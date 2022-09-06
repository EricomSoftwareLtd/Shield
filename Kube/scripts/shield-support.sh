#!/bin/bash
############################################
#####   Ericom Shield Support          #####
#######################################BH###
#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo" $0
    exit
fi

echo
echo " Shield Support: Collecting Info and Logs from System and Shield ....."
echo

# Create temp directory
TMPDIR=$(mktemp -d)

# System info
echo " Shield Support: Collecting System Info ....."
mkdir -p $TMPDIR/systeminfo
hostname >$TMPDIR/systeminfo/hostname 2>&1
hostname -f >$TMPDIR/systeminfo/hostnamefqdn 2>&1
cat /etc/hosts >$TMPDIR/systeminfo/etchosts 2>&1
cat /etc/resolv.conf >$TMPDIR/systeminfo/etcresolvconf 2>&1
date >$TMPDIR/systeminfo/date 2>&1
free -m >$TMPDIR/systeminfo/freem 2>&1
uptime >$TMPDIR/systeminfo/uptime 2>&1
dmesg >$TMPDIR/systeminfo/dmesg 2>&1
df -h >$TMPDIR/systeminfo/dfh 2>&1
if df -i >/dev/null 2>&1; then
    df -i >$TMPDIR/systeminfo/dfi 2>&1
fi
lsmod >$TMPDIR/systeminfo/lsmod 2>&1
mount >$TMPDIR/systeminfo/mount 2>&1
ps aux >$TMPDIR/systeminfo/psaux 2>&1
lsof -Pn >$TMPDIR/systeminfo/lsof 2>&1
if $(command -v sysctl >/dev/null 2>&1); then
    sysctl -a >$TMPDIR/systeminfo/sysctla 2>/dev/null
fi
# OS: Ubuntu
if $(command -v ufw >/dev/null 2>&1); then
    ufw status >$TMPDIR/systeminfo/ubuntu-ufw 2>&1
fi
if $(command -v apparmor_status >/dev/null 2>&1); then
    apparmor_status >$TMPDIR/systeminfo/ubuntu-apparmorstatus 2>&1
fi
# OS: RHEL
if [ -f /etc/redhat-release ]; then
    systemctl status NetworkManager >$TMPDIR/systeminfo/rhel-statusnetworkmanager 2>&1
    systemctl status firewalld >$TMPDIR/systeminfo/rhel-statusfirewalld 2>&1
    if $(command -v getenforce >/dev/null 2>&1); then
        getenforce >$TMPDIR/systeminfo/rhel-getenforce 2>&1
    fi
fi
echo " Done! "
echo

# Docker
echo " Shield Support: Collecting Docker Info ....."
mkdir -p $TMPDIR/docker
docker info >$TMPDIR/docker/dockerinfo 2>&1
docker ps -a >$TMPDIR/docker/dockerpsa 2>&1
docker stats -a --no-stream >$TMPDIR/docker/dockerstats 2>&1
if [ -f /etc/docker/daemon.json ]; then
    cat /etc/docker/daemon.json >$TMPDIR/docker/etcdockerdaemon.json
fi

# Networking
mkdir -p $TMPDIR/networking
iptables-save >$TMPDIR/networking/iptablessave 2>&1
cat /proc/net/xfrm_stat >$TMPDIR/networking/procnetxfrmstat 2>&1
if $(command -v ip >/dev/null 2>&1); then
    ip addr show >$TMPDIR/networking/ipaddrshow 2>&1
    ip route >$TMPDIR/networking/iproute 2>&1
fi
if $(command -v ifconfig >/dev/null 2>&1); then
    ifconfig -a >$TMPDIR/networking/ifconfiga
fi

# System logging
mkdir -p $TMPDIR/systemlogs
#cp /var/log/syslog* /var/log/messages* /var/log/kern* /var/log/docker* /var/log/system-docker* /var/log/audit/* $TMPDIR/systemlogs 2>/dev/null
cp /var/log/syslog /var/log/docker* /var/log/system-docker* $TMPDIR/systemlogs 2>/dev/null

echo " Done! "
echo

# Rancher logging
if [ $(docker ps | grep -c rancher) -ge 1 ]; then
    echo " Shield Support: Collecting Rancher Info ....."
    # Discover any server or agent running
    mkdir -p $TMPDIR/rancher/containerinspect
    mkdir -p $TMPDIR/rancher/containerlogs
    RANCHERSERVERS=$(docker ps -a | grep -E "rancher/rancher:|rancher/rancher " | awk '{ print $1 }')
    RANCHERAGENTS=$(docker ps -a | grep -E "rancher/rancher-agent:|rancher/rancher-agent " | awk '{ print $1 }')

    for RANCHERSERVER in $RANCHERSERVERS; do
        docker inspect $RANCHERSERVER >$TMPDIR/rancher/containerinspect/server-$RANCHERSERVER 2>&1
        docker logs -t $RANCHERSERVER >$TMPDIR/rancher/containerlogs/server-$RANCHERSERVER 2>&1
    done

    echo " Done! "
    echo
fi

# Shield
mkdir -p $TMPDIR/shield
echo " Shield Support: Collecting Shield Info ....."

if [ $(which "kubectl") ] >/dev/null; then
    kubectl get namespaces >$TMPDIR/shield/k8s-namespaces
    kubectl get nodes >$TMPDIR/shield/k8s-nodes
    kubectl get pods -o wide --all-namespaces >$TMPDIR/shield/k8s-pods
fi

if [ -d ~/shield/ ]; then
    cp -r ~/shield/ $TMPDIR/shield/ 2>/dev/null
fi

if [ -d /usr/local/ericomshield/ ]; then
    /usr/local/ericomshield/status.sh -a >$TMPDIR/shield/statusa
    if [ "$?" -eq "0" ]; then
        /usr/local/ericomshield/status.sh -n >$TMPDIR/shield/statusn
        /usr/local/ericomshield/status.sh -s >$TMPDIR/shield/statuss
        /usr/local/ericomshield/status.sh -e >$TMPDIR/shield/statuse
    fi
    cp /usr/local/ericomshield/*.log $TMPDIR/shield 2>/dev/null
    cp /usr/local/ericomshield/*.yml $TMPDIR/shield 2>/dev/null
    cp /usr/local/ericomshield/*.txt $TMPDIR/shield 2>/dev/null
    cp /usr/local/ericomshield/backup/*.json $TMPDIR/shield 2>/dev/null
fi
echo " Done! "
echo

FILENAME="$(hostname)-$(date +'%Y-%m-%d_%H_%M_%S').tgz"
echo " Preparing the tar file: /tmp/$FILENAME "
tar czf /tmp/$FILENAME -C ${TMPDIR}/ .
rm -rf ${TMPDIR}

echo " Done! "
echo
echo "Created:"
ls -lah "/tmp/$FILENAME"
echo
echo "Please send this file /tmp/${FILENAME} to Ericom Support"
echo
