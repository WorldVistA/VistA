#!/bin/sh

#-------------------------------------------------------------
#
#  This script must be run by root or with sudo permissions.
#
#  It will setup the local date and time of the server.
#
#  It must be called with two arguments : Data and Time
#  with the following formats:
#
#                     YYYY-MM-DD HH:MM:SS
#
#-------------------------------------------------------------

#-------------------------------------------------------------
#
#  Change Date:   date +%D -s YYYY-MM-DD
#
#-------------------------------------------------------------
date +%D -s $1

#-------------------------------------------------------------
#
#  Change Time:   date +%T -s HH:MM:SS
#
#-------------------------------------------------------------
date +%T -s $2

