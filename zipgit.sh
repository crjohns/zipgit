#!/bin/bash

function usage
{
    echo "Usage: $0 <command>"
    echo Commands:
    echo "open <zipfile>   - Open zip file as a remote"
    echo "close            - Close the opened zip file, and save data"
    echo "init <zipfile>   - Initialize a new bare repository"
   # echo "save             - Save the opened zip file without closing"
}

function save
{
    if test ! -e "$1"; then
        touch "$1"
        FILENAME=`readlink -f "$1"`
        rm -f "$1"
    else
        FILENAME="$1"
    fi

    cd .ziprepo
    rm -f "$FILENAME"
    zip -q -r "$FILENAME" .
    cd ..

    rm -rf .ziprepo
    rm -f .zipgitopened
}

if test "$1" = "init"; then
    FILE=$2
    if test -z "$FILE"; then
        usage
        exit
    fi

    mkdir .ziprepo
    cd .ziprepo
    git init --bare > /dev/null 2>/dev/null
    cd ..
    save "$FILE"

    echo "Initialized new git repository in ZIP file $FILE"

elif test "$1" = "open"; then
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

    save "$OPENFILE"
    
    echo "Closed $OPENFILE"


else
    usage
fi
