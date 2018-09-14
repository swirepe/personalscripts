# this is basically an index into all the things we want to include 
# when we start a new shell

# verbose: call out the names of the included files
# and mark them as executable so that we can see them afterwards


if [ -f ~/.bashrc_verbose ]
then
    echo -e "\e[1;35m[bashrc.include] Including files.\e[0m"
    VERBOSE="True"
    rm ~/.bashrc_verbose
    
    # unmark everything
    chmod -x $BASHINCLUDES_DIR/*.sh
    chmod -x $ZSHINCLUDES_DIR/*.sh
    
else
    VERBOSE=""
fi

function source_include {
    if [ -n "$VERBOSE" ]
    then        
        START_TIME=$(date +%s)
        source $@
        chmod +x $@   # now we can see what we ran
        END_TIME=$(date +%s)
        echo -e "\e[0;35m$(echo "$END_TIME - $START_TIME" | bc -l)s \t$1\e[0m"
    else
        if [[ -f $@ ]]
        then
            source $@
        else
            echo "[zshincludes/INCLUDE.sh] File not found: $@" 1>&2
        fi
    fi

}

# best to start with the core
source_include $ZSHINCLUDES_DIR/zshrc_core.sh
source_include $ZSHINCLUDES_DIR/zbell.sh
source_include $ZSHINCLUDES_DIR/jython.sh
source_include $ZSHINCLUDES_DIR/report.sh
#source_include $ZSHINCLUDES_DIR/hosts.sh
source_include $ZSHINCLUDES_DIR/mandelbrot.sh
source_include $ZSHINCLUDES_DIR/meta-parent.sh
source_include $ZSHINCLUDES_DIR/completedots.sh
source_include $ZSHINCLUDES_DIR/cachecompletion.sh
source_include $ZSHINCLUDES_DIR/usercompletion.sh
source_include $ZSHINCLUDES_DIR/cachecompletion.sh
source_include $ZSHINCLUDES_DIR/somefile.sh
#source_include $ZSHINCLUDES_DIR/fbinfer.sh

source_include $ZSHINCLUDES_DIR/calendar.sh

source_include $BASHINCLUDES_DIR/color.sh
source_include $BASHINCLUDES_DIR/_work_dummy.sh
#source_include $BASHINCLUDES_DIR/work.sh

# show recent emails
#source_include $BASHINCLUDES_DIR/email.sh

source_include $BASHINCLUDES_DIR/misc.sh
#source_include $BASHINCLUDES_DIR/alwaysontop.sh
#source_include $BASHINCLUDES_DIR/navigation.sh
#source_include $BASHINCLUDES_DIR/projects.sh
source_include $BASHINCLUDES_DIR/pyg.sh
source_include $BASHINCLUDES_DIR/vim.sh
source_include $BASHINCLUDES_DIR/perl.sh
source_include $BASHINCLUDES_DIR/lsfancy.sh
source_include $BASHINCLUDES_DIR/colorman.sh
source_include $BASHINCLUDES_DIR/clipboard.sh
source_include $BASHINCLUDES_DIR/gitfns.sh
source_include $BASHINCLUDES_DIR/vagrant.sh
source_include $BASHINCLUDES_DIR/jlanguage.sh
source_include $BASHINCLUDES_DIR/gitfn.sh
source_include $BASHINCLUDES_DIR/autonavigation.sh  
source_include $BASHINCLUDES_DIR/headtail.sh
source_include $BASHINCLUDES_DIR/ramdiskscripts.sh
source_include $BASHINCLUDES_DIR/virtualenvs.sh
source_include $BASHINCLUDES_DIR/errorinred.sh
source_include $BASHINCLUDES_DIR/z.sh
source_include $BASHINCLUDES_DIR/lsfn.sh
source_include $BASHINCLUDES_DIR/lstmux.sh
source_include $BASHINCLUDES_DIR/ssh-agent.sh
source_include $BASHINCLUDES_DIR/mac.sh
source_include $BASHINCLUDES_DIR/fortunes.sh
source_include $BASHINCLUDES_DIR/bt.sh
source_include $BASHINCLUDES_DIR/psql.sh
source_include $BASHINCLUDES_DIR/tiny-care-terminal.sh
source_include $BASHINCLUDES_DIR/gopath.sh
source_include $BASHINCLUDES_DIR/bin.sh
