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
git clone $URL $TEMP_DIR > /dev/null || $(echo "Error cloning $URL" && exit 1)
cd $TEMP_DIR


echo -e "day\tloc\tsubmodules"
while read -r line 
do
    #echo -e "${line}"
    HASH=$(echo $line | awk '{print $1}')
    DATE=$(echo $line | awk '{print $2}')
    git checkout $HASH &> /dev/null
    
    
    echo -e "${DATE}\t$(getlines)\t$(git submodule | wc -l)"
done <<< "$(git log --no-merges --date=iso --pretty=format:'%H %cd')"

rm -rf $TEMP_DIR


## You can put this in a database pretty easily
# repo_growth.sh <url> | tee growth.tsv && csvsql --tabs --db sqlite:///growth.sqlite --insert growth.tsv && sqlite3 growth.sqlite
# select day, max(loc), submodules from growth group by day order by day;
