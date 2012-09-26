
function alwaysontop {
    if [ "$ALWAYSONTOP" != "TRUE" ]
    then
        export ALWAYSONTOP="TRUE"
        _toprepl
    fi
}


function _toprepl {
    local _usrcmd
    clear
    while [ "$ALWAYSONTOP" == "TRUE" ]
    do
        echo -en "$PS1"
        read -p "" _usrcmd
        clear
        eval _usrcmd
        tput cup 0 0
        tput el
        tput el1
    done
}



function unalwaysontop {
    if [ "$ALWAYSONTOP" == "TRUE"  ]
    then
        ALWAYSONTOP="FALSE"
    fi
   
}


