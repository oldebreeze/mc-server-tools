#!/usr/bin/env python

import os, time

import boto3
import boto3.s3
import tarfile

MC_CURRENT_BUCKET = 'sil-minecraft-current'
MC_BACKUP_BUCKET = 'sil-minecraft-backup'
BACKUP_LOC = "/tmp/"

# Function to set backup file names
def create_s3_key()
    cur_time = time.strftime("%Y%m%d%H%M%S")
    backup_name = "mc-server" + cur_time + "tar.gz"
    return backup_name

# Function to tarball server directory and stamp with current date
def tarball_server(backup_name, mc_dir="/etc/minecraft")
    backup_file = BACKUP_LOC + backup_name
    
    tar = tarfile.open(backup_name, "w:gz")
    tar.add(mc_dir, arcname="minecraft")
    tar.close()

    return backup_file

# Function to upload file to S3 as new current image
def upload_tarball(key_name)
    backup_path = tarball_server(key_name)
    s3conn = boto3.client('s3')
    s3.meta.client.upload_file(backup_path, MC_CURRENT_BUCKET, key_name)

# Function to move old current file to backup folder


# Meat and potatoes
s3_key = create_s3_key()
upload_tarball(s3_key)
