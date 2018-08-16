#!/bin/sh

/opt/xensource/bin/xapi-wait-init-complete 180
xe host-apply-edition edition=enterprise-per-socket license-server-address=10.12.246.11 license-server-port=27000

SERVER_IP=10.12.5.100
cd /tmp
mkdir ihotfix
cd ihotfix
wget "http://$SERVER_IP/upgrade/updates/updates.list"
hotfixes=`cat updates.list`
for hotfix in $hotfixes
do
wget "http://$SERVER_IP/upgrade/updates/$hotfix.iso"
hotfix_uuid=`xe update-upload file-name=$hotfix.iso 2>&1 | egrep -o [a-z0-9-]{36}`
host_uuid=`cat /etc/xensource-inventory | grep INSTALLATION_UUID | cut -d"'" -f2`
xe update-apply host=$host_uuid uuid=$hotfix_uuid
done
/usr/bin/rm -f /etc/systemd/system/multi-user.target.wants/postinstall.service
