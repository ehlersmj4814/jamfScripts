#!/bin/zsh
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	mobileDeviceRename.zsh
#
# SYNOPSIS
#	sudo mobileDeviceRename.zsh
#
# DESCRIPTION
#	This script uses Jamf Pro Classic API to determine list of Mobile Devices needing rename, then renames devices according to Google Sheet data
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#   
#   !!!WORK IN PROGRESS!!!
#
#	- Created by Matt Ehlers on Mar, 29, 2022
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
jamfAPIURL="<JAMF URL HERE>"
apiUser="<API USERNAME HERE>"
apiPass="<API PW HERE>"
csvPath=/tmp/devicenames.csv
url="<GSHEET URL HERE>"

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

#Removes previous downloaded csv
if [ -e /tmp/devicenames.csv ]
then
	rm /tmp/devicenames.csv
  echo "Removed previous CSV file."
fi

#Downloads current version of csv
curl -L $url -o /tmp/devicenames.csv
echo "CSV Download Complete"

#API GET list of device SN's from smart group
serialNumbers=$(curl -su $apiUser:$apiPass -H "accept: text/xml" $jamfAPIURL/mobiledevicegroups/id/60 -X GET | xmllint --format - | awk -F'>|<' '/serial_number/{print $3}')

#Verify Device(s) in the Jamf Smart Group
if [[ -z "$serialNumbers" ]]; then
    echo "No devices in the Jamf Rename Smart Group"
else
    while IFS= read -r sn; do
        #Set Device Name and Asset Tag based off GSHEET values
        deviceName=`(cat $csvPath | grep -i "$sn" | awk -F',' '{print $2}')`
        assetTag=`(cat $csvPath | grep -i "$sn" | awk -F',' '{print $3}')`
        #Verify device name(s) in GSHEET
        if [[ -z "$deviceName" ]]; then
            echo "No device name set in Asset Sheet"
        else
            #API PUT Device Name and Asset Tag based on Serial Number
            echo "Setting" $sn "to" $deviceName "with asset" $assetTag
            curl -su $apiUser:$apiPass -H "content-type: text/xml" $jamfAPIURL/mobiledevices/serialnumber/"$sn" -X PUT -d "<mobile_device><general><device_name>$deviceName</device_name><asset_tag>$assetTag</asset_tag></general></mobile_device>"
        fi
    done <<< "$serialNumbers"
fi


exit=0