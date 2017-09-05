#!/bin/bash
############################################
#####   Ericom Shield Virtual Appliance  ###
#######################################BH###

#Check if we are root
if (( $EUID != 0 )); then
#    sudo su
        echo " Please run it as Root"
        echo "sudo" $0 $1 $2
#       don't exit for now, because when running with Jenkins        
#       exit 1
fi

LOGFILE="ericomshield-ova.log"
OVA_FILE="shield_eval.ova"
ES_repo_Vagrant="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/Vagrantfile"
ES_repo_Vagrant_dev="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/Vagrantfile_dev"
PUSH_STRATEGY_GDRIVE="0"
PUSH_STRATEGY_COPY="1"
TARGET_FOLDER="/tmp/shield_ova/"
PUSH_STRATEGY_FTP="0"

if [ "$1" == "-dev" ]; then
   echo "Using Dev Release"
   curl -s -S -o Vagrantfile $ES_repo_Vagrant_dev
   DEV="Dev"
   OVA_FILE="shield_eval_dev.ova"
  else
   echo "Using Production Release"
   curl -s -S -o Vagrantfile $ES_repo_Vagrant
fi

echo "Preparing Ericom Shield Virtual Appliance"
echo "Cleaning existing VM"
vagrant destroy -f

if [ -f "$OVA_FILE" ]; then
   rm $OVA_FILE
fi

echo "***************     Vagrant Up"
time vagrant up
if [ $? == 0 ]; then
   echo "***************     Success!"
  else
   echo "An error occured during the Virtual Appliance $DEV generation"
   echo "$(date): An error occured during the Virtual Appliance $DEV generation" >> "$LOGFILE"
   exit 1
fi

time vagrant halt
echo "***************     Vagrant Export Ova"
time vboxmanage export shield-eval -o $OVA_FILE

if [ $? == 0 ]; then
   echo "***************     Success!"
   echo "Ericom Shield Virtual Appliance is ready: $OVA_FILE"
   echo "$(date): Ericom Shield Virtual Appliance is ready: $OVA_FILE" >> "$LOGFILE"
  else
   echo "An error occured during the Virtual Appliance $DEV generation"
   echo "$(date): An error occured during the Virtual Appliance $DEV generation" >> "$LOGFILE"
   exit 1
fi

chmod 277 $OVA_FILE

# Need to define push strategy (ftp, GoogleDrive, ftp, repo)

if [ $PUSH_STRATEGY_GDRIVE == "1" ]; then
#  using gdrive (assuming it is installed:
#  gdrive installation from home directory (~)
#
#  wget https://docs.google.com/uc?id=0B3X9GlR6EmbnWksyTEtCM0VfaFE&export=download
#  ls
#  mv uc\?id\=0B3X9GlR6EmbnWksyTEtCM0VfaFE gdrive
#  chmod +x gdrive
#  sudo install gdrive /usr/local/bin/gdrive
#  gdrive list

    echo "***************     Uploading to GoogleDrive"
    if [ "$1" == "-dev" ]; then
       time gdrive update 0B_wcQRaAT_INVkpVckU5eXh0cHM $OVA_FILE
      else
       time gdrive update 0B_wcQRaAT_INcXhsc1E4bXlySWs $OVA_FILE
    fi

    if [ $? == 0 ]; then
       echo "***************     Success!"
       echo "Ericom Shield Virtual Appliance Uploaded to Google Drive"
       echo "$(date): Ericom Shield Virtual Appliance $DEV Uploaded to Google Drive" >> "$LOGFILE"
      else
       echo "An error occured during the Virtual Appliance upload"
       echo "$(date): An error occured during the Virtual Appliance $DEV upload to Google Drive" >> "$LOGFILE"
       exit 1
    fi
fi

if [ $PUSH_STRATEGY_COPY == "1" ]; then
    echo "***************     Moving the File to: $TARGET_FOLDER"
    if [ ! -d $TARGET_FOLDER ]; then
       mkdir -p $TARGET_FOLDER
       chmod 0755 $TARGET_FOLDER
    fi
    time mv $OVA_FILE $TARGET_FOLDER

    if [ $? == 0 ]; then
       echo "***************     Success!"
       echo "Ericom Shield Virtual Appliance Copied to $TARGET_FOLDER"
       echo "$(date): Ericom Shield Virtual Appliance $DEV Copied to $TARGET_FOLDER" >> "$LOGFILE"
      else
       echo "An error occured during the Virtual Appliance Copy to Folder:$TARGET_FOLDER"
       echo "$(date): An error occured during the Virtual Appliance $DEV Copy to Folder:$TARGET_FOLDER " >> "$LOGFILE"
       exit 1
    fi
fi

# PUSH_STRATEGY_FTP="0"
