# this is definitely going to piss me off

function git {
   command git $@ 2> ~/silly | cat silly | cowsay
}
