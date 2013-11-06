DMUDTC00 ; VEN/SMH - Unit Test Driver for %DTC Utilities; 04-MAR-2013
 ;;22.2;VA FILEMAN;;Mar 28, 2013
 ;
 S IO=$PRINCIPAL
 N DIQUIET S DIQUIET=1
 D DT^DICRW
 D EN^XTMUNIT($T(+0),1)
 QUIT
 ;
 ;STARTUP  ; Not used
 ;SHUTDOWN ; Not used
 ;SETUP    ; Not used
 ;TEARDOWN ; Not used
 ;
%DTC ; @TEST - %DTC - Returns the number of days between two dates
 ; Input: X1 and X2
 ; Output: X (days difference) and %Y (1=valid dates; 0=invalid dates)
 N X1,X2,X,%Y
 S X1=3101112.22,X2=3101116.08
 D ^%DTC
 D CHKEQ^XTMUNIT(X,-4,"Difference between X1=3101112.22 and X2=3101116.08 is 4 days")
 D CHKEQ^XTMUNIT(%Y,1,"Dates are supposed to be valid")
 ;
 N X1,X2,X,%Y
 S X1=3101100,X2=3101116.08
 D ^%DTC
 D CHKEQ^XTMUNIT(%Y,0,"This difference of dates is uncomputable as an inexact date is used")
 ;
 N X1,X2,X,%Y
 S X1=3001231,X2=2991231
 D ^%DTC
 D CHKEQ^XTMUNIT(X,366,"Millenium year has 366 days")
 ;
 N X1,X2,X,%Y
 S X1=3011231,X2=3001231
 D ^%DTC
 D CHKEQ^XTMUNIT(X,365,"2001 has 365 days")
 ;
 N X1,X2,X,%Y
 S X1=3041231,X2=3031231
 D ^%DTC
 D CHKEQ^XTMUNIT(X,366,"2004 has 366 days")
 ;
 N X1,X2,X,%Y
 S X1=4001231,X2=3991231
 D ^%DTC
 D CHKEQ^XTMUNIT(X,365,"2100 has 365 days")
 ;
 N X1,X2,X,%Y
 S X1=4501231,X2=2991231 ; 151 years. Check for numeric overflows.
 D ^%DTC
 D CHKEQ^XTMUNIT(X,365.24*151\1+1,"Numeric overflow")
 ;
 QUIT
 ;
C ; @TEST - C^%DTC - Adds and subtracts dates
 ; Input: X1 = Start Date, X2= Number of days to add or remove
 ; X is the output. %H -> Horolog value
 N X,X1,X2,%H
 S X1=3101229.103139,X2=-2
 D C^%DTC
 D CHKEQ^XTMUNIT(X,3101227.103139,"2 days weren't subtracted correctly")
 N LASTH S LASTH=%H
 N %H,%T,%Y
 D H^%DTC ; Input is X
 D CHKEQ^XTMUNIT(%H,LASTH,"Horolog conversion failed")
 D CHKEQ^XTMUNIT(%T,(10*60*60)+(31*60)+39,"Seconds since mid conversion failed")
 ;
 N X,X1,X2,%H
 S X1=3101229.103139,X2=3
 D C^%DTC
 D CHKEQ^XTMUNIT(X,3110101.103139,"3 days weren't added correctly")
 N LASTH S LASTH=%H
 N %H,%T,%Y
 D H^%DTC ; Input is X
 D CHKEQ^XTMUNIT(%H,LASTH,"Horolog conversion failed")
 D CHKEQ^XTMUNIT(%T,(10*60*60)+(31*60)+39,"Seconds since mid conversion failed")
 QUIT
COMMA ; @TEST - COMMA^%DTC - Format the number with a comma
 ; Input: X - Number you want to format. X2 = Number of decimal digits.
 ; Append $ to X2 to output a dollar amount.
 ; Input: X3 - Length of desired output. 12 characters if not specified.
 ; Output: X
 ;
 N X,X2,X3
 S X="123332.229" D COMMA^%DTC
 D CHKEQ^XTMUNIT($L(X),12,"Default length is wrong")
 D CHKEQ^XTMUNIT(X," 123,332.23 ","Comma value is wrong")
 ;
 N X,X2,X3
 S X="123332.229",X2=1 D COMMA^%DTC
 D CHKEQ^XTMUNIT($L(X),12,"Default length is wrong 2")
 D CHKEQ^XTMUNIT(X,"  123,332.2 ","Comma value is wrong 2")
 ;
 N X,X2,X3
 S X="123332.2291",X2="3$" D COMMA^%DTC
 D CHKEQ^XTMUNIT($L(X),13,"Default length is wrong 3")
 D CHKEQ^XTMUNIT(X,"$123,332.229 ","Comma value is wrong 3")
 ;
 N X,X2,X3
 S X="123332.2291",X2="3$",X3=15 D COMMA^%DTC
 D CHKEQ^XTMUNIT($L(X),15,"Length isn't 15")
 D CHKEQ^XTMUNIT(X,"  $123,332.229 ","Comma value is wrong 4")
 ;
 N X,X2,X3
 S X="123.22",X2="3$" D COMMA^%DTC
 D CHKEQ^XTMUNIT($L(X),12,"Default length is wrong 5")
 D CHKEQ^XTMUNIT(X,"   $123.220 ","Comma value is wrong 5")
 ;
 N X,X2,X3
 S X="ABCDEDFGHIJK",X2=1 D COMMA^%DTC
 D CHKEQ^XTMUNIT($L(X),12,"Default length is wrong 6")
 D CHKEQ^XTMUNIT(X,"        0.0 ","Comma value is wrong 6")
 QUIT
 ;
DW ; @TEST - DW^%DTC - Return the day of week
 ; Input: X - FM Date
 ; Output: %H - $H date, %T - Seconds since midnight,
 ;   %Y: Numeric Day of Week, X: Alpha day of week
 N X,%H,%T,%Y
 S X="3121228.224422" D DW^%DTC
 D CHKEQ^XTMUNIT(X,"FRIDAY","28DEC2012 is a Friday")
 D CHKEQ^XTMUNIT(%H,"62819","Horolog not correctly translated")
 D CHKEQ^XTMUNIT(%T,(22*60*60)+(44*60)+22,"Number of seconds since midnight incorrect")
 D CHKEQ^XTMUNIT(%Y,5,"Should be 5 for Friday")
 ;
 N X,%H,%T,%Y
 S X="3100000" D DW^%DTC
 D CHKEQ^XTMUNIT(X,"","Imprecise date - should be null")
 D CHKEQ^XTMUNIT(%H,"61727","Horolog not correctly translated 2")
 D CHKEQ^XTMUNIT(%T,0,"Imprecise date - seconds should be zero")
 D CHKEQ^XTMUNIT(%Y,-1,"Imprecise date - %Y should be -1")
 ;
 N X,%H,%T,%Y
 S X="ABCDEF" D DW^%DTC
 D CHKEQ^XTMUNIT(X,"","Invalid input - empty string expected")
 D CHKEQ^XTMUNIT(%H,0,"Invalid input - %H should be 0")
 D CHKEQ^XTMUNIT(%T,0,"Invalid input - %T should be 0")
 D CHKEQ^XTMUNIT(%Y,-1,"Invalid input - %Y should be -1")
 ;
 N X,%H,%T,%Y
 S X=5 D DW^%DTC
 D CHKEQ^XTMUNIT(X,"","Invalid input - empty string expected")
 D CHKEQ^XTMUNIT(%H,0,"Invalid input - %H should be 0")
 D CHKEQ^XTMUNIT(%T,0,"Invalid input - %T should be 0")
 D CHKEQ^XTMUNIT(%Y,-1,"Invalid input - %Y should be -1")
 QUIT
 ;
H ; @TEST - H^%DTC - Convert an FM Date to a $H format date/time
 ; Input: X - FM Date
 ; Output: %H - $H date, %T - Seconds since midnight,
 ;   %Y: Numeric Day of Week
 N X,%H,%T,%Y
 S X="3121228.224422" D H^%DTC
 D CHKEQ^XTMUNIT(%H,"62819","Horolog not correctly translated")
 D CHKEQ^XTMUNIT(%T,(22*60*60)+(44*60)+22,"Number of seconds since midnight incorrect")
 D CHKEQ^XTMUNIT(%Y,5,"Should be 5 for Friday")
 ;
 N X,%H,%T,%Y
 S X="3100000" D H^%DTC
 D CHKEQ^XTMUNIT(%H,"61727","Horolog not correctly translated 2")
 D CHKEQ^XTMUNIT(%T,0,"Imprecise date - seconds should be zero")
 D CHKEQ^XTMUNIT(%Y,-1,"Imprecise date - %Y should be -1")
 ;
 N X,%H,%T,%Y
 S X="ABCDEF" D H^%DTC
 D CHKEQ^XTMUNIT(%H,0,"Invalid input - %H should be 0")
 D CHKEQ^XTMUNIT(%T,0,"Invalid input - %T should be 0")
 D CHKEQ^XTMUNIT(%Y,-1,"Invalid input - %Y should be -1")
 ;
 N X,%H,%T,%Y
 S X=5 D H^%DTC
 D CHKEQ^XTMUNIT(%H,0,"Invalid input - %H should be 0")
 D CHKEQ^XTMUNIT(%T,0,"Invalid input - %T should be 0")
 D CHKEQ^XTMUNIT(%Y,-1,"Invalid input - %Y should be -1")
 QUIT
 ;
HELP ; @TEST - Exercise Help, no checks.
 N REDBG S REDBG=$C(27)_"[41m" ; Red Background ANSI
 N WHTFG S WHTFG=$C(27)_"[37m" ; White Forground ANSI
 N RESET S RESET=$C(27)_"[0m"  ; Reset to original ANSI
 N X  ; Looper variable
 ;
 ; Test %DT flags
 F X="A","E","F","I","M","N","P","R","SR","ST","T","X","" D
 . N %DT S %DT=X
 . W !
 . W REDBG_WHTFG
 . W !,"%DT: ",%DT
 . W RESET
 . D HELP^%DTC
 ;
 ; Test %DT(0)
 N X,Y ; Loopers
 F X="3101231","T+30" F Y="-","+" D
 . N %DT S %DT(0)=Y_X,%DT="I"
 . W !
 . W REDBG_WHTFG
 . W !,"%DT(0): ",%DT(0)
 . W RESET
 . D HELP^%DTC
 QUIT
 ;
NOW ; @TEST - Tests NOW^%DTC
 ; Input: None
 ; Output:
 ; - %  -> VA FileMan date/time down to the second.
 ; - %H -> $H date/time.
 ; %I(1) -> The numeric value of the month.
 ; %I(2) -> The numeric value of the day.
 ; %I(3) -> The numeric value of the year.
 ; X -> VA FileMan date only.
 N %,%H,%I,X
 D NOW^%DTC
 D CHKEQ^XTMUNIT($L(%,"."),2,"No date/time provided when they should be")
 D CHKTF^XTMUNIT($L($P(%,".",2))>2,"Hours and minutes not provided when they should be")
 D CHKEQ^XTMUNIT(%I(1),+$E(DT,4,5),"Month incorrect")
 D CHKEQ^XTMUNIT(%I(2),+$E(DT,6,7),"Day incorrect")
 D CHKEQ^XTMUNIT(%I(3),$E(DT,1,3),"Year incorrect")
 D CHKEQ^XTMUNIT(X,DT,"VA Fileman date only incorrect")
 QUIT
 ;
S ; @TEST - Test S^%DTC
 ; Input: % - Number of seconds since midnight
 ; Output: % - Decimal part of Fileman Date
 N % S %=1 D S^%DTC
 D CHKEQ^XTMUNIT(%,.000001,"1 second didn't convert correctly")
 N % S %=(13*60*60)+(48*60)+47 D S^%DTC ; 1:48:47 PM
 D CHKEQ^XTMUNIT(%,.134847,"1:48:47 didn't convert correctly")
 N % S %=0 D S^%DTC
 D CHKEQ^XTMUNIT(%,0,"0 didn't convert correctly")
 N % S %="ABCDEF" D S^%DTC
 D CHKEQ^XTMUNIT(%,0,"ABCDEF didn't convert correctly")
 N % S %="1abcdef" D S^%DTC
 D CHKEQ^XTMUNIT(%,.000001,"1abcdef didn't convert correctly")
 QUIT
YMD ; @TEST - Test YMD^%DTC
 ; Input: %H - $H format date/time
 ; Output: % - Time down to second in FM format
 ;       : X - date in Fileman format
 N %H,%,X
 S %H=$H D YMD^%DTC
 N FMTIME S FMTIME=$$FMTFDHT(%H)
 D CHKEQ^XTMUNIT(%,FMTIME,"Time didn't convert correctly")
 D CHKEQ^XTMUNIT(X,DT,"Date didn't convert correctly")
 ;
 ; Check date sans time
 N %H,%,X
 S %H=$P($H,",") D YMD^%DTC
 D CHKEQ^XTMUNIT(%,0,"Time didn't convert correctly 2")
 D CHKEQ^XTMUNIT(X,DT,"Date didn't convert correctly 2")
 ;
 ; Now check invalid inputs
 N %H,%,X
 S %H=0 D YMD^%DTC
 D CHKEQ^XTMUNIT(%,0,"Time should be zero for $H of 0")
 D CHKEQ^XTMUNIT(X,"","Date should be null? for $H of 0")
 ;
 N %H,%,X
 S %H=1 D YMD^%DTC
 D CHKEQ^XTMUNIT(%,0,"Time should be zero for $H of 1")
 D CHKEQ^XTMUNIT(X,1410101,"Date for $H of 1 is 1410101")
 ;
 N %H,%,X
 S %H="HELLO" D YMD^%DTC
 D CHKEQ^XTMUNIT(%,0,"Time should be zero for $H of ""HELLO""")
 D CHKEQ^XTMUNIT(X,"","Date should be null for $H of 0")
 ;
 N %H,%,X
 S %H="1HELLO" D YMD^%DTC
 D CHKEQ^XTMUNIT(%,0,"Time should be zero for $H of ""1HELLO""")
 D CHKEQ^XTMUNIT(X,1410101,"Date for $H of ""1HELLO"" should be 1410101")
 QUIT
 ;
YX ; @TEST - Test YX^%DTC
 ; Input: %H - a $Horolog date
 ; Output: Y - Date in external format
 ;       : X - Date in Fileman Format
 ;       : % - Time in Fileman decimal format
 ;
 ; $H cum datetime
 N %H,Y,X,%
 S %H="62823,40271" D YX^%DTC
 D CHKEQ^XTMUNIT(Y,"JAN 01, 2013@11:11:11","$H didn't convert correctly")
 D CHKEQ^XTMUNIT(X,3130101,"Fileman date didn't get produced correctly")
 D CHKEQ^XTMUNIT(%,.111111,"Fileman time didn't get produced correctly")
 ;
 ; $H sans time
 N %H,Y,X,%
 S %H=62823 D YX^%DTC
 D CHKEQ^XTMUNIT(Y,"JAN 01, 2013","$H didn't convert correctly 2")
 D CHKEQ^XTMUNIT(X,3130101,"Fileman date didn't get produced correctly 2")
 D CHKEQ^XTMUNIT(%,0,"Fileman time should be zero for $H of 62823")
 ;
 ; Invalid input
 N %H,Y,X,%
 S %H=0 D YX^%DTC
 D CHKEQ^XTMUNIT(Y,0,"$H of 0 should produce zero date")
 D CHKEQ^XTMUNIT(X,"","$H of 0 should produced a empty fileman date")
 D CHKEQ^XTMUNIT(%,0,"$H of 0 should produce zero time")
 ;
 ; Invalid input again
 N %H,Y,X,%
 S %H="HELLO" D YX^%DTC
 D CHKEQ^XTMUNIT(Y,0,"$H of ""HELLO"" should produce zero date")
 D CHKEQ^XTMUNIT(X,"","$H of ""HELLO"" should produce a zero fileman date")
 D CHKEQ^XTMUNIT(%,0,"$H of ""HELLO"" should produce zero time")
 ;
 ; Slightly invalid input
 N %H,Y,X,%
 S %H="62823HELLO" D YX^%DTC
 D CHKEQ^XTMUNIT(Y,"JAN 01, 2013","$H of 62823HELLO should be JAN 01, 2013")
 D CHKEQ^XTMUNIT(X,3130101,"$H of 62823HELLO should be FM Date 3130101")
 D CHKEQ^XTMUNIT(%,0,"$H of 62823HELLO should be FM time zero")
 QUIT
 ;
FMTFDHT(%H) ; $$ ; Fileman Time from $H Time; Private to DMU routines
 ; Input %H: By Value: Seconds portion of $H
 ; Output: Fileman decimal representing the time
 N SECONDS,REM ; seconds, remainder
 S SECONDS=$P(%H,",",2)
 N FMHR S FMHR=SECONDS/60/60\1 S:$L(FMHR)=1 FMHR="0"_FMHR ; derive hours
 S REM=SECONDS-(60*60*FMHR) ; remainder seconds after hours
 N FMMIN S FMMIN=REM/60\1 S:$L(FMMIN)=1 FMMIN="0"_FMMIN ; minutes
 S REM=SECONDS-(60*60*FMHR)-(60*FMMIN) ; remainder
 N FMSEC S FMSEC=REM ; seconds
 S:$L(FMSEC)=1 FMSEC="0"_FMSEC ; and pad zero if one digit
 N FMTIME S FMTIME="."_FMHR_FMMIN_FMSEC,FMTIME=+FMTIME ; create FM time number; remove extra trailing zeroes.
 QUIT FMTIME
 ;
INTWRAP(CMD,ARR) ; Interactive Prompt Wrapper. Write prompt to file and read back.
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
