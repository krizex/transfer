#!/bin/bash

IP=$1
if [ "x$IP" == "x" ];then
    echo "Please provide IP address"
    exit 1
fi

echo "Scripts will be installed..."

INSTALLED=""

for file in $(find scripts)
do
    if [ -d ${file} ]; then
        continue
    fi

    target_f="/${file#scripts/}"

    target_d=$(dirname  ${target_f})
    mkdir -p ${target_d}
    echo "Installing: ${target_f}"
    cp -f ${target_f} "${target_f}.bak"
    cp -f ${file} ${target_f}
    INSTALLED="${INSTALLED} ${target_f}"
done

echo "Configuring IP address in scripts..."

for f in ${INSTALLED}
do
    echo "=== changes of $f ==="
    sed -n -e "s/##IP##/${IP}/gp" $f
    sed -i "s/##IP##/${IP}/g" $f
done
