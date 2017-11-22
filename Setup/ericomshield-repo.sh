#!/bin/bash
############################################
#####   Ericom Shield Installer        #####
#######################################BH###

BRANCH="master"
#BRANCH="Install-Staging"

# Development Repository: (Latest)
ES_repo_setup="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-setup.sh"
ES_repo_run="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/run.sh"
ES_repo_update="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/autoupdate.sh"
ES_repo_version="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/showversion.sh"
ES_repo_stop="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/stop.sh"
ES_repo_status="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/status.sh"
ES_repo_service="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield"
ES_repo_ip="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/show-my-ip.sh"
ES_repo_systemd_service="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield.service"
ES_repo_systemd_updater_service="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-updater.service"
ES_repo_sysctl_shield_conf="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/sysctl_shield.conf"
ES_repo_uninstall="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/ericomshield-uninstall.sh"
ES_repo_EULA="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/Ericom-EULA.txt"
ES_repo_setup_node="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/SetupNode/ericomshield-setup-node.sh"

# Production Version Repository: (Release)
ES_repo_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/shield-version.txt"
# Staging Version Repository: (Staging)
ES_repo_staging_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/shield-version-staging.txt"
# Development Version Repository: (Latest)
ES_repo_dev_ver="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/shield-version-dev.txt"

# Production Repository: (Release)
ES_repo_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose.yml"
ES_repo_staging_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose_staging.yml"
ES_repo_dev_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose_dev.yml"
ES_repo_pocket_yml="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/docker-compose_pocket.yml"
ES_repo_swarm_sh="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/deploy-shield.sh"
ES_repo_swarm_dev_sh="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/$BRANCH/Setup/deployshield-dev.sh"
