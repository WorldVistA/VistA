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

cd "${BASH_SOURCE%/*}/.." &&
Scripts/GitSetup/setup-user && echo &&
Scripts/GitSetup/setup-hooks && echo &&
Scripts/GitSetup/SetupGitAliases.sh && echo &&
(Scripts/GitSetup/setup-gerrit ||
 echo 'Failed to setup Gerrit.  Run this again to retry.') && echo &&
Scripts/GitSetup/tips

# Rebase master by default
git config rebase.stat true
git config branch.master.rebase true
