!/bin/sh -e
# uboot-set Bootloader Configuration Utility
# Version 1.67 for ChromeOS Devices
# ===================================
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Soft"ware Foundation, either version 3 of the License, or
# (at your option) any later version.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

CHROME="chrome"
UBUNTU="ubuntu"
INSTALL="install"
CROSINST="chromeinstall"
HELP="help"



if [ "$1" = $INSTALL ]
then
	echo "U-Boot Configuration Utility 1.1update1"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================"
	echo "Clearing old install, prepping directories"
	sudo rm /usr/bin/uboot-set
	sudo rm /usr/bin/uboot-set.bkp
	echo "Installing..."
	sudo cp ./uboot-set.sh /usr/bin/uboot-set
	echo "Install Complete!"

elif [ "$1" = $CROSINST ]
then
	echo "U-Boot Configuration Utility 1.1update1"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================"
	echo "This feature has not yet been implemented."

elif [ "$1" = $UBUNTU ]
then
	echo "U-Boot Configuration Utility 1.1update1"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================"
    sudo cgpt add -i 6 -P 5 -S 1 /dev/sda
    echo "Next time you reboot, you will boot into Ubuntu"

elif [ "$1" = $CHROME ]	
then
	echo "U-Boot Configuration Utility 1.1update1"
	echo "INTERNAL RELEASE ONLY"
	echo "========================================"		
	sudo cgpt add -i 6 -P 0 -S 1 /dev/sda
   	echo "Next time you reboot, you will boot into ChromeOS"
	

elif [ "$1" = $HELP ]
then
	echo "U-Boot Configuration Utility 1.1update1"
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
	echo "[chromeinstall] to install to Chrome partition"
	echo "[help] to display this screen"
else
	echo "No valid flags specified. Try uboot-set help"
fi
