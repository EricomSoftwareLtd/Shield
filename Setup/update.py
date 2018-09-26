#!/usr/bin/python3

import argparse, subprocess, re, urllib3, os
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
from argparse import RawTextHelpFormatter


def parse_arguments():
    '''
        Function is main place to parse supplied parameters and switches
        This function is central place to configure update parameters script
    :param args:
    :return: arguments structure
    '''
    parser = argparse.ArgumentParser(formatter_class=RawTextHelpFormatter)
    parser.add_argument('command', choices=['sshkey', 'update'], const='update',
                    nargs='?',default='update', help="sshkey => Make ssh key to connect to swarm hosts \nupdate (default) => Update docker/shield command")
    parser.add_argument('--verbose', action="store_true", default=False, help="Switch to detailed output")
    parser.add_argument('-v', '--version', default='', help='Branch or ericomshield version tree. Default (master)')
    parser.add_argument('--autoupdate', action="store_true", default=False, help="Switch on/off autoupdate in production and staging")
    parser.add_argument('-f', '--force', action="store_true", default=False, help="Execute update even if versions is same")
    parser.add_argument('--pre-install-check', dest="precheck", action="store_true", default=False, help="Execute 'pre-installation checks' script")
    parser.add_argument('--registry', default="", help="Use registry this docker registery")
    return parser.parse_args()


def make_enviroment_variables():
    '''
    Parse repo file and create all variables contains URLs
    :return:
    '''
    with open("{}/ericomshield-repo.sh".format(os.environ['ES_PATH'])) as file:
        for line in  file:
            if 'https://' in line:
                var = line.split('=')
                os.environ[var[0]] = var[1].replace('$BRANCH', os.environ['BRANCH']).strip().replace('"','')




class UpdateExecutor():
    '''
    Main update class
    '''
    def __init__(self, args):
        self.version_data = ""
        self.force_update = args.force
        self.deatiled_output = args.verbose
        self.container = "shield-autoupdate:180916-13.48-2835"
        self.docker_upgrade = False
        self.run_sshkey = args.command == 'sshkey'
        self.version_update = True
        self.all_args = args
        self.versions_compared = False
        self.container_image_found = False
        self.docker_upgrade_checked = False

    def download_latest_version(self):
        url = os.environ['ES_repo_ver']
        try:
            http = urllib3.PoolManager()
            response = http.request('GET', url)
            self.version_data = response.data.decode('UTF-8')
        except Exception as ex:
            print(ex)
            exit(1)

        for d_line in self.version_data.split('\n'):
            if not self.versions_compared:
                self.check_if_version_changed(d_line)

            if not self.container_image_found:
                self.set_container_image(d_line)

            if not self.docker_upgrade_checked:
                self.check_docker_upgrade(d_line)


    def check_if_version_changed(self, d_line):
        if "SHIELD_VER" in d_line:
            match = re.findall("SHIELD_VER=([a-zA-Z0-9_:\.-]+)", d_line)
            cmd = 'cat {} | grep -E "SHIELD_VER=([a-zA-Z0-9_:\.-]+)" | tail -1'.format(os.environ['ES_CONFIG_FILE'])
            output = subprocess.check_output(cmd, shell=True).decode('UTF-8').strip().replace("'",'')
            second_match = re.findall("SHIELD_VER=([a-zA-Z0-9_:\.-]+)", output)

            if second_match[0] == match[1] \
                    and not self.force_update \
                    and not self.run_sshkey:
                print(' Ericom Shield repo version is {}'.format(d_line.split()[1].split('=')[1]))
                print(" Current system version is {}".format(second_match[0]))
                print(" Your EricomShield System is Up to date")
                exit(0)
            self.versions_compared = True


    def check_docker_upgrade(self, d_line):
        if 'docker-version' in d_line:
            cmd = "docker info -f '{{ .ServerVersion }}' | cut -d'-' -f1"
            output = subprocess.check_output(cmd, shell=True).decode('UTF-8').strip()
            line = d_line.split()[1]
            self.docker_upgrade = line != output
            self.docker_upgrade_checked = True


    def run_ssh_key_provider(self):
        cmd = '''docker run --rm -it \\
            -v /var/run/docker.sock:/var/run/docker.sock \\
            -v $(which docker):/usr/bin/docker \\
            -v {0}:/usr/local/ericomshield \\
            securebrowsing/{1} sshkey'''.format(os.environ['ES_PATH'], self.container)
        subprocess.run(cmd, shell=True)

    def set_container_image(self, d_line):
        if "shield-autoupdate:" in d_line:
           self.container = d_line.split()[1].strip()
           self.container_image_found = True

    def execute_shield_update(self):
        if "AUTO" in os.environ:
            output = ""
        else:
            output = "-it"

        verbose = ""
        if self.deatiled_output:
            verbose="--verbose"

        rest_args = ""

        if len(self.all_args.version) > 0:
            rest_args += " -v {}".format(self.all_args.version)
        else:
            if 'ES_BRANCH_FILE' in os.environ and os.path.exists(os.environ['ES_BRANCH_FILE']):
                with open(os.environ['ES_BRANCH_FILE']) as file:
                    rest_args += ' -v {}'.format(file.read().strip())


        if self.all_args.autoupdate:
            rest_args += ' --autoupdate'

        if self.force_update:
            rest_args += " -f"

        if self.all_args.precheck:
            rest_args += " --pre-install-check"

        if len(self.all_args.registry) > 0:
            rest_args += " --registry {}".format(self.all_args.registry)

        cmd = '''docker run --rm {0} \\
                -v /var/run/docker.sock:/var/run/docker.sock \\
                -v $(which docker):/usr/bin/docker \\
                -v /usr/local/ericomshield:/usr/local/ericomshield \\
                -e "ES_PRE_CHECK_FILE={1}" \\
                securebrowsing/{2} {3} update {4}'''\
                .format(output, os.environ['ES_PRE_CHECK_FILE'], self.container, verbose, rest_args)

        print(cmd)
        subprocess.run(cmd, shell=True)

    def execute_docker_upgrade(self):
        pass

    def save_current_update_data(self):
        pass

    def run_update(self):
        self.download_latest_version()
        if self.run_sshkey:
            self.run_ssh_key_provider()
            exit()

        if self.docker_upgrade or self.force_update:
            self.execute_docker_upgrade()

        self.execute_shield_update()

    def check_sshkey_exists(self):
        pass

def main():
    arguments = parse_arguments()
    make_enviroment_variables()
    executor = UpdateExecutor(arguments)
    executor.run_update()



if __name__ == '__main__':
    main()