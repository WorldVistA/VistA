#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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
foreach(package
  Borland_DXE8
  #VA2007
  ORCtrls_DXE8
  #ORDateLib2007
  )
  add_delphi_package(${package})
endforeach()

add_dependencies(ORCtrls_DXE8 VAShared_RXE8)
#add_dependencies(ORDateLib2007 ORCtrlLibXE3 XWB_RXE3)
