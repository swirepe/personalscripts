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




## ----------------------------------------------------------------------------
## linux-specific
## ----------------------------------------------------------------------------
echo -e "${COLOR_BIBlue}user:${COLOR_off}\t$(whoami)"
echo -e "${COLOR_BIBlue}host:${COLOR_off}\t$(hostname)"


DEBIAN="false"
if [[ $(which apt-get) ]]
then
    DEBIAN="true"
    echo -e "${COLOR_Blue}Program apt-get found.  Assuming Debian.${COLOR_off}"
    echo -e "${COLOR_Blue}Upgrading and installing core packages.${COLOR_off}"
    sudo apt-get update
    sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev git-core build-essential cmake openssl
fi


## ----------------------------------------------------------------------------
## make sure we have all the programs we need
## ----------------------------------------------------------------------------

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

## ----------------------------------------------------------------------------
## get the keys and extract them
## ----------------------------------------------------------------------------

echo -e "${COLOR_Blue}Fetching keys.${COLOR_off}"

wget http://swirepe.com/keys.tar.gz.des3

## to compress
## tar -czf keys.tar.gz keys/
## to encrypt
## openssl des3 -in keys.tar.gz -out keys.tar.gz.des3 

echo -e "${COLOR_Blue}Decrypting keys.${COLOR_off}"

openssl des3 -d -in keys.tar.gz.des3 -out keys.tar.gz
tar zxvf keys.tar.gz


## ----------------------------------------------------------------------------
## start ssh agent
## ----------------------------------------------------------------------------

echo -e "${COLOR_Blue}Adding keys to ssh agent.${COLOR_off}"

eval `ssh-agent -s` 

yes yes | ssh-add $HOME/pers/keys/bitbucket-key
yes yes | ssh-add $HOME/pers/keys/github-key

echo -e "${COLOR_BGreen}Keys successfully added.${COLOR_off}"


## ----------------------------------------------------------------------------
## clone the repos
## ----------------------------------------------------------------------------

echo -e "${COLOR_Blue}Cloning repositories.${COLOR_off}"

git clone git@bitbucket.org:swirepe/machines.git $HOME/pers/machines
git clone git@bitbucket.org:swirepe/fortunes.git $HOME/pers/quotes
git clone git@github.com:swirepe/personalscripts.git $HOME/pers/scripts

cd $HOME/pers/scripts
git submodule update --init --recursive 


echo -e "${COLOR_Blue}Updating oh-my-zsh (even if you aren't using it.)${COLOR_off}"
cd $HOME/pers/scripts/src/oh-my-zsh-copy
git remote add bitbucket git@bitbucket.org:swirepe/oh-my-zsh-copy.git
git pull bitbucket master


echo -e "${COLOR_BGreen}Repositories successfully cloned.${COLOR_off}"


## ----------------------------------------------------------------------------
## symlink everything in place
## ----------------------------------------------------------------------------

function move_if_exists {
    FILE=$1
    [ -e $FILE ] && tar -zcf "$FILE-$(shasum $FILE | cut -c 1-5)" $FILE && rm -r $FILE
    cd $HOME
}


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


## ----------------------------------------------------------------------------
## build some scripts if we can
## ----------------------------------------------------------------------------

if [[ "$DEBIAN" == "true" ]]
then
    echo -e "${COLOR_Blue}Installing vim ipython gnupg fortune-mod python-pygments python-pip moreutils zsh${COLOR_off}"
    $HOME/pers/scripts/sagi -y fortune-mod vim ipython gnupg python-pygments python-pip moreutils zsh
    
    echo -e "${COLOR_Blue}Making stderred.${COLOR_off}"
    cd $HOME/pers/scripts/src/stderred
    make || make 32
    echo -e "${COLOR_BGreen}Build of stderred complete.${COLOR_off}"
    
    
    echo -e "${COLOR_Blue}Building the j programming language.${COLOR_off}"
    cd $HOME/pers/scripts/src
    SCRIPTS_DIR=$HOME/pers/scripts ./buildj.sh
    echo -e "${COLOR_BGreen}Build of the j programming language complete.${COLOR_off}"
    
    
    echo -e "${COLOR_Blue}Building the silver searcher.${COLOR_off}"
    cd $HOME/pers/scripts/src/silversearcher
    ./build.sh
    sudo make install
    echo -e "${COLOR_BGreen}Build of the silver searcher complete.${COLOR_off}"
    
    
    echo -e "${COLOR_Blue}Building git-extras.${COLOR_off}"
    cd $HOME/pers/scripts/src/git-extras
    sudo make install
    echo -e "${COLOR_BGreen}Build of git-extras complete.${COLOR_off}"
    
    
    echo -e "${COLOR_Blue}Fetching and installing gnu parallel.${COLOR_off}"
    cd /tmp
    wget http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
    tar -xvjf parallel-latest.tar.bz2
    cd parallel*
    ./configure
    make
    sudo make install
    echo -e "${COLOR_BGreen}Install of gnu parallel complete.${COLOR_off}"
    
    echo -e "${COLOR_Blue}Building and installing csvkit.${COLOR_off}"
    cd $HOME/pers/scripts/src/csvkit
    sudo python setup.py install
    echo -e "${COLOR_BGreen}Install of csvkit complete.${COLOR_off}"

fi


## ----------------------------------------------------------------------------
## compile the fortunes
## ----------------------------------------------------------------------------

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



## ----------------------------------------------------------------------------
## bashrc_nomem
## ----------------------------------------------------------------------------

echo -e "${COLOR_Blue}Creating ~/.bashrc_nomem${COLOR_off}"
echo -e "${COLOR_Blue}Remove it if you want all scripts to be stored on a ramdisk.${COLOR_off}"
touch $HOME/.bashrc_nomem



## ----------------------------------------------------------------------------
## done.
## ----------------------------------------------------------------------------

cd $HOME

echo -e "${COLOR_BGreen}Done!${COLOR_off}"
