DMUDIC00 ; VEN/SMH - A few ^DIC API Unit Tests; 13 JAN 2013
 ;;22.2;VA FILEMAN;;Mar 28, 2013
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
 S IO=$PRINCIPAL
 N DIQUIET S DIQUIET=1
 D DT^DICRW
 D:$$VERSION^XPDUTL("DI")["22.2" EN^XTMUNIT($T(+0),1)
 QUIT
 ;
STARTUP ; Create files 1009.802 (Shadow State) and 1009.801 (Broken File)
 D ^DMUFINIT ; Customized by yours truly to be silent
 QUIT
 ;
SHUTDOWN ; Delete files 1009.802 and 1009.801 from the system
 N DIU F DIU=1009.801,1009.802 S DIU(0)="DT" D EN^DIU0 ; Data and DD; Templates too!
 QUIT
 ;
SETUP    ; Remove DBS Output and Variables
 D CLEAN^DILF ; Remove DBS variables from ST
 K ^TMP("DILIST",$J) ; Remove Output from DBS Server
 QUIT
 ;
 ;TEARDOWN ; Not used
 ;
FINDC ; @TEST - FIND^DIC with computed fields in return field list
 D FIND^DIC(1009.802,,"@;.01;1;COUNT(COUNTY)","","AL") ; Exercise computed fields.
 ; ^TMP("DILIST",26063,0)="3^*^0^"
 ; ^TMP("DILIST",26063,0,"MAP")=".01^1^C4"
 ; ^TMP("DILIST",26063,2,1)=1
 ; ^TMP("DILIST",26063,2,2)=2
 ; ^TMP("DILIST",26063,2,3)=100
 ; ^TMP("DILIST",26063,"ID",1,.01)="ALABAMA"
 ; ^TMP("DILIST",26063,"ID",1,1)="AL"
 ; ^TMP("DILIST",26063,"ID",1,"C4",1)=67
 ; ^TMP("DILIST",26063,"ID",2,.01)="ALASKA"
 ; ^TMP("DILIST",26063,"ID",2,1)="AK"
 ; ^TMP("DILIST",26063,"ID",2,"C4",1)=29
 ; ^TMP("DILIST",26063,"ID",3,.01)="ALBERTA"
 ; ^TMP("DILIST",26063,"ID",3,1)="AB"
 ; ^TMP("DILIST",26063,"ID",3,"C4",1)=1
 ;
 ; ZEXCEPT: DIERR ; Comes from the ST
 I $D(DIERR) D FAIL^XTMUNIT("Fileman errored.") QUIT
 ;
 N COUNTISZERO S COUNTISZERO=0
 ;
 N I F I=0:0 S I=$O(^TMP("DILIST",$J,"ID",I)) Q:'I  Q:COUNTISZERO  D
 . I ^TMP("DILIST",$J,"ID",I,"C4",1)=0 S COUNTISZERO=1
 ;
 D CHKEQ^XTMUNIT(COUNTISZERO,0,"Count of counties should be at least one")
 ;
FINDE ; @TEST - Find with "E" flag to return all results in spite of errors.
 ;
 ; This is my broken file. Let's see if we can return the entries without
 ; the "E" flag and then with the "E" flag.
 D FIND^DIC(1009.801,,"@;.01;.02;.03;.04;.05;.06","","BAD") ; Search for entries starting with "BAD"
 ;
 ; WATCH FOR NAKED REFERENCES
 N I F I=0:0 S I=$O(^TMP("DILIST",$J,"ID",I)) Q:'I  D
 . Q:^(I,.01)'="BAD POINTER"
 . D CHKEQ^XTMUNIT($D(^(.03)),0,".03 node is not supposed to exist")
 ;
 ; Do this again with the "E" flag
 D FIND^DIC(1009.801,,"@;.01;.02;.03;.04;.05;.06","E","BAD") ; Search for entries starting with "BAD"
 ;
 ; WATCH FOR NAKED REFERENCES
 N I F I=0:0 S I=$O(^TMP("DILIST",$J,"ID",I)) Q:'I  D
 . Q:^(I,.01)'="BAD POINTER"
 . D CHKEQ^XTMUNIT($D(^(.03)),1,".03 node supposed to exist")
 QUIT
 ;
LISTC ; @TEST - LIST^DIC with computed fields in the field list.
 ;
 D LIST^DIC(1009.802,,"@;.01;1;COUNT(COUNTY)")
 ;
 ; ZEXCEPT: DIERR ; Comes from the ST
 I $D(DIERR) D FAIL^XTMUNIT("Fileman errored.") QUIT
 ;
 N COUNTISZERO S COUNTISZERO=0
 ;
 N I F I=0:0 S I=$O(^TMP("DILIST",$J,"ID",I)) Q:'I  Q:COUNTISZERO  D
 . I ^TMP("DILIST",$J,"ID",I,"C4",1)=0 S COUNTISZERO=1
 ;
 D CHKEQ^XTMUNIT(COUNTISZERO,0,"Count of counties should be at least one")
 QUIT
 ;
LISTE ; @TEST - LIST^DIC with "E" flag to return all results in spite of errors.
 ;
 ; This is my broken file. Let's see if we can return the entries without
 ; the "E" flag and then with the "E" flag.
 D LIST^DIC(1009.801,,"@;.01;.02;.03;.04;.05;.06") ; Get all entries
 ;
 ; WATCH FOR NAKED REFERENCES
 N I F I=0:0 S I=$O(^TMP("DILIST",$J,"ID",I)) Q:'I  D
 . Q:^(I,.01)'="BAD POINTER"
 . D CHKEQ^XTMUNIT($D(^(.03)),0,".03 node is not supposed to exist")
 ;
 ; Do this again with the "E" flag
 D FIND^DIC(1009.801,,"@;.01;.02;.03;.04;.05;.06","E") ; Search for entries starting with "BAD"
 ;
 ; WATCH FOR NAKED REFERENCES
 N I F I=0:0 S I=$O(^TMP("DILIST",$J,"ID",I)) Q:'I  D
 . Q:^(I,.01)'="BAD POINTER"
 . D CHKEQ^XTMUNIT($D(^(.03)),1,".03 node supposed to exist")
 QUIT
 ;
LISTX1 ; @TEST - LIST^DIC with the new X flag -- Sort by Unindexed field
 D LIST^DIC(1009.802,,"@;.01;5",,,,,5) ; Try to sort by Capital (Unindexed); no X flag
 D CHKTF^XTMUNIT(^TMP("DILIST",$J,"ID",1,5)'="HARTFORD","Without X flag, first entry shouldn't be Hartford")
 ;
 D LIST^DIC(1009.802,,"@;.01;5","X",,,,5) ; Try again, this time with X
 D CHKTF^XTMUNIT(^TMP("DILIST",$J,"ID",1,5)="HARTFORD","With X flag, first entry should be Hartford")
 ;
 QUIT
 ;
LISTX2 ; @TEST - LIST^DIC with the new X flag -- Sort by Computed Expression
 D LIST^DIC(1009.802,,.01,"",,,,"COUNT(COUNTY)>100") ; Get all states with more than 100 counties
 D CHKTF^XTMUNIT(+^TMP("DILIST",$J,0)'=7,"We SHOULDN'T be getting 7 states sans the X flag")
 ;
 D LIST^DIC(1009.802,,.01,"X",,,,"COUNT(COUNTY)>100") ; Get all states with more than 100 counties
 D CHKEQ^XTMUNIT(+^TMP("DILIST",$J,0),7,"We expect 7 states with more than 100 counties")
 ;
 QUIT
 ;
LISTX3 ; @TEST - LIST^DIC with the new X flag -- Sort by Sort Template
 ; First, create the sort template
 N DMUST ; Holds Sort Template Text
 S DMUST(1)="SORT BY: -COUNT(COUNTY)" ; Sort by the reverse of number of counties
 S DMUST(2)="From:"
 S DMUST(3)="To:"
 S DMUST(4)="   WITHIN COUNT(COUNTY), SORT BY: $E(NAME,1,3)=""NEW""" ; Only get the States whose names start with NEW
 ;
 N RET ; RP style return reference variable
 D BUILDNEW^DIBTED(.RET,1009.802,$NA(DMUST),"DMU NEW STATES W MOST COUNTIES")
 ;
 D CHKTF^XTMUNIT($P(^DIBT(+RET,0),U)="DMU NEW STATES W MOST COUNTIES","Template not created correctly")
 ;
 D LIST^DIC(1009.802,,".01;COUNT(COUNTY)","",,,,"[DMU NEW STATES W MOST COUNTIES]")
 D CHKTF^XTMUNIT(+$G(^TMP("DILIST",$J,0))'=6,"6 states' names start with NEW, but template not used")
 ;
 D LIST^DIC(1009.802,,".01;COUNT(COUNTY)","X",,,,"[DMU NEW STATES W MOST COUNTIES]")
 D CHKEQ^XTMUNIT(+^TMP("DILIST",$J,0),6,"6 states' names start with NEW")
 D CHKEQ^XTMUNIT(^TMP("DILIST",$J,"ID",1,.01),"NEW YORK","Of the ""NEW"" states, New York has the most counties")
 QUIT
