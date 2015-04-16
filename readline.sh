#!/bin/bash

if [[ $# -ne 1 ]]; then
    1<&2 echo "Error. Need file name"
    exit 1
fi

if ! [[ -e $1 ]]; then
    1<&2 echo "$1 does not exist"
    exit 2
fi

re='^[0-9]+$'
if [[ -e /tmp/tempfile ]]; then rm /tmp/tempfile; fi
while read line
do
    total=0
    for val in $line
    do
        if [[ $val =~ $re ]] #A number! add it.
        then
            total=$(($total + $val))
        fi
    done
    echo "$line (Total:$total)" >> /tmp/tempfile
done < $1

mv /tmp/tempfile $1
