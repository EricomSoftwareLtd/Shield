#!/bin/bash -e
############################################
#####   Ericom Shield Proxy Rules      #####
####################################AN#BH###

ES_PATH="/usr/local/ericomshield"

function show_usage() {
    echo ""
    echo "Shield IP tables rules installation"
    echo "   Usage: $0 <PROXY_ADDRESS> <PROXY_PORT>"
    echo ""
    exit
}

function valid_ip()
{
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    if [ $stat -eq 1 ];then
        echo "Error."
        echo "Invalid IP address. Please check and run again."
        show_usage
    fi
    return $stat
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    show_usage
    exit 1
fi

if [ $(systemctl status es-iptables-rule.service | grep -c 'Active: active') -eq "1" ]; then
    systemctl stop es-iptables-rule.service
fi

if [ ! -d "$ES_PATH" ]; then
    mkdir -p "$ES_PATH"
fi

cd "$ES_PATH"

PROXY_ADDRESS="$1"
PROXY_PORT="$2"
APP=$(which iptables)
DOCKER_NETWORK_REGEX='^[[:space:]\[\{]+([[:digit:]\.\/]+)'

if [[ $(docker network inspect bridge -f "{{.IPAM.Config}}") =~ $DOCKER_NETWORK_REGEX ]]; then
    BRIDGE_RANGE="${BASH_REMATCH[1]}"
else
    echo "Could not determine Docker bridge network address. Exiting..."
    exit 1
fi
if [[ $(docker network inspect docker_gwbridge -f "{{.IPAM.Config}}") =~ $DOCKER_NETWORK_REGEX ]]; then
    GW_BRIDGE_RANGE="${BASH_REMATCH[1]}"
else
    echo "Could not determine Docker GW bridge network address. Exiting..."
    exit 1
fi

if [ -z "$PROXY_ADDRESS" ] || [ -z "$PROXY_PORT" ] ; then
    show_usage
    exit 1
fi

valid_ip $PROXY_ADDRESS

   cat << EOF > $ES_PATH/create-iptable-rules.sh
#!/bin/bash -e
EOF

   cat << EOF > $ES_PATH/delete-iptable-rules.sh
#!/bin/bash -e
EOF


echo -n "Do you want Bypass the Proxy for CDR? [y/N]:"
read ANSWER
case $ANSWER in
     "Y" | "y" | "yes" | "Yes" | "YES" )
     echo -n "Please input CDR Server's IP address.: "
     read CDR_SERVER
     valid_ip $CDR_SERVER
     cat << EOF >> $ES_PATH/create-iptable-rules.sh
$APP -t nat -A PREROUTING -s $BRIDGE_RANGE -d $CDR_SERVER -p tcp -j DNAT --to $CDR_SERVER
$APP -t nat -A PREROUTING -s $GW_BRIDGE_RANGE -d $CDR_SERVER -p tcp -j DNAT --to $CDR_SERVER
EOF

     cat << EOF >> $ES_PATH/delete-iptable-rules.sh
$APP -t nat -D PREROUTING -s $BRIDGE_RANGE -d $CDR_SERVER -p tcp -j DNAT --to $CDR_SERVER
$APP -t nat -D PREROUTING -s $GW_BRIDGE_RANGE -d $CDR_SERVER -p tcp -j DNAT --to $CDR_SERVER
EOF


     echo -n "Please input secondary CDR Server's IP address.(if you need): "
     read CDR_SERVER2

     if [ "$CDR_SERVER2" != "" ]; then
         cat << EOF >> $ES_PATH/create-iptable-rules.sh
$APP -t nat -A PREROUTING -s $BRIDGE_RANGE -d $CDR_SERVER2 -p tcp -j DNAT --to $CDR_SERVER2
$APP -t nat -A PREROUTING -s $GW_BRIDGE_RANGE -d $CDR_SERVER2 -p tcp -j DNAT --to $CDR_SERVER2
EOF

         cat << EOF >> $ES_PATH/delete-iptable-rules.sh
$APP -t nat -D PREROUTING -s $BRIDGE_RANGE -d $CDR_SERVER2 -p tcp -j DNAT --to $CDR_SERVER2
$APP -t nat -D PREROUTING -s $GW_BRIDGE_RANGE -d $CDR_SERVER2 -p tcp -j DNAT --to $CDR_SERVER2
EOF
     fi
        ;;
     * )
        ;;
esac


   cat << EOF >> $ES_PATH/create-iptable-rules.sh
$APP -t nat -A PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -A PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -A PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -A PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
EOF

    chmod +x $ES_PATH/create-iptable-rules.sh
    cat $ES_PATH/create-iptable-rules.sh

    cat << EOF >> $ES_PATH/delete-iptable-rules.sh
$APP -t nat -D PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -D PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -D PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -D PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
EOF

    chmod +x $ES_PATH/delete-iptable-rules.sh
    cat $ES_PATH/delete-iptable-rules.sh

if [ $(systemctl status es-iptables-rule.service | grep -c 'not-found') -eq "1" ]; then
    cat << EOF > $ES_PATH/es-iptables-rule.service
[Unit]
Description=Apply DNAT rule for transparent proxy
After=docker.service

[Service]
Type=oneshot
ExecStart=$ES_PATH/create-iptable-rules.sh
ExecStop=$ES_PATH/delete-iptable-rules.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    systemctl link $ES_PATH/es-iptables-rule.service
    systemctl --system enable $ES_PATH/es-iptables-rule.service
    systemctl daemon-reload

    systemctl start es-iptables-rule.service

else
    echo "Service already exists"

    systemctl restart es-iptables-rule.service

    echo "Restarted the Service "

    exit 0
fi
