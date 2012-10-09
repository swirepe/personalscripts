# removing those pretty indicatos seem to have fixed the text-wrapping issue
export ALWAYSONTOP_INDICATOR="\[${COLOR_BIPurple}\]^^\[${COLOR_off}\] "
export AUTOCLEAR_INDICATOR="\[${COLOR_BIYellow}\]@\[${COLOR_off}\] "

#export ALWAYSONTOP_INDICATOR="↑↑ "
#export AUTOCLEAR_INDICATOR="◎ "

function alwaysontop {
    if [ "$ALWAYSONTOP" != "TRUE" ]
    then
        export ALWAYSONTOP="TRUE"
        export OLD_PROMPT_COMMAND_AOT="$PROMPT_COMMAND"
        if [ "$PROMPT_COMMAND" ]
        then
            # before showing the prompt and doing whatever you're supposed to do
            # when you do that, go to the top of the screen and clear in both directions
            PROMPT_COMMAND="$PROMPT_COMMAND ; tput cup 0 0 ; tput el ; tput el1"
        else
            PROMPT_COMMAND="tput cup 0 0 ; tput el ; tput el1"
        fi
        
        
        PS1="$ALWAYSONTOP_INDICATOR$PS1"
        #PS1="$PS1"
    fi
}


function unalwaysontop {
    if [ "$ALWAYSONTOP" == "TRUE"  ]
    then
        if [ -n $OLD_PRMOPT_COMMAND_AOT ]
        then
            PROMPT_COMMAND="$OLD_PRMOPT_COMMAND_AOT"
        fi
        
        ALWAYSONTOP="FALSE"
        
        # it turns out that i suck at sed
        # strremove takes in two arguments: a base and a toRemove
        # and removes the substring toRemove from the base  :/
        PS1=$(strremove.py "$PS1" "$ALWAYSONTOP_INDICATOR" ) 
    fi
   
    
}


function autoclear {
    if [ "$AUTOCLEAR" != "TRUE" ]
    then
        export AUTOCLEAR="TRUE"
        
        # replace the enter key with a form feed (clears the screen) and an enter key
        bind 'RETURN: "\C-l\C-j"' 
        PS1="$AUTOCLEAR_INDICATOR$PS1"
        
        #PS1="$PS1"
    fi
    
    # since we are going to be clearing the screen after every command, might as well have cd also be an ls
    alias "cd"=cdls
    
    # all those little navigation functions that basically just cd into a directory?
    # let them know to use the new cd function
    renavigate    
}


function unautoclear {
    export AUTOCLEAR="FALSE"
    bind 'RETURN: "\C-j"'
    PS1=$(strremove.py "$PS1" "$AUTOCLEAR_INDICATOR" )
    
    unalias "cd"
    renavigate
}

# turn on both alwaysontop and autoclear
function autotop {
    clear
    autoclear
    alwaysontop
}

# turn off both alwaysontop and autoclear
function unautotop {
    unalwaysontop
    unautoclear
}

function cdls {
    # go into a directory
    # if that succees, print the git status and a horizontal rule (if we are in a git repository)
    # then print the directory contents, 4 columns, cropped to the screen
    command cd $@ && ((git status -bs 2>/dev/null && hr) ; ls --color=always --group-directories-first | gitignorefilter --color | colfmt | head -n$LINES )
}


function renavigate {
    # reloads my navigation functions so that they get the new cd alias
    source $BASHINCLUDES_DIR/navigation.sh
}
