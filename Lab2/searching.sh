#!/bin/bash

#Listing info about files in a specific directory

INT1=$1 #Cmd line argument 1
INT2=$2 #Cmd line argument 2

#counters
INTA=0
INTB=0
INTC=0
INTD=0
INTE=0

for((;;))
do
    echo "Insert directory name"
    read catName
    echo -e "\n"

    echo -ne "1) Files with permissions: "
    #We execute the cmd once and pipeline it to wc -l in order to print the number of the files that are about to be printed.
    find $catName -type f -perm /${INT1} | wc -l
    #We execute and pipeline it to wc -l again but now we add the number of the files to the counter.
    INTA=$((${INTA}+"$(find $catName -type f -perm /${INT1} | wc -l)"))
    #We execute the cmd again without any pipelines in order to print the requested files.
    find $catName -type f -perm /${INT1}
    
    #Likewise:
    echo -ne "\n2) Files last modified: "
    find $catName -type f -ctime -${INT2} | wc -l
    INTB=$((${INTB}+"$(find $catName -type f -ctime -${INT2} | wc -l)"))
    find $catName -type f -ctime -${INT2}

    echo -ne "\n3) Directories last accessed: "
    find $catName -type d -atime -${INT2} | wc -l
    INTC=$((${INTC}+"$(find $catName -type d -atime -${INT2} | wc -l)"))
    find $catName -type d -atime -${INT2}

    echo -ne "\n4) Files w/ read perm by all: "
    ls -l $catName | grep -e '-r..r..r..' | wc -l
    INTD=$((${INTD}+"$(ls -l $catName | grep -e '-r..r..r..' | wc -l)"))
    ls -l $catName | grep -e '-r..r..r..'

    echo -ne "\n5) Directories that can be modified by others: "
    ls -l $catName | grep -e 'd......rw.' | wc -l
    INTE=$((${INTE}+"$(ls -l $catName | grep -e 'd......rw.' | wc -l)"))
    ls -l $catName | grep -e 'd......rw.' 
    
    echo "Repeat? Y/N"
    read flag
    if [[ "$flag" == "N" || "$flag" == "n" ]]; then
        echo -n "1. Total files found= "
        echo "${INTA}"
        echo -n "2. Total files found= "
        echo "${INTB}"
        echo -n "3. Total directories found= "
        echo "${INTC}"
        echo -n "4. Total files found= "
        echo "${INTD}"
        echo -n "5. Total directories found= "
        echo "${INTE}"
        break
    fi
done