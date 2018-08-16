#!/bin/sh

set -x

cd $1

function fix_hostname
{
    host_name=$(cat etc/sysconfig/network | egrep ^HOSTNAME | awk -F = '{print $2}' | awk '{$1=$1;print}')

    if [ "x${host_name}" != "x" ]; then
        echo "${host_name}" > etc/hostname
    fi
}

fix_hostname

server_ip=##IPP##
first_boot_script_after_upgrade=root/first-boot-after-upgrade.sh
wget http://${server_ip}/upgrade/updates/hotfix.sh  -O ${first_boot_script_after_upgrade}
chmod 777 ${first_boot_script_after_upgrade}
post_install_service=etc/systemd/system/postinstall.service
cat > ${post_install_service} <<EOF
[Unit]
After=xapi.service

[Service]
ExecStart=/${first_boot_script_after_upgrade}

[Install]
WantedBy=multi-user.target
EOF
ln -s /${post_install_service} etc/systemd/system/multi-user.target.wants/postinstall.service

date > root/post-install-executed
