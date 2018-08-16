#!/bin/bash

IP=$1
if [ "x$IP" == "x" ];then
    echo "Please provide IP address"
    exit 1
fi

FILES="answerfile.xml updates/hotfix.sh updates/post_install.sh"

for f in $FILES
do
    sed -i "s/##IP##/${IP}/g" $f
done

echo "Done"
