#!/bin/bash

echo Content-type: text/html
echo ""


if  ( ls -la /sys/block | grep usb | grep -qo sd. ) 
   then
	  USBev=$( ls -la /sys/block | grep usb | grep -o sd.| uniq | tail -9 )
         
	#List all the USBs and make the user to choose one of them
             
		i=1   
		for Upath in /dev/$USBev ; do
				dev=$( basename "$Upath" )
				p=$(fdisk -l /dev/$dev | grep -o '^/dev/sd[a-f][0-9]') 
				devices[$i]=${p}
				vendor=$( cat /sys/block/"$dev"/device/vendor)
				size=$( cat /sys/class/block/"$dev"/size )
				echo  "<a id='$p' class='usb_list' href='#'> $i Usb Name:$vendor  Device:$p  Size:$size </a>"
				i=$(( i+1 ))
				echo '<br>'
				done 
                        	export Upath="${devices[$usbNo]}"
else 
	echo " There is no USB device found "
fi
