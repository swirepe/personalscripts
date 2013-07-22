#!/usr/bin/env bash


## ----------------------------------------------------------------------------
## set up error checking
## ----------------------------------------------------------------------------
# fail on any errors (same as set -e)
set -o errexit

function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    echo "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}: $(sed -n ${LASTLINE}p $0)"
    exit 1
}
trap 'error ${LINENO} ${$?}' ERR


## ----------------------------------------------------------------------------
## make sure we have all the programs we need
## ----------------------------------------------------------------------------

cd $HOME

echo "Checking wget."
which wget
echo "Checking git."
which git
echo "Checking openssl"
which openssl


mkdir $HOME/pers


## ----------------------------------------------------------------------------
## get the keys and extract them
## ----------------------------------------------------------------------------

wget http://swirepe.com/keys.tar.gz.des3

## to compress
## tar -czf keys.tar.gz keys/
## to encrypt
## openssl des3 -in keys.tar.gz -out keys.tar.gz.des3 


openssl des3 -d -in keys.tar.gz.des3 -out keys.tar.gz
tar zxvf keys.tar.gz


## ----------------------------------------------------------------------------
## clone the repos
## ----------------------------------------------------------------------------

ssh-add $HOME/pers/keys/bitbucket-key
ssh-add $HOME/pers/keys/github-key


git clone git@bitbucket.org:swirepe/machines.git $HOME/pers/machines
git clone git@bitbucket.org:swirepe/fortunes.git $HOME/.fortunes
git clone git@github.com:swirepe/personalscripts.git $HOME/pers/scripts


cd $HOME/pers/scripts
git submodule update --init --recursive 

## ----------------------------------------------------------------------------
## symlink everything in place
## ----------------------------------------------------------------------------

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

touch $HOME/.bashrc_nomem
