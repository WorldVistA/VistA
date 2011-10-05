ZGI ; Read Globals from ZWR format
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
 N  D CONFIG
 W "ZWR Global Input",! X CONFIG("ASKIO") Q:IO=""  W !
 I '$$LOAD(IO) Q
 U $P W "Loaded "_IO,!
 Q
LOAD(IO) ; Read Globals from IO device in ZWR format
 N CONFIG D CONFIG
 N Q,S S Q=1
 C IO X CONFIG("OPENIO") I '$T W "Failed to open: "_IO,! Q 0
 I '($$READLINE(.H1)&$$READLINE(.H2)&(H2["ZWR")) U $P W "Not a ZWR: "_IO,! S Q=0 G QUIT
 F  Q:'$$READLINE(.S)  S @S
 G QUIT
LIST(IO,DIR) ; Read list from IO, load Globals from each DIR<entry> device
 N CONFIG D CONFIG
 N Q,ZWR S Q=1
 C IO X CONFIG("OPENIO") I '$T W "Failed to open: "_IO,! Q 0
 F  Q:'$$READLINE(.ZWR)  U $P W DIR_ZWR,! I '$$LOAD(DIR_ZWR) S Q=0
 G QUIT
 ;---------------------------------------------------------------------------
 ; Private implementation entry points below
 ;
READLINE(LINE)
 N $ES,$ET,EOF S EOF=0 X CONFIG("ETRAP")
 D READLN(.LINE)
 Q '($ZEOF!EOF)
READLN(LINE)
 S LINE=""
 U IO R LINE
 Q
ETRAP
 I @(CONFIG("ENDOFFILE")) S EOF=-1
 S $EC=""
 Q
QUIT
 C IO
 Q Q
CONFIG
 I $D(CONFIG) Q
 I $ZV["Cache" D  Q
 . S CONFIG("ASKIO")="D IN^%IS I POP S IO="""""
 . S CONFIG("OPENIO")="O IO:(""R""):0"
 . S CONFIG("ETRAP")="S $ET=""G ETRAP"""
 . S CONFIG("ENDOFFILE")="$ZE[""ENDOFFILE"""
 I $ZV["GT.M" D  Q
 . S CONFIG("ASKIO")="D ASKIO"
 . S CONFIG("OPENIO")="O IO:(readonly):0"
 . S CONFIG("ETRAP")="U IO:(exception=""G ETRAP"")"
 . S CONFIG("ENDOFFILE")="$ZS[""IOEOF"""
 W "ZGI does not support "_$ZV,!
 Q
ASKIO
 R "Device: ",IO,!
 I IO="" G ASKIO
 I IO="^" S IO=""
 Q
