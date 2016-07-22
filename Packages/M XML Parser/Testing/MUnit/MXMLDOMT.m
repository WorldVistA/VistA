MXMLDOMT ; VEN/SMH - Unit Tests for DOM Parser;2015-05-25  11:36 AM
 ;;2.4;XML PROCESSING UTILITIES;;June 15, 2015;Build 14
 ;;
 ; (c) Sam Habiel 2014
 ;
 S IO=$P
 N DIQUIET S DIQUIET=1
 D EN^%ut($T(+0),1)
 QUIT
 ;
XML1 ; @TEST - Parse a regular XML Document--sanity test
 D READ("XML1D")
 N D S D=$$EN^MXMLDOM($NA(^TMP($J)),"WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 QUIT
XML2 ; @TEST - Parse an XML doc on one line
 D READ("XML2D")
 N D S D=$$EN^MXMLDOM($NA(^TMP($J)),"WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 QUIT
XML3 ; @TEST - Parse an XML doc broken on several lines
 D READ("XML3D")
 N D S D=$$EN^MXMLDOM($NA(^TMP($J)),"WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 QUIT
XML4 ; @TEST - Parse an XML doc with Character ref attr
 D READ("XML4D")
 N D S D=$$EN^MXMLDOM($NA(^TMP($J)),"WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 QUIT
XML5 ; @TEST - Parse an XML doc with Chracter ref attr broken over 2 lines (Sergey's bug)
 D READ("XML5D")
 N D S D=$$EN^MXMLDOM($NA(^TMP($J)),"WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 QUIT
XML6 ; @TEST - Parse an XML doc with Chracter ref text broken over 2 lines (George's bug)
 D READ("XML6D")
 N D S D=$$EN^MXMLDOM($NA(^TMP($J)),"WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 QUIT
XMLFILE ; @TEST - Parse an XML document loacated on the File system (Sam's bug)
 D READ("XML1D")
 ;
 ; Write file
 N % S %=$$GTF^%ZISH($NA(^TMP($J,1)),2,$$DEFDIR^%ZISH(),"mxmldomt.xml")
 I '% S $EC=",U-FILE-WRITE-FAIL,"
 ;
 ; Check 1: No path supplied. System supposed to use default directory
 N D S D=$$EN^MXMLDOM("mxmldomt.xml","WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 ;
 ; Check 2; Supply path explicitly
 N D S D=$$EN^MXMLDOM($$DEFDIR^%ZISH()_"mxmldomt.xml","WD")
 D CHKTF^%ut(D,"XML not parsed")
 D DELETE^MXMLDOM(D)
 ;
 ; Delete file
 N %1 S %1("mxmldomt.xml")=""
 S %=$$DEL^%ZISH($$DEFDIR^%ZISH(),$NA(%1))
 QUIT
XML136 ; @TEST - VA Patch 136 - Long comments are not read properly
 N CB,I,TEST,Y,Z
 K ^TMP($J,"P136 TEST")
 S U="^",TEST="FAILED",Z=0
 F I=1:1 S Y=$T(XML7D+I) Q:Y=""  D
 .I $E(Y,1,3)=" ;;" S Y=$E(Y,4,999),Z=Z+1,^TMP($J,"P136 TEST",Z)=Y Q
 .S Y=$E(Y,2,999),^TMP($J,"P136 TEST",Z)=^TMP($J,"P136 TEST",Z)_Y
 .Q
 S CB("ENDDOCUMENT")="ENDD^MXMLDOMT",Y="^TMP($J,""P136 TEST"")"
 D EN^MXMLPRSE(Y,.CB,"")
 D CHKEQ^%ut(TEST,"PASSED","Long comments are not parsed properly")
 K ^TMP($J,"P136 TEST")
 Q
ENDD ;end of document call back
 ;ZEXCEPT: TEST
 S TEST="PASSED"
 Q
READ(TAGNAME) ; Read XML from tag
 K ^TMP($J)
 N LN
 N I F I=1:1 S LN=$P($T(@TAGNAME+I),";;",2) Q:'$L(LN)  S ^TMP($J,I)=LN
 QUIT
 ;
XML1D ;; @DATA for Test 1
 ;;<?xml version="1.0" encoding="utf-8"?>
 ;;<!-- Edited by XMLSpy -->
 ;;<note>
 ;;<to>Tove</to>
 ;;<from>Jani</from>
 ;;<heading>Reminder</heading>
 ;;<body>Don't forget me this weekend!</body>
 ;;</note>
 ;;
XML2D ;; @DATA for Test 2
 ;;<?xml version="1.0" encoding="utf-8"?><!-- Edited by XMLSpy --><note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>
 ;;
XML3D ;; @DATA for Test 3
 ;;<?xml version="1.0"
 ;;encoding="utf-8"?>
 ;;<!-- Edited b
 ;;y XMLSpy -->
 ;;<not
 ;;e>
 ;;<to>Tove<
 ;;/to>
 ;;<from>Jani</from>
 ;;<heading>Reminder</heading>
 ;;<body>Don't forget me this weekend!</
 ;;body>
 ;;</note>
 ;;
XML4D ;; @DATA for Test 4
 ;;<?xml version="1.0" encoding="utf-8"?>
 ;;<!-- Edited by XMLSpy -->
 ;;<note>
 ;;<to lastname="M&#xfc;ller">Tove</to>
 ;;<from>Jani</from>
 ;;<heading>Reminder</heading>
 ;;<body>Don't forget me this weekend!</body>
 ;;</note>
 ;;
XML5D ;; @DATA for Test 5 (Sergey's bug!)
 ;;<?xml version="1.0" encoding="utf-8"?>
 ;;<!-- Edited by XMLSpy -->
 ;;<note>
 ;;<!-- Overflow the main buffer -->
 ;;<subject>AAAAAAAAAAAAAAAAAAAAAAAAAAAA</subject><to lastnameAAAAAAAAAAAAAAAAA="M&#
 ;;xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#x
 ;;fc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#
 ;;xfc;ller">Tove</to>
 ;;<from>Jani</from>
 ;;<heading>Reminder</heading>
 ;;<body>Don't forget me this weekend!</body>
 ;;</note>
 ;;
XML6D ;; @DATA for Test 6 (George's bug!)
 ;;<?xml version="1.0" encoding="utf-8"?>
 ;;<!-- Edited by XMLSpy -->
 ;;<note>
 ;;<!-- Overflow the main buffer -->
 ;;<subject>AAAAAAAAAAAAAAAAAAAAAAAAAAAA</subject>
 ;;<to>Tove&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#
 ;;xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&
 ;;#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xf
 ;;c;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;&#xfc;</to>
 ;;<from>Jani</from>
 ;;<heading>Reminder</heading>
 ;;<body>Don't forget me this weekend!</body>
 ;;</note>
 ;;
XML7D ;; @DATA for Test 7 (VA patch 136)
 ;;<Bloodbank><Patient dfn="990451" firstName="CARPANTS" lastName="BIFF" dob="7720613.000000" ssn="111111111" abo="A " rh="N">
 ;;<TransfusionReactions><TransfusionReaction type="Urticaria" date="3130408.151856" unitId="W040713210843" productTypeName="Thawed
 ; Apheresis FRESH FROZEN PLASMA" productTypePrintName="FFP AFR Thaw" productCode="E2121V00" comment="On 4/8/13 after transfusion of
 ; thawed plasma unit #W040713210843 the patient developed a rash and itching.  Th
 ;;e entire unit had been transfused.  There were only minor changes in his VS: T 98.3 to 98.2; HR 56 to 56; BP 119/71 to 132/75 and
 ; RR 18 to 18.  Blood Bank was notified of a suspected transfusion reaction.  A clerical check revealed no errors; the patient&ap
 ;;os;s posttransfusion plasma was not hemolyzed and his direct antiglobulin tesst (DAT) remained negative.  The patient's symptoms
 ; and the lack of laboratory findings are most conististent with a mild allergic transfusion reaction.  Such reactions are not uncommon
 ; and are usually directed to foreign proteins in the transfused plasma to which the recipient is immune.  If future transfusions are
 ; needed premedication with benadryl may be beneficial."/>
 ;;</TransfusionReactions></Patient></Bloodbank>
