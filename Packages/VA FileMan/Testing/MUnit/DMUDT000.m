DMUDT000 ; VEN/SMH - Unit Test Driver for Date Utilities; 26-DEC-2012
 ;;22.2;VA FILEMAN;;
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
%DTFUT ; @TEST - %DT Future Assumed Flag
 N %DT,X,Y
 S %DT="F",X="NOV 11, 2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3801111,"Future Date Test Full Failed.")
 S %DT="F",X="NOV 2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3801100,"Future Date Test Month Year Only Failed.")
 S %DT="F",X="2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3800000,"Future Date Test Year Only Failed.")
 S %DT="F",X="2000" D ^%DT
 D CHKEQ^XTMUNIT(Y,3000000,"Past Date Test failed.")
 N YEAR S YEAR=$E(DT,1,3)+1700-10 ; Get a year 10 years in the past
 N YEAR2D S YEAR2D=$E(YEAR,3,4) ; Get the last 2 digits of the year
 S %DT="F" S X="03"_"11"_YEAR2D D ^%DT
 N EXPRESULT S EXPRESULT=YEAR-1700+100_"0311"
 D CHKEQ^XTMUNIT(Y,EXPRESULT,"Future Date: Past 2 digit year wasn't interpreted to be in the future")
 QUIT
 ;
%DTPAST ; @TEST - %DT="P" - Past assumed flag
 N %DT,X,Y
 S %DT="P",X="NOV 11,2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3801111,"Past Date Test Full Failed.")
 S %DT="P",X="NOV 2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3801100,"Past Date Test Month Year only failed.")
 S %DT="P",X="2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3800000,"Past Date Test Year only failed.")
 N YEAR S YEAR=$E(DT,1,3)+1700+10 ; Get a year 10 years in the future
 N YEAR2D S YEAR2D=$E(YEAR,3,4)
 S %DT="P" S X="03"_"11"_YEAR2D D ^%DT
 N EXPRESULT S EXPRESULT=YEAR-1700-100_"0311"
 D CHKEQ^XTMUNIT(Y,EXPRESULT,"Past Date: Future 2 digit year wasn't interpreteed to be in the past")
 QUIT
 ;
%DTI ; @TEST - Internationl Dates
 N %DT,X,Y
 S %DT="I",X="3/11/2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3801103,"dd/mm/yyyy input failed")
 S %DT="I",X="APR 3,2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3800403,"mmm dd,yyyy input failed")
 S %DT="I",X="5 APR 2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3800405,"dd mmm yyyy input failed")
 S %DT="I",X="8 APRIL 2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,3800408,"dd mmmm yyyy input failed")
 S %DT="I",X="31 APRIL 2080" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"Invalid date test failed")
 S %DT="I",X="03112010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3101103,"ddmmyyyy input failed")
 QUIT
 ;
%DTINT ; @TEST - Interactive dates; %DT("AE") - Ask and Echo
 N %DT,X,Y
 S %DT="A"
 N CMD S CMD="D ^%DT"
 N ARR
 D INTWRAP(CMD,.ARR)
 D CHKEQ^XTMUNIT(ARR(2),"DATE: ","Date prompt not issued")
 ;
 N %DT
 S %DT="A"
 S %DT("A")="YABADABADO"
 N ARR
 N CMD S CMD="D ^%DT"
 D INTWRAP(CMD,.ARR)
 D CHKEQ^XTMUNIT(ARR(2),"YABADABADO","%DT(""A"") not honored")
 ;
 N %DT
 S %DT="A"
 S %DT("B")="T+12M"
 N CMD S CMD="D ^%DT"
 D INTWRAP(CMD,.ARR)
 D CHKEQ^XTMUNIT(ARR(2),"DATE: T+12M//","%DT(""B"") not honored")
 ;
 ; Can't seem to get that to work in Mumps alone
 ; N %DT
 ; S %DT="AE"
 ; S %DT("B")="T+12M"
 ; N CMD S CMD="D ^%DT"
 ; D INTWRAP(CMD,.ARR)
 ; D CHKEQ^XTMUNIT(ARR(2),"","Echo not honored")
 ;
%DTM ; @TEST - %DT="M" only month and year input is allowed
 N %DT,X,Y
 S %DT="M"
 S X="1 JAN 2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"%DT=""M"" not honored")
 S X="JAN 2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3100100,"%DT=""M"" didn't work correctly")
 S X="2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3100000,"%DT=""M"" didn't work correctly 2")
 S X="4/2002" D ^%DT
 D CHKEQ^XTMUNIT(Y,3020400,"%DT=""M"" didn't work correctly 3")
 QUIT
 ;
%DTN ; @TEST - %DT="N" - Pure Numeric Input is not allowed
 N %DT,X,Y
 S %DT="N"
 S X="2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"%DT=""N"" not honored 1")
 S X="03012010" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"%DT=""N"" not honored 2")
 S X="03 01 2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3100301,"%DT=""N"" failed")
 QUIT
 ;
%DTR ; @TEST - %DT="R" - Requires Time Input
 N %DT,X,Y
 S %DT="R"
 S X="2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"%DT=""R"" not honored 1")
 S X="03012010" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"%DT=""R"" not honored 2")
 S X="T@10" D ^%DT
 D CHKEQ^XTMUNIT(Y,DT_"."_1,"%DT=""R"" T@10 failed")
 S X="NOV 12 2012@11:22" D ^%DT
 D CHKEQ^XTMUNIT(Y,3121112.1122,"%DT=""R"" NOV 12 2012@11:22 failed")
 QUIT
 ;
%DTT ; @TEST - %DT="T" - Allows Time Input
 N %DT,X,Y
 S %DT="T"
 S X="2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3100000,"%DT=""T"" not honored 1")
 S X="03012010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3100301,"%DT=""T"" not honored 2")
 S X="T@22:15" D ^%DT
 D CHKEQ^XTMUNIT(Y,DT_"."_2215,"%DT=""T"" failing on T@22:15")
 S X="T@22:15:22" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"%DT=""T"" NOT failing on T@22:15:22")
 S X="NOW" D ^%DT
 D CHKTF^XTMUNIT($L($P(Y,".",2))=4,"%DT=""T"" is returning seconds when it shouldn't")
 QUIT
 ;
%DTS ; @TEST - %DT="TS" or "RS" - Return Seconds
 N %DT,X,Y
 S %DT="TS",X="NOW" D ^%DT
 D CHKTF^XTMUNIT($L($P(Y,".",2))=6,"%DT=""TS"" is not returning seconds when it should")
 S %DT="RS",X="3/6/2016@11:22:44" D ^%DT
 D CHKEQ^XTMUNIT(Y,3160306.112244,"%DT=""RS"" is not returning seconds when it should")
 S %DT="S",X="NOW" D ^%DT
 D CHKEQ^XTMUNIT(Y,DT,"%DT=""S"" by itself without T or R should do nothing")
 QUIT
 ;
%DTX ; @TEST - %DT="X" - Exact (month and day) input is required
 N %DT,X,Y
 S %DT="X",X="2000" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"%DT=""X"" not honored")
 S %DT="X",X="T" D ^%DT
 D CHKEQ^XTMUNIT(Y,DT,"TODAY should work with %DT=""X""")
 S %DT="X",X="12 DECEMBER 2033" D ^%DT
 D CHKEQ^XTMUNIT(Y,3331212,"12 DECEMBER 2033 should work with %DT=""X""")
 QUIT
 ;
%DT0 ; @TEST - %DT(0) - Limit dates to or from %DT(0)
 N %DT,X,Y
 S %DT(0)=3101031
 S X="10 OCTOBER 2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"10 OCTOBER 2010 is before 3101031 and invalid")
 S X="31 OCTOBER 2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3101031,"31 OCTOBER 2010 should be valid (At Limit)")
 S X="22 JANUARY 2013" D ^%DT
 D CHKEQ^XTMUNIT(Y,3130122,"22 JANUARY 2013 should be valid (After Limit)")
 ;
 S %DT(0)=-3101031
 S X="10 OCTOBER 2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3101010,"10 OCTOBER 2010 is before 3101031 and valid")
 S X="31 OCTOBER 2010" D ^%DT
 D CHKEQ^XTMUNIT(Y,3101031,"31 OCTOBER 2010 should be valid (At Limit)")
 S X="22 JANUARY 2013" D ^%DT
 D CHKEQ^XTMUNIT(Y,-1,"22 JANUARY 2013 should be invalid (After Limit)")
 QUIT
 ;
DDUPDT ; @TEST - Internal Format to External Format - DD^%DT
 ; Test normal operation first
 N %DT
 N Y S Y="3130522" D DD^%DT
 D CHKEQ^XTMUNIT(Y,"MAY 22, 2013","3130522 didn't convert to external properly")
 N Y S Y="3130522.22" D DD^%DT
 D CHKEQ^XTMUNIT(Y,"MAY 22, 2013@22:00","3130522.22 didn't convert to external properly")
 N Y S Y="3130522.2211" D DD^%DT
 D CHKEQ^XTMUNIT(Y,"MAY 22, 2013@22:11","3130522.2211 didn't convert to external properly")
 N Y S Y="3130522.221144" D DD^%DT
 D CHKEQ^XTMUNIT(Y,"MAY 22, 2013@22:11:44","3130522.221144 didn't convert to external properly")
 ;
 N Y S Y=3130000 D DD^%DT
 D CHKEQ^XTMUNIT(Y,2013,"3130000 didn't convert to external properly")
 N Y S Y=3131200 D DD^%DT
 D CHKEQ^XTMUNIT(Y,"DEC 2013","3131200 didn't convert to external properly")
 ;
 ; Test force seconds return (%DT="S")
 D
 . N %DT,Y S %DT="S"
 . S Y=3130522.22 D DD^%DT
 . D CHKEQ^XTMUNIT(Y,"MAY 22, 2013@22:00:00","Seconds not returned when requested")
 ;
 ; Test bad Input
 N Y S Y=5 D DD^%DT
 D CHKEQ^XTMUNIT(Y,-1,"5 (invalid value) converted to a unknown date")
 ;
 ; Test l10n
 S DUZ("LANG")=2 ; German
 N Y S Y=3130522.2211 D DD^%DT
 D CHKEQ^XTMUNIT(Y,"22.05.2013 22:11","Date didn't convert correctly into German format")
 S DUZ("LANG")="" ; Reset
 QUIT
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
