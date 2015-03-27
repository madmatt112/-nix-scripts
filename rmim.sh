#!/bin/sh

#This script is a fun way for me to delete a batch of files
#based on a matched *string* in a given directory.
#You are MUCH better off just using 'rm' wisely.

#Modify the shell's delimiter for use in remove_files() subshell
old_IFS="$IFS"
IFS="
"

#For each string specified as a script argument,
#Find all files containing the string in the current directory
remove_files()
{
  for i in $(find $1 -name "*$2*")
  do
    rm $i
    echo "Removed $i"
  done
}

#
### MAIN SCRIPT STARTS HERE
#


#FIXME Place the -h if statement inside the Interactive if statement


#Non-interactive Mode
if [ $1 ]
    if [ $1 = "-h" ]
    then
        echo "This script removes files for you."
        echo "When run with no arguments, it will walk you through it's actions"
        echo "Otherwise, the script will delete all files matching the second argument in the directory specified in the first."i
        echo ""
        echo "usage \"rmim -h\" : Display this help and exit"
        echo "      \"rmim <directory> <matched string>\""
        echo "       Deletes all files that match <string> in <directory>. Default directory is \".\""
        echo "      \"rmim\" Run rmim interactively, with a helpful walkthrough"
    fi
then
    echo "Script was called non-interactively"
    remove_files $1 $2

#Interactive Mode
elif [ $1 -z ]
then
    
    echo ""
    echo "---This script is designed to be run as root.---"
    echo "--- If you are not root, you will get a whack of permissions errors.---"
    echo "Are you sure you want to run this script? [y/n]"

    while :
    do
      read CONT
      case $CONT in
          y|yes)
              echo "Which directory shall we operate in? [current directory]:"
              read DIR
              echo "Please enter the string to be search for. \
    Wildcards are accepted. Regex may or may not be, use with caution \
    [no default]"          
              read SEARCH_STRING
              echo "---Removing all results, please wait...---"

              #Determine what the current working directory is
              #May be switched for "." so it can be added to $PATH
              SCRIPT=$(readlink -f "$0")
              SCRIPT_DIR=$(dirname "$SCRIPT")

              #Call the function!
              remove_files ${DIR:="."} $SEARCH_STRING
              break
              ;;
          n|no)
              echo "Wise choice, young one"
              break
              ;;
          *)
              echo "Please say yes or no."
      esac
    done
fi

IFS=$old_IFS
