#!/bin/bash


######################################
## STAND: 19/10/22
## HF Schubert
######################################


######################################################################################
###############################Globale Variablen #####################################
######################################################################################

syno=9.99.64.7

######################################################################################
##################################### Deployment #####################################
######################################################################################


deployment(){

    colormsg "### Start SPLUNK Deployment Server Install ###"
    #### Variablen ####
	mkdir -p /mnt/tmp/
    mount -t nfs $syno:/volume1/Software /mnt/tmp/


	sources[0]=Splunk_9_Deployment_Server_GMN02.tar
	#sources[1]=
	

    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root
    xfs_growfs /dev/mapper/sysvg-lv_root

	download(){

	for i in "${sources[@]}"
		do
		result=""
		result=$(find /mnt/tmp -name $i)
		if  [ "$result" == "" ];
		then
		echo $i nicht vorhanden.
		else	
		echo Kopiere $i
		find /mnt/tmp/ -name $i | xargs --no-run-if-empty cp --target-directory /root
	fi
	done

	}

    password(){

		colormsg '### SPLUNK User ###'
		echo -n "Splunk username : "
		echo
		read -s splunkusername
		echo

		colormsg '### SPLUNK user password ###'
		echo -n "Splunk user password : "
		echo
		read -s splunkpassword
		echo

    	colormsg '### SPLUNK Cluster secret ###'
		echo -n "Splunk Cluster secret : "
		echo
		read -s clusertsecret
		echo

    	colormsg '### SPLUNK Cluster Name ###'
		echo -n "Splunk Cluster name : "
		echo
		read -s clusertname
		echo
	}

	License(){
		colormsg '### Copy Licence for SPLUNK ###'

		mkdir -p /opt/splunk/etc/licenses/enterprise

		cp -r /License/*.License /opt/splunk/etc/licenses/enterprise

		mv /opt/splunk/etc/licenses/enterprise/*.License /opt/splunk/etc/licenses/enterprise/SPLUNK_vCPU.License.lic

		chown -R splunk:splunk /opt/splunk

		/opt/splunk/bin/splunk restart

	}

    clusterconfig(){
    
    	colormsg '### Enable Cluster ###'

    	/opt/splunk/bin/splunk edit cluster-config -mode manager -replication_factor 3 -search_factor 3 -secret $clusertsecret -cluster_label $clusterlabel

		/opt/splunk/bin/splunk restart

    }


    #### Script Startpunkte ####
    download
	password
	
}


######################################################################################
##################################### Searchhead #####################################
######################################################################################

searchhead(){

    colormsg "### Start SPLUNK Deployment Server Install ###"
    #### Variablen ####
    mount -t nfs $syno:/volume1/Software /mnt/tmp/


	sources[0]=Splunk_9_Searchhead_Config_GMN02.tar
	sources[1]=Splunk_9_Searchhead_Addons_GMN02.tar
	

    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root
    xfs_growfs /dev/mapper/sysvg-lv_root


	download(){

	for i in "${sources[@]}"
		do
		result=""
		result=$(find /mnt/tmp -name $i)
		if  [ "$result" == "" ];
		then
		echo $i nicht vorhanden.
		else	
		echo Kopiere $i
		find /mnt/tmp/ -name $i | xargs --no-run-if-empty cp --target-directory ../Sources
	fi
	done

	}

    password(){

		colormsg '### SPLUNK User ###'
		echo -n "Splunk username : "
		echo
		read -s splunkusername
		echo

		colormsg '### SPLUNK user password ###'
		echo -n "Splunk user password : "
		echo
		read -s splunkpassword
		echo

    	colormsg '### SPLUNK Cluster secret ###'
		echo -n "Splunk Cluster secret : "
		echo
		read -s clusertsecret
		echo

    	colormsg '### SPLUNK Cluster Name ###'
		echo -n "Splunk Cluster name : "
		echo
		read -s clusertname
		echo
	}

    clusterconfig(){
    
    	colormsg '### Set License Server ###'
    
   		colormsg '### Deployment Server IP ###'
		echo -n "Deployment Server IP : "
		echo
		read -s deployip
		echo
    
    	/opt/splunk/bin/splunk edit licenser-localslave -master_uri https://$deployip:8089 -auth $splunkusername:$splunkpassword

		/opt/splunk/bin/splunk edit cluster-config -mode searchhead -manager_uri https://$deployip:8089 -secret $clusertsecret

		/opt/splunk/bin/splunk restart

    }

    #### Script Startpunkte ####
    download
	password
    clusterconfig
}


######################################################################################
##################################### Indexer ########################################
######################################################################################

indexer(){

    colormsg "### Start SPLUNK Deployment Server Install ###"
    #### Variablen ####
    
    password(){

	colormsg '### SPLUNK User ###'
	echo -n "Splunk username : "
	echo
	read -s splunkusername
	echo

	colormsg '### SPLUNK user password ###'
	echo -n "Splunk user password : "
	echo
	read -s splunkpassword
	echo

    colormsg '### SPLUNK Cluster secret ###'
	echo -n "Splunk Cluster secret : "
	echo
	read -s clusertsecret
	echo

    colormsg '### SPLUNK Cluster Name ###'
	echo -n "Splunk Cluster name : "
	echo
	read -s clusertname
	echo
	}

    clusterconfig(){
    
    	colormsg '### Set License Server ###'
    
    	colormsg '### Deployment Server IP ###'
		echo -n "Deployment Server IP"
		read -s deployip
		echo
    
    	/opt/splunk/bin/splunk edit licenser-localslave -master_uri https://$deployip:8089 -auth $splunkusername:$splunkpassword

		/opt/splunk/bin/splunk edit cluster-config -mode peer -manager_uri https://$deployip:8089 -secret $clusertsecret -replication_port 9887 -cluster_label $clusertname

		opt/splunk/bin/splunk restart

    }
    #### Script Startpunkte ####
    password
    clusterconfig

}

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

colormsg "############################"
colormsg "############################"
colormsg "### SPLUNK Configuration ###"
colormsg "############################"
colormsg "############################"
sleep 2
colormsg "### Install Deployment FIRST ! ###"
colormsg "### Install Deployment FIRST ! ###"
colormsg "### Install Deployment FIRST ! ###"
sleep 3

start(){

read -p "##### Welche SPLUNK Rolle soll installiert werden?? Exit --> N // Deployment --> D // Searchhead --> S // Indexer --> I  ##### :" -n 1 -r
echo 
if [[ $REPLY =~ ^[Nn]$ ]]; then

    colormsg "### Exit Config ###"
	exit 1
	
elif [[ $REPLY =~ ^[Dd]$ ]]; then
	
	read -p "### Start SPLUNK Deployment Server Install ? --> Y / N <-- ### :" -n 1 -r
    echo 
    if [[ $REPLY =~ ^[Nn]$ ]]; then

    colormsg "### Exit Config ###"
	exit 1

    else
        deployment
    fi

elif [[ $REPLY =~ ^[Ss]$ ]]; then
	
	read -p "### Ist ein Searchhead Server installiert ? ? ? --> Y / N <-- ### :" -n 1 -r
    echo 
    if [[ $REPLY =~ ^[Nn]$ ]]; then

    colormsg "### Exit Config ###"
	exit 1

    else
        searchhead
    fi

elif [[ $REPLY =~ ^[Ii]$ ]]; then
	
	read -p "### Ist ein Indexer Server installiert ? ? ? --> Y / N <-- ### :" -n 1 -r
    echo 
    if [[ $REPLY =~ ^[Nn]$ ]]; then

    colormsg "### Exit Config ###"
	exit 1

    else
        indexer
    fi

fi
}

start
