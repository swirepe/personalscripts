# http://superuser.com/questions/117227/a-command-before-every-bash-command
# bind the f12 key to the time command:
#  go to the start of the line
#  write the word time
#  go the end of the line
#  insert a newline
bind '"\e[24~": "\e[1~time \e[4~\n"'
