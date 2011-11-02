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

egrep-q() {
  egrep "$@" >/dev/null 2>/dev/null
}

die() {
  echo 'failure during hook setup' 1>&2
  echo '-------------------------' 1>&2
  echo '' 1>&2
  echo "$@" 1>&2
  exit 1
}

u=$(cd "$(echo "$0"|sed 's/[^/]*$//')"; pwd)
cd "$u/../.git/hooks"

# We need to have a git repository to do a fetch.
if ! test -d ./.git; then
  git init -q || die "Could not run git init."
fi

# Fetch the hooks.  Use the local hooks branch if possible.
if GIT_DIR=.. git for-each-ref refs/remotes/origin/hooks 2>/dev/null | \
  egrep-q 'refs/remotes/origin/hooks$'; then
  git fetch -q .. remotes/origin/hooks
else
  git fetch -q http://code.osehra.org/OSEHRA-Automated-Testing.git hooks
fi &&
git reset -q --hard FETCH_HEAD || die "Failed to install hooks"
cd ../..
