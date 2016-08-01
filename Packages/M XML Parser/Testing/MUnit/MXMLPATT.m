MXMLPATT ; VEN/SMH-OSEHRA/JPS - MXML XPath Processor Unit Tests;2015-06-11  04:00 PM
 ;;2.4;XML PROCESSING UTILITIES;;June 15, 2015;Build 14
 ; (c) Sam Habiel 2014
TEST ; M-Unit Entry point for Unit Testing
 SET IO=$PRINCIPAL
 NEW DIQUIET SET DIQUIET=1
 DO DT^DICRW
 DO:$LENGTH($TEXT(EN^%ut))&$L($T(^MXMLPATH)) EN^%ut($TEXT(+0),1)
 QUIT
 ;
STARTUP ; M-Unit start-up; Load XML Document
 KILL ^TMP($JOB) ; array where we will store it
 NEW L ; Line text
 ;
 ; Load document
 NEW I FOR I=1:1 SET L=$TEXT(TESTDATA+I) SET L=$PIECE(L,";;",2) QUIT:L="<<END>>"  QUIT:L=""  SET ^TMP($JOB,I)=L
 ;
 ; Parse document
 ; ZEXCEPT: DOCHAND
 SET DOCHAND=$$EN^MXMLDOM($NAME(^TMP($JOB)),"W")
 ;
 IF 'DOCHAND DO FAIL^%ut("Could not parse XML")
 ;
 KILL ^TMP($JOB)
 QUIT
SHUTDOWN ; M-Unit Shutdown ; Delete parsed XML document from memory
 ; ZEXCEPT: DOCHAND
 DO DELETE^MXMLDOM(DOCHAND)
 KILL DOCHAND
 QUIT
 ;
TESTS1 ; @TEST - Test /PEPSResponse/Body/drugCheck/drugDrugChecks/drugDrugCheck/source [extant]
 NEW XPATH SET XPATH="/PEPSResponse/Body/drugCheck/drugDrugChecks/drugDrugCheck/source"
 ;
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 NEW TEXT
 DO TEXT^MXMLDOM(DOCHAND,$ORDER(RTN("")),$NAME(TEXT))
 DO CHKEQ^%ut(TEXT(1),"FDB",XPATH_" expression failed")
 QUIT
 ;
TESTS2 ; @TEST - Test /PEPSResponse/drugCheck/drugDrugChecks/drugDrugCheck/source [n/a]
 NEW XPATH SET XPATH="/PEPSResponse/drugCheck/drugDrugChecks/drugDrugCheck/source"
 ;
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 NEW NODE SET NODE=$ORDER(RTN(""))
 DO CHKEQ^%ut(NODE,"",XPATH_" shouldn't be found")
 QUIT
 ;
TESTS3 ; @TEST - Test a multiple /PEPSResponse/.../reference [extant]
 NEW XPATH SET XPATH="/PEPSResponse/Body/drugCheck/drugDrugChecks/drugDrugCheck/professionalMonograph/references/reference"
 ;
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 ;
 ;
 ; Count returned nodes
 NEW C SET C=0
 NEW N SET N=0 FOR  SET N=$ORDER(RTN(N)) QUIT:'N  SET C=C+1
 ;
 DO CHKEQ^%ut(C,5,"5 reference tags should exist")
 QUIT
 ;
TESTSS1 ; @TEST - Test //reference [extant]
 NEW XPATH SET XPATH="//reference"
 ;
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 ;
 ; Count returned nodes
 NEW C SET C=0
 NEW N SET N=0 FOR  SET N=$ORDER(RTN(N)) QUIT:'N  SET C=C+1
 ;
 DO CHKEQ^%ut(C,5,"5 reference tags should exist")
 QUIT
 ;
TESTSS2 ; @TEST - Test //referenceblah [n/a]
 NEW XPATH SET XPATH="//referenceblah"
 ;
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 ;
 ; Count returned nodes
 NEW C SET C=0
 NEW N SET N=0 FOR  SET N=$ORDER(RTN(N)) QUIT:'N  SET C=C+1
 ;
 DO CHKEQ^%ut(C,0,"0 referenceblah tags should exist")
 QUIT
 ;
TESTSS3 ; @TEST - Test //interactedDrugList/drug [extant]
 NEW XPATH SET XPATH="//interactedDrugList/drug"
 ;
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 ;
 ; Count returned nodes
 NEW C SET C=0
 NEW N SET N=0 FOR  SET N=$ORDER(RTN(N)) QUIT:'N  SET C=C+1
 ;
 DO CHKEQ^%ut(C,2,"2 "_XPATH_" tags should exist")
 QUIT
 ;
TESTSS4 ; @TEST - Test //interactedDrugList/drum [n/a]
 NEW XPATH SET XPATH="//interactedDrugList/drum"
 ;
 ;
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 ;
 ; Count returned nodes
 NEW C SET C=0
 NEW N SET N=0 FOR  SET N=$ORDER(RTN(N)) QUIT:'N  SET C=C+1
 ;
 DO CHKEQ^%ut(C,0,"0 "_XPATH_" tags should exist")
 QUIT
 ;
TESTREL1 ; @TEST - Test Relative paths (//Header, then MUser) [extant]
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,"//Header")
 NEW % SET %=$$XPATH^MXMLPATH(.RTN,DOCHAND,"MUser")
 DO CHKEQ^%ut($$VALUE^MXMLDOM(DOCHAND,%,"duz"),88660079,"Wrong tag retrieved")
 QUIT
 ;
TESTREL2 ; @TEST - Test Relative paths (//Header, then interactedDrugList/drug) [n/a]
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,"//Header")
 NEW % SET %=$$XPATH^MXMLPATH(.RTN,DOCHAND,"interactedDrugList/drug")
 DO CHKEQ^%ut($ORDER(RTN("")),"","No results should be found.")
 QUIT
 ;
TESTATT1 ; @TEST - Test Attribute //@orderNumber [extant]
 ; ZEXCEPT: DOCHAND
 NEW RTN
 DO XPATH^MXMLPATH(.RTN,DOCHAND,"//@orderNumber")
 NEW X,Y,Z SET X=$ORDER(RTN("")),Y=$ORDER(RTN(X,"")),Z=RTN(X,Y)
 DO CHKEQ^%ut(Z,"Z;2;Prospect","Attribute not retrieved properly")
 QUIT
 ;
TESTATT2 ; @TEST - Test Attribute //drug/@vuid [extant]
 ; ZEXCEPT: DOCHAND
 DO CHKEQ^%ut($$XPATH^MXMLPATH(,DOCHAND,"//drug/@vuid"),778899,"Attribute not retrieved properly")
 QUIT
 ;
TESTATT3 ; @TEST - Test Attribute //drug/dada [n/a]
 ; ZEXCEPT: DOCHAND
 DO CHKEQ^%ut($$XPATH^MXMLPATH(,DOCHAND,"//drug/@dada"),"","non-existent Attribute")
 QUIT
 ;
TESTATT4 ; @TEST - Test relative attribute //Header, MServer, @stationNumber [extant]
 ; ZEXCEPT: DOCHAND
 NEW %1 SET %1=$$XPATH^MXMLPATH(,DOCHAND,"//Header")
 NEW %2 SET %2=$$XPATH^MXMLPATH(,DOCHAND,"MServer")
 NEW %3 SET %3=$$XPATH^MXMLPATH(,DOCHAND,"@stationNumber")
 DO CHKEQ^%ut(%3,45,"Attribute not retrieved properly")
 QUIT
 ;
TESTFIL1 ; @TEST - Test ordinal filter expressions //references/reference[3] [extant]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//references/reference[3]"
 NEW RTN DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 NEW TXT SET TXT=^TMP("MXMLDOM",$JOB,DOCHAND,$ORDER(RTN("")),"T",1)
 DO CHKTF^%ut(TXT["nelfinavir","Incorrect node retrieved")
 QUIT
 ;
TESTFIL2 ; @TEST - Test ordinal filter expressions //references/reference[11] [n/a]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//references/reference[11]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut(%,"","reference[11] shouldn't exist")
 QUIT
 ;
TESTFIL3 ; @TEST - Test ordinal filter expression //reference[position(3)] [extant]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//references/reference[position(3)]"
 NEW RTN DO XPATH^MXMLPATH(.RTN,DOCHAND,XPATH)
 NEW TXT SET TXT=^TMP("MXMLDOM",$JOB,DOCHAND,$ORDER(RTN("")),"T",1)
 DO CHKTF^%ut(TXT["nelfinavir","Incorrect node retrieved")
 QUIT
 ;
TESTFIL4 ; @TEST - Test last() filter expression //reference[last()] [extant]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//reference[last()]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 NEW TXT SET TXT=^TMP("MXMLDOM",$JOB,DOCHAND,%,"T",1)
 DO CHKTF^%ut(TXT["tipranavir","Incorrect node retrieved")
 QUIT
 ;
TESTFIL5 ; @TEST - Test @attribute as //drug[@vuid] [extant]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//drug[@vuid]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut($$VALUE^MXMLDOM(DOCHAND,%,"ien"),113,"Incorrect node retrieved")
 QUIT
 ;
TESTFIL6 ; @TEST - Test @attribute as //drug[@vuib] [n/a]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//drug[@vuib]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut(%,"","Incorrect node retrieved")
 QUIT
 ;
TESTFIL7 ; @TEST - Test node as //professionalMonograph[monographTitle] [extant]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//professionalMonograph[monographTitle]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut(^TMP("MXMLDOM",$JOB,DOCHAND,%),"professionalMonograph","Incorrect node retrieved")
 QUIT
 ;
TESTFIL8 ; @TEST - Test node as //professionalMonograph[monographTible] [n/a]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//professionalMonograph[monographTible]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut(%,"","monographTible does not exist")
 QUIT
 ;
TESTFIL9 ; @TEST - Test attribute="value" as //drug[@ien="113"] [extant]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//drug[@ien=""113""]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut($$VALUE^MXMLDOM(DOCHAND,%,"gcnSeqNo"),266,"Incorrect node retrieved")
 QUIT
 ;
TESTFI10 ; @TEST - Test attribute="value" as //drug[@ien="999"] [n/a]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//drug[@ien=""999""]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut(%,"","drug of IEN 999 doesn't exist")
 QUIT
 ;
TESTFI11 ; @TEST - Test node="value" as //drugDrugCheck[id="283"] [extant]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//drugDrugCheck[id=""283""]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut(^TMP("MXMLDOM",$JOB,DOCHAND,%),"drugDrugCheck","Incorrect node retrieved")
 QUIT
 ;
TESTFI12 ; @TEST - Test node="value" as //drugDrugCheck[id="999"] [n/a]
 ; ZEXCEPT: DOCHAND
 NEW XPATH SET XPATH="//drugDrugCheck[id=""999""]"
 NEW % SET %=$$XPATH^MXMLPATH(,DOCHAND,XPATH)
 DO CHKEQ^%ut(%,"","drugDrugCheck of id 999 doesn't exist")
 QUIT
 ;
TESTDATA ; from https://github.com/OSEHRA-Sandbox/MOCHA/tree/master/etc/xml/test/messages
 ;;<?xml version="1.0" encoding="UTF-8"?>
 ;;<PEPSResponse
 ;;    xsi:schemaLocation="gov/va/med/pharmacy/peps/external/common/preencapsulation/vo/drug/check/response drugCheckSchemaOutput.xsd"
 ;;    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="gov/va/med/pharmacy/peps/external/common/preencapsulation/vo/drug/check/response">
 ;;    <Header>
 ;;        <Time value="0845"/>
 ;;        <MServer namespace="VISTA" uci="text" ip="127.0.000.1"
 ;;            serverName="Server Name" stationNumber="45"/>
 ;;        <MUser userName="user" duz="88660079" jobNumber="1001"/>
 ;;        <PEPSVersion difIssueDate="20091002" difBuildVersion="6" difDbVersion="3.2"/>
 ;;    </Header>
 ;;    <Body>
 ;;        <drugCheck>
 ;;            <drugDrugChecks>
 ;;                <drugDrugCheck>
 ;;                    <id>283</id>
 ;;                    <source>FDB</source>
 ;;                    <interactedDrugList>
 ;;                        <drug orderNumber="Z;2;Prospect" ien="455" gcnSeqNo="25485"/>
 ;;                        <drug orderNumber="Z;1;Prospect" ien="113"
 ;;                            vuid="778899" gcnSeqNo="266"/>
 ;;                    </interactedDrugList>
 ;;                    <severity>Contraindicated Drug Combination</severity>
 ;;                    <interaction>SELECTED PROTEASE INHIBITORS/AMIODARONE</interaction>
 ;;                    <shortText>INDINAVIR SULFATE ORAL CAPSULE 400 MG and AMIODARONE HCL ORAL TABLET 200 MG may interact based on the potential interaction between SELECTED PROTEASE INHIBITORS and AMIODARONE.</shortText>
 ;;                    <professionalMonograph>
 ;;                        <monographSource>FDB</monographSource>
 ;;                        <disclaimer>This information is generalized and not intended as specific medical advice. Consult your healthcare professional before taking or discontinuing any drug or commencing any course of treatment.</disclaimer>
 ;;                        <monographTitle>MONOGRAPH TITLE:  Selected Protease Inhibitors/Amiodarone</monographTitle>
 ;;                        <severityLevel>SEVERITY LEVEL:  1-Contraindicated Drug Combination: This drug combination is contraindicated and generally should not be dispensed or administered to the same patient.</severityLevel>
 ;;                        <mechanismOfAction>MECHANISM OF ACTION:  Indinavir,(1) nelfinavir,(2) ritonavir,(3) and tipranavir coadministered with ritonavir(4) may inhibit the metabolism of amiodarone at CYP P-450-3A4.</mechanismOfAction>
 ;;                        <clinicalEffects>CLINICAL EFFECTS:  The concurrent administration of amiodarone with indinavir,(1) nelfinavir,(2) ritonavir,(3) or tipranavir coadministered with ritonavir(4)
 ;;may result in increased levels, clinical effects, and toxicity of amiodarone.</clinicalEffects>
 ;;                        <predisposingFactors>PREDISPOSING FACTORS:  None determined.</predisposingFactors>
 ;;                        <patientManagement>PATIENT MANAGEMENT:  The concurrent administration of amiodarone with indinavir,(1) nelfinavir(2), ritonavir,(3) or tipranavir coadministered with ritonavir(4)
 ;;is contraindicated by the manufacturers of indinavir,(1) nelfinavir(2), ritonavir,(3) and tipranavir coadministered with ritonavir. (4)</patientManagement>
 ;;                        <discussion>DISCUSSION:  Indinavir has been shown to inhibit CYP P-450-3A4.  Therefore, the manufacturer of indinavir states that the concurrent administration of indinavir with amiodarone,
 ;;which is metabolized by CYP P-450-3A4, is contraindicated.(1)Nelfinavir has been shown to inhibit CYP P-450-3A4.
 ;;Therefore, the manufacturer of nelfinavir states that the concurrent administration of
 ;;nelfinavir with amiodarone, which is metabolized by CYP P-450-3A4, is contraindicated.(2)
 ;;Ritonavir has also been shown to inhibit CYP P-450-3A4. Therefore, the manufacturer of ritonavir state that the concurrent administration of ritonavir with amiodarone is contraindicated.(3)</discussion>
 ;;                        <references>
 ;;                            <reference><![CDATA[REFERENCES:]]></reference>
 ;;                            <reference><![CDATA[1.Crixivan (indinavir sulfate) US prescribing information. Merck & Co., Inc. December, 2008.]]></reference>
 ;;                            <reference><![CDATA[2.Viracept (nelfinavir mesylate) US prescribing information. Agouron Pharmaceuticals, Inc. July, 2007.]]></reference>
 ;;                            <reference><![CDATA[3.Norvir (ritonavir) US prescribing information. Abbott Laboratories September 30, 2008.]]></reference>
 ;;                            <reference><![CDATA[4.Aptivus (tipranavir) US prescribing information. Boehringer Ingelheim Pharmaceuticals, Inc. June, 2009.]]></reference>
 ;;                        </references>
 ;;                        <!-- THIS IS A COMMENT -->
 ;;                    </professionalMonograph>
 ;;                </drugDrugCheck>
 ;;            </drugDrugChecks>
 ;;        </drugCheck>
 ;;    </Body>
 ;;</PEPSResponse>
 ;;<<END>>
