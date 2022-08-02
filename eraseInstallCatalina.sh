#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	eraseInstallCatalina.sh
#
# SYNOPSIS
#	sudo eraseInstallCatalina.sh
#
# DESCRIPTION
#	This script installs Catalina from DP, then runs eraseinstall command
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on May, 06, 2020
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
installPath="/Applications/Install macOS Catalina.app/Contents/Resources/startosinstall"

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

#Check if device is on battery or ac power
pwrAdapter=$( /usr/bin/pmset -g ps )
if [[ ${pwrAdapter} == *"AC Power"* ]]; then
    pwrStatus="OK"
    /bin/echo "Power Check: OK - AC Power Detected"
else
    pwrStatus="ERROR"
    /bin/echo "Power Check: ERROR - No AC Power Detected, exiting"
    exit 1
fi

#Check if free space > 15GB
#availableSpace=$(/usr/sbin/diskutil info / | grep "Volume Free Space:" | awk '{print $4}')
#if [ "$availableSpace" == "" ]; then
#	availableSpace=$(/usr/sbin/diskutil info / | grep "Volume Available Space:" | awk '{print $4}')
#   	if [ "$availableSpace" == "" ]; then
#    	availableSpace=$(/usr/sbin/diskutil info / | grep "Container Free Space:" | awk '{print $4}')
#    fi
#fi
#availableSpaceInt=$(/bin/echo $availableSpace | awk '{print int($1)}')
#
#if [ "$availableSpaceInt" -lt "15" ]; then
#    echo "Disk Check: ERROR - $availableSpaceInt GB available, exiting"
#    exit 1
#else
#    echo "Disk Check: OK - $availableSpaceInt GB available."
#fi

#Verify Installer is Cached, if not start cache policy
if [ -f "$installPath" ]; then
    echo "Installer Check: OK - $installPath exists"
else 
    echo "Installer Check: ERROR - $installPath does not exist, running policy"
    /usr/local/bin/jamf policy -trigger cachecatalina
fi

#Start EraseInstall
"$installPath" --eraseinstall --agreetolicense --forcequitapps --newvolumename 'Mac'

exit=0