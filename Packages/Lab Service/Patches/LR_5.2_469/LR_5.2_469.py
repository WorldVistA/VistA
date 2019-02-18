#---------------------------------------------------------------------------
# Copyright 2016 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------
from __future__ import print_function

from DefaultKIDSBuildInstaller import DefaultKIDSBuildInstaller
from VistAMenuUtil import VistAMenuUtil
import re
import time
import sys

inputRegEx = re.compile("INPUT TO WHAT FILE", re.I)
outputRegEx = re.compile("Output from WHAT FILE", re.I)

""" This is an example of custom installer to handle post install questions
    Requirement for custom installer python script:
    1. Must be a class named CustomInstaller
    2. The constructor __init__ takes the exact arguments as the
       DefaultKIDSBuildInstaller
    3. Preferred to be a subclass of DefaultKIDSBuildInstaller
    4. Refer to DefaultKIDSBuildInstaller for methods to override
    5. If not a subclass of DefaultKIDSBuildInstaller, must have a method
       named runInstallation, and take an argument connection
       from VistATestClient.
"""
class CustomInstaller(DefaultKIDSBuildInstaller):
  def __init__(self, kidsFile, kidsInstallName,
               seqNo = None, logFile = None, multiBuildList=None,
               duz=17, **kargs):
    print(kidsInstallName, seqNo)
    assert kidsInstallName == "LR*5.2*469"
    DefaultKIDSBuildInstaller.__init__(self, kidsFile,
                                       kidsInstallName,
                                       seqNo, logFile,
                                       multiBuildList,
                                       duz, **kargs)
  """ The test won't accept a name of "URINE" when creating the entry, change it afterwards from
  the temp name of "URINCE CYTOLOGY" """
  def addSNOMEDCode(self,connection,name,code):
     connection.send('S DUZ=1,LRFMERTS=1,LRFMERTS("STS","STAT")="NEW",LRFMERTS("STS","PROC")="REFLAB" D Q^DI\r')
     connection.expect("Select OPTION")
     connection.send("1\r")
     connection.expect(inputRegEx)
     connection.send("TOPOGRAPHY FIELD\r")
     connection.expect("EDIT WHICH FIELD")
     for field in ["SNOMED CT ID"]:
       connection.send(field+"\r")
       index = connection.expect(["SUB-FIELD","THEN EDIT FIELD"])
       if index ==0:
         connection.send('\r')
         connection.expect("THEN EDIT FIELD")
     connection.send('\r')
     connection.expect("TOPOGRAPHY FIELD NAME")
     connection.send(name+'\r')
     index = connection.expect(["SNOMED CT ID","CHOOSE"])
     if index == 1:
         connection.send("1\r")
         connection.expect("SNOMED CT ID")
     connection.send(code+'\r')
     connection.expect("TOPOGRAPHY FIELD NAME")
     connection.send('\r')
     connection.expect("OPTION")
     connection.send('\r')
  """ The LABORATORY TEST and ORDERABLE ITEM files won't accept a name of "URINE" when creating the entry, change it afterwards from
  the temp name of "URINCE CYTOLOGY" """
  def fixUrineTest(self,connection):
     connection.send("S DUZ=1 D Q^DI\r")
     connection.expect("Select OPTION")
     connection.send("1\r")
     connection.expect(inputRegEx)
     connection.send("LABORATORY TEST\r")
     connection.expect("EDIT WHICH FIELD")
     for field in ["NAME"]:
       connection.send(field+"\r")
       index = connection.expect(["SUB-FIELD","THEN EDIT FIELD"])
       if index ==0:
         connection.send('\r')
         connection.expect("THEN EDIT FIELD")
     connection.send('\r')
     connection.expect("LABORATORY TEST NAME")
     connection.send('URINE CYTOLOGY\r')
     connection.expect("NAME")
     connection.send('URINE\r')
     connection.expect("LABORATORY TEST NAME")
     connection.send('\r')
     connection.expect("OPTION")
     # Change ORDERABLE ITEM FILE
     connection.send("1\r")
     connection.expect(inputRegEx)
     connection.send("ORDERABLE ITEMS\r")
     connection.expect("EDIT WHICH FIELD")
     for field in ["NAME"]:
       connection.send(field+"\r")
       index = connection.expect(["SUB-FIELD","THEN EDIT FIELD"])
       if index ==0:
         connection.send('\r')
         connection.expect("THEN EDIT FIELD")
     connection.send('\r')
     connection.expect("ORDERABLE ITEMS NAME")
     connection.send('URINE CYTOLOGY\r')
     connection.expect("NAME")
     connection.send('URINE\r')
     connection.expect("ORDERABLE ITEMS NAME")
     connection.send('\r')
     connection.expect("OPTION")
     connection.send("\r")

  def addLabTest(self, connection, name,subscript):
     connection.send("S DUZ=1 D Q^DI\r")
     connection.expect("Select OPTION")
     connection.send("1\r")
     connection.expect(inputRegEx)
     connection.send("LABORATORY TEST\r")
     connection.expect("EDIT WHICH FIELD")
     for field in ["SUBSCRIPT","TYPE","HIGHEST URGENCY","COLLECTION SAMPLE"]:
       connection.send(field+"\r")
       index = connection.expect(["SUB-FIELD","THEN EDIT FIELD"])
       if index ==0:
         connection.send('\r')
         connection.expect("THEN EDIT FIELD")
     connection.send('\r')
     connection.expect("LABORATORY TEST NAME")
     connection.send(name +'\r')
     index = connection.expect(["Are you adding","SUBSCRIPT","CHOOSE" ])
     if index == 0:
       connection.send('Y\r')
       connection.expect("LABORATORY TEST SUBSCRIPT")
       connection.send(subscript +'\r')
       connection.expect("HIGHEST URGENCY")
       connection.send("STAT\r")
       connection.expect("PRINT NAME")
       connection.send(name[:19] +'\r')
       connection.expect("DATA NAME")
       connection.send('\r')
       connection.expect("SUBSCRIPT")
     connection.send('\r')
     connection.expect("TYPE")
     connection.send('N\r')
     connection.expect("HIGHEST URGENCY ALLOWED")
     connection.send('\r')
     connection.expect("COLLECTION SAMPLE")
     connection.send('AP SPECIMEN\r')
     index = connection.expect(["OK","FORM NAME"])
     if index==0:
       connection.send('\r')
       connection.expect('COLLECTION SAMPLE')
     connection.send('^\r')
     connection.expect("LABORATORY TEST NAME")
     connection.send('\r')
     connection.expect("OPTION")
     connection.send('\r')

  def addOrderableItemConnection(self, connection, name):
     # First find the IEN of the given Lab test
     ien=''
     connection.send("S DUZ=1 D Q^DI\r")
     connection.expect("Select OPTION")
     connection.send("5\r")
     connection.expect(outputRegEx)
     connection.send("Laboratory Test\r")
     connection.expect("LABORATORY TEST NAME")
     connection.send(name +"\r")
     connection.expect("Another one")
     connection.send('\r')
     connection.expect("Standard Captioned Output")
     connection.send('N\r')
     connection.expect("First Print FIELD")
     connection.send("NUMBER\r")
     connection.expect("Then Print FIELD")
     connection.send("\r")
     connection.expect('Heading')
     connection.send("\r")
     connection.expect("DEVICE")
     connection.send("HOME;82;999\r")
     if sys.platform == 'win32':
       match = connection.expect('\r\n[0-9]+')
       ien = connection.after.lstrip('\r\n')
     else:
       connection.expect('\n[0-9]+')
       number = self.connection.after
       ien = number.lstrip('\r\n')
     connection.expect("Select OPTION")
     #Set the lab test ien as the ID value of the orderable items
     if ien:
       connection.send("1\r")
       connection.expect(inputRegEx)
       connection.send('ORDERABLE ITEMS\r')
       connection.expect("EDIT WHICH FIELD")
       connection.send("ID\r")
       connection.expect("THEN EDIT FIELD")
       connection.send("DISPLAY GROUP\r")
       connection.expect("THEN EDIT FIELD")
       connection.send("\r")
       connection.expect("ORDERABLE ITEMS NAME")
       connection.send(name+"\r")
       index = connection.expect(["CHOOSE","ID:","Are you adding"])
       if index==2:
         connection.send("Y\r")
         connection.expect("ID:")
       elif index == 0:
         connection.send("1\r")
         connection.expect("ID:")
       connection.send(ien+";99LRT\r")
       connection.expect("DISPLAY GROUP")
       connection.send("ANATOMIC PATHOLOGY\r")
       connection.expect("ORDERABLE ITEMS NAME")
       connection.send("\r")
       connection.expect("Select OPTION")
     connection.send("\r")
  def editDisplayGroup(self,connection):
     groups = ["SURGICAL PATHOLOGY","CYTOLOGY","ELECTRON MICROSCOPY"]
     connection.send("S DUZ=1 D Q^DI\r")
     connection.expect("Select OPTION")
     connection.send("1\r")
     connection.expect(inputRegEx)
     connection.send("DISPLAY GROUP\r")
     connection.expect("EDIT WHICH FIELD")
     connection.send("MEMBER\r")
     index = connection.expect(["SUB-FIELD","THEN EDIT FIELD"])
     if index == 0:
       connection.send('\r')
       connection.expect("THEN EDIT FIELD")
     connection.send('\r')
     connection.expect("DISPLAY GROUP NAME")
     connection.send("ANATOMIC PATHOLOGY\r")
     for value in groups:
       connection.expect("Select MEMBER")
       connection.send(value+"\r")
       connection.expect("Are you adding")
       connection.send("Y\r")
       connection.expect("MEMBER SEQUENCE")
       connection.send(str(groups.index(value)+1)+"\r")
     connection.expect("Select MEMBER")
     connection.send('\r')
     connection.expect("DISPLAY GROUP NAME")
     connection.send("LABORATORY\r")
     for value in groups:
       connection.expect("Select MEMBER")
       connection.send(value+"\r")
       connection.expect("OK")
       connection.send("\r")
       connection.expect("MEMBER")
       connection.send("@\r")
       connection.expect("DELETE THE ENTIRE")
       connection.send("Y\r")
     connection.expect("Select MEMBER")
     connection.send('\r')
     connection.expect("DISPLAY GROUP NAME")
     connection.send('\r')
     connection.expect("OPTION")
     connection.send('\r')

  def addAPSpecimen(self, connection):
     connection.send("S DUZ=1 D Q^DI\r")
     connection.expect("Select OPTION")
     connection.send("1\r")
     connection.expect(inputRegEx)
     connection.send("COLLECTION SAMPLE\r")
     connection.expect("EDIT WHICH FIELD")
     connection.send("ALL\r")
     connection.expect("COLLECTION SAMPLE NAME")
     connection.send("AP SPECIMEN\r")
     index = connection.expect(["NAME","Are you adding"])
     if index == 1:
       connection.send("Y\r")
       connection.expect('COLLECTION SAMPLE DEFAULT')
       connection.send("\r")
       connection.expect('COLLECTION SAMPLE TUBE TOP COLOR')
       connection.send("\r")
       connection.expect("DEFAULT SPECIMEN")
     connection.send("^\r")
     connection.expect("COLLECTION SAMPLE NAME")
     connection.send("^\r")
     connection.expect("Select OPTION")
     connection.send("^\r")
  """
    @override DefaultKIDSBuildInstaller.preInstallationWork
    to manually create entries needed by patch
  """
  def preInstallationWork(self, vistATestClient, **kargs):
    connection = vistATestClient.getConnection()
    self.addAPSpecimen(connection)
    labTestArray = [["BONE MARROW", "SURGICAL PATHOLOGY"],
                    ["BRONCHIAL BIOPSY","SURGICAL PATHOLOGY"],
                    ["BRONCHIAL CYTOLOGY","CYTOLOGY"],
                    ["DERMATOLOGY","SURGICAL PATHOLOGY"],
                    ["FINE NEEDLE ASPIRATE","CYTOLOGY"],
                    ["GENERAL FLUID","CYTOLOGY"],
                    ["TISSUE EXAM","SURGICAL PATHOLOGY"],
                    ["GASTROINTESTINAL ENDOSCOPY","SURGICAL PATHOLOGY"],
                    ["GYNECOLOGY (PAP SMEAR)","CYTOLOGY"],
                    ["URINE CYTOLOGY","CYTOLOGY"],
                    ["UROLOGY,BLADDER/URETER","SURGICAL PATHOLOGY"],
                    ["UROLOGY,PROSTATE","SURGICAL PATHOLOGY"],
                    ["RENAL BIOPSY","SURGICAL PATHOLOGY"]
                    ]
    topographyArray = [ ["ABDOMEN", "113345001"],
 ["ADRENAL GLAND", "23451007"],
 ["ANAL CANAL", "34381000"],
 ["APPENDIX", "66754008"],
 ["ASCENDING COLON", "9040008"],
 ["BILE DUCT CYTOLOGIC MATERIAL", "110928002"],
 ["BILE DUCT MUCOUS MEMBRANE", "7035006"],
 ["BILIARY TRACT", "34707002"],
 ["BODY OF PANCREAS", "40133006"],
 ["BONE", "3138006"],
 ["BONE MARROW", "14016003"],
 ["BREAST", "76752008"],
 ["BRONCHIAL CYTOLOGIC MATERIAL", "110912007"],
 ["BRONCHUS", "955009"],
 ["CARDIAC INCISURE OF STOMACH", "5459006"],
 ["CARDIAC OSTIUM OF STOMACH", "63853002"],
 ["CARDIO-ESOPHAGEAL JUNCTION", "25271004"],
 ["CECUM", "32713005"],
 ["CEREBROSPINAL FLUID CYTOLOGIC MATERIAL", "110969006"],
 ["CERVICAL CYTOLOGIC MATERIAL", "110949001"],
 ["CHORIONIC VILLI", "2049008"],
 ["COLON", "71854001"],
 ["DESCENDING COLON", "32622004"],
 ["DUODENUM", "38848004"],
 ["ESOPHAGUS", "32849002"],
 ["ESOPHAGUS, LOWER THIRD", "67173009"],
 ["ESOPHAGUS, MIDDLE THIRD", "19000002"],
 ["ESOPHAGUS, UPPER THIRD", "54738009"],
 ["GASTRIC FUNDUS", "414003"],
 ["GASTRIC JUICE", "31773000"],
 ["GREATER CURVATURE OF STOMACH", "89382009"],
 ["HEAD OF PANCREAS", "64163001"],
 ["ILEUM", "34516001"],
 ["JEJUNUM", "21306003"],
 ["KIDNEY", "64033007"],
 ["LEFT COLIC FLEXURE", "72592005"],
 ["LEFT TESTIS", "63239009"],
 ["LESSER CURVATURE OF STOMACH", "80085006"],
 ["LIVER", "10200004"],
 ["LUNG", "39607008"],
 ["LYMPH NODE", "59441001"],
 ["MEDIASTINUM", "72410000"],
 ["NECK, LEFT SIDE", "170583000"],
 ["NECK, RIGHT SIDE", "170303002"],
 ["PANCREAS", "15776009"],
 ["PAROTID GLAND", "45289007"],
 ["PELVIS", "12921003"],
 ['PERICARDIAL CYTOLOGIC MATERIAL', "110919003"],
 ["PERIRENAL TISSUE", "47145004"],
 ["PERITONEAL CYTOLOGIC MATERIAL", "110944006"],
 ["PERITONEUM", "15425007"],
 ["PLEURAL CYTOLOGIC MATERIAL", "110913002"],
 ["PROSTATE", "41216001"],
 ["PYLORIC ANTRUM", "66051006"],
 ["PYLORUS", "280119005"],
 ["RECTOSIGMOID JUNCTION", "49832006"],
 ["RECTUM", "34402009"],
 ["RENAL PELVIS", "25990002"],
 ["RETROPERITONEUM", "82849001"],
 ["RIGHT COLIC FLEXURE", "48338005"],
 ["RIGHT TESTIS", "15598003"],
 ["SALIVARY GLAND", "385294005"],
 ["SIGMOID COLON", "60184004"],
 ["SKIN", "39937001"],
 ["SMALL INTESTINE", "30315005"],
 ["SOFT TISSUES", "87784001"],
 ["SPLEEN", "78961009"],
 ["STOMACH", "69695003"],
 ["SUBLINGUAL GLAND", "88481005"],
 ["SUBMAXILLARY GLAND", "54019009"],
 ["SUBPHRENIC FOSSA", "243974009"],
 ["SYNOVIAL CYTOLOGIC MATERIAL", "110895009"],
 ["TAIL OF PANCREAS", "73239005"],
 ["THYROID GLAND", "69748006"],
 ["TISSUE", "85756007"],
 ["TRANSVERSE COLON", "485005"],
 ["URETER", "87953007"],
 ["URINARY BLADDER", "89837001"],
 ["URINE", "78014005"],
 ["VAS DEFERENS", "57671007"],
 ["VERTEBRA", "51282000"]
 ]
    for entry in labTestArray:
      self.addLabTest(connection, entry[0],entry[1])
      self.addOrderableItemConnection(connection, entry[0])
    self.fixUrineTest(connection)
    self.editDisplayGroup(connection)
    for entry in topographyArray:
      self.addSNOMEDCode(connection, entry[0],entry[1])