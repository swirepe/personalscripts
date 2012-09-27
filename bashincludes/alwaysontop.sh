
export ALWAYSONTOP_INDICATOR="$COLOR_BIPurple^^$COLOR_off "
export AUTOCLEAR_INDICATOR="$COLOR_BIYellow◎$COLOR_off  "

function alwaysontop {
    if [ "$ALWAYSONTOP" != "TRUE" ]
    then
        export ALWAYSONTOP="TRUE"
        export OLD_PROMPT_COMMAND_AOT="$PROMPT_COMMAND"
        if [ "$PROMPT_COMMAND" ]
        then
            PROMPT_COMMAND="$PROMPT_COMMAND ; tput cup 0 0 ; tput el ; tput el1 "
        else
            PROMPT_COMMAND="tput cup 0 0 ; tput el ; tput el1 "
        fi
        
        PS1="$ALWAYSONTOP_INDICATOR$PS1"
    fi
}


function unalwaysontop {
    if [ "$ALWAYSONTOP" == "TRUE"  ]
    then
        if [ -n $OLD_PROMPT_COMMAND ]
        then
            PROMPT_COMMAND="$OLD_PRMOPT_COMMAND_AOT"
        fi
        
        ALWAYSONTOP="FALSE"
        # it turns out that i suck at sed
        PS1=$(strremove.py "$PS1" "$ALWAYSONTOP_INDICATOR" ) 
    fi
   
    
}

# todo: search for indicators in PS1 instead of just remembering old ones
# (that way they can be removed in any order)
function autoclear {
    if [ "$AUTOCLEAR" != "TRUE" ]
    then
        export AUTOCLEAR="TRUE"
        bind 'RETURN: "\C-l\C-j"'
        PS1="$AUTOCLEAR_INDICATOR$PS1"
    fi
        
}

function unautoclear {
    export AUTOCLEAR="FALSE"
    bind 'RETURN: "\C-j"'
    PS1=$(strremove.py "$PS1" "$AUTOCLEAR_INDICATOR" )
}

function autotop {
    clear
    autoclear
    alwaysontop
}

function unautotop {
    unalwaysontop
    unautoclear
}
