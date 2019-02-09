#!/bin/bash

# Set minecraft install dir
INSTALL_DIR=$MC_INSTALL_DIR}
BIN_DIR=$MC_BIN_DIR

function setup_new_install() {
    # Install mc.jar, pull config from S3, start server to generate files and world
    if [ ! -f $INSTALL_DIR/minecraft_server.jar ]; then
        wget -O $INSTALL_DIR/minecraft_server.jar https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar
    fi

    aws s3 cp s3://sil-minecraft-backup/server.conf $INSTALL_DIR

    sh $BIN_DIR/minecraft_start.sh
}

# Update python to latest
add-apt-repository -y ppa:jonathonf/python-2.7
apt-get update
apt-get install python2.7

# Install necessary packages
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java8-installer python-pip wget

pip install awscli

# Check S3 to see if 
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
# - pull server config from s3 (if it doesnt contain flag string?)
# - code check
