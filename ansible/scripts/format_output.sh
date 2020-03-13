#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR 


HOWMANY=$(grep "number_of_students" ../vars/vars.yml | cut -d \  -f2 | tr -d '\n')

echo "Ad server"
cat /tmp/ad_instances.out
echo #

for i in $(seq 1 $HOWMANY); do
    echo Cockpit instance for student$i
    sed "${i}q;d" /tmp/cockpit_instances.out
    echo RHEL host
    sed "${i}q;d" /tmp/rhelhost_instances.out
    echo Windows host
    sed "${i}q;d" /tmp/winhost_instances.out
    echo
done