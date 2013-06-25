#!/bin/bash

function lstmux {
	SESSIONS=$(tmux list-sessions 2> /dev/null)
	if [[ "$SESSIONS" ]] 
	then
	     
		echo -en "$COLOR_BGreen"
		echo "Available Tmux Sessions: "
		echo -en "$COLOR_Green"
		
		echo "$SESSIONS" | sed 's/^/    /'

		echo -en "$COLOR_off"
	fi
}

if [ "$SSH_CONNECTION" ]
then
    if [ ! -f ~/.hushlogin ]
    then
	lstmux
    fi
fi
