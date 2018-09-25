#!/usr/bin/python3

import argparse, subprocess, sys, urllib, os


def parse_arguments(args):
    '''
        Function is main place to parse supplied parameters and switches
        This function is central place to configure update parameters script
    :param args:
    :return: arguments structure
    '''
    parser = argparse.ArgumentParser()
    return parser.parse_args(args)


class UpdateExecutor():
    def __init__(self, args):
        pass
        #self.args = parse_arguments(args)


    def download_latest_version(self):
        url = os.environ['ES_repo_ver']
        print(url)





def main(args):
    executor = UpdateExecutor(args)
    executor.download_latest_version()


if __name__ == '__main__':
    main(sys.argv)