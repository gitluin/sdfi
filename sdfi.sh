#!/bin/sh

test -z "$INTERFACE" && INTERFACE="wlp2s0"

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
	sudo pkill -9 dhcpcd
	sleep "$1"
	echo "Successfully disconnected"
}

Usage () {
	echo "Usage: sdfi [Action] [network name] [psk]"
	echo "Simple interface to wpa_supplicant and dhcpcd."
	echo "Set \$INTERFACE to a default in this script, ~/.bashrc, or"
	echo "  somewhere else before using."
	echo "If no actions are provided, will connect to the provided,"
	echo "  pre-configured network."
	echo
	echo "Actions:"
	echo "  -h, --help		Show this help."
	echo "  -a, --add		Add a network with passcode psk."
	echo "  -c, --connect		Connect to new network. Provide name"
	echo "				  in lowercase, spaces as underscores."
	echo "  -d, --disconnect	Disconnect from current network."
	echo "  -r, --reconnect	Disconnect from current network, connect to"
	echo "				  new network." # tabs >:(
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
		test -z "$NETWORK" || Connect "$NETWORK"
		break
		;;
	*)
		Usage
		exit -1
esac

# For users of my sbar shell scripts
/usr/local/bin/sbar_network.sh
