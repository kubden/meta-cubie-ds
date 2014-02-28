#!/bin/sh

#------------------------------------------------------------------------------
#assign input and output params

inputFile=$1
outputFile=$2

SCRIPT_DIR=$PWD

# get active mac address
MAC_ETH=`ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'`

REPLACE="hwaddress ether $MAC_ETH"
echo "Assigned MAC ADDRESS: $MAC_ETH"
sed "s|hwaddress ether xx|$REPLACE|g" $inputFile > $outputFile
