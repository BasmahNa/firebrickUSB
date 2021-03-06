#!/bin/bash

echo Content-type: text/html
echo ""

if  ( ls -la /sys/block | grep usb | grep -qo sd. ) 
then
USBev=$( ls -la /sys/block | grep usb | grep -o sd.| uniq | tail -9 )
         
		#List all the USBs 
		i=1   
		for Upath in /dev/$USBev ; do
    			dev=$( basename "$Upath" )
    			devices[$i]=${dev}
    			vendor=$( cat /sys/block/"$dev"/device/vendor)
    			#size=$( cat /sys/class/block/"$dev"/size)
			size=$(blockdev --getsize64 /dev/$dev)
			echo  "$i. Usb:$vendor  Device:$dev  Size:$size Bytes " 
    			i=$(( i+1 ))
		done

		#chech for the input validation	 
		while [[ ! "$usbNo" =~ ^[0-9]+$ ]] || [[ "$usbNo" -gt ${#devices[@]} || "$usbNo" -eq 0 ]] ; 
		do
        	       read -p "Choose a USB device ?   " usbNo
        	       Upath="${devices[$usbNo]}"
		done

                
	 	#clear the RAM to start fresh imaging
		sync && echo 3 > /proc/sys/vm/drop_caches
				 
		#ask the use for confirmation
		echo "Are you sure you want to image this USB $Upath device, (y,n) ? "
		read selection
		case "$selection" in

		y|Y )   echo "Enter Incident's Name"
       	        	read InciName
   	        	if [[ "$InciName" != "" ]] ; then
			
       	        	while [ -d /firestor/"$InciName" ] ; do 
	        	read  -p "The incident name ($InciName) is already exists, please enter another name " InciName
       	        	done
       	        	
       	        	[ ! -d /firestor/"$InciName" ] && mkdir -p /firestor/"$InciName"
			           	
       	        	# Image the USB divce using dcfldd       
       	        	dcfldd if=/dev/$Upath of=/firestor/"$InciName"/"$InciName".dd  hash=md5,sha1 conv=noerror,sync hashlog=/firestor/"$InciName"/imageHash_"$InciName".txt

       	        	
       			# verifying the image
       			echo "Calculating hash values. Please wait"
      			hashUSB=$(md5sum /dev/"$Upath")
       			hashImage=$(md5sum /firestor/"$InciName"/"$InciName".dd )
  
       			echo $hashUSB
       			echo $hashImage
   			 	
       			if (cmp /dev/$Upath /firestor/"$InciName"/"$InciName".dd) >/dev/null ; then
 
	  			echo ""
          			echo " == Matching hashes == "
	  			echo ""
				
       			else
	  			echo ""
 	  			echo  " == Missmatch hashes. Discarding the Image == "
	  			echo ""
				#remove the directory
	  			rm -rf /firestor/"$InciName"
				
       			fi
	     
       			else
          			echo " Invalide Name "
       			fi 
			;;

		n|N ) exit 
			;;

		* ) echo "invalid"
			;;
		esac

	 	
     
		
else 
    echo "There is no USB device found "
    
fi

