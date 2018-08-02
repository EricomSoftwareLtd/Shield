#!/bin/bash
############################################
#####   Ericom Shield Registry Cache   #####
#######################################BH###

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo "Usage: $0 "
    echo " Please run it as Root"
    echo "sudo $0 $@"
    exit
fi
ES_PATH="/usr/local/ericomshield"
LOGFILE="$ES_PATH/ericomshield.log"
ES_YML_FILE="$ES_PATH/docker-compose.yml"
ES_VER_FILE="$ES_PATH/shield-version.txt"
ES_BRANCH_FILE="$ES_PATH/.esbranch"
REGISTRY_PORT=8188
SHIELD_REGISTRY="127.0.0.1:$REGISTRY_PORT"

ES_REG_PATH="$ES_PATH/registry"
ES_REG_YML_REPO="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/Dev/Utils/shield-registry-config.yml"
ES_REG_YML="$ES_REG_PATH/shield-registry-config.yml"
ES_REG_DATA="$ES_REG_PATH/data"

function pull_images() {
    LINE=0
    while read -r line; do
        if [ "${line:0:1}" == '#' ]; then
            echo "$line"
        else
            arr=($line)
            if [ $LINE -ge 3 ]; then
                echo "################## Pulling images  ######################"
                echo "pulling image: ${arr[1]} ($SHIELD_REGISTRY)"
                if [ ! -z "$SHIELD_REGISTRY" ]; then
                   IMAGE_NAME="$SHIELD_REGISTRY/securebrowsing/${arr[1]}"
                   docker pull $IMAGE_NAME
                else
                   docker pull "securebrowsing/${arr[1]}"
                fi
            fi
        fi
        LINE=$((LINE + 1))
    done <"$ES_VER_FILE"
}

function update_daemon_json() {
    if [ ! -z $SHIELD_REGISTRY ]; then
       if [ -f /etc/docker/daemon.json ] && [ $(grep -c 'regist' /etc/docker/daemon.json) -ge 1 ]; then
          echo '/etc/docker/daemon.json is ok'
        else
          echo "Setting: insecure-registries:[$SHIELD_REGISTRY] in /etc/docker/daemon.json"
          echo '{' >/etc/docker/daemon.json.shield
          echo -n ',  "insecure-registries":["' >>/etc/docker/daemon.json.shield
          echo -n $SHIELD_REGISTRY >>/etc/docker/daemon.json.shield
          echo '"]' >>/etc/docker/daemon.json.shield
          echo '}' >>/etc/docker/daemon.json.shield
          systemctl stop docker
          sleep 10
          mv /etc/docker/daemon.json.shield /etc/docker/daemon.json
          systemctl start docker
       fi
    fi
}

# Create the Ericom empty dir if necessary
if [ ! -d $ES_PATH ]; then
    mkdir -p $ES_PATH
    chmod 0755 $ES_PATH
fi

# Create the Registry dir if necessary
if [ ! -d $ES_REG_PATH ]; then
    mkdir -p $ES_REG_PATH
    chmod 0755 $ES_REG_PATH
fi

cd "$ES_REG_PATH" || exit

# Create the Registry dir if necessary
if [ ! -d $ES_REG_DATA ]; then
    mkdir -p $ES_REG_DATA
    chmod 0755 $ES_REG_DATA
fi

echo "Getting $ES_REG_YM_REPO"
if [ -f "$ES_REG_YML" ]; then
   rm "$ES_REG_YML"
fi   
wget -q "$ES_REG_YML_REPO"

update_daemon_json

#Stopping registry dockeri if running:
if [ $(docker ps | grep -c registry) -ge 1 ]; then
   docker rm $(docker stop $(docker ps -a -q --filter name=registry --format="{{.ID}}"))
fi

#Starting registry docker
echo "Starting Shield Registry ..."
docker run --rm -d -p "$REGISTRY_PORT:5000" \
 -v "$ES_REG_YML:/etc/docker/registry/config.yml" \
 -v "$ES_REG_DATA:/var/lib/registry" \
 --name registry registry:2

#wait until container will start
sleep 30
echo "Ericom Shield Registry Cache Listening on port: $REGISTRY_PORT "

if [ -f "$ES_VER_FILE" ]; then
   echo "pull images" #pull images for caching
   pull_images
fi
    
