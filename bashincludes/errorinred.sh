
# see https://github.com/sickill/stderred

export LD_PRELOAD="$SCRIPTS_DIR/src/stderred/build/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
