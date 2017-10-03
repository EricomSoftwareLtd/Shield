#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 [-force] [-noautoupdate] [-dev] [-usage] [-pocket]"
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
ES_PATH="/usr/local/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
DOCKER_VERSION="17.06.2"
DOCKER_COMPOSE_VERSION="1.15.0"
UPDATE=false
UPDATE_NEED_RESTART=false
UPDATE_NEED_RESTART_TXT="#UNR#"
ES_DEV_FILE="$ES_PATH/.esdev"
ES_AUTO_UPDATE_FILE="$ES_PATH/.autoupdate"
ES_REPO_FILE="$ES_PATH/ericomshield-repo.sh"
ES_YML_FILE="$ES_PATH/docker-compose.yml"
ES_YML_FILE_BAK="$ES_PATH/docker-compose_yml.bak"
ES_VER_FILE="$ES_PATH/shield-version.txt"
ES_VER_FILE_BAK="$ES_PATH/shield-version.bak"
ES_uninstall_FILE="$ES_PATH/ericomshield-uninstall.sh"
EULA_ACCEPTED_FILE="$ES_PATH/.eula_accepted"

ES_SETUP_VER="17.40b-Setup"
BRANCH="master"

MIN_FREE_SPACE_GB=5
DOCKER_USER="ericomshield1"
DOCKER_SECRET="Ericom98765$"
ES_DEV=false
ES_POCKET=false
ES_AUTO_UPDATE=true
ES_FORCE=false
# Create the Ericom empty dir if necessary
if [ ! -d $ES_PATH ]; then
    mkdir -p $ES_PATH
    chmod 0755 $ES_PATH
fi

cd "$ES_PATH" || exit

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -dev)
        ES_DEV=true
        echo "ES_DEV" >"$ES_DEV_FILE"
        ;;
    -noautoupdate)
        ES_AUTO_UPDATE=false
        rm -f "$ES_AUTO_UPDATE_FILE"
        ;;
    -force)
        ES_FORCE=true
        echo " " >>$ES_VER_FILE
        ;;
    -pocket)
        ES_POCKET=true
        echo " pocket version "
        ;;
    -restart)
        UPDATE_NEED_RESTART=true
        echo " Restart will be done during upgrade "	
        ;;
    -approve-eula)
	log_message "EULA has been accepted from Command Line"
        date -Iminutes >"$EULA_ACCEPTED_FILE"
	;;
    #        -usage)
    *)
        echo "Usage: $0 [-force] [-noautoupdate] [-dev] [-pocket] [-usage]"
        exit
        ;;
    esac
    shift
done

if [ -f "$ES_DEV_FILE" ]; then
    ES_DEV=true
fi

if [ "$ES_AUTO_UPDATE" == true ]; then
    echo "ES_AUTO_UPDATE" >"$ES_AUTO_UPDATE_FILE"
fi

#Check if curl is installed (-w check that the whole word is found)
if [ "$(dpkg -l | grep -w -c curl)" -eq 0 ]; then
    echo "***************     Installing curl"
    apt-get --assume-yes -y install curl
fi

if [ "$(dpkg -l | grep -w -c jq)" -eq 0 ]; then
    echo "***************     Installing jq"
    apt-get --assume-yes -y install jq
fi

function log_message() {
    echo "$1"
    echo "$(date): $1" >>"$LOGFILE"
}
function failed_to_install() {
   log_message "An error occured during the installation: $1, Exiting!"

    if [ "$UPDATE" == true ]; then
       if [ -f "$ES_VER_FILE" ]; then
          mv "$ES_VER_FILE_BAK" "$ES_VER_FILE"
       fi   
      else
       if [ -f "$ES_VER_FILE" ]; then
          rm "$ES_VER_FILE"             
       fi   
    fi   
}

function accept_license() {
    export LESSSECURE=1
    while less -P"%pb\% Press h for help or q to quit" "$1" &&
        read -p "Do you accept the EULA (yes/no/anything else to display it again)? " choice; do
        case "$choice" in
        y | Y | n | N)
            echo 'Please, type "yes" or "no"'
            read -n1 -r -p "Press any key to continue..." key
            ;;
        "yes" | "YES" | "Yes")
            echo "yes"
            return 0
            ;;
        "no" | "NO" | "No")
            echo "no"
            break
            ;;
        *) ;;

        esac
    done

    return -1
}

function check_free_space() {
    FREE_SPACE_ON_ROOT=$(($(stat -f --format="%a*%S" /) / (1024 * 1024 * 1024)))
    FREE_SPACE_ON_DEB=$(($(stat -f --format="%a*%S" /var/cache/debconf) / (1024 * 1024 * 1024)))
    if ((FREE_SPACE_ON_ROOT < MIN_FREE_SPACE_GB)); then
        failed_to_install "Not enough free space on the / partition. ${FREE_SPACE_ON_ROOT}GB available, ${MIN_FREE_SPACE_GB}GB required."
        exit 1
    fi
    if ((FREE_SPACE_ON_DEB < MIN_FREE_SPACE_GB)); then
        failed_to_install "Not enough free space on the /var/cache/debconf partition. ${FREE_SPACE_ON_DEB}GB available, ${MIN_FREE_SPACE_GB}GB required."
        exit 1
    fi
}

function install_docker() {
    if [ "$(sudo docker version | grep -c $DOCKER_VERSION)" -le 1 ]; then
        echo "***************     Installing docker-engine"
        apt-get --assume-yes -y install apt-transport-https
#        apt-get update
#        apt-get --assume-yes -y install "linux-image-extra-$(uname -r)" linux-image-extra-virtual
#        apt-get --assume-yes -y install apt-transport-https ca-certificates software-properties-common
#        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#        apt-get update
#        apt-get --assume-yes -y install docker-ce
	
	#Docker Installation of a specific Version
        curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
        sudo apt-add-repository "deb https://apt.dockerproject.org/repo debian-$(lsb_release -cs) main"
        sudo apt-get update

        sudo apt-cache policy docker-ce
	echo "Installing Docker: docker-ce=$DOCKER_VERSION~ce-2~ubuntu"
	sudo apt-get -y --assume-yes --allow-downgrades install docker-ce=$(DOCKER_VERSION)~ce-2~ubuntu
    else
        echo " ******* docker-engine $DOCKER_VERSION is already installed"
    fi
    if [ "$(sudo docker version | wc -l)" -le 1 ]; then
       failed_to_install "Failed to Install Docker"
       exit 1
    fi
}

function install_docker_compose() {
    if [ "$(docker-compose version | grep -c $DOCKER_COMPOSE_VERSION)" -eq 0 ]; then
        echo "***************     Installing docker-compose"
        curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    else
        echo "***************     DockerCompose is already installed"
    fi
}

function docker_login() {
    if [ "$(docker info | grep -c Username)" -eq 0 ]; then
        if [ "$DOCKER_USER" == " " ]; then
            echo " Please enter your login credentials to docker-hub"
            docker login
        else
            #Login and enter the credentials you received separately when prompt
            echo "docker login" $DOCKER_USER $DOCKER_SECRET
            docker login --username=$DOCKER_USER --password=$DOCKER_SECRET
        fi

        if [ $? == 0 ]; then
            echo "Login Succeeded!"
        else
            echo "Cannot Login to docker, Exiting!"
            echo "$(date): An error occured during the installation: Cannot login to docker" >>"$LOGFILE"
            exit 1
        fi
    fi
}

function update_sysctl() {
    #check if file was not updated
    curl -s -S -o "${ES_PATH}/sysctl_shield.conf" "${ES_repo_sysctl_shield_conf}"
    if [ "$(grep -c EricomShield /etc/sysctl.conf)" -eq 0 ]; then
        # append sysctl with our settings
        cat "${ES_PATH}/sysctl_shield.conf" >>/etc/sysctl.conf
        #to apply the changes:
        sysctl -p
        echo "file /etc/sysctl.conf Updated!!!!"
    else
        echo "file /etc/sysctl.conf already updated"
    fi
    echo "setting sysctl fs.file=1000000"
    sysctl -w fs.file-max=1000000
}

function create_shield_service() {
    echo "**************  Creating the ericomshield updater service..."
    if [ ! -f "${ES_PATH}/ericomshield-updater.service" ]; then
        # Need to download the service file only if needed and reload only if changed
        curl -s -S -o "${ES_PATH}/ericomshield-updater.service" "${ES_repo_systemd_updater_service}"
        systemctl link ${ES_PATH}/ericomshield-updater.service
        systemctl --system enable ${ES_PATH}/ericomshield-updater.service
        systemctl daemon-reload
	fi	
    echo "Done!"
}

function prepare_yml() {
    echo "Preparing yml file..."
    while read -r ver; do
        if [ "${ver:0:1}" == '#' ]; then
            echo "$ver"
        else
            pattern_ver=$(echo "$ver" | awk '{print $1}')
            comp_ver=$(echo "$ver" | awk '{print $2}')
            if [ ! -z "$pattern_ver" ]; then
                echo "Changing ver: $comp_ver"
                #echo "  sed -i 's/$pattern_ver/$comp_ver/g' $ES_YML_FILE"
                sed -i "s/$pattern_ver/$comp_ver/g" $ES_YML_FILE
            fi
        fi
    done <"$ES_VER_FILE"

    MY_IP=IP=$(/sbin/ifconfig | grep 'inet addr:' | grep -v "127.0" | grep -v "172.1" | cut -d: -f2 | awk '{ printf $1}')
    #echo "  sed -i 's/IP_ADDRESS/$MY_IP/g' $ES_YML_FILE"
    sed -i "s/IP_ADDRESS/$MY_IP/g" $ES_YML_FILE
}

function get_shield_install_files() {
    echo "Getting $ES_REPO_FILE"
    ES_repo_setup="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-repo.sh"
    echo $ES_REPO_FILE
    curl -s -S -o $ES_REPO_FILE $ES_repo_setup
    #include file with files repository
    source $ES_REPO_FILE

    if [ "$ES_DEV" == true ]; then
        echo "Getting $ES_repo_dev_ver (dev)"
        curl -s -S -o shield-version-new.txt "$ES_repo_dev_ver"
    else
        echo "Getting $ES_repo_ver (prod)"
        curl -s -S -o shield-version-new.txt "$ES_repo_ver"
    fi
    if [ -f "$ES_VER_FILE" ]; then
        if [ "$(diff "$ES_VER_FILE" shield-version-new.txt | wc -l)" -eq 0 ]; then
            echo "Your EricomShield System is Up to date"
            exit 0
        else
            echo "***************     Updating EricomShield ($ES_SETUP_VER)"
            echo "$(date): New version found:  Updating EricomShield ($ES_SETUP_VER)" >>"$LOGFILE"
            UPDATE=true
            mv "$ES_VER_FILE"  "$ES_VER_FILE_BAK"
            if [ $(grep -c "$UPDATE_NEED_RESTART_TXT" shield-version-new.txt) -eq 1 ]; then
              UPDATE_NEED_RESTART=true
            fi  
        fi
    else
        echo "***************     Installing EricomShield ($ES_SETUP_VER)..."
        echo "$(date): Installing EricomShield ($ES_SETUP_VER)" >>"$LOGFILE"
    fi
    mv "shield-version-new.txt" "$ES_VER_FILE"

    echo "Getting $ES_YML_FILE"

    if [ -f "$ES_YML_FILE" ]; then
       mv  "$ES_YML_FILE"  "$ES_YML_FILE_BAK"
    fi   

    curl -s -S -o "$ES_YML_FILE" "$ES_repo_yml"
    echo "Getting $ES_repo_uninstall"
    curl -s -S -o "$ES_uninstall_FILE" "$ES_repo_uninstall"
    chmod +x "$ES_uninstall_FILE"

    if [ $ES_POCKET == true ]; then
        echo "Getting $ES_repo_pocket_yml"
        curl -s -S -o "$ES_YML_FILE" "$ES_repo_pocket_yml"
    fi
    curl -s -S -o deploy-shield.sh "$ES_repo_swarm_sh"
    if [ "$ES_DEV" == true ]; then
        echo "Getting $ES_repo_dev_yml"
        curl -s -S -o "$ES_YML_FILE" "$ES_repo_dev_yml"
        curl -s -S -o deploy-shield.sh "$ES_repo_swarm_dev_sh"
    fi
    chmod +x deploy-shield.sh
}

#############     Getting all files from Github
function get_shield_files() {
    if [ ! -f "ericomshield-setup.sh" ]; then
        curl -s -S -o ericomshield-setup.sh $ES_repo_setup
        chmod +x ericomshield-setup.sh
    fi

    curl -s -S -o run.sh "$ES_repo_run"
    chmod +x run.sh
    curl -s -S -o autoupdate.sh "$ES_repo_update"
    chmod +x autoupdate.sh
    curl -s -S -o showversion.sh "$ES_repo_version"
    chmod +x showversion.sh
    curl -s -S -o stop.sh "$ES_repo_stop"
    chmod +x stop.sh
    curl -s -S -o status.sh "$ES_repo_status"
    chmod +x status.sh
    curl -s -S -o ~/show-my-ip.sh "$ES_repo_ip"
    chmod +x ~/show-my-ip.sh
}

##################      MAIN: EVERYTHING STARTS HERE: ##########################

check_free_space

echo Docker Login: $DOCKER_USER
echo "dev=$ES_DEV"
echo "autoupdate=$ES_AUTO_UPDATE"

install_docker

if systemctl start docker; then
    echo "Starting docker service ***************     Success!"
else
   failed_to_install "Failed to start docker service"
   exit 1
fi

install_docker_compose

get_shield_install_files

if [ "$UPDATE" == false ] && [ ! -f "$EULA_ACCEPTED_FILE" ]; then
    echo 'You will now be presented with the End User License Agreement.'
    echo 'Use PgUp/PgDn/Arrow keys for navigation, q to exit.'
    echo 'Please, read the EULA carefully, then accept it to continue the installation process or reject to exit.'
    read -n1 -r -p "Press any key to continue..." key
    echo

    curl -s -S -o "$ES_PATH/Ericom-EULA.txt" "$ES_repo_EULA"
    if accept_license "$ES_PATH/Ericom-EULA.txt"; then
        log_message "EULA has been accepted"
        date -Iminutes >"$EULA_ACCEPTED_FILE"
    else
        failed_to_install "EULA has not been accepted, exiting..."
        exit -1
    fi
fi

get_shield_files

docker_login

update_sysctl

echo "Preparing yml file (Containers build number)"
prepare_yml

if [ "$UPDATE" == false ]; then
    # New Installation

    create_shield_service
    systemctl start ericomshield-updater.service

else # Update
   if [ "$UPDATE_NEED_RESTART" == true ]; then
      echo " Stopping Ericom Shield for Update "
      ./stop.sh
     else
      echo -n "stop shield-broker"
      docker service scale shield_broker-server=0
      wait=0
      while [ $wait -lt 6 ]; do
        if [ "$(docker service ps shield_broker-server | wc -l)" -le 1 ]; then
            echo !
            break
        else
            echo -n .
            sleep 10
        fi
        wait=$((wait + 1))
      done
    fi
fi

echo "source deploy-shield.sh"
source deploy-shield.sh

# Check the result of the last command (start, status, deploy-shield)
if [ $? == 0 ]; then
    echo "***************     Success!"
else
    echo "An error occured during the installation"
    echo "$(date): An error occured during the installation" >>"$LOGFILE"
    echo "--failed?" >>"$ES_VER_FILE" # adding failed into the version file
    exit 1
fi

#Check the status of the system wait 30*10 (5 mins)
wait=0
while [ $wait -lt 10 ]; do
    if "$ES_PATH"/status.sh; then
        echo "Ericom Shield is Running!"
        break
    else
        echo -n .
        sleep 20
    fi
    wait=$((wait + 1))
done

Version=$(grep SHIELD_VER "$ES_YML_FILE")

echo "$Version" >.version
grep image "$ES_YML_FILE" >>.version

echo "***************     Success!"
echo "***************"
echo "***************     Ericom Shield Version: $Version is up and running"
echo "$(date): Ericom Shield Version: $Version is up and running" >>"$LOGFILE"
