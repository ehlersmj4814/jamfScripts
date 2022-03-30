#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	copyOzoneDirectory.sh
#
# SYNOPSIS
#	sudo copyOzoneDirectory.sh
#
# DESCRIPTION
#	This script Copies the Ozone Directory files to users "~/Documents/iZotope/Ozone 9/” Folder upon first login
#
####################################################################################################
#
# HISTORY
#
#	Version: 2.0
#
#	- Created by Matt Ehlers on Jul, 28, 2020
#   - Updated by Matt Ehlers on Aug, 11, 2021 (added plist)
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
pathToDir="/Users/Shared/iZotope"
pathToPlist="/Users/Shared/Ozone9Plist/com.izotope.audioapp.OZONE9APP.plist"

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

cp -R "$pathToDir" "/Users/$3/Documents/"

chown -R $3 "/Users/$3/Documents/iZotope"

cp "$pathToPlist" "/Users/$3/Library/Preferences"

chown $3 "/Users/$3/Library/Preferences/com.izotope.audioapp.OZONE9APP.plist"


exit=0