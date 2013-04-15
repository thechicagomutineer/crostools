README file for uboot-set
Version 1.1-update6
April 9 2013
==
TABLE OF CONTENTS
==
1 Introduction

1.1 How To Install (Ubuntu)

1.2 How To Install (Chrome/Chromium)

2 Functions

2.1 From Command Line

2.2 Automatic Update

2.3 Invoke at Boot

3 License Information

4 Detailed Release Information

1 Introduction
==
1.1 How to Install under Ubuntu:
--
To install in Ubuntu, the recommended method is to clone the repository, and use the builtin
"uboot-set install" function. To do this, run the following from a root terminal.

git clone "git://github.com/alanthemanofchicago/crostools.git"
cd crostools
chmod +x ./uboot-set-dev.sh
./uboot-set-dev.sh install

and allow the script to finish installation. 

1.2 Install on Chrome:
--
This requires Developer Mode to be enabled, as well as full read/write access to your Chrome partition.
For instructions about how to enter Developer Mode, see 
http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices
and select your device out of the list. To enable read-write access to the root partition, after
enabling developer mode press [Ctrl] + [Alt] + [T] after configuring your account. Type "shell" 
in the crosh window, and enter "sudo /usr/share/vboot/bin/make_dev_ssd.sh --remove_rootfs_verification"
You will be told to add a switch to the end, such as "--partitions 2", to ensure that you are certain 
you want to do this. After another reboot, you will be ready. Then, run "bash ./uboot-set-dev.sh install"
and allow the binary to install itself.

2 Functions
==

2.1 From Command Line
--
Uboot-set contains an array of commands for administering your Chrome OS device.
Type chrome to set boot to ChromeOS partition on next boot, ditto for Ubuntu.
Install installs the binary to /usr/bin, update does the same while wiping the old version.
