#!/bin/bash

# Author: Amith Koujalgi

# Ensure you have placed the credentials file (server.cfg) in your home directory with the foloowing structure:
#
# KEYFILE=/path/to/serverkey/file
# DEST_PATH=/path/to/remote/dir
# AWS_USERNAME=<remote username>
# AWS_IP=<remote host's IP address>
#
# Save the above params in /home/<user>/server.cfg and run this script.

CFG_FILE=`eval echo ~$USER/server.cfg`

if [ $# -lt 1 ]; then
    echo "No source file specified. Terminating..."
    echo "Usage: sh push.sh <srcfilepath>"
    exit
fi

  echo ""
  echo "---------------------------------------------------"
  echo "*                FILE PUSH UTIL                    *"
  echo "---------------------------------------------------"
  echo ""

KEYFILE=""
AWS_USERNAME=""
AWS_IP=""
SRC_FILE=$1
DEST_PATH=""

checkIfCfgFileExists(){
    if [ ! -f "$CFG_FILE" ]; then
        echo "Config file not found. Terminating..."
        exit
    else
        echo "Config file found: $CFG_FILE"
    fi
}

checkIfSrcFileExists(){
    if [ ! -f "$SRC_FILE" ]; then
        echo "Source file '$SRC_FILE' not found. Terminating..."
        exit
    else
        echo "Source file found: $SRC_FILE"
    fi
}

getProperties(){
    REPLACE=""
    KEYFILE=`grep $CFG_FILE -e "KEYFILE=" | sed -e "s/KEYFILE=/$REPLACE/g"`
    AWS_IP=`grep $CFG_FILE -e "AWS_IP=" | sed -e "s/AWS_IP=/$REPLACE/g"`
    DEST_PATH=`grep $CFG_FILE -e "DEST_PATH=" | sed -e "s/DEST_PATH=/$REPLACE/g"`
    AWS_USERNAME=`grep $CFG_FILE -e "AWS_USERNAME=" | sed -e "s/AWS_USERNAME=/$REPLACE/g"`
    echo "---------------------------------------------------"
    echo "AWS_IP=$AWS_IP"
    echo "AWS_USERNAME=$AWS_USERNAME"
    echo "SRC_FILE=$SRC_FILE"
    echo "DEST_PATH=$DEST_PATH"
    echo "---------------------------------------------------"
}

checkIfSrcFileExists
checkIfCfgFileExists
getProperties

ssh -i $KEYFILE $AWS_USERNAME@$AWS_IP "mkdir -p $DEST_PATH"

TARGET_FILE=`basename $1`
DESTFILE=$DEST_PATH/$TARGET_FILE

echo "Pushing local file '$SRC_FILE' to remote location '$DESTFILE' of server $AWS_IP..." 

scp -i $KEYFILE $SRC_FILE $AWS_USERNAME@$AWS_IP:$DESTFILE
