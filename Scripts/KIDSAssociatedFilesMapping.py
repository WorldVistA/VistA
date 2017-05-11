#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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

"""
  single file name => kids install name
"""
KIDS_SINGLE_FILE_ASSOCIATION_DICT = {
  ### Info Files Section
  "CPRS GUI VERSION 28 NOTES.txt" : "MultiBuilds",
  "EDP-2.TXT" : "EDP 2.0",
  "MAG3_0P121.ReadMe.txt" : "MAG*3.0*121",
  "MOCHA_1.txt" : "PSJ*5.0*261",
  "PREC - PHARMACY ENTERPRISE CUSTOMIZATION SYSTEM RELEASE.txt" : "PREC*2.2*1",
  "PREN Release.txt" : "PREN*1.0*1",
  "Release of Patient Assessment Documentation Pkg_NUPA_1.txt" : "NUPA 1.0",
  "Release of VA NATIONAL HEALTH INFO NETWORK NHIN_1.txt" : "NHIN 1.0",
  "Update to NUPA_1.txt" : "NUPA 1.0",
  "XOBU_1-6 Security Suite Utility Pack.txt" : "XOBU 1.6",
  "CPRS 29 Source Code Note.txt" : "MultiBuilds",
  #### Global Files Section
  "LEX_2_51.GBL": "LEX*2.0*51",
  "LEX_2_74.GBL": "LEX*2.0*74",
  "LEX_2_76.GBL": "LEX*2.0*76",
  "LEX_2_77.GBL": "LEX*2.0*77",
  "LEX_2_78.GBL": "LEX*2.0*78",
  "LEX_2_79.GBL": "LEX*2.0*79",
  "LEX_2_82.GBLs": "LEX*2.0*82",
  "LEX_2_83.GBLs": "LEX*2.0*83",
  "LEX_2_84.GBLs": "LEX*2.0*84",
  "LEX_2_89.GBLs": "LEX*2.0*89",
  "LEX_2_90.GBLs": "LEX*2.0*90",
  "LEX_2_91.GBLs": "LEX*2.0*91",
  "LEX_2_93.GBLs": "LEX*2.0*93",
  "LEX_2_94.GBLs": "LEX*2.0*94",
  "LEX_2_95.GBLs": "LEX*2.0*95",
  "LEX_2_102.GBLs": "LEX*2.0*102",
  "LEX_2_105.GBLs": "LEX*2.0*105",
  "LEX_2_107.GBLs": "LEX*2.0*107",
  "LEX_2_108.GBLs": "LEX*2.0*108",
  "LEX_2_109.GBLs": "LEX*2.0*109",
}

"""
  regular expression match => kids install name
"""
KIDS_GROUP_FILES_ASSOCIATION_DICT = {
  "IBRC1101[A-F].TXT" : "IB*2.0*445",
  "IBRC1110[A-F].TXT" : "IB*2.0*462",
  "IBRC1201[A-F].TXT" : "IB*2.0*468",
  "IBRC1210[A-F].TXT" : "IB*2.0*484",
  "IBRC1301[A-F].TXT" : "IB*2.0*491",
  "IBRC1310[A-F].TXT" : "IB*2.0*508",
  "IBRC1401[A-F].TXT" : "IB*2.0*520",
}

def getAssociatedInstallName(fileName):
  import os
  import re
  from ConvertToExternalData import isValidSha1Suffix
  basename = os.path.basename(fileName)
  if isValidSha1Suffix(basename):
    basename = basename[:basename.rfind('.')]
  if basename in KIDS_SINGLE_FILE_ASSOCIATION_DICT:
    return KIDS_SINGLE_FILE_ASSOCIATION_DICT[basename]
  for regExp in KIDS_GROUP_FILES_ASSOCIATION_DICT:
    if re.search(regExp, basename):
      return KIDS_GROUP_FILES_ASSOCIATION_DICT[regExp]
  return None
