#!/bin/bash

function usage {
echo "please supply a path to the vars file"
echo "like:"
echo "$0 ../vars/vars.yml"
}

#Check if there is any arguments in the cli
if [ $# -eq 0 ];then
  usage
  exit 1
fi

#Check if there is the first argument in the cli
if [ -z "$0" ];then
  usage
  exit 1
fi

#Check if there is to many arguements
if [ ! -z "$2" ];then
  usage
  exit 1
fi

#The actual variable file
MYVARSFILE=$1

#Check to see if it an actual file
if [ ! -f $MYVARSFILE ]; then
  usage
  exit 1
fi  

#The amount of students found in the vars file
HOWMANY=$(grep "number_of_students" ${MYVARSFILE} | cut -d \  -f2 | tr -d '\n')

#Get the Active Directory server first
echo "Ad server"
cat /tmp/ad_instances.out
echo #

#Iterate over the amount of students to build the list
for i in $(seq 1 $HOWMANY); do
    echo Cockpit instance for student$i
    sed "${i}q;d" /tmp/cockpit_instances.out
    echo RHEL host
    sed "${i}q;d" /tmp/rhelhost_instances.out
    echo Windows host
    sed "${i}q;d" /tmp/winhost_instances.out
    echo #
done