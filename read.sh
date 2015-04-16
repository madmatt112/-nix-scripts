#!/bin/bash
var=0
while read line
do
    var=$(($var + 1))
    echo "$var: $line" >> output
done < $1
