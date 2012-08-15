%ZTLOAD1 ;SEA/RDS-TaskMan: P I: Queue ;09/23/08  10:06
 ;;8.0;KERNEL;**112,118,127,162,275,363,409,415,425,446,LOCAL**;Jul 10, 1995;Build 35
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
GET ;get task data
 N %X,%Y,X,Y,X1,ZT,ZTC1,ZTC2,ZTA1,ZTA4,ZTA5,ZTINC,ZTGOT,ZTC34P
 K %ZTLOAD
 I ("^"[$G(ZTRTN))!($L($G(ZTRTN),"^")>2) D REJECT^%ZTLOAD2("Bad Routine") G EXIT
 S U="^" I ZTRTN'[U S ZTRTN=U_ZTRTN
 S ZTC1=+$G(DUZ),ZTC2=""
 I ZTC1>0 S ZTC2=$P($G(^VA(200,ZTC1,0)),U)
 ;Check Date/Time
1 I $D(ZTDTH)[0 S ZTDTH=""
 I ZTDTH?7N.".".N S ZTDTH=$$FMTH^%ZTLOAD7(ZTDTH)
 I $P($G(XQY0),U,18) D RESTRCT^%ZTLOAD2
 I ZTDTH'="@",ZTDTH'?1.5N1","1.5N D ASK^%ZTLOAD2 I ZTDTH'>0 D REJECT^%ZTLOAD2("Bad Date/Time") G EXIT
 ;
 S ZTA1="R",ZTA4="",ZTA5=""
 I ZTRTN="ZTSK^XQ1" D OPTION^%ZTLOAD2 I ZTA1="" D REJECT^%ZTLOAD2("Bad Option") G EXIT
 I ZTA1="R" D
 . S ZTSAVE("XQY")="",ZTSAVE("XQY0")="",ZTA4=$G(XQY),ZTA5=$P($G(XQY0),U)
 ;
 D GETENV^%ZOSV S ZTC34P=Y
 ;Description
2 I $D(ZTDESC)[0 S ZTDESC="No Description (%ZTLOAD)"
 ;
 I $G(ZTKIL)]"" D ZTKIL^%ZTLOAD2
 S:$G(ZTUCI)["," ZTUCI=$P(ZTUCI,",") S:$G(ZTCPU)["," ZTCPU=$P(ZTCPU,",",2)
DEVICE ;get device data
 I $D(ZTIO)#2,$G(ION)=$P(ZTIO,";"),$G(IOT)="SPL" D SPOOL^%ZTLOAD2
 ;If no ZTIO, build from symbol table
 I $D(ZTIO)[0 S ZTIO=$G(ION) I $L(ZTIO) D
 . S:$G(IOST)]"" $P(ZTIO,";",2)=IOST
 . I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_IO("DOC")
 . E  I $G(IOM)]"" S ZTIO=ZTIO_";"_IOM I $G(IOSL)]"" S ZTIO=ZTIO_";"_IOSL
 . Q
 ;
 I $E(ZTIO,1)="`" S $P(ZTIO,";")=$P(^%ZIS(1,+$E(ZTIO,2,99),0),"^") ;Convert `IEN format
 S ZTIO(1)=$S($G(ZTIO(1))'="D":"Q",1:"DIRECT")
 I $L(ZTIO) D  ;Skip if no device
 . ;IO("HFSIO") and IOPAR are how %ZIS reports the user selected file name and parameters
 . S:'$D(ZTIO("H")) ZTIO("H")=$G(IO("HFSIO"))
 . S:'$D(ZTIO("P")) ZTIO("P")=$G(IOPAR)
 . I $G(IO("P"))]"",ZTIO'[";/" S ZTIO=ZTIO_";/"_IO("P")
 . I $$NOQ^%ZISUTL($P(ZTIO,";")) D BADDEV^%ZTLOAD2("Restricted Device")
 . I $E(ZTIO,1,9)="P-MESSAGE" S ZTSAVE("^TMP(""XM-MESS"",$J,")=""
 . Q
 ;
 I $D(%ZTLOAD("ERROR")) G EXIT
 ;
 ;See that ^%ZTSK(-1) is set
 I $D(^%ZTSK(-1))[0 S ^%ZTSK(-1)=$S($P($G(^%ZTSK(0)),U,3):$P(^(0),U,3),1:1000)
RECORD ;build record
 S ZTINC=$G(^%ZOSF("$INC"),1) ;Set to 1 if this system has $INCREMENT, otherwise 0.
 S ZTGOT=0
 I 'ZTINC D  ;For System that don't have $INC (GT.M, DTM, MSM)
 . ;Find a free entry, Claim it and Lock it.
 . L +^%ZTSK(-1):0 S ZTSK=^%ZTSK(-1) ;This is just a starting point
 . F  S ZTSK=ZTSK+1 I '$D(^%ZTSK(ZTSK)) D  Q:ZTGOT
 . . L +^%ZTSK(ZTSK):$G(DILOCKTM,3) Q:'$T  ;Can we lock it
 . . I $D(^%ZTSK(ZTSK)) L -^%ZTSK(ZTSK) ;Already claimed
 . . S ^%ZTSK(ZTSK,.1)=0,^%ZTSK(-1)=ZTSK,ZTGOT=1 ;Claim it
 . . Q
 . L -^%ZTSK(-1) ;
 . Q
 I ZTINC D  ;For DSM and OpenM. Faster over network(DDP)
 . S ZTSK=$INCREMENT(^%ZTSK(-1))
 . L +^%ZTSK(ZTSK):$G(DILOCKTM,3) S ZTGOT=$T ;p446
 I 'ZTGOT!($D(^%ZTSK(ZTSK,0))) L -^%ZTSK(ZTSK) G RECORD
 ;;  Begin ORIGINAL Code (OSEHRA/CJE) Remove Transaction Processing
 ;TSTART  ;
 ;;  END ORIGINAL Code(OSEHRA/CJE)
 S ^%ZTSK(ZTSK,0)=ZTRTN_U_ZTC1_U_$G(ZTUCI)_U_$H_U_ZTDTH_U_ZTA1_U_ZTA4_U_ZTA5_U_ZTC2_U_$P(ZTC34P,U,1,2)_U_"ZTDESC"_U_$G(ZTCPU)_U_$G(ZTPRI)
 S ^%ZTSK(ZTSK,.1)=0,^%ZTSK(ZTSK,.03)=ZTDESC
 S ^%ZTSK(ZTSK,.2)=ZTIO_"^^^^"_ZTIO(1)_U_$G(ZTIO("H")) S:$D(ZTSYNC) $P(^%ZTSK(ZTSK,.2),U,7)=ZTSYNC
 I $G(ZTIO("P"))]"" S ^%ZTSK(ZTSK,.25)=ZTIO("P")
 ;
 D ZTSAVE
 ;
SCHED ;schedule task and quit
 S ZTSTAT=$S(ZTDTH'="@":1,1:"K")_"^"_$H,$P(ZTSTAT,U,8)=$G(ZTKIL)
 S ^%ZTSK(ZTSK,.1)=ZTSTAT
 I ZTDTH'="@" L +^%ZTSCH("SCHQ"):$G(DILOCKTM,3) S ZT=$$H3(ZTDTH),^%ZTSK(ZTSK,.04)=ZT,^%ZTSCH(ZT,ZTSK)="" L -^%ZTSCH("SCHQ")
 L -^%ZTSK(ZTSK) S ZTSK("D")=ZTDTH
 ;;  Begin ORIGINAL Code (OSEHRA/CJE) Remove Transaction Processing
 ;TCOMMIT  ;
 ;;  END ORIGINAL Code(OSEHRA/CJE)
EXIT ;Clean up
 I $E($G(ZTIO),1,9)="P-MESSAGE" K ^TMP("XM-MESS",$J) ;Clean up the Global
 K X1,ZT,ZT1,ZTDTH,ZTKIL,ZTSAVE,ZTSTAT,ZTIO
 Q
 ;
ZTSAVE ;save variables
 N ZTIO
 K %H,%T,ZTA1,ZTA4,ZTA5,ZTC1,ZTC2,ZTC34P,ZTCPU,ZTDESC,ZTIO,ZTNOGO,ZTPRI,ZTRTN,ZTUCI,ZTSYNC
 S ZTSAVE("DUZ(")=""
 S ZT1="" F  S ZT1=$O(ZTSAVE(ZT1)) Q:ZT1=""  D EVAL
 K ^%ZTSK(ZTSK,.3,"DUZ(","NEWCODE")
 K ^%ZTSK(ZTSK,.3,"ZTSK"),^("ZTSAVE"),^("ZTDTH")
 K ^%ZTSK(ZTSK,.3,"XQNOGO")
 Q
 ;
EVAL ;ZTSAVE--evaluate expression
 I ZT1="*" S X="^%ZTSK(ZTSK,.3," D DOLRO^%ZOSV Q
 I ZT1["*",$P(ZT1,"*")'["(" S X="^%ZTSK(ZTSK,.3,",Y=ZT1 D ORDER^%ZOSV Q
 I $S($E(ZT1)="""":1,+ZT1'=ZT1:0,1:ZT1]0),$D(ZTSAVE(ZT1))#2 S @("^%ZTSK(ZTSK,"_ZT1_")=ZTSAVE(ZT1)") Q
 I $S(ZT1'["(":1,1:$E(ZT1,$L(ZT1))=")"),$S($D(@ZT1)#2:1,1:ZTSAVE(ZT1)]"") S ^%ZTSK(ZTSK,.3,ZT1)=$S(ZTSAVE(ZT1)]"":ZTSAVE(ZT1),1:@ZT1) Q
 I $E(ZT1)="^",ZT1["(" S %X=ZT1,%Y="^%ZTSK(ZTSK,.3,ZT1," D %XY^%RCR Q
 I ZT1["(" S %X=ZT1,%Y="^%ZTSK(ZTSK,.3,ZT1," D %XY^%RCR
 ;I ZT1["(" M ^%ZTSK(ZTSK,.3,ZT1)=@$P(ZT1,"(")
 Q
 ;
H3(%) ;Convert $H to seconds.
 Q 86400*%+$P(%,",",2)
H0(%) ;Covert from seconds to $H
 Q (%\86400)_","_(%#86400)
