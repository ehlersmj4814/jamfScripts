#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	mousePrefs.sh
#
# SYNOPSIS
#	sudo mousePrefs.sh
#
#
# DESCRIPTION
#	This script sets the default mouse values to: 
#		enable secondary click, disable natural scrolling
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Jan, 24, 2020
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

# For template Users.
#for i in `ls -1 "/System/Library/User Template"`; do
defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleHIDMouse" Button2 -int 2
defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse" MouseButtonMode -string TwoButton
defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad" TrackpadRightClick -int 1
defaults write -g "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.swipescrolldirection" 0
#done

#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleHIDMouse" Button1 -integer 1
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleHIDMouse" Button2 -integer 2
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleHIDMouse" Button3 -integer 3
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleHIDMouse" ButtonDominance -integer 1

#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse" Button1 -integer 1
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse" Button2 -integer 2
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse" Button3 -integer 3
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse" ButtonDominance -integer 1

#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad" Button1 -integer 1
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad" Button2 -integer 2
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad" Button3 -integer 3
#defaults write "/System/Library/User Template/Non_localized/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad" ButtonDominance -integer 1

# For Exisiting Users.
for i in `ls -1 "/Users"`; do
defaults write "/Users/${i}/Library/Preferences/com.apple.driver.AppleHIDMouse" Button2 -int 2
defaults write "/Users/${i}/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.mouse" MouseButtonMode -string TwoButton
defaults write "/Users/${i}/Library/Preferences/com.apple.driver.AppleBluetoothMultitouch.trackpad" TrackpadRightClick -int 1
defaults write -g "/Users/${i}/Library/Preferences/com.apple.swipescrolldirection" 0
done

#Global Preference Domain.
defaults write -g com.apple.swipescrolldirection 0

exit=0