#!/bin/bash

echo Content-type: text/html
echo ""

param=($QUERY_STRING)

#check if the usb already mountend or not
mount | grep $param[0] > /dev/null
	if [ $? -eq 1 ]; then

	#mount the usb as read-only 
	[ ! -d /mnt/$param[0] ] && mkdir -p /mnt/$param[0]
	mount -o ro,loop $param[0] /mnt/$param[0]
	echo " done"				
				
	else
	echo "umount"
				
	

