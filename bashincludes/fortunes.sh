export FORTUNES_DIR="/usr/share/games/fortunes"
export FORTUNES_PERS_DIR="/home/swirepe/pers/quotes/fortunes_pers"


function load_fortunes {
    # load the fortune files into memory, if necessary
    if [[ -f "$TORAMDISK" ]]
    then
        if [[  -d "/tmp/ramdisk/fortunes" ]]
        then
           FORTUNES_DIR="/tmp/ramdisk/fortunes"
        else
            # report this in purple
           echo -e "\e[0;35m[fortunes.sh] Copying fortunes to memory.\e[0m"
           FORTUNES_DIR=$($TORAMDISK "$FORTUNES_DIR")
        fi
        
        if [[  -d "/tmp/ramdisk/fortunes_pers" ]]
        then
           FORTUNES_PERS_DIR="/tmp/ramdisk/fortunes_pers"
        else
            # report this in purple
           echo -e "\e[0;35m[fortunes.sh] Copying personal fortunes to memory.\e[0m"
           FORTUNES_PERS_DIR=$($TORAMDISK "$FORTUNES_PERS_DIR")
        fi
    fi
    
}


function unmount-fortunes {
    sudo umount /tmp/ramdisk/fortunes
    sudo umount /tmp/ramdisk/fortunes_pers    
    sudo rm -r /tmp/ramdisk/fortunes
    sudo rm -r /tmp/ramdisk/fortunes_pers   
}



## This part actually displays the fortunes
# load_fortunes

if [ ! -f ~/.hushlogin ]
then 
    echo -en $COLOR_White
    (probexit 0.1 && echo "Believe in yourself.") ||
	(probexit 0.3 && fortune -s "$FORTUNES_DIR" | fold -s) ||
	(probexit 0.3 && fortune "$FORTUNES_PERS_DIR" | fold -s)
    echo -en $COLOR_off
fi
