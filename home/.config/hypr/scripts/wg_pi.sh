#!/bin/bash

# Get the connection state of the 'pi' connection
connection_state=$(nmcli -f GENERAL.STATE -t connection show pi 2>/dev/null)

# Check if the connection is active
if [[ "$connection_state" == "GENERAL.STATE:activated" ]]; then
    nmcli connection down pi
    notify-send "VPN Disconnected" "The Raspberry Pi VPN connection has been disconnected."
else
    nmcli connection up pi
    notify-send "VPN Connected" "The Raspberry Pi VPN connection has been established."
fi
