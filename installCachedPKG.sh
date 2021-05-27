#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	installCachedPKG.sh
#
# SYNOPSIS
#	sudo installCachedPKG.sh
#
# DESCRIPTION
#	This script installed a cached package via the defined path
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on May, 27, 2021
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE

cachepolicy=$4
pkgpath=$5

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

#Verify package exists
if [[ -f "$pkgpath" ]]; then
    echo "PKG exists, continuing installation"
else
	echo "PKG does not exist, attempting to cache PKG."
    /usr/local/jamf/bin/jamf policy -trigger $cachepolicy
fi

#Install PKG
installer -pkg "$pkgpath" -target /

exit=0