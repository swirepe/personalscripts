
if [ "$(uname)" == "Darwin" ]
then
    ## for allowing files to be run that have been downloaded
    alias allow="xattr -d com.apple.quarantine"
fi
