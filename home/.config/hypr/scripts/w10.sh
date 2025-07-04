#!/bin/bash

compose="$HOME/Documents/windows/docker-compose.yaml"
rem="$HOME/.local/share/remmina/group_rdp_w10up_localhost.remmina"

up_dock() {
	docker compose -f $compose up -d
}

connect() {
	#remmina -c $rem
	rdesktop -g 2880x1800 -P -z -x l -r sound:on -u gylfirst 127.0.0.1:3389
}

main() {
	up_dock
	sleep 5
	connect
}

main
