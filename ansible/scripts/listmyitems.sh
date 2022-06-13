#!/bin/bash

data=$(aws ec2 describe-instances \
    --filters Name=tag-key,Values=Name \
    --query 'Reservations[*].Instances[*].{PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output text)

COUNT=1
DELTAGARE=$(echo "${data}" | grep cockpit | wc -l )
let DELTAGARE=DELTAGARE+1

echo
while true ;do
    echo Student$COUNT
    echo "${data}" | grep cockpit | sed -n "${COUNT}"p
    echo "${data}" | grep rhel | sed -n "${COUNT}"p
    echo "${data}" | grep winguest | sed -n "${COUNT}"p
    echo
    let COUNT=COUNT+1
    if [ $COUNT = $DELTAGARE ];then
		exit 1
	fi
done

