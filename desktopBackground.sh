#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	desktopBackground.sh
#
# SYNOPSIS
#	sudo desktopBackground.sh
#
# DESCRIPTION
#	This script sets the background for the current logged in user using Desktoppr 0.2 if the background has not been modified by the user.
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Feb, 18, 2020
#   - Edited by Matt Ehlers on Feb, 20, 2020 (Added function to only change desktop if desktop background has not been modified.)
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE

currentDesktop=`sudo -u $3 /usr/local/bin/desktoppr`

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

# Call background image policy (Will run if not already complete)
jamf policy -trigger background

# Changes to default GCC background if current background is in the default macOS or GCC background folder.
if [[ "$currentDesktop" == *"/private/var/GCC/Enviro/"* ]] || [[ "$currentDesktop" == *"/Library/Desktop Pictures/"* ]] || [[ "$currentDesktop" == *"/System/Library/CoreServices/"* ]]
then
echo "Logged in user using a default background, changing to GCC default..."
sudo -u $3 /usr/local/bin/desktoppr "/private/var/GCC/Enviro/background.png"
else
echo "Logged in user using custom background, will not overwrite. Now exiting..."
fi

exit=0