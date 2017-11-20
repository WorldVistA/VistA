#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2017 The Open Source Electronic Health Record Agent
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

# Modify the system firewall to allow needed ports
# System Management Portal
firewall-cmd --zone=public --add-port=57772/tcp --permanent

# SuperServer
firewall-cmd --zone=public --add-port=1972/tcp --permanent

# reload config
firewall-cmd --reload
