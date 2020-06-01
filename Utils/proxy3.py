#!/usr/bin/python3

from io import open

import getpass  # for taking password input
import shutil  # for copying file
import sys
import os
import subprocess
from os import getuid
import urllib.request, urllib.error, urllib.parse
import urllib.request, urllib.parse, urllib.error
import urllib.parse

"""
created by :
Nityananda Gohain
School of Engineering, Tezpur University
27/10/17
Modified by Ericom for Ericom Shield
"""
"""
Three files will be modified
1) /etc/apt/apt.conf
2) /etc/environment
3) /etc/bash.bashrc
4) /etc/systemd/system/docker.service.d/http-proxy.conf
"""

# run it as sudo
if getuid() != 0:
    print("Please run this program as Super user(sudo)\n")
    sys.exit()

APT_ = r'/etc/apt/apt.conf'
APT_BACKUP = r'./.backup_proxy/apt.txt'
YUM_ = r'/etc/yum.conf'
YUM_BACKUP = r'./.backup_proxy/yum.txt'
BASH_ = r'/etc/bash.bashrc'
if not os.path.exists(BASH_):
    BASH_ = r'/etc/bashrc'
BASH_BACKUP = r'./.backup_proxy/bash.txt'
ENV_ = r'/etc/environment'
ENV_BACKUP = r'./.backup_proxy/env.txt'
DOCKER_ = r'/etc/systemd/system/docker.service.d/http-proxy.conf'
DOCKER_BACKUP = r'./.backup_proxy/docker.txt'
DOCKER_SERVICE_DIR = r'/etc/systemd/system/docker.service.d'
DOCKER_SERVICE_UNIT = r'/etc/systemd/system/multi-user.target.wants/docker.service'
REDHAT_RELEASE_FILE = r'/etc/redhat-release'
RESTORE_SCRIPT = r'/etc/bash.restore'


# This function directly writes to the apt.conf file
# Fist deletes the lines containning ::proxy
def writeToApt(proxy, port, username, password, flag):
    # find and delete line containing ::proxy
    if os.path.exists(APT_):
        with open(APT_, "r+") as filepointer:
            lines = filepointer.readlines()
            filepointer.seek(0)
            for line in lines:
                if r"::proxy" not in line:
                    filepointer.write(line)
            filepointer.truncate()

    # writing starts
    if not flag:
        with open(APT_, "a") as filepointer:
            filepointer.write('Acquire::http::proxy "{}";\n'.format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write('Acquire::https::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write('Acquire::ftp::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write('Acquire::socks::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'socks')))

    # if apt.conf is NULL, delete the file
    if os.path.exists(APT_):
        if os.path.getsize(APT_) == 0:
            os.remove(APT_)


# This function directly writes to the yum.conf file
# Fist deletes the lines containning proxy=
def writeToYum(proxy, port, username, password, flag):
    # find and delete line containing proxy=
    if os.path.exists(YUM_):
        with open(YUM_, "r+") as filepointer:
            lines = filepointer.readlines()
            filepointer.seek(0)
            for line in lines:
                if r"proxy=" not in line:
                    filepointer.write(line)
            filepointer.truncate()

    # writing starts
    if not flag:
        with open(YUM_, "a") as filepointer:
            filepointer.write('proxy=http://{}:{}\n'.format(proxy, port))
            if username:
                filepointer.write('proxy_username={}\n'.format(username))
                filepointer.write('proxy_password={}\n'.format(password))


# This function writes to the environment file
# Fist deletes the lines containng _proxy=, _PROXY=
def writeToEnv(proxy, port, username, password, exceptions, flag):
    # find and delete line containing _proxy=, _PROXY=
    if os.path.exists(ENV_):
        with open(ENV_, "r+") as filepointer:
            lines = filepointer.readlines()
            filepointer.seek(0)
            for line in lines:
                if r"_proxy=" not in line and r"_PROXY=" not in line:
                    filepointer.write(line)
            filepointer.truncate()

    # writing starts
    if not flag:
        with open(ENV_, "a") as filepointer:
            filepointer.write("http_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("https_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("ftp_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("socks_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'socks')))
            filepointer.write("HTTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("HTTPS_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("FTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("SOCKS_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'socks')))
            if exceptions:
                filepointer.write("no_proxy='{}'\n".format(exceptions))
                filepointer.write("NO_PROXY='{}'\n".format(exceptions))


# This function will write to the bashcr file
# Fist deletes the lines containng _proxy=, _PROXY=
def writeToBashrc(proxy, port, username, password, exceptions, flag):
    # find and delete _proxy=, _PROXY=
    if os.path.exists(BASH_):
        with open(BASH_, "r+") as filepointer:
            lines = filepointer.readlines()
            filepointer.seek(0)
            for line in lines:
                if r"_proxy=" not in line and r"_PROXY=" not in line:
                    filepointer.write(line)
            filepointer.truncate()

    # writing starts
    if not flag:
        with open(BASH_, "a") as filepointer:
            filepointer.write("export http_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("export https_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("export ftp_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("export socks_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'socks')))
            filepointer.write("export HTTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("export HTTPS_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("export FTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("export SOCKS_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'socks')))
            if exceptions:
                filepointer.write("export no_proxy='{}'\n".format(exceptions))
                filepointer.write("export NO_PROXY='{}'\n".format(exceptions))


# This function will write to the bashcr file
# Fist deletes the file
def writeDockerServiceConfig(proxy, port, username, password, exceptions, flag):
    if os.path.exists(DOCKER_):
        os.remove(DOCKER_)

    if not os.path.exists(DOCKER_SERVICE_DIR):
        os.makedirs(DOCKER_SERVICE_DIR)

    # writing starts
    if not flag:
        with open(DOCKER_, "w") as filepointer:
            filepointer.write("[Service]\n")
            http_url = make_proxy_url_string(proxy, port, username, password)
            https_url = make_proxy_url_string(proxy, port, username, password, 'https')
            conf_str = 'Environment="HTTP_PROXY={0}" "HTTPS_PROXY={1}"'.format(http_url, https_url)
            if exceptions:
                conf_str += ' "NO_PROXY={}"\n'.format(exceptions)
            else:
                conf_str += '\n'
            filepointer.write(conf_str)

    # If docker is installed, restart the service.
    if os.path.islink(DOCKER_SERVICE_UNIT):
        print("reload and restart docker....")
        subprocess.run("systemctl daemon-reload", shell=True)
        subprocess.run("systemctl restart docker", shell=True)


def set_proxy(flag):
    proxy, port, username, password, exceptions = "", "", "", "", ""
    if not flag:
        proxy = input("Enter proxy : ")
        port = input("Enter port : ")
        exceptions = input("Enter IPs separated by ',' for direct access : ")
        username = input("Enter username (if you need) : ")
        password = getpass.getpass("Enter password (if you need) : ")

        if username == '':
            username = None

        if password == '':
            password = None

    if not os.path.isfile(REDHAT_RELEASE_FILE):
        writeToApt(proxy, port, username, password, flag)
    else:
        writeToYum(proxy, port, username, password, flag)

    writeToEnv(proxy, port, username, password, exceptions, flag)
    writeToBashrc(proxy, port, username, password, exceptions, flag)
    writeDockerServiceConfig(proxy, port, username, password, exceptions, flag)


def make_proxy_url_string(proxy, port, username=None, password=None, protocol='http'):
    if username and password:
        return "http://{0}:{1}@{2}:{3}".format(urllib.parse.quote_plus(username), urllib.parse.quote_plus(password), proxy, port)
    else:
        return "http://{0}:{1}".format(proxy, port)


def restore_default():
    if os.path.isdir("./.backup_proxy"):
        # copy from backup to main
        if os.path.exists(APT_BACKUP):
            shutil.copy2(APT_BACKUP, APT_)
        else:
            if os.path.exists(APT_):
                os.remove(APT_)
        if os.path.exists(ENV_BACLUP):
            shutil.copy2(ENV_BACLUP, ENV_)
        if os.path.exists(BASH_BACKUP):
            shutil.copy2(BASH_BACKUP, BASH_)
        if os.path.exists(DOCKER_BACKUP):
            shutil.copy2(DOCKER_BACKUP, DOCKER_)
        else:
            if os.path.exists(DOCKER_):
                os.remove(DOCKER_)
        if os.path.islink(DOCKER_SERVICE_UNIT):
            print("reload and restart docker....")
            subprocess.run("systemctl daemon-reload", shell=True)
            subprocess.run("systemctl restart docker", shell=True)
    else:
        print("No backup data...")
        sys.exit()


def backup_default():
    # create backup     if not present
    if not os.path.isdir("./.backup_proxy"):
        os.makedirs("./.backup_proxy")
        if os.path.exists(APT_):
            shutil.copy2(APT_, APT_BACKUP)
        if os.path.exists(ENV_):
            shutil.copy2(ENV_, ENV_BACKUP)
        if os.path.exists(BASH_):
            shutil.copy2(BASH_, BASH_BACKUP)
        if os.path.exists(DOCKER_):
            shutil.copy2(DOCKER_, DOCKER_BACKUP)


def ref_env():
    # Generate a script that reflects environment variables with shell currently in use
    with open(RESTORE_SCRIPT, "w") as filepointer:
        filepointer.write('#!/bin/bash\n')
        filepointer.write('\n')
        filepointer.write('# Once all delet\n')
        filepointer.write('unset http_proxy\n')
        filepointer.write('unset https_proxy\n')
        filepointer.write('unset ftp_proxy\n')
        filepointer.write('unset socks_proxy\n')
        filepointer.write('unset no_proxy\n')
        filepointer.write('unset HTTP_PROXY\n')
        filepointer.write('unset HTTPS_PROXY\n')
        filepointer.write('unset FTP_PROXY\n')
        filepointer.write('unset SOCKS_PROXY\n')
        filepointer.write('unset NO_PROXY\n')
        filepointer.write('\n')
        filepointer.write('# If it exists, reset the existing definition of env.\n')
        with open(ENV_, "r") as filepointer2:
            lines = filepointer2.readlines()
            for line in lines:
                if r"_proxy=" in line or r"_PROXY=" in line:
                    filepointer.write('export {}\n'.format(line))
        filepointer.write('\n')
        filepointer.write('# Re-execute bashrc to reflect the existing settings, if exists.\n')
        filepointer.write('source {}\n'.format(BASH_))


def end_message(flag):
    if not flag:
        print("DONE!")
        print(("Please run the command '$ source {}'.".format(BASH_)))
    else:
        print("DONE!")
        print("Please run the command '$ source /etc/bash.restore'.")


if __name__ == "__main__":

    # choice
    print("----------------------------------------------------------------------------------------------------------------------")
    print(" If the './.backup_proxy' directory does not exist, the settings before execution are automatically saved as a backup.")
    print(" If the directory exists, it will not overwrite the backup.")
    print("----------------------------------------------------------------------------------------------------------------------")
    print("1:) Set Proxy")
    print("2:) Remove Proxy")
    print("3:) Restore Backup file")
    print("4:) Exit")
    choice = int(input("\nchoice (1/2/3/4) : "))

    if (choice == 1):
        backup_default()
        set_proxy(flag=0)
        end_message(flag=0)
    elif (choice == 2):
        backup_default()
        set_proxy(flag=1)
        ref_env()
        end_message(flag=1)
    elif (choice == 3):
        restore_default()
        ref_env()
        end_message(flag=1)
    else:
        sys.exit()
