# this is for using pygmentize as a colorized cat
# http://pygments.org/download/
# http://www.ralfebert.de/blog/tools/cat_syntax_highlighting/

alias pcat=pygmentize

function pless() {
    pcat "$1" | less -R
}
