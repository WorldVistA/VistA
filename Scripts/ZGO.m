ZGO ; [Public] Save globals to ZWR files organized by FileMan ; 12/6/16 4:01pm
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
 ;
EN ; [Public] Interactive Entry Point
 N (ZGODEBUG)
 D CONFIG
 W "ZWR Global Output, organized by FileMan"
 D ASKDIR Q:DIR["^"
 D DUMPALL
 Q
 ;
 ;
SAVEALL(DIR) ; [Public] Save all globals to files in host DIR
 N CONFIG D CONFIG
 I '$$SLASH(DIR) Q
 N T1 S T1=$$NOW^XLFDT()
 D DUMPALL
 N T2 S T2=$$NOW^XLFDT()
 W !,$$FMDIFF^XLFDT(T2,T1,2)_" SECONDS"
 K ^TMP($J),^XTMP("ZGO")
 Q
 ;
 ;
SAVEONE(DIR,G) ; [Public] Save global G to files in host DIR
 N CONFIG D CONFIG
 I '$$SLASH(DIR) Q
 N T1 S T1=$$NOW^XLFDT()
 D DUMPONE
 N T2 S T2=$$NOW^XLFDT()
 W !,$$FMDIFF^XLFDT(T2,T1,2)_" SECONDS"
 K ^TMP($J),^XTMP("ZGO")
 Q
 ;
 ;
SINGLEDUMP(DIR) ; [Public] Dump everything into one file
 N T1 S T1=$$NOW^XLFDT()
 N CONFIG D CONFIG
 I '$$SLASH(DIR) Q
 N GLOBALS D GLOBALS
 n gDev s gDev=$$OPENGBL("ALL")
 u gDev
 N G S G=""
 F  S G=$O(GLOBALS(G)) Q:G=""  ZWRITE @G ; Better on GT.M
 ;F  S G=$O(GLOBALS(G)) Q:G=""  D WRITE(gDev,G):$D(@G)#2,DUMP(gDev,G) ; Better on Cache
 d CLOSE(gDev)
 N T2 S T2=$$NOW^XLFDT()
 W !,$$FMDIFF^XLFDT(T2,T1,2)_" SECONDS"
 K ^TMP($J),^XTMP("ZGO")
 Q
 ;---------------------------------------------------------------------------
 ; Private implementation entry points below
 ;
CONFIG ; Obtain configuration for Open and obtaining globals
 I $D(CONFIG) Q
 ; Kill garbage globals
 K ^A7RTMP1,^DIZ("ZDBSVR"),^SYS
 ; Kill invalid top nodes
 ZK ^%ZIS,^%ZISL,^%ZTER,^%ZTSCH,^%ZUA,^%ZUT
 ZK ^DIC,^ECC,^ECT,^DIC,^LAC,^LEX,^LEXC,^PRPF,^PRPFT,^PSNDF,^PSNDF(0),^USC,^XIP
 ;
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
ASKDIR ; Ask directory
 R !,!,"Host output directory: ",DIR,! Q:DIR["^"   G:'$$SLASH(DIR) ASKDIR
 Q
SLASH(DIR) ; Check for an ending slash
 I $E(DIR,$L(DIR))?1(1"/",1"\") Q 1
 E  U $P W "Output directory must end in a slash!" Q 0
WRITEHDR(VAL) ; Writes out the date/time in the header
 N Y
 I +VAL=47 Q $ZDATE($HOROLOG,"DD-MON-YEAR 12:60:SS")
 I $L(VAL,":")=2 D  Q Y ; Cache date time
 . N MLIST S MLIST=" JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC"
 . S Y=$TR($ZDATE($HOROLOG,2,MLIST)," ","-")_" "_$ZTIME($P($HOROLOG,",",2))
 Q 0
DUMPALL ; Dump All globals
 S ^XTMP("ZGO",0)=$$DT^XLFDT_"^"_$$DT^XLFDT_"^"_"Children for extraction^"_DIR
 I $G(ZGODEBUG) D  QUIT
 . D FILES,GLOBALS
 . N G S G=0
 . F  S G=$O(GLOBALS(G)) Q:G=""  D VISIT(G)
 L +^ZGO ; Child jobs must wait on Semaphore
 D STARTJOBS
 D FILES
 D GLOBALS
 M ^XTMP("ZGO","FILES")=FILES
 M ^XTMP("ZGO","GLOBALS")=GLOBALS
 M ^XTMP("ZGO","FILEROOTS")=FILEROOTS
 L -^ZGO ; GO!
 H 1
 L +^ZGO ; Wait until they are done.
 L ; Done
 Q
DUMPONE ; Dump one global
 D FILES
 D VISIT(G)
 Q
FILES ; Build FILES() mapping FGR components to file number
 N N S N=0 F  S N=$O(^DIC(N)) Q:N=""  D:+N
 . N FGR S FGR=$$ROOT^DILFD(N,"",1),FGR=$$FGRFIX(FGR)
 . Q:'$$FGROK(FGR,N)
 . N F S F=$$FILE(FGR),@F=N,FILEROOTS(N)=FGR
 Q
FGROK(FGR,N) ; Verify that FGR is a canonical M node name
 I FGR="" W "W: File "_N_" has no root!",! Q 0
 N $ET S $ET="S $EC="""" W ""W: File "_N_" has non-canonical root: ""_FGR,! Q 0"
 N (FGR) ; Hide local variables from evaluation of @FGR
 Q ($NA(@FGR)]"")&($QL(FGR)'<0)
FGRFIX(FGR) ; Fix known non-canonical FGRs
 N N F N="DUZ(2)" D
 . N B,E,S S B=$L(FGR)-$L(N) Q:B<1  S E=$L(FGR)-1,S=$E(FGR,B-1)
 . I ((S=",")!(S="("))&($E(FGR,B,E)=N)&($E(FGR,E+1)=")") S $E(FGR,B-1,E+1)=$S(S="(":"",1:")")
 Q FGR
FILE(N) ; [Private] Crate File Array for a Fileman File
 ; FILES("^XWB",8994)=8994
 N I,FILE
 S FILE=$NAME(FILES($QS(N,0)))
 F I=1:1:$QL(N) S FILE=$NAME(@FILE@($QS(N,I)))
 Q FILE
GLOBALS ; [Private] Collect all Globals except the temp ones
 N G
 X CONFIG("GLOBALS")
 F G="^ROUTINE","^TMP","^UTILITY","^XUTL","^%ZOSF","^XTMP","^DISV" K GLOBALS(G)
 Q
STARTJOBS  ; [Private] Start child workers
 N CORES
 I $L($SY,":")=2 X "S CORES=$SYSTEM.Util.NumberOfCPUs()"
 I +$SY=47 D
 . I $ZV["Linux" o "p":(shell="/bin/sh":comm="nproc")::"pipe" u "p" r CORES c "p"
 . I $ZV["Darwin" o "p":(shell="/bin/sh":comm="sysctl -n hw.ncpu")::"pipe" u "p" r CORES c "p"
 I 'CORES S CORES=8
 N JOBPAR
 N CACHENULL S CACHENULL="/dev/null"
 I $L($SY,":")=2,$ZV["Windows" S CACHENULL="//./nul"
 N OUTCACHE S OUTCACHE=$$DEFDIR^%ZISH_"worklist.log"
 I +$SY=47 S JOBPAR="RUNJOBS:(IN=""/dev/null"":OUT="""_$P_""":ERR="""_$P_""")"
 I $L($SY,":")=2 S JOBPAR="RUNJOBS:(::CACHENULL:OUTCACHE)"
 N I F I=1:1:CORES J @JOBPAR W !,"Started Job PID "_$S($L($SY,":")=2:$ZCHILD,1:$ZJOB)
 I $L($SY,":")=2 W !,"Tail "_OUTCACHE_" to see the status of a Cache Export"
 QUIT
 ;
RUNJOBS ; [Private] Run child workers
 L +^ZGO($J) ; Wait on Semaphore
 N DIR S DIR=$P(^XTMP("ZGO",0),"^",4)
 D CONFIG
 N G S G=0
 F  S G=$O(^XTMP("ZGO","GLOBALS",G)) Q:G=""  D
 . L +^XTMP("ZGO","GLOBALS",G):0 E  QUIT
 . N FILES M FILES=^XTMP("ZGO","FILES")
 . N FILEROOTS M FILEROOTS=^XTMP("ZGO","FILEROOTS")
 . D VISIT(G)
 . K ^XTMP("ZGO","GLOBALS",G) ; Kill it so nobody else tries to loop through it.
 . K ^XTMP("ZGO","FILES",G) ; This is just cosmetic
 . N I F I=0:0 S I=$O(^XTMP("ZGO","FILEROOTS",I)) Q:'I  K:$NA(@^(I),0)=G ^(I) ; cosmetic again
 . L -^XTMP("ZGO","GLOBALS",G) ; Unlock
 L -^ZGO($J)
 QUIT
VISIT(G) ; [Private] Visit export Files; and if there is a non-Fileman node, export that separately.
 s $et="d ^%ZTER HALT"
 w !,$J,": ",G,!
 n gDev ; global device
 N gHasFiles S gHasFiles=$O(FILES(G,""))'=""!($d(FILES(G))=1)
 ;
 n tracker  ; track weather we dumped everything in a filed global
 n done s done=0    ; Don't continue if file is in an unsubscripted global and exported already.
 I gHasFiles d  ; for each file
 . n fileRef s fileRef=$na(FILES(G))  ; Get the global reference *name*
 . ; run this loop twice: once if the file is in the global and then quit
 . ;  -> or for each entry of the files array for this global.
 . ;  -> God did not create $Query stuff to be readable.
 . d:$d(FILES(G))=1  q:done  f  s fileRef=$q(@fileRef) q:fileRef=""  q:$na(@fileRef,1)'=$na(FILES(G),1)  d
 .. n fileNumber s fileNumber=@fileRef
 .. n fileGlobal s fileGlobal=FILEROOTS(fileNumber)
 .. s tracker(fileGlobal)=""
 .. n fDev s fDev=$$OPENFILE(fileRef)
 .. I +$SY=47 U fDev ZWRITE @fileGlobal@(*) ; GT.M speed up!
 .. I $L($SY,":")=2 d  ; On Cache, ZWRITE is really slow
 ... d:$d(@fileGlobal)#2 WRITE(fDev,fileGlobal) ; head node
 ... d DUMP(fDev,fileGlobal)
 .. d CLOSE(fDev)
 .. i $d(FILES(G))=1 s done=1
 .. k @fileRef,FILEROOTS(fileNumber)
 ;
 i done quit  ; All exported. No need for any other checks.
 ;
 ; Now see if any of the data did not get written out (e.g. ^DD)
 ; Merge global to ^TMP, and then peel it off
 ; NB: (sam): I don't like this--but this is not very expensive compared to writing the global on disk.
 ;            I wish to think of another algorithm to do this; but--alas, nothing comes to mind.
 k ^TMP($J)
 M ^TMP($J)=@G
 n glo s glo=""
 n q s q=""""
 ;
 ; Stanza: remove glos which we exported from ^TMP
 ;         if nothing remains, we are done!
 f  s glo=$o(tracker(glo)) q:glo=""  d  ; for each global node under G
 . n fullSubs s fullSubs=""             ; obtain subscripts
 . n i f i=1:1:$ql(glo) d               ; ditto
 .. n sub s sub=$qs(glo,i)              ; ditto
 .. i sub?1.N,+sub=sub
 .. e  s sub=q_sub_q                    ; quote non-numeric values
 .. s fullSubs=fullSubs_sub_","         ; add a comma to the end
 . s $e(fullSubs,$l(fullSubs))=""       ; remove final comma
 . k @("^TMP("_$J_","_fullSubs_")")     ; Okay. We know we exported that.
 ;
 ; Are we done?
 if '$data(^TMP($J)) quit
 ;
 ; Stanza: Export leftovers
 ; Stuff still remains... okay then, no choice.
 n orig s orig=$na(^TMP($J))
 i $d(FILES(G))=1 s gDev=$$OPENFILE($NA(FILES(G))) i 1 ; ^DIC
 e  s gDev=$$OPENGBL(G)
 i $d(@orig)#2 D WRITE(gDev,G)
 n notSaved s notSaved=orig
 ; loop through every node in ^TMP, find the corresponding node in G, and export that.
 f  s notSaved=$Q(@notSaved) q:notSaved=""  q:$na(@notSaved,1)'=orig  d
 . n fullSubs s fullSubs=""
 . n i f i=2:1:$ql(notSaved) d
 .. n sub s sub=$qs(notSaved,i)
 .. i sub?1.N,+sub=sub
 .. e  s sub=q_sub_q
 .. s fullSubs=fullSubs_sub_","
 . s $e(fullSubs,$l(fullSubs))=""
 . n gNode s gNode=G_"("_fullSubs_")"
 . I +$SY=47 U gDev ZWRITE @gNode@(*) ; GT.M speed up!
 . I $L($SY,":")=2 D WRITE(gDev,gNode)
 D CLOSE(gDev)
 quit
 ;
DUMP(IO,G) ; Dump everything under node G, excluding G itself
 N R,LR
 S R=$S(G["(":$E(G,1,$L(G)-1)_",",1:G_"("),LR=$L(R)
 F  S G=$Q(@G) Q:G=""  Q:$L(G)<LR  Q:$E(G,1,LR)'=R  D WRITE(IO,G)
 Q
FILENAME(N) ; Return FileMan file name
 Q $P(^DIC(N,0),"^")
HOSTPATH(N) ;
 Q DIR_N_".zwr"
HOSTFILE(F) ;
 N HF S HF=@F_"+"_$TRANSLATE($$FILENAME(@F),"/()*'","-") ; #&
 I $E(HF,1)="." S HF="0"_HF ; File numbers < 1
 Q $$HOSTPATH(HF)
OPENGBL(G) ;
 N IO S IO=$$HOSTPATH($E(G,2,$L(G)))
 U $P W IO,!
 D OPEN(IO)
 U IO W "OSEHRA ZGO Export: "_G,!,$$WRITEHDR($SY)_" ZWR",!
 Q IO
OPENFILE(F) ;
 N IO S IO=$$HOSTFILE(F)
 U $P W IO,!
 D OPEN(IO)
 U IO W "OSEHRA ZGO Export: "_$$FILENAME(@F),!,$$WRITEHDR($SY)_" ZWR",!
 Q IO
OPEN(IO) ;
 ;U $P W "OPEN ",IO,!
 C IO X CONFIG("OPENIORW") I '$T U $P W "Cannot open """_IO_""" for write!",!
 Q
CLOSE(IO) ;
 ;U $P W "CLOSE ",IO,!
 C IO
 Q
WRITE(IO,G) ;
 ;U IO W $$ENCODE(G)_"="_$$VALUE(@G),!
 W $$ENCODE(G)_"="_$$VALUE(@G),!
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
