#!/usr/bin/env bash

## ----------------------------------------------------------------------------
## define some colors to make this all pretty
## ----------------------------------------------------------------------------


COLOR_off='\033[0m'
COLOR_Red='\033[0;31m'
COLOR_BGreen='\033[1;32m'
COLOR_BYellow='\033[1;33m'
COLOR_Blue='\033[0;34m'
COLOR_BIBlue='\033[1;94m' 

THIS_SCRIPT_PATH="$PWD/$0"

## ----------------------------------------------------------------------------
## set up error checking
## ----------------------------------------------------------------------------
# fail on any errors (same as set -e)
set -o errexit

function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    echo -e "${COLOR_Red}ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}: $(sed -n ${LASTLINE}p $THIS_SCRIPT_PATH) ${COLOR_off}"
    exit 1
}
trap 'error ${LINENO} ${$?}' ERR


function checkpoint {
    echo "$1" > $HOME/setup-new-machine.checkpoint
    echo -e "${COLOR_BGreen}Checkpoint: $1"
}


## ----------------------------------------------------------------------------
## Start this script behind a tee
## ----------------------------------------------------------------------------

function start_behind_tee {
    # deliberately does not checkpoint, since it has the power to restart the script
    if [[ -t 1 ]]
    then
        # stdout is a terminal
        exec bash -c "$THIS_SCRIPT_PATH | tee --append $HOME/new-machine-setup.log"
    else
         # stdout is not a terminal
        echo "(Okay, it seems like this is being piped somewhere.  That's good.)"
    fi

}

## ----------------------------------------------------------------------------
## Introduce yourself!
## ----------------------------------------------------------------------------
function intro {
    
    checkpoint 'intro'
    
    echo -en "$COLOR_BGreen"
    
    echo '        m     m        ""#                                    m '
    echo '        #  #  #  mmm     #     mmm    mmm   mmmmm   mmm       # '
    echo '        " #"# # #"  #    #    #"  "  #" "#  # # #  #"  #      # '
    echo '         ## ##" #""""    #    #      #   #  # # #  #""""        '
    echo '         #   #  "#mm"    "mm  "#mm"  "#m#"  # # #  "#mm"      # '
    echo -e "$COLOR_off" 
    echo "This is the automated setup script for Peter Swire's machines."
    echo "                 Peter Swire - data@swirepe.com"
    echo ""
    echo "This script will:"
    echo " * Create user swirepe                                   (Linux)"
    echo " * Get private keys                                        (All)"
    echo " * Clone respositories                                     (All)"
    echo " * Symlink dotfiles into place                             (All)"
    echo " * Build commonly used scripts                           (Linux)"
    echo " * Install and record commonly used packages            (Debian)"
    echo " * Expand the root partition                      (Raspberry Pi)"
    echo " * Install a Tor relay                            (Raspberry Pi)"
    echo " * Expand the root partition                      (Raspberry Pi)"
    echo ""
    echo "This script also has checkpointing system."
    echo "Start this script with a checkpoint location,"
    echo "or store it in $HOME/setup-new-machine.checkpoint"
    echo "Possible starting points:"
    declare -f gammut
    echo "or just 'build_scripts' to build all the scripts."
    echo -e "\n\nReady? Go!\n"

}
## ----------------------------------------------------------------------------
## who are we?
## ----------------------------------------------------------------------------
function names {
    checkpoint 'names'
        
    echo -e "${COLOR_BIBlue}user:${COLOR_off}\t$(whoami)"
    echo -e "${COLOR_BIBlue}host:${COLOR_off}\t$(hostname)"

}
## ----------------------------------------------------------------------------
## linux-specific: make a swirepe if you have to
## ----------------------------------------------------------------------------
function add_sudoersd {
    # make sure /etc/sudoers.d exists
    [ -d /etc/sudoers.d ] || sudo mkdir -p /etc/sudoers.d
    
    echo -e "${COLOR_Blue}Creating sudoers file /etc/sudoers.d/${FILE}${COLOR_off}"
    FILE="$1"
    CONTENT="##added by setup-new-machine on $(date)\n$2"
    echo -e "$CONTENT" | sudo tee /etc/sudoers.d/$FILE
    if  visudo -c -f /etc/sudoers.d/$FILE 
    then
        sudo chmod 0440 /etc/sudoers.d/$FILE
        echo -e "${COLOR_BIBlue}Sudoers file /etc/sudoers.d/$FILE successfully installed.${COLOR_off}"
    else
        echo -e "${COLOR_BYellow}New sudoers file /etc/sudoers.d/$FILE is incorrect.  Removing.${COLOR_off}"
        sudo rm /etc/sudoers.d/$FILE
    fi
}


function add_group_admin {
    checkpoint 'add_group_admin'
    if [[ "$(uname)" == *"Linux"* ]]
    then
        # does the group admin exist?
        if [[ "$(cat /etc/group | grep ^admin)"         ]] &&
           [[ "$(sudo cat /etc/sudoers | grep ^%admin)" ]]
        then
            echo -e "${COLOR_Blue}Group admin exists.${COLOR_off}"
        else
            echo -e "${COLOR_Blue}Creating group admin${COLOR_off}"
            sudo groupadd --force admin
            add_sudoersd 'admin.sudo' "# Members of the admin group may gain root privileges\n\n%admin ALL=(ALL) NOPASSWD:ALL"
            echo -e "${COLOR_BIBlue}Group admin created.${COLOR_off}"
        fi
    fi
}


function add_user_swirepe {
    checkpoint 'add_user_swirepe'   
    
    if [[ "$(uname)" == *"Linux"* ]]
    then
        # does swirepe exist?
        if [[ "$(grep ^swirepe /etc/passwd)"  ]]
        then
            echo -e "${COLOR_Blue}User swirepe in /etc/passwd${COLOR_off}"
        else
            echo -e "${COLOR_Blue}Creating user swirepe.${COLOR_off}"
            sudo adduser --home /home/swirepe --ingroup admin --gecos "Peter Swire,1337,swirepe@swirepe.com,hi@swirepe.com,Believe in yourself." swirepe
            echo -e "${COLOR_BYellow}NOTE: User swirepe has an unencrypted home directory.${COLOR_off}"
            echo -e "${COLOR_BYellow}    Consider running ${COLOR_BGreen}ecryptfs-setup-private${COLOR_BYellow} on your next login.${COLOR_off}"
            echo -e "${COLOR_BYellow}    See: ${COLOR_BGreen}https://help.ubuntu.com/community/EncryptedPrivateDirectory${COLOR_off}"
            echo -e "${COLOR_BIBlue}User swirepe created.${COLOR_off}"
        fi
        
    fi
}


function add_swirepe_to_sudoersd {
    checkpoint 'add_swirepe_to_sudoersd'
    if [[ "$(uname)" == *"Linux"* ]]
    then
        ## add swirepe to sudoers
        if [[ "$(sudo cat /etc/sudoers | grep swirepe)"     ]] ||
           [[ "$(sudo cat /etc/sudoers.d/* | grep swirepe)" ]] 
        then
            echo -e "${COLOR_Blue}User swirepe is a sudoer.${COLOR_off}"
        else
            echo -e "${COLOR_Blue}Putting a file for user swirepe in /etc/sudoers.d/${COLOR_off}"
            add_sudoersd 'swirepe.sudo' "swirepe ALL=(ALL) NOPASSWD:ALL"
            echo -e "${COLOR_BIBlue}User swirepe added to /etc/sudoers.d/${COLOR_off}"
        fi
    fi
}


function add_include_to_sudoers {
    checkpoint 'add_include_to_sudoers'

    if [[ "$(uname)" == *"Linux"* ]]
    then

        ## add that include directive to sudoers
        if [[ "$(sudo cat /etc/sudoers | grep '^includedir /etc/sudoers.d')" ]]
        then
            echo -e "${COLOR_BIBlue}Sudoers includes the directory /etc/sudoers.d/${COLOR_off}"
        else
            echo -e "${COLOR_Blue}Adding an include directive in /etc/sudoers${COLOR_off}"
                
            SUDOERS_TEMP=$(mktemp /tmp/sudoers.XXXXX)
            sudo cat /etc/sudoers >> $SUDOERS_TEMP
            
            echo -e "\n\n## Added by setup-new-machine.sh on $(date)" >> $SUDOERS_TEMP
            echo -e "includedir /etc/sudoers.d" >> $SUDOERS_TEMP
            if visudo -c -f $SUDOERS_TEMP 
            then
                echo -e "${COLOR_Blue}New sudoers file is syntactically correct.  Installing.${COLOR_off}"
                sudo flock /etc/sudoers -c "cat $SUDOERS_TEMP | sudo tee /etc/sudoers"
                
                if  visudo -c -f /etc/sudoers 
                then
                    echo -e "${COLOR_BIBlue}Sudoers file /etc/sudoers successfully installed.${COLOR_off}"
                else
                    echo -e "${COLOR_Red}Sudoers file failed to install correctly.  Lord have mercy.${COLOR_off}"  
                fi
                
            else
                echo -e "${COLOR_BYellow}New sudoers file is incorrect.  NOT installing.${COLOR_off}"
            fi
            rm $SUDOERS_TEMP
        fi
    fi

}
## ----------------------------------------------------------------------------
## restart script as swirepe
## ----------------------------------------------------------------------------
function restart_as_swirepe {
checkpoint 'restart_as_swirepe'
    
if [[ "$(whoami)" == "swirepe" ]]
then
    echo -e "${COLOR_BGreen}Currently user swirepe.${COLOR_off}"
else   
    
    echo -e "${COLOR_BYellow}We can restart this command as user ${COLOR_BIBlue}swirepe${COLOR_off}${COLOR_BYellow}.${COLOR_off}"
    read -t 5 -p "Restart as swirepe? [Y/n] " restart
    restart=${restart:-yes}
    if [[ "$(echo $restart | grep -i  ^y )" ]]
    then
        
        echo -e "${COLOR_BYellow}****RESTARTING SCRIPT.****${COLOR_off}"
        
        sudo su - swirepe -c "HOME=/home/swirepe  bash -c '$THIS_SCRIPT_PATH | tee --append /home/swirepe/new-machine-setup.log' "
        
        exit 0
    else
        echo -e "${COLOR_BIBlue}Not restarting as user swirepe.${COLOR_off}"
        
        echo -e "${COLOR_BYellow}We can pretend that home is at ${COLOR_BIBlue}/home/swirepe${COLOR_off}${COLOR_BYellow}.${COLOR_off}"
        echo -e "${COLOR_BYellow}It is currently at  ${COLOR_Blue}${HOME}${COLOR_off}${COLOR_BYellow}.${COLOR_off}"
        read -t 5 -p "Pretend home is /home/swirepe? [y/N] " rehome
        rehome=${rehome:-no}
        if [[ "$(echo $rehome | grep -i y)" ]]
        then
            echo -e "${COLOR_BIBlue}Setting HOME to /home/swirepe${COLOR_off}"
            HOME="/home/swirepe"
        else
            echo -e "${COLOR_BIBlue}Keeping home as $HOME.${COLOR_off}"
        fi
        
    fi
    
fi

}
## ----------------------------------------------------------------------------
## debian: get core packages
## ----------------------------------------------------------------------------
DEBIAN="false"

function debian_core {
    checkpoint 'debian_core'
        
    if [[ $(which apt-get) ]]
    then
        DEBIAN="true"
        echo -e "${COLOR_Blue}Program apt-get found.  Assuming Debian.${COLOR_off}"
        echo -e "${COLOR_Blue}Upgrading and installing core packages.${COLOR_off}"
        sudo apt-get update
        sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev git-core build-essential cmake openssl ecryptfs-utils
    fi

}
## ----------------------------------------------------------------------------
## make sure we have all the programs we need
## ----------------------------------------------------------------------------
function util_check {
    checkpoint 'util_check'
        
    cd $HOME
    
    echo -e "${COLOR_Blue}Checking wget.${COLOR_off}"
    which wget
    echo -e "${COLOR_Blue}Checking git.${COLOR_off}"
    which git
    echo -e "${COLOR_Blue}Checking openssl.${COLOR_off}"
    which openssl
    echo -e "${COLOR_Blue}Checking tar.${COLOR_off}"
    which tar
    echo -e "${COLOR_Blue}Checking yes.${COLOR_off}"
    which yes
    
    echo -e "${COLOR_BGreen}All necessary programs are present.${COLOR_off}"
    
    
    mkdir -p $HOME/pers
    cd $HOME/pers
}
## ----------------------------------------------------------------------------
## make getting stuff tenacious, just for this one time
## ----------------------------------------------------------------------------

function wget {
    command wget --tries=10 --append-output="$HOME/new-machine-setup-wget.log" "$@"
}


## ----------------------------------------------------------------------------
## pi-specific
## ----------------------------------------------------------------------------
function pi_specific {
    checkpoint 'pi_specific'
    
    if [[ "$(which raspi-config)" ]]
    then
        echo -e "${COLOR_Blue}raspi-config detected.  Assuming raspberry pi.${COLOR_off}"
    
        echo -e "${COLOR_Blue}Fetching raspberry pi pre-install script.${COLOR_off}"
        mkdir -p $HOME/pi
        cd $HOME/pi
        
        [ -e pre-install.sh  ] || wget https://raw.github.com/swirepe/personalscripts/master/pi/pre-install.sh
    
        chmod +x pre-install.sh
        ./pre-install.sh "$THIS_SCRIPT_PATH"
        
    
        echo -e "${COLOR_BGreen}Setup of pi-specific components complete.${COLOR_off}"
    fi

}
## ----------------------------------------------------------------------------
## get the keys and extract them
## ----------------------------------------------------------------------------
function keys {
    checkpoint 'keys'
    
    echo -e "${COLOR_Blue}Fetching keys.${COLOR_off}"
    
    wget http://swirepe.com/keys.tar.gz.des3
    
    ## to compress
    ## tar -czf keys.tar.gz keys/
    ## to encrypt
    ## openssl des3 -in keys.tar.gz -out keys.tar.gz.des3 
    
    echo -e "${COLOR_Blue}Decrypting keys.${COLOR_off}"
    
    openssl des3 -d -in keys.tar.gz.des3 -out keys.tar.gz
    tar zxvf keys.tar.gz

}
## ----------------------------------------------------------------------------
## start ssh agent
## ----------------------------------------------------------------------------
function add_keys_to_ssh {
    checkpoint 'add_keys_to_ssh'
    
    echo -e "${COLOR_Blue}Adding keys to ssh agent.${COLOR_off}"
    
    eval `ssh-agent -s` 
    
    yes yes | ssh-add $HOME/pers/keys/bitbucket-key
    yes yes | ssh-add $HOME/pers/keys/github-key
    
    echo -e "${COLOR_BGreen}Keys successfully added.${COLOR_off}"

}
## ----------------------------------------------------------------------------
## add persistence to ssh connections.
## ----------------------------------------------------------------------------
function config_ssh_persist {
	checkpoint 'config_ssh_persist'
	
    echo -e "${COLOR_Blue}Adding persistence options to ~/.ssh/config${COLOR_off}"
    mkdir -p ~/.ssh
    echo -e "\n\## ---------------------------------------------\n"  >> ~/.ssh/config
    echo -e "\n## added on $(date) by setup-new-machine.sh\n" >> ~/.ssh/config
    echo "Host *" >> ~/.ssh/config
    echo -e "    ControlMaster auto" >> ~/.ssh/config
    echo -e "    ControlPath /tmp/ssh-%r@%h:%p" >> ~/.ssh/config
    echo -e "    ControlPersist yes" >> ~/.ssh/config
    echo -e "\n\## ---------------------------------------------\n"  >> ~/.ssh/config

    echo -e "${COLOR_BGreen}Done adding persistence options to ~/.ssh/config${COLOR_off}"

}
## ----------------------------------------------------------------------------
## clone the repos
## ----------------------------------------------------------------------------
function clone_repos {
    checkpoint 'clone_repos'
    
    echo -e "${COLOR_Blue}Cloning repositories.${COLOR_off}"
    
    git clone git@bitbucket.org:swirepe/machines.git $HOME/pers/machines
    git clone git@bitbucket.org:swirepe/fortunes.git $HOME/pers/quotes
    git clone git@github.com:swirepe/personalscripts.git $HOME/pers/scripts
}


function update_submodules {
    checkpoint 'update_submodules'
    
    cd $HOME/pers/scripts
    git submodule update --init --recursive 
}

function update_oh_my_zsh_module {
    checkpoint 'update_oh_my_zsh_module'
    echo -e "${COLOR_Blue}Updating oh-my-zsh (even if you aren't using it.)${COLOR_off}"
    cd $HOME/pers/scripts/src/oh-my-zsh-copy
    git remote add bitbucket git@bitbucket.org:swirepe/oh-my-zsh-copy.git
    git pull bitbucket master
    
    
    echo -e "${COLOR_BGreen}Repositories successfully cloned.${COLOR_off}"

}
## ----------------------------------------------------------------------------
## symlink everything in place
## ----------------------------------------------------------------------------

function move_if_exists {
    FILE=$1
    [ -e $FILE ] && tar -zcf "$FILE-$(shasum $FILE | cut -c 1-5).tar.gz" $FILE && rm -r $FILE
    cd $HOME
}


function symlinks {
    checkpoint 'symlinks'
    
    echo -e "${COLOR_Blue}Symlinking files into place.${COLOR_off}"
    
    move_if_exists ~/.bashrc 
    move_if_exists ~/.vimrc 
    move_if_exists ~/.tmux.conf  
    move_if_exists ~/.gitconfig  
    move_if_exists ~/.zshrc
    move_if_exists ~/.gitconfig
    move_if_exists ~/.gitignore_global
    move_if_exists ~/.grepignore
    
    
    ln -s $HOME/pers/scripts/rc/bashrc.init $HOME/.bashrc
    ln -s $HOME/pers/scripts/rc/zshrc.init $HOME/.zshrc
    ln -s $HOME/pers/scripts/src/oh-my-zsh-copy $HOME/.oh-my-zsh
    ln -s $HOME/pers/scripts/rc/vimrc2 $HOME/.vimrc
    ln -s $HOME/pers/scripts/rc/tmux.conf $HOME/.tmux.conf
    ln -s $HOME/pers/scripts/rc/gitconfig $HOME/.gitconfig
    ln -s $HOME/pers/scripts/gitignoreglobal $HOME/.gitignore_global
    ln -s $HOME/pers/scripts/grepignore $HOME/.grepignore
    
    mkdir -p $HOME/.vim_backup
    
    echo -e "${COLOR_BGreen}Files successfully symlinked.${COLOR_off}"
    

}
## ----------------------------------------------------------------------------
## build some scripts if we can
## ----------------------------------------------------------------------------

function build_scripts {
    checkpoint 'build_scripts'
    
    build_scripts_sagi
    build_scripts_stderred
    build_scripts_j
    build_scripts_ag
    build_scripts_git_extras
    build_scripts_parallel
    build_scripts_csvkit

}



function build_scripts_sagi {
    checkpoint 'build_scripts_sagi'
    if [[ "$DEBIAN" == "true" ]]
    then
        echo -e "${COLOR_Blue}Installing vim ipython gnupg fortune-mod python-pygments python-pip moreutils zsh${COLOR_off}"
        $HOME/pers/scripts/sagi -y fortune-mod vim ipython gnupg python-pygments python-pip moreutils zsh
    fi
}


function build_scripts_stderred {
    checkpoint 'build_scripts_stderred'
    
    echo -e "${COLOR_Blue}Making stderred.${COLOR_off}"
    cd $HOME/pers/scripts/src/stderred
    make || make 32 || echo -e "${COLOR_BYellow}WARNING: stderred failed to build.${COLOR_off}"
    echo -e "${COLOR_BGreen}Build of stderred complete.${COLOR_off}"
}
    

function build_scripts_j {
    checkpoint 'build_scripts_j'
    
    echo -e "${COLOR_Blue}Building the j programming language.${COLOR_off}"
    cd $HOME/pers/scripts/src
    SCRIPTS_DIR=$HOME/pers/scripts ./buildj.sh
    echo -e "${COLOR_BGreen}Build of the j programming language complete.${COLOR_off}"
}
 

function build_scripts_ag {
    checkpoint 'build_scripts_ag'
    
    echo -e "${COLOR_Blue}Building the silver searcher.${COLOR_off}"
    cd $HOME/pers/scripts/src/silversearcher
    ./build.sh
    sudo make install
    echo -e "${COLOR_BGreen}Build of the silver searcher complete.${COLOR_off}"
}


function build_scripts_git_extras {
    checkpoint 'build_scripts_git_extras'
    
    echo -e "${COLOR_Blue}Building git-extras.${COLOR_off}"
    cd $HOME/pers/scripts/src/git-extras
    sudo make install
    echo -e "${COLOR_BGreen}Build of git-extras complete.${COLOR_off}"
}


function build_scripts_parallel   {
    checkpoint 'build_scripts_parallel'    
    echo -e "${COLOR_Blue}Fetching and installing gnu parallel.${COLOR_off}"
    cd /tmp
    wget http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
    tar -xvjf parallel-latest.tar.bz2
    cd parallel*
    ./configure
    make
    sudo make install
    echo -e "${COLOR_BGreen}Install of gnu parallel complete.${COLOR_off}"
}


function build_scripts_csvkit     {
    checkpoint 'build_scripts_csvkit'

    echo -e "${COLOR_Blue}Building and installing csvkit.${COLOR_off}"
    cd $HOME/pers/scripts/src/csvkit
    sudo python setup.py install
    echo -e "${COLOR_BGreen}Install of csvkit complete.${COLOR_off}"
}



## ----------------------------------------------------------------------------
## backup-cron.sh
## ----------------------------------------------------------------------------
function install_backup_cron {
    checkpoint 'install_backup_cron'
    echo -e "${COLOR_Blue}Installing backup-cron.sh${COLOR_off}"
    
    $HOME/pers/scripts/backup-cron.sh --install
    
    echo -e "${COLOR_BGreen}Install of backup-cron.sh complete.${COLOR_off}"

}


## ----------------------------------------------------------------------------
## compile the fortunes
## ----------------------------------------------------------------------------
function compile_fortunes {
    checkpoint 'compile_fortunes'
    
    echo -e "${COLOR_Blue}Setting up fortunes.${COLOR_off}"

    if [[ "$(which strfile)" ]]
    then 
        cd $HOME
        wget https://raw.github.com/swirepe/arXiv-fortunes/master/csarxiv.tar.gz
        tar -xzvf csarxiv.tar.gz
        
        mkdir -p $HOME/pers/quotes/fortunes_pers
        cd $HOME/pers/quotes
        python compile.py
        
        echo -e "${COLOR_BGreen}Fortunes successfully compiled.${COLOR_off}"
    else
        echo -e "${COLOR_BYellow}WARNING: fortunes package not installed." 
    fi

}

## ----------------------------------------------------------------------------
## bashrc_nomem
## ----------------------------------------------------------------------------
function bashrc_nomem {
    checkpoint 'bashrc_nomem'

    echo -e "${COLOR_Blue}Creating ~/.bashrc_nomem${COLOR_off}"
    echo -e "${COLOR_Blue}Remove it if you want all scripts to be stored on a ramdisk.${COLOR_off}"
    touch $HOME/.bashrc_nomem


}
## ----------------------------------------------------------------------------
## done.
## ----------------------------------------------------------------------------

function all_done {
    checkpoint 'all_done'
    
    rm $HOME/setup-new-machine.checkpoint
    cd $HOME
    
    echo -e "${COLOR_BGreen}Done!${COLOR_off}"

}

## ----------------------------------------------------------------------------
## these are all the things in the order that they appear in
## ----------------------------------------------------------------------------


function gammut {
    intro
    names
    add_group_admin
    add_user_swirepe
    add_swirepe_to_sudoersd
    add_include_to_sudoers
    restart_as_swirepe
    debian_core
    util_check
    pi_specific
    keys
    add_keys_to_ssh
    config_ssh_persist
    clone_repos
    update_submodules
    update_oh_my_zsh_module
    symlinks
    build_scripts_sagi
    build_scripts_stderred
    build_scripts_j
    build_scripts_ag
    build_scripts_git_extras
    build_scripts_parallel
    build_scripts_csvkit
    install_backup_cron
    compile_fortunes
    bashrc_nomem
    all_done
}


STARTING_POINT=''
if [ -e $HOME/setup-new-machine.checkpoint ]
then
    STARTING_POINT="$(cat $HOME/setup-new-machine.checkpoint)"
fi

if [[ "$1" ]]
then
    if [[ "$1 " == "-h"     ]]   ||
       [[ "$1 " == "--help" ]]
    then
       intro
       exit 0
    else
        STARTING_POINT="$1"  
    fi
fi

## if you aren't asking for help, we can start this behind a tee
start_behind_tee

echo "Starting at $STARTING_POINT"

case  $STARTING_POINT  in
    start_behind_tee)              start_behind_tee               ;&
    intro)                         intro                          ;&
    names)                         names                          ;&
    add_group_admin)               add_group_admin                ;& 
    add_user_swirepe)              add_user_swirepe               ;&
    add_swirepe_to_sudoersd)       add_swirepe_to_sudoersd        ;&
    add_include_to_sudoers)        add_include_to_sudoers         ;&
    add_include_to_sudoers)        add_include_to_sudoers         ;&
    restart_as_swirepe)            restart_as_swirepe             ;&
    debian_core)                   debian_core                    ;&
    util_check)                    util_check                     ;&
    pi_specific)                   pi_specific                    ;&
    keys)                          keys                           ;&
    add_keys_to_ssh)               add_keys_to_ssh                ;&
	config_ssh_persist)            config_ssh_persist             ;&
    clone_repos)                   clone_repos                    ;&
    update_submodules)             update_submodules              ;&
    update_oh_my_zsh_module)       update_oh_my_zsh_module        ;&
    symlinks)                      symlinks                       ;&
    build_scripts_sagi)            build_scripts_sagi             ;&
    build_scripts_stderred)        build_scripts_stderred         ;&
    build_scripts_j)               build_scripts_j                ;&
    build_scripts_ag)              build_scripts_ag               ;&
    build_scripts_git_extras)      build_scripts_git_extras       ;&
    build_scripts_parallel)        build_scripts_parallel         ;&
    build_scripts_csvkit)          build_scripts_csvkit           ;&
    install_backup_cron)           install_backup_cron            ;&
    compile_fortunes)              compile_fortunes               ;&
    bashrc_nomem)                  bashrc_nomem                   ;&
    all_done)                      all_done                       ;;
    build_scripts)                 build_scripts                  ;;
    *)                             gammut                         ;;
    
esac





