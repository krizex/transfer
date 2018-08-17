#!/bin/bash

IP=$1
if [ "x$IP" == "x" ];then
    echo "Please provide IP address"
    exit 1
fi

FOLDER="/var/www/html/upgrade"

echo "Scripts will be installed to ${FOLDER}"

for file in $(find .)
do
    if [ "x${file}" == "x./install.sh" ];then
        continue
    fi

    if [ -d ${file} ]; then
        continue
    fi

    d=$(dirname  ${file})
    target_d="${FOLDER}/${d}"
    mkdir -p ${target_d}
    target_f="${FOLDER}/${file}"
    echo "Installing: ${target_f}"
    cp -f ${file} ${target_f}
done

echo "Configuring IP address in scripts:"

FILES="${FOLDER}/answerfile.xml ${FOLDER}/updates/hotfix.sh ${FOLDER}/updates/post_install.sh /var/lib/tftpboot/pxelinux.cfg/default"

for f in $FILES
do
    echo "=== changes of $f ==="
    sed -n -e "s/##IP##/${IP}/gp" $f
    sed -i "s/##IP##/${IP}/g" $f
done
