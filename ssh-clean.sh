#!/bin/bash

IFS='@' read -r user host <<< $1
OUTPUT=$(ssh $1 true 2>&1)

if echo "$OUTPUT" | grep -q 'WARNING'; 
then
	for line in $(ssh-keygen -F $host | awk '/^# Host/ { print $NF }' | sort -rn); do
		sed -i "${line}d" ~/.ssh/known_hosts
	done
	ssh $1
else 
	ssh $1
fi
