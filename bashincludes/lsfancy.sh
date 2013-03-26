
function lsfancyfn {
    command ls $@ --color=always --group-directories-first | gitignorefilter --color | colfmt 
}

function lsfancy {
    alias "ls"=lsfancyfn
}

function unlsfancy {
    unalias "ls"
    alias "ls"=ls --color=auto
}

function lsd {
   ls -d */
    # ls -l --color=always "$@" | egrep '^d' | awk '{print $9}' | colfmt -c 3
}

function lsdir {
   ls -l --color=always "$@" | egrep '^d' | awk '{print $9}'
}

function lsf {
       ls -l --color=always "$@" | egrep -v '^d' | awk '{print $9}' | colfmt -c 3
}

function lsfiles {
    ls -l --color=always "$@" | egrep -v '^d' | awk '{print $9}'
}
