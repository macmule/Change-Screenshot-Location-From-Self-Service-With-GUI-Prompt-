#!/bin/bash
####################################################################################################
#
# More information: http://macmule.com/2013/07/13/change-screenshot-location-from-self-service-with-gui-prompt/
#
# GitRepo: https://github.com/macmule/Change-Screenshot-Location-From-Self-Service-With-GUI-Prompt
#
# License: http://macmule.com/license/
#
###################################################################################################
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################


###
# Get the Username of the logged in user
###
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

###
# Prompt the user for the location of the folder that they wish screen shots to be created in
###
folderPath=$(osascript -e 'try
tell application "SystemUIServer"
   choose folder with prompt "Which folder would like screenshots to go to? (the default location is your Desktop)"
  set folderPath to POSIX path of result
end
end')

# Echo chosen location
echo "User has chosen $folderPath..."

# Update User plist
defaults write /Users/"$loggedInUser"/Library/Preferences/com.apple.screencapture location "$folderPath"

# As we're root, amend ownership back to set for plist
chown "$loggedInUser" /Users/"$loggedInUser"/Library/Preferences/com.apple.screencapture.plist

# Restart SystemUIServer for changes to take affect
killall SystemUIServer

exit 0
