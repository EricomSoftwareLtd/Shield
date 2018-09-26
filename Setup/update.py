#!/usr/bin/python3

import argparse, subprocess, sys, urllib3, os
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
from argparse import RawTextHelpFormatter


def parse_arguments(args):
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
    parser.add_argument('-v', '--version', default='master', help='Branch or ericomshield version tree. Default (master)')
    parser.add_argument('--autoupdate', action="store_true", default=False, help="Switch on/off autoupdate in production and staging")
    parser.add_argument('-f', '--force', action="store_true", default=False, help="Execute update even if versions is same")
    parser.add_argument('--pre-install-check', dest="precheck", action="store_true", default=False, help="Execute 'pre-installation checks' script")
    parser.add_argument('--registry', default="", help="Use registry this docker registery")
    return parser.parse_args()


def make_enviroment_variables():
    global ES_CONFIG_FILE
    with open("{}/ericomshield-repo.sh".format(os.environ['ES_PATH'])) as file:
        for line in  file:
            if 'https://' in line:
                var = line.split('=')
                os.environ[var[0]] = var[1].replace('$BRANCH', os.environ['BRANCH']).strip().replace('"','')




class UpdateExecutor():
    def __init__(self, args):
        self.version_data = None
        self.force_update = False
        self.deatiled_output = args.verbose
        self.container = "shield-autoupdate:180916-13.48-2835"
        self.docker_upgrade = False
        self.run_sshkey = args.command == 'sshkey'
        self.version_update = True

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
            self.check_if_version_changed(d_line)
            self.set_container_image(d_line)
            self.check_docker_upgrade(d_line)

    def check_if_version_changed(self, d_line):
        if "SHIELD_VER" in d_line:
            cmd = 'cat {} | grep SHIELD_VER | tail -1'.format(os.environ['ES_CONFIG_FILE'])
            output = subprocess.check_output(cmd, shell=True).decode('UTF-8').strip().replace("'",'')
            arr = output.split('=')
            if len(arr) > 1:
                output = arr[1]

            if output in d_line and not self.force_update and not self.run_sshkey:
                print(' Ericom Shield repo version is {}'.format(d_line.split()[1].split('=')[1]))
                print(" Current system version is {}".format(output))
                print(" Your EricomShield System is Up to date")
                exit(0)


    def check_docker_upgrade(self, d_line):
        if 'docker-version' in d_line:
            cmd = "docker info -f '{{ .ServerVersion }}' | cut -d'-' -f1"
            output = subprocess.check_output(cmd, shell=True).decode('UTF-8').strip()
            line = d_line.split()[1]
            self.docker_upgrade = line != output


    def run_ssh_key_provider(self):
        cmd = '''docker run --rm -it \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(which docker):/usr/bin/docker \
            -v {0}:/usr/local/ericomshield \
            "securebrowsing/{1} sshkey"
        '''.format(os.environ['ES_PATH'], self.container)
        print(cmd)
        subprocess.run(cmd, shell=True)

    def set_container_image(self, d_line):
        if "shield-autoupdate:" in d_line:
           self.container = d_line.split()[1].strip()

    def run_update(self):
        self.download_latest_version()
        if self.run_sshkey:
            self.run_ssh_key_provider()



def main(args):
    arguments = parse_arguments(args)
    make_enviroment_variables()
    executor = UpdateExecutor(arguments)
    executor.run_update()



if __name__ == '__main__':
    main(sys.argv)