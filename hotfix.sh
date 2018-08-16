#!/bin/sh

/opt/xensource/bin/xapi-wait-init-complete 180
#xe host-apply-edition edition=enterprise-per-socket license-server-address=10.12.246.11 license-server-port=27000

server_ip=$1
hotfix_dir=/tmp/ihotfix
mkdir -p ${hotfix_dir}
cd ${hotfix_dif}

host_uuid=`cat /etc/xensource-inventory | grep INSTALLATION_UUID | cut -d"'" -f2`
wget "http://${server_ip}/upgrade/updates/updates.list"
for hotfix in $(cat updates.list)
do
    wget "http://${server_ip}/upgrade/updates/${hotfix}.iso"
    hotfix_uuid=`xe update-upload file-name=${hotfix}.iso 2>&1 | egrep -o [a-z0-9-]{36}`
    xe update-apply host=${host_uuid} uuid=${hotfix_uuid}
done
/usr/bin/rm -f /etc/systemd/system/multi-user.target.wants/postinstall.service
