if [[ ! -f ~/.calendar.calendar ]] 
then
	echo "#include <calendar.argentina>" >> ~/.calendar.calendar
	echo "#include <calendar.australia>" >> ~/.calendar.calendar
	echo "#include <calendar.belgium>" >> ~/.calendar.calendar
	echo "#include <calendar.birthday>" >> ~/.calendar.calendar
	echo "#include <calendar.christian>" >> ~/.calendar.calendar
	echo "#include <calendar.computer>" >> ~/.calendar.calendar
	echo "#include <calendar.croatian>" >> ~/.calendar.calendar
	echo "#include <calendar.debian>" >> ~/.calendar.calendar
	echo "#include <calendar.discordian>" >> ~/.calendar.calendar
	echo "#include <calendar.eu>" >> ~/.calendar.calendar
	echo "#include <calendar.freebsd>" >> ~/.calendar.calendar
	echo "#include <calendar.history>" >> ~/.calendar.calendar
	echo "#include <calendar.holiday>" >> ~/.calendar.calendar
	echo "#include <calendar.judaic.2018>" >> ~/.calendar.calendar
	echo "#include <calendar.judaic.2019>" >> ~/.calendar.calendar
	echo "#include <calendar.judaic.2020>" >> ~/.calendar.calendar
	echo "#include <calendar.judaic.2021>" >> ~/.calendar.calendar
	echo "#include <calendar.judaic.2022>" >> ~/.calendar.calendar
	echo "#include <calendar.kazakhstan>" >> ~/.calendar.calendar
	echo "#include <calendar.lotr>" >> ~/.calendar.calendar
	echo "#include <calendar.music>" >> ~/.calendar.calendar
	echo "#include <calendar.newzealand>" >> ~/.calendar.calendar
	echo "#include <calendar.pagan>" >> ~/.calendar.calendar
	echo "#include <calendar.southafrica>" >> ~/.calendar.calendar
	echo "#include <calendar.ubuntu>" >> ~/.calendar.calendar
	echo "#include <calendar.unitedkingdom>" >> ~/.calendar.calendar
	echo "#include <calendar.usholiday>" >> ~/.calendar.calendar
	echo "#include <calendar.world>" >> ~/.calendar.calendar
fi
if [ ! -f ~/.hushlogin ]
then
	probexit 0.1 && (echo -en "${COLOR_BBlack}";
		calendar -w | shuf -n 1;
		echo -e "${COLOR_off}" )
fi
