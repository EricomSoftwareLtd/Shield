import argparse


def parse_command_line():
    parser = argparse.ArgumentParser(description='Append new node to swarm cluster')
    parser.add_argument('-ips', '--machines-ip', dest='ips', required=True, help="IpV4 of machines should be append. Ip separator is ','")
    return parser.parse_args()


def main():
    args = parse_command_line()


if __name__ == '__main__':
    main()