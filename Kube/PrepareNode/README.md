Tasks performed for Ubuntu 18.04:

1. Install Docker dependencies
1. Install the Docker repository
1. Install the latest Docker (daemons and CLI)
1. Disable swap in /etc/fstab
1. Install and load /etc/sysctl.d/30-ericom_shield_common.conf
 with common Shield sysctl values
1. Install a custom /etc/docker/daemon.json and enable Docker service in systemd
1. Add the user specified by the -u/--user option to the group docker
1. Install and disable firewalld
1. Reboot the server and execute apt autoremove.

Tasks performed for CentOS 7:

1. Install the ELRepo repository (http://elrepo.org/tiki/tiki-index.php)
1. Install the latest longterm kernel from the ELRepo repository
1. Install the EPEL repository
1. Install the Docker repository
1. Install the latest Docker and related dependencies
1. Disable swap in /etc/fstab
1. Install and load /etc/modules-load.d/30-ericom-shield.conf with a list of required kernel modules
1. Install and load /etc/sysctl.d/30-ericom_shield_CentOS-7.conf with CentOS-specific sysctl values
1. Install and load /etc/sysctl.d/30-ericom_shield_common.conf
 with common Shield sysctl values
1. Install a custom /etc/docker/daemon.json and enable Docker service in systemd
1. Add the user specified by the -u/--user option to the group docker
1. Install and disable firewalld
1. Reboot the server and remove old kernels.
