while read line
do
    for word in $line
    do
        echo "$word is the current word"
        if [[ $word ]] 
        then
            echo "$word exists and test works inside this loop"
        fi
        if [[ $word =~ ^[0-9]+$ ]]
        then
            echo "$word is a number!"
        fi
    done
done < numbers
