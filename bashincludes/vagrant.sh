PATH="$PATH:/opt/vagrant/bin"

# display the vagrant box in the prompt when we are in a vm
function _getvagrantbox {
    grep 'config\.vm\.box\s*=' Vagrantfile | sed 's/.*"\(.*\)".*/\1/'
    
}


if [ -e /vagrant/Vagrantfile ]
then
    export PS1="${COLOR_Purple}[vm:$(_getvagrantbox)]$COLOR_off $PS1"
fi
