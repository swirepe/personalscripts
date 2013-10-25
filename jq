#!/usr/bin/env bash

if [[ uname == "Darwin" ]]
then
	$SCRIPTS_DIR/src/jq-osx $*
else
	$SCRIPTS_DIR/src/jq-linux $*
fi
