#!/bin/bash


######################################
## STAND: 19/10/22
## HF Schubert
######################################


######################################################################################
###############################Globale Variablen #####################################
######################################################################################


organizationalunit=GMN02

commonname=$(hostname -f)
serverip=$(hostname -i)
shortname=$(hostname)


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



