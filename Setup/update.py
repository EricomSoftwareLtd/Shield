#!/usr/bin/python3

import argparse, subprocess, sys



class UpdateExecutor():
    def __init__(self, args):
        self.args = UpdateExecutor.parse_arguments(args)

    @staticmethod
    def parse_arguments(args):
        parser = argparse.ArgumentParser()
        return parser.parse_args(args)




def main(args):
    pass


if __name__ == '__main__':
    main(sys.argv)