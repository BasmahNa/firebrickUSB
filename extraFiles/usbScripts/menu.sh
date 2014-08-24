#!/bin/bash
# USB Capturing Main menu
 
Opt=""

while [ "$Opt" != "q" ]; do
clear
echo  "=============================================================== "
echo  "=                                                             = "
echo  "=          Welocome to the FIREBrick USB Main Menu            = "
echo  "=                                                             = "
echo  "=============================================================== "
echo  "1.USB Capture" 
echo  "2.USB write Blocker"
echo  "3.Export USB drive"
echo  "q.Exit"
echo  "p.Poweroff"
 
echo  " "

read -p "Select an option  " Opt

case "$Opt" in
	1) bash usbCapture.sh
	        ;;
	2) bash usbBlocker.sh 
		;;
	3) bash usbExport.sh
		;;
	q) exit
		;;
	p) poweroff
		;;
	*) ;; 
esac
echo  " "
done

	



