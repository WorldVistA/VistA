#!/bin/sh

#-------------------------------------------------------------
#
#  This script must be run by root or with sudo permissions.
#
#  It will setup the time zone of the system, and
#  will synchronize the clock with a NIST time server.
#
#-------------------------------------------------------------

#-------------------------------------------------------------
#
#  Select US Central as Time Zone
#
#-------------------------------------------------------------
echo "ZONE=\"US/Central\"" > /etc/sysconfig/clock
ln -sf /usr/share/zoneinfo/US/Central /etc/localtime


#-------------------------------------------------------------
#
#  Select US Eastern as Time Zone
#
#-------------------------------------------------------------
echo "ZONE=\"US/Eastern\"" > /etc/sysconfig/clock
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime


#-------------------------------------------------------------
#
#  Get the time from a time server
#
#-------------------------------------------------------------
rdate -s nist1-ny.ustiming.org


#-------------------------------------------------------------
#
#  Finally, reboot to get everything in order.
#
#-------------------------------------------------------------
shutdown -r now

