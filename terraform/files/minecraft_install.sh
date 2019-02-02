#!/bin/bash

# Set minecraft install dir
INSTALL_DIR=/home/minecraft

# Install packages and updates
apt-get update
apt-get install -y aws-cli wget openjdk-8-jre-headless

# Setup Minecraft users/directories, pull last S3 backup
useradd minecraft

if [ ! -d $INSTALL_DIR ]; then
    mkdir $INSTALL_DIR
    chown minecraft: $INSTALL_DIR
fi

if [ ! -f $INSTALL_DIR/minecraft_server.jar ]; then
    wget -O $INSTALL_DIR/minecraft_server.jar https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar
fi

# Accept EULA if not already accepted
if [ ! -f $INSTALL_DIR/eula.txt ]; then
    echo "EULA not accepted. Running server to create file."
    
    $INSTALL_DIR/minecraft_run.sh
    echo "eula=true" > $INSTALL_DIR/eula.txt
fi

# TODO:
# - pull s3 backup
# - add correct minecraft configuration with server info
