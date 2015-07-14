#!/bin/bash
#
# Creates a file, sets execute permissions for owner, writes a skelton framework,
# and opens the file in VIm.
# Modify the FILE variable to suit your filestructure.

FILE=$HOME/nix-scripts/$1

if [ -f $FILE ]
  then
    echo "Error: File Exists and this will overwrite. Exiting"
    exit 1
fi

touch $FILE
chmod u+x $FILE

echo "#!/bin/bash" > $FILE
echo "#" >> $FILE
echo "# Name: $1" >>$FILE
echo "# Author: Matthew Field" >> $FILE
echo "# Date: `date +"%b %d, %Y"`" >> $FILE
echo "#" >> $FILE
echo "# Description: " >> $FILE

vim $FILE
