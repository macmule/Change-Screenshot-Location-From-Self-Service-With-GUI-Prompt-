#!/bin/sh
####################################################################################################
#
# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognise copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org/>
#
####################################################################################################
#
# More information: http://macmule.com/2013/07/13/change-screenshot-location-from-self-service-with-gui-prompt/
#
# GitRepo: https://github.com/macmule/Change-Screenshot-Location-From-Self-Service-With-GUI-Prompt
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

# Exit
exit 0