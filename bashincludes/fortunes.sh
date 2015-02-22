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


# load_fortunes

## This part actually displays the fortunes
# load_fortunes

## get the built-in fortunes:
# sudo apt-get install fortune-mod fortunes-off
if [ ! -f ~/.hushlogin ]
then

		if [[ "$(date)" == *"Jan 18"* ]]
		then
			if [[ ! -z "$(which toilet)" ]]
			then
				toilet --gay happy birthday!
			else
				echo Happy Birthday!
			fi
		fi


    if [ -f ~/.bashrc_sfwfortunes ]
    then
        
        ## display a random paper from arxiv.org
        ## https://github.com/swirepe/arXiv-fortunes
        if [ $[ ( $RANDOM % 100 ) ] -lt  40 ]
        then
            fortune ~/.arxiv
        fi
                
    else
    
        echo -en $COLOR_White
        # default: believe in yourself
        (probexit 0.1 && echo "Believe in yourself.") ||
				# a new default: Lori Deshene
				(probexit 0.1 && echo "We can't hate ourselves into a version of ourselves we can love." ) ||
        # short
        (probexit 0.3 && fortune -s "$FORTUNES_DIR" | fold -s) ||
        (probexit 0.3 && fortune -s "$FORTUNES_PERS_DIR" | fold -s) ||
        # long
        (probexit 0.1 && fortune  "$FORTUNES_DIR" | fold -s) ||
        (probexit 0.1 && fortune  "$FORTUNES_PERS_DIR" | fold -s) ||
        # short offensive
        (probexit 0.1 && fortune -s -o "$FORTUNES_DIR" | fold -s) ||
        (probexit 0.1 && fortune -s -o "$FORTUNES_PERS_DIR" | fold -s) ||
        # long offensive
        (probexit 0.1 && fortune -o "$FORTUNES_DIR" | fold -s) ||
        (probexit 0.1 && fortune -o "$FORTUNES_PERS_DIR" | fold -s) ||
				# rss feeds
        (probexit 0.05 && ping -c 1 google.com &> /dev/null && feedfortune --timeout 2) ||
        (probexit 0.05 && ping -c 1 google.com &> /dev/null && feedfortune --timeout 2 --deep) ||
				(probexit 0.5 && pinc -c 1 neuroky.me &> /dev/null && curl --insecure https://betta.neuroky.me/fortunes/one.php )
        echo -en $COLOR_off
        
        # 20% probability of not getting a fortune when not using the arxiv stuff
    fi
fi

