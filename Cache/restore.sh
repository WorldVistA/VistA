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

# Restore latest backup from directory
# This utility requires root privliges

# Process flow:
# 1. Stop cache
# 2. Copy /opt/backup/CACHE-%m%d%Y.DAT to /opt/cachesys/VISTA/CACHE.DAT
# 3. Start cache

# Stop cache
service stop cache

# Copy file
# see if files exist
# Copy existing just to be safe
cp /opt/cachesys/VISTA/CACHE.DAT /opt/backup/CACHE-`date +%m%d%Y`.DAT
# find previous version (not the one just backed up)
cp /opt/cachesys/VISTA/CACHE.DAT

# Start cache
service start cache
