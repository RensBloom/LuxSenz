#!/bin/bash
rm res
while true; do
	#cat res | tail -n 60
	dmesg
	dmesg -c >> res
#	sleep 1
#	echo " "
done
