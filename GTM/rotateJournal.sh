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

# Rotate journal for instance

# TODO: accept journal file argument
# TODO: accept database location

# Source VistA environment variables
source /opt/FOIA/etc/env
instance="FOIA"
gtmver="V6.0-000_x86_64"
daystokeep="5"

# TODO: logging
find /opt/$instance/$gtmver/j/ -name "*.mjl_*" -type f -ctime +$daystokeep -exec rm -v {} \;
