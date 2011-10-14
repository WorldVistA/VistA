rem ---------------------------------------------------------------------------
rem Copyright 2011 The Open Source Electronic Health Record Agent
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.
rem ---------------------------------------------------------------------------
cd c:\Users\joe.snyder\Dashboards\AutomatedTesting\OSEHRA-Automated-Testing/DashboardScripts/kitware/
"C:\Program Files (x86)\Git\bin\git.exe" pull
"C:\Program Files (x86)\CMake 2.8\bin\ctest.exe" -S tuchanka.cmake -VV -O tuchanka.log