#!/usr/bin/python3

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

# This files takes the location as input and writes the proxy authentication

import getpass  # for taking password input
import shutil  # for copying file
import sys
import os.path  # for checking if file is present or not
import subprocess
from os import getuid
import urllib.parse
import re

# run it as sudo
if getuid() != 0:
    print("Please run this program as Super user(sudo)\n")
    sys.exit()

APT_ = r'/etc/apt/apt.conf'
APT_BACKUP = r'./.backup_proxy/apt.txt'
YUM_ = r'/etc/yum.conf'
YUM_BACKUP = r'./.backup_proxy/yum.txt'
BASH_ = r'/etc/bash.bashrc'
if not os.path.isfile(BASH_):
    BASH_ = r'/etc/bashrc'
BASH_BACKUP = r'./.backup_proxy/bash.txt'
ENV_ = r'/etc/environment'
ENV_BACKUP = r'./.backup_proxy/env.txt'
DOCKER_ = r'/etc/systemd/system/docker.service.d/http-proxy.conf'
DOCKER_BACKUP = r'./.backup_proxy/docker.txt'
DOCKER_SERVICE_DIR = '/etc/systemd/system/docker.service.d'
DOCKER_SERVICE_UNIT = '/etc/systemd/system/multi-user.target.wants/docker.service'
REDHAT_RELEASE_FILE = '/etc/redhat-release'

# This function directly writes to the apt.conf file
def writeToApt(proxy, port, username, password, flag):
    with open(APT_, "w") as filepointer:
        if not flag:
            filepointer.write('Acquire::http::proxy "{}";\n'.format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write('Acquire::https::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write('Acquire::ftp::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write('Acquire::socks::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'socks')))

# This function directly writes to the yum.conf file
def writeToYum(proxy, port, username, password, flag):
    with open(YUM_, "a") as filepointer:
        if not flag:
            filepointer.write(f'proxy=http://{proxy}:{port}\n')
            if username:
                filepointer.write(f'proxy_username={username}\n')
                filepointer.write(f'proxy_password={password}\n')
        else:
            proxy_pattern = re.compile("^proxy.+$")
            with open(YUM_, "r") as filepointer:
                lines = filepointer.readlines()
            with open(YUM_, "w") as filepointer:
                for line in lines:
                    if not proxy_pattern.match(line):
                        filepointer.write(line)

# This function writes to the environment file
# Fist deletes the lines containng http:// , https://, ftp://
def writeToEnv(proxy, port, username, password, exceptions, flag):
    # find and delete line containing http://, httpd://, ftp://
    with open(ENV_, "r+") as opened_file:
        lines = opened_file.readlines()
        opened_file.seek(0)  # moves the file pointer to the beginning
        for line in lines:
            if r"http://" not in line and r"https://" not in line and r"ftp://" not in line and r"socks://" not in line:
                opened_file.write(line)
        opened_file.truncate()

    # writing starts
    if not flag:
        with open(ENV_, "a") as filepointer:
            filepointer.write("http_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("https_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("ftp_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("HTTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("HTTPS_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("FTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("socks_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'socks')))
            if exceptions:
                filepointer.write("NO_PROXY='{}'\n".format(exceptions))


# This function will write to the
def writeToBashrc(proxy, port, username, password, exceptions, flag):
    # find and delete http:// , https://, ftp://
    with open(BASH_, "r+") as opened_file:
        lines = opened_file.readlines()
        opened_file.seek(0)
        for line in lines:
            if r"http://" not in line and r"https://" not in line and r"ftp://" not in line and r"socks://" not in line:
                opened_file.write(line)
        opened_file.truncate()

    # writing starts
    if not flag:
        with open(BASH_, "a") as filepointer:
            filepointer.write("export http_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("export https_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("export ftp_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("export HTTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password)))
            filepointer.write("export HTTPS_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'https')))
            filepointer.write("export FTP_PROXY='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
            filepointer.write("export socks_proxy='{}'\n".format(make_proxy_url_string(proxy, port, username, password, 'socks')))
            if exceptions:
                filepointer.write("export NO_PROXY='{}'\n".format(exceptions))


def writeDockerServiceConfig(proxy, port, username, password, exceptions, flag):
    if not os.path.exists(DOCKER_SERVICE_DIR):
        os.makedirs(DOCKER_SERVICE_DIR)


    with open(DOCKER_, "r+") as opened_file:
        lines = opened_file.readlines()
        opened_file.seek(0)
        for line in lines:
            if r"http://" not in line and r"https://" not in line and r"ftp://" not in line and r"socks://" not in line:
                opened_file.write(line)
        opened_file.truncate()

    if not flag:
        with open(DOCKER_, "a") as filepointer:
            filepointer.write("[Service]\n")
            http_url = make_proxy_url_string(proxy, port, username, password)
            https_url = make_proxy_url_string(proxy, port, username, password, 'https')
            conf_str = 'Environment="HTTP_PROXY={0}" "HTTPS_PROXY={1}"'.format(http_url, https_url)
            if exceptions:
                conf_str += ' "NO_PROXY={}"\n'.format(exceptions)
            else:
                conf_str += '\n'
            filepointer.write(conf_str)

    if os.path.islink(DOCKER_SERVICE_UNIT):
        subprocess.run("systemctl daemon-reload", shell=True)
        subprocess.run("systemctl restart docker", shell=True)

def set_proxy(flag):
    proxy, port, username, password, exceptions = "", "", "", "", ""
    if not flag:
        proxy = input("Enter proxy : ")
        port = input("Enter port : ")
        exceptions = input("Enter IPs separated by ',' for direct access: ")
        username = input("Enter username : ")
        password = getpass.getpass("Enter password : ")

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
    if not username is None and not password is None:
        return "http://{0}:{1}@{2}:{3}".format(urllib.parse.quote_plus(username), urllib.parse.quote_plus(password), proxy, port)
    else:
        return "http://{0}:{1}".format(proxy, port)


def restore_default():
    # copy from backup to main
    if os.path.isfile(APT_BACKUP):
        shutil.copy(APT_BACKUP, APT_)
    if os.path.isfile(YUM_BACKUP):
        shutil.copy(YUM_BACKUP, YUM_)
    shutil.copy(ENV_BACKUP, ENV_)
    shutil.copy(BASH_BACKUP, BASH_)
    shutil.copy(DOCKER_BACKUP, DOCKER_)
    if os.path.islink(DOCKER_SERVICE_UNIT):
        subprocess.run("systemctl daemon-reload", shell=True)
        subprocess.run("systemctl restart docker", shell=True)

if __name__ == "__main__":

    # create backup     if not present
    if not os.path.isfile(REDHAT_RELEASE_FILE):
        if not os.path.isfile(APT_):
            open(APT_, 'a').close()

    if not os.path.exists(DOCKER_SERVICE_DIR):
        os.makedirs(DOCKER_SERVICE_DIR)
    if not os.path.isfile(DOCKER_):
        open(DOCKER_, 'a').close()

    if not os.path.isdir("./.backup_proxy"):
        os.makedirs("./.backup_proxy")
        if os.path.isfile(APT_):
            shutil.copyfile(APT_, APT_BACKUP)
        if os.path.isfile(YUM_):
            shutil.copyfile(YUM_, YUM_BACKUP)
        shutil.copyfile(ENV_, ENV_BACKUP)
        shutil.copyfile(BASH_, BASH_BACKUP)
        shutil.copyfile(DOCKER_, DOCKER_BACKUP)

    # choice
    print("1:) Set Proxy")
    print("2:) Remove Proxy")
    print("3:) Restore Default")
    print("4:) Exit")
    choice = int(input("\nchoice (1/2/3/4) : "))

    if (choice == 1):
        set_proxy(flag=0)
    elif (choice == 2):
        set_proxy(flag=1)
    elif (choice == 3):
        restore_default()
    else:
        sys.exit()

    print("DONE!")
