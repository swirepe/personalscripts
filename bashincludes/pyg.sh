# this is for using pygmentize as a colorized cat
# http://pygments.org/download/
# http://www.ralfebert.de/blog/tools/cat_syntax_highlighting/

function pcat {
    FILE="$1"
    LEXER=""
    FIRSTLINE="$(head -n1 $FILE)"

    if [[ "$FIRSTLINE" == *"bash"* ]]
    then
	LEXER="-l bash"
    fi

    if [[ "$FIRSTLINE" == *"python"* ]]
    then
	LEXER="-l python"
    fi

    if [[ "$FIRSTLINE" == *"perl"* ]]
    then
	LEXER="-l perl"
    fi

    if [[ "$FIRSTLINE" == *"ruby"* ]]
    then
	LEXER="-l ruby"
    fi


    pygmentize $LEXER "$FILE" 2> /dev/null || cat "$FILE"

}

function pless() {
    pcat "$1" | less -R
}
