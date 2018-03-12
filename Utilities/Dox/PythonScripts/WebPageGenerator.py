#!/usr/bin/env python

# A python script to generate the
# Visual Cross Reference Documentation (DOX) pages.
#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
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

import argparse
import bisect
import csv
import io
import json
import logging
import os
import os.path
import re
import shutil
import string
import subprocess
import sys
import urllib

from operator import itemgetter
from LogManager import logger
from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser
from CrossReference import *


# Note: Other scripts depend on the pkgMap
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

MAX_DEPENDENCY_LIST_SIZE = 30 # Do not generate the graph if have more than 30 nodes
PROGRESS_METER = 1000

GLOBAL_VARIABLE_SECTION_HEADER_LIST = [
     "Name",
      '''Line Occurrences &nbsp;(* Changed, &nbsp;! Killed)''']
FILENO_FILEMANDB_SECTION_HEADER_LIST = [
     "FileNo",
      '''Call Tags''']
RPC_REFERENCE_SECTION_HEADER_LIST = [
     "RPC Name",
      '''Call Tags''']
HL7_REFERENCE_SECTION_HEADER_LIST = [
     "HL7 Protocol Name",
      '''Call Tags''']
LABEL_REFERENCE_SECTION_HEADER_LIST = ["Name", "Line Occurrences"]
ENTRY_POINT_SECTION_HEADER_LIST = ["Name", "Comments", "DBIA/ICR reference"]
DEFAULT_VARIABLE_SECTION_HEADER_LIST = ["Name", "Line Occurrences",]

LINE_TAG_PER_LINE = 10

# constants for html page
GOOGLE_ANALYTICS_JS_CODE = """
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-26757196-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'https://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
"""

TOP_INDEX_BAR_PART = """
<center>
<a href="index.html" class="qindex">Home</a>&nbsp;&nbsp;
<a href="packages.html" class="qindex">Package List</a>&nbsp;&nbsp;
<a href="routines.html" class="qindex">Routine Alphabetical List</a>&nbsp;&nbsp;
<a href="globals.html" class="qindex">Global Alphabetical List</a>&nbsp;&nbsp;
<a href="filemanfiles.html" class="qindex">FileMan Files List</a>&nbsp;&nbsp;
<a href="filemansubfiles.html" class="qindex">FileMan Sub-Files List</a>&nbsp;&nbsp;
<a href="Packages_Namespace_Mapping.html" class="qindex">
Package-Namespace Mapping</a>&nbsp;&nbsp;
<BR>
</center>
<script type="text/javascript" src="PDF_Script.js"></script>
"""

COMMON_HEADER_PART = """
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html><head>
<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.32/vfs_fonts.js"></script>
<link href="DoxygenStyle.css" rel="stylesheet" type="text/css">
"""

SWAP_VIEW_HTML = """
<button id="swapDisplay">Switch Display Mode</button>
<script type="text/javascript\">
  $(window).on("scroll",function(event) {
    scrollLoc = 55 - $(this).scrollTop()
    if(scrollLoc < 0) scrollLoc=0
    $("#pageCommands").css('top',scrollLoc);
  });
  $("#swapDisplay").click( function(event) {
    if ($("#terseDisplay").is(':visible')) {
      $("#terseDisplay").hide()
      $("#expandedDisplay").show()
    }
    else {
      $("#terseDisplay").show()
      $("#expandedDisplay").hide()
    }
  });
</script>
"""

HEADER_END = """
</head>
"""
DEFAULT_BODY_PART = """
<body bgcolor="#ffffff">
"""
SOURCE_CODE_BODY_PART = """
<body bgcolor="#ffffff" onload="prettyPrint()">
"""
CODE_PRETTY_JS_CODE = """
<link href="code_pretty_scripts/prettify.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="code_pretty_scripts/prettify.js"></script>
<script type="text/javascript" src="code_pretty_scripts/lang-mumps.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
"""
INDEX_HTML_PAGE_HEADER = """
<div class="header">
  <div class="headertitle">
  </div>
 <h1>VistA Cross Reference Documentation</h1>
</div>
"""

XINDEXLegend = """
  <div>
    <h3>Legend:</h3>
    <table>
      <tbody>
        <tr>
          <td class="IndexKey"> >> </td>
          <td class="IndexValue"> Not killed explicitly</td>
          </tr><tr>
          <td class="IndexKey"> * </td>
          <td class="IndexValue">Changed</td>
          </tr><tr>
          <td class="IndexKey"> ! </td>
          <td class="IndexValue">Killed</td>
          </tr><tr>
          <td class="IndexKey">~</td>
          <td class="IndexValue">Newed</td>
        </tr>
      </tbody>
    </table>
    <br/>
"""

INDEX_HTML_PAGE_OSEHRA_IMAGE_PART = """
<br/>
<left>
<div class="content">
<a href="https://www.osehra.org">
<img src="https://www.osehra.org/profiles/drupal_commons/themes/commons_osehra_earth/logo.png"
style="border-width:0" alt="OSEHRA" /></a>
</div>
</left>
<br/>
"""

INDEX_HTML_PAGE_INTRODUCTION_PART = """
<h2><a class ="anchor" id="intro"></a>Introduction</h2>
<p>
Welcome to VistA Cross Reference Documentation Page.
This documentation is generated with the results of XINDEX and
 FileMan Data Dictionary utility running against the VistA code base pulled
 from the <a href="https://code.osehra.org/gitweb?p=VistA-M.git;a=summary"/>
repository</a>.
This documentation provides direct dependency information among packages,
 among FileMan files,  between globals and routines,
 as well as direct call/caller graphs and source code for individual routine.
<br/>
<h2><a class ="anchor" id="howto"></a>How to use this documentation</h2>
<ul><li>
To view information related to a specified package like dependency graph,
assigned namespaces, FileMan files, globals and routines list, please click
 "<a href="packages.html" class="qindex">Package List</a>" link at the top
 and select the package that you are interested in.
</li><li>
To view information related to a specified FileMan file like fields,
 direct access routines and FileMan pointer dependency list, please click
 "<a href="filemanfiles.html" class="qindex">FileMan Files List</a>" link at
 the top and select the FileMan file that you are interested in.
</li><li>
To view information related to a specified routine/global, you can either
find the routine/global via
 "<a href="routines.html" class="qindex">Routine Alphabetical List</a>"/
"<a href="globals.html" class="qindex">Global Alphabetical List</a>" link or
 under the individual package page.
</li></ul>
<br/>
<br/>
"""

def writePDFCustomization(outputFile, titleList):
  outputFile.write("<script>initTitleList="+titleList+"\n")
  outputFile.write(" initTitleList.forEach(function(obj) {\n")
  outputFile.write('''   if (obj == "Doc") {return }\n''');
  outputFile.write('''   $("#pdfSelection").append('<input class="headerVal" type="checkbox" val="'+obj+'" checked>'+obj+'</input>')\n''');
  outputFile.write('''   $("#pdfSelection").append('<br/>')\n''');
  outputFile.write(" })\n")
  outputFile.write("</script>\n")

# utility functions
accordionOpenFun = """
    <script type='text/javascript'>
        function openAccordionVal(event) {
            $('.accordion').accordion( {active:false, collapsible:true });
            classVal = ".accordion"
            if (event.target.classList[1] != "Allaccord") {
              classVal= classVal+"."+event.target.classList[1]
            }
            $(classVal).accordion( 'option', 'active',0 );
        }
    </script>

"""

def getAccordionHTML():
  return """
    <script type='text/javascript'>
       $( document ).ready(function() {
           $( '.accordion' ).accordion({
               heightStyle: "content",
               collapsible: true,
               active: false
           })
       })
    </script>
  """

# Note: This function is called from other scripts
def getGlobalHtmlFileNameByName(globalName):
    return ("Global_%s.html" %
                        normalizeGlobalName(globalName))
def getICRHtmlFileName(icrEntry):
    # TODO: Needs to be a more general address?
    return ("https://code.osehra.org/vivian/files/ICR/ICR-%s.html" % icrEntry["NUMBER"])

def getGlobalHtmlFileName(globalVar):
    if globalVar.isSubFile():
        return getFileManSubFileHtmlFileNameByName(globalVar.getFileNo())
    return getGlobalHtmlFileNameByName(globalVar.getName())

def getGlobalDisplayName(globalVar):
    if globalVar.isFileManFile():
        return "%s(#%s)" % ( globalVar.getFileManName(), globalVar.getFileNo() )
    return globalVar.getName()

def getICRDisplayName(icrEntry):
    outString = "ICR Entry: %s <br><ul>" % (icrEntry["NUMBER"])
    if "TYPE" in icrEntry:
      outString +="<li>TYPE: %s</li>" % (icrEntry["TYPE"])
      if icrEntry["TYPE"] == "Routine":
        if "ROUTINE" in icrEntry:
          outString += "<li>Routine Called: %s</li>" % (icrEntry['ROUTINE'])
      if icrEntry["TYPE"] == "File":
        if "GLOBAL ROOT" in icrEntry:
          outString += "<li>Global Ref Called: %s</li>" % (icrEntry["GLOBAL ROOT"])
    if "STATUS" in icrEntry:
      outString +="<li>Status: %s</li>" % (icrEntry["STATUS"])
    if "USAGE" in icrEntry:
      outString +="<li>Usage: %s</li></ul>" % (icrEntry["USAGE"])
    return outString

# FileMan File (Global) related Functions
def getFileManFileHypeLink(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    if GlobalVar.isSubFile():
        return getFileManSubFileHtmlFileNameByName(GlobalVar.getFileNo())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      getGlobalDisplayName(GlobalVar))

def getFileManFileHypeLinkWithFileNo(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      GlobalVar.getFileNo())

def getFileManFileHypeLinkWithFileManName(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      GlobalVar.getFileManName())

def getFileManFileHyperLinkWithNameFileNo(GlobalVar):
    if not GlobalVar.isFileManFile():
        return getGlobalHypeLinkByName(GlobalVar.getName())
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileName(GlobalVar),
                                      "%s - [#%s]" % (GlobalVar.getName(),
                                      GlobalVar.getFileNo()))

# sub fileman files related functions
def getFileManSubFileHtmlFileNameByName(subFileNo):
    return urllib.quote("SubFile_%s.html" % subFileNo)
def getFileManSubFileHtmlFileName(subFile):
    return getFileManSubFileHtmlFileNameByName(subFile.getFileNo())
def getFileManSubFileHypeLinkByName(subFileNo):
    return "<a href=\"%s\">%s</a>" % (getFileManSubFileHtmlFileNameByName(subFileNo),
                                      subFileNo)
def getFileManSubFileHypeLinkWithName(subFile):
    return ("<a href=\"%s\">%s</a>" %
            (getFileManSubFileHtmlFileName(subFile),
                                      subFile.getFileManName()))

# Note: This function is called from other scripts
def getRoutineHtmlFileName(routineName):
    return urllib.quote(getRoutineHtmlFileNameUnquoted(routineName))

def getRoutineHtmlFileNameUnquoted(routineName):
    return "Routine_%s.html" % routineName

# Note: This function is called from other scripts
def getPackageHtmlFileName(packageName):
    return urllib.quote("Package_%s.html" %
                        normalizePackageName(packageName))

def getRoutineHypeLinkByName(routineName):
    return "<a href=\"%s\">%s</a>" % (getRoutineHtmlFileName(routineName),
                                      routineName)
def getGlobalHypeLinkByName(globalName):
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileNameByName(globalName),
                                      globalName)

def getPackageHyperLinkByName(packageName):
    if packageName in pkgMap:
      packageName = pkgMap[packageName]
    return "<a href=\"%s\">%s</a>" % (getPackageHtmlFileName(packageName),
                                      packageName)

# Note: This function is called from other scripts
def normalizePackageName(packageName):
    newName = packageName.replace(' ', '_')
    return newName.replace('-', "_").replace('.', '_').replace('/', '_')

def normalizeGlobalName(globalName):
    import base64
    return base64.urlsafe_b64encode(globalName)

def getRoutineSourceCodeFileByName(routineName, packageName, sourceDir):
    return os.path.join(sourceDir, "Packages" +
                        os.path.sep + packageName +
                        os.path.sep + "Routines" +
                        os.path.sep +
                        routineName + ".m")

def getRoutineSourceHtmlFileNameUnquoted(routineName):
    return "Routine_%s_source.html" % routineName

def getRoutineSourceHtmlFileName(routineName):
    return urllib.quote(getRoutineSourceHtmlFileNameUnquoted(routineName))

# generate index bar based on input list
def generateIndexBar(outputFile, inputList, archList=None, isIndex=False, printButton=False):
    if (not inputList) or len(inputList) == 0:
        return
    hasArchList = archList and len(archList) == len(inputList)
    outputFile.write(accordionOpenFun)
    outputFile.write("<div class=\"qindex\">\n")
    for i in range(len(inputList) - 1):
        if hasArchList:
            archName = archList[i]
        else:
            archName = inputList[i]
        outputFile.write("<a onclick=\"openAccordionVal(event)\" class=\"qindex %s\" href=\"#%s\">%s</a>&nbsp;|&nbsp;\n" % (archName.split(" ")[0],archName,
                                                                                     inputList[i]))
    if hasArchList:
        archName = archList[-1]
    else:
        archName = inputList[-1]
    outputFile.write("<a onclick=\"openAccordionVal(event)\" class=\"qindex %s\" href=\"#%s\">%s</a>&nbsp;|&nbsp;\n" % (archName.split(" ")[0],archName,
        inputList[-1]))
    outputFile.write("<a onclick=\"openAccordionVal(event)\" class=\"qindex Allaccord\" href=\"#%s\">%s</a></div>\n" % ("All","All"))
    if not isIndex and printButton:
      outputFile.write("<button class=\"printButton\" onclick=\"startWritePDF(event)\">PRINT</button></div>\n")
      outputFile.write("<div style=\"display:none;\" id=pdfSelection>\n")
      outputFile.write('''<h3>Customize PDF page</h3>\n''');
      outputFile.write('''<p>Select the objects that you wish to see in the downloaded PDF</p>\n''');
      outputFile.write('''</div>\n''');

# generate Indexed Page Table Row
def generateIndexedTableRow(outputFile, inputList, httpLinkFunction,
                            nameFunc=None, indexSet=set(char for char in string.uppercase)):
    if not inputList or len(inputList) == 0:
        return
    outputFile.write("<tr>")
    for item in inputList:
        if len(item) == 1 and item in indexSet:
            outputFile.write("<td><a name=\"%s\"></a>" % item)
            outputFile.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">")
            outputFile.write("<tr><td><div class=\"ah\">&nbsp;&nbsp;%s&nbsp;&nbsp;</div></td></tr>" % item)
            outputFile.write("</table></td>")
            indexSet.remove(item)
        else:
            displayName = item
            if nameFunc:
                displayName = nameFunc(item)
            outputFile.write("<td><a class=\"el\" href=\"%s\">%s</a>&nbsp;&nbsp;&nbsp;</td>" %
                             (httpLinkFunction(item),
                              displayName))
    outputFile.write("</tr>\n")

def generateIndexedPackageTableRow(outputFile, inputList,
                                   nameFunc=None, indexSet=set(char for char in string.uppercase)):
    generateIndexedTableRow(outputFile, inputList, getPackageHtmlFileName,
                            nameFunc, indexSet)

def generateIndexedRoutineTableRow(outputFile, inputList,
                                   nameFunc=None, indexSet=set(char for char in string.uppercase)):
    generateIndexedTableRow(outputFile, inputList, getRoutineHtmlFileName,
                            nameFunc, indexSet)

def generateIndexedGlobalTableRow(outputFile, inputList,
                                  nameFunc=None, indexSet=set(char for char in string.uppercase)):
    generateIndexedTableRow(outputFile, inputList, getGlobalHtmlFileNameByName,
                            nameFunc, indexSet)

def getPackageDependencyHtmlFile(packageName, depPackageName):
    firstName = normalizePackageName(packageName)
    secondName = normalizePackageName(depPackageName)
    if firstName < secondName:
        temp = firstName
        firstName = secondName
        secondName = temp
    return "Package_%s-%s_detail.html" % (firstName, secondName)

def getPackagePackageDependencyHyperLink(packageName, depPackageName, name,
                                         tooltip, dependency):
    if dependency:
        edgeLinkArch = packageName
    else:
        edgeLinkArch = depPackageName
    packageDependencyHtmlFile = getPackageDependencyHtmlFile(packageName, depPackageName)
    return "<a href=\"%s#%s\", title=\"%s\">%s</a>" % (packageDependencyHtmlFile,
                                                       edgeLinkArch,
                                                       tooltip,
                                                       name)

#------------------------------------------------------------------------------
# Html helper functions
#------------------------------------------------------------------------------
def writeTableHeader(headerList, outputFile, classid=""):
    outputFile.write("<table>\n")
    outputFile.write("<tr class=\"%s\">\n" % classid)
    for header in headerList:
        outputFile.write("<th class=\"IndexKey\">%s</th>\n" % header)
    outputFile.write("</tr>\n")

def writeListData(listData, outputFile, classid=""):
    outputFile.write(generateHtmlListData(listData, classid))

def generateHtmlListData(listData, classid=""):
    if not listData : return "<div></div>"
    output = "<div class=\"%s\"><ul>" % classid
    for item in listData:
        output += "<li>%s</li>" % item
    output += "</ul></div>"
    return output

def listDataToCommaSeperatorString(listData):
    if not listData: return ""
    result = ""
    index = 0
    for item in listData:
        if index < len(listData) - 1:
            result += "%s,&nbsp;" % item
        else:
            result += "%s&nbsp;" % item
        index += 1
    return result

def writeSectionHeader(headerName, archName, outputFile):
    outputFile.write("<div class='accordion %s'><h2 align=\"left\"><a name=\"%s\">%s</a></h2>\n"
        % (archName.split(" ")[0], archName, headerName))

def writeSectionEnd(outputFile):
    outputFile.write("</div>")

def writeSubSectionHeader(headerName, outputFile, classid=""):
    outputFile.write("<h3 class=\"%s\"align=\"left\">%s</h3>\n" % (classid, headerName))

###############################################################################
# class to generate the web page based on input
class WebPageGenerator:
    def __init__(self, crossReference, outDir, repDir, docRepDir, git,
                 includeSource=False, rtnJson=None):
        self._crossRef = crossReference
        self._allPackages = crossReference.getAllPackages()
        self._allRoutines = crossReference.getAllRoutines()
        self._allGlobals = crossReference.getAllGlobals()
        self._outDir = outDir
        self._repDir = repDir
        self._docRepDir = docRepDir
        self._git = git
        self._header = [] # TODO: Not used? header.html is in repo and __includeHeader__ is called.. a lot
        self._footer = []
        self._dot = ""
        self._source_header = []  # TODO: Not used?
        self._includeSource = includeSource
        self.__initWebTemplateFile__()
        with open(rtnJson, 'r') as jsonFile:
            self._rtnRefJson = json.load(jsonFile)

    def __initWebTemplateFile__(self):
        #load _header and _footer in the memory
        self.__generateHtmlPageHeader__(True)
        self.__generateHtmlPageHeader__(False)
        webDir = os.path.join(self._docRepDir, "Web")
        footer = open(os.path.join(webDir, "footer.html"), 'r')
        for line in footer:
            self._footer.append(line)
        footer.close()

    def setDot(self, dot):
        self._dot = dot

    def __includeHeader__(self, outputFile, indexList=""):
        for line in (self._header):
            outputFile.write(line)
    def __includeFooter__(self, outputFile):
        for line in self._footer:
            outputFile.write(line)
    def __includeSourceHeader__(self, outputFile):
        for line in self._source_header:
            outputFile.write(line)

    def queryICRInfo(self, package, type, val):
      icrList = []
      #  Find entries that have a certain top-level parameter
      #
      #  example call queryICRInfo("ROUTINE","ROUTINE","SDAM1")
      #  Would return all "ROUTINE" types where the "ROUTINE" field equals 'SDAM1'
      #
      if package in self._crossRef._icrJson.keys():
        for keyVal in self._crossRef._icrJson[package].keys():
          if type == "*":
              for keyEntry in self._crossRef._icrJson[package][keyVal].keys():
                for entry in self._crossRef._icrJson[package][keyVal][keyEntry]:
                  icrList.append(entry)
          else:
            if val in self._crossRef._icrJson[package][keyVal].keys():
              for entry in self._crossRef._icrJson[package][keyVal][val]:
                icrList.append(entry)
      return icrList

    def generateWebPage(self):
        self.generateIndexHtmlPage()
        self.generatePackageNamespaceGlobalMappingPage()
        if self._dot:
            self.generatePackageDependenciesGraph()
            self.generatePackageDependentsGraph()
        self.generateGlobalNameIndexPage()
        self.generateIndividualGlobalPage()
        self.generateGlobalFileNoIndexPage()
        self.generateFileManSubFileIndexPage()
        self.generatePackageIndexPage()
        self.generatePackagePackageInteractionDetail()
        self.generateIndividualPackagePage()
        self.generateRoutineIndexPage()
        if self._dot:
            self.generateRoutineCallGraph()
            self.generateRoutineCallerGraph()
        self.generateAllSourceCodePage(not self._includeSource)
        self.generateAllIndividualRoutinePage()
        self.copyFilesToOutputDir()
#===============================================================================
# Method to generate the index.html page
#===============================================================================
    def generateIndexHtmlPage(self):
        outputFile = open(os.path.join(self._outDir, "index.html"), 'wb')
        outputFile.write(COMMON_HEADER_PART)
        outputFile.write("<title>OSEHRA VistA Code Documentation</title>")
        outputFile.write(GOOGLE_ANALYTICS_JS_CODE)
        outputFile.write(HEADER_END)
        outputFile.write(DEFAULT_BODY_PART)
        outputFile.write(INDEX_HTML_PAGE_OSEHRA_IMAGE_PART)
        outputFile.write(INDEX_HTML_PAGE_HEADER)
        outputFile.write(TOP_INDEX_BAR_PART)
        outputFile.write(INDEX_HTML_PAGE_INTRODUCTION_PART)
        self.__generateGitRepositoryKey__(outputFile)
        self.__includeFooter__(outputFile)

    def __generateGitRepositoryKey__(self, outputFile):
        sha1Key = self.__getGitRepositLatestSha1Key__()
        outputFile.write("""<h6><a class ="anchor" id="howto"></a>Note:Repository SHA1 key:%s</h6>\n""" % sha1Key)

    def __getGitRepositLatestSha1Key__(self):
        gitCommand = "\"" + self._git + "\"" + " rev-parse --verify HEAD"
        os.chdir(self._repDir)
        if os.path.exists(os.path.join(self._repDir,'.git')):
          logger.debug("git Command is %s" % gitCommand)
          result = subprocess.check_output(gitCommand, shell=True)
          return result.strip()
        return ""
    def __generateHtmlPageHeader__(self, isSource = False):
        if isSource:
            output = self._source_header
        else:
            output = self._header
        output.append(COMMON_HEADER_PART)
        if isSource:
            output.append(CODE_PRETTY_JS_CODE)
        output.append(GOOGLE_ANALYTICS_JS_CODE)
        output.append(HEADER_END)
        if isSource:
            output.append(SOURCE_CODE_BODY_PART)
        else:
            output.append(DEFAULT_BODY_PART)
        output.append(TOP_INDEX_BAR_PART)

#===============================================================================
# Method to generate Package Namespace Mapping page
#===============================================================================
    def generatePackageNamespaceGlobalMappingPage(self):
        outputFile = open(os.path.join(self._outDir, "Packages_Namespace_Mapping.html"), 'wb')
        self.__includeHeader__(outputFile)
        outputFile.write("<title>Package Namespace Mapping</title>")
        outputFile.write("<div><h1>%s</h1></div>\n" % "Package Namespace Mapping")
        writeTableHeader(["PackageName",
                          "Namespaces",
                          "Additional Globals"],
                         outputFile)
        allPackage = sorted(self._allPackages.keys())
        for packageName in allPackage:
            package = self._allPackages[packageName]
            namespaces = package.getNamespaces()
            globalNamespaces = package.getGlobalNamespace()
            totalCol = max(len(namespaces),
                           len(globalNamespaces))
            for index in range(totalCol):
                outputFile.write("<tr>")
                # write the package name
                if index == 0:
                    outputFile.write("<td class=\"IndexKey\">%s</td>" % getPackageHyperLinkByName(packageName))
                else:
                    outputFile.write("<td class=\"IndexKey\"></td>")
                # write the namespace
                if index <= len(namespaces) - 1:
                    outputFile.write("<td class=\"IndexValue\">%s</td>" % namespaces[index])
                else:
                    outputFile.write("<td class=\"IndexValue\"></td>")
                # write the additional globals
                if index <= len(globalNamespaces) - 1:
                    outputFile.write("<td class=\"IndexValue\">%s</td>" % globalNamespaces[index])
                else:
                    outputFile.write("<td class=\"IndexValue\"></td>")
                outputFile.write("</tr>\n")
        outputFile.write("</table>\n")
        outputFile.write("<BR>\n")
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateGlobalNameIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "globals.html"), 'w')
        self.__includeHeader__(outputFile)
        outputFile.write("<title>Global Index List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Global Index List</h1>\n</div>\n</div>")
        generateIndexBar(outputFile, string.uppercase, isIndex = True,printButton=True)
        outputFile.write("<div class=\"contents\">\n")
        sortedGlobals = [] # a list of list
        for globalVar in self._allGlobals.itervalues():
            sortedName = globalVar.getName()[1:] # get rid of ^
            if sortedName.startswith('%'): # get rid of %
                sortedName = sortedName[1:]
            sortedGlobals.append([sortedName, globalVar.getName()])
        sortedGlobals = sorted(sortedGlobals,
                             key=lambda item: item[0])
        for letter in string.uppercase:
            bisect.insort_left(sortedGlobals, [letter, letter])
        totalGlobals = len(sortedGlobals)
        totalCol = 4
        numPerCol = totalGlobals / totalCol + 1
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        for i in range(numPerCol):
            itemsPerRow = [];
            for j in range(totalCol):
                if (i + numPerCol * j) < totalGlobals:
                    itemsPerRow.append(sortedGlobals[i + numPerCol * j][1]);
            generateIndexedGlobalTableRow(outputFile, itemsPerRow)
        outputFile.write("</table>\n</div>\n")
        generateIndexBar(outputFile, string.uppercase, isIndex = True)
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateGlobalFileNoIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "filemanfiles.html"), 'wb')
        allFileManFilesList = []
        for item in self._allGlobals.itervalues():
            if item.isFileManFile():
                allFileManFilesList.append(item)
        self.__includeHeader__(outputFile)
        outputFile.write("<title>FileMan Files List</title>")
        outputFile.write("<div><h1>%s</h1></div>\n" % "All FileMan Files List Total: %d" % len(allFileManFilesList))
        writeTableHeader(["FileMan Name",
                          "FileMan FileNo",
                          "Global Name"],
                         outputFile)
        sortedFileManList = sorted(allFileManFilesList, key=lambda item: float(item.getFileNo()))
        for fileManFile in sortedFileManList:
            outputFile.write("<tr>")
            outputFile.write("<td class=\"IndexKey\">%s</td>" % getFileManFileHypeLinkWithFileManName(fileManFile))
            outputFile.write("<td class=\"IndexKey\">%s</td>" % getFileManFileHypeLinkWithFileNo(fileManFile))
            outputFile.write("<td class=\"IndexKey\">%s</td>" % getGlobalHypeLinkByName(fileManFile.getName()))
            outputFile.write("</tr>\n")
        outputFile.write("</table>\n")
        outputFile.write("<BR>\n")
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateFileManSubFileIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "filemansubfiles.html"), 'wb')
        allSubFiles = self._crossRef.getAllFileManSubFiles()
        self.__includeHeader__(outputFile)
        outputFile.write("<title id=\"pageTitle\">Fileman Sub-Files</title>")
        outputFile.write("<div><h1>%s</h1></div>\n" % "All FileMan Sub-Files List Total: %d" % len(allSubFiles))
        writeTableHeader(["Sub-File Name",
                          "Sub-File FileNo",
                          "Package Name"],
                         outputFile)
        sortedSubFileList = sorted(allSubFiles.values(), key=lambda item: float(item.getFileNo()))
        for subFile in sortedSubFileList:
            outputFile.write("<tr>")
            outputFile.write("<td class=\"IndexKey\">%s</td>" %
                getFileManSubFileHypeLinkWithName(subFile))
            outputFile.write("<td class=\"IndexKey\">%s</td>" %
                getFileManSubFileHypeLinkByName(subFile))
            package = subFile.getRootFile().getPackage()
            outputFile.write("<td class=\"IndexKey\">%s</td>" %
                getPackageHyperLinkByName(package.getName()))
            outputFile.write("</tr>\n")
        outputFile.write("</table>\n")
        outputFile.write("<BR>\n")
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
#
#===============================================================================
    def generateIndividualGlobalPage(self):
        logger.info("Start generating individual globals......")

        for package in self._allPackages.itervalues():
            for (globalName, globalVar) in package.getAllGlobals().iteritems():
                isFileManFile = globalVar.isFileManFile()

                if isFileManFile:
                    indexList = ["Info", "Desc",
                                 "Directly Accessed By Routines",
                                 "Accessed By FileMan Db Calls",
                                 "Pointed To By FileMan Files",
                                 "Pointer To FileMan Files", "Fields"]
                else:
                    indexList = ["Directly Accessed By Routines"]

                outputFile = open(os.path.join(self._outDir,
                                               getGlobalHtmlFileNameByName(globalName)), 'wb')
                self.__includeHeader__(outputFile)

                icrList = self.queryICRInfo(package.getName().upper(),"GLOBAL", globalName[1:])
                if icrList:
                  indexList.append("ICR Entries")

                outputFile.write("<script>var titleList = " + str(indexList) + "</script>\n")
                outputFile.write("")
                # generated the qindex bar
                generateIndexBar(outputFile, indexList, printButton=True)
                title = "Global: %s" % globalName
                writePDFCustomization(outputFile, str(indexList))
                self.writeTitleBlock(title, title, package, outputFile)
                outputFile.write(getAccordionHTML())
                if isFileManFile:
                    # Information
                    writeSectionHeader("Information", "Info", outputFile)
                    infoHeader = ["FileMan FileNo", "FileMan Filename", "Package"]
                    itemList = [[globalVar.getFileNo(),
                              globalVar.getFileManName(),
                              getPackageHyperLinkByName(package.getName())]]
                    self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid="information")
                    writeSectionHeader("Description", "Desc", outputFile)
                    # TODO: Write as a normal paragraph or series of paragraphs (i.e. not a list)
                    writeListData(globalVar.getDescription(), outputFile, classid="description")
                    writeSectionEnd(outputFile)

                # Directly Accessed By Routines
                writeSectionHeader("Directly Accessed By Routines, Total: %d" %
                                    globalVar.getTotalNumberOfReferencedRoutines(),
                                    "Directly Accessed By Routines", outputFile)
                self.generateGlobalRoutineDependentsSection(
                                  globalVar.getAllReferencedRoutines(), outputFile,classid="directCall")
                writeSectionEnd(outputFile)

                # Accessed By FileMan Db Calls
                fileManDbCallRtns = globalVar.getFileManDbCallRoutines()
                totalNumDbCallRtns = 0
                if fileManDbCallRtns:
                    DbCallRtnsNos = [len(x) for x in
                        fileManDbCallRtns.itervalues()]
                    totalNumDbCallRtns = sum(DbCallRtnsNos)
                if isFileManFile:
                    writeSectionHeader("Accessed By FileMan Db Calls, Total: %d" %
                                       totalNumDbCallRtns,
                                       "Accessed By FileMan Db Calls", outputFile)
                if fileManDbCallRtns:
                    self.generateGlobalRoutineDependentsSection(fileManDbCallRtns,
                        outputFile,classid="gblRtnDep")
                else:
                    outputFile.write("<div></div>")
                writeSectionEnd(outputFile)
                if isFileManFile:
                    # Pointed to By FileMan Files
                    writeSectionHeader("Pointed To By FileMan Files, Total: %d" % globalVar.getTotalNumberOfReferredGlobals(), "Pointed To By FileMan Files", outputFile)
                    self.generateGlobalPointedToSection(globalVar, outputFile, True,classid="gblPointedTo")
                    writeSectionEnd(outputFile)

                    # Pointer To FileMan Files
                    writeSectionHeader("Pointer To FileMan Files, Total: %d" % globalVar.getTotalNumberOfReferencedGlobals(), "Pointer To FileMan Files", outputFile)
                    self.generateGlobalPointedToSection(globalVar, outputFile, False,classid="gblPointerTo")
                    writeSectionEnd(outputFile)

                    # Fields
                    totalNoFields = 0
                    allFields = globalVar.getAllFileManFields()
                    if allFields: totalNoFields = len(allFields)
                    writeSectionHeader("Fields, Total: %d" % totalNoFields, "Fields", outputFile)
                    self.__generateFileManFileDetails__(globalVar, outputFile)
                    writeSectionEnd(outputFile)

                if icrList:
                   writeSectionHeader("ICR Entries","ICR Entries",outputFile)
                   self.generateGlobalICRSection(icrList,outputFile)
                   writeSectionEnd(outputFile)
                generateIndexBar(outputFile, indexList)
                self.__includeFooter__(outputFile)
                outputFile.close()

                # generate individual sub files
                if isFileManFile:
                    subFiles = globalVar.getAllSubFiles()
                    if subFiles:
                        for subFile in subFiles.itervalues():
                            self.__generateFileManSubFilePage__(subFile)
        logger.info("End of generating individual globals......")

#===============================================================================
#
#===============================================================================
    def __generateFileManSubFilePage__(self, subFile):
        logger.debug("Start generating individual subfile [%s]" % subFile.getFileNo())
        indexList = ["Info", "Details"]
        outputFile = open(os.path.join(self._outDir,
                                       getFileManSubFileHtmlFileName(subFile)), 'wb')
        # write the same _header file
        self.__includeHeader__(outputFile)
        # generated the qindex bar
        generateIndexBar(outputFile, indexList, printButton=True)
        writePDFCustomization(outputFile, str(indexList))
        # get the root file package
        fileIter = subFile
        topDownList=[fileIter]
        while not fileIter.isRootFile():
            fileIter = fileIter.getParentFile()
            topDownList.append(fileIter)
        topDownList.reverse()
        package = fileIter.getPackage()
        title = "Sub-Field: %s" % subFile.getFileNo()
        # generate # link list
        linkHtmlTxt = ""
        index = 0
        for item in topDownList:
            if index == 0:
                linkHtmlTxt += getFileManFileHypeLink(item)
            else:
                linkHtmlTxt += getFileManSubFileHypeLinkByName(item.getFileNo())
            if index < len(topDownList) - 1:
                linkHtmlTxt += "-->"
            index += 1
        self.writeTitleBlock(title, title, package, outputFile, linkHtmlTxt)
        outputFile.write(getAccordionHTML())

        # Information
        writeSectionHeader("Information", "Info", outputFile)
        infoHeader = ["Parent File", "Name", "Number", "Package"]
        parentFile = subFile.getParentFile()
        parentFileLink = ""
        if parentFile.isRootFile():
            parentFileLink = getFileManFileHypeLink(parentFile)
        else:
            parentFileLink =  getFileManSubFileHypeLinkByName(parentFile.getFileNo())
        itemList = [[parentFileLink, subFile.getFileManName(), subFile.getFileNo(),
                  getPackageHyperLinkByName(package.getName())]]
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid="information")
        writeSectionEnd(outputFile)

        # Details
        writeSectionHeader("Details", "Details", outputFile)
        self.__generateFileManFileDetails__(subFile, outputFile)
        writeSectionEnd(outputFile)

        # generated the index bar at the bottom
        generateIndexBar(outputFile, indexList)
        self.__includeFooter__(outputFile)
        outputFile.close()
        logger.debug("End of generating individual subFile [%s]" % subFile.getFileNo())

#===============================================================================
#
#===============================================================================
    def __generateFileManFileDetails__(self, fileManFile, outputFile):
        assert isinstance(fileManFile, FileManFile)
        # sort the file man field by file #
        allFields = fileManFile.getAllFileManFields()
        if not allFields or len(allFields) == 0: return
        # sort the fields # by the float value
        sortedFields = sorted(allFields.keys(), key=lambda item: float(item))
        outputFieldsList = []
        fieldHeaderList = ["Field #", "Name", "Loc", "Type", "Details"]
        for key in sortedFields:
            value = allFields[key]
            location = value.getLocation()
            if not location: location = ""
            fieldNo = value.getFieldNo()
            fieldNoTxt = "<a name=\"%s\">%s</a>" % (fieldNo, fieldNo)
            type = value.getTypeName()
            if type is None: type = ""
            fieldRow = [fieldNoTxt, value.getName(), location, type]
            fieldDetails = ""
            if value.__getattribute__("_isRequired"):
                text = "************************REQUIRED FIELD************************"
                fieldDetails += "<div style='text-align: center'><b>%s</b></div>" % text
            if value.isSetType():
                # nice display of set members
                setIter = value.getSetMembers()
                fieldDetails += generateHtmlListData(setIter)
            elif value.isFilePointerType():
                globalVar = value.getPointedToFile()
                if globalVar:
                    fieldDetails += (getFileManFileHypeLink(globalVar))
            elif value.isVariablePointerType():
                fileManFiles = value.getPointedToFiles()
                for pointedToFile in fileManFiles:
                    fieldDetails += getFileManFileHypeLink(pointedToFile) + "&nbsp;&nbsp;"
            elif value.isSubFilePointerType():
                filePointer = value.getPointedToSubFile()
                if filePointer:
                    fieldDetails += getFileManSubFileHypeLinkByName(filePointer.getFileNo())
            # logic to append field extra details here
            fieldDetails += self.__generateFileManFieldPropsDetailsList__(value)
            fieldRow.append(fieldDetails)
            outputFieldsList.append(fieldRow)
        self.writeGenericTablizedHtmlData(fieldHeaderList, outputFieldsList, outputFile, classid="fmFields")


#===============================================================================
#
#===============================================================================
    def __generateFileManFieldPropsDetailsList__(self, fileManField):
        if not fileManField:
            return ""
        propList = fileManField.getPropList()
        if not propList or len(propList) == 0:
            return ""
        output = "<p><ul>"
        for (name, values) in propList:
            output += "<li><dl><dt>%s&nbsp;&nbsp;<code>%s</code></dt>" % (name, values[0])
            for value in values[1:]:
                output += "<dd><pre>%s</pre></dd>" % value
            output += "</dl></li>"
        output += "</ul>"
        return output
#===============================================================================
#
#===============================================================================
    def generateGlobalPointedToSection(self, globalVar,
                                       outputFile, isPointedBy=True, classid=""):
        if isPointedBy:
          pointedByGlobals = globalVar.getAllReferencedFileManFiles()
        else:
          pointedByGlobals = globalVar.getAllReferredFileManFiles()
        sortedPackage = sorted(sorted(pointedByGlobals.keys()),
                           key=lambda item: len(pointedByGlobals[item]),
                           reverse=True)
        infoHeader = ["Package", "Total", "FileMan Files"]
        itemList = []
        for package in sortedPackage:
            globalDict = pointedByGlobals[package]
            itemRow = []
            itemRow.append(getPackageHyperLinkByName(package.getName()))
            itemRow.append(len(globalDict))
            globalData = ""
            index = 0
            for Global in sorted(globalDict.keys()):
                globalData += ("<a class=\"e1\" href=\"%s\">%s</a>" %
                             (getGlobalHtmlFileNameByName(Global.getName()),
                              getGlobalDisplayName(Global)))
                detailedList = globalDict[Global]
                if not detailedList or len(detailedList) ==0:
                    continue
                fieldLinkGlobal = Global
                if not isPointedBy:
                    fieldLinkGlobal = globalVar
                globalData +="["
                index = 0
                for item in detailedList:
                    if not item[1]:
                        itemHtmlText = ("<a class=\"e2 %s\" href=\"%s#%s\">%s</a>" %
                                       (classid,
                                        getGlobalHtmlFileNameByName(fieldLinkGlobal.getName()),
                                        item[0], item[0]))
                    else:
                        itemHtmlText = ("<a class=\"e2\" href=\"%s#%s\">#%s(%s)</a>" %
                                       (getFileManSubFileHtmlFileNameByName(item[1]),
                                        item[0], item[1], item[0]))
                    globalData += itemHtmlText
                    if index < len(detailedList) - 1:
                        globalData += ",&nbsp"
                    index += 1
                globalData +="]"
                if (index + 1) % 4 == 0:
                    globalData += "<BR>"
                else:
                    globalData += "&nbsp;&nbsp;&nbsp;&nbsp;"
                index += 1
            itemRow.append(globalData)
            itemList.append(itemRow)
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid=classid)

#===============================================================================
#
#===============================================================================
    def generateGlobalRoutineDependentsSection(self, depRoutines,
                                               outputFile,classid=""):
        sortedPackage = sorted(sorted(depRoutines.keys()),
                               key=lambda item: len(depRoutines[item]),
                               reverse=True)
        infoHeader = ["Package", "Total", "Routines"]
        itemList = []
        for package in sortedPackage:
            routineSet = depRoutines[package]
            itemRow = []
            itemRow.append(getPackageHyperLinkByName(package.getName()))
            itemRow.append(len(routineSet))
            routineData = ""
            index = 0
            for routine in sorted(routineSet):
                routineData += ("<a class=\"e1\" href=\"%s\">%s" %
                             (getRoutineHtmlFileName(routine.getName()),
                              routine.getName()))
                if (index + 1) % 8 == 0:
                    routineData += "</a><BR>"
                else:
                    routineData += "</a>&nbsp;&nbsp;&nbsp;&nbsp;"
                index += 1
            itemRow.append(routineData)
            itemList.append(itemRow)
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid=classid)

#===============================================================================
# method to generate the interactive detail list page between any two packages
#===============================================================================
    def generatePackagePackageInteractionDetail(self):
        packDepDict = dict()
        for package in self._allPackages.itervalues():
            for depDict in (package.getPackageRoutineDependencies(),
                            package.getPackageGlobalDependencies(),
                            package.getPackageFileManFileDependencies(),
                            package.getPackageFileManDbCallDependencies()):
                self._updatePackageDepDict(package, depDict, packDepDict)
        for (key, value) in packDepDict.iteritems():
            self.generatePackageInteractionDetailPage(key, value[0], value[1])

    def generateGlobalICRSection(self, icrInfo, outfile):
      headerList = ["ICR LINK", "Subscribing Package(s)",
                    "Fields Referenced", "Description"]
      icrTable = []
      for entry in icrInfo:
        row = []
        icrLink = "<a href='%s'>ICR #%s</a>" % (getICRHtmlFileName(entry), entry["NUMBER"])
        subscribingPackage = ""
        if "SUBSCRIBING PACKAGE" in entry:
          for value in entry["SUBSCRIBING PACKAGE"]:
            pkgName = value["SUBSCRIBING PACKAGE"][0] if type(value["SUBSCRIBING PACKAGE"]) is list else value["SUBSCRIBING PACKAGE"]
            subscribingPackage += "<li>" + getPackageHyperLinkByName(pkgName) + "</li>"
        fieldsReferenced = ""
        if ("GLOBAL REFERENCE" in entry):
          for reference in entry["GLOBAL REFERENCE"]:
            if "FIELD NUMBER" in reference:
              for value in reference["FIELD NUMBER"]:
                name = value["FIELD NAME"] if "FIELD NAME" in value else ""
                num = value["FIELD NUMBER"] if "FIELD NUMBER" in value else ""
                accessString = value["ACCESS"] if "ACCESS" in value else ""
                fieldsReferenced += "%s (<a href='#%s'>%s</a>). <br/> <b>Access:</b> %s" % (name, num, num, accessString)
                fieldsReferenced += "<br/><br/>"
        description = ""
        if ("GLOBAL REFERENCE" in entry):
          for reference in entry["GLOBAL REFERENCE"]:
            if "GLOBAL DESCRIPTION" in reference:
              for value in reference["GLOBAL DESCRIPTION"]:
                description += value
        row.append(icrLink)
        row.append(subscribingPackage)
        row.append(fieldsReferenced)
        row.append(description)
        icrTable.append(row)
      self.writeGenericTablizedHtmlData(headerList, icrTable, outfile,classid="icrVals")

    def _updatePackageDepDict(self, package, depDict, packDepDict):
        for depPack in depDict.iterkeys():
            fileName = getPackageDependencyHtmlFile(package.getName(),
                                                    depPack.getName())
            if fileName not in packDepDict:
                packDepDict[fileName] = (package, depPack)

#===============================================================================
# method to generate the detail of package
#===============================================================================
    def generatePackageRoutineDependencyDetailPage(self, package, depPackage, outputFile,titleIndex):
        packageHyperLink = getPackageHyperLinkByName(package.getName())
        depPackageHyperLink = getPackageHyperLinkByName(depPackage.getName())
        # generate section header
        writeSectionHeader("%s-->%s :" % (packageHyperLink, depPackageHyperLink),
                           package.getName(), outputFile)
        routineDepDict = package.getPackageRoutineDependencies()
        globalDepDict = package.getPackageGlobalDependencies()
        fileManDepDict = package.getPackageFileManFileDependencies()
        dbCallDepDict = package.getPackageFileManDbCallDependencies()
        callerRoutines = set()
        calledRoutines = set()
        referredRoutines = set()
        referredGlobals = set()
        referredFileManFiles = set()
        referencedFileManFiles = set()
        dbCallRoutines = set()
        dbCallFileManFiles = set()
        titleList = ['Summary'+titleIndex]
        if routineDepDict and depPackage in routineDepDict:
            callerRoutines = routineDepDict[depPackage][0]
            calledRoutines = routineDepDict[depPackage][1]
            titleList = titleList + ["Caller Routines"+titleIndex, "Called Routines"+titleIndex]
        if globalDepDict and depPackage in globalDepDict:
            referredRoutines = globalDepDict[depPackage][0]
            referredGlobals = globalDepDict[depPackage][1]
            titleList = titleList + ["Referred Routines"+titleIndex, "Referenced Globals"+titleIndex]
        if fileManDepDict and depPackage in fileManDepDict:
            referredFileManFiles = fileManDepDict[depPackage][0]
            referencedFileManFiles = fileManDepDict[depPackage][1]
            titleList = titleList + ["Referred FileMan Files"+titleIndex, "Referenced FileMan Files"+titleIndex]
        if dbCallDepDict and depPackage in dbCallDepDict:
            dbCallRoutines = dbCallDepDict[depPackage][0]
            dbCallFileManFiles = dbCallDepDict[depPackage][1]
            titleList = titleList + ["FileMan Db Call Routines"+titleIndex, "FileMan Db Call Accessed FileMan Files"+titleIndex]
        writePDFCustomization(outputFile,str(titleList))
        totalCalledHtml = "<span class=\"comment\">%d</span>" % len(callerRoutines)
        totalCallerHtml = "<span class=\"comment\">%d</span>" % len(calledRoutines)
        totalReferredRoutineHtml = "<span class=\"comment\">%d</span>" % len(referredRoutines)
        totalReferredGlobalHtml = "<span class=\"comment\">%d</span>" % len(referredGlobals)
        totalReferredFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(referredFileManFiles)
        totalReferencedFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(referencedFileManFiles)
        totalDbCallRoutinesHtml = "<span class=\"comment\">%d</span>" % len(dbCallRoutines)
        totalDbCallFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(dbCallFileManFiles)
        summaryHeader = "Summary:<BR> Total %s routine(s) in %s called total %s routine(s) in %s" % (totalCalledHtml,
                                                                                               packageHyperLink,
                                                                                               totalCallerHtml,
                                                                                               depPackageHyperLink)
        summaryHeader += "<BR> Total %s routine(s) in %s accessed total %s global(s) in %s" % (totalReferredRoutineHtml,
                                                                                             packageHyperLink,
                                                                                             totalReferredGlobalHtml,
                                                                                             depPackageHyperLink)
        summaryHeader += "<BR> Total %s fileman file(s) in %s pointed to total %s fileman file(s) in %s" % (totalReferredFileManFilesHtml,
                                                                                             packageHyperLink,
                                                                                             totalReferencedFileManFilesHtml,
                                                                                             depPackageHyperLink)
        summaryHeader += "<BR> Total %s routine(s) in %s accessed via fileman db call to total %s fileman file(s) in %s" % (totalDbCallRoutinesHtml,
                                                                                             packageHyperLink,
                                                                                             totalDbCallFileManFilesHtml,
                                                                                             depPackageHyperLink)
        writeSubSectionHeader(summaryHeader, outputFile,classid="summary")
        # print out the routine details
        if len(callerRoutines) > 0:
            writeSubSectionHeader("Caller Routines List in %s : %s" % (packageHyperLink,
                                                                       totalCalledHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(callerRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="callerRoutines")
        if len(calledRoutines) > 0:
            writeSubSectionHeader("Called Routines List in %s : %s" % (depPackageHyperLink,
                                                                       totalCallerHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(calledRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="calledRoutines")
        if len(referredRoutines) > 0:
            writeSubSectionHeader("Referred Routines List in %s : %s" % (packageHyperLink,
                                                                       totalReferredRoutineHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="referredRoutines")
        if len(referredGlobals) > 0:
            writeSubSectionHeader("Referenced Globals List in %s : %s" % (depPackageHyperLink,
                                                                       totalReferredGlobalHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredGlobals), outputFile,
                                          getGlobalHtmlFileName,classid="referredGlobals")
        if len(referredFileManFiles) > 0:
            writeSubSectionHeader("Referred FileMan Files List in %s : %s" % (packageHyperLink,
                                                                       totalReferredFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredFileManFiles), outputFile,
                                          getGlobalHtmlFileName, getGlobalDisplayName,classid="referredFileManFiles")
        if len(referencedFileManFiles) > 0:
            writeSubSectionHeader("Referenced FileMan Files List in %s : %s" % (depPackageHyperLink,
                                                                       totalReferencedFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referencedFileManFiles), outputFile,
                                          getGlobalHtmlFileName, getGlobalDisplayName,classid="referencedFileManFiles")
        if len(dbCallRoutines) > 0:
            writeSubSectionHeader("FileMan Db Call Routines List in %s : %s" % (packageHyperLink,
                                                                       totalDbCallRoutinesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(dbCallRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName,classid="dbCallRoutines")
        if len(dbCallFileManFiles) > 0:
            writeSubSectionHeader("FileMan Db Call Accessed FileMan Files List in %s : %s" % (depPackageHyperLink,
                                                                       totalDbCallFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(dbCallFileManFiles), outputFile,
                                          getGlobalHtmlFileName,classid="dbCallFileManFiles")
        writeSectionEnd(outputFile)
        outputFile.write("<br/>\n")

#===============================================================================
# method to generate the individual package/package interaction detail page
#===============================================================================
    def generatePackageInteractionDetailPage(self, fileName, package, depPackage):
        outputFile = open(os.path.join(self._outDir, fileName), 'w')
        self.__includeHeader__(outputFile)
        packageHyperLink = getPackageHyperLinkByName(package.getName())
        depPackageHyperLink = getPackageHyperLinkByName(depPackage.getName())
        #generate the index bar
        inputList = ["%s-->%s" % (package.getName(), depPackage.getName()),
                   "%s-->%s" % (depPackage.getName(), package.getName())]
        archList = [package.getName(), depPackage.getName()]
        generateIndexBar(outputFile, inputList, archList, isIndex = False, printButton=True)
        outputFile.write("<title id=\"pageTitle\">" + package.getName() + " : " + depPackage.getName() + "</title>")
        outputFile.write("<div><h1>%s and %s Interaction Details</h1></div>\n" %
                         (packageHyperLink, depPackageHyperLink))
        self.generatePackageRoutineDependencyDetailPage(package, depPackage, outputFile,"_1")
        self.generatePackageRoutineDependencyDetailPage(depPackage, package, outputFile,"_2")
        generateIndexBar(outputFile, inputList, archList, isIndex = False)
        self.__includeFooter__(outputFile)
        outputFile.close()

    def __parseReadCmd__(self,matchArray, routine,lineNo):
      for matchObj in matchArray:
        setup = matchObj[0].split(",")
        interaction = {}
        interaction["type"]= "READ"
        interaction["line"]= str(lineNo)
        interaction['timeout'] = matchObj[1]
        # Read directly into a variable
        if len(setup) == 1:
          interaction['variable'] = setup[0]
        # Read into a variable with some prompt
        elif len(setup) == 2:
          (interaction['string'], interaction['variable']) = tuple(setup)
        # Read into a variable with a prompt and some extra parameters/formatting
        elif len(setup) == 3:
          (interaction['formatting'], interaction['string'], interaction['variable']) = tuple(setup)
        routine.addInteractionEntry(interaction)
    def __parseWriteCmd__(self,line, routine,lineNo):
      # splits the line into a space separated list which ignores spaces found within quotes
      lineList =  re.split(''' (?=(?:[^'"]|'[^']*'|"[^"]*")*$)''', line)
      lastIndex = 0
      for i in lineList:
        # Captures the conditional value of the write, while trying to remove false matches like "WRITE" as an entry point
        match = re.search("^W(?!\w)($|(?P<conditional>\:.+)?)",i)
        if match:
          interaction = {}
          # Make sure we aren't going to look past the end
          if lineList[lastIndex:].index(i) + 1+lastIndex  >= len(lineList):
            continue
          interaction["string"] = lineList[lineList[lastIndex:].index(i) + 1+lastIndex]
          lastIndex=lineList.index(i) + 1
          interaction["type"]= "WRITE"
          interaction["line"]= str(lineNo)
          if match.group('conditional'):
            interaction["conditional"]= match.group('conditional')[1:]
          routine.addInteractionEntry(interaction)

#===============================================================================
# Method to parse the source code and generate source code page or just extract comments
#===============================================================================
    def __generateSourceCodePageByName__(self, sourceCodeName, routine, justComment):
        ENTRY_POINT = re.compile("^[A-Z0-9]+[(]?")
        COMMENT  = re.compile("^ ; ")
        READ_CMD = re.compile(" R (?P<params>.+?):(?! )(?P<timeout>.+?) ")
        WRITE_CMD = re.compile(" W (?P<string>.+?)\s")
        if not routine:
            logger.error("Routine can not be None")
            return
        package = routine.getPackage()
        if not package:
            logger.error("Routine %s does not belong to a package" % routine)
            return
        packageName = package.getName()
        routineName = routine.getName()
        sourcePath = getRoutineSourceCodeFileByName(sourceCodeName,
                                                    packageName,
                                                    self._repDir)
        if not os.path.exists(sourcePath):
            logger.error("Souce file:[%s] does not exit\n" % sourcePath)
            return
        sourceFile = open(sourcePath, 'r')
        if not justComment:
            outputFile = open(os.path.join(self._outDir,
                                         getRoutineSourceHtmlFileNameUnquoted(sourceCodeName)), 'wb')
            self.__includeSourceHeader__(outputFile)
            outputFile.write("<title id=\"pageTitle\">Routine: "+sourceCodeName+"</title>")
            outputFile.write("<div><h1>%s.m</h1></div>\n" % sourceCodeName)
            outputFile.write("<div id='pageCommands' style='position:fixed; top:55; background: white;'>")
            outputFile.write("  <a href=\"%s\">Go to the documentation of this file.</a>" %
                             getRoutineHtmlFileName(routineName))
            if routine._structuredCode:
              outputFile.write(SWAP_VIEW_HTML)
            outputFile.write('</div>')
            outputFile.write("<xmp id=\"terseDisplay\" class=\"prettyprint lang-mumps linenums:1\">")
        # Inititalize the new variables
        lineNo = 0
        entry = ""
        entryOffset = 0
        currentEntryPoint = routineName
        comment=[]
        icrJson=[]
        inComment=False
        for line in sourceFile:
            if lineNo <= 1:
                routine.addComment(line)
            if ENTRY_POINT.search(line) and lineNo > 1:
              if entry:
                routine.addEntryPoint(entry, comment, icrJson)
                comment=[]
              inComment = True
              foundLine = line.replace("\t"," ").split(" ",1)
              if len(foundLine) > 1:
                entry = foundLine[0]
                commentString = foundLine[1]
              else:
                commentString = "@"
                entry= line
              currentEntryPoint= entry
              entryOffset= 0
              comment.append(commentString)
              if not commentString[0]==";":
                comment=[]
                # if No comment on the first line, assume no other comments will follow it
                inComment= False
              icrJson = self.queryICRInfo(packageName.upper(),"ROUTINE", routineName)
            # Check for more comments that are 1 space in from the beginning of the line
            elif COMMENT.search(line) and inComment:
              comment.append(line)
            else:
              # If here, assume we have reached the code part of the entry point and stop checking for comments
              inComment=False
            if READ_CMD.search(line):
                self.__parseReadCmd__(READ_CMD.findall(line), routine, currentEntryPoint+"+"+str(entryOffset))
            if WRITE_CMD.search(line):
                self.__parseWriteCmd__(line, routine, currentEntryPoint+"+"+str(entryOffset))
            if justComment and lineNo > 1:
               continue
            if not justComment:
                outputFile.write(line)
            lineNo += 1
            entryOffset += 1
        sourceFile.close()
        routine.addEntryPoint(entry, comment, icrJson)
        if not justComment:
            outputFile.write("</xmp>\n")
            if routine._structuredCode:
              outputFile.write("<xmp id=\"expandedDisplay\" class=\"prettyprint lang-mumps linenums:1\" style='display:none;'>")
              for line in routine._structuredCode:
                if len(line):
                  outputFile.write("%s \n" % line)
              outputFile.write("</xmp>\n")
            self.__includeFooter__(outputFile)
            outputFile.close()

#===============================================================================
# Method to generate individual source code page for Platform Dependent Routines
#===============================================================================
    def __generatePlatformDependentRoutineSourcePage__(self, genericRoutine, justComment):
        assert genericRoutine
        assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
        assert self._crossRef.isPlatformGenericRoutineByName(genericRoutine.getName())
        allRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in allRoutines.itervalues():
            routine = routineInfo[0]
            sourceCodeName = routine.getOriginalName()
            self.__generateSourceCodePageByName__(sourceCodeName, routine, justComment)

#===============================================================================
# Method to generate individual source code page
# sourceDir should be VistA-M git repository
#===============================================================================
    def generateAllSourceCodePage(self, justComment=True):
        for packageName in self._allPackages.iterkeys():
            for (routineName, routine) in self._allPackages[packageName].getAllRoutines().iteritems():
                if self._crossRef.isPlatformGenericRoutineByName(routineName):
                    self.__generatePlatformDependentRoutineSourcePage__(routine, justComment)
                    continue
                # check for platform dependent routine
                if not self._crossRef.routineHasSourceCodeByName(routineName):
                    logger.debug("Routine:%s does not have source code" % routineName)
                    continue
                sourceCodeName = routine.getOriginalName()
                self.__generateSourceCodePageByName__(sourceCodeName, routine, justComment)
#===============================================================================
# utility method to show routine name
#===============================================================================
    def getRoutineDisplayNameByName(self, routineName):
        if self._crossRef.isPlatformGenericRoutineByName(routineName):
            return "%s&sup1" % routineName # superscript 1
        if not self._crossRef.routineHasSourceCodeByName(routineName):
            return "%s&sup2" % routineName # superscript 2
        return routineName
    def getRoutineDisplayName(self, routine):
        return self.getRoutineDisplayNameByName(routine.getName())

#===============================================================================
# Method to generate routine Index page
#===============================================================================
    def generateRoutineIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "routines.html"), 'w')
        self.__includeHeader__(outputFile)
        outputFile.write("<title>Routine Index List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Routine Index List</h1>\n</div>\n</div>")
        indexList = [char for char in string.uppercase]
        indexList.insert(0, "%")
        indexSet = sorted(set(indexList))
        generateIndexBar(outputFile, indexList, isIndex = True, printButton=True)
        outputFile.write("<div class=\"contents\">\n")
        sortedRoutines = []
        for routine in self._allRoutines.itervalues():
            sortedRoutines.append(routine.getName())
        sortedRoutines = sorted(sortedRoutines)
        for letter in indexList:
            bisect.insort_left(sortedRoutines, letter)
        totalRoutines = len(sortedRoutines)
        totalCol = 4
        numPerCol = totalRoutines / totalCol + 1
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        for i in range(numPerCol):
            itemsPerRow = [];
            for j in range(totalCol):
                if (i + numPerCol * j) < totalRoutines:
                    item = sortedRoutines[i + numPerCol * j]
                    itemsPerRow.append(item);
            generateIndexedRoutineTableRow(outputFile, itemsPerRow,
                                           self.getRoutineDisplayNameByName,
                                           indexSet)
        outputFile.write("</table>\n</div>\n")
        generateIndexBar(outputFile, indexList, isIndex = True)
        self.__includeFooter__(outputFile)
        outputFile.close()

    #===============================================================================
    # Return a dict with package as key, a list of 6 as value
    #===============================================================================
    def __mergePackageDependenciesList__(self, package, isDependencies=True):
        packageDepDict = dict()
        if isDependencies:
            routineDeps = package.getPackageRoutineDependencies()
            globalDeps = package.getPackageGlobalDependencies()
            fileManDeps = package.getPackageFileManFileDependencies()
            dbCallDeps = package.getPackageFileManDbCallDependencies()
        else:
            routineDeps = package.getPackageRoutineDependents()
            globalDeps = package.getPackageGlobalDependents()
            fileManDeps = package.getPackageFileManFileDependents()
            dbCallDeps = package.getPackageFileManDbCallDependents()
        for (package, depTuple) in routineDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][0] = len(depTuple[0])
            packageDepDict[package][1] = len(depTuple[1])
        for (package, depTuple) in globalDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][2] = len(depTuple[0])
            packageDepDict[package][3] = len(depTuple[1])
        for (package, depTuple) in fileManDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][4] = len(depTuple[0])
            packageDepDict[package][5] = len(depTuple[1])
        for (package, depTuple) in dbCallDeps.iteritems():
            if package not in packageDepDict:
                packageDepDict[package] = [0, 0, 0, 0, 0, 0, 0, 0]
            packageDepDict[package][6] = len(depTuple[0])
            packageDepDict[package][7] = len(depTuple[1])
        return packageDepDict

    #===============================================================================
    ## Method to generate merge and sorted Dependeny list by Package
    #===============================================================================
    def __mergeAndSortDependencyListByPackage__(self, package, isDependencyList):
        depPackageMerged = self.__mergePackageDependenciesList__(package, isDependencyList)
        # sort by the sum of the total # of routines
        depPackages = sorted(depPackageMerged.keys(),
                           key=lambda item: sum(depPackageMerged[item][0:7:2]),
                           reverse=True)
        return (depPackages, depPackageMerged)

    #===============================================================================
    ## Method to generate the package dependency/dependent graph
    #===============================================================================
    def generatePackageDependencyGraph(self, package, dependencyList=True):
        # merge the routine and package list
        depPackages, depPackageMerged = self.__mergeAndSortDependencyListByPackage__(
                                                                      package,
                                                                      dependencyList)
        if dependencyList:
            packageSuffix = "_dependency"
        else:
            packageSuffix = "_dependent"
        packageName = package.getName()
        normalizedName = normalizePackageName(packageName)
        totalPackage = len(depPackageMerged)
        if  (totalPackage == 0) or (totalPackage > MAX_DEPENDENCY_LIST_SIZE):
            logger.info("Nothing to do exiting... Package: %s Total: %d " %
                         (packageName, totalPackage))
            return
        try:
            dirName = os.path.join(self._outDir, packageName)
            if not os.path.exists(dirName):
                os.makedirs(dirName)
        except OSError, e:
            logger.error("Error making dir %s : Error: %s" % (dirName, e))
            return
        output = open(os.path.join(dirName, normalizedName + packageSuffix + ".dot"), 'w')
        output.write("digraph %s {\n" % (normalizedName + packageSuffix))
        output.write("\tnode [shape=box fontsize=14];\n") # set the node shape to be box
        output.write("\tnodesep=0.35;\n") # set the node sep to be 0.35
        output.write("\transsep=0.55;\n") # set the rank sep to be 0.75
        output.write("\tedge [fontsize=12];\n") # set the edge label and size props
        output.write("\t%s [style=filled fillcolor=orange label=\"%s\"];\n" % (normalizedName,
                                                                               packageName))
        for depPackage in depPackages:
            depPackageName = depPackage.getName()
            normalizedDepPackName = normalizePackageName(depPackageName)
            output.write("\t%s [label=\"%s\" URL=\"%s\"];\n" % (normalizedDepPackName,
                                                                depPackageName,
                                                                getPackageHtmlFileName(depPackageName)))
    #            output.write("\t%s->%s [label=\"depends\"];\n" % (normalizedName, normalizePackageName(depPackageName.getName())))
            depMetricsList = depPackageMerged[depPackage]
            edgeWeight = sum(depMetricsList[0:7:2])
            edgeLinkURL = getPackageDependencyHtmlFile(normalizedName, normalizedDepPackName)
            edgeStartNode = normalizedName
            edgeEndNode = normalizedDepPackName
            edgeLinkArch = packageName
            toolTipStartPackage = packageName
            toolTipEndPackage = depPackageName
            if not dependencyList:
                edgeStartNode = normalizedDepPackName
                edgeEndNode = normalizedName
                edgeLinkArch = depPackageName
                toolTipStartPackage = depPackageName
                toolTipEndPackage = packageName
            (edgeLabel, edgeToolTip, edgeStyle) = self.__getPackageGraphEdgePropsByMetrics__(depMetricsList,
                                                                                             toolTipStartPackage,
                                                                                             toolTipEndPackage)
            output.write("\t%s->%s [label=\"%s\" weight=%d URL=\"%s#%s\" style=\"%s\" labeltooltip=\"%s\" edgetooltip=\"%s\"];\n" % (edgeStartNode,
                                                     edgeEndNode,
                                                     edgeLabel,
                                                     edgeWeight,
                                                     edgeLinkURL,
                                                     edgeLinkArch,
                                                     edgeStyle,
                                                     edgeToolTip,
                                                     edgeToolTip))
        output.write("}\n")
        output.close()
        # use dot tools to generated the image and client side mapping
        outputName = os.path.join(dirName, normalizedName + packageSuffix + ".png")
        outputmap = os.path.join(dirName, normalizedName + packageSuffix + ".cmapx")
        inputName = os.path.join(dirName, normalizedName + packageSuffix + ".dot")
        # this is to generated the image in gif format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                               outputName,
                                                               outputmap,
                                                               inputName)
        logger.debug("command is %s" % command)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))

#===============================================================================
#  return a tuple of Edge Label, Edge ToolTip, Edge Style
#===============================================================================
    def __getPackageGraphEdgePropsByMetrics__(self, depMetricsList,
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
                  )
        labelText =("%s(R)" % (depMetricsList[0]),
                    "%s(G)" % (depMetricsList[2]),
                    "%s(F)" % (depMetricsList[4]),
                    "%s(D)" % (depMetricsList[6]),
                    )

        metricValue = 0
        (edgeLabel, edgeToolTip, edgeStyle) = ("","","")
        metricValue = 0
        for i in range(0,4):
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

#===============================================================================
#
#===============================================================================
    def copyFilesToOutputDir(self):
       cssFile = os.path.join(os.path.abspath(self._docRepDir),
                              "Web/DoxygenStyle.css")
       pdfFile = os.path.join(os.path.abspath(self._docRepDir),
                              "PythonScripts/PDF_Script.js")
       import shutil
       shutil.copy(cssFile, self._outDir)
       shutil.copy(pdfFile, self._outDir)

#===============================================================================
#
#===============================================================================
    def generateRoutineCallGraph(self, isCalled=True):
        logger.info("Start Routine generating call graph......")
        for package in self._allPackages.itervalues():
            routines = package.getAllRoutines()
            for routine in routines.itervalues():
                isPlatformGenericRoutine = self._crossRef.isPlatformGenericRoutineByName(routine.getName())
                if isCalled and isPlatformGenericRoutine:
                    self.generatePlatformGenericDependencyGraph(routine, isCalled)
                else:
                    self.generateRoutineDependencyGraph(routine, isCalled)
        logger.info("End of generating call graph......")

#===============================================================================
# Method to generate routine caller graph for platform dependent routines
#===============================================================================
    def generatePlatformGenericDependencyGraph(self, genericRoutine, isDependency):
        assert genericRoutine
        assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
        if not isDependency:
            return
        platformRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in platformRoutines.itervalues():
            self.generateRoutineDependencyGraph(routineInfo[0], isDependency)

#===============================================================================
#
#===============================================================================
    def generateRoutineCallerGraph(self):
        self.generateRoutineCallGraph(False)

#===============================================================================
## generate all dot file and use dot to generated the image file format
#===============================================================================
    def generateRoutineDependencyGraph(self, routine, isDependency=True):
        if not routine.getPackage():
            return
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if isDependency:
            depRoutines = routine.getCalledRoutines()
            routineSuffix = "_called"
            totalDep = routine.getTotalCalled()
        else:
            depRoutines = routine.getCallerRoutines()
            routineSuffix = "_caller"
            totalDep = routine.getTotalCaller()
        #do not generate graph if no dep routines, totalDep routines > max_dependency_list
        if (not depRoutines
            or len(depRoutines) == 0
            or  totalDep > MAX_DEPENDENCY_LIST_SIZE):
            logger.debug("No called Routines found! for routine:%s package:%s" % (routineName, packageName))
            return
        try:
            dirName = os.path.join(self._outDir, packageName)
            if not os.path.exists(dirName):
                os.makedirs(dirName)
        except OSError, e:
            logger.error("Error making dir %s : Error: %s" % (dirName, e))
            return
        output = open(os.path.join(dirName, routineName + routineSuffix + ".dot"), 'wb')
        output.write("digraph \"%s\" {\n" % (routineName + routineSuffix))
        output.write("\tnode [shape=box fontsize=14];\n") # set the node shape to be box
        output.write("\tnodesep=0.45;\n") # set the node sep to be 0.15
        output.write("\transsep=0.45;\n") # set the rank sep to be 0.75
#        output.write("\tedge [fontsize=12];\n") # set the edge label and size props
        if routine.getPackage() not in depRoutines:
            output.write("\tsubgraph \"cluster_%s\"{\n" % (routine.getPackage()))
            output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % routineName)
            output.write("\t}\n")
        for (package, callDict) in depRoutines.iteritems():
            output.write("\tsubgraph \"cluster_%s\"{\n" % (package))
            for routine in callDict.keys():
                output.write("\t\t\"%s\" [URL=\"%s\"];\n" % (routine,
                                                         getRoutineHtmlFileName(routine)))
                if str(package) == packageName:
                    output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % routineName)
            output.write("\t\tlabel=\"%s\";\n" % package)
            output.write("\t}\n")
            for (routine, tags) in callDict.iteritems():
                if isDependency:
                    output.write("\t\t\"%s\"->\"%s\"" % (routineName, routine))
                else:
                    output.write("\t\t\"%s\"->\"%s\"" % (routine, routineName))
                output.write(";\n")
        output.write("}\n")
        output.close()
        outputName = os.path.join(dirName, routineName + routineSuffix + ".png")
        outputmap = os.path.join(dirName, routineName + routineSuffix + ".cmapx")
        inputName = os.path.join(dirName, routineName + routineSuffix + ".dot")
        # this is to generated the image in png format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        # @TODO this should be able to run in parallel
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                               outputName,
                                                               outputmap,
                                                               inputName)
        logger.debug("command is %s" % command)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))

#===============================================================================
#
#===============================================================================
    def generatePackageDependenciesGraph(self, isDependency=True):
        # generate all dot file and use dot to generated the image file format
        if isDependency:
            name = "dependencies"
        else:
            name = "dependents"
        logger.info("Start generating package %s......" % name)
        logger.info("Total Packages: %d" % len(self._allPackages))
        for package in self._allPackages.values():
            self.generatePackageDependencyGraph(package, isDependency)
        logger.info("End of generating package %s......" % name)

#===============================================================================
#
#===============================================================================
    def generatePackageDependentsGraph(self):
        self.generatePackageDependenciesGraph(False)

#===============================================================================
#
#===============================================================================
    def generatePackageIndexPage(self):
        outputFile = open(os.path.join(self._outDir, "packages.html"), 'w')
        self.__includeHeader__(outputFile)
        #write the _header
        outputFile.write("<title>Package List</title>")
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Package List</h1>\n</div>\n</div>")
        generateIndexBar(outputFile, string.uppercase, isIndex = True, printButton=True)
        outputFile.write("<div class=\"contents\">\n")
        #generated the table
        totalNumPackages = len(self._allPackages) + len(string.uppercase)
        totalCol = 3
        # list in three columns
        numPerCol = totalNumPackages / totalCol + 1
        sortedPackages = sorted(self._allPackages.keys())
        for letter in string.uppercase:
            bisect.insort_left(sortedPackages, letter)
        # write the table first
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        for i in range(numPerCol):
            itemsPerRow = [];
            for j in range(totalCol):
                if (i + numPerCol * j) < totalNumPackages:
                    itemsPerRow.append(sortedPackages[i + j * numPerCol]);
            generateIndexedPackageTableRow(outputFile, itemsPerRow)
        outputFile.write("</table>\n</div>\n")
        generateIndexBar(outputFile, string.uppercase, isIndex = True)
        self.__includeFooter__(outputFile)
        outputFile.close()

#=======================================================================
# Method to generate package dependency/dependent section info
#=======================================================================
    def generatePackageDependencySection(self, packageName, outputFile, isDependencyList=True):
        if isDependencyList:
            sectionGraphHeader = "Dependency Graph"
            sectionListHeader = "Package Dependency List"
            packageSuffix = "_dependency"
        else:
            sectionGraphHeader = "Dependent Graph"
            sectionListHeader = "Package Dependent List"
            packageSuffix = "_dependent"

        writeSectionHeader(sectionGraphHeader, sectionGraphHeader, outputFile)
        outputFile.write("<div>\n")
        try:
            # write the image of the dependency graph
            fileNamePrefix = normalizePackageName(packageName) + packageSuffix
            cmapFile = open(os.path.join(self._outDir, packageName + "/" + fileNamePrefix + ".cmapx"), 'r')
            outputFile.write("<div class=\"contents\">\n")
            imageFileName = packageName + "/" + fileNamePrefix + ".png"
            outputFile.write("<img id=\"package%sGraph\" src=\"%s\" border=\"0\" alt=\"Call Graph\" usemap=\"#%s\"/>\n"
                       % (packageSuffix, imageFileName, fileNamePrefix))

            # append the content of map outputFile
            for line in cmapFile:
                outputFile.write(line)
            outputFile.write("</div>\n")
        except IOError:
            pass
        package = self._allPackages[packageName]
        depPackages, depPackagesMerged = \
          self.__mergeAndSortDependencyListByPackage__(package, isDependencyList)
        totalPackages = 0
        if depPackages:
            totalPackages = len(depPackages)
        total = "%s Total: %d " % (sectionListHeader, totalPackages)
        writeSubSectionHeader(total, outputFile)
        key = "Format: package[# of caller routines(R):# of global accessing routines(G): \
                    # of fileman file references(F): # of fileman db call reference(D)]"
        outputFile.write("<h4>%s</h4><BR>\n" % key)
        if totalPackages > 0:
            outputFile.write("<div class=\"contents\"><table>\n")
            numOfCol = 6
            numOfRow = totalPackages / numOfCol + 1
            for index in range(numOfRow):
                outputFile.write("<tr>")
                for j in range(numOfCol):
                    if (index * numOfCol + j) < totalPackages:
                        depPackage = depPackages[index * numOfCol + j]
                        depPackageName = depPackage.getName()
                        toolTipStartPackage = packageName
                        toolTipEndPackage = depPackageName
                        if not isDependencyList:
                            toolTipStartPackage = depPackageName
                            toolTipEndPackage = packageName
                        depMetricsList = depPackagesMerged[depPackage]
                        linkName, tooltip, edgeStyle = self.__getPackageGraphEdgePropsByMetrics__(
                                                         depMetricsList,
                                                         toolTipStartPackage,
                                                         toolTipEndPackage,
                                                         False)

                        depHyperLink = getPackagePackageDependencyHyperLink(packageName,
                                                                          depPackageName,
                                                                          linkName,
                                                                          tooltip,
                                                                          isDependencyList)
                        outputFile.write("<td class=\"indexkey %s\"><a class=\"e1\" href=\"%s\">%s</a> [%s]&nbsp;&nbsp;&nbsp</td>"
                                   % (packageSuffix, getPackageHtmlFileName(depPackageName), depPackageName, depHyperLink))
                outputFile.write("</tr>\n")
            outputFile.write("</table></div>\n")
        writeSectionEnd(outputFile)
        outputFile.write("</div>\n")

#===============================================================================
#
#===============================================================================
    def writeTitleBlock(self, pageTitle, title, package, outputFile,
                        extraHtmlHeader=None):
        outputFile.write("<title id=\"pageTitle\">%s</title>" % pageTitle)
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        if package is not None:
            outputFile.write(("<h4>Package: %s</h4>\n</div>\n</div>"
                               % getPackageHyperLinkByName(package.getName())))
        if extraHtmlHeader:
            outputFile.write("<h4>%s</h4>\n</div>\n</div><br/>\n" % extraHtmlHeader)
        outputFile.write("<h1>%s</h1>\n</div>\n</div><br/>\n" % title)
#===============================================================================
# method to generate a tablized representation of data
#===============================================================================
    def generateTablizedItemList(self, sortedItemList, outputFile, htmlMappingFunc,
                                 nameFunc=None, totalCol=8, classid=""):
        totalNumRoutine = 0
        if sortedItemList:
            totalNumRoutine = len(sortedItemList)
        numOfRow = totalNumRoutine / totalCol + 1
        if totalNumRoutine > 0:
            outputFile.write("<div class=\"contents\"><table>\n")
            for index in range(numOfRow):
                outputFile.write("<tr class=\"%s\">" % classid)
                for i in range(totalCol):
                    position = index * totalCol + i
                    if position < totalNumRoutine:
                        displayName = sortedItemList[position]
                        if nameFunc: displayName = nameFunc(displayName)
                        outputFile.write("<td class=\"indexkey\"><a class=\"e1\" href=\"%s\">%s</a>&nbsp;&nbsp;&nbsp;&nbsp;</td>"
                                   % (htmlMappingFunc(sortedItemList[position]),
                                      displayName))
                outputFile.write("</tr>\n")
            outputFile.write("</table>\n</div>\n")
        else:
            outputFile.write("<div>\n</div>\n")
#===============================================================================
#
#===============================================================================
    def writeGenericTablizedHtmlData(self, headerList, itemList, outputFile, classid=""):
        outputFile.write("<div><table>\n")
        if headerList and len(headerList) > 0:
            outputFile.write("<tr class=\"%s\" >\n" % (classid))
            for header in headerList:
                outputFile.write("<th class=\"IndexKey\">%s</th>\n" % ( header))
            outputFile.write("</tr>\n")
        if itemList and len(itemList) > 0:
            for itemRow in itemList:
                outputFile.write("<tr class=\"%s\">\n" % (classid))
                for data in itemRow:
                    outputFile.write("<td class=\"IndexValue\">%s</td>\n" % (data))
                outputFile.write("</tr>\n")
        outputFile.write("</table></div></div>\n")  # the second </div> closes the accordion

#===============================================================================
# method to generate individual package page
#===============================================================================
    def generateIndividualPackagePage(self):
        indexList = ["Namespace", "Doc", "Dependency Graph",
                     "Dependent Graph",
                     "All ICR Entries","FileMan Files",
                     "Non-FileMan Globals", "All Routines"]
        for packageName in self._allPackages.iterkeys():
            package = self._allPackages[packageName]
            outputFile = open(os.path.join(self._outDir, getPackageHtmlFileName(packageName)), 'w')

            # Write the _header part
            self.__includeHeader__(outputFile)
            generateIndexBar(outputFile, indexList, printButton=True)
            # Title
            title = "Package: %s" % packageName
            writePDFCustomization(outputFile, str(indexList))
            self.writeTitleBlock(title, title, None, outputFile)
            # Namespace
            namespace = "Namespace: %s" % listDataToCommaSeperatorString(package.getNamespaces())
            outputFile.write(getAccordionHTML())
            writeSectionHeader("Namespace", "Namespace", outputFile)
            outputFile.write("<div class=packageNamespace>")
            outputFile.write("<div><p><h4 id=\"packageNamespace\">Namespace: %s</h4></div>" % listDataToCommaSeperatorString(package.getNamespaces()))
            globalNamespaces = package.getGlobalNamespace()
            if globalNamespaces and len(globalNamespaces) > 0:
                globalNamespace = "Additional Global Namespace: %s" % listDataToCommaSeperatorString(globalNamespaces)
                outputFile.write("<div><p><h4 id=\"packageNamespace\">" + globalNamespace + "</h4></div>")
            else:
                outputFile.write("</h4></div>")
            writeSectionEnd(outputFile)

            # Link to VA documentation
            writeSectionHeader("Documentation", "Doc", outputFile)
            if len(package.getDocLink()) > 0:
                outputFile.write("<div><p><h4 id=\"packageDocs\">VA documentation in the <a target='blank' href=\"%s\">VistA Documentation Library</a></p></div>" % package.getDocLink())
                if len(package.getDocMirrorLink()) > 0:
                    outputFile.write("&nbsp;or&nbsp;<a href=\"%s\">OSEHRA Mirror site</a></h4></div>\n" % package.getDocMirrorLink())
            else:
                outputFile.write("<div><p><h4><a href=\"https://www.va.gov/vdl/\">VA documentation in the VistA Documentation Library</a></h4></p></div>\n")
            writeSectionEnd(outputFile)

            self.generatePackageDependencySection(packageName, outputFile, True)
            self.generatePackageDependencySection(packageName, outputFile, False)

            # Find all ICR entries that have the package as a "CUSTODIAL Package"
            icrList = self.queryICRInfo(packageName.upper(),"*","*")
            writeSectionHeader("All ICR Entries: %d" % len(icrList),
                               "All ICR Entries",
                               outputFile)
            sortedICRList = sorted(icrList, key=lambda item: float(item["NUMBER"]))
            self.generateTablizedItemList(sortedICRList, outputFile,
                                          getICRHtmlFileName,
                                          getICRDisplayName, classid="icrVals")
            writeSectionEnd(outputFile)

            # separate fileman files and non-fileman globals
            fileManList, globalList = [], []
            allGlobals = package.getAllGlobals()
            for globalVar in allGlobals.itervalues():
                if globalVar.isFileManFile():
                    fileManList.append(globalVar)
                else:
                    globalList.append(globalVar)

            # section of All FileMan files
            writeSectionHeader("All FileMan Files Total: %d" % len(fileManList),
                               "FileMan Files",
                               outputFile)
            sortedFileManList = sorted(fileManList, key=lambda item: float(item.getFileNo())) # sorted by fileMan file No
            self.generateTablizedItemList(sortedFileManList, outputFile,
                                          getGlobalHtmlFileName,
                                          getGlobalDisplayName,classid="fmFiles")
            writeSectionEnd(outputFile)

            # section of All Non-FileMan Globals
            writeSectionHeader("Non FileMan Globals Total: %d" % len(globalList),
                               "Non-FileMan Globals",
                               outputFile)
            sortedGlobalList = sorted(globalList, key=lambda item: item.getName()) # sorted by global Name
            self.generateTablizedItemList(sortedGlobalList, outputFile,
                                          getGlobalHtmlFileName,
                                          getGlobalDisplayName, classid="nonfmFiles")
            writeSectionEnd(outputFile)

            # section of all routines
            sortedRoutines = sorted(package.getAllRoutines().keys())
            totalNumRoutine = len(sortedRoutines)
            writeSectionHeader("All Routines Total: %d" % totalNumRoutine,
                               "All Routines",
                               outputFile)
            self.generateTablizedItemList(sortedRoutines, outputFile,
                                          getRoutineHtmlFileName,
                                          self.getRoutineDisplayNameByName,
                                          8,classid="rtns")
            writeSectionEnd(outputFile)

            generateIndexBar(outputFile, indexList)
            self.__includeFooter__(outputFile)
            outputFile.close()

#===============================================================================
# method to generate Routine Dependency and Dependents page
#===============================================================================
    def generateRoutineDependencySection(self, routine, outputFile, isDependency=True):
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if isDependency:
            depRoutines = routine.getCalledRoutines()
            sectionGraphHeader = "Call Graph"
            sectionListHeader = "Called Routines"
            totalNum = routine.getTotalCalled()
        else:
            depRoutines = routine.getCallerRoutines()
            sectionGraphHeader = "Caller Graph"
            sectionListHeader = "Caller Routines"
            routineSuffix = "_caller"
            totalNum = routine.getTotalCaller()
        if not depRoutines:
          return
        self.__writeRoutineDepGraphSection__(routine, depRoutines,
                                             sectionGraphHeader,
                                             sectionGraphHeader,
                                             outputFile, isDependency)
        self.__writeRoutineDepListSection__(routine, depRoutines,
                                            sectionListHeader,
                                            sectionListHeader,
                                            outputFile, isDependency)
    def __getDataEntryDetailHtmlLink__(self, fileNo, ien):
      return ("https://code.osehra.org/vivian/files/%s/%s-%s.html" % (fileNo.replace('.','_'),fileNo,
            ien))
    def __convertRPCDataReference__(self, variables):
        return self.__convertRtnDataReference__(variables, '8994')
    def __convertHL7DataReference__(self, variables):
        return self.__convertRtnDataReference__(variables, '101')
    def __convertRtnDataReference__(self, variables, fileNo):
        output = []
        for item in variables:
            detailLink = self.__getDataEntryDetailHtmlLink__(fileNo,
                item['ien'])
            name = "<a href=\"%s\">%s</a>" % (detailLink, item['name'])
            tag = item.get('tag', "")
            output.append((name, tag))
        return output

    def __convertVariableToTableData__(self, variables, isGlobal=False):
        output = []
        allVars = sorted(variables.iterkeys())
        for varName in allVars:
            var = variables[varName]
            if isGlobal and varName in self._allGlobals:
                globalVar = self._allGlobals[varName]
                varName = getFileManFileHyperLinkWithNameFileNo(globalVar)
            lineOccurencesString = self.__generateLineOccurencesString__(var.getLineOffsets())
            output.append(((var.getPrefix()+varName).strip(), lineOccurencesString))
        return output

    def __generateLineOccurencesString__(self, lineOccurences):
        lineOccurencesString = ""
        index = 0
        for offset in lineOccurences:
            if index > 0:
                lineOccurencesString += ",&nbsp;"
            lineOccurencesString += offset
            if (index + 1) % LINE_TAG_PER_LINE == 0:
                lineOccurencesString +="<BR>"
            index += 1
        return lineOccurencesString

    def __convertGlobalVarToTableData__(self, variables):
        return self.__convertVariableToTableData__(variables, True)

    def __convertFileManDbCallToTableData__(self, variables):
        output = []
        allVars = sorted(variables.keys())
        for fileNo in allVars:
            varInst, tags = variables[fileNo]
            varName = None
            if varInst.getFileNo() and varInst.isSubFile():
                varName = getFileManSubFileHypeLinkByName(varInst.getFileNo())
            else:
                varName = getFileManFileHyperLinkWithNameFileNo(varInst)
            callTagsStr = ""
            index = 0
            for item in tags:
                if index > 0:
                    callTagsStr += ", &nbsp;"
                if item == None:
                    callTagsStr += "Classic Fileman Calls"
                else:
                    tag, rtn = "", ""
                    rst = item.split('^')
                    if len(rst) == 0:
                      rtn = rst[0]
                    else:
                      tag = rst[0]
                      rtn = rst[1]
                    callTagsStr += tag + '^' + getRoutineHypeLinkByName(rtn)
                index += 1
            output.append((varName, callTagsStr))
        return output

    def __convertNakedGlobaToTableData__(self, variables):
        return self.__convertVariableToTableData__(variables, False)

    def __convertMarkedItemToTableData__(self, variables):
        return self.__convertVariableToTableData__(variables, False)

    def __convertLabelReferenceToTableData__(self, variables):
        return self.__convertVariableToTableData__(variables, False)

    def __convertExternalReferenceToTableData__(self, variables):
        output = []
        allVars = sorted(variables.iterkeys(), key = itemgetter(0,1))
        for nameTag in allVars:
            lineOccurencesString = self.__generateLineOccurencesString__(variables[nameTag])
            output.append((nameTag[1]+"^"+getRoutineHypeLinkByName(nameTag[0]),
                           lineOccurencesString))
        return output

#===============================================================================
# Methods to generate individual routine page
#===============================================================================
    def __getRpcReferences__(self, rtnName):
        return self.__getRtnDataFileRefs__(rtnName, '8994')
    def __getHl7References__(self, rtnName):
        return self.__getRtnDataFileRefs__(rtnName, '101')
    def __getRtnDataFileRefs__(self, rtnName, fileNo):
        if self._rtnRefJson and rtnName in self._rtnRefJson:
          refFilesJson = self._rtnRefJson[rtnName]
          return refFilesJson.get(fileNo)
        return None
    def __writeRoutineInfoSection__(self, routine, data, header, link, outputFile,classid=""):
        writeSectionHeader(header, link, outputFile)
        outputFile.write("<div>")
        for comment in data:
            outputFile.write("<p><span class=\"information %s\">%s</span></p>\n" % (classid,comment))
        outputFile.write("</div>")

    def __writeRoutineSourceSection__(self, routine, data, header, link,
                                      outputFile, classid=""):
        writeSectionHeader(header, link, outputFile)
        outputFile.write("<div class=\"%s\"><p><span class=\"sourcefile\">Source file &lt;<a class=\"el\" href=\"%s\">%s.m</a>&gt;</span></p></div>\n" %
                         (classid,
                          getRoutineSourceHtmlFileName(routine.getOriginalName()),
                          routine.getOriginalName()))

    # Generate routine variables sections
    # (e.g. Local Variables or Global Variables)
    def __writeRoutineVariableSection__(self, routine, data, header, link,
                                        outputFile, tableHeader, convFunc, classid=""):
        writeSectionHeader(header, header, outputFile)
        if header == "Local Variables":
            outputFile.write(XINDEXLegend)
        outputList = convFunc(data)
        self.writeGenericTablizedHtmlData(tableHeader, outputList, outputFile, classid=classid)

    # Read through all available ICR information and generate links for each found within it
    def __writeICRInformation__(self, icrVals):
      icrString = ""
      for icrEntry in icrVals:
        icrString += "<li><a href='%s'>ICR #%s</a></li>" % (getICRHtmlFileName(icrEntry),icrEntry["NUMBER"])
        if "STATUS" in icrEntry:
          icrString +="<ul><li>Status: %s</li></ul>" % (icrEntry["STATUS"])
        if "USAGE" in icrEntry:
          icrString +="<ul><li>Usage: %s</li></ul>" % (icrEntry["USAGE"])
      return icrString

    def __writeInteractionCommandHTML__(self, entry):
      outstring = "<ul>"
      entryDict = {
                  "formatting": "Formatting:",
                  "string": "Prompt:",
                  "variable": "Variable:",
                  "timeout": "Timeout:",
                  "conditional": "Condition for execution:",
                  "line": "Line Location:"
                 }
      for key in entryDict:
        if key in entry:
          outstring += "<li>%s %s</li>" % (entryDict[key],entry[key])
      outstring +=  "</ul>"
      return outstring

    def __writeEntryPointSection__(self, routine, data, header, link,
                                    outputFile, tableHeader, classid=""):
        writeSectionHeader("Entry Points", "Routine Entry Points", outputFile)
        entryPoints = routine.getEntryPoints()
        tableData = []
        for entry in entryPoints:
            row = []
            comments = entryPoints[entry]["comments"] if entryPoints[entry]["comments"] else ""
            # Build table row
            row.append(entry)
            val = ""
            for line in comments:
                val += line + '<br/>'
            row.append(val)
            row.append(self.__writeICRInformation__(entryPoints[entry]["icr"]))
            tableData.append(row)
        self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid=classid)

    def __writeInteractionSection__(self, routine, data, header, link,
                                     outputFile, tableHeader, classid=""):
        writeSectionHeader("Interaction Calls", "Interaction Calls", outputFile)
        calledRtns = routine.getFilteredExternalReference(['DIR','VALM','DDS','DIE','DIC','%ZIS','DIALOG','DIALOGU'])
        tableData = []
        for entry in data:  # R and W commands
          row = []
          row.append("Function Call: %s" % entry['type'])
          row.append(self.__writeInteractionCommandHTML__(entry))
          tableData.append(row)
        # Write out the entries that are "interaction" routines
        for entry in calledRtns:
          row = []
          row.append("Routine Call")
          val = "<ul>"
          val += "<li>"+entry[0]+"</li>"
          # Nicely show the ENTRYPOINT+OFFSET values for location
          if type(calledRtns[entry]) is list:
            val += "<li>Line Location:</li>"
            val += "<ul>"
            for location in calledRtns[entry]:
              val += "<li>"+location+"</li>"
            val += "</ul>"
          else:
            val += "<li>"+str(calledRtns[entry])+"</li>"
          val += "</ul>"
          row.append(val)
          tableData.append(row)
        self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile,classid=classid)

    def __writeRoutineDepGraphSection__(self, routine, data, header, link,
                                        outputFile, isDependency=True,classid=""):
        writeSectionHeader(header, link, outputFile)
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if isDependency:
          routineSuffix = "_called"
        else:
          routineSuffix = "_caller"
        fileNamePrefix = routineName + routineSuffix
        fileName = os.path.join(self._outDir,
                                packageName + "/" + fileNamePrefix + ".cmapx")
        if os.path.exists(fileName):
          outputFile.write("<div class=\"contents\">\n")
          imageFileName = packageName + "/" + fileNamePrefix + ".png"
          outputFile.write("<img id=\"img%s\"src=\"%s\" border=\"0\" alt=\"%s\" usemap=\"#%s\"/>\n"
                     % (routineSuffix,
                        urllib.quote(imageFileName),
                        header,
                        fileNamePrefix))
          # append the content of map outputFile
          with open(fileName, 'r') as cmapFile:
            for line in cmapFile:
                outputFile.write(line)
        self.__writeRoutineDepListSection__(routine, data, header, link,
                                        outputFile, isDependency, classid=classid)
    def __writeRoutineDepListSection__(self, routine, data, header, link,
                                       outputFile, isDependency=True, classid=""):
      if isDependency:
          totalNum = routine.getTotalCalled()
      else:
          totalNum = routine.getTotalCaller()
      writeSubSectionHeader("%s Total: %d" % (header, totalNum), outputFile)
      tableHeader = ["Package", "Total", header]
      tableData = []
      # sort the key by Total # of routines
      sortedDepRoutines = sorted(sorted(data.keys()),
                               key=lambda item: len(data[item]),
                               reverse=True)
      for depPackage in sortedDepRoutines:
          routinePackageLink = getPackageHyperLinkByName(depPackage.getName())
          routineNameLink = ""
          index = 0
          for depRoutine in sorted(data[depPackage].keys()):
              if isDependency: # append tag information for called routines
                  allTags = data[depPackage][depRoutine].keys()
                  sortedTags = sorted(allTags)
                  # format the tag
                  tagString = ""
                  if len(sortedTags) > 1:
                      tagString = "("
                  idx = 0
                  for tag in sortedTags:
                      if idx > 0:
                          tagString += ","
                      idx += 1
                      tagString += tag
                  if len(sortedTags) > 1:
                      tagString += ")"
                  routineNameLink += tagString + "^"
              routineNameLink += getRoutineHypeLinkByName(depRoutine.getName())
              routineNameLink += "&nbsp;&nbsp;"
              if (index + 1) % 8 == 0:
                  routineNameLink += "<BR>"
              index += 1
          row = []
          row.append(routinePackageLink)
          row.append("%d" % len(data[depPackage]))
          row.append(routineNameLink)
          tableData.append(row)
      self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid=classid)

    def __generateIndividualRoutinePage__(self, routine, platform=None):
        assert routine
        routineName = routine.getName()
        # This is a list of sections that might be applicable to a routine
        sectionGenLst = [
           # Name section
           {
             "name": "Info", # this is also the link name
             "header" : "Information", # this is the actual display name
             "data" : routine.getComment, # the data source
             "generator" : self.__writeRoutineInfoSection__, # section generator
             'classid': "header"
           },
           # Source section
           {
             "name": "Source", # this is also the link name
             "header" : "Source Code", # this is the actual display name
             "data" : routine.hasSourceCode, # the data source
             "generator" : self.__writeRoutineSourceSection__, # section generator
             "classid":"source"
           },
           # Call Graph section
           {
             "name": "Call Graph", # this is also the link name
             "data" : routine.getCalledRoutines, # the data source
             "generator" : self.__writeRoutineDepGraphSection__, # section generator
             "classid"  :"callG"
           },
           # Caller Graph section
           {
             "name": "Caller Graph", # this is also the link name
             "data" : routine.getCallerRoutines, # the data source
             "generator" : self.__writeRoutineDepGraphSection__, # section generator
             "classid"  :"callerG",
             "geneargs" : [False],
           },
            # Entry Point section
           {
             "name": "Entry Points", # this is also the link name
             "data" : routine.getEntryPoints, # the data source
             "generator" : self.__writeEntryPointSection__, # section generator
             "geneargs" : [ENTRY_POINT_SECTION_HEADER_LIST], # extra argument
             "classid"  :"entrypoint"
           },
           # External References section
           {
             "name": "External References", # this is also the link name
             "data" : routine.getExternalReference, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertExternalReferenceToTableData__], # extra argument
             "classid"  :"external"
           },
           # Interaction Code section
           {
             "name": "Interaction Calls", # this is also the link name
             "data" : routine.getInteractionEntries, # the data source
             "generator" : self.__writeInteractionSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST], # extra argument
             "classid"  :"interactioncalls"
           },
           # Used in RPC section
           {
             "name": "Used in RPC", # this is also the link name
             "data" : self.__getRpcReferences__, # the data source
             "dataarg" : [routineName], # extra arguments for data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [RPC_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertRPCDataReference__], # extra argument
             "classid"  :"rpc"
           },
           # Used in HL7 Interface section
           {
             "name": "Used in HL7 Interface", # this is also the link name
             "data" : self.__getHl7References__, # the data source
             "dataarg" : [routineName], # extra arguments for data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [HL7_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertHL7DataReference__], # extra argument
             "classid"  :"hl7"
           },
           # FileMan Files Accessed Via FileMan Db Call section
           {
             "name": "FileMan Files Accessed Via FileMan Db Call", # this is also the link name
             "data" : routine.getFilemanDbCallGlobals, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [FILENO_FILEMANDB_SECTION_HEADER_LIST,
                           self.__convertFileManDbCallToTableData__], # extra argument
             "classid"  :"dbCall"
           },
           # Global Variables Directly Accessed section
           {
             "name": "Global Variables Directly Accessed", # this is also the link name
             "data" : routine.getGlobalVariables, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [GLOBAL_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertGlobalVarToTableData__], # extra argument
             "classid"  :"directAccess"
           },
           # Label References section
           {
             "name": "Label References", # this is also the link name
             "data" : routine.getLabelReferences, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [LABEL_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertLabelReferenceToTableData__], # extra argument
             "classid"  :"label"
           },
           # Naked Globals section
           {
             "name": "Naked Globals", # this is also the link name
             "data" : routine.getNakedGlobals, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertNakedGlobaToTableData__], # extra argument
             "classid"  :"naked"
           },
           # Local Variables section
           {
             "name": "Local Variables", # this is also the link name
             "data" : routine.getLocalVariables, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertVariableToTableData__], # extra argument
             "classid"  :"local"
           },
           # Marked Items section
           {
             "name": "Marked Items", # this is also the link name
             "data" : routine.getMarkedItems, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertMarkedItemToTableData__], # extra argument
             "classid"  :"marked"
           },
        ]
        package = routine.getPackage()

        outputFile = open(os.path.join(self._outDir,
                                       getRoutineHtmlFileNameUnquoted(routineName)), 'w')
        self.__includeHeader__(outputFile)

        # generated the qindex bar
        indexList = []
        idxLst = []
        for idx, item in enumerate(sectionGenLst):
          extraarg = item.get('dataarg', [])
          if item['data'](*extraarg):
            indexList.append(item['name'])
            idxLst.append(idx)
        generateIndexBar(outputFile, indexList, printButton=True)
        # Title
        writePDFCustomization(outputFile, str(indexList))
        title = "Routine: %s" % routineName
        routineHeader = title
        if platform:
            routineHeader += "Platform: %s" % platform
        self.writeTitleBlock(title, routineHeader, package, outputFile)
        outputFile.write(getAccordionHTML())
        for idx in idxLst:
          sectionGen = sectionGenLst[idx]
          data = sectionGen['data'](*sectionGen.get('dataarg',[]))
          link = sectionGen['name']
          header = sectionGen.get('header', link)
          geneargs = sectionGen.get('geneargs',[])
          classid  = sectionGen.get('classid', "")
          sectionGen['generator'](routine, data, header, link, outputFile,classid=classid, *geneargs)
          writeSectionEnd(outputFile)
          if header == "Local Variables":
           outputFile.write("</div>\n")
        # generated the index bar at the bottom
        generateIndexBar(outputFile, indexList)
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
# Method to generate page for platform-dependent generic routine page
#===============================================================================
    def __generatePlatformDepentGenericRoutinePage__(self, genericRoutine):
        assert genericRoutine
        assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
        # generated the subpage for each platform routines
        platformDepRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in platformDepRoutines.itervalues():
            self.__generateIndividualRoutinePage__(routineInfo[0], routineInfo[1])
        indexList = ["Platform Dependent Routines", "Caller Graph", "Caller Routines"]
        routineName = genericRoutine.getName()
        package = genericRoutine.getPackage()
        outputFile = open(os.path.join(self._outDir,
                                       getRoutineHtmlFileNameUnquoted(routineName)), 'w')
        self.__includeHeader__(outputFile)
        # generated the qindex bar
        generateIndexBar(outputFile, indexList, printButton=True)
        title = "Routine: %s" % routineName
        self.writeTitleBlock(title, title, package, outputFile)
        writeSectionHeader("Platform Dependent Routines", "DepRoutines", outputFile)
        # output the Platform part.
        tableRowList = []
        for routineInfo in platformDepRoutines.itervalues():
            tableRowList.append([getRoutineHypeLinkByName(routineInfo[0].getName()), routineInfo[1]])
        self.writeGenericTablizedHtmlData(["Routine", "Platform"], tableRowList, outputFile)
        self.generateRoutineDependencySection(genericRoutine, outputFile, False)
        outputFile.write("<br/>\n")
        # generated the index bar at the bottom
        generateIndexBar(outputFile, indexList)
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
# Method to generate all individual routine pages
#===============================================================================
    def generateAllIndividualRoutinePage(self):
        logger.info("Start generating all individual Routines......")
        totalNoRoutines = len(self._allRoutines)
        routineIndex = 0
        for package in self._allPackages.itervalues():
            for routine in package.getAllRoutines().itervalues():
                if (routineIndex + 1) % PROGRESS_METER == 0:
                    logger.info("Processing %d of total %d" % (routineIndex, totalNoRoutines))
                routineIndex += 1
                # handle the special case for platform dependent routine
                if self._crossRef.isPlatformGenericRoutineByName(routine.getName()):
                    self.__generatePlatformDepentGenericRoutinePage__(routine)
                else:
                    self.__generateIndividualRoutinePage__(routine)
        logger.info("End of generating individual routines......")

###############################################################################
# Logging

# constants
DEFAULT_OUTPUT_LOG_FILE_NAME = "WebPageGen.log"

import tempfile
def getTempLogFile():
    return os.path.join(tempfile.gettempdir(), DEFAULT_OUTPUT_LOG_FILE_NAME)

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

#===============================================================================
# main
#===============================================================================
def run(args):
    # Reads in the ICR JSON file and generates
    # a dictionary that consists of only the routine information
    #
    # Each key is a routine and it points to a list of all of the entries
    # that have that routine marked as a "ROUTINE" field.
    #
    if args.icrJsonFile:
      icrJson = os.path.abspath(args.icrJsonFile)
    parsedICRJSON= {}
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
    crossRef = CrossReferenceBuilder().buildCrossReferenceWithArgs(args,pkgDepJson=None, icrJson=parsedICRJSON)
    logger.info ("Starting generating web pages....")
    doxDir = os.path.join(args.patchRepositDir, 'Utilities/Dox')
    webPageGen = WebPageGenerator(crossRef,
                                  args.outdir,
                                  args.MRepositDir,
                                  doxDir,
                                  args.git,
                                  args.includeSource,
                                  args.rtnJson)
    if args.dot:
        webPageGen.setDot(args.dot)
    webPageGen.generateWebPage()
    logger.info ("End of generating web pages....")

if __name__ == '__main__':
    crossRefArgParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
        description='VistA Visual Cross-Reference Documentation Generator',
        parents=[crossRefArgParse])
    parser.add_argument('-o', '--outdir', required=True,
                        help='Output Web Page directory')
    parser.add_argument('-git', required=True, help='git executable')
    parser.add_argument('-dot', required=False,
                        help='path to the folder containing dot excecutable')
    parser.add_argument('-is', '--includeSource', required=False,
                        default=False, action='store_true',
                        help='generate routine source code page?')
    parser.add_argument('-lf', '--outputLogFileName', required=False,
                        help='the output Logging file')
    parser.add_argument('-rj','--rtnJson', required=True,
                        help='routine reference in VistA data file in JSON format')
    parser.add_argument('-icr','--icrJsonFile', required=True,
                        help='JSON formatted information of DBIA/ICR')
    result = parser.parse_args();

    if not result.outputLogFileName:
      outputLogFile = getTempLogFile()
    else:
      outputLogFile = result.outputLogFileName
    initLogging(outputLogFile)
    logger.debug (result)

    run(result)
