
function lastrun {
  history | tail -2 | awk '{print $2; exit}'
}


# dreampie with the current virtualenv
# http://xion.org.pl/2012/05/10/dreampie-with-virtualenv/
alias dream='(dreampie $(which python) &>/dev/null &)'




function findinfiles {
   # we use git --ls-files so that we take into account the .gitignores
   local _ingit=$(ingitrepo)
   if [ "$_ingit" -eq "0" ] ;
   then
       findinfiles_git $@
   else
       findinfiles_regular $@        
   fi
}


function findinfiles_regular {
   local searchString 
   for searchString in "$@"
   do
       echo "Files containing $searchString"
       echo "--------"
       find . | xargs grep "$searchString" -sl
   done
}


function findinfiles_git {
   local searchString
   git branch
   for searchString in "$@"
   do
       echo "Files containing $searchString"
       echo "--------"
       git ls-files | xargs grep "$searchString" -sl | xpipe "git status -s" "echo"
   done
}

function finf {
  ##  f.ind in f.iles
  # r recursive
  # H with filename
  # n with line number
  # T tab separated
  # --binary-files=without-match  skip binary files
  # --exclude-from  basically a gitignore file, but not skipping logs
  grep -rHnT --binary-files=without-match --exclude-from=$HOME/.grepignore "$@" *
}


# requires xdg-utils
# open a file using the system set preffered application
alias actualize="xdg-open"


function lsabbrev {
  ls $@ --color=always --group-directories-first -1 | head -n 3
}

# go into a folder and display its contents
function c {
   clear && cd $@ &&  ls --color=always --group-directories-first  | colfmt | head -n 3
}

# make a mirror of a site using wget
alias "wmirror"="wget --mirror --convert-links --tries=10 --retry-connrefused --wait=1"

# show a bash function definition
alias "viewfn"="declare -f"

# use cut to limit the length of a line
alias "line-limit"="cut -c -$(tput cols)"

# http://unix.stackexchange.com/questions/366/convince-grep-to-output-all-lines-not-just-those-with-matches
function highlight {
    perl -pe "s/$1/$COLOR_BRed$&$COLOR_off/g"
}


# from google io 2013
# http://www.youtube.com/watch?feature=player_detailpage&v=Mk-tFn2Ix6g#t=399
function server {
	local port="${1:-8000}"

	OPEN_CMD="xdg-open"
	if [[ $(uname) == *"Darwin"* ]]
	then
		OPEN_CMD="open"
	fi
	$OPEN_CMD "http://localhost:${port}/"

	python -m SimpleHTTPServer "$port"
}



export EDITOR="vim"
