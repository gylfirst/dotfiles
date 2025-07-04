#!/bin/bash
# /* ---- 💫 https://github.com/gylfirst 💫 ---- */  ##
# Script for toggling the touchpad 

iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000
dev="asue140d:00-04f3:31b9-touchpad"
TOUCHPAD_file="$HOME/.config/hypr/scripts/touchpad_state"

state=$(cat $TOUCHPAD_file)

# Get icons
get_icon() {
	cur=$(cat $TOUCHPAD_file)
	if   [ "$cur" = "OFF" ]; then
		icon="$iDIR/touchpad_off.png"
	elif [ "$cur" = "ON" ]; then
		icon="$iDIR/touchpad_on.png"
	fi
}

# Notify
notify_user() {
	get_icon
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h string:value:$cur -u low -i "$icon" "Touchpad Switched $cur"
}

# Change brightness
change_touchpad() {
	if [ "$state" = "OFF" ]; then 
		echo ON > $TOUCHPAD_file
		hyprctl keyword "device["$dev"]:enabled" true && notify_user
	elif [ "$state" = "ON" ]; then
		echo OFF > $TOUCHPAD_file
		hyprctl keyword "device[$dev]:enabled" false && notify_user
	fi
}

# Execute accordingly
change_touchpad
