#!/bin/bash

function lstmux {
	SESSIONS=$(tmux list-sessions 2> /dev/null)

	if [[ "$TMUX" ]]
	then
	    CURRENT_SESSION=$(tmux display-message -p '#S')
	fi

	if [[ "$SESSIONS" ]] 
	then
	     
		echo -en "$COLOR_BGreen"
		echo "Available Tmux Sessions: "
		echo -en "$COLOR_off"

		echo -en "$COLOR_Green"
		echo "$SESSIONS" | 
		    ack --passthru --color --color-match=green ".*$CURRENT_SESSION:.*" |
		    sed 's/^/    /'
		
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
