#!/bin/bash


# Einlesen Config Datei
source ./Splunk_Config_Variablen.txt

# Funktion zur Abfrage des Passworts
get_password() {
    echo -n "Password for Cert: "
    read -s password
    echo
}

# Funktion zur Erstellung des Zertifikatanforderung
create_cert_request() {
    echo "### Zertifikatrequest erstellen ###"
    sleep 3
    
    echo "### Generating key request for SplunkServer ###"
    openssl genrsa -des3 -passout pass:$password -out /tmp/SPLUNK.key 2048 -noout || {
        echo "Failed to generate key request"
        exit 1
    }

    openssl rsa -in /tmp/SPLUNK.key -passin pass:$password -out /tmp/SPLUNK.key || {
        echo "Failed to remove passphrase from the key"
        exit 1
    }

    echo "### Creating CSR ###"
    openssl req -new -key /tmp/SPLUNK.key -out /tmp/Splunk.csr -subj "/C=DE/OU=$organizationalunit/CN=$commonname" || {
        echo "Failed to create certificate signing request"
        exit 1
    }

    echo "-----Below is your CSR-----"
    cat /tmp/Splunk.csr || echo "Failed to display CSR"
    sleep 2
}

# Funktion zur Konvertierung des Zertifikatsformats
convert_certificate_format() {
    read -p ".cer saved at /root/ ? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        openssl x509 -in /root/$commonname.cer -inform DER -out /root/$commonname.cer || {
            echo "Failed to convert certificate from DER to PEM format"
            exit 1
        }
        ls -l /root | grep .cer
    else
        convert_certificate_format
    fi
    sleep 2
}

# Funktion zur Erstellung der Konfiguration für Splunk Web-Certs
copy_cert_config() {
    echo "## Copy Web-Certs Configuration ##"
    if [ -f '/opt/splunk/etc/system/local/web.conf' ]; then
        echo "web.conf already exists!"
    else
        echo "# Make Web.conf #"
        touch /opt/splunk/etc/system/local/web.conf
        
        cat << EOF > /opt/splunk/etc/system/local/web.conf
[settings]
enableSplunkWebSSL = true
httpport = 8443
privKeyPath = /opt/splunk/etc/auth/mycert/SPLUNK.key
serverCert = /opt/splunk/etc/auth/mycert/$commonname.cer
EOF
    fi
}

# Hauptfunktion zur Zertifikatgenerierung
generate_web_cert() {
    get_password
    create_cert_request
    convert_certificate_format
    copy_cert_config
}

# Rufen Sie die Hauptfunktion zur Zertifikatgenerierung auf, wenn das Skript direkt ausgeführt wird
if [ "$0" = "$BASH_SOURCE" ]; then
    generate_web_cert
fi
