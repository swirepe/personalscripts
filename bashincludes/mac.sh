
if [[ "$(uname)" == "Darwin" ]]
then
    ## for allowing files to be run that have been downloaded
    alias allow="xattr -d com.apple.quarantine"

    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

fi
