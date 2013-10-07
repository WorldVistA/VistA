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

# Perform a copy of a CACHE.DAT to another directory
# THIS SCRIPT IS NOT DESIGNED FOR PRODUCTION USAGE!
# THIS WILL BRING DOWN THE CACHE INSTANCE!
# This utility requires root privliges

# Process flow:
# 0. Ensure $1 & $2 arguments specified and valid
# 1. Stop Cache
# 2. Copy CACHE.DAT to directory
# 3. Start Cache

if [ ! -e $1 ]; then
    echo "Specified CACHE.DAT doesn't exist"
fi

if [ ! -d $2 ]; then
    echo "Specified backup directory doesn't exist"
fi

# Stop Cache
service cache stop

# Copy CACHE.DAT to directory
cp $1 $2/CACHE-`date +%m%d%Y`.DAT

# Start Cache
service cache start
