ZGO ; Save globals to ZWR files organized by FileMan
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
 N  W "ZWR Global Output, organized by FileMan"
 D ASKDIR Q:DIR["^"
 D SAVEALL(DIR)
 Q
SAVEALL(DIR) ; Save all globals to files in host DIR
 I '$$SLASH(DIR) Q
 D FILES
 D GLOBALS
 S G="" F  S G=$O(GLOBALS(G)) Q:G=""  D GLOBAL(G)
 Q
SAVEONE(DIR,G) ; Save global G to files in host DIR
 I '$$SLASH(DIR) Q
 D FILES
 D GLOBAL(G)
 Q
 ;---------------------------------------------------------------------------
 ; Private implementation entry points below
 ;
ASKDIR
 R !,!,"Host output directory: ",DIR,! Q:DIR["^"   G:'$$SLASH(DIR) ASKDIR
 Q
SLASH(DIR)
 I $E(DIR,$L(DIR))?1(1"/",1"\") Q 1
 E  U $P W "Output directory must end in a slash!" Q 0
FILES
 N FGR,FGRS,N
 S N=0 F  S N=$O(^DIC(N)) Q:N=""  I $D(^DIC(N,0))#10 S FGR=^DIC(N,0,"GL") S FGRS(FGR)=$P(^DIC(N,0),"^")
 S FGR="" F  S FGR=$O(FGRS(FGR)) Q:FGR=""  D
 . S R=$E(FGR,1,$L(FGR)-1)
 . I $E(FGR,$L(FGR))="," S R=R_")"
 . S F=$$FILE(R)
 . S @F=FGRS(FGR)
 Q
FILE(N)
 N I,FILE
 S FILE=$NAME(FILES($QS(N,0)))
 F I=1:1:$QL(N) S FILE=$NAME(@($E(FILE,1,$L(FILE)-1)_",$QS(N,I))"))
 Q FILE
GLOBALS
 N G
 D Fetch^%SYS.GD("*",1,0) ; Undocumented API, stores in ^CacheTempJ($J,
 S G="" F  S G=$O(^CacheTempJ($J,G)) Q:G=""  I G'?.E1L.E S GLOBALS(G)=""
 F G="^ROUTINE","^TMP","^UTILITY","^XUTL" K GLOBALS(G)
 Q
GLOBAL(G) ; Dump global G
 N IO S IO=$$OPENGBL(G)
 I $D(@G)#10 D WRITE(IO,G)
 D VISIT(IO,$NAME(FILES(G)),G)
 D CLOSE(IO)
 Q
VISIT(IO,F,G) ; Visit node G and recurse
 N DF S DF=$D(@F)
 I DF#10 S IO=$$OPENFILE(F)
 I DF<10 D DUMP(IO,G)
 E       D FOLLOW(IO,F,G)
 I DF#10 D CLOSE(IO)
 Q
FOLLOW(IO,F,G) ; Follow children of node G
 N RI,FI,I
 S RI=$S(G["(":$E(G,1,$L(G)-1)_",I)",1:G_"(I)")
 S FI=$E(F,1,$L(F)-1)_",I)"
 S I="" F  S I=$O(@RI) Q:I=""  D
 . N G,DG,NF
 . S G=$NAME(@RI),DG=$D(@G)
 . I DG#10 D WRITE(IO,G)
 . I DG<10 Q
 . S NF=$NAME(@FI)
 . I $D(@NF) D VISIT(IO,NF,G)
 . E         D DUMP(IO,G)
 Q
DUMP(IO,G) ; Dump everything under node G, excluding G itself
 N R,LR
 S R=$S(G["(":$E(G,1,$L(G)-1)_",",1:G_"("),LR=$L(R)
 F  S G=$Q(@G) Q:G=""  Q:$L(G)<LR  Q:$E(G,1,LR)'=R  D WRITE(IO,G)
 Q
HOSTPATH(N)
 Q DIR_N_".zwr"
HOSTFILE(F)
 N HF S HF=$QS(F,1),HF=$E(HF,2,$L(HF))_"+"
 S HF=HF_$TRANSLATE(@F,"/()*'","-") ; #&
 Q $$HOSTPATH(HF)
OPENGBL(G)
 N IO S IO=$$HOSTPATH($E(G,2,$L(G)))
 U $P W IO,!
 D OPEN(IO)
 U IO W G,!,"ZWR",!
 Q IO
OPENFILE(F)
 N IO S IO=$$HOSTFILE(F)
 U $P W IO,!
 D OPEN(IO)
 ;U $P W " ",F,!
 U IO W @F,!,"ZWR",!
 Q IO
OPEN(IO)
 ;U $P W "OPEN ",IO,!
 C IO O IO:("WNS"):1 I '$T U $P W "Cannot open """_IO_""" for write!",!
 Q
CLOSE(IO)
 ;U $P W "CLOSE ",IO,!
 C IO
 Q
WRITE(IO,G)
 U IO W $$ENCODE(G)_"="_$$VALUE(@G),!
 Q
VALUE(V) ; Encode value V
 S V=$NAME(%(V)),V=$E(V,3,$L(V)-1)
 I $E(V,1)'="""" S V=""""_V_""""
 Q $$ENCODE(V)
ENCODE(V) ; Convert control characters to $C() syntax
 Q:V'?.E1C.E V
 N Y,I,C
 S Y=""
 F I=1:1:$L(V) D
 . S C=$E(V,I)
 . I C?1C S Y=Y_"""_$C("_$A(C)_")_"""
 . E  S Y=Y_C
 Q Y
