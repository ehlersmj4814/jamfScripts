#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	nomadSecureToken.sh
#
# SYNOPSIS
#	sudo nomadSecureToken.sh
#
# DESCRIPTION
#	This script creates the _nomadlogin user and enables it for secureToken using encrypted credential pass
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Matt Ehlers on Aug, 31, 2021
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################

# HARDCODED VALUES SET HERE

#Admin User Encrypted String passed via jamf script $4 parameter
adminEncryptedString="$4"
adminSalt="EnterSaltHere"
adminPassphrase="EnterPassphraseHere"

#Local User Encrypted String passed via jamf script $5 parameter
localEncryptedString="$5"
localSalt="EnterSaltHere"
localPassphrase="EnterPassphraseHere"


####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

function DecryptStringAdminPass() {
    # Usage: ~$ DecryptString "Encrypted String" "Salt" "Passphrase"
    echo "$adminEncryptedString" | /usr/bin/openssl enc -aes256 -d -a -A -S "$adminSalt" -k "$adminPassphrase"
}
function DecryptStringLocalPass() {
    # Usage: ~$ DecryptString "Encrypted String" "Salt" "Passphrase"
    echo "$localEncryptedString" | /usr/bin/openssl enc -aes256 -d -a -A -S "$localSalt" -k "$localPassphrase"
}

adminPass="$(DecryptStringAdminPass)"
localPass="$(DecryptStringLocalPass)"
echo $adminPass
echo $localPass
sysadminctl -addUser _nomadlogin -fullName "NoMAD Login" -UID 400 -password "$localPass" -picture /Library/Security/SecurityAgentPlugins/NoMADLoginAD.bundle/Contents/Resources/NoMADFDEIcon.png
sysadminctl -adminUser "alpha" -adminPassword "$adminPass" -secureTokenOn "_nomadlogin" -password "$localPass"

sysadminctl -secureTokenStatus _nomadlogin

exit=0