
if [[ "$(uname)" == "Darwin" ]]
then
    ## for allowing files to be run that have been downloaded
    alias allow="xattr -d com.apple.quarantine"

    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

		function infinder {
			  if [[ -z "$1" ]]
					 open -a Finder .
				 else
					 open -a Finder "$1"
				 fi
  	}	

		function interm {
				if [[ -z "$1" ]]
				then
					open -a iTerm ~
				else
					open -a iTerm "$1"
				fi
		}
fi
