# start the ssh agent when making a new shell
# and kill it when leaving
# http://mah.everybody.org/docs/ssh

if [ -e ~/.bashrc_verbose ]
then
    echo "Starting ssh agent."
fi


SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [[ -z "$SSH_AUTH_SOCK" ]] && [[ -x "$SSHAGENT" ]]
then
    eval `$SSHAGENT $SSHAGENTARGS` &> /dev/null
    trap "kill $SSH_AGENT_PID" 0

fi


if [[ ! -z "$SSH_AUTH_SOCK" ]]
then
    # now add in our private keys
    for pubkey in $(ls ~/pers/keys/*.pub)
    do 
        
        if [ -e ~/.bashrc_verbose ]
        then
            echo $pubkey | sed 's/....$//' | xargs ssh-add
        else
        
            # strip off the last 4 characters so we get a private key
            echo $pubkey | sed 's/....$//' | xargs ssh-add &> /dev/null
        fi
    done
fi


# get rid of those old variables
unset SSHAGENT
unset SSHAGENTARGS



