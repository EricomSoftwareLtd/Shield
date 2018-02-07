import paramiko
from paramiko import SSHClient
from paramiko import SFTPClient
import logging
import sys
import subprocess
import os
import time
import tarfile
import glob

logger = logging.getLogger("prepare_machine")

client = SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())


ericom_shield_setup_script = \
        'https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/{}/Setup/ericomshield-setup.sh' \
        .format(os.environ["ERICOM_SETUP_BRANCH"])

ericom_shield_install_dir = '/install'

add_machine_max_attempts = 5
if "ADD_MAX_ATTEMPTS" in os.environ:
    add_machine_max_attempts = int(os.environ["ADD_MAX_ATTEMPTS"])


def run_command_and_return_output(cmd):
    _, stdout, stderr = client.exec_command(cmd)
    err = None
    output = None
    if stdout.channel.recv_exit_status() == 0:
        output = stdout.read().decode("ascii")
    else:
        err = stderr.read().decode("ascii")

    return err, output


def get_docker_join_command():
    output = subprocess.check_output('docker swarm join-token {} | grep join'.format(os.environ['MACHINE_MODE']), shell=True)
    return output.strip().decode('ascii')

def join_to_cluster():
    join_command = ''
    try:
        join_command = get_docker_join_command()
    except Exception as ex:
        logger.error(ex)

def test_docker_on_machine():
    stdin, stdout, stderr = client.exec_command('sudo docker version')
    err_lines = stderr.readlines()
    out_lines = stdout.readlines()
    if err_lines and len(err_lines) > 0 and ('command not found' in err_lines[-1]):
        return False
    #Apply check docker version
    return True

def test_shield_already_installed():
    err, out = run_command_and_return_output('sudo ls -al /usr/local/ericomshield | grep ericomshield-repo')
    if not err is None:
        if "No such file or directory" in err:
            return False
    #need to analyze more ls output
    return True

def install_docker():
    transport = client.get_transport()
    sftp_client = SFTPClient.from_transport(transport)
    sftp_client.put(os.path.abspath('./install-docker.sh'), '/home/{}/install-docker.sh'.format(os.environ['MACHINE_USER']))
    sftp_client.close()
    running = True
    channel = client.get_transport().open_session()
    channel.exec_command('chmod +x install-docker.sh && sudo ./install-docker.sh && rm -f ./install-docker.sh')
    print('Install docker please wait...', end='')
    while running:
        sys.stdout.write('.')
        sys.stdout.flush()
        time.sleep(1)
        if channel.exit_status_ready():
            print(' ')
            if channel.recv_exit_status() == 0:
                print("Docker installed")
            else:
                print("Docker installation failed")
            running = False


    if test_docker_on_machine():
        logger.info("Docker installation success")
    else:
        logger.error("Docker installation failed")
        sys.exit(1)

def check_dev_version():
    return os.path.isfile('/install/.esdev')

def check_staging_version():
    return os.path.isfile('/install/.esstaging')

def run_ericom_shield_setup():
    err, out = run_command_and_return_output('wget -O ericomshield-setup.sh {}'.format(ericom_shield_setup_script))
    if not err is None:
        print(err)
        sys.exit(1)
    err, out = run_command_and_return_output('chmod +x ./ericomshield-setup.sh')
    if not err is None:
        print(err)
        sys.exit(1)

    add_switch = ''
    if check_dev_version():
        add_switch = '-dev'

    if check_staging_version():
        add_switch = '-staging'

    _, stdout, stderr = client.exec_command("export BRANCH=\"{0}\" && sudo -E bash -c './ericomshield-setup.sh -no-deploy {1}'".format(os.environ["ERICOM_SETUP_BRANCH"], add_switch))
    while not stdout.channel.exit_status_ready():
        one_line = ''
        if stdout.channel.recv_ready():
            one_line = stdout.channel.recv(2048).decode("ascii")
            sys.stdout.write(one_line)
            sys.stdout.flush()


def apply_ericomshield_version():
    with tarfile.open('./system.tar.gz'.format(ericom_shield_install_dir), mode='w:gz') as tar:
        for file in glob.glob("{}/*".format(ericom_shield_install_dir)):
            tar.add(file)
        for file in glob.glob('{}/.*'.format(ericom_shield_install_dir)):
            if not '.es_ip_address' in file:
                tar.add(file)

    transport = client.get_transport()
    sftp_client = SFTPClient.from_transport(transport)
    sftp_client.put('./system.tar.gz'.format(ericom_shield_install_dir), '/home/{}/system.tar.gz'.format(os.environ['MACHINE_USER']))
    sftp_client.close()
    _, stdout, stderr = client.exec_command("tar xfz ./system.tar.gz && sudo rsync -avh ./usr/local/ericomshield/ /usr/local/ericomshield/ && rm -rf ./usr ./system.tar.gz")
    while not stdout.channel.exit_status_ready():
        one_line = ''
        if stdout.channel.recv_ready():
            one_line = stdout.channel.recv(2048).decode("ascii")
            sys.stdout.write(one_line)
            sys.stdout.flush()

    output = subprocess.check_output('rm -f ./system.tar.gz'.format(ericom_shield_install_dir), shell=True)

def get_swarm_node_name(data):
    if '*' in data:
        return data[2]
    else:
        return data[1]

def get_managers_ip_and_name():
    output = subprocess.check_output('docker node ls', shell=True).decode('ascii').split('\n')
    return_data = []
    for line in output:
        data = line.split()
        if ('Leader' in line) or ('Reachable' in line):
            extract_name_and_ip(get_swarm_node_name(data), return_data)

    return return_data

def extract_name_and_ip(name, return_data):
    swarm_node = subprocess.check_output('docker node inspect --pretty {} | grep Address'.format(name),
                                         shell=True).decode('ascii').split('\n')
    node_ip = swarm_node[0].split()[1]
    return_data.append('{0}\t{1}'.format(node_ip, name))


def prepare_machine_to_docker_node(ip):
    _, stdout, _ = client.exec_command('hostname')
    hostname = (stdout.read()).decode('ascii').replace('\n', '')
    with open('hosts', mode='w') as file:
        file.write("{0}\t{1}\n".format(ip, hostname))
        for manager in get_managers_ip_and_name():
            file.write('{}\n'.format(manager))
        file.close()

    transport = client.get_transport()
    sftp_client = SFTPClient.from_transport(transport)
    # sftp_client.put(os.path.abspath('./hosts'),'/home/{}/hosts'.format(os.environ['MACHINE_USER']))
    # stdin, stdout, stderr = client.exec_command('cat ./hosts | sudo tee -a /etc/hosts && rm -f ./hosts')
    # stdout.channel.recv_exit_status()
    # logger.error(stderr.read())
    sftp_client.put(os.path.abspath('./sysctl_shield.conf'),'/home/{}/sysctl_shield.conf'.format(os.environ['MACHINE_USER']))
    sftp_client.put(os.path.abspath('./mount-tmpfs-volume.sh'), '/home/{}/mount-tmpfs-volume.sh'.format(os.environ['MACHINE_USER']))
    sftp_client.close()
    stdin, stdout, stderr = client.exec_command('chmod +x ./mount-tmpfs-volume.sh && sudo ./mount-tmpfs-volume.sh && rm -f ./mount-tmpfs-volume.sh')
    stdout.channel.recv_exit_status()
    logger.error(stderr.read())

    stdin, stdout, stderr = client.exec_command('cat ./sysctl_shield.conf | sudo tee "/etc/sysctl.d/30-ericom-shield.conf"; sudo sysctl --load="/etc/sysctl.d/30-ericom-shield.conf"')
    stdout.channel.recv_exit_status()
    logger.error(stderr.read())
    return hostname



def make_cert_pass():
    if 'CERTIFICATE_PASS' in os.environ:
        return os.environ['CERTIFICATE_PASS']
    else:
        return ''


def run_with_password(ip):
    global client
    client.connect(ip, look_for_keys=False, username=os.environ['MACHINE_USER'], password=os.environ['MACHINE_USER_PASS'])

def run_certificate_mode(ip):
    global client
    key = paramiko.RSAKey.from_private_key_file(filename=os.environ['MACHINE_CERTIFICATE'], password=make_cert_pass())
    client.connect(ip, username=os.environ['MACHINE_USER'], pkey=key)
    pass

def format_labels_command(hostname):
    res = ''
    if 'BROWSERS' in os.environ:
        res += "--label-add browser=yes"
    if 'SHIELD_CORE' in os.environ:
        res += ' --label-add shield_core=yes'
    if 'MANAGEMENT' in os.environ:
        res += ' --label-add management=yes'

    return 'docker node update {0} {1}'.format(res, hostname)

def run_consul_reshafle_command():
    '''
    We not use this function until consul is global
    :return:
    '''
    try:
        output = subprocess.check_output('docker service update --force --replicas 5 shield_consul-server', shell=True)
    except Exception as ex:
        print("Error: {}".format(ex))
        return
    print(output)

def run_join_to_swarm(command, ip):
    counter = 0
    while True:
        try:
            if os.environ['MACHINE_SESSION_MODE'] == 'password':
                run_with_password(ip)
            else:
                run_certificate_mode(ip)

            hostname = prepare_machine_to_docker_node(ip)
            if not test_shield_already_installed():
                run_ericom_shield_setup()
                apply_ericomshield_version()
            else:
                logger.info("Ericomshield already installed")

            err, out = run_command_and_return_output("sudo {}".format(command))
            if not err is None:
                logger.error(err)
            else:
                logger.info(out)

            try:
                output = subprocess.run(format_labels_command(hostname), shell=True, check=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
                logger.info(output.stdout)
                break
            except subprocess.CalledProcessError as e:
                if "ambiguous" in e.stderr.decode("ascii"):
                    logger.error(e.stderr)
                    exit(121)
        except paramiko.ssh_exception.NoValidConnectionsError as ex:
            logger.error(ex.args[1])
            exit(122)
        except Exception as ex:
            logger.error(ex)
            logger.error("Attempt {} failed will try more one time".format(counter))

        counter += 1
        if counter >= add_machine_max_attempts:
            logger.error("Max retries exceeded stop execution")
            exit(120)


def main(args):
    if len(args) <= 0:
        logger.error('No machine IP is sended')
        sys.exit(1)

    join_command = None
    try:
        join_command = get_docker_join_command()
    except Exception as ex:
        logger.error(ex)
        sys.exit(1)

    if not join_command is None:
        run_join_to_swarm(join_command, args[1])
        client.close()


if __name__ == '__main__':
    main(sys.argv)