#!/bin/bash

######################################
## STAND: 19/10/22
## HF Schubert
######################################

colormsg(){
	### Setting CLI Color to human readable ###
	if [ "$2" == 'green' ]; then
		echo -e "\e[4m\e[32m$1\e[36m\e[24m\n"
	else
		echo -e "\e[33m$1\e[36m"
	fi
}


### Install Ordner für Splunk Enterprise zum Mounten
mkdir -p /opt/splunk

colormsg "##### Splunk 2. HDD für IDX #####"


neuePartition(){

	colormsg "Erstelle Neue Partition"

	fdisk /dev/sdb <<EEOF
	d
	n
	p
	1


	t
	83
	w
	EEOF

	colormsg "Weiter mit formatieren"
	formatieren
}

formatieren(){

	mkfs.ext4 /dev/sdb1

	echo "weiter mit Mounting /opt/splunk"
	mountingOpt

}

mountingOpt(){

	mount /dev/sdb1 /opt/splunk
	echo /dev/sdb1 /opt/splunk ext4 defaults 0 0 >> /etc/fstab

	colormsg "Fertig :)"
	exit

}

server(){
	echo
	echo
	read -p "ist das ein Splunk Index Server?" -n 1 -r
	echo
	echo 

	if [[ $REPLY =~ ^[Yy]$ ]]; then

	colormsg "Neue Partition"		
	neuePartition
			
	else 
			
	exit
			
	fi
			
			
	sleep 2
}


######################################################################################
##################################### Funktionen #####################################
######################################################################################

server


