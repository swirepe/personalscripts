if [[ $TERM == "xterm-kitty" ]]
then
	if [ ! -e ~/.hushlogin ]
	then
		echo -e "${COLOR_Yellow}🐱 Setting TERM=xterm ${COLOR_off}"
	fi
	TERM=xterm
fi

