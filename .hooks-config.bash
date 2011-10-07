#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
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

# Loaded by .git/hooks/(pre-commit|commit-msg|prepare-commit-msg)
# during git commit after Scripts/SetupForDevelopment.sh has run.

hooks_chain_pre_commit="Scripts/Git/pre-commit"
hooks_chain_commit_msg="Scripts/Git/commit-msg"
hooks_chain_prepare_commit_msg="Scripts/Git/prepare-commit-msg"
