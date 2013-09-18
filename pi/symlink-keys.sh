#!/usr/bin/env bash

# this script mov the keys from .ssh to $HOME/pers/keys, then symlinks in the 
# opposite direction

for key in $(find $HOME/.ssh -name '*.pub' ) 
do
    # don't move symbolic links
    if [ ! -L $key ]
    then
        privkey="$(echo $key | sed 's/....$//')"
        
        mv $key "$HOME/pers/keys/$(basename $key)"
        mv $privkey "$HOME/pers/keys/$(basename $privkey)"
    fi
done



for key in $(find $HOME/pers/keys -name '*.pub' ) 
do
    privkey="$(echo $key | sed 's/....$//')"
    
    ln -s $key "$HOME/.ssh/$(basename $key)"
    ln -s $privkey "$HOME/.ssh/$(basename $privkey)"
done
