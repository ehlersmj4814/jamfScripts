#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	persistantUpdateNotification.sh
#
# SYNOPSIS
#	sudo persistantUpdateNotification.sh
#
# DESCRIPTION
#	This script utilitizes the jamfhelper to notify users of SS policy available to install latest tested version of macOS
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Mar, 03, 2020
#
#   Version 1.1
#   
#   - Updated by Matt ehlers on Sep 23, 2021
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE

title="GCC OIT Notification"
head="macOS Big Sur Update Available in Self Service"
desc="GCC OIT has made macOS Big Sur available to install in Self Service. 
It is recommended that this update is started at the end of the day as it can take up to an hour to complete. Any devices not on macOS 11 Big Sur by April 1st will be automatically upgraded."

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

response=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -windowPosition ur -title "$title" -heading "$head" -description "$desc" -icon /Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/InstallAssistant.icns -button1 "Update" -button2 "Exit" -defaultButton 2 -cancelButton 2 -alignDescription left)

if [[ $response == "0" ]];then
    open "jamfselfservice://content?entity=policy&id=7154&action=view"
fi

exit=0