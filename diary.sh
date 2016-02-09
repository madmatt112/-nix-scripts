#!/bin/bash

#Authors: AJ Armstrong and Matthew Field
#This script is a nifty little journaling script I wrote for class
#It takes a few arguments to specify timestamping of entries
#It reads lines of text entered by the user, and writes them to ./.journal
#If called with (and only with) -p, it prints the journal file


#Print an error with usage message
function printerr
{
    echo "Error: $1" 1>&2
    echo "Usage: 'diary.sh <-p>' OR"
    echo "Usage: 'diary.sh  <-a> <-d> <-t>'"
}

#Parses arguments, taking actions as neccessary.
function checkargs
{
    # Only accept arguments that begin with '-'
    # Only flags valid are a, d, t
    #Check all arguments

    for arg in $@
    do
        #Check that the first character is '-'
        if ! [[ ${arg:0:1} == "-" ]]; then
            printerr "Unknown argument: $arg"
            exit 1
        fi

        #Iterate through the letters after the -
        for (( i=1 ; i<${#arg} ; i++ ))  #go from 1 to the length of arg
        do
            case ${arg:$i:1} in
                a) PRINTDAY=true;;
                d) PRINTDATE=true;;
                t) PRINTTIME=true;;
                p) PRINTDIARY=true;;
                *) printerr "unknown option, dumbass: ${arg:$i:1}";
                   exit 2;;
            esac
        done

    #If -p is included with any other argument, printerr.
    if [[ $PRINTDIARY ]]; then
        if [[ $PRINTDAY ]] || [[ $PRINTDATE ]] || [[ $PRINTTIME ]]; then
            printerr "-p must be only argument if present"
            exit 5
        else
            echo "Here is your diary's contents:"
            cat $FILE
            exit 0
        fi
    fi
    done
    return 0;
}

#Check if file exists, if not then create it and add header
#Filename is arg 1
function checkfile
{
    if (( $# != 1 )); then
        printerr "No argument passed to checkfile"
        exit 3
    fi

    if ! [[ -e "$1" ]]
    then
        #File doesn't exist. Create it and set up
        touch "$1"
        echo "=========================================================" >> $1
        echo " Diary of $(whoami). Created on $(date)." >> $1
        echo "=========================================================" >> $1
        echo
    fi
}

function writeheader
{
    if (( $# != 1 )); then
        printerr "No argument passed to writeheader"
        exit 3
    fi

    HEADER="" #Start with an empty one
    if [[ $PRINTDAY ]]; then HEADER="$(date +%a)"; fi
    if [[ $PRINTDATE ]]; then
        if [[ $HEADER ]]; then HEADER="${HEADER}, "; fi
        HEADER="${HEADER}$(date '+%D %b %Y')"
    fi

    if [[ $PRINTTIME ]]; then
        if [[ $HEADER ]]; then HEADER="${HEADER}, "; fi
        HEADER="${HEADER}$(date '+(%H:%M)')"
    fi

    if [[ $HEADER ]]; then HEADER="${HEADER} - "; fi

    if [[ $HEADER ]]; then echo -n $HEADER >> $1; fi
}
    

##############
#Main Routine#
##############

FILE=./.diary

checkargs $@
checkfile $FILE
writeheader $FILE
echo >> $FILE

#Get diary entry from user - Why we're here!
echo "Type your diary entry. Two carriage returns to end."
read LINE
while [[ $LINE ]] #Two carriage returns kills the While
do
    echo " $LINE" >>$FILE
    read LINE
done
