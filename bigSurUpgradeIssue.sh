#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	bigSurUpgradeIssue.sh
#
# SYNOPSIS
#	sudo bigSurUpgradeIssue.sh
#
# DESCRIPTION
#	This script is to mitigate issues in-place upgrading to Big Sur, as detailed here: 
#   https://mrmacintosh.com/macos-upgrade-to-big-sur-failed-stuck-progress-bar-fix-prevention/
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Nov, 16, 2021
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

sudo find /private/var/folders/*/*/C/com.apple.mdworker.bundle -mindepth 1 -delete

sudo find /private/var/folders/*/*/C/com.apple.metadata.mdworker -mindepth 1 -delete


exit=0