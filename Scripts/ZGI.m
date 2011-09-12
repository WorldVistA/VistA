ZGI ; Read Globals from ZWR format into InterSystems Cache
 ;---------------------------------------------------------------------------
 ; Copyright 2011 The Open Source Electronic Health Record Agent
 ;
 ; Licensed under the Apache License, Version 2.0 (the "License");
 ; you may not use this file except in compliance with the License.
 ; You may obtain a copy of the License at
 ;
 ;     http://www.apache.org/licenses/LICENSE-2.0
 ;
 ; Unless required by applicable law or agreed to in writing, software
 ; distributed under the License is distributed on an "AS IS" BASIS,
 ; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ; See the License for the specific language governing permissions and
 ; limitations under the License.
 ;---------------------------------------------------------------------------
 N  W "ZWR Global Input",! D IN^%IS Q:POP  W !
 I '$$LOAD(IO) Q 0
 U $P W "Loaded "_IO,!
 Q 1
LOAD(IO) ; Read Globals from IO device in ZWR format
 N Q,S S Q=1
 C IO O IO:("R"):0 I '$T W "Failed to open: "_IO,! Q 0
 I '($$READLINE(.H1)&$$READLINE(.H2)&(H2["ZWR")) U $P W "Not a ZWR: "_IO,! S Q=0 G QUIT
 F  Q:'$$READLINE(.S)  S @S
 G QUIT
LIST(IO,DIR) ; Read list from IO, load Globals from each DIR<entry> device
 N Q,ZWR S Q=1
 C IO O IO:("R"):0 I '$T W "Failed to open: "_IO,! Q 0
 F  Q:'$$READLINE(.ZWR)  U $P W DIR_ZWR,! I '$$LOAD(DIR_ZWR) S Q=0
 G QUIT
READLINE(LINE)
 N $ES,$ET,EOF S $ET="G ETRAP",EOF=0
 D READLN(.LINE)
 Q '(($ZEOF=-1)!EOF)
READLN(LINE)
 S LINE=""
 U IO R LINE
 Q
ETRAP
 I $ZE["ENDOFFILE" S EOF=-1
 S $EC=""
 Q
QUIT
 C IO
 Q Q
