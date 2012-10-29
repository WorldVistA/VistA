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
 N  D CONFIG
 W "ZWR Global Output, organized by FileMan"
 D ASKDIR Q:DIR["^"
 D DUMPALL
 Q
SAVEALL(DIR) ; Save all globals to files in host DIR
 N CONFIG D CONFIG
 I '$$SLASH(DIR) Q
 D DUMPALL
 Q
SAVEONE(DIR,G) ; Save global G to files in host DIR
 N CONFIG D CONFIG
 I '$$SLASH(DIR) Q
 D DUMPONE
 Q
 ;---------------------------------------------------------------------------
 ; Private implementation entry points below
 ;
CONFIG
 I $D(CONFIG) Q
 I $ZV["Cache" D  Q
 . S CONFIG("OPENIORW")="O IO:(""WNS""):1"
 . S CONFIG("GLOBALS")="D Fetch^%SYS.GD(""*"",1,0) S G="""" F  S G=$O(^CacheTempJ($J,G)) Q:G=""""  I G'?.E1L.E S GLOBALS(G)="""""
 I $ZV["GT.M" D  Q
 . S CONFIG("OPENIORW")="D GTMIOW(IO)"
 . S CONFIG("GLOBALS")="S G=""^%"" F  S G=$O(@G) Q:G=""""  S:$D(^%) G(""^%"")="""" I G'?.E1L.E S GLOBALS(G)="""""
 W "ZGO does not support "_$ZV,!
 Q
GTMIOW(IO) ; GT.M open-for-output impl.
 O IO:(newversion:noreadonly:nowrap:except="S IO=""""") I IO'=""
 Q
ASKDIR
 R !,!,"Host output directory: ",DIR,! Q:DIR["^"   G:'$$SLASH(DIR) ASKDIR
 Q
SLASH(DIR)
 I $E(DIR,$L(DIR))?1(1"/",1"\") Q 1
 E  U $P W "Output directory must end in a slash!" Q 0
DUMPALL
 D FILES
 D GLOBALS
 S G="" F  S G=$O(GLOBALS(G)) Q:G=""  D GLOBAL(G)
 Q
DUMPONE
 D FILES
 D GLOBAL(G)
 Q
FILES ; Build FILES() mapping FGR components to file number
 N N S N=0 F  S N=$O(^DIC(N)) Q:N=""  D:+N
 . N FGR S FGR=$$ROOT^DILFD(N,"",1),FGR=$$FGRFIX(FGR)
 . Q:'$$FGROK(FGR,N)
 . N F S F=$$FILE(FGR),@F=N
 Q
FGROK(FGR,N) ; Verify that FGR is a canonical M node name
 I FGR="" W "W: File "_N_" has no root!",! Q
 N $ET S $ET="S $EC="""" W ""W: File "_N_" has non-canonical root: ""_FGR,! Q 0"
 N (FGR) ; Hide local variables from evaluation of @FGR
 Q ($NA(@FGR)]"")&($QL(FGR)'<0)
FGRFIX(FGR) ; Fix known non-canonical FGRs
 N N F N="DUZ(2)" D
 . N B,E,S S B=$L(FGR)-$L(N) Q:B<1  S E=$L(FGR)-1,S=$E(FGR,B-1)
 . I ((S=",")!(S="("))&($E(FGR,B,E)=N)&($E(FGR,E+1)=")") S $E(FGR,B-1,E+1)=$S(S="(":"",1:")")
 Q FGR
FILE(N)
 N I,FILE
 S FILE=$NAME(FILES($QS(N,0)))
 F I=1:1:$QL(N) S FILE=$NAME(@FILE@($QS(N,I)))
 Q FILE
GLOBALS
 N G
 X CONFIG("GLOBALS")
 F G="^ROUTINE","^TMP","^UTILITY","^XUTL","^%ZOSF","^XTMP" K GLOBALS(G)
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
 N I S I="" F  S I=$O(@G@(I)) Q:I=""  D
 . N NG,DG S NG=$NAME(@G@(I)),DG=$D(@NG)
 . I DG#10 D WRITE(IO,NG)
 . I DG<10 Q
 . N NF S NF=$NAME(@F@(I))
 . I $D(@NF) D VISIT(IO,NF,NG)
 . E         D DUMP(IO,NG)
 Q
DUMP(IO,G) ; Dump everything under node G, excluding G itself
 N R,LR
 S R=$S(G["(":$E(G,1,$L(G)-1)_",",1:G_"("),LR=$L(R)
 F  S G=$Q(@G) Q:G=""  Q:$L(G)<LR  Q:$E(G,1,LR)'=R  D WRITE(IO,G)
 Q
FILENAME(N) ; Return FileMan file name
 Q $P(^DIC(N,0),"^")
HOSTPATH(N)
 Q DIR_N_".zwr"
HOSTFILE(F)
 N HF S HF=@F_"+"_$TRANSLATE($$FILENAME(@F),"/()*'","-") ; #&
 I $E(HF,1)="." S HF="0"_HF ; File numbers < 1
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
 U IO W $$FILENAME(@F),!,"ZWR",!
 Q IO
OPEN(IO)
 ;U $P W "OPEN ",IO,!
 C IO X CONFIG("OPENIORW") I '$T U $P W "Cannot open """_IO_""" for write!",!
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
