#!/bin/bash

ARG1=$1 #username
ARG2=$2 #src file or src dir
ARG3=$3 #copy dest
ARG4=$4 #time

source ./bck.sh ${ARG1} ${ARG2} ${ARG3} | at ${ARG4}