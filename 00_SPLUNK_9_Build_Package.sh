#!/bin/bash


######################################
## STAND: 19/10/22
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
colormsg "### SPLUNK Build Pack    ###"
colormsg "############################"
colormsg "############################"
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


syno=9.99.64.7



colormsg "### Splunk Build Package ###"


######################################################################################
##################################### Test Syno ######################################
######################################################################################

TestSyno(){

    colormsg "### Test Syno Connection ###"

    ping -c 3 $syno
    echo
    start

}

######################################################################################
##################################### Build Package ##################################
######################################################################################

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
    echo
        colormsg "Pack download done "
    echo
    echo    
        start
    echo
    ;;
    esac
    done

}




start(){

    syno=9.99.64.7

    organizationalunit=GMN02

    PS3="Was soll gemacht werden? : "
    select auswahl in TestSyno BuildPackage End
    do
        case "$auswahl" in
            End)    echo "End"; exit ;;
            "")     echo "Ungültige Auswahl"; start ;;
            *)      echo "Sie haben $auswahl gewählt" &&\
                    echo
                    $auswahl
                    echo
                    ;;
        esac
    done
}

start