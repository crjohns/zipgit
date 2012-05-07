#!/bin/bash

function usage
{
    echo "Usage: $0 <command>"
    echo Commands:
    echo "open <zipfile>   - Open zip file as a remote"
    echo "close            - Close the opened zip file, and save data"
    echo "save             - Save the opened zip file without closing"
}

if test "$1" = "open"; then
    FILE=$2
    if test -z "$FILE"; then
        usage
        exit
    fi

    OPENFILE=`cat .zipgitopened 2>/dev/null`

    if test -n "$OPENFILE"; then
        echo "Failed to open $FILE"
        echo "$OPENFILE is already open"
        exit 1
    fi

    mkdir "./.ziprepo"

    unzip -q $FILE -d "./.ziprepo"
    test $? -eq 0 && echo `readlink -f "$FILE"` > .zipgitopened && echo "Opened $FILE at " `pwd`/.ziprepo 
    
    OPENFILE=`cat .zipgitopened 2>/dev/null`

    if test -z "$OPENFILE"; then
        (rm -rf "./.ziprepo" && echo "Failed to extract $FILE")
    fi

elif test "$1" = "close"; then
    OPENFILE=`cat .zipgitopened 2>/dev/null`

    if test -z $OPENFILE; then
        echo "No zip repository opened"
        exit
    fi
    
    OPENFILE=`readlink -f "$OPENFILE"`

    cd .ziprepo
    rm $OPENFILE
    zip -q -r "$OPENFILE" .
    cd ..

    rm -rf .ziprepo
    rm -f .zipgitopened

    echo "Closed $OPENFILE"


else
    usage
fi
