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

# Enable journaling for instance

# Ensure presence of required variables
if [[ -z $instance && $gtmver && $gtm_dist && $basedir ]]; then
    echo "The required variables are not set (instance, gtmver, gtm_dist)"
fi

$gtm_dist/mupip set -journal="enable,on,before,file=$basedir/j/$instance.mjl" -file $basedir/g/$instance.dat
