#!/bin/bash

aws s3 cp s3://sil-minecraft-backup/server.conf $INSTALL_DIR
aws s3 cp s3://$S3_BUCKET/world $INSTALL_DIR/world
