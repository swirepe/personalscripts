# this script adds a little icon if we are on a remote server.

if [ -n "$SSH_CLIENT" ]
then
    PS1="\[${COLOR_IGreen}\] ⚲ \[${COLOR_off}\]$PS1"
fi


# ☎ ☏  ☄  ❂    ✈
