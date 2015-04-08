#!/bin/bash

function printerr
{
    echo "Error: $1" 1>&2
    echo "Usage: 'timesheet <-d[days]> <-h[hours]> <-m[minutes]> [Company Name]"
}

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
        echo " Tiemsheet  of $(whoami). Created on $(date)." >> $1
        echo "=========================================================" >> $1
        echo
    fi
}

function processArgs
{
    # Acept only one argument
    # Accept arguments that begin with '-'
    # Only flags valid are a, d, t
    # Check all arguments

    COMPANY_COUNT=""
    for arg in $@
    do
        if ! [[ ${arg:0:1} == "-" ]]; then
            if [[ $COMPANY_COUNT == "" ]]; then
                COMPANY_NAME=$arg
                COMPANY_COUNT=1
            elif [[ $COMPANY_COUNT == 1 ]]; then
                printerr "More than one company name given: $arg"
                exit 1
            fi

        #If the argument does begin with '-'
        #Iterate through the letters after the '-'
        elif [[ ${arg:0:1} == "-" ]]; then
        case ${arg:1:1} in
            d) PRINTDAY=""
              DAY_VALUE="${arg:2:${#arg}}"
              ;;
            h) PRINTHOUR=""
              HOUR_VALUE="${arg:2:${#arg}}"
              ;;
            m) PRINTMINUTE=""
              MINUTE_VALUE="${arg:2:${#arg}}"
              ;;
            *) printerr "unknown option: ${arg:$i:1}";
               exit 2;;
        esac
        fi
    done
}

#################
## MAIN SCRIPT ##
#################

TIMESHEET_FILE=".timesheet"

checkfile $TIMESHEET_FILE
processArgs $@

echo "$(date +"%a, %b %d, %Y"): $COMPANY_NAME $DAY_VALUE days, $HOUR_VALUE hours, $MINUTE_VALUE minutes" >> .timesheet
