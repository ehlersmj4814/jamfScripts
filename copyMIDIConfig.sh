#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	copyMIDIConfig.sh
#
# SYNOPSIS
#	sudo copyMIDIConfig.sh
#
# DESCRIPTION
#	This script Copies the MIDI configuration files to users "~/Library/Audio/MIDI Configration” Folder upon initial login
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Jul, 22, 2020
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
pathToConfig="/Users/Shared/Main Station MIDI Config/Main.mcfg"

####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

mkdir -p "/Users/$3/Library/Audio/MIDI Configurations"

cp "$pathToConfig" "/Users/$3/Library/Audio/MIDI Configurations"

exit=0