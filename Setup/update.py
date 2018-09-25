#!/usr/bin/python3

import argparse, subprocess, sys, urllib3, os
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def parse_arguments(args):
    '''
        Function is main place to parse supplied parameters and switches
        This function is central place to configure update parameters script
    :param args:
    :return: arguments structure
    '''
    parser = argparse.ArgumentParser()
    return parser.parse_args(args)


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
        #self.args = parse_arguments(args)


    def download_latest_version(self):
        url = os.environ['ES_repo_ver']
        try:
            http = urllib3.PoolManager()
            response = http.request('GET', url)
            self.version_data = response.data.decode('UTF-8')
        except Exception as ex:
            print(ex)

    def check_if_version_changed(self):
        for d_line in self.version_data.split('\n'):
            if "SHIELD_VER" in d_line:
                cmd = 'cat {} | grep SHIELD_VER | tail -1'.format(os.environ['ES_CONFIG_FILE'])
                output = subprocess.check_output(cmd, shell=True).decode('UTF-8').strip().replace("'",'')
                arr = output.split('=')
                if len(arr) > 1:
                    output = arr[1]
                else:
                    break

                if output in d_line and not self.force_update:
                    print(' Ericom Shield repo version is {}'.format(d_line.split()[1].split('=')[1]))
                    print(" Current system version is {}".format(output))
                    print(" Your EricomShield System is Up to date")
                    exit(0)
                else:
                    break

    def check_docker_upgrade(self):
        for d_line in self.version_data.split('\n'):
            if 'docker-version' in d_line:
                cmd = "docker info -f '{{ .ServerVersion }}' | cut -d'-' -f1"
                output = subprocess.check_output(cmd, shell=True).decode('UTF-8').strip()
                line = d_line.split()[1]
                if line != output:
                    pass #do upgrade






def main(args):
    make_enviroment_variables()
    executor = UpdateExecutor(args)
    executor.download_latest_version()
    executor.check_if_version_changed()
    executor.check_docker_upgrade()


if __name__ == '__main__':
    main(sys.argv)