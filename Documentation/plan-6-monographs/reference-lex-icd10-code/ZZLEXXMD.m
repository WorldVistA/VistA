ZZLEXXMD ;SLC/KER - Import - Misc - Code Totals ;10/26/2017
 ;;1.0;Generic Utility;**1**;Sep 23, 1996
 ;               
 ; Global Variables
 ;    ^ICD0(              ICR   4486
 ;    ^ICD9(              ICR   4485
 ;    ^LEX(757.03,        SACC 1.3
 ;    ^ZZLEXX("ZZLEXXMD"  SACC 1.3
 ;               
 ; External References
 ;    HOME^%ZIS           ICR  10086
 ;    ^%ZTLOAD            ICR  10063
 ;    $$GET1^DIQ          ICR   2056
 ;    $$DT^XLFDT          ICR  10103
 ;               
 ; Update Coding Systems file #757.03
 ;
 ;   Field #4  ACTIVE CODES   0;5  
 ;   Field #5  CODES          0;6
 ;                                           |           |
 ; ^LEX(757.03,30,0)=SAB^NOM^Title^SDO^Active Codes^Total Codes
 ; ^LEX(757.03,31,0)=SAB^NOM^Title^SDO^Active Codes^Total Codes
 ;   
EN ; Main Entry Point
 N CONT,ENV,CHK S ENV=$$ENV Q:ENV'>0  S CHK=1 I '$D(QUIET) D
 . W:$L(IOF) @IOF
 . W !,?1,"Updating the Coding Systems file #757.03 with the total number"
 . W !,?1,"of codes and the total number of active codes for ICD-10-CM"
 . W !,?1,"Diagnosis and ICD-10-PCS Procedures",!
 N QUIET S QUIET=1 D ICD S QUIET=1 D ICP S:'$D(DONE) CONT=$$CONT^ZZLEXX K QUIET N DONE
 Q
ICD ;   Update ICD Diagnosis
 S:+($G(CHK))'>0 ENV=$$ENV I +($G(CHK))'>0,+ENV'>0 Q
 I $D(^ZZLEXX("ZZLEXXMD",$J)) W !,?4,"Update Coding Systems file #757.03 ICD-10 Diagnosis in progress" Q
 S ZTRTN="ICDT^ZZLEXXMD" S ZTDESC="Update Coding Systems file #757.03 ICD-10 Diagnosis",ZTIO="",ZTDTH=$H D ^%ZTLOAD
 I '$D(QUIET),+($G(ZTSK))>0 W !,?4,"Update Coding Systems file #757.03 ICD-10 Diagnosis tasked (",+($G(ZTSK)),")"
 D HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTQUEUED,ZTREQ,QUIET N TEST
 Q
ICDT ;     Update ICD Diagnosis (TASK)
 S:$D(ZTQUEUED) ZTREQ="@" K ^ZZLEXX("ZZLEXXMD",$J,"DIA")
 N ACT,INA,ORD,TD,TOT S TD=$$DT^XLFDT,ORD="" F  S ORD=$O(^ICD9("ABA",30,ORD)) Q:'$L(ORD)  D
 . N SIEN S SIEN=0 F  S SIEN=$O(^ICD9("ABA",30,ORD,SIEN)) Q:+SIEN'>0  D
 . . N CODE,EFF,HIS,STA S CODE=$P($G(^ICD9(+SIEN,0)),"^",1)
 . . S EFF=$O(^ICD9(SIEN,66,"B",9999999),-1)
 . . S HIS=$O(^ICD9(SIEN,66,"B",+EFF," "),-1)
 . . S STA=$G(^ICD9(+SIEN,66,+HIS,0)),STA=$P(STA,"^",2)
 . . S:+STA>0 ^ZZLEXX("ZZLEXXMD",$J,"DIA","ACT",(CODE_" "))=""
 . . S:+STA'>0 ^ZZLEXX("ZZLEXXMD",$J,"DIA","INA",(CODE_" "))=""
 . . S ^ZZLEXX("ZZLEXXMD",$J,"DIA","TOT",(CODE_" "))=""
 S TOT=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXMD",$J,"DIA","TOT",ORD)) Q:'$L(ORD)  S TOT=TOT+1
 S INA=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXMD",$J,"DIA","INA",ORD)) Q:'$L(ORD)  S INA=INA+1
 S ACT=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXMD",$J,"DIA","ACT",ORD)) Q:'$L(ORD)  S ACT=TOT+1
 I '$D(ZTQUEUED) W ! D
 . W !," ICD-10-CM Diagnosis codes:",!
 . W !,?5,"Active Codes",?20,$J($G(ACT),6)
 . W !,?5,"Inactive Codes",?20,$J($G(INA),6)
 . W !,?5,"Total Codes",?20,$J($G(TOT),6)
 I +($G(TOT))>0,+($G(ACT))>0  D
 . S $P(^LEX(757.03,+30,0),"^",5)=+($G(ACT))
 . S $P(^LEX(757.03,+30,0),"^",6)=+($G(TOT))
 K ^ZZLEXX("ZZLEXXMD",$J,"DIA")
 Q
ICP ;   Update ICD Procedures
 S:+($G(CHK))'>0 ENV=$$ENV I +($G(CHK))'>0,+ENV'>0 Q
 I $D(^ZZLEXX("ZZLEXXMD",$J)) W !,?4,"Update Coding Systems file #757.03 ICD-10 Procedures in progress" Q
 S ZTRTN="ICPT^ZZLEXXMD" S ZTDESC="Update Coding Systems file #757.03 ICD-10 Procedures",ZTIO="",ZTDTH=$H D ^%ZTLOAD
 I '$D(QUIET),+($G(ZTSK))>0 W !,?4,"Update Coding Systems file #757.03 ICD-10 Procedures tasked (",+($G(ZTSK)),")"
 D HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTQUEUED,ZTREQ,QUIET N TEST
 Q
ICPT ;     Update ICD Procedures (TASK)
 S:$D(ZTQUEUED) ZTREQ="@" K ^ZZLEXX("ZZLEXXMD",$J,"PRO")
 N ACT,INA,ORD,TD,TOT S TD=$$DT^XLFDT,ORD="" F  S ORD=$O(^ICD0("ABA",31,ORD)) Q:'$L(ORD)  D
 . N SIEN S SIEN=0 F  S SIEN=$O(^ICD0("ABA",31,ORD,SIEN)) Q:+SIEN'>0  D
 . . N CODE,EFF,HIS,STA S CODE=$P($G(^ICD0(+SIEN,0)),"^",1)
 . . S EFF=$O(^ICD0(SIEN,66,"B",9999999),-1)
 . . S HIS=$O(^ICD0(SIEN,66,"B",+EFF," "),-1)
 . . S STA=$G(^ICD0(+SIEN,66,+HIS,0)),STA=$P(STA,"^",2)
 . . S:+STA>0 ^ZZLEXX("ZZLEXXMD",$J,"PRO","ACT",(CODE_" "))=""
 . . S:+STA'>0 ^ZZLEXX("ZZLEXXMD",$J,"PRO","INA",(CODE_" "))=""
 . . S ^ZZLEXX("ZZLEXXMD",$J,"PRO","TOT",(CODE_" "))=""
 S TOT=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXMD",$J,"PRO","TOT",ORD)) Q:'$L(ORD)  S TOT=TOT+1
 S INA=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXMD",$J,"PRO","INA",ORD)) Q:'$L(ORD)  S INA=INA+1
 S ACT=0,ORD="" F  S ORD=$O(^ZZLEXX("ZZLEXXMD",$J,"PRO","ACT",ORD)) Q:'$L(ORD)  S ACT=TOT+1
 I '$D(ZTQUEUED) W ! D
 . W !," ICD-10-CM Procedure codes:",!
 . W !,?5,"Active Codes",?20,$J($G(ACT),6)
 . W !,?5,"Inactive Codes",?20,$J($G(INA),6)
 . W !,?5,"Total Codes",?20,$J($G(TOT),6)
 I +($G(TOT))>0,+($G(ACT))>0  D
 . S $P(^LEX(757.03,+31,0),"^",5)=+($G(ACT))
 . S $P(^LEX(757.03,+31,0),"^",6)=+($G(TOT))
 K ^ZZLEXX("ZZLEXXMD",$J,"PRO")
 Q
 ; 
 ; Miscellaneous
ZERO ;   Zero out totals
 S $P(^LEX(757.03,30,0),"^",5)=0,$P(^LEX(757.03,30,0),"^",6)=0
 S $P(^LEX(757.03,31,0),"^",5)=0,$P(^LEX(757.03,31,0),"^",6)=0
 Q
ENV(X) ;   Check environment
 N USR S DT=$$DT^XLFDT D HOME^%ZIS S U="^" I +($G(DUZ))=0 Q 0
 S USR=$$GET1^DIQ(200,(DUZ_","),.01) I '$L(USR) Q 0
 Q 1
