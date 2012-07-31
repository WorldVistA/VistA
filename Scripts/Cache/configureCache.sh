#!/bin/bash
#
#  Configuring network services for Intersystems Cache.
#
#  You MUST use "sudo" to execute this script.
#

#
# Open the port needed for Web interface.
#
sudo iptables -A INPUT -p tcp --dport 57772 -j ACCEPT

#
# Open the port needed for TCP connection.
#
sudo iptables -A INPUT -p tcp --dport 1972  -j ACCEPT
