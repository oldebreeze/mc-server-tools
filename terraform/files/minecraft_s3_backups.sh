#!/bin/bash

set -e

ACTION=$1
CUR_TIME=$(date +%Y%m%d-%H%M)
BAK_FILE=minecraft-backup.${CUR_TIME}.tar.gz
RES_FILE=minecraft-backup.tar.gz

# Copy backup file to s3, remove current latest, create new latest
function upload_to_s3() {
    aws s3 cp /tmp/${BAK_FILE} s3://sil-minecraft-backup/${BAK_FILE}
    aws s3 rm s3://sil-minecraft-backup/minecraft-backup.latest.tar.gz
    aws s3 cp s3://sil-minecraft-backup/${BAK_FILE} s3://sil-minecraft-backup/minecraft-backup.latest.tar.gz
}

# Zip the MC dir, call upload function, remove zip
function backup() {
    tar czvf /tmp/${BAK_FILE} /home/minecraft
    upload_to_s3
    rm -f /tmp/${BAK_FILE}
}

# Copy latest s3 zip to local disk, unzip to install dir, remove backup
function restore() {
    aws s3 cp s3://sil-minecraft-backup/minecraft-backup.latest.tar.gz /tmp/${RES_FILE}
    tar xzvf /tmp/${RES_FILE} /home/minecraft/
    rm -f /tmp/${RES_FILE}
}

if [ -z "$ACTION" ]; then
    echo "Must specify backup or restore when running."
    exit 1
elif [ "$ACTION" == "backup" ]
    backup
elif [ "$ACTION" == "restore" ]
    restore
else
    echo "How did you get here? Specify backup or restore when running."
    exit 1
fi
