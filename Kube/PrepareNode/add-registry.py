#!/usr/bin/env python3

import yaml
import sys
import argparse


def add_in_subsection(reg, subsection):
    for i in subsection:
        subsection[i] = "{0}/{1}".format(reg, subsection[i])


def add_in_subsection_elk(reg, subsection):
    subsection['image'] = "{0}/{1}".format(reg, subsection['image'])


def add_in_subsection_consul(reg, subsection):
    subsection['repository'] = "{0}/{1}".format(
        subsection['registry'], subsection['repository'])
    subsection['registry'] = reg


parser = argparse.ArgumentParser(
    description='Add Private Repository address to custom values YAML.')
parser.add_argument('repo', type=str,
                    nargs=1, help='IP address and port of the Private Repository <address:port>')
parser.add_argument('shield_yaml_name', type=str,
                    nargs=1, help='Shield custom values YAML file')
parser.add_argument('consul_yaml_name', type=str,
                    nargs='?', help='Consul custom values YAML file')

args = parser.parse_args()

repo = args.repo[0]
shield_yaml_name = args.shield_yaml_name[0]
consul_yaml_name = args.consul_yaml_name

with open(shield_yaml_name, 'r') as shield_values:
    try:
        shield_yaml_dic = yaml.safe_load(shield_values)
        shield_values.close()

        consul_yaml_dic = None
        if consul_yaml_name:
            with open(consul_yaml_name, 'r') as consul_values:
                consul_yaml_dic = yaml.safe_load(consul_values)
                consul_values.close()

        add_in_subsection(repo, shield_yaml_dic['shield-mng']['images'])
        add_in_subsection(repo, shield_yaml_dic['shield-proxy']['images'])
        add_in_subsection(repo, shield_yaml_dic['farm-services']['images'])
        add_in_subsection(
            repo, shield_yaml_dic['elk']['management']['images'])
        add_in_subsection(
            repo, shield_yaml_dic['common']['fluent-bit-out-syslog']['images'])

        add_in_subsection_elk(repo, shield_yaml_dic['elk']['elasticsearch'])
        add_in_subsection_elk(repo, shield_yaml_dic['elk']['kibana'])

        with open(shield_yaml_name, "w") as out_shield_yaml_dic:
            yaml.dump(shield_yaml_dic, out_shield_yaml_dic)

        if consul_yaml_dic:
            add_in_subsection_consul(repo, consul_yaml_dic['image'])
            add_in_subsection_consul(repo, consul_yaml_dic['metrics']['image'])
            add_in_subsection_consul(
                repo, consul_yaml_dic['volumePermissions']['image'])
            with open(consul_yaml_name, "w") as out_consul_yaml_dic:
                yaml.dump(consul_yaml_dic, out_consul_yaml_dic)

    except yaml.YAMLError as exc:
        print(exc)
