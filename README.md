Some Dumb wiFI tool
=====
What Is, Why Do
-------
`sdfi` is a tool I wrote because `NetworkManager` went berserk when I tried to use it once. This is just a simple wrapper for `wpa_supplicant` and `dhcpcd`.

Features
-----
* Create a wpa_supplicant .conf file with an SSID and PSK.
* Connect to an added network.
* Disconnect from the current network.
* Connect to a different network.

Installation and Usage
-----
* Clone this repository: `git clone https://github.com/gitluin/sdfi.git`.
* Copy or link `sdfi.sh` in `/usr/local/bin/`.
* Copy or link `sdfi_comp` in `/etc/bash_completion.d/` for `bash` tab completion.
* Use `sdfi.sh` at the shell prompt!
* Have sudo rights without password confirmation for speedier usage, or be okay with typing your password a few times.
* If you don't use any of my other software like `sbar`, remove the `sbar_network.sh` call at the end of `sdfi.sh`.

Recent Statii
------
* v1.0 - Initial version. Can ask for help, add a network, connect to an added network, disconnect from the current network, and connect to a different network.

To Do
----
 * Tab completion for Actions.

Please submit bug reports/feature requests if you have a similar use situation with `wpa_supplicant` and `dhcpcd`!
