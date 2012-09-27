
function lsfancyfn {
    command ls $@ --color=always --group-directories-first | gitignorefilter --color | colfmt 
}

function lsfancy {
    alias "ls"=lsfancyfn
}

function unlsfancy {
    unalias "ls"
}

