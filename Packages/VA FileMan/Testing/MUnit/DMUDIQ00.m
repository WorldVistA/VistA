DMUDIQ00 ;VEN/LGC - UNIT TESTING FM DIQ ; 3/6/13 11:44am
 ;;22.2;VA FILEMAN;;Mar 28, 2013;1/7/2013
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 ;
 S IO=$PRINCIPAL
 N DIQUIET S DIQUIET=1
 D DT^DICRW
 D EN^XTMUNIT($T(+0),1)
 QUIT
 ;
 ;
TGET1DIQ ; @TEST - $$GET1^DIQ Single Data Retriever
 ; DIQ     $$GET1^DIQ( ): Single Data Retriever
 ; VA FM PRG MAN 22.0 March 1999, Revised May 2011 3.5.42
 ; Test using with DIKK EDIT form entry in FORM file which
 ;   is distributed with Fileman
 ; Test Method:
 ;  1. Set file number to .403, record to .3101
 ;     NOTE: Selecting FM file delivered with FM
 ;  2. Pull "GL" nodes from the DD for this file and its subfiles for
 ;     each field number defined in DD
 ;  3. Check the result of the $GET1^DIQ against the data
 ;     pulled directly from the global node and piece
 ;     as defined in DD
 ;  4. Failure defined as any incidence of failure to match
 ;
 S FNMBR=.403,RECORD=.3101
 N ERR S ERR=0
 N FARRAY
 ; Build an array of all the GL nodes (file and subfile)
 D PULLDD(FNMBR,.FARRAY)
 ; Now run through each file and subfile to compare entiries
 ;  for this record.  Do by finding node with data and using
 ;  GL to pull each piece of the node, then compare with a
 ;  $$GET1 call with the "I" flag.  If even one difference
 ;  is found, the test ends in failure.
 N SUBF S SUBF=0
 F  S SUBF=$O(FARRAY(SUBF)) Q:'SUBF  D TGET1(FNMBR,RECORD,SUBF)
 S Y=ERR
 D CHKEQ^XTMUNIT(Y,0,"GET1^DIQ Single Data Retriever failed.")
 Q
 ; Enter with a file or subfile number, the record in the file
 ;  to use for evaluation, and the subfile to evaluate.
 ; Note that if we are evaluating the top file, the subfile
 ;  arrives empty and is set to be the same as the file number
 ;  immediately upon entering the subroutine.
 ;   FNMBR   =  File number being evaluated (e.g. .403)
 ;   RECORD  =  Record in file to use (e.g. .3010)
 ;   SUBF    =  Subfile to evaluate (e.g. .4032 )
TGET1(FNMBR,RECORD,SUBF) ;
 S:$G(SUBF)="" SUBF=FNMBR
 ; Gather all GL nodes in the DD for this file/subfile and
 ;  any subfiles noted in the DD
 D PULLDD(SUBF,.POO)
 N NODE,SNODE,QLBN
 ; Get global where this file stored
 ; Set stop node to node global minus the last subscript
 S NODE=$NA(^DIC(FNMBR,0,"GL")),NODE=@NODE_RECORD_")"
 Q:'$D(@$Q(@NODE))
 S QLBN=$QL(NODE)
 S SNODE=$P($P(NODE,",",1,$QL(NODE)),")")
 ; Run through every global node associated with this file
 ;   and/or subfile and send to the subroutine to compare each
 ;   piece of the global entry against a $$GET1 call
 I SUBF=FNMBR D  Q
 . D TGET1B(RECORD,NODE,SUBF,FNMBR,SNODE,QLBN)
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D
 . I +$P(@NODE,"^",2)=+SUBF D
 .. D TGET1B(RECORD,NODE,SUBF,FNMBR,SNODE,QLBN)
 Q
 ; Run through all matching global nodes.  Compare the
 ;  pieces of data for each as described by the GL
 ;  and compare to the $$GET1 call for the represented
 ;  field
TGET1B(RECORD,NODE,SUBF,FNMBR,SNODE,QLBN) ;
 N GET1,BYPIECE,DSS
 N CNT S CNT=$QL(NODE)
 I SUBF=FNMBR S SNODE=$P(SNODE,",",1,$QL(NODE))
 E  S SNODE=$P(SNODE,",",1,$QL(NODE)-1)
 N SSCNT S SSCNT=$QL($Q(@NODE))
 ;
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  Q:'$QS(NODE,CNT)  D
 . Q:SSCNT<$QL(NODE)
 . S DSS=$QS(NODE,$QL(NODE)) ; Note terminal or Data SubScript
 . S IENS=$$BLDIENS(QLBN,NODE) ; Build an appropriate IENS
 . N PIECE S PIECE=0
 . F  S PIECE=$O(POO(SUBF,"GL",DSS,PIECE)) Q:PIECE=""  D
 ..  S FIELD=$O(POO(SUBF,"GL",DSS,PIECE,""))
 ..  S GET1=$$GET1^DIQ(SUBF,IENS,FIELD,"I")
 ..  I PIECE S BYPIECE=$P(@NODE,"^",PIECE)
 ..  E  S BYPIECE=@NODE
 ..  S:GET1'=BYPIECE ERR=1
 Q
 ;
 ;
 ;
TDDIQ ; @TEST - D^DIQ Conversion of Internal to External date
 ; Convert Date
 ; Takes internal date in Y and coverts to the external form
 ; DIQ     D^DIQ: Display
 ; VA FM PRG MAN 22.0 March 1999, Revised May 2011 2.3.40
 ; Test Method:
 ;  1. Build an array of random dates
 ;  2. Convert each to the external format with D^DIQ call
 ;  3. Convert each back to the FM date with the ^%DT call
 ;     and check for match
 ;  4. Failure defined as any incidence of failure to match
 N ERR,CNT,XARRAY,Y,YY S CNT=1000 D MKDTARR(.XARRAY,CNT)
 S ERR=0
 N NODE S NODE=$NA(XARRAY)
 F  S NODE=$Q(@NODE) Q:NODE'["XARRAY"  D
 . S Y=@NODE D D^DIQ S YY=Y
 . S X=$P(Y,"@") D ^%DT S Y=Y_"."_$TR($P(YY,"@",2),":")
 . I Y'=@NODE D
 .. S ERR=1
 S Y=ERR
 D CHKEQ^XTMUNIT(Y,0,"D^DIQ Date Conversion Internal to External failed.")
 Q
 ;
 ;
 ;
TDTDIQ ; @TEST - DT^DIQ Convert and Display Date
 ; DIQ     DT^DIQ: Display
 ; VA FM PRG MAN 22.0 March 1999, Revised May 2011 2.3.41
 ; Test Method:
 ;  1. Build an array of random dates
 ;  2. Convert each to the external format with DT^DIQ call
 ;     and capture the returned result
 ;  3. Convert each back to the FM date with the ^%DT call
 ;     and check for match
 ;  4. Failure defined as any incidence of failure to match
 N ERR,CNT,POO,XARRAY,Y,YY S CNT=1000 D MKDTARR(.XARRAY,CNT)
 S ERR="0"
 N NODE S NODE=$NA(XARRAY)
 N CMD S CMD="DT^DIQ"
 F  S NODE=$Q(@NODE) Q:NODE'["XARRAY"  D
 . S CMD="S Y=@NODE D DT^DIQ"
 . D INTWRAP(CMD,.POO)
 . S YY=Y
 . S X=$P(Y,"@") D ^%DT S Y=Y_"."_$TR($P(YY,"@",2),":")
 . I Y'=@NODE D
 ..  S ERR=1
 S Y=ERR
 D CHKEQ^XTMUNIT(Y,0,"DT^DIQ Date Convert and Display failed.")
 Q
 ;
 ;
 ;
TENDIQ ; @TEST - EN^DIQ Display a Range of Data Elements
 ; DIQ     EN^DIQ: Display
 ; VA FM PRG MAN 22.0 March 1999, Revised May 2011 2.3.42
 ; Testing Process
 ;   Use the EN^DIQ call to retrieve all data from the first
 ;   entry in the LANGUAGE [.85] file as distributed in
 ;   FM 22.2 at X1DATA
 ; Test Method:
 ;  1. Set file number to .85
 ;     NOTE: Selecting FM file delivered with FM
 ;  2. Pull "GL" nodes from the DD for this file and
 ;     each field number defined in DD
 ;  3. Capture the text from the EN^DIQ call.
 ;     NOTE: To mitigate problems due to match failures due
 ;     to multiple " marks and added spaces in the return
 ;     text, these are removed.
 ;  4. Pull the node and piece directly from the global as
 ;     indicated by the DD.
 ;     Note: " and spaces removed (see 3 above)
 ;  5. Search the text retrieved with the EN^DIQ call for
 ;     the field name being evaluated.  If found, check
 ;     the data retrieved from the global node and piece
 ;     directly as being contained in the EN^DIQ call.
 ;     NOTE: Sadly, demanding 1) the field name be found
 ;           in the EN^DIQ text was necessary as the FM
 ;           call sometimes shortens the field name
 ;           (perhaps for text compression?) and 2) needing
 ;           to remove " and space characters, then
 ;           3) seaching for a match as a 'contained in'
 ;           process mitigates the strength of the testing.
 ;           I was unable to think around these issues and
 ;           would gladly accept correction/advice - poo
 ;
 N FNMBR,ERR,RECORD S FNMBR=.85,RECORD=1,ERR=0
 D PULLDD(FNMBR,.POO)
 N XXDIC S XXDIC=^DIC(FNMBR,0,"GL")
 N ALLPPP,ANS1,CMD,FNAME
 S CMD="K DA,DR S DIC=XXDIC,DA=1,DIQ(0)="""" D EN^DIQ"
 K PPP
 D INTWRAP(.CMD,.PPP)
 N CNT S CNT=0
 F  S CNT=$O(PPP(CNT)) Q:'CNT  S ALLPPP=$G(ALLPPP)_PPP(CNT)
 S ALLPPP=$TR(ALLPPP," "),ALLPPP=$TR(ALLPPP,"""")
 ;
 ; Go down GL for file and get each name
 N FNAME,FNAMEC,OK S FNAME=""
 N BDDGLBL S BDDGLBL="^DD("_FNMBR_",""B"")"
 S BDDGLBL=$NA(@BDDGLBL),OK=$P(BDDGLBL,")")
 F  S BDDGLBL=$Q(@BDDGLBL) Q:BDDGLBL'[OK  D  Q:ERR
 .  Q:@BDDGLBL
 .  S FNAME=$QS(BDDGLBL,3)
 .  S FNAME=$TR(FNAME_":",""""),FNAME=$TR(FNAME," ")
 .  Q:ALLPPP'[FNAME
 .  S FLDNUM=$QS(BDDGLBL,4)
 .  D TMPFN(FLDNUM,.POO) Q:NODE=""
 .  S:NODE'=+NODE NODE=""""_NODE_""""
 .  S GLBL=XXDIC_RECORD_","_NODE_")" ;W !,"GLBL=",GLBL
 .  S GLBL=$NA(@GLBL) ;W " NEW GLBL=",GLBL
 .  Q:'($D(@GLBL)#2)
 .  I PIECE S ANS1=$P(@GLBL,"^",PIECE)
 .  E  S ANS1=@GLBL
 .  Q:'$L(ANS1)
 .  S ANS1=$TR(FNAME_$G(ANS1),""""),ANS1=$TR(ANS1," ")
 .  S:ALLPPP'[ANS1 ERR=1
 S Y=ERR
 D CHKEQ^XTMUNIT(Y,0,"EN^DIQ Display Range of Data Elements failed.")
 Q
TMPFN(FLDNUM,POO) N GLNODE S GLNODE=$NA(POO(0)),GLNODE=$Q(@GLNODE)
TMPFN1 S:GLNODE="" (NODE,PIECE)="" Q:GLNODE=""  S NODE=$QS(GLNODE,3),PIECE=$QS(GLNODE,4) Q:$QS(GLNODE,5)=FLDNUM  S GLNODE=$Q(@GLNODE) G TMPFN1
 Q
 ;
 ;
 ;
TGETS ; @TEST - GETS^DIQ Data Retriever
 ; DIQ     GETS^DIQ( ): Data Retriever
 ; VA FM PRG MAN 22.0 March 1999, Revised May 2011 3.5.43
 ; Testing Process
 ;   Use the GETS^DIQ call to retrieve all data from a given
 ;   file entry and compare to the nodes as described in the GL
 ; Test Method:
 ;  1. Set file number to .85, record to 1
 ;     NOTE: Selecting FM file delivered with FM
 ;  2. Perform GETS^DIQ
 ;  3. Pull "GL" nodes from the DD for this file for
 ;     each field number defined in DD
 ;  4. Check the data obtained from each node and piece in
 ;     the file global as defined in the DD with the same
 ;     information returned in the GETS array
 ;  5. Failure defined as any incidence of failure to match
 N FNMBR,RECORD,ERR,ARRAY,POO,OK
 S FNMBR=.85,RECORD=1,ERR=0
 D GETS^DIQ(FNMBR,"1,","**","I","ARRAY")
 D PULLDD(FNMBR,.POO)
 N GLBLDD
 S GLBLDD="POO("_FNMBR_")",GLBLDD=$NA(@GLBLDD),OK=$P(GLBLDD,")")_","
 N ANS1,FLDNUM,GLBLA,GLBLDATA,NODE,PIECE
 F  S GLBLDD=$Q(@GLBLDD) Q:GLBLDD'[OK  D
 . S NODE=$QS(GLBLDD,3),PIECE=$QS(GLBLDD,4),FLDNUM=$QS(GLBLDD,5)
 . S:NODE'=+NODE NODE=""""_NODE_""""
 . S GLBLDATA=^DIC(FNMBR,0,"GL")_RECORD_","_NODE_")"
 . S GLBLDATA=$NA(@GLBLDATA)
 . Q:'($D(@GLBLDATA)#2)
 . I PIECE'=+PIECE S ANS1=@GLBLDATA
 . E  S ANS1=$P(@GLBLDATA,"^",PIECE)
 . S GLBLA="ARRAY("_FNMBR_","""_RECORD_","","_FLDNUM_",""I"")"
 . S GLBLA=$NA(@GLBLA)
 . S:ANS1'=@GLBLA ERR=1
 S Y=ERR
 D CHKEQ^XTMUNIT(Y,0,"GETS^DIQ Data Retriever failed.")
 Q
 ;
 ;
 ;
TYDIQ ; @TEST - Y^DIQ Convert Internal Form of any Data Element to External Form
 ;   (Equivalent DS is $$EXTERNAL^DILFD)
 ; DIQ     Y^DIQ: Display
 ; VA FM PRG MAN 22.0 March 1999, Revised May 2011 2.3.43
 ; Test Method:
 ;  1. Run through data saved in this routine (X1DATA) for testing
 ;     NOTE: Selecting FM files delivered with FM
 ;  2. Parse into the variables needed for the Y^DIQ call
 ;  3. Run the Y^DIQ call and check result matches expected
 ;  4. Failure defined as any incidence of failure to match
 ;  NOTE: I would like to work further on this and change to
 ;        a direct translation of the DD to allow for a more
 ;        thorough and powerful testing
 N C,CNT,ERR,FILE,FIELD,Y,RSLT
 S ERR=0
 F  S CNT=$G(CNT)+1 Q:'$L($P($T(X1DATA+CNT),";;",2))  D
 . S Y=$P($T(X1DATA+CNT),";;",2)
 . S FILE=$P(Y,"^"),FIELD=$P(Y,"^",2),RSLT=$P(Y,"^",4),Y=$P(Y,"^",3)
 . S C=$P(^DD(FILE,FIELD,0),"^",2)
 . D Y^DIQ
 . I Y'[RSLT S ERR=0
 S Y=ERR
 D CHKEQ^XTMUNIT(Y,0,"Y^DIQ Data Element Conversion Internal to External failed.")
 Q
 ;
 ;
 ;
TENDIQ1 ; @TEST - EN^DIQ1 Retrieve Data from a File for a Particular Entry
 ; Retrieve Data from a File for a Particular Entry
 ; DIQ1     EN^DIQ1: Data Retrieval
 ; VA FM PRG MAN 22.0 March 1999, Revised May 2011 2.3.44
 ;   (Equivalent DS are $$GETS^DIQ and $$GET1^DIQ
 ; Test Method:
 ;  1. Set file number to .85, record to 1
 ;     NOTE: Selecting FM file delivered with FM
 ;  2. Get file global from DIC
 ;  3. Pull "GL" nodes from the DD for this file and run through
 ;     each field number defined in DD
 ;  4. Check the results of the EN^DIQ1 call stored in the
 ;     ^UTILITY global against the data pulled directly from
 ;     the global node and piece defined in DD
 ;  5. Failure defined as any incidence of failure to match
 N FNMBR,RECORD,Y
 S FNMBR=.85,RECORD=1
 N ERR S ERR=0
 D TENDIQ1A(FNMBR,RECORD)
 S Y=ERR
 D CHKEQ^XTMUNIT(Y,0,"EN^DIQ1 Data from File for Particular Entry failed.")
 Q
 ;
TENDIQ1A(FNMBR,RECORD) N ANS1,ANS2,DA,DDNODE,DIC,DIQ,DR,FIELD,GLOBAL,NODE,PIECE,POO,SDNODE
 D PULLDD(FNMBR,.POO)
 N GLBL S GLBL=^DIC(FNMBR,0,"GL")
 S DDNODE=$NA(POO(FNMBR,"GL")),SDDNODE=$P(DDNODE,")")
 F  S DDNODE=$Q(@DDNODE) Q:DDNODE'[SDDNODE  D
 .  S NODE=$QS(DDNODE,3)
 .  S PIECE=$QS(DDNODE,4)
 .  S FIELD=$QS(DDNODE,5)
 .  K ^UTILITY("DIQ1",$J)
 .  S DIC=FNMBR,DA=RECORD,DR=FIELD,DIQ(0)="I" D EN^DIQ1
 .  S ANS1=$G(^UTILITY("DIQ1",$J,FNMBR,RECORD,FIELD,"I"))
 .  S GLOBAL=GLBL_RECORD_","_NODE_")"
 .  I NODE'=0,'NODE S GLOBAL=GLBL_RECORD_","""_NODE_""")"
 .  I $D(@$NA(@GLOBAL))#2 D
 ..  I PIECE S ANS2=$P(@$NA(@GLOBAL),"^",PIECE)
 ..  E  S ANS2=@$NA(@GLOBAL)
 ..  I ANS1'=ANS2 S ERR=1
 Q
 ;
 ;
 ; Build array of randome dates
 ; Returns such as : XDATA(n)=2451209.212358
MKDTARR(XDATA,NMBR) ;
 K XDATA
 N X,Y,Z,STRTYR,YEAR,DAY,HOURS,MINS,MONTH,SECS
 S STRTYR=150
 F Z=1:1:NMBR D
 .  S YEAR=STRTYR+$R(200)
 .  S MONTH=$TR($J($R(12)+1,2)," ","0")
 .  S DAY=$TR($J($R(28)+1,2)," ","0")
 .  S HOURS=$TR($J($R(24),2)," ","0")
 .  S MINS=$TR($J($R(60),2)," ","0")
 .  S SECS=$TR($J($R(60),2)," ","0") S:SECS="00" SECS=""
 .  S YEAR=YEAR_MONTH_DAY_"."_HOURS_MINS_SECS
 .  S XDATA(Z)=YEAR
 S X="FEB 29, 2000" D ^%DT S $P(XDATA(Z-3),".")=Y
 S X="FEB 29, 2012" D ^%DT S $P(XDATA(Z-2),".")=Y
 Q
 ;
 ; INTWRAP pulled directly from DMUDT000 in case each unit test
 ;  routine needs to be independent of any other
INTWRAP(CMD,ARR) ; Interactive Prompt Wrapper. Write prompt to file and read back
 ; CMD is command to execute by value
 ; ARR Return Array pass by reference. New before passing as we only add contents here.
 N F S F="test"_$J_".txt"
 D OPEN^%ZISH("FILE",$$DEFDIR^%ZISH(),F,"W") ; Write mode
 U IO
 X CMD
 D CLOSE^%ZISH("FILE")
 D OPEN^%ZISH("FILE",$$DEFDIR^%ZISH(),F,"R") ; Read mode
 U IO
 N I F I=1:1 R ARR(I):0 Q:$$STATUS^%ZISH()   ; Read until $ZEOF
 D CLOSE^%ZISH("FILE")
 N DELARR S DELARR(F)=""
 N % S %=$$DEL^%ZISH($$DEFDIR^%ZISH(),$NA(DELARR)) ; Delete file
 U $P
 QUIT
 ;
 ; Build an array matching all of a file and subfile's
 ;  "GL" subscripted nodes
 ; Enter with
 ;   STUB  = a parent file number (e.g. 2, 200, .403)
 ;   PDD   = the name of the array to return
 ; Exits with
 ;   Array named in PDD
PULLDD(STUB,PDD) K PDD N NODE S NODE="^DD("_STUB_")"
 F  S NODE=$Q(@NODE) Q:$QS(NODE,1)'=STUB  D
 .  I $QS(NODE,2)="GL" S @$TR(NODE,"^","P")=""
 .  I $QS(NODE,2)="SB" D PD($QS(NODE,3))
 Q
 ;
PD(STUB) N NODE S NODE="^DD("_STUB_")"
 F  S NODE=$Q(@NODE) Q:$QS(NODE,1)'=STUB  D
 .  I $QS(NODE,2)="GL" S @$TR(NODE,"^","P")=""
 .  I $QS(NODE,2)="SB" D PD($QS(NODE,3))
 Q
 ;
BLDIENS(QLBN,NODE) ;
 N IENS
 N I F I=QLBN:1:$QL(NODE) S:'(I#2) IENS=$QS(NODE,I)_","_$G(IENS)
 Q $G(IENS)
 ;
 ;;
X1DATA ;;
 ;;.84^1.2^13^VA FILEMAN^
 ;;.83^1^y^YES, NUMBER IS IN USE^
 ;;.83^1^n^NOT IN USE^
 ;;
