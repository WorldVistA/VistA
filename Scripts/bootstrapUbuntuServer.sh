#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2012 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update the server from repositories
# TODO: kill output
# TODO: log status
# TODO: determine if this needs to be logged
apt-get -y update
apt-get -y upgrade

# Install baseline packages
# TODO: detect virtualbox and install additions?
apt-get install -y git xinetd

# Create the user.
useradd $1

# Change the user's password.
passwd $1

# Add the user to the list of sudoers
echo "$1  ALL=(ALL)   ALL" > /etc/sudoers.d/customsudoers
chmod 0440 /etc/sudoers.d/customsudoers
