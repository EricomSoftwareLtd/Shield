import argparse
import sys
import logging


logger = logging.getLogger("parse_arguments")




# [-u|--user] ssl usename
# [-t|--token] Token to join to swarm deafult will be provide from current cluster
# [-l|--leader] leader ip
# [-c|--certificate] path to sertificate file. Should be together private and public (file name + .pub)
# [-t|--token] swarm join token 'docker swarm join-token -q worker|manager'
# [-m|--mode] Mode to join should be worker|manager default worker
# [-n|--name] Node name prefix. should be only letters. default WORKER. Final looks (NAME) + node number
# -ips|--machines-ip IPs of machines to append separated by ','
# [-b|--browser] Allow shield-browser containers to be allocated on this node
# [-sc|--shield-core] Allow shield-core containers to be allocated on this node
# [-mng|--management] Allow to shield managment container to be allocated on node"
parser = None

def parse_command_line():
    global parser
    parser = argparse.ArgumentParser(description='''
        Append new node to swarm cluster.
        When you append node keep that node goal will be applyed. 
        Set at least one of label parameters.
    ''')
    parser.add_argument('-ips', '--machines-ip', dest='ips', required=True, help="IpV4 of machines should be append. Ip separator is ','")

    parser.add_argument('-u', '--user', dest='user', default='ericom', help='User/login on remote machine/s')
    # parser.add_argument('-t', '--token', dest='token', help='Join token token to swarm cluster. By default will be provided')
    # parser.add_argument('-l', '--leader', dest='leader_ip', help='Ip of cluster leader if you run script from another machine')
    parser.add_argument('-m', '--mode', dest='mode', default='worker', help='Mode to join should be worker|manager default worker')
    parser.add_argument('-n', '--name', dest='machine_name', default='shieldNode', help='Node name prefix. should be only letters. default shieldNode. Final looks (NAME) + node number')
    parser.add_argument('-b', '--browser', dest='browser', default=False, action='store_true', help='Allow shield-browser containers to be allocated on this node. Default false')
    parser.add_argument('-sc','--shield-core', dest='shield_core', action="store_true", default=False, help="Allow shield-core containers to be allocated on this node. Default false")
    parser.add_argument('-mng', '--management', dest='management', action='store_true', default=False, help='Allow to shield managment container to be allocated on node. Default false')
    parser.add_argument('-c', '--certificate', dest='certificate', default='./shield_crt', help='Path to sertificate file. Should be together private and public (file name + .pub)')
    parser.add_argument('-s', '-session-mode', dest='session_mode', default='password', help='Remote machine session mode')
    return parser.parse_args()


def validate_parameters(args):
    global parser
    if (not args.browser) and (not args.shield_core) and (not args.management):
        parser.error('At least one of label arguments required -b/--browser | -sc/--shield-core | -mng/--management')


def make_enviroment_file(args):
    with open('.env', mode='w') as file:
        ips = ' '.join(args.ips.split(','))
        file.write("export MACHINE_IPS='{}'\n".format(ips))
        file.write("export MACHINE_USER={}\n".format(args.user))
        file.write('export MACHINE_NAME_PREFIX={}\n'.format(args.machine_name))
        file.write('export MACHINE_MODE={}\n'.format(args.mode))
        file.write('export MACHINE_CERTIFICATE={}\n'.format(args.certificate))
        file.write('export MACHINE_SESSION_MODE={}\n'.format(args.session_mode))
        if args.browser:
            file.write("export BROWSERS=yes\n")
        if args.shield_core:
            file.write('export SHIELD_CORE=yes\n')
        if args.management:
            file.write('export MANAGEMENT=yes\n')

        file.close()

def main():
    args = parse_command_line()
    validate_parameters(args)
    make_enviroment_file(args)


if __name__ == '__main__':
    main()

