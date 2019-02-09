#!/bin/bash
INSTALL_DIR=$MC_INSTALL_DIR
MIN_MEM=$MC_JAVA_MIN_MEM
MAX_MEM=$MC_JAVA_MAX_MEM

java -Xms${MIN_MEM} -Xmx${MAX_MEM} -jar ${INSTALL_DIR}/minecraft_server.jar -o true
