#!/usr/bin/python3

import os
import sys
import subprocess
import re

es_path = "/usr/local/ericomshield"
if "ES_PATH" in os.environ:
    es_path = os.environ["ES_PATH"]

app_name = "addnodes.sh"
if "APP_NAME" in os.environ:
    app_name = os.environ["APP_NAME"]

es_versions_file = os.path.join(es_path,"shield-version.txt")
if "ES_VER_FILE" in os.environ:
    es_versions_file = os.environ['ES_VER_FILE']

es_precheck_file_path = os.path.join(es_path, "shield-pre-install-check.sh")
if "ES_PRE_CHECK_FILE" in os.environ:
    es_precheck_file_path = os.environ['ES_PRE_CHECK_FILE']

container_pattern = re.compile(r'shield-autoupdate')

run_container_template = """docker run --rm  -it \\
                  -v /var/run/docker.sock:/var/run/docker.sock \\
                  -v $(which docker):/usr/bin/docker \\
                  -v {0}:/usr/local/ericomshield \\
                  -e "ES_PRE_CHECK_FILE={1}" \\
                  -e "COMMAND={2}" \\
                  {3} {4}"""


def run_sshkey_provider(container_name):
    cmd = '''docker run --rm -it \\
                -v /var/run/docker.sock:/var/run/docker.sock \\
                -v $(which docker):/usr/bin/docker \\
                -v {0}:/usr/local/ericomshield \\
                {1} sshkey'''.format(es_path, container_name)
    subprocess.run(cmd, shell=True)

class AddNodeExecutor(object):
    """
    Run commands that connect new nodes to leader
    """

    def __init__(self, command_line):
        self.verbose = False
        self.container = AddNodeExecutor.prepare_container_name()
        self.help_required = False
        self.prepare = False
        self.cmd = self.prepare_args_line(command_line)

    def prepare_args_line(self, commands):
        main_cmd = []
        for arg in commands:
            if arg == '--verbose':
                self.verbose = True
            elif arg == "-h" or arg == "--help":
                self.help_required = True
            elif arg == "--prepare":
                self.prepare = True
            else:
                main_cmd.append(arg)
        return main_cmd

    def make_command_line(self):
        return " ".join(self.cmd)

    @staticmethod
    def prepare_container_name():
        with open(es_versions_file, mode='r') as versions:
            for line in versions.readlines():
                if container_pattern.match(line):
                    return "securebrowsing/{}".format(line.split()[1].strip())

            return "securebrowsing/shield-autoupdate:180916-13.48-2835"

    def show_container_help(self):
        cmd = run_container_template.format(es_path, es_precheck_file_path, app_name, self.container, " addnode --help")

        output = subprocess.check_output(cmd, shell=True)
        help_arr = output.decode('ASCII').split('\n')
        print('Usage {} [OPTIONS]'.format(app_name))
        print('Options:')
        print('  --verbose Switch between verbose and short output')
        print("  --prepare  Execute prepare node")
        print("\n".join(help_arr[3:]))


    def execute_add_node(self):
        args = ""
        if self.verbose:
            args += " --verbose"
        args += " addnode {}".format(" ".join(self.cmd[1:]))
        cmd = run_container_template.format(es_path, es_precheck_file_path, app_name, self.container, args)

        subprocess.run(cmd, shell=True)

    def run_node_prepare(self):
        index = -1
        if "-ips" in self.cmd:
           index = self.cmd.index('-ips')

        if "--ips" in self.cmd:
           index = self.cmd.index('--ips')

        if index > 0:
            extend_command = " prepare {}".format(" ".join(self.cmd[index:(index + 2)]))
        else:
            extend_command = ' prepare '

        if self.verbose:
            extend_command = " --verbose " + extend_command

        if "-ip" in self.cmd:
            ip_indx = [i for i, x in enumerate(self.cmd) if self.cmd[i] == '-ip']
            for index in ip_indx:
                extend_command += " ".join(self.cmd[index:(index + 2)])
                extend_command += " "
        cmd = run_container_template.format(es_path, es_precheck_file_path, app_name, self.container, extend_command)

        subprocess.run(cmd, shell=True)

    def execute(self):
        if self.help_required:
            self.show_container_help()
            exit(0)

        if not os.path.exists(os.path.join(es_path, "ericomshield_key.pub")):
            run_sshkey_provider(self.container)

        if self.prepare:
            self.run_node_prepare()
            print('Nodes prepared to be shield. Please type ericom password.')

        self.execute_add_node()



def main(args):
    executor = AddNodeExecutor(args)
    executor.execute()


if __name__ == '__main__':
    main(sys.argv)
