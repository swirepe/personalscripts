#!/bin/bash

# This short script builds the j language from source, so that you have it for whatever platform you happen to be on
# j is basically the world's best calculator, forever and ever, world without end.  Amen.
# http://www.jsoftware.com/source.htm
# (or, more specifically, http://www.jsoftware.com/download/j701_b_source.tar.gz )
## exit on error
set -e

# since tar only works from a current working directory thing, change the directory
pushd . > /dev/null
cd $SCRIPTS_DIR/src
tar -xzf $SCRIPTS_DIR/src/j701_b_source.tar.gz
$SCRIPTS_DIR/src/jgplsrc/bin/build_libj
$SCRIPTS_DIR/src/jgplsrc/bin/build_jconsole

mkdir -p $SCRIPTS_DIR/j
mv $SCRIPTS_DIR/src/jgplsrc/j/bin $SCRIPTS_DIR/j
popd
