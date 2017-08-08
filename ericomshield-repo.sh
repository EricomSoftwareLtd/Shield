#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

BRANCH="master"
#BRANCH="BenyH-patch-1"

# Development Repository: (Latest)
ES_repo_setup="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/ericomshield-setup.sh"
ES_repo_run="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/run.sh"
ES_repo_update="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/autoupdate.sh"
ES_repo_version="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/showversion.sh"
ES_repo_stop="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/stop.sh"
ES_repo_status="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/status.sh"
ES_repo_service="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/ericomshield"
ES_repo_ip="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/show-my-ip.sh"
ES_repo_systemd_service="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/ericomshield.service"
ES_repo_systemd_service_swarm="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/ericomshield.service.swarm"
ES_repo_systemd_updater_service="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/ericomshield-updater.service"
ES_repo_sysctl_shield_conf="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/sysctl_shield.conf"


# Production Version Repository: (Release)
ES_repo_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/shield-version.txt"
# Development Version Repository: (Latest)
ES_repo_dev_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/shield-version-dev.txt"

# Production Repository: (Release)
ES_repo_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/docker-compose.yml"
ES_repo_dev_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/docker-compose_dev.yml"
ES_repo_pocket_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/docker-compose_pocket.yml"
ES_repo_swarm_sh="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/deploy-shield.sh"
