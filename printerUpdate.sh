#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	printerUpdate.sh
#
# SYNOPSIS
#	sudo printerUpdate.sh
#
# DESCRIPTION
#	This script uses the jamf classic API to PUT update printer data
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Nov, 09, 2020
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
apiUsername="APIUSERHERE"
apiPassword="APIPASSWORDHERE"
jssServer="JSSSERVERHERE"
file="path/to/printers.csv"


####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

#Verify file is readable
data=`cat $file`
if [[ "$data" == "" ]]; then
    echo "Unable to read the file path specified"
    echo "Ensure there are no spaces and that the path is correct"
    exit 1
fi

#Find how many printers to import
printerqty=`awk -F, 'END {printf "%s\n", NR}' $file`
echo "Printerqty= " $printerqty
#Set a counter for the loop
counter="0"

duplicates=[]

id=$((id+1))

#Loop through the CSV and submit data to the API
while [ $counter -lt $printerqty ]
do
    counter=$[$counter+1]
    line=`echo "$data" | head -n $counter | tail -n 1`
    jamfID=`echo "$line" | awk -F , '{print $1}'`
    printerName=`echo "$line" | awk -F , '{print $2}'`
    deviceURI=`echo "$line" | awk -F , '{print $3}'`
    cupsName=`echo "$line" | awk -F , '{print $4}'`

    echo "Attempting to update printer data for printer ID $id"

    echo $id " " $printerName " " $deviceURI " " $cupsName
    apiData="<printer><name>$printerName</name><uri>$deviceURI</uri><CUPS_name>$cupsName</CUPS_name></printer>"
    output=`curl -sS -k -i -u ${apiUsername}:${apiPassword} -X PUT -H "Content-Type: text/xml" -d "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>$apiData" ${jssServer}/JSSResource/printers/id/$jamfID`

    echo $output
    #Error Checking
    error=""
    error=`echo $output | grep "Conflict"`
    if [[ $error != "" ]]; then
        duplicates+=($serialnumber)
    fi
    #Increment the ID variable for the next user
    id=$((id+1))
done

echo "The following computers could not be created:"
printf -- '%s\n' "${duplicates[@]}"

exit 0


exit=0