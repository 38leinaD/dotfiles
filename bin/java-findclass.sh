#!/bin/bash

shopt -s globstar

search_jar() {
    jarpath=$1

    echo "> Searching $jarpath for $2"
    jar -tvf "${jarpath}" | grep ${2}
    if [[ $? == 0 ]];
    then
        echo -e "\E[32m *** found *** in $jarpath\033[0m"
    fi
}
export -f search_jar
find . -name "*.*ar" -type f | xargs -n 2 -P 5 -I {} bash -c "search_jar {} $1"

# even simpler:
# for i in *.jar; do jar -tvf "$i" | grep -Hsi ClassName && echo "$i"; done
