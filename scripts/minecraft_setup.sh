#!/bin/bash

source ./mc_env_vars

# Get local vars from env
INSTALL_DIR=$MC_INSTALL_DIR
BIN_DIR=$MC_BIN_DIR
S3_BUCKET=$S3_BUK

# Setup users and directories
useradd -m -d $INSTALL_DIR -s /bin/bash minecraft
mkdir $BIN_DIR

# Update python for pip and mark2
add-apt-repository -y ppa:jonathonf/python-2.7
apt-get update
apt-get install -y python2.7 wget git python-software-properties software-properties-common debconf-utils
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
python /tmp/get-pip.py

# Install necessary packages, ignore Java8 install prompts
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt-get install -y openjdk-8-jre

# Install awscli
pip install awscli

# Install minecraft jar and pull down conf and world
#wget -O $INSTALL_DIR/minecraft_server.jar https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar
wget -O $INSTALL_DIR/paperclip.jar https://papermc.io/ci/job/Paper-1.13/525/artifact/paperclip-525.jar
chown minecraft: /home/minecraft/*


aws s3 cp s3://sil-minecraft-backup/server.conf $INSTALL_DIR
aws s3 cp s3://$S3_BUCKET/world $INSTALL_DIR/world
