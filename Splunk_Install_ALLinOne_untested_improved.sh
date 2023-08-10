#!/bin/bash


######################################
## ALL in ONE
## STAND: 18/10/22
######################################

if [[ $EUID -ne 0 ]]; then
   echo "Dieses Skript muss als Root ausgeführt werden." 
   exit 1
fi

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
############################### Einlesen der Config Datei ############################
######################################################################################

declare -A config
declare -A value_counts

while true; do
    unset config
    declare -A config
    unset value_counts
    declare -A value_counts

    while IFS='=' read -r key value; do
        config[$key]=$value
        value_counts[$value]=$(( ${value_counts[$value]} + 1 ))
    done < Konfig.txt

    missing_files=false

    for key in "${!config[@]}"; do
        if [[ -z "${config[$key]}" ]]; then
            echo "Fehler: $key ist nicht definiert" >&2
        else
            echo "$key=${config[$key]}"
            if [[ ${value_counts[${config[$key]}]} -gt 1 ]]; then
                echo "Warnung: Der Wert '${config[$key]}' wird mehr als einmal verwendet" >&2
            fi
            if [[ ! -f ${config[$key]} ]]; then
                echo "Fehler: '${config[$key]}' ist eine Datei, aber sie existiert nicht" >&2
                missing_files=true
            fi
        fi
    done

    if $missing_files; then
        while true; do
            echo "Es wurden fehlende Dateien gefunden. Möchten Sie sie hinzufügen (h) oder ignorieren (i)?"
            read -r answer
            if [[ $answer = "i" ]]; then
                exit 1
            elif [[ $answer = "h" ]]; then
                while true; do
                    echo "Fügen Sie die fehlenden Dateien hinzu und geben Sie dann 'y' ein, wenn Sie fertig sind."
                    read -r answer
                    if [[ $answer = "y" ]]; then
                        break
                    fi
                done
                break
            else
                echo "Ungültige Eingabe. Bitte geben Sie 'h' zum Hinzufügen oder 'i' zum Ignorieren ein."
            fi
        done
    else
        break
    fi
done

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


######################################################################################
##################################### Deployment #####################################
######################################################################################
BETADeployment(){

    trap cleanup ERR EXIT

    set -e
    colormsg "### Start SPLUNK Deployment Config ###"
    sleep 1
	
    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root || { colormsg "Fehler beim Erweitern des Logical Volumes"; exit 1; }
    xfs_growfs /dev/mapper/sysvg-lv_root || { colormsg "Fehler beim Wachsen des XFS-Dateisystems"; exit 1; }

    adminpassword(){

		colormsg '### SPLUNK Admin-User ###'
		read -s -p "SPLUNK Admin-Username : " splunkusername
		echo

		colormsg '### SPLUNK Admin-User password ###'
		read -s -p "SPLUNK Admin-User password : " splunkpassword
		echo

        colormsg '### SPLUNK Cluster secret ###'
        read -s -p "Splunk Cluster secret : " clusertsecret
        echo

        colormsg '### SPLUNK Cluster Name ###'
        read -s -p "Splunk Cluster name : " clusterlabel
        echo

	}

	License(){
		colormsg '### Copy Licence for SPLUNK ###'
        sleep 1

		mkdir -p /opt/splunk/etc/licenses/enterprise || { colormsg "Fehler beim Erstellen des Verzeichnisses"; exit 1; }

		cp -r /tmp/Sources/*.License /opt/splunk/etc/licenses/enterprise || { colormsg "Fehler beim Kopieren der Lizenz"; exit 1; }

		mv /opt/splunk/etc/licenses/enterprise/*.License /opt/splunk/etc/licenses/enterprise/SPLUNK_vCPU.License.lic || { colormsg "Fehler beim Umbenennen der Lizenz"; exit 1; }

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk || { colormsg "Fehler beim Ändern des Besitzers der Splunk-Dateien"; exit 1; }
       

		#/opt/splunk/bin/splunk restart

	}

    clusterconfig(){
    
    	colormsg '### Enable Cluster ###'
        sleep 1

    	/opt/splunk/bin/splunk edit cluster-config -mode manager -replication_factor 3 -search_factor 3 -secret $clusertsecret -cluster_label $clusterlabel || { colormsg "Fehler bei der Konfiguration des Clusters"; exit 1; }

		#/opt/splunk/bin/splunk restart

    }

    copyapps(){ 

    colormsg '### untar App Files ###'
    sleep 1

    mkdir -p /tmp/pack || { colormsg "Fehler beim Erstellen des Verzeichnisses /tmp/pack"; exit 1; }
    mkdir -p /tmp/spl || { colormsg "Fehler beim Erstellen des Verzeichnisses /tmp/spl"; exit 1; }

    for file in $download/*.tgz; do tar xf $file -C /tmp/pack || { colormsg "Fehler beim Entpacken von $file"; exit 1; }; done
    for file in $download/*.tar; do tar xf $file -C /tmp/pack || { colormsg "Fehler beim Entpacken von $file"; exit 1; }; done
    for file in $download/*.spl; do tar xf $file -C /tmp/spl || { colormsg "Fehler beim Entpacken von $file"; exit 1; }; done

    colormsg '### copy App Files ###'

    copy_and_verify() {
        yes | cp -R $1 $2 || { colormsg "Fehler beim Kopieren von $1 zu $2"; exit 1; }
    }

    copy_and_verify "/tmp/pack/deployment-apps/*" "/opt/splunk/etc/deployment-apps"
    copy_and_verify "/tmp/pack/local/*" "/opt/splunk/etc/system/local"
    copy_and_verify "/tmp/pack/master-apps/*" "/opt/splunk/etc/master-apps"

    yes | rm -rf /tmp/pack/deployment-apps || { colormsg "Fehler beim Löschen von /tmp/pack/deployment-apps"; exit 1; }
    yes | rm -rf /tmp/pack/local || { colormsg "Fehler beim Löschen von /tmp/pack/local"; exit 1; }
    yes | rm -rf /tmp/pack/master-apps || { colormsg "Fehler beim Löschen von /tmp/pack/master-apps"; exit 1; }

    copy_and_verify "/tmp/pack/*" "/opt/splunk/etc/master-apps"
    copy_and_verify "/tmp/spl/SA-IndexCreation" "/opt/splunk/etc/master-apps"
    copy_and_verify "/tmp/spl/SA-UserAccess" "/opt/splunk/etc/apps"
    copy_and_verify "/tmp/spl/SA-ITSI-Licensechecker" "/opt/splunk/etc/apps"

    copy_and_verify "/tmp/pack/Splunk_TA_symantec-ep" "/opt/splunk/etc/deployment-apps"
    copy_and_verify "/tmp/pack/Splunk_TA_windows" "/opt/splunk/etc/deployment-apps"
    copy_and_verify "/tmp/pack/Splunk_TA_nix" "/opt/splunk/etc/deployment-apps"

    sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk/etc || { colormsg "Fehler beim Ändern des Besitzers der Splunk-Dateien"; exit 1; }
       

    #/opt/splunk/bin/splunk restart

    }

    finished(){

    colormsg '### Install finished ; clean up ###'

    rm -rf /tmp/Sources || { colormsg "Fehler beim Löschen von /tmp/Sources"; exit 1; }
    rm -rf /Es tut mir leid für die vorherige Unterbrechung. Hier ist der vollständige Text:

    rm -rf /tmp/pack || { colormsg "Fehler beim Löschen von /tmp/pack"; exit 1; }

    colormsg '### Alles aufgeräumt :) ###'
    echo
    exit

    }

    cleanup(){
    colormsg '### Ein Fehler ist aufgetreten. Aufräumen... ###'
    rm -rf /tmp/Sources || { colormsg "Fehler beim Löschen von /tmp/Sources"; exit 1; }
    rm -rf /tmp/pack || { colormsg "Fehler beim Löschen von /tmp/pack"; exit 1; }
    exit 1
    }

    #### Script Startpunkte ####
    adminpassword
    License
    clusterconfig
    copyapps
    finished

}


######################################################################################
##################################### Searchhead #####################################
######################################################################################
BETASearchhead(){

    trap cleanup ERR EXIT

    set -e
    colormsg "### Start SPLUNK Searchhead Config ###"
	
    lvextend -l +100%FREE /dev/mapper/sysvg-lv_root || { colormsg "Fehler beim Erweitern des Logical Volumes"; exit 1; }
    xfs_growfs /dev/mapper/sysvg-lv_root || { colormsg "Fehler beim Wachsen des XFS-Dateisystems"; exit 1; }

    adminpassword(){

        colormsg '### SPLUNK Admin-User ###'
        read -s -p "SPLUNK Admin-Username : " splunkusername
        echo

        colormsg '### SPLUNK Admin-User password ###'
        read -s -p "SPLUNK Admin-User password : " splunkpassword
        echo

        colormsg '### SPLUNK Cluster secret ###'
        read -s -p "Splunk Cluster secret : " clusertsecret
        echo

        colormsg '### SPLUNK Cluster Name ###'
        read -s -p "Splunk Cluster name : " clusterlabel
        echo

        colormsg '### Deployment Server IP ###'
        read -s -p "Deployment Server IP: " deployip
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

        sudo chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk/etc || { colormsg "Fehler beim Ändern des Besitzers der Splunk-Dateien"; exit 1; }

        #/opt/splunk/bin/splunk restart
    }

    cleanup() {

        colormsg '### Install finished ; clean up ###'

        rm -rf /tmp/Sources || { colormsg "Fehler beim Löschen des temporären Verzeichnisses"; exit 1; }
        rm -rf /tmp/pack || { colormsg "Fehler beim Löschen des temporären Verzeichnisses"; exit 1; }

        colormsg '### Alles aufgeräumt :) ###'
        echo
    }

    #### Script Startpunkte ####
    adminpassword
    clusterconfig
    copyapps

    trap - ERR EXIT
    colormsg "Das Skript wurde erfolgreich abgeschlossen."
}


######################################################################################
##################################### Indexer ########################################
######################################################################################
BETAIndexer(){

    trap cleanup ERR EXIT

    set -e
    colormsg "### Start SPLUNK Inder Config ###"

    adminpassword(){

        colormsg '### SPLUNK Admin-User ###'
        read -s -p "SPLUNK Admin-Username : " splunkusername
        echo

        colormsg '### SPLUNK Admin-User password ###'
        read -s -p "SPLUNK Admin-User password : " splunkpassword
        echo

        colormsg '### SPLUNK Cluster secret ###'
        read -s -p "Splunk Cluster secret : " clusertsecret
        echo

        colormsg '### SPLUNK Cluster Name ###'
        read -s -p "Splunk Cluster name : " clusterlabel
        echo

        colormsg '### Deployment Server IP ###'
        read -s -p "Deployment Server IP: " deployip
        echo
    }

    clusterconfig(){

        colormsg '### Set License Server ###'
       
        /opt/splunk/bin/splunk edit licenser-localslave -master_uri https://$deployip:8089 -auth $splunkusername:$splunkpassword || { colormsg "Fehler beim Konfigurieren des Lizenzservers"; exit 1; }

        /opt/splunk/bin/splunk edit cluster-config -mode peer -manager_uri https://$deployip:8089 -secret $clusertsecret -replication_port 9887 -cluster_label $clusterlabel || { colormsg "Fehler bei der Konfiguration des Clusters"; exit 1; }

        #opt/splunk/bin/splunk restart
    }

    cleanup() {
        colormsg '### Install finished ; clean up ###'
        rm -rf /tmp/Sources
        rm -rf /tmp/pack
        colormsg '### Alles aufgeräumt :) ###'
        echo
    }
    

    #### Script Startpunkte ####
    adminpassword
    clusterconfig

    trap - ERR EXIT
    colormsg "Das Skript wurde erfolgreich abgeschlossen."
}


######################################################################################
##################################### Syslog #########################################
######################################################################################
BETASyslog(){

    trap cleanup ERR EXIT

    set -e
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

        chown -R $SplunkRunAs:$SplunkRunAs /opt/splunk
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

        GetFQDN=$(hostname --fqdn)

        deployconf="/opt/splunk/etc/system/local/deploymentclient.conf"

        while :; do
            read -r -s -p "Deployment Server IP: " deployip
            echo

            # check if user canceled the input
            if [ $? -ne 0 ]; then
                echo "Input canceled by the user"
                return 1
            fi

            # check if the input is empty
            if [ -z "$deployip" ]; then
                echo "No input provided. Please try again."
                continue
            fi

            # validate IPv4 address
            if [[ $deployip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                # check if each octet is less than or equal to 255
                IFS='.' read -ra ADDR <<< "$deployip"
                for i in "${ADDR[@]}"; do
                    if [[ $i -lt 0 || $i -gt 255 ]]; then
                        echo "Invalid IP address. Please try again."
                        continue 2
                    fi
                done
            else
                echo "Invalid IP address. Please try again."
                continue
            fi

            break
        done

        printf "[deployment-client]\nclientName = %s\nphoneHomeIntervalInSecs=60\nappEventsResyncIntervalInSecs=3600\n[target-broker:deploymentServer]\ntargetUri = %s:8089\n" "$GetFQDN" "$deployip" > "$deployconf"
    }

    cleanup() {
        colormsg '### Install finished ; clean up ###'
        rm -rf /tmp/Sources
        rm -rf /tmp/pack
       colormsg '### Alles aufgeräumt :) ###'
        echo
    }

    #### Script Startpunkte ####
    copyapps
    internNAT
    deploymentc

    trap - ERR EXIT
    colormsg "Das Skript wurde erfolgreich abgeschlossen."
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



