#!/bin/bash

function lstmux {
# http://wi-fizzle.com/article/276
# IFS: Coax a BASH shell script into splitting for-loop elements by newline
# instead of whitespace (whitespace is the default behaviour).
local IFS="
"

	local SESSIONS=$(tmux list-sessions 2> /dev/null)

	if [[ ! -z "$TMUX" ]]
	then
	    local CURRENT_SESSION=$(tmux display-message -p '#S')
	fi

	if [[ ! -z "$SESSIONS" ]] 
	then
	     
		echo -en "$COLOR_BGreen"
		echo "Available Tmux Sessions: "
		echo -en "$COLOR_off"

		for session_line in "$SESSIONS"
		do
		    
		    if [[ ! -z $(echo "$session_line" | grep "^$CURRENT_SESSION:" ) ]]
		    then
			echo -e "${COLOR_BYellow}=>  ${COLOR_off}${COLOR_Green}$session_line${COLOR_off}"

		    else
			echo -e "    ${COLOR_Green}$session_line${COLOR_off}"
		    fi  		    

		done

	fi
}

if [[ ! -z  "$SSH_CONNECTION" ]]
then
    if [ ! -f ~/.hushlogin ]
    then
	lstmux
    fi
fi
