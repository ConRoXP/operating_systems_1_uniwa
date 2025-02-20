#!/bin/bash

#Fetching and listing locked files along with detailed info.

#Internal Field Separator / Delimiter
#to separate the contents of '/proc/locks' line by line
IFS=$'\n'
#'lockcmd' is an array that in every slot
#contains one line (1 lock)
lockcmd=($(cat /proc/locks))

#Each line (lock)...
for i in "${lockcmd[@]}"
do
    #is further separated by the ' ' character
    IFS=' '
    read -a locks <<< $i

    #Check if process exists
    if [ ! -d /proc/${locks[4]} ]; then
        echo "Process not found"
        echo "Process not found" >> locks.log
        continue
    fi

    IFS=$'\n'
    #The following command displays detailed information
    #about the file descriptors used by the process.
    #At the end is the path of the locked file.
    fileDesc=($(sudo ls -l /proc/${locks[4]}/fd))

    flag=0

    #For each file descriptor (slot 0 of the array contains "total 0" and is ignored)...
    for j in "${fileDesc[@]:1}"
    do
        #further separation on each ' ' character
        #in order to isolate the locked file's path.
        IFS=' '
        fileInfo=(${j})
        IFS=$'\t'
        #Getting the inode of each file descriptor
        inodeCheck=($(sudo cat /proc/${locks[4]}/fdinfo/${fileInfo[8]} | grep "ino"))
        #Getting the locked file's inode
        targetInode=$(echo "${locks[5]}" | cut -d: -f3)
        #If the 2 inodes are the same, we print the following entry in the log file:
        #[lock numbering] [lock type] [pid] [command] [process name] [user id] [locked file's path]
        if [[ ${inodeCheck[1]} == ${targetInode} ]]; then
            #The printf cmd displays a warning in the console - it can be ignored as it does not get written to the file.
            printf "%s %s %s %s %s %s %s\n" "${locks[0]}" "${locks[3]}" "${locks[4]}" "$(cat /proc/${locks[4]}/cmdline)" "$(cat /proc/${locks[4]}/comm)" "$(cat /proc/${locks[4]}/loginuid)" "${fileInfo[10]}"
            printf "%s %s %s %s %s %s %s\n" "${locks[0]}" "${locks[3]}" "${locks[4]}" "$(cat /proc/${locks[4]}/cmdline)" "$(cat /proc/${locks[4]}/comm)" "$(cat /proc/${locks[4]}/loginuid)" "${fileInfo[10]}" >> locks.log
            
            flag=1
        fi
    done
    #Checking if the file corresponding to the inode exists
    if [ ${flag} == 0 ]; then
        echo "No file matching inode found" 
        echo "No file matching inode found" >> locks.log
    fi
done