import paramiko
from paramiko import SSHClient
from paramiko import SFTPClient
import logging
import sys
import subprocess
import os
import time


logger = logging.getLogger("prepare_machine")

client = SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

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
    with open('hostname', mode='w') as file:
        file.write(os.environ['REMOTE_HOST_NAME'])
        file.close()

    with open('hosts', mode='w') as file:
        #file.write('127.0.0.1\tlocalhost\n')
        #file.write('127.0.1.1\t{}\n'.format(os.environ['REMOTE_HOST_NAME']))
        file.write("{0}\t{1}\n".format(ip, os.environ['REMOTE_HOST_NAME']))
        for manager in get_managers_ip_and_name():
            file.write('{}\n'.format(manager))
        file.close()

    transport = client.get_transport()
    sftp_client = SFTPClient.from_transport(transport)
    sftp_client.put(os.path.abspath('./hostname'),
                    '/home/{}/hostname'.format(os.environ['MACHINE_USER']))
    sftp_client.put(os.path.abspath('./hosts'),
                    '/home/{}/hosts'.format(os.environ['MACHINE_USER']))
    sftp_client.put(os.path.abspath('./mount-tmpfs-volume.sh'), '/home/{}/mount-tmpfs-volume.sh'.format(os.environ['MACHINE_USER']))
    sftp_client.close()
    stdin, stdout, stderr = client.exec_command('sudo mv ./hostname /etc/hostname')
    stdout.channel.recv_exit_status()
    logger.error(stderr.readlines())
    stdin, stdout, stderr = client.exec_command('sudo hostname {}'.format(os.environ['REMOTE_HOST_NAME']))
    stdout.channel.recv_exit_status()
    logger.error(stderr.readlines())
    stdin, stdout, stderr = client.exec_command('cat ./hosts | sudo tee -a /etc/hosts && rm -f ./hosts')
    stdout.channel.recv_exit_status()
    logger.error(stderr.readlines())

    stdin, stdout, stderr = client.exec_command('chmod +x ./mount-tmpfs-volume.sh && sudo ./mount-tmpfs-volume.sh && rm -f ./mount-tmpfs-volume.sh')
    stdout.channel.recv_exit_status()
    logger.error(stderr.readlines())




def run_with_password(ip):
    global client
    client.connect(ip, look_for_keys=False, username=os.environ['MACHINE_USER'], password=os.environ['MACHINE_USER_PASS'])

def format_labels_command():
    res = ''
    if 'BROWSERS' in os.environ:
        res += "--label-add browser=yes"
    if 'SHIELD_CORE' in os.environ:
        res += ' --label-add shield_core=yes'
    if 'MANAGEMENT' in os.environ:
        res += ' --label-add management=yes'

    return 'docker node update {0} {1}'.format(res, os.environ['REMOTE_HOST_NAME'])


def run_join_to_swarm(command, ip):
    if os.environ['MACHINE_SESSION_MODE'] == 'password':
        run_with_password(ip)

    prepare_machine_to_docker_node(ip)
    if not test_docker_on_machine():
        install_docker()
    else:
        logger.info("Found suitable docker version")

    stdin, stdout, stderr = client.exec_command("sudo {}".format(command))
    stdout.channel.recv_exit_status()
    logger.error(stderr.readlines())
    logger.info(stdout.readlines())

    output = subprocess.check_output(format_labels_command(), shell=True)
    logger.info(output)







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