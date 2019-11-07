#!/bin/sh -e

echo "Disabling swap"
swapoff -a
echo "Removing swap partition, original fstab file could be found at /etc/fstab.bak"
sed -i.bak '/swap/ s/^#*/#/' /etc/fstab

ES_SYSCTL_FILE="/etc/sysctl.d/30-ericom-shield.conf"
ES_MOD_LOAD_FILE="/etc/modules-load.d/30-ericom-shield.conf"

update_sysctl() {
    cat - >"$ES_SYSCTL_FILE"
    echo "$ES_SYSCTL_FILE has been updated!"

    if [ -f /etc/redhat-release ]; then
        echo "br_netfilter" >"$ES_MOD_LOAD_FILE"
        systemctl restart systemd-modules-load.service

        cat >>"$ES_SYSCTL_FILE" <<EOF

net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1

# increase user namespaces
user.max_user_namespaces=30405

# increase min free space to 2GB
vm.min_free_kbytes=2048000

EOF
    fi

    # apply the values
    sysctl --load="$ES_SYSCTL_FILE" >/dev/null 2>&1
    echo "Values from $ES_SYSCTL_FILE have been applied!"
}

update_sysctl <<EOF
#Recommended sysctl settings for EricomShield

#Changes for try increase docker performance.
#Increase number of open files
fs.file-max = 10000000

#Increase max number of processes
kernel.pid_max = 1000000

# Have a larger connection range available
net.ipv4.ip_local_port_range=1024 65000

# Reuse closed sockets faster
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_fin_timeout=15

# The maximum number of "backlogged sockets".  Default is 128.
net.core.somaxconn=4096
net.core.netdev_max_backlog=4096

# 16MB per socket - which sounds like a lot,
# but will virtually never consume that much.
net.core.rmem_max=16777216
net.core.wmem_max=16777216

# Various network tunables
net.ipv4.tcp_max_syn_backlog=20480
net.ipv4.tcp_max_tw_buckets=400000
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_syn_retries=2
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_wmem=4096 65536 16777216

net.ipv4.conf.all.rp_filter=1

# By default, traffic from containers connected to the default bridge network
# is not forwarded to the outside world. Enable forwarding.
net.ipv4.conf.all.forwarding=1

#vm.min_free_kbytes=65536

# Connection tracking to prevent dropped connections (usually issue on LBs)
#net.netfilter.nf_conntrack_max=262144
#net.ipv4.netfilter.ip_conntrack_generic_timeout=120
#net.netfilter.nf_conntrack_tcp_timeout_established=86400

# ARP cache settings for a highly loaded docker swarm
net.ipv4.neigh.default.gc_thresh1=8096
net.ipv4.neigh.default.gc_thresh2=12288
net.ipv4.neigh.default.gc_thresh3=16384

#increase memory lock for elasticsearch 5
vm.max_map_count=262144

# Fixes the "fluent-bit-config 17 [2019/10/04 12:55:27] 
# [error] [plugins/in_tail/tail_fs.c:169 errno=24] Too many open files" - type
# errors

fs.inotify.max_user_instances=1024

EOF
