#!/bin/bash
#Last edit on 07/07/2014 by Basmah Alnasser


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
		#size=$( cat /sys/class/block/"$dev"/size )
		size=$(blockdev --getsize64 /dev/$dev)
		echo  " $i. Usb: $vendor Device: $p Size: $size Bytes " 
		i=$(( i+1 ))
		done 
                        
		#chech for the input validation	 
	    	while  [[ ! "$usbNo"  =~ ^[0-9]+$ ]] ||  [[  "$usbNo"  -gt  ${#devices[@]}  ||  "$usbNo" -eq 0 ]]; do
		     read -p "Choose a USB device to write protect?   " usbNo
               	     Upath="${devices[$usbNo]}"
		done 
                     echo "The device selected is: $Upath "         
				
		#ask the use for confirmation 
		read -p "Continue to mount this $Upath USB as read-only (y/n)? " selection
		case "$selection" in

		#check if the usb already mountend or not
		y|Y ) mount | grep $Upath > /dev/null
			  if [ $? -eq 1 ]; then
		      	  #Chick if the folder exists 
			  [ ! -d /mnt$Upath ] && mkdir -p /mnt$Upath

		      	  #mount the usb as read-only
			  mount -o ro,loop $Upath /mnt$Upath
			  echo " The USB now is write protected"
			  sleep 3   
	                  else
				echo "The USB is already mounted, do you want to umount it? (y,n) "
				read ans 
			  if [ "$ans" == "y" ]; then
				umount /mnt$Upath
				rmdir /mnt$Upath
				echo "Done"
				sleep 3 
			
			  else
				exit
			  fi
			  fi
			  ;;
		n|N ) exit;;

		* ) echo "invalid";;
		esac
	
else 
	echo "There is no USB device found "
	sleep 1
fi

