#!/usr/bin/env python3

import sys
import os
import argparse
import subprocess

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PYTHON = "{}/usr/bin/python3".format(SCRIPT_DIR)
ANSIBLE_PLAYBOOK = "{}/usr/bin/ansible-playbook".format(SCRIPT_DIR)

parser = argparse.ArgumentParser(
    description='Prepare nodes for Ericom Shield.')
parser.add_argument('-u', '--user', metavar='USER', dest='ansible_username',
                    type=str, required=True, help='username to use to connect to a node via SSH')

parser.add_argument('--offline-registry', metavar='OFFLINE_REGISTRY', dest='offline_registry',
                    type=str, required=False, help='IP address and port of the Offline Registry <address:port>')

parser.add_argument('node_address', metavar='address', type=str,
                    nargs='+', help='IP address or domain name of a node to configure')
args, unknown_args = parser.parse_known_args()

node_list = ",".join(args.node_address) + ','

extra_vars = []
if args.offline_registry:
    extra_vars.append("offline_registry_address={0}".format(args.offline_registry))

addnode_command = [os.getenv('PYTHON', PYTHON), os.getenv('ANSIBLE_PLAYBOOK', ANSIBLE_PLAYBOOK),
                   "-i", node_list,
                   "-u", args.ansible_username,
                   "-k", "-K"
                   ]
if extra_vars:
    addnode_command.append("--extra-vars")
    addnode_command.append(" ".join(extra_vars))

addnode_command.extend(unknown_args)
addnode_command.append("{}/ansible_playbooks/es_nodes.yaml".format(SCRIPT_DIR))

result = subprocess.run(args=addnode_command)  # , cwd=SCRIPT_DIR)
sys.exit(result.returncode)
