ZZLEXXVE ;SLC/KER - Import - FileMan Verify (DIVC) ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^DD("KEY"           None
 ;               
 ; External References
 ;    None
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     DIFLD
 ;               
VER(DIFILE,DIROOT,DA,DIVCTMP,DIINDEX,DIKEY) ;
 ;
 ; Check that index is set. If index is a uniqueness index also
 ; check that key is unique, and that key fields are non-null.
 ; Called from INDEX^^ZZLEXXVF.
 ;
 ; Input:
 ; 
 ;   DIFILE  = [sub]file #
 ;   DIROOT  = closed [sub]file root
 ;  .DA      = DA array
 ;   DIVCTMP = root where xref info/logic is stored
 ;   
 ; Output:
 ; 
 ;  .DIINDEX = see VINDEX above
 ;  .DIKEY   = see VINDEX above
 ;
 N DICHECK,DINULL,DIXR,DIXRNAM,X,X1,X2
 N KEY,KFIL,KNAM,UNIQ
 ; Loop through the xrefs loaded in @DIVCTMP
 S DIXR=0 F  S DIXR=$O(@DIVCTMP@(DIFILE,DIXR)) Q:DIXR'=+DIXR  D
 . S DIXRNAM=$P(@DIVCTMP@(DIFILE,DIXR),U)
 . D SETXARR^ZZLEXXVG(DIFILE,DIXR,DIVCTMP,.DINULL) M X1=X,X2=X
 . ; If no X values are null, but no index, set DIINDEX(name,xref#)
 . I 'DINULL D
 .. S DICHECK=$G(@DIVCTMP@(DIFILE,DIXR,"V"))
 .. I DICHECK]"" X DICHECK E  S DIINDEX(DIXRNAM,DIXR)=""
 . ; If the xref is a uniqueness index for a key, set DIKEY() if
 . ; key is not unique, or a key field is null.
 . I $D(^DD("KEY","AU",DIXR)) D
 .. S UNIQ=$S(DINULL:0,1:$$UNIQUE^ZZLEXXVG(DIFILE,DIXR,.X,.DA,DIVCTMP))
 .. I 'UNIQ S KEY=0 F  S KEY=$O(^DD("KEY","AU",DIXR,KEY)) Q:'KEY  D
 ... Q:$D(^DD("KEY",KEY,0))[0  S KFIL=$P(^(0),U),KNAM=$P(^(0),U,2)
 ... S DIKEY(KFIL,KNAM,DIXRNAM)=$S(DINULL:"null",1:"uniq")
 Q
 ;
CHK ; File is a required input parameter
 ;
 ; Output:
 ; 
 ;   DA     = DA array
 ;   DIFILE = File #
 ;   DIROOT = Closed file root
 ;   DIVERR = 1 : if there's a problem
 ;   
 I $G(DIFILE)="" D:DIFLAG["D" ERR^ZZLEXXVG(202,"","","","FILE") D ERR Q
 I $G(DIFLD)="" D:DIFLAG["D" ERR^ZZLEXXVG(202,"","","","FIELD") D ERR Q
 ; Check DIREC and set DA array
 N DIIENS
 I $G(DIREC)'["," M DA=DIREC S DIIENS=$$IENS^ZZLEXXVG(.DA)
 E  S:DIREC'?.E1"," DIREC=DIREC_"," D DA^ZZLEXXVG(DIREC,.DA) S DIIENS=DIREC
 I '$$VDA^ZZLEXXVG(.DA,DIFLAG_"R") D ERR Q
 ; Check DIFLD
 I '$$VFLD^ZZLEXXVG(DIFILE,DIFLD,DIFLAG) D ERR Q
 ; Set DIFILE and DIROOT
 N DILEV
 I DIFILE=+$P(DIFILE,"E") D
 . S DIROOT=$$FROOTDA^ZZLEXXVG(DIFILE,DIFLAG,.DILEV) I DIROOT="" D ERR Q
 . I DILEV,$D(DA(DILEV))[0 D  Q
 .. D:DIFLAG["D" ERR^ZZLEXXVG(205,"",$$IENS^ZZLEXXVG(.DA),"",DIFILE) D ERR
 . S:DILEV DIROOT=$NA(@DIROOT)
 . S DIFILE=$$FNUM^ZZLEXXVG(DIROOT,DIFLAG) I DIFILE="" D ERR
 E  D
 . S DIROOT=DIFILE
 . S:"(,"[$E(DIROOT,$L(DIROOT)) DIROOT=$$CREF^ZZLEXXVG(DIFILE)
 . S DIFILE=$$FNUM^ZZLEXXVG(DIROOT,DIFLAG) I DIFILE="" D ERR Q
 . S DILEV=$$FLEV^ZZLEXXVG(DIFILE,DIFLAG) I DILEV="" D ERR Q
 . I DILEV,$D(DA(DILEV))[0 D  Q
 .. D:DIFLAG["D" ERR^ZZLEXXVG(205,"",$$IENS^ZZLEXXVG(.DA),"",DIFILE) D ERR
 N DIFLAG,DIREC
 Q
 ;
ERR ; Set error flag
 S DIVERR=1
 Q
 ;
LOADVER(FILE,FIELD,TMP) ; Load indexes into TMP array
 ;
 ; Load xref and verification logic for file/field into @TMP.
 ; Also, for each regular xref with no set condition, set
 ; @TMP@(rootFile#,xref#,"V")=I $D(^index),^index=indexVal
 ; where:
 ; 
 ;    index    = something like DIZ(9999,"BB",X(1),X(2),DA)
 ;    indexVal = value of index, usually ""
 ;
 ; Input:
 ; 
 ;   FILE  = File #
 ;   FIELD = Field #
 ;   TMP   = Root to store logic
 ;   
 N FIL,KL,SL,XR,DIVERR
 ; Load xref info for file/field into @TMP
 D LOADFLD^ZZLEXXVG(FILE,FIELD,"KS","","",TMP,TMP)
 ; Set the "V" nodes, kill the "S" and "K" nodes
 S FIL=0 F  S FIL=$O(@TMP@(FIL)) Q:'FIL  D
 . S XR=0 F  S XR=$O(@TMP@(FIL,XR)) Q:'XR  D
 .. I $P(@TMP@(FIL,XR),U,4)'="R"!$D(@TMP@(FIL,XR,"SC")) K @TMP@(FIL,XR) Q
 .. S SL=$G(@TMP@(FIL,XR,"S")),KL=$G(@TMP@(FIL,XR,"K"))
 .. I SL?1"S ^"1.E,KL?1"K ^"1.E D
 ... S @TMP@(FIL,XR,"V")="I $D("_$E(KL,3,999)_")#2,"_$E(SL,3,999)
 .. K @TMP@(FIL,XR,"S"),@TMP@(FIL,XR,"K")
 Q
