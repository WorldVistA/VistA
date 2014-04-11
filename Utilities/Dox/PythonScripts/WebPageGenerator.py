#!/usr/bin/env python

# A python script to generate the VistA cross reference web page
# To run the script, please do
# python WebPageGenerator.py -l <logFileDir> -r <VistA-Repository-Dir> -o <outputDir>
# Make sure that all the css/html files under web directory are copied to outputDIr
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
import os
import os.path
import sys
import subprocess
import urllib
import string
import bisect
import argparse
import shutil
import csv
import json

from datetime import datetime, date, time
from LogManager import logger
import logging
from operator import itemgetter, attrgetter
from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser
from CrossReference import *

MAX_DEPENDENCY_LIST_SIZE = 30 # Do not generate the graph if have more than 30 nodes
PROGRESS_METER = 1000
LOCAL_VARIABLE_SECTION_HEADER_LIST = [
      "Name &nbsp;(>>&nbsp;not killed explicitly)",
      '''Line Occurrences &nbsp;(* Changed, &nbsp;! Killed, &nbsp;~ Newed)''']
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
DEFAULT_VARIABLE_SECTION_HEADER_LIST = ["Name", "Line Occurrences"]
LINE_TAG_PER_LINE = 10
# constants for html page
GOOGLE_ANALYTICS_JS_CODE = """
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-26757196-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
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
"""
COMMON_HEADER_PART = """
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html><head>
<meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1">
<title>OSEHRA VistA Code Documentation</title>
<link href="DoxygenStyle.css" rel="stylesheet" type="text/css">
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
"""
INDEX_HTML_PAGE_HEADER = """
<div class="header">
  <div class="headertitle">
  </div>
 <h1>VistA Cross Reference Documentation</h1>
</div>
"""
INDEX_HTML_PAGE_OSEHRA_IMAGE_PART = """
<br/>
<left>
<div class="content">
<a href="http://www.osehra.org">
<img src="http://www.osehra.org/profiles/drupal_commons/themes/commons_osehra_earth/logo.png"
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
 from the <a href="http://code.osehra.org/gitweb?p=VistA-M.git;a=summary"/>
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

# utility functions
def getGlobalHtmlFileNameByName(globalName):
    return ("Global_%s.html" %
                        normalizeGlobalName(globalName))
def getGlobalHtmlFileName(globalVar):
    if globalVar.isSubFile():
        return getFileManSubFileHtmlFileNameByName(globalVar.getFileNo())
    return getGlobalHtmlFileNameByName(globalVar.getName())
def getGlobalDisplayName(globalVar):
    if globalVar.isFileManFile():
        return "%s(#%s)" % ( globalVar.getFileManName(), globalVar.getFileNo() )
    return globalVar.getName()
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
def getRoutineHtmlFileName(routineName):
    return urllib.quote(getRoutineHtmlFileNameUnquoted(routineName))
def getRoutineHtmlFileNameUnquoted(routineName):
    return "Routine_%s.html" % routineName
def getPackageHtmlFileName(packageName):
    return urllib.quote("Package_%s.html" %
                        normalizePackageName(packageName))
def getRoutineHypeLinkByName(routineName):
    return "<a href=\"%s\">%s</a>" % (getRoutineHtmlFileName(routineName),
                                      routineName);
def getGlobalHypeLinkByName(globalName):
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileNameByName(globalName),
                                      globalName);
def getPackageHyperLinkByName(packageName):
    return "<a href=\"%s\">%s</a>" % (getPackageHtmlFileName(packageName),
                                      packageName);
def normalizePackageName(packageName):
    newName = packageName.replace(' ', '_')
    return newName.replace('-', "_")

def normalizeGlobalName(globalName):
    import base64
    return base64.urlsafe_b64encode(globalName)

def getRoutineSourceCodeFileByName(routineName,
                                   packageName,
                                   sourceDir):
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
def generateIndexBar(outputFile, inputList, archList=None):
    if (not inputList) or len(inputList) == 0:
        return
    hasArchList = archList and len(archList) == len(inputList)
    outputFile.write("<div class=\"qindex\">\n")
    for i in range(len(inputList) - 1):
        if hasArchList:
            archName = archList[i]
        else:
            archName = inputList[i]
        outputFile.write("<a class=\"qindex\" href=\"#%s\">%s</a>&nbsp;|&nbsp;\n" % (archName,
                                                                                     inputList[i]))
    if hasArchList:
        archName = archList[-1]
    else:
        archName = inputList[-1]
    outputFile.write("<a class=\"qindex\" href=\"#%s\">%s</a></div>\n" % (archName,
                                                                          inputList[-1]))
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
def getPackagePackageDependencyHyperLink(packageName,
                                         depPackageName,
                                         name,
                                         tooltip,
                                         dependency=True):
    if dependency:
        edgeLinkArch = packageName
    else:
        edgeLinkArch = depPackageName
    return "<a href=\"%s#%s\", title=\"%s\">%s</a>" % (getPackageDependencyHtmlFile(packageName,
                                                                      depPackageName),
                                         edgeLinkArch,
                                         tooltip,
                                         name)
def writeTableHeader(headerList, outputFile):
    outputFile.write("<tr>\n")
    for header in headerList:
        outputFile.write("<th class=\"IndexKey\">%s</th>\n" % header)
    outputFile.write("</tr>\n")
def writeTableData(itemRow, outputFile):
    outputFile.write("<tr>\n")
    index = 0;
    for data in itemRow:
        if index == 0:
            key = "IndexKey"
        else:
            key = "IndexValue"
        outputFile.write("<td class=\"%s\">%s</td>\n" % (key, data))
        index += 1
    outputFile.write("</tr>\n")
def writeGenericTablizedData(headerList, itemList, outputFile):
    outputFile.write("<table>\n")
    if headerList and len(headerList) > 0:
        writeTableHeader(headerList, outputFile)
    if itemList and len(itemList) > 0:
        for itemRow in itemList:
            writeTableData(itemRow, outputFile)
    outputFile.write("</table>\n")
def writeListData(listData, outputFile):
    outputFile.write(generateHtmlListData(listData))
def generateHtmlListData(listData):
    if not listData : return ""
    output = "<ul>"
    for item in listData:
        output += "<li>%s</li>" % item
    output += "</ul>"
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
    outputFile.write("<h2 align=\"left\"><a name=\"%s\">%s</a></h2>\n" % (archName,
                                                                       headerName))
def writeSubSectionHeader(headerName, outputFile):
    outputFile.write("<h3 align=\"left\">%s</h3>\n" % (headerName))
# class to generate the web page based on input
class WebPageGenerator:
    def __init__(self, crossReference, outDir, repDir, docRepDir, gitPath,
                 includeSource=False, rtnJson=None):
        self._crossRef = crossReference
        self._allPackages = crossReference.getAllPackages()
        self._allRoutines = crossReference.getAllRoutines()
        self._allGlobals = crossReference.getAllGlobals()
        self._outDir = outDir
        self._repDir = repDir
        self._docRepDir = docRepDir
        self._gitPath = gitPath
        self._header = []
        self._footer = []
        self._source_header = []
        self._hasDot = False
        self._dotPath = ""
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
    def setDotPath(self, dotPath):
        self._hasDot = True
        self._dotPath = dotPath
    def __includeHeader__(self, outputFile):
        for line in self._header:
            outputFile.write(line)
    def __includeFooter__(self, outputFile):
        for line in self._footer:
            outputFile.write(line)
    def __inlcudeSourceHeader__(self, outputFile):
        for line in self._source_header:
            outputFile.write(line)
#===============================================================================
# Template method to generate the web pages
#===============================================================================
    def generateWebPage(self):
        self.generateIndexHtmlPage()
        self.generatePackageNamespaceGlobalMappingPage()
        if self._hasDot and self._dotPath:
            self.generatePackageDependenciesGraph()
            self.generatePackageDependentsGraph()
        self.generateGlobalNameIndexPage()
        self.generateIndividualGlobalPage()
        self.generateGlobalFileNoIndexPage()
        self.generateFileManSubFileIndexPage()
        self.generatePackageIndexPage()
        self.generatePackagePackageInteractionDetail()
        self.generateIndividualPackagePage()
        self.generateRoutineRelatedPages()
        self.copyFilesToOutputDir()
#===============================================================================
# Method to generate the index.html page
#===============================================================================
    def generateIndexHtmlPage(self):
        outputFile = open(os.path.join(self._outDir, "index.html"), 'wb')
        outputFile.write(COMMON_HEADER_PART)
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
        gitCommand = "\"" + os.path.join(self._gitPath, "git") + "\"" + " rev-parse --verify HEAD"
        os.chdir(self._repDir)
        logger.debug("git Command is %s" % gitCommand)
        result = subprocess.check_output(gitCommand, shell=True)
        return result.strip()
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
        outputFile.write("<div><h1>%s</h1></div>\n" % "Package Namespace Mapping")
#        writeSectionHeader("Package Namespace Mapping", "Package Namespace Mapping", outputFile)
        # print the table header
        outputFile.write("<table>\n")
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
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Global Index List</h1>\n</div>\n</div>")
        generateIndexBar(outputFile, string.uppercase)
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
        generateIndexBar(outputFile, string.uppercase)
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
        outputFile.write("<div><h1>%s</h1></div>\n" % "All FileMan Files List Total: %d" % len(allFileManFilesList))
#        writeSectionHeader("Package Namespace Mapping", "Package Namespace Mapping", outputFile)
        # print the table header
        outputFile.write("<table>\n")
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
        outputFile.write("<div><h1>%s</h1></div>\n" % "All FileMan Sub-Files List Total: %d" % len(allSubFiles))
#        writeSectionHeader("Package Namespace Mapping", "Package Namespace Mapping", outputFile)
        # print the table header
        outputFile.write("<table>\n")
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
        indexListFileMan = ["Info", "Desc", "Directly Accessed By Routines",
                     "Accessed By FileMan Db Calls",
                     "Pointed To By FileMan Files",
                     "Pointer To FileMan Files", "Fields"]
        indexListGlobal = ["Directly Accessed By Routines"]
        for package in self._allPackages.itervalues():
            for (globalName, globalVar) in package.getAllGlobals().iteritems():
                isFileManFile = globalVar.isFileManFile()
                outputFile = open(os.path.join(self._outDir,
                                               getGlobalHtmlFileNameByName(globalName)), 'wb')
                # write the same _header file
                self.__includeHeader__(outputFile)
                # generated the qindex bar
                if isFileManFile:
                    generateIndexBar(outputFile, indexListFileMan)
                else:
                    generateIndexBar(outputFile, indexListGlobal)
                outputFile.write("<div class=\"_header\">\n")
                outputFile.write("<div class=\"headertitle\">")
                outputFile.write(("<h4>Package: %s</h4>\n</div>\n</div>"
                                   % getPackageHyperLinkByName(package.getName())))
                outputFile.write("<h1>Global: %s</h1>\n</div>\n</div><br/>\n" % globalName)
                if isFileManFile:
                    writeSectionHeader("Information", "Info", outputFile)
                    infoHeader = ["FileMan FileNo", "FileMan Filename", "Package"]
                    itemList = [[globalVar.getFileNo(),
                              globalVar.getFileManName(),
                              getPackageHyperLinkByName(package.getName())]]
                    writeGenericTablizedData(infoHeader, itemList, outputFile)
                    writeSectionHeader("Description", "Desc", outputFile)
                    writeListData(globalVar.getDescription(), outputFile)
                writeSectionHeader("Directly Accessed By Routines, Total: %d" %
                                    globalVar.getTotalNumberOfReferencedRoutines(),
                                    "Directly Accessed By Routines", outputFile)
                self.generateGlobalRoutineDependentsSection(
                                  globalVar.getAllReferencedRoutines(), outputFile)
                fileManDbCallRtns = globalVar.getFileManDbCallRoutines()
                totalNumDbCallRtns = 0
                if fileManDbCallRtns:
                    DbCallRtnsNos = [len(x) for x in
                        fileManDbCallRtns.itervalues()]
                    totalNumDbCallRtns = sum(DbCallRtnsNos)
                writeSectionHeader("Accessed By FileMan Db Calls, Total: %d" %
                                    totalNumDbCallRtns,
                                    "Accessed By FileMan Db Calls", outputFile)
                if fileManDbCallRtns:
                    self.generateGlobalRoutineDependentsSection(fileManDbCallRtns,
                        outputFile)
                if isFileManFile:
                    writeSectionHeader("Pointed To By FileMan Files, Total: %d" % globalVar.getTotalNumberOfReferredGlobals(), "Pointed To By FileMan Files", outputFile)
                    self.generateGlobalPointedToSection(globalVar, outputFile, True)
                    writeSectionHeader("Pointer To FileMan Files, Total: %d" % globalVar.getTotalNumberOfReferencedGlobals(), "Pointer To FileMan Files", outputFile)
                    self.generateGlobalPointedToSection(globalVar, outputFile, False)
                    outputFile.write("<br/>\n")
                    totalNoFields = 0
                    allFields = globalVar.getAllFileManFields()
                    if allFields: totalNoFields = len(allFields)
                    writeSectionHeader("Fields, Total: %d" % totalNoFields, "Fields", outputFile)
                    self.__generateFileManFileDetails__(globalVar, outputFile)
                # generated the index bar at the bottom
                if isFileManFile:
                    generateIndexBar(outputFile, indexListFileMan)
                else:
                    generateIndexBar(outputFile, indexListGlobal)
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
        generateIndexBar(outputFile, indexList)
        # get the root file package
        fileIter = subFile
        topDownList=[fileIter]
        while not fileIter.isRootFile():
            fileIter = fileIter.getParentFile()
            topDownList.append(fileIter)
        topDownList.reverse()
        package = fileIter.getPackage()
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write(("<h4>Package: %s</h4>\n</div>\n</div>"
                           % getPackageHyperLinkByName(package.getName())))
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
        outputFile.write("<h4>%s</h4>\n</div>\n</div><br/>\n" % linkHtmlTxt)
        outputFile.write("<h1>Sub-Field: %s</h1>\n</div>\n</div><br/>\n" % subFile.getFileNo())
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
        writeGenericTablizedData(infoHeader, itemList, outputFile)
        writeSectionHeader("Details", "Details", outputFile)
        self.__generateFileManFileDetails__(subFile, outputFile)
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
            fieldRow = [fieldNoTxt, value.getName(), location, value.getTypeName()]
            fieldDetails = ""
            if value.isSetType():
                # nice display of set members
                setIter = value.getSetMembers()
                fieldDetails = generateHtmlListData(setIter)
            elif value.isFilePointerType():
                if value.getPointedToFile():
                    fieldDetails = (getFileManFileHypeLink(value.getPointedToFile()))
            elif value.isVariablePointerType():
                fileManFiles = value.getPointedToFiles()
                for pointedToFile in fileManFiles:
                    fieldDetails += getFileManFileHypeLink(pointedToFile) + "&nbsp;&nbsp;"
            elif value.isSubFilePointerType():
                filePointer = value.getPointedToSubFile()
                if filePointer:
                    fieldDetails = getFileManSubFileHypeLinkByName(filePointer.getFileNo())
            # logic to append field extra details here
            fieldDetails += self.__generateFileManFieldPropsDetailsList__(value)
            fieldRow.append(fieldDetails)
            outputFieldsList.append(fieldRow)
        writeGenericTablizedData(fieldHeaderList, outputFieldsList, outputFile)
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
                                       outputFile, isPointedBy=True):
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
                        itemHtmlText = ("<a class=\"e2\" href=\"%s#%s\">%s</a>" %
                                       (getGlobalHtmlFileNameByName(fieldLinkGlobal.getName()),
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
        writeGenericTablizedData(infoHeader, itemList, outputFile)
#===============================================================================
#
#===============================================================================
    def generateGlobalRoutineDependentsSection(self, depRoutines,
                                               outputFile):
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
        writeGenericTablizedData(infoHeader, itemList, outputFile)
#===============================================================================
#method to generate the interactive detail list page between any two packages
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

    def _updatePackageDepDict(self, package, depDict, packDepDict):
        for depPack in depDict.iterkeys():
            fileName = getPackageDependencyHtmlFile(package.getName(),
                                                    depPack.getName())
            if fileName not in packDepDict:
                packDepDict[fileName] = (package, depPack)
#===============================================================================
# method to generate caller/called routine detail dict
#===============================================================================
    def generatePackageRoutineDetailDict(self, package, depPackage, depDict):
        depRoutinesDict = dict()
        for routine in depDict[depPackage]:
            details = routine.getCalledRoutines()[depPackage]
            for depRoutine in details.iterkeys():
                if depRoutine not in depRoutinesDict:
                    depRoutinesDict[depRoutine] = []
                depRoutinesDict[depRoutine].append(routine)
        return depRoutinesDict
#===============================================================================
# method to generate the detail of package
#===============================================================================
    def generatePackageRoutineDependencyDetailPage(self, package, depPackage, outputFile):
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
        if routineDepDict and depPackage in routineDepDict:
            callerRoutines = routineDepDict[depPackage][0]
            calledRoutines = routineDepDict[depPackage][1]
        if globalDepDict and depPackage in globalDepDict:
            referredRoutines = globalDepDict[depPackage][0]
            referredGlobals = globalDepDict[depPackage][1]
        if fileManDepDict and depPackage in fileManDepDict:
            referredFileManFiles = fileManDepDict[depPackage][0]
            referencedFileManFiles = fileManDepDict[depPackage][1]
        if dbCallDepDict and depPackage in dbCallDepDict:
            dbCallRoutines = dbCallDepDict[depPackage][0]
            dbCallFileManFiles = dbCallDepDict[depPackage][1]
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
        summaryHeader += "<BR> Total %s routine(s) in %s accesed via fileman db call to total %s fileman file(s) in %s" % (totalDbCallRoutinesHtml,
                                                                                             packageHyperLink,
                                                                                             totalDbCallFileManFilesHtml,
                                                                                             depPackageHyperLink)
        writeSubSectionHeader(summaryHeader, outputFile)
        # print out the routine details
        if len(callerRoutines) > 0:
            writeSubSectionHeader("Caller Routines List in %s : %s" % (packageHyperLink,
                                                                       totalCalledHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(callerRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName)
        if len(calledRoutines) > 0:
            writeSubSectionHeader("Called Routines List in %s : %s" % (depPackageHyperLink,
                                                                       totalCallerHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(calledRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName)
        if len(referredRoutines) > 0:
            writeSubSectionHeader("Referred Routines List in %s : %s" % (packageHyperLink,
                                                                       totalReferredRoutineHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName)
        if len(referredGlobals) > 0:
            writeSubSectionHeader("Referenced Globals List in %s : %s" % (depPackageHyperLink,
                                                                       totalReferredGlobalHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredGlobals), outputFile,
                                          getGlobalHtmlFileName)
        if len(referredFileManFiles) > 0:
            writeSubSectionHeader("Referred FileMan Files List in %s : %s" % (packageHyperLink,
                                                                       totalReferredFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referredFileManFiles), outputFile,
                                          getGlobalHtmlFileName, getGlobalDisplayName)
        if len(referencedFileManFiles) > 0:
            writeSubSectionHeader("Referenced FileMan Files List in %s : %s" % (depPackageHyperLink,
                                                                       totalReferencedFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(referencedFileManFiles), outputFile,
                                          getGlobalHtmlFileName, getGlobalDisplayName)
        if len(dbCallRoutines) > 0:
            writeSubSectionHeader("FileMan Db Call Routines List in %s : %s" % (packageHyperLink,
                                                                       totalDbCallRoutinesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(dbCallRoutines), outputFile,
                                          getRoutineHtmlFileName, self.getRoutineDisplayName)
        if len(dbCallFileManFiles) > 0:
            writeSubSectionHeader("FileMan Db Call Accessed FileMan Files List in %s : %s" % (depPackageHyperLink,
                                                                       totalDbCallFileManFilesHtml),
                                                                       outputFile)
            self.generateTablizedItemList(sorted(dbCallFileManFiles), outputFile,
                                          getGlobalHtmlFileName)
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
        generateIndexBar(outputFile, inputList, archList)
        outputFile.write("<div><h1>%s and %s Interaction Details</h1></div>\n" %
                         (packageHyperLink, depPackageHyperLink))
        #generate the summary part.
        self.generatePackageRoutineDependencyDetailPage(package, depPackage, outputFile)
        self.generatePackageRoutineDependencyDetailPage(depPackage, package, outputFile)
        generateIndexBar(outputFile, inputList, archList)
        self.__includeFooter__(outputFile)
        outputFile.close()

#===============================================================================
# Method to parse the source code and generate source code page or just extract comments
#===============================================================================
    def __generateSourceCodePageByName__(self, sourceCodeName, routine, justComment):
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
            self.__inlcudeSourceHeader__(outputFile)
            outputFile.write("<div><h1>%s.m</h1></div>\n" % sourceCodeName)
            outputFile.write("<a href=\"%s\">Go to the documentation of this file.</a>" %
                             getRoutineHtmlFileName(routineName))
            outputFile.write("<xmp class=\"prettyprint lang-mumps linenums:1\">")
        lineNo = 0
        for line in sourceFile:
            if lineNo <= 1:
                routine.addComment(line)
            if justComment and lineNo > 1:
                break
            if not justComment:
                outputFile.write(line)
            lineNo += 1
        sourceFile.close()
        if not justComment:
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
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Routine Index List</h1>\n</div>\n</div>")
        indexList = [char for char in string.uppercase]
        indexList.insert(0, "%")
        indexSet = sorted(set(indexList))
        generateIndexBar(outputFile, indexList)
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
        generateIndexBar(outputFile, indexList)
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
        outputName = os.path.join(dirName, normalizedName + packageSuffix + ".gif")
        outputmap = os.path.join(dirName, normalizedName + packageSuffix + ".cmapx")
        inputName = os.path.join(dirName, normalizedName + packageSuffix + ".dot")
        # this is to generated the image in gif format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        command = "\"%s\" -Tgif -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (os.path.join(self._dotPath, "dot"),
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
    def generateRoutineRelatedPages(self):
        self.generateRoutineIndexPage()
        if self._hasDot and self._dotPath:
            self.generateRoutineCallGraph()
            self.generateRoutineCallerGraph()
        self.generateAllSourceCodePage(not self._includeSource)
        self.generateAllIndividualRoutinePage()
#===============================================================================
#
#===============================================================================
    def copyFilesToOutputDir(self):
       cssFile = os.path.join(os.path.abspath(self._docRepDir),
                              "Web/DoxygenStyle.css")
       import shutil
       shutil.copy(cssFile, self._outDir)
#===============================================================================
#
#===============================================================================
    def generateRoutineCallGraph(self, isCalled=True):
        logger.info("Start generating call graph......")
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
        outputName = os.path.join(dirName, routineName + routineSuffix + ".gif")
        outputmap = os.path.join(dirName, routineName + routineSuffix + ".cmapx")
        inputName = os.path.join(dirName, routineName + routineSuffix + ".dot")
        # this is to generated the image in gif format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        # @TODO this should be able to run in parallel
        command = "\"%s\" -Tgif -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (os.path.join(self._dotPath, "dot"),
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
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>Package List</h1>\n</div>\n</div>")
        generateIndexBar(outputFile, string.uppercase)
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
        generateIndexBar(outputFile, string.uppercase)
        self.__includeFooter__(outputFile)
        outputFile.close()
#=======================================================================
# Method to generate package dependency/dependent section infp
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
        fileNamePrefix = normalizePackageName(packageName) + packageSuffix
        # write the image of the dependency graph
        writeSectionHeader(sectionGraphHeader, sectionGraphHeader, outputFile)
        try:
            cmapFile = open(os.path.join(self._outDir, packageName + "/" + fileNamePrefix + ".cmapx"), 'r')
            outputFile.write("<div class=\"contents\">\n")
            outputFile.write("<img src=\"%s\" border=\"0\" alt=\"Call Graph\" usemap=\"#%s\"/>\n"
                       % (packageName + "/" + fileNamePrefix + ".gif", fileNamePrefix))
            #append the content of map outputFile
            for line in cmapFile:
                outputFile.write(line)
            outputFile.write("</div>\n")
        except IOError:
            pass
        # write the list of the package dependency list
        package = self._allPackages[packageName]
        depPackages, depPackagesMerged = self.__mergeAndSortDependencyListByPackage__(
                                                                    package,
                                                                    isDependencyList)
        totalPackages = 0
        if depPackages:
            totalPackages = len(depPackages)
        writeSectionHeader("%s Total: %d " % (sectionListHeader, totalPackages),
                           sectionListHeader,
                           outputFile)
        outputFile.write("""<h4>Format:&nbsp;&nbsp;
                            package[# of caller routines(R):
                            # of global accessing routines(G):
                            # of fileman file references(F):
                            # of fileman db call reference(D)]
                            </h4><BR>\n""")
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
                        outputFile.write("<td class=\"indexkey\"><a class=\"e1\" href=\"%s\">%s</a> [%s]&nbsp;&nbsp;&nbsp</td>"
                                   % (getPackageHtmlFileName(depPackageName), depPackageName, depHyperLink))
                outputFile.write("</tr>\n")
            outputFile.write("</table></div>\n")
#===============================================================================
# method to generate a tablized representation of data
#===============================================================================
    def generateTablizedItemList(self, sortedItemList, outputFile, htmlMappingFunc,
                                 nameFunc=None, totalCol=8):
        totalNumRoutine = 0
        if sortedItemList:
            totalNumRoutine = len(sortedItemList)
        numOfRow = totalNumRoutine / totalCol + 1
        if totalNumRoutine > 0:
            outputFile.write("<div class=\"contents\"><table>\n")
            for index in range(numOfRow):
                outputFile.write("<tr>")
                for i in range(totalCol):
                    position = index * totalCol + i
                    if position < totalNumRoutine:
                        displayName = sortedItemList[position]
                        if nameFunc: displayName = nameFunc(displayName)
                        outputFile.write("<td class=\"indexkey\"><a class=\"e1\" href=\"%s\">%s</a>&nbsp;&nbsp;&nbsp;&nbsp;</td>"
                                   % (htmlMappingFunc(sortedItemList[position]),
                                      displayName))
                outputFile.write("</tr>\n")
            outputFile.write("</table>\n</div>\n<br/>")
#===============================================================================
# method to generate individual package page
#===============================================================================
    def generateIndividualPackagePage(self):
        indexList = ["Namespace", "Doc", "Dependency Graph",
                     "Package Dependency List", "Dependent Graph",
                     "Package Dependent List", "FileMan Files",
                     "Non-FileMan Globals", "All Routines"]
        for packageName in self._allPackages.iterkeys():
            package = self._allPackages[packageName]
            outputFile = open(os.path.join(self._outDir, getPackageHtmlFileName(packageName)), 'w')
            #write the _header part
            self.__includeHeader__(outputFile)
            generateIndexBar(outputFile, indexList)
            outputFile.write("<div class=\"_header\">\n")
            outputFile.write("<div class=\"headertitle\">")
            outputFile.write("<h1>Package: %s</h1>\n</div>\n</div>" % packageName)
            # Namespace
            writeSectionHeader("Namespace", "Namespace", outputFile)
            outputFile.write("<p><h4>Namespace: %s" % listDataToCommaSeperatorString(package.getNamespaces()))
            globalNamespaces = package.getGlobalNamespace()
            if globalNamespaces and len(globalNamespaces) > 0:
                outputFile.write("&nbsp;&nbsp;Additional Global Namespace: %s</h4>" % listDataToCommaSeperatorString(globalNamespaces))
            else:
                outputFile.write("</h4>")
            # link to VA documentation
            writeSectionHeader("Documentation", "Doc", outputFile)
            if len(package.getDocLink()) > 0:
                outputFile.write("<p><h4>VA documentation in the <a href=\"%s\">VistA Documentation Library</a>" % package.getDocLink())
                if len(package.getDocMirrorLink()) > 0:
                    outputFile.write("&nbsp;or&nbsp;<a href=\"%s\">OSEHRA Mirror site</a></h4>\n" % package.getDocMirrorLink())
                else:
                    outputFile.write("</h4>\n")
            else:
                outputFile.write("<p><h4><a href=\"http://www.va.gov/vdl/\">VA documentation in the VistA Documentation Library</a></h4>\n")
            self.generatePackageDependencySection(packageName, outputFile, True)
            self.generatePackageDependencySection(packageName, outputFile, False)
            # seperate fileman files and non-fileman globals
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
                                          getGlobalDisplayName)
            # section of All Non-FileMan Globals
            writeSectionHeader("Non FileMan Globals Total: %d" % len(globalList),
                               "Non-FileMan Globals",
                               outputFile)
            sortedGlobalList = sorted(globalList, key=lambda item: item.getName()) # sorted by global Name
            self.generateTablizedItemList(sortedGlobalList, outputFile,
                                          getGlobalHtmlFileName,
                                          getGlobalDisplayName)
            # section of all routines
            sortedRoutines = sorted(package.getAllRoutines().keys())
            totalNumRoutine = len(sortedRoutines)
            writeSectionHeader("All Routines Total: %d" % totalNumRoutine,
                               "All Routines",
                               outputFile)
            self.generateTablizedItemList(sortedRoutines, outputFile,
                                          getRoutineHtmlFileName,
                                          self.getRoutineDisplayNameByName,
                                          8)
            generateIndexBar(outputFile, indexList)
            self.__includeFooter__(outputFile)
            outputFile.close()
#===============================================================================
# method to generate Routine Dependency and Dependents page
#===============================================================================
    def generateRoutineDependencySection(self, routine, outputFile, dependencyList=True):
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if dependencyList:
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
                                             outputFile, dependencyList)
        self.__writeRoutineDepListSection__(routine, depRoutines,
                                            sectionListHeader,
                                            sectionListHeader,
                                            outputFile, dependencyList)
#===============================================================================
# Method to generate routine variables sections such as Local Variables, Global Variables
#===============================================================================
    def generateRoutineVariableSection(self, outputFile, sectionTitle, headerList, variables,
                                       converFunc):
        writeSectionHeader(sectionTitle, sectionTitle, outputFile)
        outputList = converFunc(variables)
        writeGenericTablizedData(headerList, outputList, outputFile)
    def __getDataEntryDetailHtmlLink__(self, fileNo, ien):
      return ("http://code.osehra.org/ProdDemo/Visual/files/%s-%s.html" % (fileNo,
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
    def __convertVariableToTableData__(self, variables, isGlobal = False):
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
    def __convertLableReferenceToTableData__(self, variables):
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
# Method to generate individual routine page
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
    def __writeRoutineInfoSection__(self, routine, data, header, link, outputFile):
        writeSectionHeader(header, link, outputFile)
        for comment in data:
            outputFile.write("<p><span class=\"information\">%s</span></p>\n" % comment)
    def __writeRoutineSourceSection__(self, routine, data, header, link, outputFile):
        writeSectionHeader(header, link, outputFile)
        outputFile.write("<p><span class=\"information\">Source file &lt;<a class=\"el\" href=\"%s\">%s.m</a>&gt;</span></p>\n" %
                         (getRoutineSourceHtmlFileName(routine.getOriginalName()),
                          routine.getOriginalName()))
    def __writeRoutineVariableSection__(self, routine, data, header, link,
                                        outputFile, tableHeader, convFunc):
        self.generateRoutineVariableSection(outputFile, header,
                                            tableHeader, data, convFunc)
    def __writeRoutineDepGraphSection__(self, routine, data, header, link,
                                        outputFile, isDependency=True):
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
        if not os.path.exists(fileName):
          logging.warn("Can not find file %s" % fileName)
          return
        outputFile.write("<div class=\"contents\">\n")
        outputFile.write("<img src=\"%s\" border=\"0\" alt=\"%s\" usemap=\"#%s\"/>\n"
                   % (urllib.quote(packageName + "/" + fileNamePrefix + ".gif"),
                      header,
                      fileNamePrefix))
        #append the content of map outputFile
        with open(fileName, 'r') as cmapFile:
          for line in cmapFile:
              outputFile.write(line)
        outputFile.write("</div>\n")
    def __writeRoutineDepListSection__(self, routine, data, header, link,
                                       outputFile, isDependency=True):
      if isDependency:
          totalNum = routine.getTotalCalled()
      else:
          totalNum = routine.getTotalCaller()
      writeSectionHeader("%s Total: %d" % (header, totalNum),
                         header,
                         outputFile)
      outputFile.write("<div class=\"contents\"><table>\n")
      outputFile.write("<tr><th class=\"indexkey\">Package</th>")
      outputFile.write("<th class=\"indexvalue\">Total</th>")
      outputFile.write("<th class=\"indexvalue\">%s</th></tr>\n" % header)
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
#                            allTags = filter(len, depRoutines[depPackage][depRoutine].iterkeys())
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
          outputFile.write("<tr><td class=\"indexkey\">%s</td><td class=\"indexvalue\">%d</td><td class=\"indexvalue\">%s</td></tr>\n"
                     % (routinePackageLink, len(data[depPackage]), routineNameLink))
      outputFile.write("</table>\n</div>\n")
    def __generateIndividualRoutinePage__(self, routine, platform=None):
        assert routine
        routineName = routine.getName()
        """ This is a list sections that might be applicable to a routine
        """
        sectionGenLst = [
           # Name section
           {
             "name": "Info", # this is also the link name
             "header" : "Information", # this is the actual display name
             "data" : routine.getComment, # the data source
             "generator" : self.__writeRoutineInfoSection__, # section generator
           },
           # Source section
           {
             "name": "Source", # this is also the link name
             "header" : "Source Code", # this is the actual display name
             "data" : routine.hasSourceCode, # the data source
             "generator" : self.__writeRoutineSourceSection__, # section generator
           },
           # Call Graph section
           {
             "name": "Call Graph", # this is also the link name
             "data" : routine.getCalledRoutines, # the data source
             "generator" : self.__writeRoutineDepGraphSection__, # section generator
           },
           # Called Routines section
           {
             "name": "Called Routines", # this is also the link name
             "data" : routine.getCalledRoutines, # the data source
             "generator" : self.__writeRoutineDepListSection__, # section generator
           },
           # Caller Graph section
           {
             "name": "Caller Graph", # this is also the link name
             "data" : routine.getCallerRoutines, # the data source
             "generator" : self.__writeRoutineDepGraphSection__, # section generator
             "geneargs" : [False],
           },
           # Caller Routines section
           {
             "name": "Caller Routines", # this is also the link name
             "data" : routine.getCallerRoutines, # the data source
             "generator" : self.__writeRoutineDepListSection__, # section generator
             "geneargs" : [False],
           },
           # Used in RPC section
           {
             "name": "Used in RPC", # this is also the link name
             "data" : self.__getRpcReferences__, # the data source
             "dataarg" : [routineName], # extra arguments for data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [RPC_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertRPCDataReference__], # extra argument
           },
           # Used in HL7 Interface section
           {
             "name": "Used in HL7 Interface", # this is also the link name
             "data" : self.__getHl7References__, # the data source
             "dataarg" : [routineName], # extra arguments for data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [HL7_REFERENCE_SECTION_HEADER_LIST,
                           self.__convertHL7DataReference__], # extra argument
           },
           # FileMan Files Accessed Via FileMan Db Call section
           {
             "name": "FileMan Files Accessed Via FileMan Db Call", # this is also the link name
             "data" : routine.getFilemanDbCallGlobals, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [FILENO_FILEMANDB_SECTION_HEADER_LIST,
                           self.__convertFileManDbCallToTableData__], # extra argument
           },
           # Global Variables Directly Accessed section
           {
             "name": "Global Variables Directly Accessed", # this is also the link name
             "data" : routine.getGlobalVariables, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [GLOBAL_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertGlobalVarToTableData__], # extra argument
           },
           # External References section
           {
             "name": "External References", # this is also the link name
             "data" : routine.getExternalReference, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertExternalReferenceToTableData__], # extra argument
           },
           # Label References section
           {
             "name": "Label References", # this is also the link name
             "data" : routine.getLabelReferences, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertLableReferenceToTableData__], # extra argument
           },
           # Naked Globals section
           {
             "name": "Naked Globals", # this is also the link name
             "data" : routine.getNakedGlobals, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertNakedGlobaToTableData__], # extra argument
           },
           # Local Variables section
           {
             "name": "Local Variables", # this is also the link name
             "data" : routine.getLocalVariables, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertVariableToTableData__], # extra argument
           },
           # Marked Items section
           {
             "name": "Marked Items", # this is also the link name
             "data" : routine.getMarkedItems, # the data source
             "generator" : self.__writeRoutineVariableSection__, # section generator
             "geneargs" : [DEFAULT_VARIABLE_SECTION_HEADER_LIST,
                           self.__convertMarkedItemToTableData__], # extra argument
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
        generateIndexBar(outputFile, indexList)
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h4>Package: %s</h4>\n</div>\n</div>" % getPackageHyperLinkByName(package.getName()))
        routineHeader = "Routine: %s " % routineName
        if platform:
            routineHeader += "Platform: %s" % platform
        outputFile.write("<h1>%s</h1>\n</div>\n</div><br/>\n" % routineHeader)
        for idx in idxLst:
          sectionGen = sectionGenLst[idx]
          data = sectionGen['data'](*sectionGen.get('dataarg',[]))
          link = sectionGen['name']
          header = sectionGen.get('header', link)
          geneargs = sectionGen.get('geneargs',[])
          sectionGen['generator'](routine, data, header, link, outputFile, *geneargs)
        outputFile.write("<br/>\n")
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
        generateIndexBar(outputFile, indexList)
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h4>Package: %s</h4>\n</div>\n</div>" % getPackageHyperLinkByName(package.getName()))
        outputFile.write("<h1>Routine: %s</h1>\n</div>\n</div><br/>\n" % routineName)
        writeSectionHeader("Platform Dependent Routines", "DepRoutines", outputFile)
        # output the Platform part.
        tableRowList = []
        for routineInfo in platformDepRoutines.itervalues():
            tableRowList.append([getRoutineHypeLinkByName(routineInfo[0].getName()), routineInfo[1]])
        writeGenericTablizedData(["Routine", "Platform"], tableRowList, outputFile)
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

def testGenerateIndexBar(inputList, outputFile):
    outputFile = open(outputFile, 'w')
    outputFile.write("<html><head>Test</head><body>\n")
    generateIndexBar(outputFile, inputList)
    outputFile.write("</body></html>")
    outputFile.close()

#test to play around the Dot
def testDotCall(outputDir):
    packageName = "Nursing Service"
    routineName = "NURA6F1"
    dirName = os.path.join(outputDir, packageName);
    outputName = os.path.join(dirName, routineName + ".svg")
    inputName = os.path.join(dirName, routineName + ".dot")
    command = "dot -Tsvg -o \"%s\" \"%s\"" % (outputName, inputName)
    logger.info ("command is [%s]" % command)
    retCode = subprocess.call(command)
    logger.info ("calling dot returns %d" % retCode)

# Get the lastest git SHA1 Key from git repository
def testGetGitLastRev(GitRepoDir, gitPath):
    gitCommand = "\"" + os.path.join(gitPath + "git") + "\"" + " rev-parse --verify HEAD"
    os.chdir(GitRepoDir)
    result = subprocess.check_output(gitCommand, shell=True)
    print result.strip()

# test parsing package.csv file from VistA-M release
def testPackageCsvParser(packageFile):
    csvFile = open(packageFile, 'rb')
    sniffer = csv.Sniffer()
    dialect = sniffer.sniff(csvFile.read(1024))
    csvFile.seek(0)
    hasHeader = sniffer.has_header(csvFile.read(1024))
    logger.info ("hasHeader: %s" % hasHeader)
    csvFile.seek(0)
    reader = csv.reader(csvFile, dialect)
    for line in reader:
        print line

# constants
DEFAULT_OUTPUT_LOG_FILE_NAME = "WebPageGen.log"

import tempfile
def getTempLogFile():
    return os.path.join(tempfile.gettempdir(), DEFAULT_OUTPUT_LOG_FILE_NAME)

def initLogging(outputFileName):
    logger.setLevel(logging.DEBUG)
    fileHandle = logging.FileHandler(outputFileName, 'w')
    fileHandle.setLevel(logging.DEBUG)
    formatStr = '%(asctime)s %(levelname)s %(message)s'
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
if __name__ == '__main__':
    crossRefArgParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
        description='VistA Visual Cross-Reference Documentation Generator',
        parents=[crossRefArgParse])
    parser.add_argument('-o', '--outputDir', required=True,
                        help='Output Web Page dirctory')
    parser.add_argument('-gp', '--gitPath', required=True,
                        help='Path to the folder containing git excecutable')
    parser.add_argument('-hd', '--hasDot', required=False, default="False",
                        action='store_true', help='is Dot installed')
    parser.add_argument('-dp', '--dotPath', required=False,
                        help='path to the folder containing dot excecutable')
    parser.add_argument('-is', '--includeSource', required=False,
                        default=False, action='store_true',
                        help='generate routine source code page?')
    parser.add_argument('-lf', '--outputLogFileName', required=False,
                        help='the output Logging file')
    parser.add_argument('-rj','--rtnJson', help='routine reference in VistA '
        'Data file in JSON format')
    result = parser.parse_args();
    if not result.outputLogFileName:
        outputLogFile = getTempLogFile()
    else:
        outputLogFile = result.outputLogFileName
    initLogging(outputLogFile)
    logger.debug (result)
    crossRef = CrossReferenceBuilder().buildCrossReferenceWithArgs(result)
    logger.info ("Starting generating web pages....")
    doxDir = os.path.join(result.patchRepositDir, 'Utilities/Dox')
    webPageGen = WebPageGenerator(crossRef,
                                  result.outputDir,
                                  result.MRepositDir,
                                  doxDir,
                                  result.gitPath,
                                  result.includeSource,
                                  result.rtnJson)
    if result.hasDot and result.dotPath:
        webPageGen.setDotPath(result.dotPath)
    webPageGen.generateWebPage()
    logger.info ("End of generating web pages....")
