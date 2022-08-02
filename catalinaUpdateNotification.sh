#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	catalinaUpdateNotification.sh
#
# SYNOPSIS
#	sudo catalinaUpdateNotification.sh
#
# DESCRIPTION
#	This script utilitizes the jamfhelper to notify users of SS policy available to install macOS Catalina 10.15.3
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Mar, 03, 2020
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE


####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
title="GCC OIT Notification"
head="macOS Catalina Update Available in Self Service"
desc="OIT has made macOS Catalina available to install in Self Service. 
You will have until April 24, 2020 to update on your own time. 
After this, your mac will be updated automatically."
response= /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -windowPosition ur -title "$title" -heading "$head" -description "$desc" -icon /Applications/Install\ macOS\ Catalina.app/Contents/Resources/InstallAssistant.icns -button1 "Update" -button2 "Exit" -defaultButton 2 -cancelButton 2 -alignDescription left

if [[ $response -eq "0" ]];then
	open "jamfselfservice://content?entity=policy&id=6009&action=view"
fi

exit=0