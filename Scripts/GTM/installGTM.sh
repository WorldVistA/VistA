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

# Install GT.M using gtminstall script
# This utility requires root privliges

# Required utilities:
# TODO: add these to bootstrap scripts, doesn't hurt if utilities are already
#       installed
# wget
# sha1sum

# Make sure we are root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Download gtminstall script from SourceForge
# TODO: kill output
# TODO: log status
# TODO; determine if this needs to be logged
wget -c --trust-server-names=on http://downloads.sourceforge.net/project/fis-gtm/GT.M%20Installer/v0.12/gtminstall

# Verify hash as we are going to make it executable
# TODO: get hash and compare
# sha1sum gtminstall

# Make it executable
chmod +x gtminstall

# Create a group for gtm users
groupadd gtm

# Accept most defaults for gtminstall
# --group=gtm - override default to use gtm group
# --ucaseonly-utils - override default to install only uppercase utilities
#                     this follows VistA convention of uppercase only routines
./gtminstall --group=gtm --ucaseonly-utils

# remove installgtm script as it is unnecessary
rm ./gtminstall
