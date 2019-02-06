#!/bin/bash

# Set minecraft install dir
INSTALL_DIR=/home/minecraft

function setup_new_install() {
    # Install mc.jar, pull config from S3, start server to generate files and world
    if [ ! -f $INSTALL_DIR/minecraft_server.jar ]; then
        wget -O $INSTALL_DIR/minecraft_server.jar https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar
    fi

    aws s3 cp s3://sil-minecraft-backup/server

    sh $INSTALL_DIR/minecraft_start.sh
}

# Install packages and updates
apt-get update
apt-get install -y python-pip wget default-jre

pip install awscli

# Setup Minecraft users/directories, pull last S3 backup
useradd minecraft

if [ ! -d $INSTALL_DIR ]; then
    mkdir $INSTALL_DIR
    chown minecraft: $INSTALL_DIR
fi

bak_exists=$(aws s3 ls s3://sil-minecraft-backup/minecraft-backup.latest.tar.gz)
if [ -z "$bak_exists" ]; then
    echo "Backup not found, creating new installation."
    setup_new_install
else
    sh /home/minecraft/minecraft_s3_backups.sh restore
fi

# Accept EULA if not already accepted
if [ ! grep -q "eula=true" INSTALL_DIR/eula.txt ]; then
    echo "eula=true" > $INSTALL_DIR/eula.txt
fi

# Todo:
# - figure out what version of java is needed and how to get it installed on 14.04
# - pull server config from s3 (if it doesnt contain flag string?)
# - code check
