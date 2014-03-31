# !/bin/bash -e
# uboot-set Bootloader Configuration Utility
# Version 1.2 for SDA based devices
# ===================================
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Soft"ware Foundation, either version 3 of the License, or
# (at your option) any later version.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# PLEASE NOTE: This script works with all chrome os devices that use
# the standard /dev/sda method of attaching the SSD/disk device. Samsung
# devices require specific scripts which are not currently ready.

CHROME="chrome"
UBUNTU="ubuntu"
INSTALL="install"
CROSINST="chromeinstall"
HELP="help"
DEV="developer"



if [ "$1" = $INSTALL ]
then
	echo "U-Boot Configuration Utility 1.2"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================="
	echo "Clearing old install"
	if [ -f /usr/bin/uboot-set ];
	then
		cp /usr/bin/uboot-set /usr/bin/uboot.bkp
		rm -rf /usr/bin/uboot-set
	echo "Installing..."
	sudo cp ./uboot-set-dev.sh /usr/bin/uboot-set
	echo "Install Complete!"

elif [ "$1" = $CROSINST ]
then
	echo "U-Boot Configuration Utility 1.2"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================"
	echo "This feature has not yet been implemented."
	echo "Please view the help file for more information"
	
elif [ "$1" = $UBUNTU ]
then
	echo "U-Boot Configuration Utility 1.2"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================"
    sudo cgpt add -i 6 -P 5 -S 1 /dev/sda
    echo "Next time you reboot, you will boot into Ubuntu"

elif [ "$1" = $CHROME ]	
then
	echo "U-Boot Configuration Utility 1.2"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================"		
	sudo cgpt add -i 6 -P 0 -S 1 /dev/sda
   	echo "Next time you reboot, you will boot into ChromeOS"
	

elif [ "$1" = $HELP ]
then
	echo "U-Boot Configuration Utility 1.2"
	echo "INTERNAL RELEASE ONLY"
	echo "================================================"
    echo "Designed by Alan Xenos and the Domisy Dev Team"
    echo "================================================"
    echo "uboot-set is a utility to set bootloader flags on Chrome OS devices"
    echo "Usage: uboot-set [flag]"
    echo "Flags to set bootloader:"
	echo "[chrome] to boot to ChromeOS"
	echo "[ubuntu] to boot to Ubuntu"
	echo "[reboot] to restart machine with selected settings"
	echo "Internal Operations"
	echo "[install] to install new binary/update binary"
	echo "[chromeinstall] to install to Chrome partition  -FOR FUTURE USE!"
	echo "[help] to display this screen"
        echo "[developer] to print developer build information"
elif [ "$1" = $DEV ]
then 
        echo "Unique Build ID: Q8YTAHP98"
        echo "Unique Build Phrase: Say my name, mister fahrenheit!"
        echo "Version: 1.21 Date Of Release: 31.3.2014"
        echo "NOT WARRANTED FOR PUBLIC USE"
else
	echo "No valid flags specified. Try uboot-set help"
fi
fi
