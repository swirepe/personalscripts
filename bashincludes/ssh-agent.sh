# start the ssh agent when making a new shell
# and kill it when leaving
# http://mah.everybody.org/docs/ssh
# http://www.electricmonk.nl/log/2012/04/24/re-use-existing-ssh-agent-cygwin-et-al/

mkdir -p ~/.ssh
SSH_AUTH_SOCK="$HOME/.ssh/ssh_agent_socket"
SSHAGENT=/usr/bin/ssh-agent

ssh-add -l &> /dev/null
if [ $? = 2 ]
then
    #  ssh-agent isn't running
    rm -rf $SSH_AUTH_SOCK
    if [[ -x "$SSHAGENT" ]]
    then
        echo -en "\033[38;5;239m"  # a dark grey
        
        echo "Starting ssh agent."
        
        eval `$SSHAGENT -s -a $SSH_AUTH_SOCK` &> /dev/null
        # this would kill the agent when we exit, but we are sharing that agent now
        #trap "kill $SSH_AGENT_PID" 0
    fi


    # now add in our private keys
    for pubkey in $(ls ~/pers/keys/*.pub)
    do 
        # strip off the last 4 characters so we get a private key
        echo -n "$(builtin echo $pubkey | sed 's/....$//' | xargs ssh-add)" 
    done
    
    echo -en "${COLOR_off}"
fi


# get rid of those old variables
unset SSHAGENT




