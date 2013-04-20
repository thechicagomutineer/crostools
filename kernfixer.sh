# fw_type will always be developer for Mario.
# Alex and ZGB need the developer BIOS installed though.
fw_type="`crossystem mainfw_type`"
if [ ! "$fw_type" = "developer" ]
  then
    echo -e "\nYou're Chromebook is not running a developer BIOS!"
    echo -e "You need to run:"
    echo -e ""
    echo -e "sudo chromeos-firmwareupdate --mode=todev"
    echo -e ""
    echo -e "and then re-run this script."
    return
  else
    echo -e "\nOh good. You're running a developer BIOS...\n"
fi

# hwid lets us know if this is a Mario (Cr-48), Alex (Samsung Series 5), ZGB (Acer), etc
hwid="`crossystem hwid`"

echo -e "Chome OS model is: $hwid\n"

chromebook_arch="`uname -m`"
if [ ! "$chromebook_arch" = "x86_64" ]
then
  echo -e "This version of Chrome OS isn't 64-bit. We'll use an unofficial Chromium OS kernel to get around this...\n"
else
  echo -e "and you're running a 64-bit version of Chrome OS! That's just dandy!\n"
fi

read -p "Press [Enter] to continue..."

powerd_status="`initctl status powerd`"
if [ ! "$powerd_status" = "powerd stop/waiting" ]
then
  echo -e "Stopping powerd to keep display from timing out..."
  initctl stop powerd
fi

powerm_status="`initctl status powerm`"
if [ ! "$powerm_status" = "powerm stop/waiting" ]
then
  echo -e "Stopping powerm to keep display from timing out..."
  initctl stop powerm
fi

setterm -blank 0

#Mount Ubuntu rootfs and copy cgpt + modules over
echo "Copying modules, firmware and binaries to ${target_rootfs} for ChrUbuntu"
if [ ! -d /tmp/urfs ]
then
  mkdir /tmp/urfs
fi
mount -t ext4 /dev/sda7 /tmp/urfs
cp /usr/bin/cgpt /tmp/urfs/usr/bin/
chmod a+rx /tmp/urfs/usr/bin/cgpt

echo "console=tty1 debug verbose root=/dev/sda7 rootwait rw lsm.module_locking=0" > kernel-config
if [ "$chromebook_arch" = "x86_64" ]  # We'll use the official Chrome OS kernel if it's x64
then
  cp -ar /lib/modules/* /tmp/urfs/lib/modules/
  vbutil_kernel --pack newkern \
    --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
    --version 1 \
    --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk \
    --config kernel-config \
    --vmlinuz /boot/vmlinuz-`uname -r`
  use_kernfs=newkern
else # Otherwise we'll download a custom-built non-official Chromium OS kernel
  model="mario" # set a default
  if [[ $hwid =~ .*MARIO.* ]]
  then
    model="mario"
  else
    if [[ $hwid =~ .*ALEX.* ]]
    then
      model="alex"
    else
      if [[ $hwid =~ .*ZGB.* ]]
      then
        model="zgb"
      fi
    fi
  fi
  wget http://cr-48-ubuntu.googlecode.com/files/$model-x64-modules.tar.bz2
  wget http://cr-48-ubuntu.googlecode.com/files/$model-x64-kernel-partition.bz2
  bunzip2 $model-x64-kernel-partition.bz2
  use_kernfs="$model-x64-kernel-partition"
  vbutil_kernel --repack $use_kernfs \
    --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
    --version 1 \
    --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk \
    --config kernel-config
  tar xjvvf $model-x64-modules.tar.bz2 --directory /tmp/urfs/lib/modules
fi
umount /tmp/urfs

dd if=$use_kernfs of=${target_kern}

#Set Ubuntu partition as top priority for next boot
cgpt add -i 6 -P 5 -T 1 ${target_disk}
