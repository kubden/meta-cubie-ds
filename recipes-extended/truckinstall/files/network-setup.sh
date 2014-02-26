#!/bin/sh

#------------------------------------------------------------------------------

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# get active mac address
MAC_ETH=`ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'`

REPLACE="hwaddress ether $MAC_ETH"
echo "Assigned MAC ADDRESS: $MAC_ETH"
sed "s|hwaddress ether xx|$REPLACE|g" ${SCRIPT_DIR}/interfaces.in > /etc/network/interfaces
