
# see https://github.com/sickill/stderred
if [[ -f "$SCRIPTS_DIR/src/stderred/build/libstderred.so" ]]
then
    export LD_PRELOAD="$SCRIPTS_DIR/src/stderred/build/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"
else
    echo "[errorinred.sh] libstderred.so not found."
fi
    
