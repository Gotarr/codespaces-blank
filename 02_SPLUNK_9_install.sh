#!/bin/bash


######################################
## STAND: 19/10/22
######################################


######################################################################################
###############################Globale Variablen #####################################
######################################################################################

Sources=/tmp/Sources

#splunk-Enterprise Version Beachten !

SplunkRPM="splunk-9.0.1-82c987350fde-linux-2.6-x86_64.rpm" 		
SplunkRunAs="splunk"


######################################################################################
##################################### Funktionen #####################################
######################################################################################


colormsg(){
	### Setting CLI Color to human readable ###
	if [ "$2" == 'green' ]; then
		echo -e "\e[4m\e[32m$1\e[36m\e[24m\n"
	else
		echo -e "\e[33m$1\e[36m"
	fi
	}

colormsg "### Check SPLUNK Install ###"

read -p "SPLUNK Install File @ /tmp/Sources ? --> Y / N <-- : " -n 1 -r
echo 
if [[ $REPLY =~ ^[Nn]$ ]]; then

	exit 1
	
else 
	
	colormsg "### Start SPLUNK Install ###"
	
fi

	
	
SetFirewallSettings(){
	
	### Setting firewall rules for communication ###
	
	colormsg "### Set Firewall settings ###"
	
	
	firewall-cmd --add-port="9997/tcp"
    firewall-cmd --add-port="9998/tcp" 
    firewall-cmd --add-port="9887/tcp" 
    firewall-cmd --add-port="8089/tcp" 
    firewall-cmd --add-port="9100/tcp" 
    firewall-cmd --add-port="8191/tcp"
    firewall-cmd --add-port="8443/tcp"
    firewall-cmd --add-port="8000/tcp"
	
	# Make the changes persistent
	
	firewall-cmd --runtime-to-permanent
	firewall-cmd --reload
	
	colormsg "### Setting firewall-settings done ###"
	sleep 3
	
}

RunPackageInstaller() {
	colormsg "### Run Splunk install ###"

	cd $Sources
	yum -y install $SplunkRPM
	sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
	colormsg "### Installation of Splunk-Packages Done ###"
	sleep 3
}

password(){

	colormsg '### Initial SPLUNK User ###'
	echo -n "Splunk initial Username:"
	echo
	read -s splunkusername
	echo

	colormsg '### Initial SPLUNK password ###'
	echo -n "Splunk initial password"
	echo
	read -s splunkpassword
	echo
}

StartSplunk(){
	colormsg "### Start Spunk for the first time###"

	## Start splunk ohne Fragen und Boot-start ##
	sudo -u $SplunkRunAs /opt/splunk/bin/splunk start --answer-yes --no-prompt --accept-license 
	sudo /opt/splunk/bin/splunk enable boot-start -user $SplunkRunAs

	## Add User NOT Secured!##
	touch /opt/splunk/etc/system/local/user-seed.conf
	echo [user_info] >> /opt/splunk/etc/system/local/user-seed.conf
	echo USERNAME = $splunkusername >> /opt/splunk/etc/system/local/user-seed.conf
	echo PASSWORD =  $splunkpassword >> /opt/splunk/etc/system/local/user-seed.conf

	chown -R /opt/splunk splunk:splunk

	colormsg "### Spunk restart ###"
	sudo -u $SplunkRunAs /opt/splunk/bin/splunk restart
	sleep 3
}

splunkalias() {
	
	colormsg "#### Set Splunk Alias ####"
	
	alias splunk='/opt/splunk/bin/splunk '
	echo alias splunk='/opt/splunk/bin/splunk ' >> /root/.bashrc

	alias splunk='/opt/splunk/bin/splunk '
	echo alias splunk='/opt/splunk/bin/splunk ' >> /home/splunk/.bashrc


}


#### Script Startpunkte ####

SetFirewallSettings
RunPackageInstaller
password
StartSplunk
splunkalias


###Andre Splunk Befehle
###/opt/splunk/bin/splunk status
###/opt/splunk/bin/splunk restart
###/opt/splunk/bin/splunk stop

