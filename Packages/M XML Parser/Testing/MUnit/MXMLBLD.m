MXMLBLD ; RWF/RWF-OSEHRA/JPS - Recursive XML Writer ;2015-06-11  04:00 PM
 ;;2.4;XML PROCESSING UTILITIES;;Jun 15, 2015;Build 14
 QUIT
 ;
 ; Original routine authored by U.S. Department of Veterans Affairs
 ; Author Wally Fort
 ; ATRIBUTEff written by Sam Habiel in 2014. No copyright claimed.
 ;
 ; Sam sez: Wally Fort wrote this!
 ; How to use:
 ; - Call START to start the doucment. Pass G so that the output would be
 ;   stored for later use; otherwise, it prints to the screen.
 ; - Call ITEM for a tag with no children
 ; - Call MULTI for a tag with children, passing the routine that will
 ;   create the children for DOITEM
 ; - Call END to close the XML document
 ; - Grab the document from ^TMP("MXMLBLD",$J)
 ; - Kill that global.
 ;
 ;
 ;DOC - The top level tag
 ;DOCTYPE - Want to include a DOCTYPE node
 ;FLAG - Set to 'G' to store the output in the global ^TMP("MXMLBLD",$J,
 ;NO1ST - Not first; don't generate the XML header if this is true
 ;ATT - Attribute list for the first element
START(DOC,DOCTYPE,FLAG,NO1ST,ATT) ;Call this once at the begining.
 K ^TMP("MXMLBLD",$J)
 S ^TMP("MXMLBLD",$J,"DOC")=DOC,^TMP("MXMLBLD",$J,"STK")=0
 I $G(FLAG)["G" S ^TMP("MXMLBLD",$J,"CNT")=1
 I $G(NO1ST)'=1 D OUTPUT($$XMLHDR)
 D:$L($G(DOCTYPE)) OUTPUT("<!DOCTYPE "_DOCTYPE_">") D OUTPUT("<"_DOC_$$ATT(.ATT)_">")
 Q
 ;
END ;Call this once to close out the document
 D OUTPUT("</"_$G(^TMP("MXMLBLD",$J,"DOC"))_">")
 I '$G(^TMP("MXMLBLD",$J,"CNT")) K ^TMP("MXMLBLD",$J)
 K ^TMP("MXMLBLD",$J,"DOC"),^("CNT"),^("STK")
 Q
 ;
ITEM(INDENT,TAG,ATT,VALUE) ;Output a Item
 N I,X
 S ATT=$G(ATT)
 I '$D(VALUE) D OUTPUT($$BLS($G(INDENT))_"<"_TAG_$$ATT(.ATT)_" />") Q
 D OUTPUT($$BLS($G(INDENT))_"<"_TAG_$$ATT(.ATT)_">"_$$CHARCHK(VALUE)_"</"_TAG_">")
 Q
 ;DOITEM is a callback to output the lower level.
MULTI(INDENT,TAG,ATT,DOITEM) ;Output a Multipule
 N I,X,S
 S ATT=$G(ATT)
 D PUSH($G(INDENT),TAG,.ATT)
 D @DOITEM
 D POP
 Q
 ;
ATT(ATT) ;Output a string of attributes
 I $D(ATT)<9 Q ""
 N I,S,V
 S S="",I=""
 F  S I=$O(ATT(I)) Q:I=""  S S=S_" "_I_"="_$$Q(ATT(I))
 Q S
 ;
Q(X) ;Add Quotes
 I X'[$C(34) Q $C(34)_X_$C(34)
 ;I X'[$C(39) Q $C(39)_X_$C(39)
 N Q,Y,I,Z S Q=$C(34),(Y,Z)=""
 ;N Q,Y,I,Z S Q=$C(39),(Y,Z)=""
 F I=1:1:$L(X,Q)-1 S Y=Y_$P(X,Q,I)_Q_Q
 S Y=Y_$P(X,Q,$L(X,Q))
 Q $C(34)_Y_$C(34)
 ;Q $C(39)_Y_$C(39)
 ;
XMLHDR() ; -- provides current XML standard header
 Q "<?xml version=""1.0"" encoding=""utf-8"" ?>"
 ;
OUTPUT(S) ;Output
 N C S C=$G(^TMP("MXMLBLD",$J,"CNT"))
 I C S ^TMP("MXMLBLD",$J,C)=S,^TMP("MXMLBLD",$J,"CNT")=C+1 Q
 W S,!
 Q
 ;
CHARCHK(STR) ; -- replace xml character limits with entities
 N A,I,X,Y,Z,NEWSTR
 S (Y,Z)=""
 ;IF STR["&" SET NEWSTR=STR DO  SET STR=Y_Z
 ;. FOR X=1:1  SET Y=Y_$PIECE(NEWSTR,"&",X)_"&amp;",Z=$PIECE(STR,"&",X+1,999) QUIT:Z'["&"
 I STR["&" F I=1:1:$L(STR,"&")-1 S STR=$P(STR,"&",1,I)_"&amp;"_$P(STR,"&",I+1,999)
 I STR["<" F  S STR=$PIECE(STR,"<",1)_"&lt;"_$PIECE(STR,"<",2,99) Q:STR'["<"
 I STR[">" F  S STR=$PIECE(STR,">",1)_"&gt;"_$PIECE(STR,">",2,99) Q:STR'[">"
 I STR["'" F  S STR=$PIECE(STR,"'",1)_"&apos;"_$PIECE(STR,"'",2,99) Q:STR'["'"
 I STR["""" F  S STR=$PIECE(STR,"""",1)_"&quot;"_$PIECE(STR,"""",2,99) Q:STR'[""""
 ;
 S STR=$TR(STR,$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31))
 QUIT STR
 ;
COMMENT(VAL) ;Add Comments
 N I,L
 ;I $D($G(VAL))=1 D OUTPUT("<!-- "_ATT_" -->") Q
 I $D(VAL)#2 D OUTPUT("<!-- "_VAL_" -->") Q  ;CHANGED BY GPL FOR GTM
 S I="",L="<!--"
 F  S I=$O(VAL(I)) Q:I=""  D OUTPUT(L_VAL(I)) S L=""
 D OUTPUT("-->")
 Q
 ;
PUSH(INDENT,TAG,ATT) ;Write a TAG and save.
 N CNT
 S ATT=$G(ATT)
 D OUTPUT($$BLS($G(INDENT))_"<"_TAG_$$ATT(.ATT)_">")
 S CNT=$G(^TMP("MXMLBLD",$J,"STK"))+1,^TMP("MXMLBLD",$J,"STK")=CNT,^TMP("MXMLBLD",$J,"STK",CNT)=INDENT_"^"_TAG
 Q
 ;
POP ;Write last pushed tag and pop
 N CNT,TAG,INDENT,X
 S CNT=$G(^TMP("MXMLBLD",$J,"STK")),X=^TMP("MXMLBLD",$J,"STK",CNT),^TMP("MXMLBLD",$J,"STK")=CNT-1
 S INDENT=+X,TAG=$P(X,"^",2)
 D OUTPUT($$BLS(INDENT)_"</"_TAG_">")
 Q
 ;
BLS(I) ;Return INDENT string
 N S
 S S="",I=$G(I) S:I>0 $P(S," ",I)=" "
 Q S
 ;
INDENT() ;Renturn indent level
 Q +$G(^TMP("MXMLBLD",$J,"STK"))
 ;
 ;
 ;
 ;
 ;
 ;
 ;
 ;
 ;
 ; Alternate way to write XML, mostly written by VEN/SMH.
 ;
 ;
ATRIBUTE(NAME,VALUE) ; VEN/SMH - Stolen from Pharmacy Code
 ; @DESC Builds a valid encoded attribute from the name/value pair passed in
 ;
 ; @NAME The left side of the "name=value" relationship
 ; @VALUE The right side of the "name=value" relationship
 ;
 ; @RETURNS A valid/encoded name value pair
 NEW PSS,QT
 SET QT=""""
 SET PSS("attribute")=NAME_"="_QT_$$SYMENC^MXMLUTL($GET(VALUE))_QT
 QUIT PSS("attribute")
 ;
MKTAG(NAME,ATTRS,TEXT,CLOSE) ; $$ PEP - Make an XML Tag
 ; Input:
 ; - NAME: XML Tag Name (Value)
 ; - ATTRS: Name Value pair of attributes (By Reference)
 ; - TEXT: Text to include in the node (Value)
 ; - CLOSE: Boolean: Are we closing the tag? (Value)
 ; Output: XML as in <name culture="jp">Toyoda Kiichiro</name>
 ;
 ; Process optional value inputs
 S CLOSE=$GET(CLOSE,1) ; Default - Yes
 S TEXT=$$SYMENC^MXMLUTL($GET(TEXT)) ; Default - ""; and encode
 S NAME=$$SYMENC^MXMLUTL(NAME) ; encode
 ;
 ; Define constants we use
 N LB S LB="<" ; Left Bracket
 N RB S RB=">" ; Right Bracket
 N SL S SL="/" ; Slant/Slash
 N SP S SP=" " ; Space
 ;
 ; If the name is a closing tag (like /name), just send that out as </name>
 I $E(NAME)=SL Q LB_NAME_RB
 ;
 ; Otherwise we have an open or complete tag to take care of.
 ;
 ; Process Attributes
 N ATTRSTR S ATTRSTR="" ; Where attributes will all go...
 N ITER S ITER="" ; Iterator
 F  S ITER=$O(ATTRS(ITER)) Q:ITER=""  S ATTRSTR=ATTRSTR_$$ATRIBUTE(ITER,ATTRS(ITER))_SP ; concat together w/spaces in between
 S ATTRSTR=$E(ATTRSTR,1,$L(ATTRSTR)-1) ; Remove trailing space
 ;
 N STR ; Build string
 ;
 ; Process beginning part ----> <name attributes
 I $L(ATTRSTR) S STR=LB_NAME_SP_ATTRSTR
 E  S STR=LB_NAME
 ;
 I '$L(TEXT) D  QUIT STR
 . I CLOSE S STR=STR_SP_SL_RB ; Add  />
 . E  S STR=STR_RB ; Add >
 ;
 I $L(TEXT),CLOSE S STR=STR_RB_TEXT_LB_SL_NAME_RB Q STR ; Add >text</name>
 E  S $EC=",U-INVALID-CALL,"
 S $EC=",U-INVALID-CALL,"
 QUIT
 ;
PUT(RETURN,STRING) ; PEP Proc/$$ - Put an XML Line into the RETURN Array
 ; Output in RETURN. Adds a line in the next available numeric subscript. ByRef
 ; STRING: Value to put in return array. Pass by Value.
 ; If called as an extrinsic, the last used subscript is returned.
 ;
 N CNT S CNT=$O(RETURN(" "),-1) ; Last numberic sub; or zero if none
 S CNT=CNT+1 ; next line
 S RETURN(CNT)=STRING
 QUIT:$QUIT CNT QUIT
 ;
TEST D:$L($T(EN^%ut))&$L($T(^MXMLTMP1)) EN^%ut($T(+0),1) QUIT
 ;
TESTPUT ; @TEST - Test PUT
 N RTN
 D PUT(.RTN,$$XMLHDR())
 D PUT(.RTN,$$MKTAG("Book",,"Pride and Prejudice"))
 D CHKEQ^%ut(RTN(1),"<?xml version=""1.0"" encoding=""utf-8"" ?>")
 D CHKEQ^%ut(RTN(2),"<Book>Pride and Prejudice</Book>")
 QUIT
 ;
TESTMK ; @TEST - Test MKTAG
 N %1
 S %1("type")="japaense"
 S %1("origin")="japan"
 D CHKEQ^%ut($$MKTAG("name",.%1,"Toyoda",1),"<name origin=""japan"" type=""japaense"">Toyoda</name>")
 D CHKEQ^%ut($$MKTAG("name",.%1,"Toyoda"),"<name origin=""japan"" type=""japaense"">Toyoda</name>")
 D CHKEQ^%ut($$MKTAG("name",,"Toyoda"),"<name>Toyoda</name>")
 D CHKEQ^%ut($$MKTAG("name",.%1),"<name origin=""japan"" type=""japaense"" />")
 D CHKEQ^%ut($$MKTAG("name",.%1,,0),"<name origin=""japan"" type=""japaense"">")
 D CHKEQ^%ut($$MKTAG("/name"),"</name>")
 QUIT
 ;
TESTBLD ; @TEST - Test Wally's XML Builder
 N %1 S %1("version")="2.5"
 D START("Books",,"G",,.%1)
 D CHKEQ^%ut(^TMP("MXMLBLD",$J,1),"<?xml version=""1.0"" encoding=""utf-8"" ?>")
 D CHKEQ^%ut(^TMP("MXMLBLD",$J,2),"<Books version=""2.5"">")
 N %1 S %1("type")="date"
 D ITEM(,"LastUpdated",.%1,"3-15-99")
 D CHKEQ^%ut(^TMP("MXMLBLD",$J,3),"<LastUpdated type=""date"">3-15-99</LastUpdated>")
 D MULTI(,"Book",,"BOOKEAC1")
 D MULTI(,"Book",,"BOOKEAC2")
 D CHKEQ^%ut(^TMP("MXMLBLD",$J,11),"<Title>Sorrows of Young Werther</Title>")
 D END
 D CHKEQ^%ut(^TMP("MXMLBLD",$J,14),"</Books>")
 ; ZWRITE ^TMP("MXMLBLD",$J,*)
 QUIT
 ;
TESTBLD1 ; Test Wally's XML Builder
 N %1 S %1("version")="2.5"
 D START^MXMLBLD("Books",,"G",,.%1)
 N %1 S %1("type")="date"
 D ITEM^MXMLBLD(,"LastUpdated",.%1,"3-15-99")
 D MULTI^MXMLBLD(,"Book",,"BOOKEAC1")
 D MULTI^MXMLBLD(,"Book",,"BOOKEAC2")
 D END^MXMLBLD
 ; ZWRITE ^TMP("MXMLBLD",$J,*)
 QUIT
BOOKEAC1 ; Book 1
 D ITEM^MXMLBLD(,"Author",,"AUSTEN,JANE")
 D ITEM^MXMLBLD(,"Title",,"PRIDE AND PREJUDICE")
 D ITEM^MXMLBLD(,"Description",,"A romantic novel revealing how pride can cloud our better judgement.")
 Q
BOOKEAC2 ; Book 2
 D ITEM^MXMLBLD(,"Author",,"Johann Wolfgang von Goethe")
 D ITEM^MXMLBLD(,"Title",,"Sorrows of Young Werther")
 D ITEM^MXMLBLD(,"Description",,"A tale of unrequited love leading to the demise of the protagonist.")
 Q
