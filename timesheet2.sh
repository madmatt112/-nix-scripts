#!/bin/bash

###
###  This script works similarly to v1, but it converts
###  days and hours entered into minutes. It also only
###  ever uses one entry per company, so look for that
###  functionality in writeLines{}
###
###  Author: Matthew Field
###  Licence: Free as in beer, Free as in speech.
###  Disclaimer: Plagiarism is still a risk if used for
###  purposes.



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
#        echo "==============================================================" >> $1
#        echo "== Timesheet  of $(whoami). Created on $(date). ==" >> $1
#        echo "==============================================================" >> $1
#        echo
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
            d)if [[ $DAY_VALUE ]]; then
                printerr "Duplicate argument: -d"
                exit 4
              fi
              DAY_VALUE="${arg:2:${#arg}}"
              DAYS_IN_MINUTES=$(( $DAY_VALUE * 8 * 60 ))
              ;;
            h)if [[ $HOUR_VALUE ]]; then 
                printerr "Duplicate argument: -h"
                exit 4
              fi
              HOUR_VALUE="${arg:2:${#arg}}"
              HOURS_IN_MINUTES=$(( $HOUR_VALUE * 60 ))
              ;;
            m)if [[ $MINUTE_VALUE ]]; then
                printerr "Duplicate argument: -m"
                exit 4
              fi
              MINUTE_VALUE="${arg:2:${#arg}}"
              ;;
            *) printerr "unknown option: ${arg:1:1}";
               exit 2;;
        esac
        fi
    done

#Convert hours and days to minutes
MINUTE_VALUE=$((${DAYS_IN_MINUTES:-0} + ${HOURS_IN_MINUTES:-0} + ${MINUTE_VALUE:-0}))

}


function writeLines {

#This function actually writes the lines to a tempfile.

touch $TEMP_FILE
HEADER_LINE_COUNT=0
COMPANY_BOOL=""
while read line
do

    #If the company name already exists, add the existing minutes
    #to the minutes variable, and write the new line to tempfile

    for word in $line
    do
        
        if [[ $word =~ "$COMPANY_NAME"  ]]        
        then
            COMPANY_BOOL="true"
        fi

        if [[ $word =~ ^[0-9]+$ ]] 
        then
            if [[ $COMPANY_BOOL ]]
            then
                MINUTE_VALUE=$(($MINUTE_VALUE + $word))
                echo "$COMPANY_NAME $MINUTE_VALUE minutes" >> $TEMP_FILE
            fi
        fi        

        if ! [[ $COMPANY_BOOL ]]
        then
            echo $line >> $TEMP_FILE
            break
        fi

    done
done < $TIMESHEET_FILE

#If no existing line contains the entered company's name, create a new line
#for the company.
if ! [[ $COMPANY_BOOL ]]
then
    echo "$COMPANY_NAME $(($DAY_IN_MINUTES + $HOURS_IN_MINUTES + $MINUTE_VALUE)) minutes" >> $TEMP_FILE
fi

}

#################
## MAIN SCRIPT ##
#################

TIMESHEET_FILE=".timesheet2"
TEMP_FILE="/tmp/timesheet_temp_file"

if [[ -e $TEMP_FILE ]];then rm $TEMP_FILE; fi
checkfile $TIMESHEET_FILE
processArgs $@
writeLines

# If all completes well, write out to permanent file and clean up
cp $TEMP_FILE $TIMESHEET_FILE
rm $TEMP_FILE
