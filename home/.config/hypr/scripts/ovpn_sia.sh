#!/bin/bash

# Get the connection state of the 'pi' connection
connection_state=$(nmcli -f GENERAL.STATE -t connection show SIA 2>/dev/null)

# Check if the connection is active
if [[ "$connection_state" == "GENERAL.STATE:activated" ]]; then
    nmcli connection down SIA
    notify-send "VPN Disconnected" "The SIA VPN connection has been disconnected."
else
    nmcli connection up SIA
    notify-send "VPN Connected" "The SIA VPN connection has been established."
fi
