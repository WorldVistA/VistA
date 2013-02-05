DMUFI003 ; ; 10-JAN-2013
 ;;0.1;FILEMAN EXTENSIONS FILES;;JAN 10, 2013
 Q:'DIFQ(1009.802)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(1009.802,0,"GL")
 ;;=^DMU(1009.802,
 ;;^DIC("B","SHADOW STATE",1009.802)
 ;;=
 ;;^DIC(1009.802,"%D",0)
 ;;=^^5^5^3031105^
 ;;^DIC(1009.802,"%D",1,0)
 ;;=This file contains the name of the state (or outlying area) as issued
 ;;^DIC(1009.802,"%D",2,0)
 ;;=by the Department of Veterans Affairs and issued in M-1, Part I,
 ;;^DIC(1009.802,"%D",3,0)
 ;;=Appendix B.  These entries should remain as distributed and should not be
 ;;^DIC(1009.802,"%D",4,0)
 ;;=edited or updated unless done via a software upgrade or under direction
 ;;^DIC(1009.802,"%D",5,0)
 ;;=of VA Central Office.
 ;;^DD(1009.802,0)
 ;;=FIELD^NL^5^8
 ;;^DD(1009.802,0,"ID",2)
 ;;=W "   ",$P(^("0"),U,2)
 ;;^DD(1009.802,0,"IX","B",1009.802,.01)
 ;;=
 ;;^DD(1009.802,0,"IX","C",1009.802,1)
 ;;=
 ;;^DD(1009.802,0,"IX","C",1009.802,2)
 ;;=
 ;;^DD(1009.802,0,"NM","SHADOW STATE")
 ;;=
 ;;^DD(1009.802,.001,0)
 ;;=NUMBER^NJ3,0^^ ^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(1009.802,.001,3)
 ;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 999
 ;;^DD(1009.802,.001,21,0)
 ;;=^^2^2^2980716^^
 ;;^DD(1009.802,.001,21,1,0)
 ;;=This field contains the internal entry number of the state.  In most
 ;;^DD(1009.802,.001,21,2,0)
 ;;=cases, this should also correspond to the VA STATE CODE field.
 ;;^DD(1009.802,.01,0)
 ;;=NAME^R^^0;1^K:$L(X)>30!X!($L(X)<1)!'(X'?1P.E) X
 ;;^DD(1009.802,.01,1,0)
 ;;=^.1
 ;;^DD(1009.802,.01,1,1,0)
 ;;=1009.802^B
 ;;^DD(1009.802,.01,1,1,1)
 ;;=S ^DMU(1009.802,"B",$E(X,1,30),DA)=""
 ;;^DD(1009.802,.01,1,1,2)
 ;;=K ^DMU(1009.802,"B",$E(X,1,30),DA)
 ;;^DD(1009.802,.01,3)
 ;;=NAME MUST BE 1-30 CHARACTERS LONG & NOT BEGIN WITH PUNCTUATION
 ;;^DD(1009.802,.01,21,0)
 ;;=^^1009.802^1009.802^2911214^
 ;;^DD(1009.802,.01,21,1,0)
 ;;=This field contains the name of the state (or outlying area) as issued
 ;;^DD(1009.802,.01,21,2,0)
 ;;=by the Department of Veterans Affairs and issued in M-1, Part I Appendix
 ;;^DD(1009.802,.01,21,3,0)
 ;;=B.  These entries should remain as distributed and should not be edited
 ;;^DD(1009.802,.01,21,4,0)
 ;;=or updated unless done via a software upgrade or under direction of VA
 ;;^DD(1009.802,.01,21,5,0)
 ;;=Central Office.
 ;;^DD(1009.802,.01,"DEL",1,0)
 ;;=D EN^DDIOL("Deletions are not allowed.","","!?1009.802,$C(7)") I 1
 ;;^DD(1009.802,.01,"DT")
 ;;=3060525
 ;;^DD(1009.802,.01,"LAYGO",1,0)
 ;;=D:'$G(XUMF) EN^DDIOL("New State additions are not allowed.","","!?1009.802,$C(7)") I +$G(XUMF)
 ;;^DD(1009.802,1,0)
 ;;=ABBREVIATION^RF^^0;2^K:$L(X)>5!($L(X)<1) X
 ;;^DD(1009.802,1,1,0)
 ;;=^.1
 ;;^DD(1009.802,1,1,1,0)
 ;;=1009.802^C
 ;;^DD(1009.802,1,1,1,1)
 ;;=Q
 ;;^DD(1009.802,1,1,1,2)
 ;;=Q
 ;;^DD(1009.802,1,1,1,3)
 ;;=Used in conjunction with the 'ADUALC' xref.
 ;;^DD(1009.802,1,3)
 ;;=ANSWER MUST BE 1-1009.802 CHARACTERS IN LENGTH
 ;;^DD(1009.802,1,21,0)
 ;;=^^3^3^2911214^
 ;;^DD(1009.802,1,21,1,0)
 ;;=This field contains the recognized abbreviation for the state.  This
 ;;^DD(1009.802,1,21,2,0)
 ;;=abbreviation is transmitted to Austin from various DHCP packages and
 ;;^DD(1009.802,1,21,3,0)
 ;;=therefore should not be altered unless you are directed to do so.
 ;;^DD(1009.802,1,"DT")
 ;;=3060525
 ;;^DD(1009.802,2,0)
 ;;=VA STATE CODE^F^^0;3^K:$L(X)>2!($L(X)<2)!'(X?2N) X
 ;;^DD(1009.802,2,1,0)
 ;;=^.1
 ;;^DD(1009.802,2,1,1,0)
 ;;=1009.802^C
 ;;^DD(1009.802,2,1,1,1)
 ;;=Q
 ;;^DD(1009.802,2,1,1,2)
 ;;=Q
 ;;^DD(1009.802,2,1,1,3)
 ;;=Used in conjunction with the 'ADUALC' xref.
 ;;^DD(1009.802,2,3)
 ;;=ANSWER MUST BE 2 NUMERICS
 ;;^DD(1009.802,2,21,0)
 ;;=^^4^4^2911214^
 ;;^DD(1009.802,2,21,1,0)
 ;;=This is a numeric code (2 characters in length) which many packages
 ;;^DD(1009.802,2,21,2,0)
 ;;=transmit as to Austin to represent the state a patient resides or
 ;;^DD(1009.802,2,21,3,0)
 ;;=receives treatment in.  This value should not be altered OR IT COULD
 ;;^DD(1009.802,2,21,4,0)
 ;;=SERVERELY AND ADVERSELY AFFECT OPERATIONS AT YOUR MEDICAL CENTER.
 ;;^DD(1009.802,2,"DT")
 ;;=3060525
 ;;^DD(1009.802,2.1,0)
 ;;=AAC RECOGNIZED^RS^1:YES;0:NO;^0;5^Q
 ;;^DD(1009.802,2.1,3)
 ;;=Does the Austin Automation Center(AAC) recognize this State?
 ;;^DD(1009.802,2.1,21,0)
 ;;=^^2^2^3051107^
 ;;^DD(1009.802,2.1,21,1,0)
 ;;=This field designates whether or not the Austin Automation Center(AAC) 
 ;;^DD(1009.802,2.1,21,2,0)
 ;;=recognizes this State.
 ;;^DD(1009.802,2.1,"DT")
 ;;=3051013
 ;;^DD(1009.802,2.2,0)
 ;;=US STATE OR POSSESSION^S^0:No;1:Yes;^0;6^Q
 ;;^DD(1009.802,2.2,3)
 ;;=Is this a US State or Possession?
 ;;^DD(1009.802,2.2,21,0)
 ;;=^^2^2^3051216^
 ;;^DD(1009.802,2.2,21,1,0)
 ;;=This field designates if this entry is a US State or United Sates 
 ;;^DD(1009.802,2.2,21,2,0)
 ;;=possession.
 ;;^DD(1009.802,2.2,"DT")
 ;;=3051216
 ;;^DD(1009.802,3,0)
 ;;=COUNTY^1009.812I^^1;0
 ;;^DD(1009.802,3,21,0)
 ;;=^^4^4^2920211^^
 ;;^DD(1009.802,3,21,1,0)
 ;;=This multiple contains the names and codes of all recognized counties
 ;;^DD(1009.802,3,21,2,0)
 ;;=for this state.  This information is distributed from VA Central Office
 ;;^DD(1009.802,3,21,3,0)
 ;;=and it should NOT be altered unless you are directed to do so from
 ;;^DD(1009.802,3,21,4,0)
 ;;=someone in that office.
 ;;^DD(1009.802,5,0)
 ;;=CAPITAL^F^^0;4^K:X[""""!(X'?.ANP)!(X<0) X I $D(X) K:$L(X)>18!($L(X)<4) X
 ;;^DD(1009.802,5,1,0)
 ;;=^.1^^0
 ;;^DD(1009.802,5,3)
 ;;=MAXIMUM LENGTH: 18, MINIMUM LENGTH: 4
 ;;^DD(1009.802,5,21,0)
 ;;=^^1^1^2911214^^
 ;;^DD(1009.802,5,21,1,0)
 ;;=This field contains the name of the capital city for this state.
 ;;^DD(1009.812,0)
 ;;=COUNTY SUB-FIELD^NL^5^6
 ;;^DD(1009.812,0,"ID",2)
 ;;=W:$D(^("0")) "   ",$P(^("0"),U,3)
 ;;^DD(1009.812,0,"IX","B",1009.812,.01)
 ;;=
 ;;^DD(1009.812,0,"IX","C",1009.812,2)
 ;;=
 ;;^DD(1009.812,0,"IX","C",1009.822,.01)
 ;;=
 ;;^DD(1009.812,0,"NM","COUNTY")
 ;;=
 ;;^DD(1009.812,0,"UP")
 ;;=1009.802
 ;;^DD(1009.812,.01,0)
 ;;=COUNTY^MF^^0;1^K:$L(X)>30!($L(X)<1) X
 ;;^DD(1009.812,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(1009.812,.01,1,2,0)
 ;;=1009.812^B
 ;;^DD(1009.812,.01,1,2,1)
 ;;=S ^DMU(1009.802,DA(1),1,"B",X,DA)=""
 ;;^DD(1009.812,.01,1,2,2)
 ;;=K ^DMU(1009.802,DA(1),1,"B",X,DA)
 ;;^DD(1009.812,.01,3)
 ;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
 ;;^DD(1009.812,.01,21,0)
 ;;=^^1009.802^1009.802^2911214^
 ;;^DD(1009.812,.01,21,1,0)
 ;;=This field contains the name of the county as distributed by VA Central
 ;;^DD(1009.812,.01,21,2,0)
 ;;=Office.  This information should not be altered unless you are directed
 ;;^DD(1009.812,.01,21,3,0)
 ;;=to do so.  Addition, deletion, or modification of this data could have
 ;;^DD(1009.812,.01,21,4,0)
 ;;=severe, adverse affects on many DHCP packages and cause rejects of data
 ;;^DD(1009.812,.01,21,5,0)
 ;;=transmitted to Austin.
 ;;^DD(1009.812,.01,"DEL",1,0)
 ;;=D EN^DDIOL("Entries can only be Inactivated.","","!?1009.802,$C(7)") I 1
 ;;^DD(1009.812,.01,"LAYGO",1,0)
 ;;=D:'$G(XUMF) EN^DDIOL("New County additions are not allowed.","","!?1009.802,$C(7)") I +$G(XUMF)
 ;;^DD(1009.812,1,0)
 ;;=ABBREVIATION^F^^0;2^K:$L(X)>5!($L(X)<1) X
 ;;^DD(1009.812,1,3)
 ;;=ANSWER MUST BE 1-1009.802 CHARACTERS IN LENGTH
 ;;^DD(1009.812,1,21,0)
 ;;=^^2^2^2911214^
 ;;^DD(1009.812,1,21,1,0)
 ;;=This field contains the abbreviation of this county.  This field can be
 ;;^DD(1009.812,1,21,2,0)
 ;;=1-1009.802 characters.
 ;;^DD(1009.812,2,0)
 ;;=VA COUNTY CODE^F^^0;3^K:$L(X)>3!($L(X)<3)!'(X?3N) X
 ;;^DD(1009.812,2,1,0)
 ;;=^.1^^0
 ;;^DD(1009.812,2,1,1,0)
 ;;=1009.812^C
 ;;^DD(1009.812,2,1,1,1)
 ;;=S ^DMU(1009.802,DA(1),1,"C",X,DA)=""
 ;;^DD(1009.812,2,1,1,2)
 ;;=K ^DMU(1009.802,DA(1),1,"C",X,DA)
 ;;^DD(1009.812,2,3)
 ;;=ANSWER MUST BE 3 NUMERICS
 ;;^DD(1009.812,2,21,0)
 ;;=^^6^6^2911214^
 ;;^DD(1009.812,2,21,1,0)
 ;;=This field contains the numeric county code assigned to this conty.  This
 ;;^DD(1009.812,2,21,2,0)
 ;;=assignment is made by VA Central Office and changes should not be made to
 ;;^DD(1009.812,2,21,3,0)
 ;;=these codes unless done through a national software upgrade or with the
 ;;^DD(1009.812,2,21,4,0)
 ;;=direction of VACO.  This information is transmitted in many packages to the
 ;;^DD(1009.812,2,21,5,0)
 ;;=Austin DPC and editing of this data could cause rejects to occur as well
 ;;^DD(1009.812,2,21,6,0)
 ;;=as other negative ramifications.
 ;;^DD(1009.812,2,"DT")
 ;;=2870410
 ;;^DD(1009.812,3,0)
 ;;=CATCHMENT CODE^F^^0;4^K:$L(X)>5!($L(X)<1) X
 ;;^DD(1009.812,3,3)
 ;;=ANSWER MUST BE 1-1009.802 CHARACTERS IN LENGTH
 ;;^DD(1009.812,3,21,0)
 ;;=^^3^3^2911214^^^
 ;;^DD(1009.812,3,21,1,0)
 ;;=This field contains the catchment code (the service area) for this county.
 ;;^DD(1009.812,3,21,2,0)
 ;;=Data in this field must not be edited unless it is under the direction of
 ;;^DD(1009.812,3,21,3,0)
 ;;=VA Central Office.
 ;;^DD(1009.812,4,0)
 ;;=ZIP CODE^1009.822^^1;0
 ;;^DD(1009.812,4,21,0)
 ;;=^^2^2^2911214^
 ;;^DD(1009.812,4,21,1,0)
 ;;=This multiple contains the various zip codes which exist within this
 ;;^DD(1009.812,4,21,2,0)
 ;;=county.  This information is distributed by the US postal service.
 ;;^DD(1009.812,5,0)
 ;;=INACTIVE DATE^D^^0;5^S %DT="EX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(1009.812,5,21,0)
 ;;=^^2^2^3031017^
 ;;^DD(1009.812,5,21,1,0)
 ;;=This date represents the date when the VA determined that the county was 
 ;;^DD(1009.812,5,21,2,0)
 ;;=no longer valid.
 ;;^DD(1009.812,5,"DT")
 ;;=3031017
 ;;^DD(1009.822,0)
 ;;=ZIP CODE SUB-FIELD^NL^.01^1
 ;;^DD(1009.822,0,"NM","ZIP CODE")
 ;;=
 ;;^DD(1009.822,0,"UP")
 ;;=1009.812
 ;;^DD(1009.822,.01,0)
 ;;=ZIP CODE^MF^^0;1^K:$L(X)>5!($L(X)<5)!'(X?5N) X
 ;;^DD(1009.822,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(1009.822,.01,1,2,0)
 ;;=1009.812^C
 ;;^DD(1009.822,.01,1,2,1)
 ;;=S ^DMU(1009.802,DA(2),1,"C",X,DA(1))=""
 ;;^DD(1009.822,.01,1,2,2)
 ;;=K ^DMU(1009.802,DA(2),1,"C",X,DA(1))
 ;;^DD(1009.822,.01,3)
 ;;=ANSWER MUST BE 1009.802 CHARACTERS IN LENGTH
 ;;^DD(1009.822,.01,21,0)
 ;;=^^4^4^2911214^^
 ;;^DD(1009.822,.01,21,1,0)
 ;;=This field contains the numeric zip code allowable for this county.  This
 ;;^DD(1009.822,.01,21,2,0)
 ;;=information is distributed by the United States Postal Service.
 ;;^DD(1009.822,.01,21,3,0)
 ;;= 
 ;;^DD(1009.822,.01,21,4,0)
 ;;=This field is designed only for 1009.802 digit zip codes.  Zip+4 is not allowed.
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",0)
 ;;=1009.802^ADUALC^MU^MU^^R^IR^I^1009.802^^^^^S
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,0)
 ;;=^^19^19^3060521009.802
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,1,0)
 ;;=This cross reference is used to maintain the dual REGULAR "C" cross 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,2,0)
 ;;=reference on the ABBREVIATION(#1) field and the VA STATE CODE(#2) field 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,3,0)
 ;;=and replaces the SET and KILL logic on the REGULAR traditional cross 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,4,0)
 ;;=reference.  The REGULAR traditional cross references SET and KILL 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,5,0)
 ;;=logic are set to a "Q" so look ups will not error out.
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,6,0)
 ;;= 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,7,0)
 ;;=1009.802,1           ABBREVIATION           0;2 FREE TEXT (Required)
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,8,0)
 ;;=              CROSS-REFERENCE:  1009.802^C 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,9,0)
 ;;=                                1)= Q
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,10,0)
 ;;=                                2)= Q
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,11,0)
 ;;=                                3)= Used in conjunction with the 'ADUALC' 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,12,0)
 ;;=                                    xref.
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,13,0)
 ;;= 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,14,0)
 ;;=1009.802,2           VA STATE CODE          0;3 FREE TEXT
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,15,0)
 ;;=              CROSS-REFERENCE:  1009.802^C 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,16,0)
 ;;=                                1)= Q
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,17,0)
 ;;=                                2)= Q
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,18,0)
 ;;=                                3)= Used in conjunction with the 'ADUALC' 
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",.1,19,0)
 ;;=                                    xref.
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",1)
 ;;=I ((X2(1)'="")!(X1(1)'=X2(1))),X2(1)'="" S ^DMU(1009.802,"C",X2(1),DA)="" I ((X2(2)'="")!(X1(2)'=X2(2))),X2(2)'="" S ^DMU(1009.802,"C",X2(2),DA)="" Q
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",2)
 ;;=I ((X2(1)="")!(X1(1)'=X2(1))),X1(1)'="" K ^DMU(1009.802,"C",X1(1),DA) I ((X2(2)="")!(X1(2)'=X2(2))),X1(2)'="" K ^DMU(1009.802,"C",X1(2),DA) Q
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",2.5)
 ;;=K ^DMU(1009.802,"C")
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",11.1,0)
 ;;=^.114IA^2^2
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",11.1,1,0)
 ;;=1^F^1009.802^1^^^F
 ;;^UTILITY("KX",$J,"IX",1009.802,1009.802,"ADUALC",11.1,2,0)
 ;;=2^F^1009.802^2^^^F
