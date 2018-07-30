#!/usr/bin/python3

"""
created by :
Nityananda Gohain
School of Engineering, Tezpur University
27/10/17
"""

# run it as sudo


"""
Three files will be modified
1) /etc/apt/apt.conf
2) /etc/environment
3) /etc/bash.bashrc
"""

# This files takes the location as input and writes the proxy authentication

import getpass  # for taking password input
import shutil  # for copying file
import sys
import os.path  # for checking if file is present or not
import subprocess

apt_ = r'/etc/apt/apt.conf'
apt_backup = r'./.backup_proxy/apt.txt'
bash_ = r'/etc/bash.bashrc'
bash_backup = r'./.backup_proxy/bash.txt'
env_ = r'/etc/environment'
env_backup = r'./.backup_proxy/env.txt'
docker='/etc/systemd/system/docker.service.d/http-proxy.conf'
docker_path='/etc/systemd/system/docker.service.d'


# This function directly writes to the apt.conf file
def writeToApt(proxy, port, username, password, flag):
    filepointer = open(apt_, "w")
    if not flag:
        filepointer.write('Acquire::http::proxy "{}";\n'.format(make_proxy_url_string(proxy, port, username, password)))
        filepointer.write('Acquire::https::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'https')))
        filepointer.write('Acquire::ftp::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
        filepointer.write('Acquire::socks::proxy  "{}";\n'.format(make_proxy_url_string(proxy, port, username, password, 'socks')))
    filepointer.close()


# This function writes to the environment file
# Fist deletes the lines containng http:// , https://, ftp://
def writeToEnv(proxy, port, username, password, flag):
    # find and delete line containing http://, httpd://, ftp://
    with open(env_, "r+") as opened_file:
        lines = opened_file.readlines()
        opened_file.seek(0)  # moves the file pointer to the beginning
        for line in lines:
            if r"http://" not in line and r"https://" not in line and r"ftp://" not in line and r"socks://" not in line:
                opened_file.write(line)
        opened_file.truncate()

    # writing starts
    if not flag:
        filepointer = open(env_, "a")
        filepointer.write('http_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password)))
        filepointer.write('https_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'https')))
        filepointer.write('ftp_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
        filepointer.write('HTTP_PROXY="{}"\n'.format(make_proxy_url_string(proxy, port, username, password)))
        filepointer.write('HTTPS_PROXY="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'https')))
        filepointer.write('FTP_PROXY="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
        filepointer.write('socks_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'socks')))
        filepointer.close()


# This function will write to the
def writeToBashrc(proxy, port, username, password, flag):
    # find and delete http:// , https://, ftp://
    with open(bash_, "r+") as opened_file:
        lines = opened_file.readlines()
        opened_file.seek(0)
        for line in lines:
            if r"http://" not in line and r'"https://' not in line and r"ftp://" not in line and r"socks://" not in line:
                opened_file.write(line)
        opened_file.truncate()

    # writing starts
    if not flag:
        filepointer = open(bash_, "a")
        filepointer.write('export http_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password)))
        filepointer.write('export https_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'https')))
        filepointer.write('export ftp_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
        filepointer.write('export HTTP_PROXY="{}"\n'.format(make_proxy_url_string(proxy, port, username, password)))
        filepointer.write('export HTTPS_PROXY="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'https')))
        filepointer.write('export FTP_PROXY="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'ftp')))
        filepointer.write('export socks_proxy="{}"\n'.format(make_proxy_url_string(proxy, port, username, password, 'socks')))
        filepointer.close()

def writeDockerServiceConfig(proxy, port, username, password):
    if not os.path.exists(docker_path):
        os.makedirs(docker_path)

    with open(docker, "w") as filepoint:
        filepoint.write("[Service]\n")
        http_url = make_proxy_url_string(proxy, port, username, password)
        https_url = make_proxy_url_string(proxy, port, username, password, 'https')
        filepoint.write('Environment="HTTP_PROXY={0}" "HTTPS_PROXY={1}"\n'.format(http_url, https_url))


def set_proxy(flag):
    proxy, port, username, password = "", "", "", ""
    if not flag:
        proxy = input("Enter proxy : ")
        port = input("Enter port : ")
        username = input("Enter username : ")
        password = getpass.getpass("Enter password : ")

        if username == '':
            username = None

        if password == '':
            password = None
    writeToApt(proxy, port, username, password, flag)
    writeToEnv(proxy, port, username, password, flag)
    writeToBashrc(proxy, port, username, password, flag)
    writeDockerServiceConfig(proxy, port, username, password)
    COMMAND='Defaults env_keep += "http_proxy https_proxy ftp_proxy"'
    subprocess.run("echo $COMMAND  | sudo EDITOR='tee -a' visudo", shell=True)
    COMMAND2 = ['bash', '-c', 'source /etc/bash.bashrc']
    subprocess.run("bash -c source /etc/bash.bashrc", shell=True)

def make_proxy_url_string(proxy, port, username=None, password=None, protocol='http'):
    if not username is None and not password is None:
        return "http://{0}:{1}@{2}:{3}".format(username, password.replace('$', '\$'), proxy, port)
    else:
        return "http://{0}:{1}".format(proxy, port)


def restore_default():
    # copy from backup to main
    shutil.copy(apt_backup, apt_)
    shutil.copy(env_backup, env_)
    shutil.copy(bash_backup, bash_)



if __name__ == "__main__":

    # create backup	if not present
    if not os.path.isdir("./.backup_proxy"):
        os.makedirs("./.backup_proxy")
        if os.path.isfile(apt_):
            shutil.copyfile(apt_, apt_backup)
        shutil.copyfile(env_, env_backup)
        shutil.copyfile(bash_, bash_backup)

    # choice
    print("Please run this program as Super user(sudo)\n")
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