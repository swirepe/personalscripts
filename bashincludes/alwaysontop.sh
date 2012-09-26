
function alwaysontop {
    if [ "$ALWAYSONTOP" != "TRUE" ]
    then
        export ALWAYSONTOP="TRUE"
        export OLD_PROMPT_COMMAND="$PROMPT_COMMAND"
        if [ "$PROMPT_COMMAND" ]
        then
            PROMPT_COMMAND="$PRMOPT_COMMAND ; tput cup 0 0 ; tput el ; tput el1 "
        else
            PROMPT_COMMAND="tput cup 0 0 ; tput el ; tput el1 "
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
   
}



