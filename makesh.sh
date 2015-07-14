#!/bin/bash
#Creates a shell file as per NETE2000 requirements.

FILE=~/bin/$1

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
