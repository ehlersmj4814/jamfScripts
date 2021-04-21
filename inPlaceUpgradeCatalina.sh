#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	inPlaceUpgradeCatalina.sh
#
# SYNOPSIS
#	sudo inPlaceUpgradeCatalina.sh
#
# DESCRIPTION
#	This script Checks for AC Power, 15G Disk Space, and calls Cached Catalina Installer.
#
####################################################################################################
#
# HISTORY
#
#	Version: 2.0
#
#	- Created by Matt Ehlers on Mar, 10, 2020
#	- Version 2.0 Updates provided by Trey Gonzales
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE
selfService=$(pgrep "Self Service")
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

#Create LaunchDaemon for script to run after reboot
cat >/Library/LaunchDaemons/com.jamf.catrecon.plist<< EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.jamf.catrecon</string>

  <key>ProgramArguments</key>
  <array>
    <string>/var/GCC/jamfScripts/recon.sh</string>
  </array>

  <key>Nice</key>
  <integer>1</integer>

  <key>RunAtLoad</key>
  <true/>

  <key>StandardErrorPath</key>
  <string>/tmp/recon.err</string>

  <key>StandardOutPath</key>
  <string>/tmp/recon.out</string>
</dict>
</plist>
EOF

#Script to run recon, NoMAD, and .AppleSetupDone
cat >/var/GCC/jamfScripts/recon.sh<< EOF
sudo /usr/local/bin/jamf recon
sudo touch /var/db/.AppleSetupDone
sudo /usr/local/bin/jamf policy -trigger nomad
touch /tmp/recond.txt
sudo rm -f /Library/LaunchDaemons/com.jamf.catrecon.plist
sudo launchctl unload /Library/LaunchDaemons/com.jamf.catrecon.plist
EOF
chmod +x /var/GCC/jamfScripts/recon.sh
launchctl load /Library/LaunchDaemons/com.jamf.catrecon.plist

#Start Installation
"$installPath" --agreetolicense --pidtosignal "$selfService"

exit 0        ## Success
exit 1        ## Failure