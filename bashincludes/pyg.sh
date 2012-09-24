# this is for using pygmentize as a colorized cat
# http://pygments.org/download/
# http://www.ralfebert.de/blog/tools/cat_syntax_highlighting/

function pcat {
   # redirect to cat if we can't find a lexer
   pygmentize $@ 2> /dev/null || cat $@
}

function pless() {
    pcat "$1" | less -R
}
