#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

if [ -z "$BRANCH" ]; then
    BRANCH="master"
fi
#BRANCH="Install-Staging"

# Development Repository: (Latest)
ES_repo_setup="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-setup.sh"
ES_repo_start="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/start.sh"
ES_repo_autoupdate="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/autoupdate.sh"
ES_repo_version="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/showversion.sh"
ES_repo_stop="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/stop.sh"
ES_repo_status="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/status.sh"
ES_repo_restart="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/restart.sh"
ES_repo_ip="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/show-my-ip.sh"
ES_repo_systemd_updater_service="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-updater.service"
ES_repo_sysctl_shield_conf="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/sysctl_shield.conf"
ES_repo_uninstall="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/uninstall.sh"
ES_repo_EULA="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/Ericom-EULA.txt"
ES_repo_addnodes="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/addnodes.sh"
ES_repo_shield_nodes="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/nodes.sh"
ES_repo_pre_check="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/shield-pre-install-check.sh"
ES_repo_shield_aliases="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/.shield_aliases"
ES_repo_restore="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/restore.sh"
ES_repo_update="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/update.sh"

# Production Version Repository: (Release)
ES_repo_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/shield-version.txt"
ES_repo_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose.yml"
ES_repo_swarm_sh="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/deploy-shield.sh"
# Staging Version Repository: (Staging)
ES_repo_staging_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/shield-version-staging.txt"
ES_repo_staging_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose_staging.yml"
# Development Version Repository: (Latest)
ES_repo_dev_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/shield-version-dev.txt"
ES_repo_dev_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose_dev.yml"
ES_repo_swarm_dev_sh="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/deployshield-dev.sh"

ES_repo_pocket_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose_pocket.yml"

