#!/bin/sh

#-------------------------------------------------------------
#
#  This script must be run by root or with sudo permissions.
#
#  It starts the minimal setup to configure the RHEL server.
#
#  It expects as argument the name of the user account
#  to be created.
#
#-------------------------------------------------------------

#-------------------------------------------------------------
#
# Install Git, so that we can bring up the rest of scripts
#
#-------------------------------------------------------------
yum install git


#-------------------------------------------------------------
#
# Create the user.
#
#-------------------------------------------------------------
useradd $1


#-------------------------------------------------------------
#
# Change the user's password.
#
#-------------------------------------------------------------
passwd $1


#-------------------------------------------------------------
#
# Add the user to the list of sudoers
#
#-------------------------------------------------------------
echo "$1  ALL=(ALL)   ALL" > /etc/sudoers.d/customsudoers

