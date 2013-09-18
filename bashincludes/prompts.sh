# add the tmux extensions to path
PATH=$PATH:$SCRIPTS_DIR/tmux

# ---------------------------------------------------------------------------
# git branches for bash
# ---------------------------------------------------------------------------


function parse_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function proml {
    local BLUE="\[\033[0;34m\]"
    local RED="\[\033[0;31m\]"
    local LIGHT_RED="\[\033[1;31m\]"
    local GREEN="\[\033[0;32m\]"
    local LIGHT_GREEN="\[\033[1;32m\]"
    local WHITE="\[\033[1;37m\]"
    local LIGHT_GRAY="\[\033[0;37m\]"
case $TERM in
xterm*)
TITLEBAR='\[\033]0;\u@\h:\w\007\]'
;;
*)
TITLEBAR=""
;;
esac
PS1="${TITLEBAR}\
\u@\h:\w$WHITE\$(parse_git_branch)\
$LIGHT_GRAY>$COLOR_off$COLOR_off "
PS2='> '
PS4='+ '
}

# ---------------------------------------------------------------------------
# multiplexers
# ---------------------------------------------------------------------------



function whichmultiplexer {
   local MULTIPLEXER="none"
   
   if [ -n "$WINDOW" ];
   then
       MULTIPLEXER="screen"
   fi
   
   if [ -n "$TMUX" ];
   then
       MULTIPLEXER="tmux"    
   fi
   
   echo "$MULTIPLEXER"
}


# changes the title for screen or tmux
settitle() {
    printf "\033k$1\033\\"
}


# set the prompt
# if the WINDOW variable is set, we are in screen
case $(whichmultiplexer) in
    screen)
        PS1="($WINDOW) \w \$ "
        
        ;;
    tmux)
        PS1=" \w \$(parse_git_branch) \$ "
        #PROMPT_COMMAND=$SCRIPTS_DIR/tmux/prompt.py 
        # rename the window to what i've ssh'd into
        # close that window once we are done connecting
        function ssh {
            settitle "ssh:$*"
            command ssh "$@"
            #exit
        }
      ;;
    *)

    ;;    
esac


# for the tmux powerline
# https://github.com/erikw/tmux-powerline
# PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#I_#P") "$PWD")'


function long_prompt {
    PS1="$(retcolor) \u@\h $(parse_git_branch) \n\w \$ $(tput el)"

}

function time_run {
    local this_time=$(($SECONDS))
    echo $((this_time-LAST_TIME))
    LAST_TIME=$(($SECONDS))
    export LAST_TIME
}

function retcolor {
    if [ $? == 0 ]
    then
        echo -e "\[${COLOR_Green}\]✔\[${COLOR_off}\]"
    else
        echo -e "\[${COLOR_Red}\]✖\[${COLOR_off}\]"
    fi
}



# ---------------------------------------------------------------------------
# now actually set the PS1
# ---------------------------------------------------------------------------


PS1=" \w \$(parse_git_branch) \$ "



# ---------------------------------------------------------------------------
# show a little icon if we are on a remote server
# ---------------------------------------------------------------------------

# ☎ ☏  ☄  ❂    ✈

if [ -n "$SSH_CLIENT" ]
then
    if [[ -z "$TMUX" ]]
    then
        PS1="\[${COLOR_BPurple}\]\$(whoami)\[${COLOR_off}\]\[${COLOR_BYellow}\]@\[${COLOR_off}\]\[${COLOR_bold}\]\[\$(hostcolor.pl)\]\$(hostname)\[${COLOR_off}\] $PS1"  
    else
        PS1="\[${COLOR_IGreen}\] ⚲ \[${COLOR_off}\]$PS1"
    fi
else
    PS1="\[${COLOR_BIRed}\]➜\[${COLOR_off}\] $PS1"  
fi


# ---------------------------------------------------------------------------
# display the vagrant box if we are in a vm
# ---------------------------------------------------------------------------

function _getvagrantbox {
    grep 'config\.vm\.box\s*=' /vagrant/Vagrantfile | sed 's/.*"\(.*\)".*/\1/'
    
}


if [ -e /vagrant/Vagrantfile ]
then
    export PS1="\[${COLOR_Purple}\][vm:$(_getvagrantbox)]\[${COLOR_off}\] $PS1"
fi


