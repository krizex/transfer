#!/bin/sh

set -x

root=$1

function fix_hostname
{
    host_name=$(cat ${root}/etc/sysconfig/network | egrep ^HOSTNAME | awk -F = '{print $2}' | awk '{$1=$1;print}')

    if [ "x${host_name}" != "x" ]; then
        echo "${host_name}" > ${root}/etc/hostname
    fi
}

fix_hostname

SERVER_IP=10.12.5.100
touch ${root}/root/post-executed
wget http://$SERVER_IP/upgrade/updates/hotfix.sh  -O ${root}/root/first-boot-script.sh
chmod 777 ${root}/root/first-boot-script.sh
touch ${root}/etc/systemd/system/postinstall.service
chmod 777 ${root}/etc/systemd/system/postinstall.service
cat > ${root}/etc/systemd/system/postinstall.service <<EOF
[Unit]
After=xapi.service

[Service]
ExecStart=/root/first-boot-script.sh

[Install]
WantedBy=multi-user.target
EOF
ln -s /etc/systemd/system/postinstall.service ${root}/etc/systemd/system/multi-user.target.wants/postinstall.service
