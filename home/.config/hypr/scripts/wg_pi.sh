#!/bin/bash

# Get the connection state of the 'pi' connection
connection_state=$(nmcli -f GENERAL.STATE -t connection show pi 2>/dev/null)

# Check if the connection is active
if [[ "$connection_state" == "GENERAL.STATE:activated" ]]; then
    nmcli connection down pi
else
    nmcli connection up pi
fi
