#!/bin/sh

#This script is a fun way for me to delete a batch of files
#based on a matched *string* in a given directory.
#You are MUCH better off just using 'rm' wisely.

#Modify the shell's delimiter for use in remove_files() subshell, specifically
#to handle the "find" results easily.
old_IFS="$IFS"
IFS="
"

#Create a ~/log folder if none exists.
LOG_DIR="/home/`whoami`/log"

if [ ! -d "$LOG_DIR" ]
then
    mkdir $LOG_DIR
fi

#If a rmim logfile exists, back it up once.
if [ -f ${LOG_DIR}/rmimDeletedFiles.log ]
then
    mv ${LOG_DIR}/rmimDeletedFiles.log ${LOG_DIR}/rmimDeletedFiles.previous.log
fi

#For each string specified as a script argument,
#Find all files containing the string in the current directory.
remove_files()
{
  for i in $(find $1 -name "*$2*")
  do
    echo -n "Delete this file? $i: "
    while :
    do
        read DELETE_DECISION
        if [ -z $DELETE_DECISION ]
        then
            DELETE_DECISION="yes"
        fi
        case $DELETE_DECISION in
            'y'|'yes')
              rm $i
              echo $i >> "${LOG_DIR}/rmimDeletedFiles.log"
              break
              ;;
            'n'|'no')
              echo "File retained"
              break
              ;;
            *)
              echo "You must make a choice."
              echo -n "Delete this file? $i: "
              ;;  
        esac
    done
  done
}

#
### MAIN SCRIPT STARTS HERE
#

#If no argument is given, setup for interactive walkthrough
if [ -z $1 ]
then
    DIR="***INT***"
#If a first argument is given, setup variables for non-interactive.
elif [ -n $1 ]
then
    DIR=$1
fi
if [ -n $2 ]
then
    SEARCH_STRING=$2
fi

case $DIR in
    "-h")
        echo "This script removes files for you."
        echo "When run with no arguments, it will walk you through it's actions"
        echo "Otherwise, the script will delete all files matching the second argument in the directory specified in the first."
        echo ""
        echo "usage \"rmim -h\" : Display this help and exit"
        echo "      \"rmim <directory> <matched string>\""
        echo "       Deletes all files that match <string> in <directory>. Default directory is \".\""
        echo "      \"rmim\" Run rmim interactively, with a helpful walkthrough"
        ;;

    "$1")
        echo "Script was called non-interactively, removing files..."
        remove_files $DIR $SEARCH_STRING
        ;;


    "***INT***")    
        echo ""
        echo "--- This script will remoe files if you have permission. BE CAREFUL. ---"
        echo "--- This script is designed to be run as root. ---"
        echo "--- If you are not root, you will get a whack of permissions errors. ---"
        echo ""
        echo -n "Are you sure you want to run this script? [y/n] "

        while :
        do
          read CONT
          case $CONT in
              "y"|"yes")
                  echo -n "Which directory shall we operate in?[current directory]: "
                  read DIR
                  echo -n "Please enter the string to be search for: "
                  read SEARCH_STRING
                  echo "--- Thank you, now removing. Confirmation will be requested for each file..."
                  sleep 2

                  #Determine what the current working directory is
                  #May be switched for "." so it can be added to $PATH
                  SCRIPT=$(readlink -f "$0")
                  SCRIPT_DIR=$(dirname "$SCRIPT")

                  #Call the function!
                  remove_files ${DIR:="."} $SEARCH_STRING
                  break
                  ;;
              "n"|"no")
                  echo "Wise choice, young one"
                  break
                  ;;
              *)
                  echo "Please say yes or no: "
          esac
        done
        ;;
esac

#Return the Internat Field Seperator to normal (see top of script)
IFS=$old_IFS
echo "Safely completed"
