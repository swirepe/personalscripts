
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
$LIGHT_GRAY> "
PS2='> '
PS4='+ '
}


# set the prompt
# if the WINDOW variable is set, we are in screen
if [ -n "$WINDOW" ];
then
    # This is the escape sequence ESC k \w ESC \
    #Use path as titel
    #SCREENTITLE=’\[\ek\w\e\\\]‘
    #Use program name as titel
    SCREENTITLE='\[\ek\e\\\]'
    
    PS1="$SCREENTITLE($WINDOW) \w \$ "
    

    
    
else
    #otherwise, we'll want to do some other stuff to get our prompt
    proml
fi
    
