#---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Agent
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

import csv
import json
import logging
import os
import re
import sys
import tempfile
import urllib
from LogManager import logger

from PDFUtilityFunctions import *


pkgMap = {
    'AUTOMATED INFO COLLECTION SYS': 'Automated Information Collection System',
    'AUTOMATED MED INFO EXCHANGE': 'Automated Medical Information Exchange',
    'BAR CODE MED ADMIN': 'Barcode Medication Administration',
    'CLINICAL INFO RESOURCE NETWORK': 'Clinical Information Resource Network',
    #  u'DEVICE HANDLER',
    #  u'DISCHARGE SUMMARY',
    'E CLAIMS MGMT ENGINE': 'E Claims Management Engine',
    #  u'EDUCATION TRACKING',
    'EMERGENCY DEPARTMENT': 'Emergency Department Integration Software',
    #  u'EXTENSIBLE EDITOR',
    #  u'EXTERNAL PEER REVIEW',
    'FEE BASIS CLAIMS SYSTEM' : 'Fee Basis',
    'GEN. MED. REC. - GENERATOR': 'General Medical Record - Generator',
    'GEN. MED. REC. - I/O' : 'General Medical Record - IO',
    'GEN. MED. REC. - VITALS' : 'General Medical Record - Vitals',
    #  u'GRECC',
    #  u'HEALTH MANAGEMENT PLATFORM',
    #  u'INDIAN HEALTH SERVICE',
    #  u'INSURANCE CAPTURE BUFFER',
    #  u'IV PHARMACY',
    'MASTER PATIENT INDEX': 'Master Patient Index VistA',
    'MCCR BACKBILLING' : 'MCCR National Database - Field',
    #  u'MINIMAL PATIENT DATASET',
    #  u'MOBILE SCHEDULING APPLICATIONS SUITE',
    #  u'Missing Patient Register',
    'MYHEALTHEVET': 'My HealtheVet',
    'NATIONAL HEALTH INFO NETWORK' : 'National Health Information Network',
    #  u'NEW PERSON',
    #  u'PATIENT ASSESSMENT DOCUM',
    #  u'PATIENT FILE',
    #  u'PROGRESS NOTES',
    #  u'QUALITY ASSURANCE',
    #  u'QUALITY IMPROVEMENT CHECKLIST',
    #  u'REAL TIME LOCATION SYSTEM',
    'TEXT INTEGRATION UTILITIES' : 'Text Integration Utility',
    #  u'UNIT DOSE PHARMACY',
    'VA POINT OF SERVICE (KIOSKS)' : 'VA Point of Service',
    #  u'VDEM',
    'VISTA INTEGRATION ADAPTOR' : 'VistA Integration Adapter',
    'VENDOR - DOCUMENT STORAGE SYS' : 'Vendor - Document Storage Systems'
    #  u'VETERANS ADMINISTRATION',
    #  u'VOLUNTARY SERVICE SYSTEM',
    #  u'VPFS',
    #  u'cds',
    #  u'person.demographics',
    #  u'person.lookup',
    #  u'term',
    #  u'term.access'])
} # this is the mapping between CUSTODIAL PACKAGE and packages in Dox

sectionLinkObj = {
    "Option":{"number":"19", "color":"color=orangered"},
    "Function":{"number":".5", "color":"color=royalblue"},
    "List_Manager_Templates":{"number":"409.61", "color":"color=saddlebrown"},
    "Dialog":{"number":".84", "color":"color=turquoise"},
    "Key":{"number":"19.1", "color":"color=limegreen"},
    "Remote_Procedure":{"number":"8994", "color":"color=firebrick"},
    "Protocol":{"number":"101", "color":"color=indigo"},
    "Help_Frame":{"number":"9.2", "color":"color=moccasin"},
    "Form":{"number":".403", "color":"color=cadetblue"},
    "Sort_Template":{"number":".401", "color":"color=salmon"},
    "HL7_APPLICATION_PARAMETER":{"number":"771", "color":"color=violetred"},
    "Input_Template": {"number":".402","color":"color=skyblue"},
    "Print_Template": {"number":".4","color":"color=yellowgreen"},
    }


###############################################################################
# Logging

def getTempLogFile(filename):
    return os.path.join(tempfile.gettempdir(), filename)

def initLogging(outputFileName):
    logger.setLevel(logging.DEBUG)
    fileHandle = logging.FileHandler(outputFileName, 'w')
    fileHandle.setLevel(logging.DEBUG)
    formatStr = '%(asctime)s %(message)s'
    formatter = logging.Formatter(formatStr)
    fileHandle.setFormatter(formatter)
    #set up the stream handle (console)
    consoleHandle = logging.StreamHandler(sys.stdout)
    consoleHandle.setLevel(logging.INFO)
    consoleFormatter = logging.Formatter(formatStr)
    consoleHandle.setFormatter(consoleFormatter)
    logger.addHandler(fileHandle)
    logger.addHandler(consoleHandle)

###############################################################################

def getDOXURL(local):
    if local:
        return "../dox/"
    else:
        return "https://code.osehra.org/dox/"

def getViViaNURL(local):
    if local:
        return "../"
    else:
        return "https://code.osehra.org/vivian/files/"

###############################################################################

def findDotColor(object, title=""):
  color = "color=black"
  if "getObjectType" in dir(object):
    color = sectionLinkObj[object.getObjectType()]["color"]
  elif "Global" in str(type(object)):
    color = "color=magenta"
  return color

###############################################################################

def readIntoDictionary(infileName):
  values = {}
  with open(infileName,"r") as templateData:
    sniffer = csv.Sniffer()
    dialect = sniffer.sniff(templateData.read(1024))
    templateData.seek(0)
    hasHeader = sniffer.has_header(templateData.read(1024))
    logger.info ("hasHeader: %s" % hasHeader)
    templateData.seek(0)
    for index, line in enumerate(csv.reader(templateData,dialect)):
      if index == 0:
        continue
      if line[1] not in values.keys():
        values[line[1]] = []
      values[line[1]].append(line)
  return values

def parseICRJson(icrJson):
  # Reads in the ICR JSON file and generates
  # a dictionary that consists of only the routine information
  #
  # Each key is a routine and it points to a list of all of the entries
  # that have that routine marked as a "ROUTINE" field.
  #
  parsedICRJSON = {}
  with open(icrJson, 'r') as icrFile:
    icrEntries =  json.load(icrFile)
    for entry in icrEntries:
      if 'CUSTODIAL PACKAGE' in entry:
        # Finding a Custodial Package means the entry should belong somewhere, for now
        # we ignore those that don't have one
        if not (entry['CUSTODIAL PACKAGE'] in parsedICRJSON):
          # First time we come across a package, add dictionaries for the used types
          parsedICRJSON[entry['CUSTODIAL PACKAGE']] = {}
          parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"] = {}
          parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"] = {}
          parsedICRJSON[entry['CUSTODIAL PACKAGE']]["OTHER"] = {}
          parsedICRJSON[entry['CUSTODIAL PACKAGE']]["OTHER"]["ENTRIES"] = []
        if "ROUTINE" in entry:
          if not (entry["ROUTINE"] in parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"]):
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"][entry["ROUTINE"]] = []
          parsedICRJSON[entry['CUSTODIAL PACKAGE']]["ROUTINE"][entry["ROUTINE"]].append(entry)
        elif "GLOBAL ROOT" in entry:
          globalRoot = entry['GLOBAL ROOT'].replace(',','')
          if not (globalRoot in parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"]):
            parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"][globalRoot] = []
          parsedICRJSON[entry['CUSTODIAL PACKAGE']]["GLOBAL"][globalRoot].append(entry)
        else:
          # Take all other entries into "OTHER", so that they can be shown on the package page
          parsedICRJSON[entry['CUSTODIAL PACKAGE']]["OTHER"]["ENTRIES"].append(entry)
  return parsedICRJSON

def getRoutineHtmlFileName(routineName, title=""):
    return urllib.quote(getRoutineHtmlFileNameUnquoted(routineName))

def getRoutineHtmlFileNameUnquoted(routineName, title=""):
    return "Routine_%s.html" % routineName

def getGlobalHtmlFileNameByName(globalName):
    return ("Global_%s.html" %
                        normalizeGlobalName(globalName))

def normalizeGlobalName(globalName):
    import base64
    return base64.urlsafe_b64encode(globalName)

def getPackageHtmlFileName(packageName):
    return urllib.quote("Package_%s.html" %
                        normalizePackageName(packageName))

def normalizePackageName(packageName):
    if packageName in pkgMap:
       packageName = pkgMap[packageName]
    newName = packageName.replace(' ', '_')
    return newName.replace('-', "_").replace('.', '_').replace('/', '_')

def getPackageObjHtmlFileNameUnquoted(optionName, title=""):
    title = "Routine"
    if "getObjectType" in dir(optionName):
      title = optionName.getObjectType()
    elif "Global" in str(type(optionName)):
      return getGlobalHtmlFileNameByName(optionName.getName())
    if not isinstance(optionName,basestring):
      optionName = optionName.getName()
    return "%s_%s.html" % (title, re.sub("[ /.*?&<>:]",'_',optionName))

def getPackageObjHtmlFileName(FunctionName, title=""):
    return urllib.quote(getPackageObjHtmlFileNameUnquoted(FunctionName, title))

def getPackageDependencyHtmlFile(packageName, depPackageName):
    firstName = normalizePackageName(packageName)
    secondName = normalizePackageName(depPackageName)
    if firstName < secondName:
        temp = firstName
        firstName = secondName
        secondName = temp
    return "Package_%s-%s_detail.html" % (firstName, secondName)

#==============================================================================
#  return a tuple of Edge Label, Edge ToolTip, Edge Style
#==============================================================================
def getPackageGraphEdgePropsByMetrics(depMetricsList,
                                      toolTipStartPackage,
                                      toolTipEndPackage,
                                      isEdgeLabel=True):
    assert(len(depMetricsList) >= 8)
    # default for routine only
    toolTip =("Total %d routine(s) in %s called total %d routine(s) in %s" % (depMetricsList[0],
                                                                 toolTipStartPackage,
                                                                 depMetricsList[1],
                                                                 toolTipEndPackage),
              "Total %d routine(s) in %s accessed total %d global(s) in %s" % (depMetricsList[2],
                                                                 toolTipStartPackage,
                                                                 depMetricsList[3],
                                                                 toolTipEndPackage),
              "Total %d fileman file(s) in %s pointed to total %d fileman file(s) in %s" % (depMetricsList[4],
                                                                 toolTipStartPackage,
                                                                 depMetricsList[5],
                                                                 toolTipEndPackage),
              "Total %d routines(s) in %s accessed via fileman db calls to total %d fileman file(s) in %s" % (depMetricsList[6],
                                                                 toolTipStartPackage,
                                                                 depMetricsList[7],
                                                                 toolTipEndPackage),
              "Total %d Package Component(s) in %s accessed total %d Routine(s) in %s" % (depMetricsList[8],
                                                                 toolTipStartPackage,
                                                                 depMetricsList[9],
                                                                 toolTipEndPackage),
              "Total %d Global(s) in %s accessed total %d Routines(s) in %s" % (depMetricsList[10],
                                                                 toolTipStartPackage,
                                                                 depMetricsList[11],
                                                                 toolTipEndPackage),
              "Total %d Global(s) in %s accessed total %d Routines(s) in %s" % (depMetricsList[12],
                                                                 toolTipStartPackage,
                                                                 depMetricsList[13],
                                                                 toolTipEndPackage)
              )
    labelText =("%s(R)->(R)%s" % (depMetricsList[0],depMetricsList[1]),
                "%s(R)->(G)%s" % (depMetricsList[2],depMetricsList[3]),
                "%s(F)->(F)%s" % (depMetricsList[4],depMetricsList[5]),
                "%s(R)->(F)%s" % (depMetricsList[6],depMetricsList[7]),
                "%s(PC)->(R)%s" % (depMetricsList[8],depMetricsList[9]),
                "%s(G)->(R)%s" % (depMetricsList[10],depMetricsList[11]),
                "%s(G)->(G)%s" % (depMetricsList[12],depMetricsList[13])
                )

    metricValue = 0
    (edgeLabel, edgeToolTip, edgeStyle) = ("","","")
    metricValue = 0
    for i in range(0,7):
        if depMetricsList[i*2] > 0:
            if len(edgeLabel) == 0:
              edgeLabel = labelText[i]
            elif isEdgeLabel:
              edgeLabel = "%s\\n%s" % (edgeLabel, labelText[i])
            else:
              edgeLabel = "%s:%s" % (edgeLabel, labelText[i])
            if len(edgeToolTip) > 0:
              edgeToolTip = "%s. %s" % (edgeToolTip, toolTip[i])
            else:
              edgeToolTip = toolTip[i]
            metricValue += 1 * 2**i
    if metricValue >= 7:
        edgeStyle = "bold"
    elif metricValue == 2:
        edgeStyle = "dashed"
    elif metricValue == 4:
        edgeStyle = "dotted"
    else:
        edgeStyle = "solid"
    return (edgeLabel, edgeToolTip, edgeStyle)

#==============================================================================
## Method to generate merge and sorted Dependeny list by Package
#==============================================================================
def mergeAndSortDependencyListByPackage(package, isDependencyList):
    depPackageMerged = mergePackageDependenciesList(package, isDependencyList)
    # sort by the sum of the total # of routines
    depPackages = sorted(depPackageMerged.keys(),
                       key=lambda item: sum(depPackageMerged[item][0:7:2]),
                       reverse=True)
    return (depPackages, depPackageMerged)

#==============================================================================
# Return a dict with package as key, a list of 6 as value
#==============================================================================
def mergePackageDependenciesList(package, isDependencies=True):
    packageDepDict = dict()
    if isDependencies:
        routineDeps = package.getPackageRoutineDependencies()
        globalDeps = package.getPackageGlobalDependencies()
        globalRtnDeps = package.getPackageGlobalRoutineDependencies()
        globalGblDeps = package.getPackageGlobalGlobalDependencies()
        fileManDeps = package.getPackageFileManFileDependencies()
        dbCallDeps = package.getPackageFileManDbCallDependencies()
        optionDeps = package.getPackageComponentDependencies()
    else:
        routineDeps = package.getPackageRoutineDependents()
        globalDeps = package.getPackageGlobalDependents()
        globalRtnDeps = package.getPackageGlobalRoutineDependendents()
        globalGblDeps = package.getPackageGlobalGlobalDependents()
        fileManDeps = package.getPackageFileManFileDependents()
        dbCallDeps = package.getPackageFileManDbCallDependents()
        optionDeps = {}
    for (package, depTuple) in routineDeps.iteritems():
        if package not in packageDepDict:
            packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        packageDepDict[package][0] = len(depTuple[0])
        packageDepDict[package][1] = len(depTuple[1])
    for (package, depTuple) in globalDeps.iteritems():
        if package not in packageDepDict:
            packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        packageDepDict[package][2] = len(depTuple[0])
        packageDepDict[package][3] = len(depTuple[1])
    for (package, depTuple) in fileManDeps.iteritems():
        if package not in packageDepDict:
            packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        packageDepDict[package][4] = len(depTuple[0])
        packageDepDict[package][5] = len(depTuple[1])
    for (package, depTuple) in dbCallDeps.iteritems():
        if package not in packageDepDict:
            packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        packageDepDict[package][6] = len(depTuple[0])
        packageDepDict[package][7] = len(depTuple[1])
    for (package, depTuple) in optionDeps.iteritems():
        if package not in packageDepDict:
            packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        packageDepDict[package][8] = len(depTuple[0])
        packageDepDict[package][9] = len(depTuple[1])
    for (package, depTuple) in globalRtnDeps.iteritems():
        if package not in packageDepDict:
            packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        packageDepDict[package][10] = len(depTuple[0])
        packageDepDict[package][11] = len(depTuple[1])
    for (package, depTuple) in globalGblDeps.iteritems():
        if package not in packageDepDict:
            packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        packageDepDict[package][12] = len(depTuple[0])
        packageDepDict[package][13] = len(depTuple[1])
    return packageDepDict