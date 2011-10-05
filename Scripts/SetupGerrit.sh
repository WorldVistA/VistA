#!/usr/bin/env bash
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

# Run this script to set up the git repository to push to the Gerrit code review
# system.
die() {
  echo 'Failure during Gerrit setup.' 1>&2
  echo '----------------------------' 1>&2
  echo '' 1>&2
  echo "$@" 1>&2
  exit 1
}

# Centralize project variables for each script
project="OSEHRA-Automated-Testing"

gerrit_user() {
  read -ep "Enter your gerrit user (set in Gerrit Settings/Profile) [$USER]: " gu
  if [ "$gu" == "" ]; then
   # Use current user name.
   gu=$USER
  fi
  echo -e "\nConfiguring 'gerrit' remote with user '$gu'..."
  if git config remote.gerrit.url >/dev/null; then
    # Correct the remote url
    git remote set-url gerrit $gu@review.code.osehra.org:${project} || \
      die "Could not amend gerrit remote."
  else
    # Add a new one
    git remote add gerrit $gu@review.code.osehra.org:${project} || \
      die "Could not add gerrit remote."
  fi
}

# Make sure we are inside the repository.
cd "$(echo "$0"|sed 's/[^/]*$//')"

if git config remote.gerrit.url >/dev/null; then
  echo "Gerrit was already configured. The configured remote URL is:"
  echo
  git config remote.gerrit.url
  echo
  read -ep "Is the username correct? [Y/n]: " correct
  if [ "$correct" == "n" ] || [ "$correct" == "N" ]; then
    gerrit_user
  fi
else
  cat << EOF
Gerrit is a code review system that works with Git.

In order to use Gerrit, an account must be registered at the review site:

  http://review.code.osehra.org/p/${project}

In order to register you need an OpenID

  http://openid.net/get-an-openid/

EOF
  gerrit_user
fi

read -ep "Would you like to verify authentication to Gerrit? [y/N]: " ans
if [ "$ans" == "y" ] || [ "$ans" == "Y" ]; then
  echo
  echo "Fetching from gerrit to test SSH key configuration (Settings/SSH Public Keys)"
  git fetch gerrit ||
    die "Could not fetch gerrit remote. You need to upload your public SSH key to Gerrit."
  echo "Done."
fi
