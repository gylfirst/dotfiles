#!/bin/bash
# /* ---- 💫 https://github.com/gylfirst 💫 ---- */  ##
# Script for Keyboard backlights (need to chown your brightness file)

iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000

# Get brightness
get_backlight() {
	cat /sys/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight/brightness
}

# Get icons
get_icon() {
	bl=$(get_backlight)
	current=$((bl*100/3))
	if   [ "$current" -le "20" ]; then
		icon="$iDIR/brightness-20.png"
	elif [ "$current" -le "40" ]; then
		icon="$iDIR/brightness-40.png"
	elif [ "$current" -le "80" ]; then
		icon="$iDIR/brightness-80.png"
	else
		icon="$iDIR/brightness-100.png"
	fi
}

# Notify
notify_user() {
	get_icon
	notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -u low -i "$icon" "Keyboard brightness : $current%"
}

# Change brightness
change_backlight() {
	kb_bl=$(get_backlight)
	if [ "$kb_bl" = "0" ]; then 
		echo 1 > /sys/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight/brightness && notify_user
	elif [ "$kb_bl" = "1" ]; then
		echo 2 > /sys/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight/brightness && notify_user
	elif [ "$kb_bl" = "2" ]; then
		echo 3 > /sys/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight/brightness && notify_user
	else
		echo 0 > /sys/devices/platform/asus-nb-wmi/leds/asus::kbd_backlight/brightness && notify_user
	fi
}

# Execute accordingly
case "$1" in
	"--get")
		get_backlight
		;;
	"--inc")
		change_backlight
		;;
	*)
		get_backlight
		;;
esac
