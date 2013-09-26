#!/usr/bin/env bash
URL="$1"
# clone the repo to a blank place

if [[ -z "$URL" ]]
then
    echo "Usage: repo_growth.sh <url>" >/dev/stderr
    exit 1
fi

if ! which cloc &> /dev/null
then
    echo "This program requires cloc." >/dev/stderr
    exit 2
fi

function getlines {
    cloc --quiet . 2>/dev/null | grep SUM | awk '{print $5}'
}


TEMP_DIR=$(mktemp -d /tmp/repo_growth_XXXX)
git clone $URL $TEMP_DIR || $(echo "Error cloning $URL" && exit 1)
cd $TEMP_DIR


while read -r line 
do
    #echo -e "${line}"
    HASH=$(echo $line | awk '{print $1}')
    DATE=$(echo $line | awk '{print $2}')
    git checkout $HASH &> /dev/null
    
    
    echo -e "${DATE}\t$(getlines)"
done <<< "$(git log --no-merges --date=iso --pretty=format:'%H %cd')"

rm -rf $TEMP_DIR
