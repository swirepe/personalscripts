function unmount-scripts {
    sudo umount /tmp/ramdisk/bashincludes
    sudo umount /tmp/ramdisk/scripts
    sudo rm -r /tmp/ramdisk/bashincludes
    sudo rm -r /tmp/ramdisk/scripts

}
