#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	mobileDeviceRename.sh
#
# SYNOPSIS
#	sudo mobileDeviceRename.sh
#
# DESCRIPTION
#	This script uses Jamf Pro Classic API to determine list of Mobile Devices needing rename, then renames devices according to Google Sheet data
#
####################################################################################################
#
# HISTORY
#
#	Version: 2.0
#
#	- Created by Matt Ehlers on Mar, 29, 2022
#  - Updated by Matt Ehlers on Aug 11, 2022
#     Added API Bearer Token
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
exitCode=0
api_token=""
token_expiration=""
jamfURL="<JAMF PRO URL HERE>"
apiUser="<API USER HERE>"
apiPass="<API PASS HERE>"
csvPath=/tmp/devicenames.csv
url="<GSHEET URL HERE>"

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

###API BEARER TOKEN
GetJamfProAPIToken() {


# This function uses Basic Authentication to get a new bearer token for API authentication.

# Create base64-encoded credentials from user account's username and password.

encodedCredentials=$(printf "${apiUser}:${apiPass}" | /usr/bin/iconv -t ISO-8859-1 | /usr/bin/base64 -i -)
		
# Use the encoded credentials with Basic Authorization to request a bearer token

authToken=$(/usr/bin/curl "${jamfURL}/api/v1/auth/token" --silent --request POST --header "Authorization: Basic ${encodedCredentials}")
	
# Parse the returned output for the bearer token and store the bearer token as a variable.

if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
   api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$authToken" | /usr/bin/xargs)
else
   api_token=$(/usr/bin/plutil -extract token raw -o - - <<< "$authToken")
fi

}

APITokenValidCheck() {

# Verify that API authentication is using a valid token by running an API command
# which displays the authorization details associated with the current API user. 
# The API call will only return the HTTP status code.

api_authentication_check=$(/usr/bin/curl --write-out %{http_code} --silent --output /dev/null "${jamfURL}/api/v1/auth" --request GET --header "Authorization: Bearer ${api_token}")

}

CheckAndRenewAPIToken() {

# Verify that API authentication is using a valid token by running an API command
# which displays the authorization details associated with the current API user. 
# The API call will only return the HTTP status code.

APITokenValidCheck

# If the api_authentication_check has a value of 200, that means that the current
# bearer token is valid and can be used to authenticate an API call.


if [[ ${api_authentication_check} == 200 ]]; then

# If the current bearer token is valid, it is used to connect to the keep-alive endpoint. This will
# trigger the issuing of a new bearer token and the invalidation of the previous one.
#
# The output is parsed for the bearer token and the bearer token is stored as a variable.

      authToken=$(/usr/bin/curl "${jamfURL}/api/v1/auth/keep-alive" --silent --request POST --header "Authorization: Bearer ${api_token}")
      if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
         api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$authToken" | /usr/bin/xargs)
      else
         api_token=$(/usr/bin/plutil -extract token raw -o - - <<< "$authToken")
      fi
else

# If the current bearer token is not valid, this will trigger the issuing of a new bearer token
# using Basic Authentication.

   GetJamfProAPIToken
fi
}

InvalidateToken() {

# Verify that API authentication is using a valid token by running an API command
# which displays the authorization details associated with the current API user. 
# The API call will only return the HTTP status code.

APITokenValidCheck

# If the api_authentication_check has a value of 200, that means that the current
# bearer token is valid and can be used to authenticate an API call.

if [[ ${api_authentication_check} == 200 ]]; then

# If the current bearer token is valid, an API call is sent to invalidate the token.

      authToken=$(/usr/bin/curl "${jamfURL}/api/v1/auth/invalidate-token" --silent  --header "Authorization: Bearer ${api_token}" -X POST)
      
# Explicitly set value for the api_token variable to null.

      api_token=""

fi
}

GetJamfProAPIToken

APITokenValidCheck

echo "$api_authentication_check"

echo "$api_token"

CheckAndRenewAPIToken

APITokenValidCheck

echo "$api_authentication_check"

echo "$api_token"
###END API BEARER TOKEN

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
serialNumbers=$(/usr/bin/curl -X GET "${jamfURL}/JSSResource/mobiledevicegroups/id/60" -H "accept: application/xml" -H "Authorization: Bearer ${api_token}" | xmllint --format - | awk -F'>|<' '/serial_number/{print $3}')
echo $serialNumbers

if [[ -z "$serialNumbers" ]]; then
    echo "No devices in the Jamf Rename Smart Group"
else
    while IFS= read -r sn; do
        deviceName=`(cat $csvPath | grep -i "$sn" | awk -F',' '{print $2}')`
        assetTag=`(cat $csvPath | grep -i "$sn" | awk -F',' '{print $3}')`
        if [[ -z "$deviceName" ]]; then
            echo "No device name set in Asset Sheet"
        else
            echo "Setting" $sn "to" $deviceName "with asset" $assetTag
           /usr/bin/curl -X PUT "$jamfURL/JSSResource/mobiledevices/serialnumber/"$sn"" -H "content-type: text/xml" -H "Authorization: Bearer ${api_token}" -d "<mobile_device><general><device_name>$deviceName</device_name><asset_tag>$assetTag</asset_tag></general></mobile_device>"
        fi
    done <<< "$serialNumbers"
fi

InvalidateToken

APITokenValidCheck

echo "$api_authentication_check"

echo "$api_token"

exit=0