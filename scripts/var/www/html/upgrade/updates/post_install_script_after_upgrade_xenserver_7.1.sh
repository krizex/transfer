#!/bin/bash
HOSTNAME=`cat /etc/hostname`
host_uuid=`xe host-list --minimal name-label=$HOSTNAME`
echo $host_uuid

localstorage=`xe sr-list --minimal name-description=Cloud\ Stack\ Local\ LVM\ Storage\ Pool\ for\ $host_uuid`
echo $localstorage
#lvcreate VG_XenStorage-$localstorage -n LogLV -L 100G --config global{metadata_read_only=0} <<EOF
#y
#EOF
#mkfs.ext3 /dev/VG_XenStorage-$localstorage/LogLV

lvchange -a y /dev/VG_XenStorage-$localstorage/LogLV

service rsyslog stop
mkdir /tmp_log
mv /var/log/* /tmp_log/
mount /dev/VG_XenStorage-$localstorage/LogLV /var/log
mv /tmp_log/* /var/log/
service rsyslog start
rm -rf /tmp_log

cat <<SHEOF >> /etc/rc3.d/S02loglv
#!/bin/bash
lvchange -a y /dev/VG_XenStorage-$localstorage/LogLV
SHEOF

chmod a+x /etc/rc3.d/S02loglv

