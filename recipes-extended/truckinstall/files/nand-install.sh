#!/bin/sh

##------------------------------------------------------------------------------
##  Script for cubietruck:
##
##  Expected input Data:
##
##  Data in folder /home/root/Data
##    uImage
##    bootpartition.tar.gz
##    root.tar.gz
##
##  This script creates two partitions on the nand flash of the cubietruck board. 
##  The first partition is formatted as vfat. 
##    It contains the u-boot loader and the uImage. 
##
##  The second partition is formatted as ext4.
##    It contains the root filesystem. 
##
##  Data on the SD-Card:
##  The required data needs to be stored in the /home/root/Data folder:
##   bootpartition.tar.gz: cubietruck closed source and u-boot, uEnv.txt,..
##   uImage: the linux uImage
##   root.tar.gz: the linux root file system
##
##  When the flash process has terminated, all leds on the board will go off.
##
##------------------------------------------------------------------------------

## definition of directories
DATADIR=/home/root/Data/
SCRIPTDIR=/home/root/Script/
MOUNTDIR=/mnt/

## needed files
BOOT=bootpartition.tar.gz
UIMG=uImage
ROOTFS=root.tar.gz

if [ ! -f ${DATADIR}${BOOT} -o ! -f ${DATADIR}${UIMG} -o ! -f ${DATADIR}${ROOTFS} ]; then
  clear
  echo "------------------------------------------------------------------------------"
  echo "not all needed files exist"
  echo "check ${DATADIR}${BOOT}"
  echo "      ${DATADIR}${UIMG}"
  echo "      ${DATADIR}${ROOTFS}"
  echo "------------------------------------------------------------------------------"
  exit 1
fi

# Check if user is root
if [ $(id -u) != "0" ]; then
echo "Error: You must be root to run this script."
    exit 1
fi

exec 2>/dev/null
umount ${MOUNTDIR}
exec 2>&1

clear
echo "------------------------------------------------------------------------------"
echo "

W A R N I N G !!!

This script will NUKE / erase your NAND partition and copy content of SD card to it

"
echo -n "Proceed (y/n)? (default: y): 

"
echo "------------------------------------------------------------------------------"
read nandinst

if [ "$nandinst" == "n" ]
then
exit 0
fi

#------------------------------------------------------------------------------
echo "Partitioning NAND ..."
(echo y;) | nand-part -f a20 /dev/nand 32768 'bootloader 32768' 'rootfs 0' >> /dev/null || true
echo "Partitioning NAND ... DONE"
echo "------------------------------------------------------------------------------"

#------------------------------------------------------------------------------
echo "Formatting and optimizing NAND rootfs ... up to 30 sec"
mkfs.vfat /dev/nanda >> /dev/null
# ubifs does not make sense, since A20 implements wear leveling on hw.
mkfs.ext4 /dev/nandb >> /dev/null
tune2fs -o journal_data_writeback /dev/nandb >> /dev/null
tune2fs -O ^has_journal /dev/nandb >> /dev/null
e2fsck -f /dev/nandb
echo "Formatting and optimizing NAND rootfs ... DONE"
echo "------------------------------------------------------------------------------"

#------------------------------------------------------------------------------
echo "Creating NAND bootfs ... few seconds"
mount /dev/nanda ${MOUNTDIR}
tar -zxvf ${DATADIR}${BOOT} -C ${MOUNTDIR} >> /dev/null

cp ${DATADIR}${UIMG} ${MOUNTDIR}
umount ${MOUNTDIR}
echo "Creating NAND bootfs ... DONE"
echo "------------------------------------------------------------------------------"

#------------------------------------------------------------------------------
echo "Creating NAND rootfs ... up to 5 min"
mount /dev/nandb ${MOUNTDIR}
tar -zxvf ${DATADIR}${ROOTFS} -C ${MOUNTDIR} >> /dev/null

## assumption...
./network-setup.sh interfaces.in ${MOUNTDIR}/etc/network/interfaces

umount ${MOUNTDIR}
echo "Creating NAND rootfs ... DONE"
echo "------------------------------------------------------------------------------"

#------------------------------------------------------------------------------

echo "All done."
echo ""
echo "Press a key to power off."
echo "Then wait till all leds turn off."
echo "Remove SD and boot from NAND"
read konec
poweroff
