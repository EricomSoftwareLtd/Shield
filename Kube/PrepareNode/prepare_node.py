#!/usr/bin/env python3

import sys
import os
import argparse
import subprocess

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PYTHON = "{}/usr/bin/python3".format(SCRIPT_DIR)
ANSIBLE_PLAYBOOK = "{}/usr/bin/ansible-playbook".format(SCRIPT_DIR)
STTY_BIN = "/bin/stty"

parser = argparse.ArgumentParser(
    description='Prepare nodes for Ericom Shield.')
parser.add_argument('-u', '--user', metavar='USER', dest='ansible_username',
                    type=str, required=True, help='username to use to connect to a node via SSH')

parser.add_argument('node_address', metavar='address', type=str,
                    nargs='+', help='IP address or domain name of a node to configure')
args, unknown_args = parser.parse_known_args()

node_list = ",".join(args.node_address) + ','

addnode_command = [os.getenv('PYTHON', PYTHON), os.getenv('ANSIBLE_PLAYBOOK', ANSIBLE_PLAYBOOK),
                   "-i", node_list,
                   "-u", args.ansible_username,
                   "-k", "-K"]
addnode_command.extend(unknown_args)
addnode_command.append("prepare_node_playbook.yaml")

result = subprocess.run(args=addnode_command, cwd=SCRIPT_DIR)
if result.returncode != 0:
    if os.path.isfile(STTY_BIN):
        subprocess.run([STTY_BIN, 'sane'])
sys.exit(result.returncode)
