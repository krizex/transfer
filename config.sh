#!/bin/bash

IP=$1
if [ "x$IP" == "x" ];then
    echo "Please provide IP address"
    exit 1
fi

echo "Configuring IP address in scripts:"

FILES="answerfile.xml updates/hotfix.sh updates/post_install.sh"

for f in $FILES
do
    echo "=== changes of $f ==="
    sed -n -e "s/##IP##/${IP}/gp" $f
    sed -i "s/##IP##/${IP}/g" $f
done
