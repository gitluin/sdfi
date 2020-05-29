#!/bin/sh

INTERFACE="wlp2s0"

# Pass the network and the PSK, properly cased
Add () {
	TMPFILE=~/.sdfi_tmpadd.txt
	# Convert the SSID to a filename
	FNAME="/etc/wpa_supplicant/$(echo $1 | sed 's/ /_/').conf"
	FNAME="$(echo $FNAME | tr '[:upper:]' '[:lower:]')"

	echo "ctrl_interface=/run/wpa_supplicant" > "$TMPFILE"
	echo "update_config=1" >> "$TMPFILE"
	echo >> "$TMPFILE"
	echo "network={" >> "$TMPFILE"
	echo "	ssid=\"$1\"" >> "$TMPFILE"
	echo "	psk=\"$2\"" >> "$TMPFILE"
	echo "}" >> "$TMPFILE"

	sudo cp $TMPFILE $FNAME
	rm $TMPFILE
}

# Pass the network as an argument - all lowercase, per the config file
Connect () {
	test -z "$1" && exit 0
	echo "Starting new connection to $1"
	sudo wpa_supplicant -B -i "$INTERFACE" -c "/etc/wpa_supplicant/$1.conf"
	sleep 5
	sudo dhcpcd
}

# Pass seconds to sleep and message to print
Disconnect () {
	sudo pkill wpa_supplicant
	sudo pkill dhcpcd
	sleep "$1"
	echo "Successfully disconnected"
}

Usage () {
	echo "Usage: sdfi [Action] [network name] [psk]"
	echo
	echo "Actions:"
	echo "  If no actions are provided, connect to the provided network."
	echo "  -c, --connect is here for completeness."
	echo
	echo "  -h, --help		Show this help."
	echo "  -a, --add		Add a network with passcode psk."
	echo "  -c, --connect		Connect to new network. Provide name in lowercase, spaces as underscores."
	echo "  -d, --disconnect	Disconnect from current network."
	echo "  -r, --reconnect	Disconnect from current network, connect to new network." # tabs >:(
}

case "$1" in
	-h | --help)
		Usage
		exit -1
		;;
	-a | --add)
		Add $2 $3
		exit 1
		;;
	-c | --connect)
		NETWORK="$2"
		test -z "$NETWORK" || Connect "$NETWORK"
		break
		;;
	-d | --disconnect)
		Disconnect 1
		break
		;;
	-r | --reconnect)
		Disconnect 3
		NETWORK="$2"
		Connect "$NETWORK"
		;;
	*)

	test -z "$NETWORK" && NETWORK="$1"
	test -z "$NETWORK" || Connect "$NETWORK"
esac

/usr/local/bin/sbar_network.sh
