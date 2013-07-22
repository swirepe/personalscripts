#!/usr/bin/env bash

## ----------------------------------------------------------------------------
## define some colors to make this all pretty
## ----------------------------------------------------------------------------


COLOR_off='\033[0m'
COLOR_Red='\033[0;31m'
COLOR_BGreen='\033[1;32m'
COLOR_Blue='\033[0;34m'

## ----------------------------------------------------------------------------
## set up error checking
## ----------------------------------------------------------------------------
# fail on any errors (same as set -e)
set -o errexit

function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    echo -e "${COLOR_Red}ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}: $(sed -n ${LASTLINE}p $0) ${COLOR_off}"
    exit 1
}
trap 'error ${LINENO} ${$?}' ERR




echo -e "${COLOR_Blue}user:${COLOR_off}\t$(whoami)"
echo -e "${COLOR_Blue}host:${COLOR_off}\t$(hostname)"


PS3="Is this correct? "
select option in yes no
do
    case $option in
        y|yes) 
            echo -e "${COLOR_BGreen}Proceeding.${COLOR_off}"
            ;;
        *) 
            echo -e "${COLOR_Red}Exiting.${COLOR_off}"  
            exit
          ;;
     esac
done




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

ssh-add $HOME/pers/keys/bitbucket-key
ssh-add $HOME/pers/keys/github-key

echo -e "${COLOR_BGreen}Keys successfully added.${COLOR_off}"


## ----------------------------------------------------------------------------
## clone the repos
## ----------------------------------------------------------------------------

echo -e "${COLOR_Blue}Cloning repositories.${COLOR_off}"

git clone git@bitbucket.org:swirepe/machines.git $HOME/pers/machines
git clone git@bitbucket.org:swirepe/fortunes.git $HOME/.fortunes
git clone git@github.com:swirepe/personalscripts.git $HOME/pers/scripts


cd $HOME/pers/scripts
git submodule update --init --recursive 

echo -e "${COLOR_BGreen}Repositories successfully cloned.${COLOR_off}"

## ----------------------------------------------------------------------------
## symlink everything in place
## ----------------------------------------------------------------------------

echo -e "${COLOR_Blue}Symlinking files into place.${COLOR_off}"

[ -e ~/.bashrc ] && mv ~/.bashrc "$HOME/.bashrc-$(shasum ~/.bashrc | cut -c 1-5)"
[ -e ~/.vimrc  ] && mv ~/.vimrc "$HOME/.vimrc-$(shasum ~/.vimrc | cut -c 1-5)"
[ -e ~/.tmux.conf  ] && mv ~/.tmux.conf "$HOME/.tmux.conf-$(shasum ~/.vimrc | cut -c 1-5)"
[ -e ~/.gitconfig  ] && mv ~/.gitconfig "$HOME/.gitconfig-$(shasum ~/.vimrc | cut -c 1-5)"

ln -s $HOME/pers/scripts/rc/bashrc.init $HOME/.bashrc
ln -s $HOME/pers/scripts/rc/vimrc2 $HOME/.vimrc
ln -s $HOME/pers/scripts/rc/tmux.conf $HOME/.tmux.conf
ln -s $HOME/pers/scripts/rc/gitconfig $HOME/.gitconfig
ln -s $HOME/pers/scripts/gitignoreglobal $HOME/.gitignore_global
ln -s $HOME/pers/scripts/grepignore $HOME/.grepignore

echo -e "${COLOR_BGreen}Files successfully symlinked.${COLOR_off}"



echo -e "${COLOR_Blue}Creating ~/.bashrc_nomem${COLOR_off}"
echo -e "${COLOR_Blue}Remove it if you want all scripts to be stored on a ramdisk.${COLOR_off}"
touch $HOME/.bashrc_nomem


## ----------------------------------------------------------------------------
## done.
## ----------------------------------------------------------------------------

cd $HOME

echo -e "${COLOR_BGreen}Done!${COLOR_off}"
