#!/bin/bash

#Phonebook emulation

ARG1=$1 #Cmd line argument 1

case $ARG1 in
    "-a")
    echo "Insert name, surname, city, tel number"
    read name sur city tel
    #'>>' to append
    echo "$name $sur $city $tel" >> katalogos
    ;;

    "-l")
    #"grep -ve '^$'" ignores empty lines
    grep -ve '^$' katalogos | cat -n
    ;;

    "-s")
    ARG2=$2 #Cmd line argument 2
    #Checking if arg2 exists
    if [[ "${ARG2}" != "" ]]; then
    #sorting by the number contained in ARG2
    sort -k${ARG2} katalogos
    else echo "Invalid argument: Check telcat.sh -h" #error/help message
    fi
    ;;

    "-c")
    ARG2=$2
    #checking if arg2 exists
    if [[ "${ARG2}" != "" ]]; then
    #printing only the lines containing the keyword in arg2
    grep ${ARG2} katalogos
    else echo "Invalid argument: Check telcat.sh -h"
    fi
    ;;

    "-d")
    ARG2=$2
    ARG3=$3 #Cmd line argument 3
    #Checking if the arguments exists
    if [[ "${ARG2}" != "" && "${ARG3}" != "" ]]; then
        if  [[ "$ARG3" == "-r" ]]; then
            #if -r, removing the line that contains the keyword
            sed -i "/$ARG2/d" katalogos
        elif [[ "$ARG3" == "-b" ]]; then
            #else if -b, replacing the line with an empty one
            sed -i "/$ARG2/c\\\\" katalogos
        else
            #else error message
            echo "Missing/Wrong argument: Check telcat.sh -h"
        fi
    else echo "Invalid argument: Check telcat.sh -h"
    fi
    ;;

    *)
    #Is printed if user inputs wrong arguments
    echo "Usage: telcat.sh [-a] [-l] [-s <col_num>] [-c <keywrd>] [-d <keywrd> (-b||-r)]"
    echo "-a: Add entry"
    echo "-l: List enumerated records"
    echo "-s <col_num>: Sort by column number"
    echo "-c <keywrd>: List only matching records"
    echo "-d <keywrd> (-b||-r): Delete matching record. -b: replace with empty record, -r: none"
    ;;
esac