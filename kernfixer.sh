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

fi

