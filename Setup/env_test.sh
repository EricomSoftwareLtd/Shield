#!/usr/bin/sudo /bin/bash

LOGFILE="${LOGFILE:-./env_test.log}"
URLS_TO_CHECK='http://www.google.com/ https://www.google.com/ http://www.ericom.com/ https://www.ericom.com/ https://hub.docker.com/'
SHIELD_NETWORK_ADDR_BLOCK='10.20.0.0/16'

if ! declare -f log_message >/dev/null; then
    function log_message() {
        echo "$1"
        echo "$(date): $1" >>"$LOGFILE"
    }
fi

if ! declare -f failed_to_install >/dev/null; then
    function failed_to_install() {
        log_message "An error occured during the installation: $1, Exiting!"
        exit 1
    }
fi

function check_url_connectivity() {
    printf "\nChecking $1 ..."
    if ! curl "$1" -sS -o /dev/null -w "\nResponse Code: %{http_code}\nDNS time: %{time_namelookup}\nConnection time: %{time_connect}\nPretransfer time: %{time_pretransfer}\nStarttransfer time: %{time_starttransfer}\nTotal time: %{time_total}\n"; then
        printf "$1 check failed"
        return 1
    fi
}

function check_connectivity() {
    for url in $URLS_TO_CHECK; do
        if ! check_url_connectivity "$url"; then
            echo "Connectivity test failed for $url"
            return 1
        fi
    done
}

function check_storage_drive_speed() {
    /sbin/hdparm -Tt $(df -l --output=source /var/lib | awk 'FNR == 2 {print $1}')
}

function check_free_space() {
    local FREE_SPACE_ON_ROOT=$(($(stat -f --format="%a*%S" /) / (1024 * 1024 * 1024)))
    local FREE_SPACE_ON_DEB=$(($(stat -f --format="%a*%S" /var/cache/debconf) / (1024 * 1024 * 1024)))
    if ((FREE_SPACE_ON_ROOT < MIN_FREE_SPACE_GB)); then
        failed_to_install "Not enough free space on the / partition. ${FREE_SPACE_ON_ROOT}GB available, ${MIN_FREE_SPACE_GB}GB required."
    fi
    if ((FREE_SPACE_ON_DEB < MIN_FREE_SPACE_GB)); then
        failed_to_install "Not enough free space on the /var/cache/debconf partition. ${FREE_SPACE_ON_DEB}GB available, ${MIN_FREE_SPACE_GB}GB required."
    fi
}

function check_network_address_conflicts() {
    local INTERFACES=($(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f\n'))
    local INTERFACE_ADDRESSES=()

    for IFACE in "${INTERFACES[@]}"; do
        INTERFACE_ADDRESSES+=("$(/sbin/ip address show scope global dev $IFACE | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+')")
    done

    for IF_ADDR in "${INTERFACE_ADDRESSES[@]}"; do
        /usr/bin/python3 <<END
import ipcalc

if ipcalc.Network("${SHIELD_NETWORK_ADDR_BLOCK}").check_collision(ipcalc.IP("${IF_ADDR}")) :
    print("Address collision detected: ${IF_ADDR} collides with ${SHIELD_NETWORK_ADDR_BLOCK} used by Shield")
END
    done

}

function perform_env_test() {
    set -e

    if [ "$ES_INTERACTIVE" == true ] && [ "$(dpkg -l | grep -w -c speedtest-cli)" -eq 0 ]; then
        echo "***************     Installing speedtest-cli"
        apt-get --assume-yes -y install speedtest-cli
    fi

    if [ "$ES_INTERACTIVE" == true ] && [ "$(dpkg -l | grep -w -c hdparm)" -eq 0 ]; then
        echo "***************     Installing hdparm"
        apt-get --assume-yes -y install hdparm
    fi

    check_free_space

    log_message "Checking Internet connectivity..."
    log_message "$(check_connectivity 2>&1)"

    echo ""

    log_message "Checking Internet speed..."
    # Perform Internet connection speed test
    /usr/bin/speedtest-cli 2>&1 | tee -a "$LOGFILE"

    echo ""

    log_message "Checking storage drive speed..."
    log_message "$(check_storage_drive_speed 2>&1)"

    echo ""

    log_message "Checking network address conflicts..."
    check_network_address_conflicts
}

if ! [[ $0 != "$BASH_SOURCE" ]]; then
    perform_env_test
fi
