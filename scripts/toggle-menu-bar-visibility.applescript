#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Menu Bar Visibility
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description If menubar is visible, hide it and vice versa.
# @raycast.author protrial
# @raycast.authorURL https://raycast.com/protrial

tell application "System Events"
	tell dock preferences to set autohide menu bar to not autohide menu bar
end tell