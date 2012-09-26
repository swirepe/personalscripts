
function alwaysontop {
    if [ "$ALWAYSONTOP" != "TRUE" ]
    then
        export ALWAYSONTOP="TRUE"
        export OLD_PROMPT_COMMAND="$PROMPT_COMMAND"
        if [ "$PROMPT_COMMAND" ]
        then
            PROMPT_COMMAND="$PRMOPT_COMMAND ;  _notjustrun ; tput cup 0 0 ; tput el ; tput el1 ; _justrun"
        else
            PROMPT_COMMAND="_notjustrun ; tput cup 0 0 ; tput el ; tput el1 ; _justrun"
        fi
    fi
}


function unalwaysontop {
    if [ "$ALWAYSONTOP" == "TRUE"  ]
    then
        if [ -n $OLD_PROMPT_COMMAND ]
        then
            PROMPT_COMMAND="$OLD_PRMOPT_COMMAND"
            ALWAYSONTOP="FALSE"
        fi
    fi
    trap DEBUG
}




function _clearonjustrun {

    if [ "$JUSTRUN" == "TRUE" ] 
    then
        clear
    fi
    
}

function _justrun {
    export JUSTRUN="TRUE"   
}

function _notjustrun {
    export JUSTRUN="FALSE"
}

# make this visible
export _clearonjustrun

# run before each command
trap '_clearonjustrun' DEBUG

