#!/usr/bin/env bash
openssl des3 -d -in $SCRIPTS_DIR/rc/mre.config.des3 -out ~/.mre.config
