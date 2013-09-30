#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2013 The Open Source Electronic Health Record Agent
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

# extra utils - used for cmake and dashboards and initial clones
apt-get install build-essential cmake-curses-gui git

# Clone repos
mkdir ~/Development
cd ~/Development
git clone https://github.com/OSEHRA/VistA.git
git clone https://github.com/OSEHRA/VistA-M.git
git clone https://github.com/ChristopherEdwards/VistA-installation-scripts.git -b dev

# bootstrap the system
cd ~/Development/VistA-installation-scripts/Scripts/Install/
./Ubuntu/bootstrapUbuntuServer.sh

# Install GTM
cd GTM
./install.sh

# Create the VistA instance
./createVistaInstance.sh

# Import via ImportRG of the VistA repository
# These use the Dashboard scripts in the Dashboard directory
