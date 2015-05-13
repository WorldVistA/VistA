ZZRGUT3 ;RGI/VSL - Unit Tests - Problem List ;3/28/13
 ;;1.0;UNIT TEST;;Apr 25, 2012;Build 1;
 Q:$T(^GMPLAPI1)=""
 TSTART
 I $T(EN^%ut)'="" D EN^%ut("ZZRGUT3")
 TROLLBACK
 Q
 ;
STARTUP ;
 S U="^"
 S DT=$P($$HTFM^XLFDT($H),".")
 S LSTNAME="List"_DT
 S CATNAME="Diabetes "_DT
 S LOC=$P(^SC(0),U,3)
 S USER="1"
 F IN=1:1:10 S %=$$NEWLST^GMPLAPI1(.RET,"TestList"_IN)
 F IN=1:1:10 S %=$$NEWCAT^GMPLAPI1(.RET,"TestCateg"_IN)
 D ADDLIST(.LIST)
 S LSTCNT=$P(^GMPL(125,0),U,4)
 S LSTLAST=$P(^GMPL(125,0),U,3)
 S LSTCLAST=$P(^GMPL(125.1,0),U,3)
 S CATCNT=$P(^GMPL(125.11,0),U,4)
 S CATLAST=$P(^GMPL(125.11,0),U,3)
 S PROBLAST=$P(^GMPL(125.12,0),U,3)
 S %=$$ASSUSR^GMPLAPI6(.RETURN,LSTLAST,DUZ)
 Q
 ;
SETUP ;
 Q
 ;
SHUTDOWN ;
 Q
 ;
ADDLIST(RETURN) ;
 N NLST,NCAT
 S TARGET="^TMP(""GMPLLST"",$J)"
 S %=$$NEWLST^GMPLAPI1(.NLST,LSTNAME,LOC)
 S %=$$NEWCAT^GMPLAPI1(.NCAT,CATNAME)
 N TARGET K ^TMP("GMPLLST",$J)
 S ^TMP("GMPLLST",$J,0)=1
 S ^TMP("GMPLLST",$J,"0001N")="1^33572^Diabetes Insipidus^253.5"
 M TARGET=^TMP("GMPLLST",$J)
 S %=$$SAVGRP^GMPLAPI1(.RETURN,+NCAT,.TARGET)
 K ^TMP("GMPLIST",$J)
 S TARGET="^TMP(""GMPLIST"",$J)"
 S ^TMP("GMPLIST",$J,0)=1
 S ^TMP("GMPLIST",$J,"0001N")="1"_U_NCAT_U_"1"
 M TARGET=^TMP("GMPLIST",$J)
 S %=$$SAVLST^GMPLAPI1(.RETURN,+NLST,.TARGET)
 S RETURN("LST")=NLST
 S RETURN("CAT")=NCAT
 Q
 ;
GETCAT ;
 N RETURN
 K:$D(RETURN) RETURN
 S RET=$$GETCAT^GMPLAPI1(.RETURN,CATLAST+1)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("CTGNFND",$P(RETURN(0),U,1),"CTGNFND expected")
 ;
 K:$D(RETURN) RETURN
 S RET=$$GETCAT^GMPLAPI1(.RETURN)
 D CHKEQ^%ut(0,RET,"Incorrect return.")
 D CHKEQ^%ut("INVPARAM",$P(RETURN(0),U,1),"INVPARAM expected")
 ;
 K:$D(RETURN) RETURN
 S RET=$$GETCAT^GMPLAPI1(.RETURN,+LIST("CAT"))
 D CHKEQ^%ut(1,RET,"Incorrect return.")
 D CHKEQ^%ut(1,RETURN(0),"Incorrect rows number.")
 D CHKEQ^%ut("1^33572^Diabetes Insipidus^253.5",RETURN(PROBLAST),"Incorrect problem.")
 D CHKEQ^%ut("253.5^0",RETURN(PROBLAST,"CODE"),"Incorrect problem code.")
 D CHKEQ^%ut(CATNAME,RETURN("CAT","NAME"),"Incorrect category name.")
 D CHKEQ^%ut(DT_U_$$FMTE^XLFDT(DT),RETURN("CAT","MODIFIED"),"Incorrect modified date.")
 Q
 ;
GETLST ;
 K:$D(RETURN) RETURN
 S RET=$$GETLIST^GMPLAPI1(.RETURN,LSTLAST+1)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("LISTNFND",$P(RETURN(0),U,1),"LISTNFND expected.")
 ;
 K:$D(RETURN) RETURN
 S RET=$$GETLIST^GMPLAPI1(.RETURN)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("INVPARAM",$P(RETURN(0),U,1),"INVPARAM expected.")
 ;
 K:$D(RETURN) RETURN
 S RET=$$GETLIST^GMPLAPI1(.RETURN,LIST("LST"))
 D CHKEQ^%ut(1,RET,"Incorrect return.")
 D CHKEQ^%ut(1,RETURN(0),"Incorrect rows number.")
 D CHKEQ^%ut("1^"_LIST("CAT")_"^1",RETURN(LSTCLAST),"Incorrect category data.")
 D CHKEQ^%ut(LSTCLAST,RETURN("GRP",+LIST("CAT")),"Incorrect category IFN.")
 D CHKEQ^%ut("Diabetes Insipidus^253.5^0^33572",RETURN("GRP",+LIST("CAT"),1),"Incorrect problem.")
 D CHKEQ^%ut(LSTNAME,RETURN("LST","NAME"),"Incorrect list name.")
 D CHKEQ^%ut(DT_U_$$FMTE^XLFDT(DT),RETURN("LST","MODIFIED"),"Incorrect modified date.")
 D CHKEQ^%ut(LOC_U_$P(^SC(LOC,0),U,1),RETURN("LST","CLINIC"),"Incorrect clinic.")
 Q
 ;
GETCATD ;
 K:$D(RETURN) RETURN
 S RET=$$GETCATD^GMPLAPI5(.RETURN,CATLAST+1)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("CTGNFND",$P(RETURN(0),U,1),"CTGNFND expected")
 ;
 K:$D(RETURN) RETURN
 S RET=$$GETCATD^GMPLAPI5(.RETURN)
 D CHKEQ^%ut(0,RET,"Incorrect return.")
 D CHKEQ^%ut("INVPARAM",$P(RETURN(0),U,1),"INVPARAM expected")
 ;
 K:$D(RETURN) RETURN
 S RET=$$GETCATD^GMPLAPI5(.RETURN,+LIST("CAT"))
 D CHKEQ^%ut(1,RET,"Incorrect return.")
 D CHKEQ^%ut("Diabetes Insipidus^253.5^0^33572",RETURN("GRP",CATLAST,1),"Incorrect problem.")
 Q
 ;
GETLSTS ;
 N RETURN,CNT,LIST
 S %=$$GETLSTS^GMPLAPI5(.RETURN)
 D CHKEQ^%ut(LSTCNT_U_"*"_U_"0"_U,RETURN(0),"Incorrect number of lists.")
 S CNT=0,IFN=0
 F  S DA=$O(^GMPL(125,"B",DA)) Q:$G(DA)=""  D
 . F  S IFN=$O(^GMPL(125,"B",DA,IFN)) Q:IFN'>0  D
 . . S CNT=CNT+1
 . . D CHKEQ^%ut(IFN,RETURN(CNT,"ID"),"Incorrect list IFN.")
 . . D CHKEQ^%ut($P(^GMPL(125,IFN,0),U,1),RETURN(CNT,"NAME"),"Incorrect list name.")
 ;
 K RETURN N START
 S %=$$GETLSTS^GMPLAPI5(.RETURN,"TestList",.START,3)
 D CHKEQ^%ut("3"_U_"3"_U_"1"_U,RETURN(0),"Incorrect number of lists.")
 Q
 ;
GETCATS ;
 N RETURN,CNT,LIST
 S %=$$GETCATS^GMPLAPI5(.RETURN)
 D CHKEQ^%ut(CATCNT_U_"*"_U_"0"_U,RETURN(0),"Incorrect number of categories.")
 S CNT=0,IFN=0
 F  S DA=$O(^GMPL(125.11,"B",DA)) Q:$G(DA)=""  D
 . F  S IFN=$O(^GMPL(125.11,"B",DA,IFN)) Q:IFN'>0  D
 . . S CNT=CNT+1
 . . D CHKEQ^%ut(IFN,RETURN(CNT,"ID"),"Incorrect category IFN.")
 . . D CHKEQ^%ut($P(^GMPL(125.11,IFN,0),U,1),RETURN(CNT,"NAME"),"Incorrect category name.")
 ;
 K RETURN N START
 S %=$$GETCATS^GMPLAPI5(.RETURN,"TestCateg",.START,3)
 D CHKEQ^%ut("3"_U_"3"_U_"1"_U,RETURN(0),"Incorrect number of categories.")
 Q
 ;
GETUSRS ;
 N RETURN,CNT,LIST
 S %=$$GETUSRS^GMPLAPI5(.RETURN)
 D CHKEQ^%ut($P(^VA(200,0),U,4)_U_"*"_U_"0"_U,RETURN(0),"Incorrect number of users")
 S CNT=0,IFN=0
 F  S DA=$O(^VA(200,"B",DA)) Q:$G(DA)=""  D
 . F  S IFN=$O(^VA(200,"B",DA,IFN)) Q:IFN'>0  D
 . . S CNT=CNT+1
 . . D CHKEQ^%ut(IFN,RETURN(CNT,"ID"),"Incorrect user IFN.")
 . . D CHKEQ^%ut($P(^VA(200,IFN,0),U,1),RETURN(CNT,"NAME"),"Incorrect user name.")
 . . D CHKEQ^%ut($P($G(^VA(200,IFN,0)),U,2),$G(RETURN(CNT,"INITIAL")),"Incorrect user initial name.")
 . . D CHKEQ^%ut($G(^VA(200,IFN,".15")),$G(RETURN(CNT,"EMAIL")),"Incorrect user email address.")
 ;
 Q
 ;
GETASUSR ;
 N RETURN,CNT,LIST,ASCNT
 S RET=$$GETASUSR^GMPLAPI5(.RETURN)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("INVPARAM^Invalid parameter value - GMPLLST",RETURN(0),"INVPARAM - GMPLLST expected.")
 ;
 K RETURN
 S RET=$$GETASUSR^GMPLAPI5(.RETURN,LSTLAST+1)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("LISTNFND",$P(RETURN(0),U,1),"LISTNFND expected.")
 ;
 K RETURN
 S %=$$GETASUSR^GMPLAPI5(.RETURN,LSTLAST)
 S CNT=0,IFN=0,ASCNT=0
 F  S DA=$O(^VA(200,"B",DA)) Q:$G(DA)=""  D
 . F  S IFN=$O(^VA(200,"B",DA,IFN)) Q:IFN'>0  D
 . . S CNT=CNT+1
 . . Q:$P($G(^VA(200,IFN,125)),U,2)'=LSTLAST
 . . S ASCNT=ASCNT+1
 . . D CHKEQ^%ut(IFN,RETURN(ASCNT,"ID"),"Incorrect user IFN.")
 . . D CHKEQ^%ut($P(^VA(200,IFN,0),U,1),RETURN(ASCNT,"NAME"),"Incorrect user name.")
 D CHKEQ^%ut(ASCNT,RETURN(0),"Incorrect number of categories.")
 ;
 Q
 ;
GETCLIN ;
 N RETURN,CNT,LIST
 S %=$$GETCLIN^GMPLAPI5(.RETURN)
 S CNT=0,IFN=0
 F  S DA=$O(^SC("B",DA)) Q:$G(DA)=""  D
 . F  S IFN=$O(^SC(DA,IFN)) Q:IFN'>0  D
 . . S CNT=CNT+1
 . . D CHKEQ^%ut(IFN,RETURN(CNT,"ID"),"Incorrect location IFN.")
 . . D CHKEQ^%ut($P(^SC(IFN,0),U,1),RETURN(CNT,"NAME"),"Incorrect location name.")
 ;
 Q
 ;
ADDLOC ;
 N RETURN,RET
 S RET=$$ADDLOC^GMPLAPI5(.RETURN,LSTLAST,)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("INVPARAM^Invalid parameter value - GMPLLOC",RETURN(0),"INVPARAM - GMPLLOC expected.")
 ;
 K RETURN
 S RET=$$ADDLOC^GMPLAPI5(.RETURN,,LOC+1)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("INVPARAM^Invalid parameter value - GMPLLST",RETURN(0),"INVPARAM - GMPLLST expected.")
 ;
 K RETURN
 S RET=$$ADDLOC^GMPLAPI5(.RETURN,LSTLAST+1,LOC+1)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("LISTNFND",$P(RETURN(0),U,1),"LISTNFND expected.")
 ;
 K RETURN
 S RET=$$ADDLOC^GMPLAPI5(.RETURN,LSTLAST,LOC+1)
 D CHKEQ^%ut(0,RET,"Incorrect return")
 D CHKEQ^%ut("LOCNFND",$P(RETURN(0),U,1),"LOCNFND expected.")
 ;
 K RETURN
 S RET=$$ADDLOC^GMPLAPI5(.RETURN,LSTLAST,LOC)
 D CHKEQ^%ut(1,RET,"Incorrect return")
 D CHKEQ^%ut($P(^GMPL(125,LSTLAST,0),U,3),LOC,"Location not assigned.")
 ;
 Q
 ;
XTENT ;
 ;;GETCAT;Get category
 ;;GETLST;Get list
 ;;GETCATD;Get category details
 ;;GETLSTS;Get lists
 ;;GETCATS;Get categories
 ;;GETUSRS;Get users
 ;;GETCLIN;Get locations
 ;;ADDLOC;Add location to list
 ;;GETASUSR;Get users assigned list
 Q
