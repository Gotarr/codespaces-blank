#!/bin/bash


######################################
## ALL in ONE
## STAND: 18/10/22
######################################

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
echo
sleep 1
colormsg "### Install Deployment FIRST ! ###"
colormsg "### Install Deployment FIRST ! ###"
colormsg "### Install Deployment FIRST ! ###"
echo
sleep 1

######################################################################################
############################### Globale Variablen ####################################
######################################################################################

commonname=$(hostname -f)
serverip=$(hostname -i)
shortname=$(hostname)

download=/tmp/Sources
mountpoint=/mnt/tmp

##### splunk-Enterprise Version Beachten !

##### Install Sources
sources[0]=20220901_vCPU_Splunk.License
sources[1]=splunk-9.0.1-82c987350fde-linux-2.6-x86_64.rpm

##### Deployment Sources
deploysource[0]=cisco-networks-add-on-for-splunk-enterprise_272.tgz
deploysource[1]=cisco-networks-app-for-splunk-enterprise_274.tgz
deploysource[2]=splunk-add-on-for-microsoft-windows_850.tgz
deploysource[3]=splunk-add-on-for-unix-and-linux_870.tgz
deploysource[4]=it-essentials-work_4131.spl
deploysource[5]=splunk-add-on-for-vmware-esxi-logs_421.tgz
deploysource[6]=splunk-add-on-for-vmware-vcenter-logs_421.tar
deploysource[7]=ta-pfsense_251.tgz
deploysource[8]=trend-micro-tippingpoint-app-for-splunk_212.tgz
deploysource[9]=technology-add-on-for-netflow_451.tgz

deployconfig[0]=Deployment_GMN02_system_local.tar
deployconfig[1]=Deployment_GMN02_master_apps.tar
deployconfig[2]=Deployment_GMN02_deploy_apps.tar

##### Searchhead Sources
seasource[1]=cisco-networks-add-on-for-splunk-enterprise_272.tgz
seasource[2]=cisco-networks-app-for-splunk-enterprise_274.tgz
seasource[3]=force-directed-app-for-splunk_310.tgz
seasource[4]=infosec-app-for-splunk_170.tgz
seasource[5]=it-essentials-work_4131.spl
seasource[6]=punchcard-custom-visualization_150.tgz
seasource[7]=splunk-add-on-for-microsoft-windows_850.tgz
seasource[8]=splunk-add-on-for-symantec-endpoint-protection_340.tgz
seasource[9]=splunk-add-on-for-unix-and-linux_870.tgz
seasource[10]=splunk-add-on-for-vmware-esxi-logs_421.tgz
seasource[11]=splunk-add-on-for-vmware-extractions_403.tgz
seasource[12]=splunk-add-on-for-vmware-metrics_423.tgz
seasource[13]=splunk-add-on-for-vmware-vcenter-logs_421.tar
seasource[14]=splunk-app-for-content-packs_170.spl
seasource[15]=splunk-app-for-lookup-file-editing_360.tgz
seasource[16]=splunk-common-information-model-cim_502.tgz
seasource[17]=splunk-sankey-diagram-custom-visualization_160.tgz
seasource[18]=splunk-security-essentials_360.tgz
seasource[19]=splunk-timeline-custom-visualization_161.tgz
seasource[20]=ta-pfsense_251.tgz
seasource[21]=flow-map-viz_1414.tgz
seasource[22]=splunk-common-information-model-cim_501.tgz
seasource[23]=status-indicator-custom-visualization_150.tgz
seasource[24]=trend-micro-tippingpoint-app-for-splunk_212.tgz
seasource[25]=netflow-and-snmp-analytics-for-splunk_451.tgz
seasource[26]=technology-add-on-for-netflow_451.tgz

seaconfig[0]=SEA_GMN02_system_local.tar
seaconfig[1]=GMN02_Dashboards.tar

##### Syslog Sources
syslogsource[0]=splunk-db-connect_3100.tar
syslogsource[1]=jtds-1.3.1.jar
syslogsource[2]=mssql-jdbc-11.2.0.jre11.jar


##### verify Version
SplunkRPM="splunk-9.0.1-82c987350fde-linux-2.6-x86_64.rpm" 		
SplunkRunAs="splunk"


######################################################################################
############################### Spezifische Variablen ################################
######################################################################################

GMNSRA01(){
    colormsg "### GMN01 Noch nicht Konfiguriert ###"
    exit


    #syno=9.99.64.7

    organizationalunit=GMN01


    PS3="Was soll gemacht werden? : "
    select auswahl in TestSyno BuildPackage BuildWebCert Back End
    do
        case "$auswahl" in
            End)    echo "End"; exit ;;
            Back)   echo "Back"; start ;;
            "")     echo "Ungültige Auswahl"; start ;;
            *)      echo "Sie haben $auswahl gewählt" &&\
                    echo
                    $auswahl
                    echo
                    ;;
        esac
    done
}

GMNSRA02(){

    syno=9.99.64.7

    organizationalunit=GMN02

    PS3="Was soll gemacht werden? : "
    select auswahl in TestSyno BuildPackage BuildWebCert Back End
    do
        case "$auswahl" in
            End)    echo "End"; exit ;;
            Back)   echo "Back"; start ;;
            "")     echo "Ungültige Auswahl"; start ;;
            *)      echo "Sie haben $auswahl gewählt" &&\
                    echo
                    $auswahl
                    echo
                    ;;
        esac
    done
}

GMNSRA03(){
    colormsg "### GMN03 Noch nicht Konfiguriert ###"
    exit

    #syno=9.99.64.7

    organizationalunit=GMN03


    PS3="Was soll gemacht werden? : "
    select auswahl in TestSyno BuildPackage BuildWebCert Back End
    do
        case "$auswahl" in
            End)    echo "End"; exit ;;
            Back)   echo "Back"; start ;;
            "")     echo "Ungültige Auswahl"; start ;;
            *)      echo "Sie haben $auswahl gewählt" &&\
                    echo
                    $auswahl
                    echo
                    ;;
        esac
    done
}

TMN01(){
    colormsg "### TMN Noch nicht Konfiguriert ###"
    exit

    
    #syno=9.99.64.7

    organizationalunit=TMN


    PS3="Was soll gemacht werden? : "
    select auswahl in TestSyno BuildPackage BuildWebCert Back End
    do
        case "$auswahl" in
            End)    echo "End"; exit ;;
            Back)   echo "Back"; start ;;
            "")     echo "Ungültige Auswahl"; start ;;
            *)      echo "Sie haben $auswahl gewählt" &&\
                    echo
                    $auswahl
                    echo
                    ;;
        esac
    done
}

######################################################################################
##################################### Test Syno ######################################
######################################################################################
BETATestSyno(){
    colormsg "### Test Syno Connection ###"
    ping -c 3 $syno
    echo

    colormsg "### Test SMB Service ###"
    smbclient -L $syno -N
    echo

    colormsg "### Test NFS Service ###"
    showmount -e $syno
    echo
}



TestSyno(){

    colormsg "### Test Syno Connection ###"

    ping -c 3 $syno
    echo
    start

}

######################################################################################
##################################### Splunk Web Cert ################################
######################################################################################
BETABuildWebCert(){
    password(){
        colormsg '### Passwordabfrage für Zertifikat ###'
        echo -n "Password for Cert: "
        read -s password
        echo
    }

    certreq(){
        colormsg '### Zertifikatrequest erstellen ###'
        sleep 3
        
        colormsg '### Generating key request for SplunkServer ###'
        openssl genrsa -des3 -passout pass:$password -out /tmp/SPLUNK.key 2048 -noout
        if [[ $? -ne 0 ]]; then
            echo "Failed to generate key request"
            exit 1
        fi

        openssl rsa -in /tmp/SPLUNK.key -passin pass:$password -out /tmp/SPLUNK.key
        if [[ $? -ne 0 ]]; then
            echo "Failed to remove passphrase from the key"
            exit 1
        fi

        colormsg '### Creating CSR ###'
        openssl req -new -key /tmp/SPLUNK.key -out /tmp/Splunk.csr -subj "/C=DE/OU=$organizationalunit/CN=$commonname"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create certificate signing request"
            exit 1
        fi

        echo '-----Below is your CSR-----'
        cat /tmp/Splunk.csr || echo "Failed to display CSR"
        sleep 2
    }

    format(){
        read -p ".cer saved at /root/ ? " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            openssl x509 -in /root/$commonname.cer -inform DER -out /root/$commonname.cer
            if [[ $? -ne 0 ]]; then
                echo "Failed to convert certificate from DER to PEM format"
                exit 1
            fi
            ls -l /root | grep .cer
        else 
            format
        fi
        sleep 2
    }

    CopyCert(){
        colormsg '## Copy Web-Certs Configuration ##'
        if [ -f '/opt/splunk/etc/system/local/web.conf' ] ; then
            colormsg 'web.conf already exists!'
        else 
            colormsg '# Make Web.conf #'
            touch /opt/splunk/etc/system/local/web.conf
            
            echo [settings] > /opt/splunk/etc/system/local/web.conf
            echo enableSplunkWebSSL = true >> /opt/splunk/etc/system/local/web.conf
            echo httpport = 8443 >> /opt/splunk/etc/system/local/web.conf
            echo privKeyPath = /opt/splunk/etc/auth/mycert/SPLUNK.key >> /opt/splunk/etc/system/local/web.conf
            echo serverCert = /opt/splunk/etc/auth/mycert/$commonname.cer >> /opt/splunk/etc/system/local/web.conf
        fi
        
        if
    }
}

BuildWebCert(){


    password(){
        colormsg '### Passwordabfrage für Zertifikat ###'
        echo
        echo -n "Password for Cert : "
        echo
        read -s password
        echo

    }

    certreq(){
        ### Zertifikatrequest erstellen ###
        
        colormsg '### Zertifikatrequest erstellen ###'
        sleep 3
        
        colormsg '### Generating key request for SplunkServer ###'
        openssl genrsa -des3 -passout pass:$password -out /tmp/SPLUNK.key 2048 -noout


        ### Remove passphrase from the key. Comment the line out to keep the passphrase ###
        openssl rsa -in /tmp/SPLUNK.key -passin pass:$password -out /tmp/SPLUNK.key
        
        
        ### Create the request ###
        colormsg '### Creating CSR ###'

        openssl req -new -key /tmp/SPLUNK.key -out /tmp/Splunk.csr \
        -subj '/C=DE/OU='$organizationalunit'/CN='$commonname''

        echo
        echo '---------------------------'
        echo '-----Below is your CSR-----'
        echo '---------------------------'
        echo
        cat /tmp/Splunk.csr

        sleep 2
            
        echo
        echo	
        echo '------------------------------------------'
        echo '----- Submit Certificate Request ---------'
        echo '----- Add Additional Attributes: ---------'
        echo '----- san:ipaddress='$serverip'&dns='$commonname'&dns='$shortname' -----'
        echo '----- Choose Template : Computer Certificate ---------'
        echo '----- Download it ------------------------'
        echo '----- rename it to -----------------------'
        echo '----- '$commonname.cer' -----'
        echo '----- save '$commonname.cer' at /root/ -----'
        echo '------------------------------------------'
        echo
        echo

        sleep 5
        
    }

    format(){
        echo
        echo
        read -p ".cer saved at /root/ ? " -n 1 -r
        echo
        echo 

        if [[ $REPLY =~ ^[Yy]$ ]]; then
        
            openssl x509 -in /root/$commonname.cer -inform DER -out /root/$commonname.cer
            
            echo
            ls -l /root | grep .cer
        
        else 
        
        format
        
        fi
        
        
        sleep 2
    }


    CopyCert(){
        colormsg '## Copy Web-Certs Configuration ##'
        if [ -f '/opt/splunk/etc/system/local/web.conf' ] ; then
            colormsg 'web.conf already exist!'
        else 
            colormsg '# Make Web.conf #'
            touch /opt/splunk/etc/system/local/web.conf
            
            echo [settings] > /opt/splunk/etc/system/local/web.conf
            echo enableSplunkWebSSL = true >> /opt/splunk/etc/system/local/web.conf
            echo httpport = 8443 >> /opt/splunk/etc/system/local/web.conf
            echo privKeyPath = /opt/splunk/etc/auth/mycert/SPLUNK.key >> /opt/splunk/etc/system/local/web.conf
            echo serverCert = /opt/splunk/etc/auth/mycert/$commonname.cer >> /opt/splunk/etc/system/local/web.conf
        fi
        
        # Check Certs
        if [ -f 'opt/splunk/etc/auth/mycert/SPLUNK.pem' ] ; then
            colormsg 'Certs already exist!'
        else 
            colormsg '# Copy Certs #'
            mkdir -pv /opt/splunk/etc/auth/mycert/
            cp /tmp/*.key /opt/splunk/etc/auth/mycert/
            cp /root/*.cer /opt/splunk/etc/auth/mycert/
            
        fi
        sleep 3
        

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
       


    }

    cleanstuff(){
        echo
        echo
        read -p " Clean Stuff at /tmp /root ? " -n 1 -r
        echo
        echo 

        if [[ $REPLY =~ ^[Yy]$ ]]; then

        rm -rf /tmp/*.cer
        rm -rf /tmp/*.csr
        rm -rf /tmp/*.key
        rm -rf /root/*.cer

        
        else 
        
        start
        
        fi
        

    }

    ############

    password
    certreq
    format
    CopyCert
    cleanstuff


    ####CA-Cert
    ####/usr/share/pki/ca-trust-source/anchors/
    ####update-ca-trust
    ####trust list | grep ICA

    ### Return to Start
    start

}

######################################################################################
##################################### Splunk Basis Install ###########################
######################################################################################
BETAsplunkbase(){

    SetFirewallSettings(){
        ### Setting firewall rules for communication ###
        
        colormsg "### Set Firewall settings ###"
        echo

        ports=("9997/tcp" "9998/tcp" "9887/tcp" "8089/tcp" "9100/tcp" "8191/tcp" "8443/tcp" "8000/tcp")

        for port in "${ports[@]}"; do
            if firewall-cmd --add-port="$port"; then
                echo "Port $port added successfully"
            else
                colormsg "Failed to add port $port"
                return 1
            fi
        done

        # Make the changes persistent
        if ! firewall-cmd --runtime-to-permanent; then
            colormsg "Failed to make firewall changes persistent"
            return 1
        fi

        if ! firewall-cmd --reload; then
            colormsg "Failed to reload firewall"
            return 1
        fi
        
        colormsg "### Setting firewall-settings done ###"
        sleep 2
    }

    # Rest of the functions...
    # ...
    
    if [[ $auswahl2 == "Syslog" ]]; then
        colormsg "### Splunk Basis Install ohne 2. HDD ###"
        
        if ! SetFirewallSettings; then
            colormsg "Failed to set firewall settings"
            return 1
        fi

        # Rest of the code...
        # ...
    else
        colormsg "### Splunk Basis Install mit 2. HDD ###"
        
        if ! neuePartition; then
            colormsg "Failed to create new partition"
            return 1
        fi

        if ! SetFirewallSettings; then
            colormsg "Failed to set firewall settings"
            return 1
        fi

        # Rest of the code...
        # ...
    fi
}


splunkbase(){

    SetFirewallSettings(){
	
        ### Setting firewall rules for communication ###
        
        colormsg "### Set Firewall settings ###"
        echo

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
        sleep 2
	
	}

    RunPackageInstaller() {
        colormsg "### Run Splunk install ###"

        PfadUFInst="/opt/splunkforwarder"
        PfadInst="/opt/splunk"

        if [ -d "$PfadUFInst" ]; 
        then
            echo "Splunkforwarder im Verzeichnis /opt vorhanden ! "
            echo "Forwarder wird hier nicht benötigt "

            read -p "Soll UFWD deinstalliert werden ? --> Y / N <-- : "
            echo 
                if [[ $REPLY =~ ^[Yy]$ ]]; 
                then
                echo "Starte Uninstall UFWD "
                echo
                yum -y remove splunkforwarder.x86_64
                echo
                rm -rf /opt/splunkforwarder
                colormsg "### Deinstall of Splunkforwarder Done ###"
                echo
                sleep 2
                else
                colormsg "### Beende Install ###"
                exit
                fi
        elif [ -d "$PfadInst" ]; 
        then
            echo "Splunk already installed ! "
            read -p "Soll Splunk geupdatet werden ? --> Y / N <-- : "
            echo 
                if [[ $REPLY =~ ^[Nn]$ ]]; 
                then
                colormsg "### Beende Install ###"
                exit
                else
                colormsg "### Run Splunk update ###"
                cd $download
                yum -y localinstall $SplunkRPM
                sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
                sleep 2
                fi
        else
            colormsg "### Run Splunk install ###"
            cd $download
            yum -y localinstall $SplunkRPM
            sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
            echo
            colormsg "### Installation of Splunk-Packages Done ###"
            echo
            sleep 2
        fi
	}

    initpassword(){

        colormsg '### Initial SPLUNK User ###'
        echo
        echo -n "Splunk initial Username: "
        echo
        read -s splunkusername
        echo

        colormsg '### Initial SPLUNK password ###'
        echo
        echo -n "Splunk initial password: "
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
        echo PASSWORD = $splunkpassword >> /opt/splunk/etc/system/local/user-seed.conf

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
       

        colormsg "### Spunk restart ###"
        sudo -u $SplunkRunAs /opt/splunk/bin/splunk restart
        sleep 2
	}

    splunkalias() {
	
        colormsg "#### Set Splunk Alias ####"

        hostsfile=/root/.bashrc

        if grep -q 'splunk' $hostsfile; then
		colormsg "Alias already set!" "red"
		
        else
        alias splunk='/opt/splunk/bin/splunk '
        echo alias splunk='/opt/splunk/bin/splunk ' >> /root/.bashrc

        alias splunk='/opt/splunk/bin/splunk '
        echo alias splunk='/opt/splunk/bin/splunk ' >> /home/splunk/.bashrc
        fi
	}



    if [[ $auswahl2 == "Syslog" ]]; then
    colormsg "### Splunk Basis Install ohne 2. HDD ###"
     
    SetFirewallSettings
    RunPackageInstaller
    initpassword
    StartSplunk
    splunkalias
    $auswahl2

    else

    colormsg "### Splunk Basis Install mit 2. HDD ###"
    
    neuePartition
    SetFirewallSettings
    RunPackageInstaller
    initpassword
    StartSplunk
    splunkalias
    $auswahl2
    
}

######################################################################################
##################################### Deployment #####################################
######################################################################################
BETADeployment(){

    colormsg "### Start SPLUNK Deployment Config ###"
    sleep 1
	
    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root || echo "Fehler: lvextend ist fehlgeschlagen"
    xfs_growfs /dev/mapper/sysvg-lv_root || echo "Fehler: xfs_growfs ist fehlgeschlagen"

    adminpassword(){

		colormsg '### SPLUNK Admin-User ###'
		echo -n "SPLUNK Admin-Username : "
		read splunkusername
		echo

		colormsg '### SPLUNK Admin-User password ###'
		echo -n "SPLUNK Admin-User password : "
		read -s splunkpassword
		echo

        colormsg '### SPLUNK Cluster secret ###'
        echo -n "Splunk Cluster secret : "
        read -s clusertsecret
        echo

        colormsg '### SPLUNK Cluster Name ###'
        echo -n "Splunk Cluster name : "
        read clusterlabel
        echo

	}

	License(){
		colormsg '### Copy Licence for SPLUNK ###'
        sleep 1

		mkdir -p /opt/splunk/etc/licenses/enterprise || echo "Fehler: Das Erstellen des Verzeichnisses ist fehlgeschlagen"

		cp -r /tmp/Sources/*.License /opt/splunk/etc/licenses/enterprise || echo "Fehler: Das Kopieren der Lizenz ist fehlgeschlagen"

		mv /opt/splunk/etc/licenses/enterprise/*.License /opt/splunk/etc/licenses/enterprise/SPLUNK_vCPU.License.lic || echo "Fehler: Das Umbenennen der Lizenz ist fehlgeschlagen"

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk || echo "Fehler: chown ist fehlgeschlagen"
       

		#/opt/splunk/bin/splunk restart

	}

    clusterconfig(){
    
    	colormsg '### Enable Cluster ###'
        sleep 1

    	/opt/splunk/bin/splunk edit cluster-config -mode manager -replication_factor 3 -search_factor 3 -secret $clusertsecret -cluster_label $clusterlabel || echo "Fehler: Die Cluster-Konfiguration ist fehlgeschlagen"

		#/opt/spl...unk/bin/splunk restart

    }

	copyapps(){ 

		colormsg '### untar App Files ###'
        sleep 1

        mkdir -p /tmp/pack || echo "Fehler: Das Erstellen des Verzeichnisses /tmp/pack ist fehlgeschlagen"
        mkdir -p /tmp/spl || echo "Fehler: Das Erstellen des Verzeichnisses /tmp/spl ist fehlgeschlagen"

		for file in $download/*.tgz; do tar xf $file -C /tmp/pack; done
        for file in $download/*.tar; do tar xf $file -C /tmp/pack; done
        for file in $download/*.spl; do tar xf $file -C /tmp/spl; done

        colormsg '### copy App Files ###'

        copy_and_verify() {
            yes | cp -R $1 $2 || echo "Fehler: Das Kopieren von $1 zu $2 ist fehlgeschlagen"
        }

        copy_and_verify "/tmp/pack/deployment-apps/*" "/opt/splunk/etc/deployment-apps"
        copy_and_verify "/tmp/pack/local/*" "/opt/splunk/etc/system/local"
        copy_and_verify "/tmp/pack/master-apps/*" "/opt/splunk/etc/master-apps"

        yes | rm -rf /tmp/pack/deployment-apps || echo "Fehler: Das Löschen von /tmp/pack/deployment-apps ist fehlgeschlagen"
        yes | rm -rf /tmp/pack/local || echo "Fehler: Das Löschen von /tmp/pack/local ist fehlgeschlagen"
        yes | rm -rf /tmp/pack/master-apps || echo "Fehler: Das Löschen von /tmp/pack/master-apps ist fehlgeschlagen"

        copy_and_verify "/tmp/pack/*" "/opt/splunk/etc/master-apps"
        copy_and_verify "/tmp/spl/SA-IndexCreation" "/opt/splunk/etc/master-apps"
        copy_and_verify "/tmp/spl/SA-UserAccess" "/opt/splunk/etc/apps"
        copy_and_verify "/tmp/spl/SA-ITSI-Licensechecker" "/opt/splunk/etc/apps"

        copy_and_verify "/tmp/pack/Splunk_TA_symantec-ep" "/opt/splunk/etc/deployment-apps"
        copy_and_verify "/tmp/pack/Splunk_TA_windows" "/opt/splunk/etc/deployment-apps"
        copy_and_verify "/tmp/pack/Splunk_TA_nix" "/opt/splunk/etc/deployment-apps"

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk/etc || echo "Fehler: chown ist fehlgeschlagen"
       

        #/opt/splunk/bin/splunk restart

        
	}
   
    finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources || echo "Fehler: Das Löschen von /tmp/Sources ist fehlgeschlagen"
        rm -rf /tmp/pack || echo "Fehler: Das Löschen von /tmp/pack ist fehlgeschlagen"

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit

    }

    #### Script Startpunkte ####
    adminpassword
    License
    clusterconfig
    copyapps
    finished
    $anlage
    
}


Deployment(){

    colormsg "### Start SPLUNK Deployment Config ###"
    sleep 1
	
    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root
    xfs_growfs /dev/mapper/sysvg-lv_root

    adminpassword(){

		colormsg '### SPLUNK Admin-User ###'
		echo -n "SPLUNK Admin-Username : "
        echo
		read -s splunkusername
		echo

		colormsg '### SPLUNK Admin-User password ###'
		echo -n "SPLUNK Admin-User password : "
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
        read -s clusterlabel
        echo

	}

	License(){
		colormsg '### Copy Licence for SPLUNK ###'
        sleep 1

		mkdir -p /opt/splunk/etc/licenses/enterprise

		cp -r /tmp/Sources/*.License /opt/splunk/etc/licenses/enterprise

		mv /opt/splunk/etc/licenses/enterprise/*.License /opt/splunk/etc/licenses/enterprise/SPLUNK_vCPU.License.lic

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
       

		#/opt/splunk/bin/splunk restart

	}

    clusterconfig(){
    
    	colormsg '### Enable Cluster ###'
        sleep 1

    	/opt/splunk/bin/splunk edit cluster-config -mode manager -replication_factor 3 -search_factor 3 -secret $clusertsecret -cluster_label $clusterlabel

		#/opt/splunk/bin/splunk restart

    }

	copyapps(){ 

		colormsg '### untar App Files ###'
        sleep 1

        mkdir -p /tmp/pack
        mkdir -p /tmp/spl


		for file in $download/*.tgz; do tar xf $file -C /tmp/pack; done
        for file in $download/*.tar; do tar xf $file -C /tmp/pack; done
        for file in $download/*.spl; do tar xf $file -C /tmp/spl; done

        colormsg '### copy App Files ###'

		yes | cp -R /tmp/pack/deployment-apps/* /opt/splunk/etc/deployment-apps
        yes | cp -R /tmp/pack/local/* /opt/splunk/etc/system/local
        yes | cp -R /tmp/pack/master-apps/* /opt/splunk/etc/master-apps

        yes | rm -rf /tmp/pack/deployment-apps
        yes | rm -rf /tmp/pack/local
        yes | rm -rf /tmp/pack/master-apps

        yes | cp -R /tmp/pack/* /opt/splunk/etc/master-apps
        yes | cp -R /tmp/spl/SA-IndexCreation /opt/splunk/etc/master-apps
        yes | cp -R /tmp/spl/SA-UserAccess /opt/splunk/etc/apps
        yes | cp -R /tmp/spl/SA-ITSI-Licensechecker /opt/splunk/etc/apps

        yes | cp -R /tmp/pack/Splunk_TA_symantec-ep /opt/splunk/etc/deployment-apps
        yes | cp -R /tmp/pack/Splunk_TA_windows /opt/splunk/etc/deployment-apps
        yes | cp -R /tmp/pack/Splunk_TA_nix /opt/splunk/etc/deployment-apps


        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk/etc
       

        #/opt/splunk/bin/splunk restart

        
	}
   
    finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources
        rm -rf /tmp/pack

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit

    }

    #### Script Startpunkte ####
    adminpassword
    License
    clusterconfig
    copyapps
    finished
    $anlage
    
}

######################################################################################
##################################### Searchhead #####################################
######################################################################################
BETASearchhead(){

    set -e
    trap 'colormsg "\nEin Fehler ist aufgetreten. Exit-Status: $? Skript wird beendet."' ERR

    colormsg "### Start SPLUNK Searchhead Config ###"
	
    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root || { colormsg "Fehler beim Erweitern des Logical Volumes"; exit 1; }
    xfs_growfs /dev/mapper/sysvg-lv_root || { colormsg "Fehler beim Wachsen des XFS-Dateisystems"; exit 1; }

    adminpassword(){

        colormsg '### SPLUNK Admin-User ###'
        echo -n "SPLUNK Admin-Username : "
        read -s splunkusername
        echo

        colormsg '### SPLUNK Admin-User password ###'
        echo -n "SPLUNK Admin-User password : "
        read -s splunkpassword
        echo

        colormsg '### SPLUNK Cluster secret ###'
        echo -n "Splunk Cluster secret : "
        read -s clusertsecret
        echo

        colormsg '### SPLUNK Cluster Name ###'
        echo -n "Splunk Cluster name : "
        read -s clusterlabel
        echo

        colormsg '### Deployment Server IP ###'
        echo -n "Deployment Server IP"
        read -s deployip
        echo
    }

    clusterconfig(){

        colormsg '### Set License Server ###'
    
        /opt/splunk/bin/splunk edit licenser-localslave -master_uri https://$deployip:8089 -auth $splunkusername:$splunkpassword || { colormsg "Fehler beim Konfigurieren des Lizenzservers"; exit 1; }

        /opt/splunk/bin/splunk edit cluster-config -mode searchhead -manager_uri https://$deployip:8089 -secret $clusertsecret -cluster_label $clusterlabel || { colormsg "Fehler bei der Konfiguration des Clusters"; exit 1; }

        #/opt/splunk/bin/splunk restart
    }


    copyapps(){ 

        colormsg '### untar App Files ###'
        mkdir -p /tmp/pack

        for file in $download/*.tgz; do tar xf $file -C /tmp/pack || { colormsg "Fehler beim Entpacken von $file"; exit 1; }; done
        for file in $download/*.tar; do tar xf $file -C /tmp/pack || { colormsg "Fehler beim Entpacken von $file"; exit 1; }; done
        for file in $download/*.spl; do tar xf $file -C /tmp/pack || { colormsg "Fehler beim Entpacken von $file"; exit 1; }; done

        colormsg '### copy App Files ###'

        yes | cp -R /tmp/pack/local/* /opt/splunk/etc/system/local || { colormsg "Fehler beim Kopieren der App-Dateien"; exit 1; }
        yes | rm -rf /tmp/pack/local || { colormsg "Fehler beim Löschen des temporären Verzeichnisses"; exit 1; }
        yes | cp -R /tmp/pack/* /opt/splunk/etc/apps || { colormsg "Fehler beim Kopieren der App-Dateien"; exit 1; }

        sudo chown -R $SplunkRunAs:$SplHier ist die Fortsetzung des verbesserten Skripts:

```bash
        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk/etc || { colormsg "Fehler beim Ändern des Besitzers der Splunk-Dateien"; exit 1; }

        #/opt/splunk/bin/splunk restart
    }

    finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources || { colormsg "Fehler beim Löschen des temporären Verzeichnisses"; exit 1; }
        rm -rf /tmp/pack || { colormsg "Fehler beim Löschen des temporären Verzeichnisses"; exit 1; }

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit
    }

    #### Script Startpunkte ####
    adminpassword
    clusterconfig
    copyapps
    finished
    $anlage

    trap - ERR
    colormsg "\nDas Skript wurde erfolgreich abgeschlossen."
}


Searchhead(){

    colormsg "### Start SPLUNK Searchhead Config ###"
    sleep 1
	
    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root
    xfs_growfs /dev/mapper/sysvg-lv_root

    adminpassword(){

		colormsg '### SPLUNK Admin-User ###'
		echo -n "SPLUNK Admin-Username : "
        echo
		read -s splunkusername
		echo

		colormsg '### SPLUNK Admin-User password ###'
		echo -n "SPLUNK Admin-User password : "
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
		read -s clusterlabel
		echo

        colormsg '### Deployment Server IP ###'
		echo -n "Deployment Server IP"
        echo
		read -s deployip
		echo
	}

    clusterconfig(){
    
    	colormsg '### Set License Server ###'
    
   
    	/opt/splunk/bin/splunk edit licenser-localslave -master_uri https://$deployip:8089 -auth $splunkusername:$splunkpassword

		/opt/splunk/bin/splunk edit cluster-config -mode searchhead -manager_uri https://$deployip:8089 -secret $clusertsecret -cluster_label $clusterlabel

		#/opt/splunk/bin/splunk restart

    }


	copyapps(){ 

		colormsg '### untar App Files ###'
        sleep 1

        mkdir -p /tmp/pack


		for file in $download/*.tgz; do tar xf $file -C /tmp/pack; done
        for file in $download/*.tar; do tar xf $file -C /tmp/pack; done
        for file in $download/*.spl; do tar xf $file -C /tmp/pack; done

        colormsg '### copy App Files ###'


        yes | cp -R /tmp/pack/local/* /opt/splunk/etc/system/local

        yes | rm -rf /tmp/pack/local

        yes | cp -R /tmp/pack/* /opt/splunk/etc/apps


        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk/etc
       

        #/opt/splunk/bin/splunk restart

        
	}

       finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources
        rm -rf /tmp/pack

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit

    }

    #### Script Startpunkte ####
    adminpassword
    clusterconfig
    copyapps
    finished
    $anlage

}

######################################################################################
##################################### Indexer ########################################
######################################################################################
BETAIndexer(){

    set -e
    trap 'colormsg "\nEin Fehler ist aufgetreten. Exit-Status: $? Skript wird beendet."' ERR

    colormsg "### Start SPLUNK Inder Config ###"

    adminpassword(){

        colormsg '### SPLUNK Admin-User ###'
        echo -n "SPLUNK Admin-Username : "
        read -s splunkusername
        echo

        colormsg '### SPLUNK Admin-User password ###'
        echo -n "SPLUNK Admin-User password : "
        read -s splunkpassword
        echo

        colormsg '### SPLUNK Cluster secret ###'
        echo -n "Splunk Cluster secret : "
        read -s clusertsecret
        echo

        colormsg '### SPLUNK Cluster Name ###'
        echo -n "Splunk Cluster name : "
        read -s clusterlabel
        echo

        colormsg '### Deployment Server IP ###'
        echo -n "Deployment Server IP"
        read -s deployip
        echo
    }

    clusterconfig(){

        colormsg '### Set License Server ###'
       
        /opt/splunk/bin/splunk edit licenser-localslave -master_uri https://$deployip:8089 -auth $splunkusername:$splunkpassword || { colormsg "Fehler beim Konfigurieren des Lizenzservers"; exit 1; }

        /opt/splunk/bin/splunk edit cluster-config -mode peer -manager_uri https://$deployip:8089 -secret $clusertsecret -replication_port 9887 -cluster_label $clusterlabel || { colormsg "Fehler bei der Konfiguration des Clusters"; exit 1; }

        #opt/splunk/bin/splunk restart
    }

    finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources
        rm -rf /tmp/pack

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit
    }
    

    #### Script Startpunkte ####
    adminpassword
    clusterconfig
    finished
    $anlage

    trap - ERR
    colormsg "\nDas Skript wurde erfolgreich abgeschlossen."
}



Indexer(){

    colormsg "### Start SPLUNK Inder Config ###"

    adminpassword(){

		colormsg '### SPLUNK Admin-User ###'
		echo -n "SPLUNK Admin-Username : "
        echo
		read -s splunkusername
		echo

		colormsg '### SPLUNK Admin-User password ###'
		echo -n "SPLUNK Admin-User password : "
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
		read -s clusterlabel
		echo

        colormsg '### Deployment Server IP ###'
		echo -n "Deployment Server IP"
        echo
		read -s deployip
		echo
	}

    clusterconfig(){
    
    	colormsg '### Set License Server ###'
       
    	/opt/splunk/bin/splunk edit licenser-localslave -master_uri https://$deployip:8089 -auth $splunkusername:$splunkpassword

		/opt/splunk/bin/splunk edit cluster-config -mode peer -manager_uri https://$deployip:8089 -secret $clusertsecret -replication_port 9887 -cluster_label $clusterlabel

		#opt/splunk/bin/splunk restart

    }

    finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources
        rm -rf /tmp/pack

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit

    }
    

    #### Script Startpunkte ####
    adminpassword
    clusterconfig
    finished
    $anlage

}

######################################################################################
##################################### Syslog #########################################
######################################################################################
BETASyslog(){

    set -e
    trap 'colormsg "\nEin Fehler ist aufgetreten. Exit-Status: $? Skript wird beendet."' ERR

    colormsg "### Start SPLUNK HFWD Syslog Config ###"
    sleep 1

    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root
    xfs_growfs /dev/mapper/sysvg-lv_root

    copyapps(){ 

        colormsg '### Copy App Files ###'
        sleep 1
        mkdir -p /tmp/pack

        #tar xf $download/DBConnect.tar -C /tmp/pack

        #yes | cp -R /tmp/pack/DBC* /opt/splunk/etc/apps

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
    }

    internNAT(){

        colormsg "### Redirect Ports ###"

        local ports=("514:proto=tcp:toport=10514" "514:proto=udp:toport=10514" "10514/tcp" "10514/udp" "514/tcp" "514/udp" "1514/tcp" "9997/tcp" "9998/tcp" "8000/tcp" "8443/tcp")

        for port in "${ports[@]}"; do
            firewall-cmd --add-forward-port=port=$port
            firewall-cmd --add-port=$port
        done

        firewall-cmd --runtime-to-permanent
        firewall-cmd --reload

        colormsg "### Redirect Ports done ###"
        sleep 2
    }

    deploymentc(){

        colormsg '### Set deployment.conf ###'

        GetFQDN=$(sudo hostname --fqdn)

        deployconf=/opt/splunk/etc/system/local/deploymentclient.conf

        echo -n "Deployment Server IP"
        read -s deployip
        echo

        cat > $deployconf << EOF
[deployment-client]
clientName = $GetFQDN
phoneHomeIntervalInSecs=60
appEventsResyncIntervalInSecs=3600

[target-broker:deploymentServer]
targetUri = $deployip:8089
EOF
    }

    finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources
        rm -rf /tmp/pack

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit
    }

    #### Script Startpunkte ####
    copyapps
    internNAT
    deploymentc
    finished
    $anlage

    trap - ERR
    colormsg "\nDas Skript wurde erfolgreich abgeschlossen."
}


Syslog(){

    colormsg "### Start SPLUNK HFWD Syslog Config ###"
    sleep 1

    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root
    xfs_growfs /dev/mapper/sysvg-lv_root

    copyapps(){ 

		colormsg '### Copy App Files ###'
        sleep 1
        mkdir -p /tmp/pack

		#tar xf $download/DBConnect.tar -C /tmp/pack

		#yes | cp -R /tmp/pack/DBC* /opt/splunk/etc/apps

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
	}

    internNAT(){
        
        
        colormsg "### Redirect Ports ###"

        firewall-cmd --add-forward-port=port=514:proto=tcp:toport=10514
        firewall-cmd --add-forward-port=port=514:proto=udp:toport=10514
        firewall-cmd --add-port="10514/tcp"
        firewall-cmd --add-port="10514/udp"
        firewall-cmd --add-port="514/tcp"
        firewall-cmd --add-port="514/udp"
    #vcenter + esxi syslog
        firewall-cmd --add-port="1514/tcp"
    #splunk data Ports
        firewall-cmd --add-port="9997/tcp"
        firewall-cmd --add-port="9998/tcp"
        firewall-cmd --add-port="8000/tcp"
        firewall-cmd --add-port="8443/tcp"
        firewall-cmd --runtime-to-permanent
        firewall-cmd --reload
     

        colormsg "### Redirect Ports done ###"
        sleep 2
        
    }

    deploymentc(){

        colormsg '### Set deployment.conf ###'

        GetFQDN=$(sudo hostname --fqdn)

        deployconf=/opt/splunk/etc/system/local/deploymentclient.conf

		echo -n "Deployment Server IP"
        echo
		read -s deployip
		echo

        touch $deployconf

        echo "[deployment-client]" >> $deployconf
        echo "clientName = $GetFQDN" >> $deployconf
        echo "phoneHomeIntervalInSecs=60" >> $deployconf
        echo "appEventsResyncIntervalInSecs=3600" >> $deployconf
        echo  >> $deployconf
        echo "[target-broker:deploymentServer]" >> $deployconf
        echo "targetUri = $deployip:8089" >> $deployconf

    }

    finished(){

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources
        rm -rf /tmp/pack

        colormsg '### Alles aufgeräumt :) ###'
        echo
        exit

    }

   
    #### Script Startpunkte ####
    copyapps
    internNAT
    deploymentc
    finished
    $anlage

}

######################################################################################
##################################### Build Package ##################################
######################################################################################

BETABuildPackage(){

    set -e
    trap 'colormsg "\nEin Fehler ist aufgetreten. Exit-Status: $? Skript wird beendet."' ERR

    colormsg "### Splunk Build Package ###"

    mkdir -p $mountpoint
    mkdir -p $download

    umount $mountpoint
    mount -t nfs $syno:/volume1/Software $mountpoint

    if mount | grep $mountpoint; then
        colormsg "\nMountpoint Found !" "green"
    else
        colormsg "\nMountpoint not Found !" "red"
        exit
    fi

    PS3="Was soll Installiert werden? : "
    select auswahl2 in Deployment Searchhead Indexer Syslog Back End
    do
        case "$auswahl2" in
            End)   echo "End"; umount $mountpoint && exit ;;
            Back)   echo "Back"; start ;;
            "")     echo "Ungültige Auswahl"; start ;;
            *)      echo "Sie haben $auswahl2 gewählt" &&\
                   
    find_and_copy(){
        for i in "${@}"
        do
            result=""
            result=$(find $mountpoint -name $i)
            if  [ "$result" == "" ];
                then
                    colormsg "\n$i nicht vorhanden!" "red"
                    colormsg "\nAbbruch" "red"
                    exit
                else
                    echo Kopiere $i
                    find $mountpoint -name $i | xargs --no-run-if-empty cp --target-directory $download
            fi
        done
    }

###### Pack Donwload

    if [[ $auswahl2 == "Deployment" ]]; then
        colormsg "### Suche Deployment Packs ###"
        find_and_copy "${sources[@]}" "${deploysource[@]}" "${deployconfig[@]}"

    elif [[ $auswahl2 == "Searchhead" ]]; then
        colormsg "### Suche Searchhead Packs ###"
        find_and_copy "${sources[@]}" "${seasource[@]}" "${seaconfig[@]}"

    elif [[ $auswahl2 == "Indexer" ]]; then
        colormsg "### Suche Indexer Packs ###"
        find_and_copy "${sources[@]}"

    elif [[ $auswahl2 == "Syslog" ]]; then
        colormsg "### Suche Syslog Packs ###"
        find_and_copy "${sources[@]}" "${syslogsource[@]}"

    fi

###### next Step

    splunkbase
    ;;
    esac
    done

    trap - ERR
    colormsg "\nDas Skript wurde erfolgreich abgeschlossen."
}

BuildPackage(){

    colormsg "### Splunk Build Package ###"

    mkdir -p $mountpoint
    mkdir -p $download

    umount $mountpoint
    mount -t nfs $syno:/volume1/Software $mountpoint

    if mount | grep $mountpoint; then
        echo
		colormsg "Mountpoint Found ! " "green"
        echo
	else
        echo
        colormsg "Mountpoint not Found ! " "red"
        echo
            exit
        echo
    fi

    PS3="Was soll Installiert werden? : "
    select auswahl2 in Deployment Searchhead Indexer Syslog Back End
    do
        case "$auswahl2" in
            End)   echo "End"; umount $mountpoint && exit ;;
            Back)   echo "Back"; start ;;
            "")     echo "Ungültige Auswahl"; start ;;
            *)      echo "Sie haben $auswahl2 gewählt" &&\
                   
    
###### Pack Donwload

    if [[ $auswahl2 == "Deployment" ]]; then
        colormsg "### Suche Deployment Packs ###"
        echo
            for i in "${sources[@]}" "${deploysource[@]}" "${deployconfig[@]}"
            do
            result=""
            result=$(find $mountpoint -name $i)
            if  [ "$result" == "" ];
                then
                    echo
                    colormsg "$i nicht vorhanden! " "red"
                    echo
                    colormsg "Abbruch" "red"
                        exit
                    echo
                else
                    echo Kopiere $i
                    find $mountpoint -name $i | xargs --no-run-if-empty cp --target-directory $download
            fi
            done

    elif [[ $auswahl2 == "Searchhead" ]]; then
        colormsg "### Suche Searchhead Packs ###"
        echo
            for i in "${sources[@]}" "${seasource[@]}" "${seaconfig[@]}"
            do
            result=""
            result=$(find $mountpoint -name $i)
            if  [ "$result" == "" ];
                then
                    echo
                    colormsg "$i nicht vorhanden! " "red"
                    echo
                    rm -rf $download
                    colormsg "Abbruch" "red"
                        exit
                    echo
                else
                    echo Kopiere $i
                    find $mountpoint -name $i | xargs --no-run-if-empty cp --target-directory $download
            fi
            done

    elif [[ $auswahl2 == "Indexer" ]]; then
        colormsg "### Suche Indexer Packs ###"
        echo
            for i in "${sources[@]}"
            do
            result=""
            result=$(find $mountpoint -name $i)
            if  [ "$result" == "" ];
                then
                    echo
                    colormsg "$i nicht vorhanden! " "red"
                    echo
                    colormsg "Abbruch" "red"
                        exit
                    echo
                else
                    echo Kopiere $i
                    find $mountpoint -name $i | xargs --no-run-if-empty cp --target-directory $download
            fi
            done

    elif [[ $auswahl2 == "Syslog" ]]; then
        colormsg "### Suche Syslog Packs ###"
        echo
            for i in "${sources[@]}" "${syslogsource[@]}"
            do
            result=""
            result=$(find $mountpoint -name $i)
            if  [ "$result" == "" ];
                then
                    echo
                    colormsg "$i nicht vorhanden! " "red"
                    echo
                    colormsg "Abbruch" "red"
                        exit
                    echo
                else
                    echo Kopiere $i
                    find $mountpoint -name $i | xargs --no-run-if-empty cp --target-directory $download
            fi
            done

    fi

###### next Step

    echo
        splunkbase
    echo
    ;;
    esac
    done

}

BETAneuePartition(){
    set -e
    trap 'colormsg "Ein Fehler ist aufgetreten. Exit-Status: $? Skript wird beendet."' ERR

    colormsg "Erstelle Neue Partition"

    parted /dev/sdb mklabel splunk
    parted -a opt /dev/sdb mkpart primary ext4 0% 100%
    
    sleep 2
    colormsg "Weiter mit formatieren"

    mkfs.ext4 /dev/sdb1

    sleep 2
    colormsg "weiter mit Mounting /opt/splunk on HDD 2"
    
    mount /dev/sdb1 /opt/splunk
    echo /dev/sdb1 /opt/splunk ext4 defaults 0 0 >> /etc/fstab

    trap - ERR
    colormsg "Das Skript wurde erfolgreich abgeschlossen."
}


neuePartition(){

        colormsg "Erstelle Neue Partition"

        fdisk /dev/sdb << FDISK_CMDS
        d
        n
        1


        t
        83
        w
        FDISK_CMDS
        
        sleep 2
        colormsg "Weiter mit formatieren"

        mkfs.ext4 /dev/sdb1

        sleep 2
        colormsg "weiter mit Mounting /opt/splunk on HDD 2"
        
        mount /dev/sdb1 /opt/splunk
        echo /dev/sdb1 /opt/splunk ext4 defaults 0 0 >> /etc/fstab

}

######################################################################################
##################################### Funktionen #####################################
######################################################################################

# Select Anweisung
start(){

    PS3="Auf welcher Anlage befinden wir uns ? : "
    select anlage in Unbekannt GMNSRA01 GMNSRA02 GMNSRA03 TMN01 End
    do
    case "$anlage" in
    Unbekannt)  echo "Bitte nachgucken ! "; exit;;
    End)    echo "End"; exit ;;
    "")     echo "Ungültige Auswahl"; start ;;
    *)      echo "Sie haben $anlage gewählt" &&\
    echo
    $anlage
    echo
    ;;
    esac
    done

}
start
