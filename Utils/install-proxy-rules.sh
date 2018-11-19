#!/bin/bash -e


ES_PATH="/usr/local/ericomshield"

function show_usage() {
    echo "Shield IP tables rules installation"
    echo "Usage: $0 [OPTIONS] PROXY_ADDRESS"
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
APP=$(which iptables)

if [ -z "$PROXY_ADDRESS" ]; then
    show_usage
    exit 1
fi

if [ $(systemctl status es-iptables-rule.service | grep -c 'not-found') -eq "1" ]; then
   tee -a $ES_PATH/create-iptable-rules.sh << EOF
#!/bin/bash -e
$APP -t nat -A PREROUTING -s 172.17.0.0/16 ! -d 172.17.0.0/16 -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS
$APP -t nat -A PREROUTING -s 172.17.0.0/16 ! -d 172.17.0.0/16 -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS
$APP -t nat -A PREROUTING -s 172.18.0.0/16 ! -d 172.18.0.0/16 -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS
$APP -t nat -A PREROUTING -s 172.18.0.0/16 ! -d 172.18.0.0/16 -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS
EOF

    chmod +x $ES_PATH/create-iptable-rules.sh

    tee -a $ES_PATH/delete-iptable-rules.sh << EOF
#!/bin/bash -e
$APP -t nat -D PREROUTING -s 172.17.0.0/16 ! -d 172.17.0.0/16 -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS
$APP -t nat -D PREROUTING -s 172.17.0.0/16 ! -d 172.17.0.0/16 -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS
$APP -t nat -D PREROUTING -s 172.18.0.0/16 ! -d 172.18.0.0/16 -p tcp --dport 80 -j DNAT --to $PROXY_ADDRESS
$APP -t nat -D PREROUTING -s 172.18.0.0/16 ! -d 172.18.0.0/16 -p tcp --dport 443 -j DNAT --to $PROXY_ADDRESS
EOF

    chmod +x delete-iptable-rules.sh

    tee -a $ES_PATH/es-iptables-rule.service << EOF
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





