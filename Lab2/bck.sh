#!/bin/bash

#Backup a user's files to an archive in a different dir.

ARG1=$1 #username
ARG2=$2 #source file or src dir
ARG3=$3 #copy destination

#Argument valididty check
if [[ ${ARG1} == "" || ${ARG2} == "" || ${ARG3} == "" ]]; then
    echo "Incorrect argument(s)"
    exit 1
fi

#User valididty check
VAR="$(who | grep ${ARG1})"
if [[ ${VAR} == "" ]]; then
    echo "User doesn't exist"
    exit 1
fi

#Source path validity check
test2="$(test -d ${ARG2})"
#'$?'<- exit code of the latest cmd that ran
if [[ $? == 1 ]]; then
    test2="$(test -e ${ARG2})"
    if [[ $? == 1 ]]; then
        echo "Invalid Source Path"
        exit 1
    fi
fi

#Destination path validity check
#if file is not a dir or doesn't exist, the following cmd returns 1
test3="$(test -d ${ARG3})"
#differentiating between the file not existing or not being a directory:
if [[ $? == 1 ]]; then
    test3="$(test -e ${ARG3})"
    if [[ $? == 1 ]]; then
        echo "Invalid Destination Path"
        exit 1
    fi
fi

test3="$(test -d ${ARG3})"
if [[ $? == 0 ]]; then
    #If dest is a dir -> Create archive in dir
    tar -cf ${ARG3}/${ARG2}.tar ${ARG2}
else
    #If dest is a file -> Append to file
    tar -rf ${ARG3} ${ARG2}
fi