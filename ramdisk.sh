#!/bin/bash
# ramdisk.sh

#  A "ramdisk" is a segment of system RAM memory
#+ which acts as if it were a filesystem.
#  Its advantage is very fast access (read/write time).
#  Disadvantages: volatility, loss of data on reboot or powerdown, less RAM available to system.
#  Of what use is a ramdisk?
#  Keeping a large dataset, such as a table or dictionary on ramdisk,
#+ speeds up data lookup, since memory access is much faster than disk access.


E_NON_ROOT_USER=70             # Must run as root.
ROOTUSER_NAME=root
MOUNTPT=/mnt/ramdisk           # IF not created will be created downlevel
SIZE=2000                      # 2000 Blocks in Device
BLOCKSIZE=1024                 # 1K block size
DEVICE=/dev/ram0               # First ramdisk device

## FOR CONFIGURATION = ONLY ALTER ABOVE THIS LINE ##

CRV=$?
CLEANEXIT=0
username=`id -nu`

if [ "$username" != "$ROOTUSER_NAME" ]
then
  echo "Must be root to run \"`basename $0`\"."
  exit $E_NON_ROOT_USER
fi

if [ ! -d "$MOUNTPT" ]         #  Test whether mount point already there,
then                           #+ so no error if this script is run
  mkdir $MOUNTPT               #+ multiple times.
fi

dd if=/dev/zero of=$DEVICE count=$SIZE bs=$BLOCKSIZE  # Zero out RAM device
##Why Is This Needed - cmauk 3.30.2013
#Why do we need to keep this here? Zeroing-out lowers performance on SSD's due to poor flushing.
#aferx 3.31.2013 Sets the size of the image to store in RAM - prevents insane growth on SQL servers.

mke2fs $DEVICE                 
mount $DEVICE $MOUNTPT         
chmod 777 $MOUNTPT
##test if the script worked, if not exit while printing everything
touch /mnt/ramdisk/bullshit

if [ "CRV" != "CLEANEXIT" ]
then
	echo "An error occured while attempting to access the ramdisk. Error logs are printed above"
	exit 120
fi	

echo "\"$MOUNTPT\" now available for use."
# The ramdisk is now accessible for storing files, even by an ordinary user.
#  Caution, the ramdisk is volatile, and its contents will disappear
#+ on reboot or power loss.
#  Copy anything you want saved to a regular directory.
# After reboot, run this script to again set up ramdisk.
# Remounting /mnt/ramdisk without the other steps will not work.
#  Suitably modified, this script can by invoked in /etc/rc.d/rc.local,
#+ to set up ramdisk automatically at bootup.
#  That may be appropriate on, for example, a database server.

exit 0