#!/bin/bash -e
############################################
#####   Ericom Shield Proxy Rules      #####
####################################AN#BH###

ES_PATH="/usr/local/ericomshield"

function show_usage() {
    echo "Shield IP tables rules installation"
    echo "Usage: $0 <PROXY_ADDRESS> <PROXY_PORT>"
    exit
}

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    show_usage
    exit
fi

if [ ! -d "$ES_PATH" ]; then
    mkdir -p "$ES_PATH"
fi
cd "$ES_PATH"

PROXY_ADDRESS="$1"
PROXY_PORT="$2"
APP=$(which iptables)
BRIDGE_RANGE=$(docker network inspect bridge -f "{{.IPAM.Config}}" | cut -c 3-999 | cut -d ' ' -f 1)
GW_BRIDGE_RANGE=$(docker network inspect docker_gwbridge -f "{{.IPAM.Config}}" | cut -c 3-999 | cut -d ' ' -f 1)

if [ -z "$PROXY_ADDRESS" ] || [ -z "$PROXY_PORT" ] ; then
    show_usage
    exit 1
fi

if [ $(systemctl status es-iptables-rule.service | grep -c 'not-found') -eq "1" ]; then
   tee  $ES_PATH/create-iptable-rules.sh << EOF
#!/bin/bash -e
$APP -t nat -A PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -A PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -A PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -A PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
EOF

    chmod +x $ES_PATH/create-iptable-rules.sh

    tee  $ES_PATH/delete-iptable-rules.sh << EOF
#!/bin/bash -e
$APP -t nat -D PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -D PREROUTING -s $BRIDGE_RANGE ! -d $BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
$APP -t nat -D PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS:$PORXY_PORT
$APP -t nat -D PREROUTING -s $GW_BRIDGE_RANGE ! -d $GW_BRIDGE_RANGE -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS:$PROXY_PORT
EOF

    chmod +x $ES_PATH/delete-iptable-rules.sh

    tee  $ES_PATH/es-iptables-rule.service << EOF
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
    exit 0
fi
