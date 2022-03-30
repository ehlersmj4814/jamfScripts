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
jamfAPIURL=""
apiUser=""
apiPass=""

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

#API GET list of devices from smart group


#Check list of devices against Google Sheet


#API POST device name based on serial number



exit=0