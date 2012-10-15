
PATH="$PATH:/home/swirepe/scripts"

function lastrun {
  history | tail -2 | awk '{print $2; exit}'
}


# dreampie with the current virtualenv
# http://xion.org.pl/2012/05/10/dreampie-with-virtualenv/
alias dream='(dreampie $(which python) &>/dev/null &)'


function ingitrepo {
    # returns zero if in a git repo, nonzero if not
    local  __resultvar=$1
    git rev-parse 2> /dev/null > /dev/null
    local myresult=$?
    if [[ "$__resultvar" ]]; then
        eval $__resultvar="$myresult"
    else
        echo "$myresult"
    fi
}


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
  # r recursive
  # H with filename
  # n with line number
  # T tab separated
  # --binary-files=without-match  skip binary files
  # --exclude-from  basically a gitignore file, but not skipping logs
  grep -rHnT --binary-files=without-match --exclude-from=$HOME/.grepignore $@ *
}

# for tiv - the view in terminal image thing:
PATH="$PATH:/home/swirepe/scripts/src/tiv-2012.5"

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
alias "wmirror"="wget -mk -w1"

# show a bash function definition
alias "viewfn"="declare -f"
