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
#---------------------------------------------------------------------------

import csv
import json
import re
import urllib

from PDFUtilityFunctions import *


PACKAGE_MAP = {
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
    'HEALTH MANAGEMENT PLATFORM' : 'Enterprise Health Management Platform',
    'ENTERPRISE HEALTH MGMT PLATFORM' : 'Enterprise Health Management Platform',
    'INTEGRATED PATIENT FUNDS' : 'Integrated Patient Fund',
    #  u'INDIAN HEALTH SERVICE',
    #  u'INSURANCE CAPTURE BUFFER',
    #  u'IV PHARMACY',
    'MASTER PATIENT INDEX': 'Master Patient Index VistA',
    'MCCR BACKBILLING' : 'MCCR National Database - Field',
    #  u'MINIMAL PATIENT DATASET',
    #  u'MOBILE SCHEDULING APPLICATIONS SUITE',
    #  u'Missing Patient Register',
    'MRSA INITIATIVE REPORTS' : 'Methicillin Resistant Staph Aurerus Initiative',
    'MYHEALTHEVET': 'My HealtheVet',
    'NATIONAL HEALTH INFO NETWORK' : 'National Health Information Network',
    'OCCUPAT HEALTH RECORD-KEEPING': 'Occupational Health Record-Keeping System',
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

PACKAGE_COMPONENT_MAP = {
    "Option": "19",
    "Function": ".5",
    "List_Manager_Templates": "409.61",
    "Dialog": ".84",
    "Key": "19.1",
    "Remote_Procedure": "8994",
    "Protocol": "101",
    "Help_Frame": "9.2",
    "Form": ".403",
    "Sort_Template": ".401",
    "HL7_APPLICATION_PARAMETER": "771",
    "Input_Template": ".402",
    "Print_Template": ".4"
}

# Do not generate the graph if have more than 30 nodes
MAX_DEPENDENCY_LIST_SIZE = 30

COLOR_MAP = {
    "Option": "orangered",
    "Function": "royalblue",
    "List_Manager_Templates": "saddlebrown",
    "Dialog": "turquoise",
    "Key": "limegreen",
    "Remote_Procedure": "firebrick",
    "Protocol": "indigo",
    "Help_Frame":  "moccasin",
    "Form": "cadetblue",
    "Sort_Template": "salmon",
    "HL7_APPLICATION_PARAMETER": "mediumvioletred",
    "Input_Template": "skyblue",
    "Print_Template": "yellowgreen",
    "Global": "magenta"
}

###############################################################################

def getDOXURL(local):
    if local:
        return "../dox"
    else:
        return "https://code.osehra.org/dox"

def getViViaNURL(local):
    if local:
        return local
    else:
        return "https://code.osehra.org/vivian/files"

###############################################################################

def findDotColor(object):
  return COLOR_MAP.get(object.getObjectType(), "black")

###############################################################################

def readIntoDictionary(infileName):
  values = {}
  with open(infileName,"r") as templateData:
    sniffer = csv.Sniffer()
    dialect = sniffer.sniff(templateData.read(1024))
    templateData.seek(0)
    hasHeader = sniffer.has_header(templateData.read(1024))
    templateData.seek(0)
    for index, line in enumerate(csv.reader(templateData,dialect)):
      if index == 0:
        continue
      if line[1] not in values:
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

###############################################################################

def getGlobalHtmlFileName(globalVar):
    if globalVar.isSubFile():
        return getFileManSubFileHtmlFileNameByName(globalVar.getFileNo())
    return getGlobalHtmlFileNameByName(globalVar.getName())

def getGlobalHtmlFileNameByName(globalName):
    return ("Global_%s.html" %
                        normalizeGlobalName(globalName))

def normalizeGlobalName(globalName):
    import base64
    return base64.urlsafe_b64encode(globalName)

def getGlobalPDFFileNameByName(globalName):
    return ("Global_%s.pdf" %
                        normalizeGlobalName(globalName))

def getFileManSubFileHtmlFileName(subFile):
    return getFileManSubFileHtmlFileNameByName(subFile.getFileNo())

def getFileManSubFileHtmlFileNameByName(subFileNo):
    return urllib.quote("SubFile_%s.html" % subFileNo)

def getFileManSubFilePDFFileNameByName(subFileNo):
    return urllib.quote("SubFile_%s.pdf" % subFileNo)

def getPackageHtmlFileName(packageName):
    return urllib.quote("Package_%s.html" %
                        normalizePackageName(packageName))

def getPackagePdfFileName(packageName):
    return urllib.quote("Package_%s.pdf" %
                        normalizePackageName(packageName))

def getPackageDependencyHtmlFileName(packageName, depPackageName):
    firstName = normalizePackageName(packageName)
    secondName = normalizePackageName(depPackageName)
    if firstName < secondName:
        temp = firstName
        firstName = secondName
        secondName = temp
    return "Package_%s-%s_detail.html" % (firstName, secondName)

def normalizePackageName(packageName):
    if packageName in PACKAGE_MAP:
       packageName = PACKAGE_MAP[packageName]
    newName = packageName.replace(' ', '_')
    return newName.replace('-', "_").replace('.', '_').replace('/', '_').replace('(', '_').replace(')', '_')

# Note: 'option' is the object NOT the name string
def getPackageObjHtmlFileName(option):
    if "Global" in str(type(option)):
        filename = getGlobalHtmlFileNameByName(option.getName())
    else:
        title = option.getObjectType()
        optionName = option.getName()
        filename = "%s_%s.html" % (title, normalizeName(optionName))
    return filename

def getPackageComponentLink(option):
    return urllib.quote(getPackageObjHtmlFileName(option))

def getRoutineLink(routineName):
    filename = "Routine_%s.html" % normalizeName(routineName)
    return urllib.quote(filename)

def getRoutineHRefLink(rtnName, dox_url, **kargs):
    crossRef = None
    if 'crossRef' in kargs:
        crossRef = kargs['crossRef']
    if crossRef:
        routine = crossRef.getRoutineByName(rtnName)
        if routine:
            return '<a href=\"%s/%s\">%s</a>' % (dox_url,
                                                getPackageComponentLink(routine),
                                                rtnName)
    return None

def getRoutinePdfFileName(routineName):
    filename = "Routine_%s.pdf" % normalizeName(routineName)
    return urllib.quote(filename)

def getRoutineSourceHtmlFileName(routineName):
    filename = "Routine_%s_source.html" % normalizeName(routineName)
    return urllib.quote(filename)

def normalizeName(name):
    return re.sub("[ /.*?&<>:\\\"|]", '_', name)

def getDataEntryHtmlFileName(ien, fileNo):
  return "%s-%s.html" % (fileNo, ien)

###############################################################################

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
        if depMetricsList[i*2]:
            if not edgeLabel:
              edgeLabel = labelText[i]
            elif isEdgeLabel:
              edgeLabel = "%s\\n%s" % (edgeLabel, labelText[i])
            else:
              edgeLabel = "%s:%s" % (edgeLabel, labelText[i])
            if edgeToolTip:
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
