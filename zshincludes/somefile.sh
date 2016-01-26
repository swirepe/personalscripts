# choose a random file from this directory
alias -g  SOME_FILE='$(find . -maxdepth 1 -type f | shuf -n 1)'
