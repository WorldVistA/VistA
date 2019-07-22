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
import json
import os
import os.path
import re
import shutil
import string
import urllib
import cgi

from operator import itemgetter
from LogManager import logger, initLogging

from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, KeepTogether
from reportlab.platypus import Table, TableStyle, Image
from reportlab.platypus import ListFlowable, ListItem
from reportlab.lib.pagesizes import landscape, letter, inch
from reportlab.lib import colors
import io
import PIL

from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser
from CrossReference import *

from HTMLUtilityFunctions import FOOTER
from UtilityFunctions import *

# constants
DEFAULT_OUTPUT_LOG_FILE_NAME = "WebPageGen.log"

COMPONENT_TYPE_DICT = {
  "action" : "A",
  "extended action" : "Ea",
  "event driver" : "Ed",
  "subscriber" : "Su",
  "protocol" : "O",
  "limited protocol" : "LP",

  # Option Values
  "run routine":"RR",
  "broker":"B",
  "edit":"E",
  "server":"Se",
  "print":"P",
  "screenman":"SM",
  "inquire":"I"
}

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
PACKAGE_OBJECT_SECTION_HEADER_LIST = ["Name", "Field # of Occurrence",]

LINE_TAG_PER_LINE = 10

VIVIAN_URL = None
DOX_URL = None

ENTRY_POINT = re.compile("^[A-Z0-9]+[(]?")
# Complicated regex to avoid 'catastropic backtracking'
# https://www.regular-expressions.info/catastrophic.html
# https://stackoverflow.com/questions/13577372/do-python-regular-expressions-have-an-equivalent-to-rubys-atomic-grouping
#
routineCall = re.compile(r'(?:D(?= )|[G,$])(?::\S+)* ?(?P<entry>\w*)?(?:\^?(?P<rtn>(?<=\^)[%A-Za-z0-9]*)?)')  # re.compile("[DG] (?P<entry>[A-Za-z0-9]+)?\^(?P<rtn>.+)\b")
routineCallExpanded = re.compile(r'(?:DO|GOTO|\$) ?(?P<entry>[A-Za-z0-9]+)?(?:\^(?P<rtn>(?<=\^)[%A-Za-z0-9]+)?)?')  # re.compile("[DG] (?P<entry>[A-Za-z0-9]+)?\^(?P<rtn>.+)\b")
COMMENT  = re.compile("^ ; ")
READ_CMD = re.compile(" R (?P<params>.+?):(?! )(?P<timeout>.+?) ")
WRITE_CMD = re.compile(" W (?P<string>.+?)\s")

SPLITVAL = re.compile("^[0-9.]+(?P<splitval>DATA|XRF|HELP)[0-9]*")
DATA_URL_DICT = {
  "DATA": "(IEN:<a href=\"%s\">%s</a>)",
  "XRF": "(XREF %s)",
  "HELP": "(HELP %s)"
}

CONDITIONAL = re.compile("^W(?!\w)($|(?P<conditional>\:.+)?)")
SPLIT_LINE = re.compile(''' (?=(?:[^'"]|'[^']*'|"[^"]*")*$)''')

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
<a href="index.html" class="qindex" id="home">Home</a>&nbsp;&nbsp;
<a href="packages.html" class="qindex" id="package_list">Package List</a>&nbsp;&nbsp;
<a href="routines.html" class="qindex" id="routine_list">Routine Alphabetical List</a>&nbsp;&nbsp;
<a href="globals.html" class="qindex" id="global_list">Global Alphabetical List</a>&nbsp;&nbsp;
<a href="filemanfiles.html" class="qindex" id="fileman_files_list">FileMan Files List</a>&nbsp;&nbsp;
<a href="filemansubfiles.html" class="qindex" id="fileman_subfiles_list">FileMan Sub-Files List</a>&nbsp;&nbsp;
<a href="PackageComponents.html" class="qindex" id="package_component_list">Package Component Lists</a>&nbsp;&nbsp;
<a href="Packages_Namespace_Mapping.html" class="qindex" id="package_namespace_mapping">
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
  </div>
"""

PC_LEGEND = """
  <div>
    <h4>Package Component Superscript legend</h4>
    <table>
      <tbody>
        <tr>
        """
for key, value in COMPONENT_TYPE_DICT.iteritems():
  PC_LEGEND += """ <td class="IndexKey"> %s </td>
          <td class="IndexValue"> <sup>%s</sup> </td>
          """ % (key, value)
PC_LEGEND += """
        </tr>
      </tbody>
    </table>
    <br/>
  </div>
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

# Note: This should ALWAYS be called, even when not generating PDF bundle
def writePDFCustomization(outputFile, titleList):
  outputFile.write("<script>initTitleList=%s\n" % str(titleList))
  outputFile.write(" initTitleList.forEach(function(obj) {\n")
  outputFile.write('''   if (obj == "Doc") {return }\n''');
  outputFile.write('''   $("#pdfSelection").append('<input class="headerVal" type="checkbox" val="'+obj+'" checked>'+obj+'</input>')\n''');
  outputFile.write('''   $("#pdfSelection").append('<br/>')\n''');
  outputFile.write(" })\n")
  outputFile.write("</script>\n")

OPEN_ACCORDION_FUNCTION = """
    <script type='text/javascript'>
        function openAccordionVal(event) {
          if ($(".sectionHeader").length > 5) {
            $('.accordion').accordion( {active:false, collapsible:true });
            classVal = ".accordion"
            if (event.target.classList[1] != "Allaccord") {
              classVal= classVal+"."+event.target.classList[1]
            }
            $(classVal).accordion( 'option', 'active',0 );
          }
        }
    </script>

"""

ACCORDION =  """
    <script type='text/javascript'>
       function locationHashChanged() {
           locationString = window.location.hash.substring(1)
           $("td[name='"+locationString+"']").closest(".accordion").accordion({ activate: function(event, ui) {
               window.location = window.location.hash
           }});
           $("[name='"+locationString+"']").closest(".accordion").accordion( 'option', 'active',0 );
           var scrollPos = $("a[name='"+locationString+"']").closest("td").offset().top;
           $("html, body").animate({ scrollTop: scrollPos }, 1000);
       }
       $( document ).ready(function() {
           if ($(".sectionHeader").length > 5) {
               $( '.accordion' ).accordion({
                   heightStyle: "content",
                   collapsible: true,
                   active: false
               })
           }
          if(window.location.hash) {
               locationHashChanged()
          }
          window.onhashchange = locationHashChanged
       })
    </script>
  """

def findRelevantIndex(sectionGenLst, existingOutFile):
  indexList = []
  idxLst = []
  for idx, item in enumerate(sectionGenLst):
    if existingOutFile and (idx < 5):
      continue
    extraarg = item.get('dataarg', [])
    if item['data'](*extraarg):
      indexList.append(item['name'])
      idxLst.append(idx)
  return indexList,idxLst

def getICRHtmlFileName(icrEntry):
    return ("%s/ICR/ICR-%s.html" % (VIVIAN_URL, icrEntry["NUMBER"]))

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

def getFileManSubFileHypeLinkByName(subFileNo):
    return "<a href=\"%s\">%s</a>" % (getFileManSubFileHtmlFileNameByName(subFileNo),
                                      subFileNo)
def getFileManSubFileHypeLinkWithName(subFile):
    return ("<a href=\"%s\">%s</a>" %
            (getFileManSubFileHtmlFileName(subFile),
                                      subFile.getFileManName()))

def getRoutineHypeLinkByName(routineName):
    return "<a href=\"%s\">%s</a>" % (getRoutineLink(routineName),
                                      routineName)

def getGlobalHypeLinkByName(globalName):
    return "<a href=\"%s\">%s</a>" % (getGlobalHtmlFileNameByName(globalName),
                                      globalName)

def getPackageHyperLinkByName(packageName):
    if packageName in PACKAGE_MAP:
      packageName = PACKAGE_MAP[packageName]
    return "<a href=\"%s\">%s</a>" % (getPackageHtmlFileName(packageName),
                                      packageName)

def getRoutineSourceCodeFileByName(routineName, packageName, sourceDir):
    return os.path.join(sourceDir, "Packages" +
                        os.path.sep + packageName +
                        os.path.sep + "Routines" +
                        os.path.sep +
                        routineName + ".m")

def getPackagePackageDependencyHyperLink(packageName, depPackageName, name,
                                         tooltip, dependency):
    if dependency:
        edgeLinkArch = packageName
    else:
        edgeLinkArch = depPackageName
    packageDependencyHtmlFile = getPackageDependencyHtmlFileName(packageName, depPackageName)
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

def writeTableRow(itemRow, outputFile, rowClassId=None, firstColumnKey=False):
    if rowClassId is None:
        outputFile.write("<tr>\n")
    else:
        outputFile.write("<tr class=\"%s\" >\n" % rowClassId)
    for index, data in enumerate(itemRow):
        if firstColumnKey and index == 0:
            key = "IndexKey"
        else:
            key = "IndexValue"
        outputFile.write("<td class=\"%s\">%s</td>\n" % (key, data))
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

def writeSectionBegin(outputFile):
    outputFile.write("<div>\n")

def writeSectionEnd(outputFile):
    outputFile.write("</div>\n")

def writeSubSectionHeader(headerName, outputFile, classid=""):
    outputFile.write("<h3 class=\"%s\"align=\"left\">%s</h3>\n" % (classid, headerName))

#------------------------------------------------------------------------------
# PDF helper functions
#------------------------------------------------------------------------------
def generatePDFTableRow(data):
    row = []
    for val in data:
        row.append(generateParagraph(val))
    return row

def generateParagraph(text):
    try:
        if text is None: text = ""
        return Paragraph(text, styles['Heading6'])
    except UnicodeDecodeError as e:
        logger.warning("Failed to write to PDF:")
        logger.warning(text)
        logger.warning(e)
        return Paragraph(unicode(text, errors='ignore'), styles['Heading6'])

def generatePDFListData(listData):
    if not listData:
        return generateParagraph("")
    list = []
    for item in listData:
        list.append(ListItem(generateParagraph(item),leftIndent=7))
    return generateList(list)

def generateList(data):
    # Note: start is required when using `bullet` bulletType
    # (even though it's not explicitly mentioned in documentation)
    # TODO: Bullets need to be closer to text and indented
    return ListFlowable(data,
                        bulletType='bullet',
                        start='circle',
                        bulletFontSize=6,
                        leftIndent=7)

###############################################################################
# class to generate the web page based on input
class WebPageGenerator:
    def __init__(self, crossReference, outDir, pdfOutDir, repDir, docRepDir,
                 rtnJson, repoJson, generatePDF):
        self._crossRef = crossReference
        self._allPackages = crossReference.getAllPackages()
        self._allRoutines = crossReference.getAllRoutines()
        self._allGlobals = crossReference.getAllGlobals()
        self._outDir = outDir
        self._pdfOutDir = pdfOutDir
        if not os.path.exists(self._pdfOutDir):
            os.mkdir(self._pdfOutDir)
        self._repDir = repDir
        self._docRepDir = docRepDir
        self._header = self.__generateHtmlPageHeader__(isSource=False)
        self._source_header = self.__generateHtmlPageHeader__(isSource=True)
        with open(rtnJson, 'r') as jsonFile:
            self._rtnRefJson = json.load(jsonFile)
        with open(repoJson, 'r') as jsonFile:
            self._repoJson = json.load(jsonFile)
        self._generatePDFBundle = generatePDF
        self.__generateLegend__()


    def __includeHeader__(self, outputFile, indexList=""):
        for line in (self._header):
            outputFile.write(line)

    def __includeSourceHeader__(self, outputFile):
        for line in self._source_header:
            outputFile.write(line)

    def __getPDFDirectory__(self, packageName):
        dir = os.path.join(self._pdfOutDir, normalizePackageName(packageName))
        if not os.path.exists(dir):
            os.mkdir(dir)
        return dir

    def __setupPDF__(self, isLandscape=False):
      # Setup the pdf document
      self.buf = io.BytesIO()
      if isLandscape:
        pagesize = letter
      else:
        pagesize = landscape(letter)
      self.doc = SimpleDocTemplate(self.buf,
                                   rightMargin=inch/2,
                                   leftMargin=inch/2,
                                   topMargin=inch/2,
                                   bottomMargin=inch/2,
                                   pagesize=pagesize,
                                  )

    def __writePDFFile__(self, pdf, pdfFileName):
      try:
        # Write the PDF to a file
        self.doc.build(pdf)
        with open(pdfFileName, 'w') as fd:
          fd.write(self.buf.getvalue())
      except:
        self.failures.append(pdfFileName)
        pass

    def __generateLegend__(self):
      self.legend = "<h3>Legends:</h3>"
      self.legend += "<div class=\"contents colorLegendGrp\">\n"
      self.legend += "<img id=\"colorLegendImg\"src=\"%s\" border=\"0\" alt=\"%s\" usemap=\"caller_colors\"/>\n" % (urllib.quote("colorLegend.png"),"Legend of Colors")
      cmapFile = open(os.path.join(self._outDir, "colorLegend.cmapx"), 'r')
      for line in cmapFile:
          self.legend += line
      self.legend += PC_LEGEND.replace("<td class=\"","<td class=\"colorLegend ")
      self.legend += "</div>\n"

# -----------------------------------------------------------------------------
# Generate page-specific navigation bar for *most* DOX pages. Allows navigation
# to specific items and/or sections. Generally, each page will have two
# page-specific navigation bars:
#   * header: directly below the global navigation bar.
#   * footer: following all page-specific content
#
# There are three types of page-specific navigation bars:
#   1. Index Header (no Print or All buttons; no 'open accordion' function)
#   2. Non-Index header
#     2a. Package headers also include a 'PDF' button, if generating PDFs
#   3. Non-Index footer (no Print buttons or open accordion function)
# -----------------------------------------------------------------------------
    def generateNavigationBar(self, outputFile, inputList, archList=None,
                              printButton=True, printList=None,
                              packageName=None, isIndex=False):
        if not inputList:
            return
        if isIndex:
            printButton = False
        else:
            outputFile.write(OPEN_ACCORDION_FUNCTION)
        hasArchList = archList and len(archList) == len(inputList)
        if isIndex:
            onClickOpenAccordion = ""
        else:
            onClickOpenAccordion = "onclick=\"openAccordionVal(event)\""
        outputFile.write("<div class=\"qindex\">\n")
        for i in range(len(inputList)):
            if hasArchList:
                archName = archList[i]
            else:
                archName = inputList[i]
            outputFile.write("<a %s class=\"qindex %s\" href=\"#%s\">%s</a>&nbsp;|&nbsp;\n" %
                (onClickOpenAccordion, archName.split(" ")[0], archName, inputList[i]))
        if not isIndex:
            outputFile.write("<a %s class=\"qindex Allaccord\" href=\"#%s\">%s</a>\n" %
                (onClickOpenAccordion, "All","All"))
        outputFile.write("</div>\n")
        if printButton:
            outputFile.write("<div class=\"qindex\">\n")
            outputFile.write("<a onclick=\"startWritePDF(event)\" \
                             class=\"qindex printPage\" href=\"#Print\">Print Page as PDF</a>")
            if packageName and self._generatePDFBundle:
                # Note: Do NOT use os.path.join, want a "/" even if path is
                # generated on Windows
                # TODO: This is hardcoded to the path (currently) set in
                # CMakeLists
                pdfZipFilename = "PDF/" + normalizePackageName(packageName) + ".zip"
                outputFile.write("&nbsp;|&nbsp;")
                outputFile.write("<a onclick=\"startDownloadPDFBundle('%s')\" \
                                 class=\"qindex printAll\" href=\"#PrintAll\">Print All `%s` Pages as PDF</a>"
                                    % (pdfZipFilename, packageName))
            outputFile.write("</div>")

            # The dialog that will be displayed when the user selects 'Print'
            outputFile.write("<div style=\"display:none;\" id=pdfSelection>\n")
            outputFile.write("<h3>Customize PDF page</h3>\n")
            outputFile.write("<p>Select the objects that you wish to see in the downloaded PDF</p>\n")
            outputFile.write("</div>\n")

            if printList:
              # Generate list of printable sections
              writePDFCustomization(outputFile, printList)

    # Navigation Bar + footer
    def generateFooterWithNavigationBar(self, outputFile, indexList,
                                        archList=None):
        self.generateNavigationBar(outputFile, indexList, archList,
                                   printButton=False)
        outputFile.write(FOOTER)

#------------------------------------------------------------------------------

    def writeSectionHeader(self, headerName, archName, outputFile,
                           pdf=None, isAccordion=True):
        if isAccordion:
          accordionClass = 'accordion'
        else:
          accordionClass = ''
        outputFile.write("<div class='%s sectionheader %s'><h2 align=\"left\"><a name=\"%s\">%s</a></h2>\n"
                          % (accordionClass, archName.split(" ")[0], archName, headerName))
        if pdf is not None and self._generatePDFBundle:
            pdf.append(Spacer(1, 20))
            pdf.append(Paragraph(headerName, styles['Heading2']))


    def queryICRInfo(self, package, type, val):
      icrList = []
      #  Find entries that have a certain top-level parameter
      #
      #  example call queryICRInfo("ROUTINE","ROUTINE","SDAM1")
      #  Would return all "ROUTINE" types where the "ROUTINE" field equals 'SDAM1'
      #
      if package in self._crossRef._icrJson:
        for keyVal in self._crossRef._icrJson[package].keys():
          if type == "*":
              for keyEntry in self._crossRef._icrJson[package][keyVal].keys():
                for entry in self._crossRef._icrJson[package][keyVal][keyEntry]:
                  icrList.append(entry)
          else:
            if val in self._crossRef._icrJson[package][keyVal]:
              for entry in self._crossRef._icrJson[package][keyVal][val]:
                icrList.append(entry)
      return icrList

    def generateWebPage(self):
        self.failures = []
        self.generateIndexHtmlPage()
        self.generatePackageNamespaceGlobalMappingPage()
        self.generateGlobalNameIndexPage()
        self.generateIndividualGlobalPage()
        self.generateGlobalFileNoIndexPage()
        self.generateFileManSubFileIndexPage()
        self.generatePackageIndexPage()
        self.generateRoutineIndexPage()
        self.generateAllSourceCodePage()
        self.generateAllIndividualRoutinePage()
        self.generatePackagePackageInteractionDetail()
        self.generatePackageInformationPages()
        self.generateIndividualPackagePage()
        self.generatePackageComponentListIndexPage()

        self.copyFilesToOutputDir()
        if self._generatePDFBundle:
            self.zipPDFFiles()
        if self.failures:
            # TODO: Log failures
            pass

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
        repo_info = "The information in this instance of DOX was generated on: \
                     %s from the repository with a Git hash of: %s" \
                    % (self._repoJson["date"], self._repoJson["sha1"])
        outputFile.write("""<h6><a class ="anchor" id="howto"></a>%s</h6>\n""" % repo_info)
        outputFile.write(FOOTER)

    def __generateHtmlPageHeader__(self, isSource=False):
        header = []
        header.append(COMMON_HEADER_PART)
        if isSource:
            header.append(CODE_PRETTY_JS_CODE)
        header.append(GOOGLE_ANALYTICS_JS_CODE)
        header.append(HEADER_END)
        if isSource:
            header.append(SOURCE_CODE_BODY_PART)
        else:
            header.append(DEFAULT_BODY_PART)
        header.append(TOP_INDEX_BAR_PART)
        return header

#===============================================================================
# Method to generate Package Namespace Mapping page
#===============================================================================
    def generatePackageNamespaceGlobalMappingPage(self):
        filename = os.path.join(self._outDir, "Packages_Namespace_Mapping.html")
        with open(filename, 'w') as outputFile:
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
                    row = []
                    # write the package name
                    if index == 0:
                        row.append(getPackageHyperLinkByName(packageName))
                    else:
                        row.append("")
                    # write the namespace
                    if index <= len(namespaces) - 1:
                        row.append(namespaces[index])
                    else:
                        row.append("")
                    # write the additional globals
                    if index <= len(globalNamespaces) - 1:
                        row.append(globalNamespaces[index])
                    else:
                        row.append("")
                    writeTableRow(row, outputFile, firstColumnKey=True)
            outputFile.write("</table>\n")
            outputFile.write("<BR>\n")
            outputFile.write(FOOTER)

#===============================================================================
#
#===============================================================================
    def _generateIndexPage(self, filename, title, numCol, sortedItems,
                           httpLinkFunction, nameFunc, indexes):
        with open(os.path.join(self._outDir, filename), 'w') as outputFile:
            self.__includeHeader__(outputFile)
            self._writeIndex(outputFile, title, numCol, sortedItems,
                             httpLinkFunction, nameFunc, indexes)
            outputFile.write(FOOTER)

    def _writeIndex(self, outputFile, title, numCol, sortedItems,
                    httpLinkFunction, nameFunc, indexes, indexSuffix=""):
        self._writeIndexTitleBlock(title, outputFile)
        linksList = ["%s%s" % (index, indexSuffix) for index in indexes]
        self.generateNavigationBar(outputFile, indexes,
                                   archList=linksList,
                                   isIndex=True)
        outputFile.write("<div class=\"contents\">\n")
        outputFile.write("<table align=\"center\" width=\"95%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n")
        totalNumItems = len(sortedItems)
        numPerCol = totalNumItems / numCol + 1
        for i in range(numPerCol):
            itemsPerRow = []
            for j in range(numCol):
                if (i + numPerCol * j) < totalNumItems:
                    itemsPerRow.append(sortedItems[i + numPerCol * j])
            self._generateIndexedTableRow(outputFile, itemsPerRow,
                                          httpLinkFunction,
                                          nameFunc, indexes, indexSuffix)
        outputFile.write("</table>\n</div>\n")
        self.generateNavigationBar(outputFile, indexes,
                                   archList=linksList,
                                   isIndex=True)

    def _generateIndexedTableRow(self, outputFile, inputList, httpLinkFunction,
                                 nameFunc, indexList, indexSuffix=""):
        outputFile.write("<tr>")
        for item in inputList:
            if item in indexList:
                indexItem = "%s%s" % (item, indexSuffix)
                outputFile.write("<td><a name='%s'></a>" % indexItem)
                outputFile.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">")
                outputFile.write("<tr><td><div class=\"ah\">&nbsp;&nbsp;%s&nbsp;&nbsp;</div></td></tr>" % item)
                outputFile.write("</table></td>")
            else:
                displayName = item
                if nameFunc:
                    displayName = nameFunc(item)
                outputFile.write("<td><a class=\"el\" href=\"%s\">%s</a>&nbsp;&nbsp;&nbsp;</td>" %
                                    (httpLinkFunction(item), displayName))
        outputFile.write("</tr>\n")

#===============================================================================
#
#===============================================================================
    def generateGlobalNameIndexPage(self):
        indexList = [char for char in string.uppercase]
        sortedGlobals = [] # a list of list
        for letter in indexList:
            sortedGlobals.append([letter, letter])
        for globalVar in self._allGlobals.itervalues():
            sortedName = globalVar.getName()[1:] # get rid of ^
            if sortedName.startswith('%') or sortedName.startswith('$'): # get rid of % and $
                sortedName = sortedName[1:]
            sortedGlobals.append([sortedName, globalVar.getName()])
        sortedGlobals = sorted(sortedGlobals, key=lambda item: item[0].lower())
        sortedGlobals = [item[1] for item in sortedGlobals]
        totalCol = 4
        self._generateIndexPage("globals.html", "Global", totalCol,
                                sortedGlobals, getGlobalHtmlFileNameByName,
                                None, indexList)

#===============================================================================
#
#===============================================================================
    def generateGlobalFileNoIndexPage(self):
        filename = os.path.join(self._outDir, "filemanfiles.html")
        with open(filename, 'w') as outputFile:
            allFileManFilesList = []
            for item in self._allGlobals.itervalues():
                if item.isFileManFile():
                    allFileManFilesList.append(item)
            self.__includeHeader__(outputFile)
            outputFile.write("<title>FileMan Files List</title>")
            outputFile.write("<div><h1>%s</h1></div>\n" % "FileMan Files List, Total: %d" % len(allFileManFilesList))
            writeTableHeader(["FileMan Name",
                              "FileMan FileNo",
                              "Global Name"],
                             outputFile)
            sortedFileManList = sorted(allFileManFilesList, key=lambda item: float(item.getFileNo()))
            for fileManFile in sortedFileManList:
                row = [getFileManFileHypeLinkWithFileManName(fileManFile),
                       getFileManFileHypeLinkWithFileNo(fileManFile),
                       getGlobalHypeLinkByName(fileManFile.getName())]
                writeTableRow(row, outputFile)
            outputFile.write("</table>\n")
            outputFile.write("<BR>\n")
            outputFile.write(FOOTER)

#===============================================================================
#
#===============================================================================
    def generateFileManSubFileIndexPage(self):
        filename = os.path.join(self._outDir, "filemansubfiles.html")
        with open(filename, 'w') as outputFile:
            allSubFiles = self._crossRef.getAllFileManSubFiles()
            self.__includeHeader__(outputFile)
            outputFile.write("<title id=\"pageTitle\">Fileman Sub-Files</title>")
            outputFile.write("<div><h1>%s</h1></div>\n" % "FileMan Sub-Files List, Total: %d" % len(allSubFiles))
            writeTableHeader(["Sub-File Name",
                              "Sub-File FileNo",
                              "Package Name"],
                             outputFile)
            sortedSubFileList = sorted(allSubFiles.values(), key=lambda item: float(item.getFileNo()))
            for subFile in sortedSubFileList:
                package = subFile.getRootFile().getPackage()
                row = [getFileManSubFileHypeLinkWithName(subFile),
                       getFileManSubFileHypeLinkByName(subFile),
                       getPackageHyperLinkByName(package.getName())]
                writeTableRow(row, outputFile)
            outputFile.write("</table>\n")
            outputFile.write("<BR>\n")
            outputFile.write(FOOTER)

#===============================================================================
#
#===============================================================================
    def generateIndividualGlobalPage(self):
        logger.info("Start generating individual globals......")

        for package in self._allPackages.itervalues():
            packageName = package.getName()
            for (globalName, globalVar) in package.getAllGlobals().iteritems():
                isFileManFile = globalVar.isFileManFile()
                if isFileManFile:
                    # Get all of the data first so we know which sections to
                    # add to the indexList
                    fileManDbCallRtns = globalVar.getFileManDbCallRoutines()
                    allFields = globalVar.getAllFileManFields()

                    indexList = ["Info", "Desc"]
                    if globalVar.getTotalNumberOfReferencedRoutines() > 0:
                        indexList.append("Directly Accessed By Routines")
                    if fileManDbCallRtns:
                        indexList.append("Accessed By FileMan Db Calls")
                    if globalVar.getTotalNumberOfReferredGlobals() > 0:
                        indexList.append( "Pointed To By FileMan Files")
                    if globalVar.getTotalNumberOfReferencedGlobals() > 0:
                        indexList.append("Pointer To FileMan Files")
                    if allFields:
                        indexList.append("Fields")
                else:
                    indexList = ["Directly Accessed By Routines"]
                htmlFileName = os.path.join(self._outDir,
                                               getGlobalHtmlFileNameByName(globalName))
                outputFile = open(htmlFileName, 'wb')
                if self._generatePDFBundle:
                    pdfFileName = os.path.join(self.__getPDFDirectory__(packageName),
                                               getGlobalPDFFileNameByName(globalName))
                    self.__setupPDF__()
                    pdf = []
                else:
                    pdf = None

                rtnIndexes = [
                   {
                     "name": "External References", # this is also the link name
                     "data" : globalVar.getExternalReference, # the data source
                   },
                   # Interaction Code section
                   {
                     "name": "Interaction Calls", # this is also the link name
                     "data" : globalVar.getInteractionEntries, # the data source
                   },
                   # Used in RPC section
                   {
                     "name": "Used in RPC", # this is also the link name
                     "data" : self.__getRpcReferences__, # the data source
                     "dataarg" : [globalName], # extra arguments for data source
                   },
                   # Used in HL7 Interface section
                   {
                     "name": "Used in HL7 Interface", # this is also the link name
                     "data" : self.__getHl7References__, # the data source
                     "dataarg" : [globalName], # extra arguments for data source
                   },
                   # FileMan Files Accessed Via FileMan Db Call section
                   {
                     "name": "FileMan Files Accessed Via FileMan Db Call", # this is also the link name
                     "data" : globalVar.getFilemanDbCallGlobals, # the data source
                   },
                   # Global Variables Directly Accessed section
                   {
                     "name": "Global Variables Directly Accessed", # this is also the link name
                     "data" : globalVar.getGlobalVariables, # the data source
                   },
                   # Label References section
                   {
                     "name": "Label References", # this is also the link name
                     "data" : globalVar.getLabelReferences, # the data source
                   },
                   # Naked Globals section
                   {
                     "name": "Naked Globals", # this is also the link name
                     "data" : globalVar.getNakedGlobals, # the data source
                   },
                   # Local Variables section
                   {
                     "name": "Local Variables", # this is also the link name
                     "data" : globalVar.getLocalVariables, # the data source
                   },
                   # Marked Items section
                   {
                     "name": "Marked Items", # this is also the link name
                     "data" : globalVar.getMarkedItems, # the data source
                   }
                ]

                filename = os.path.join(self._outDir, getGlobalHtmlFileNameByName(globalName))
                with open(filename, 'w') as outputFile:
                    self.__includeHeader__(outputFile)

                    icrList = self.queryICRInfo(packageName.upper(),"GLOBAL", globalName[1:])
                    if icrList:
                        # Note: This must match the key in 'titleDic' in the
                        # 'Global' section (PDF_Script.js). Also, must be
                        # different than 'Package' ICR section name.
                        icrSectionName = "ICR"
                        indexList.append(icrSectionName)
                    # Generate the listing of objects
                    entryList=[]
                    pdfEntryList=[]
                    pdfEntryRow = []
                    if globalVar.getFileNo():
                      jsonFile = os.path.join(self._outDir, globalVar.getFileNo().replace('.','_')+".json")
                      if os.path.isfile(jsonFile):
                        logger.info("Checking %s for entries" % jsonFile)
                        with open(jsonFile,"r") as entryData:
                          try:
                            globalVals = json.load(entryData)
                            indexList.append("Found Entries")
                            for entry in globalVals:
                                globalVals[entry]["GlobalNum"] = globalVar.getFileNo()
                                globalVals[entry]["IENum"] = entry
                                for val in globalVals[entry]:
                                  globalVals[entry][val] = cgi.escape(globalVals[entry][val])
                                entryList.append(globalVals[entry])
                                pdfEntryRow.append(self.getGlobalEntryName(globalVals[entry]))
                                if len(pdfEntryRow) == 8:
                                  pdfEntryList.append(pdfEntryRow)
                                  pdfEntryRow = []
                          except ValueError:
                            pass
                        while len(pdfEntryRow) < 8:
                          pdfEntryRow.append("")
                        pdfEntryList.append(pdfEntryRow)
                    rtnIndexList, idxLst = findRelevantIndex(rtnIndexes,None)
                    indexList = indexList + rtnIndexList
                    outputFile.write("<script>var titleList = " + str(indexList) + "</script>\n")
                    outputFile.write("")
                    self.generateNavigationBar(outputFile, indexList, printList=indexList)
                    title = "Global: %s" % globalName
                    self.writeTitleBlock(title, title, package, outputFile, pdf)
                    if isFileManFile:
                        # Information
                        self.writeSectionHeader("Information", "Info", outputFile,
                                                pdf, isAccordion=False)
                        infoHeader = ["FileMan FileNo", "FileMan Filename", "Package"]
                        itemList = [[globalVar.getFileNo(),
                                  globalVar.getFileManName(),
                                  getPackageHyperLinkByName(package.getName())]]
                        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, "information")
                        if self._generatePDFBundle:
                            self.__writeGenericTablizedPDFData__(infoHeader, itemList, pdf)

                        # Description
                        self.writeSectionHeader("Description", "Desc", outputFile,
                                                pdf, isAccordion=False)
                        # TODO: Write as a normal paragraph or series of paragraphs (i.e. not a list)
                        writeListData(globalVar.getDescription(), outputFile, classid="description")
                        if self._generatePDFBundle:
                            pdf.append(generatePDFListData(globalVar.getDescription()))
                        writeSectionEnd(outputFile)

                    # Directly Accessed By Routines
                    if globalVar.getTotalNumberOfReferencedRoutines() > 0:
                        self.writeSectionHeader("Directly Accessed By Routines, Total: %d" \
                                                    % globalVar.getTotalNumberOfReferencedRoutines(),
                                                "Directly Accessed By Routines",
                                                outputFile, pdf)
                        self.generateGlobalRoutineDependentsSection(globalVar.getAllReferencedRoutines(),
                                                                    outputFile, pdf, classid="directCall")
                        writeSectionEnd(outputFile)
                    # Accessed By FileMan Db Calls
                    if fileManDbCallRtns:
                        DbCallRtnsNos = [len(x) for x in
                                            fileManDbCallRtns.itervalues()]
                        totalNumDbCallRtns = sum(DbCallRtnsNos)
                        self.writeSectionHeader("Accessed By FileMan Db Calls, Total: %d" %
                                                totalNumDbCallRtns,
                                                "Accessed By FileMan Db Calls",
                                                outputFile, pdf)
                        self.generateGlobalRoutineDependentsSection(fileManDbCallRtns,
                                                                    outputFile,
                                                                    pdf,
                                                                    classid="gblRtnDep")
                        writeSectionEnd(outputFile)
                    if isFileManFile:
                        # Pointed to By FileMan Files
                        if globalVar.getTotalNumberOfReferredGlobals() > 0:
                            self.writeSectionHeader("Pointed To By FileMan Files, Total: %d"
                                                        % globalVar.getTotalNumberOfReferredGlobals(),
                                                    "Pointed To By FileMan Files",
                                                    outputFile, pdf)
                            self.generateGlobalPointedToSection(globalVar, outputFile,
                                                                pdf, True,
                                                                classid="gblPointedTo")
                            writeSectionEnd(outputFile)

                        # Pointer To FileMan Files
                        if globalVar.getTotalNumberOfReferencedGlobals() > 0:
                            self.writeSectionHeader("Pointer To FileMan Files, Total: %d"
                                                        % globalVar.getTotalNumberOfReferencedGlobals(),
                                                    "Pointer To FileMan Files",
                                                    outputFile, pdf)
                            self.generateGlobalPointedToSection(globalVar, outputFile,
                                                                pdf, False, classid="gblPointerTo")
                            writeSectionEnd(outputFile)

                        # Fields
                        if allFields:
                            self.writeSectionHeader("Fields, Total: %d" % len(allFields),
                                                    "Fields", outputFile, pdf)
                            self.__generateFileManFileDetails__(globalVar, outputFile, pdf)
                            writeSectionEnd(outputFile)
                    # Generate the listing of objects
                    if entryList:
                      self.writeSectionHeader("Found Entries, Total: %d" % len(entryList),
                                              "Found Entries", outputFile, pdf)
                      self.generateTablizedItemList(sorted(entryList, key=lambda x: self.getGlobalEntryName(x)),
                                                    outputFile,
                                                    self.getGlobalEntryHTML,
                                                    nameFunc=self.getGlobalEntryName,
                                                    classid="gblEntry",
                                                    useColor=False,
                                                    additionalDetailsURL="%s/%s/%s.html" % (VIVIAN_URL,globalVar.getFileNo().replace('.','_'), globalVar.getFileNo()))
                      if self._generatePDFBundle:
                          columns = 8
                          columnWidth = self.doc.width/columns
                          colWidths = [columnWidth, columnWidth, columnWidth, columnWidth, columnWidth, columnWidth, columnWidth, columnWidth]
                          self.__writeGenericTablizedPDFData__([], pdfEntryList, pdf,isString=True,columnWidths=colWidths)
                      writeSectionEnd(outputFile)
                    if icrList:
                       self.writeSectionHeader("%s, Total: %d" % (icrSectionName, len(icrList)),
                                               icrSectionName, outputFile, pdf)
                       self.generateGlobalICRSection(icrList, outputFile, pdf)
                       writeSectionEnd(outputFile)
                    self.__generateIndividualRoutinePage__(globalVar, pdf,
                                                           platform=None,
                                                           existingOutFile=outputFile)
                    self.generateFooterWithNavigationBar(outputFile, indexList)

                if self._generatePDFBundle:
                    self.__writePDFFile__(pdf, pdfFileName)

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
        indexList = ["Info", "Details"]
        filename = os.path.join(self._outDir,
                                getFileManSubFileHtmlFileName(subFile))
        with open(filename, 'w') as outputFile:
            if self._generatePDFBundle:
                self.__setupPDF__(isLandscape=True)
                pdf = []
            else:
                pdf = None

            # write the same _header file
            self.__includeHeader__(outputFile)
            self.generateNavigationBar(outputFile, indexList, printList=indexList)
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
            if self._generatePDFBundle:
                linkPDFTxt = ""
            else:
                linkPDFTxt = None
            index = 0
            for item in topDownList:
                if index == 0:
                    linkHtmlTxt += getFileManFileHypeLink(item)
                    if self._generatePDFBundle:
                        if not item.isFileManFile():
                            linkPDFTxt += item.getName()
                        if item.isSubFile():
                            linkPDFTxt += getFileManSubFileHtmlFileNameByName(item.getFileNo())
                        linkPDFTxt += getGlobalDisplayName(item)
                else:
                    linkHtmlTxt += getFileManSubFileHypeLinkByName(item.getFileNo())
                    if self._generatePDFBundle:
                        linkPDFTxt += item.getFileNo()
                if index < len(topDownList) - 1:
                    linkHtmlTxt += "-->"
                    if self._generatePDFBundle:
                        linkPDFTxt += "-->"
                index += 1
            self.writeTitleBlock(title, title, package, outputFile, pdf,
                                 linkHtmlTxt, linkPDFTxt)
            packageName = package.getName();

            # Information
            self.writeSectionHeader("Information", "Info", outputFile, pdf,
                                    isAccordion=False)
            infoHeader = ["Parent File", "Name", "Number", "Package"]
            parentFile = subFile.getParentFile()
            parentFileLink = ""
            if parentFile.isRootFile():
                parentFileLink = getFileManFileHypeLink(parentFile)
            else:
                parentFileLink =  getFileManSubFileHypeLinkByName(parentFile.getFileNo())
            itemList = [[parentFileLink, subFile.getFileManName(), subFile.getFileNo(),
                         getPackageHyperLinkByName(packageName)]]
            self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, "information")
            writeSectionEnd(outputFile)
            if self._generatePDFBundle:
                self.__writeGenericTablizedPDFData__(infoHeader, itemList, pdf)

            # Details
            self.writeSectionHeader("Details", "Details", outputFile, pdf)
            self.__generateFileManFileDetails__(subFile, outputFile, pdf)
            writeSectionEnd(outputFile)

            self.generateFooterWithNavigationBar(outputFile, indexList)

        if self._generatePDFBundle:
            pdfFileName = os.path.join(self.__getPDFDirectory__(packageName),
                                       getFileManSubFilePDFFileNameByName(subFile))
            self.__writePDFFile__(pdf, pdfFileName)

#===============================================================================
#
#===============================================================================
    def __generateFileManFileDetails__(self, fileManFile, outputFile, pdf):
        # sort the file man field by file #
        allFields = fileManFile.getAllFileManFields()
        if not allFields:
            return
        # sort the fields # by the float value
        sortedFields = sorted(allFields.keys(), key=lambda item: float(item))
        outputFieldsList = []
        if self._generatePDFBundle:
            pdfOutputFieldsList = []
        for key in sortedFields:
            value = allFields[key]
            location = value.getLocation()
            if not location: location = ""
            fieldNo = value.getFieldNo()
            fieldNoTxt = "<a name=\"%s\">%s</a>" % (fieldNo, fieldNo)
            type = value.getTypeName()
            if type is None: type = ""
            # Add the first 4 columns to the row
            fieldRow = [fieldNoTxt, value.getName(), location, type]
            if self._generatePDFBundle:
                pdfFieldRow = []
                # Make sure we're adding Paragraphs not just strings
                # so that the text will wrap, if needed
                pdfFieldRow.append(generateParagraph(fieldNo))
                pdfFieldRow.append(generateParagraph(value.getName()))
                pdfFieldRow.append(generateParagraph(location))
                pdfFieldRow.append(generateParagraph(type))
                pdfFieldDetails = ""
                pdfCell = []
            fieldDetails = ""
            # Generate the last column
            if value.__getattribute__("_isRequired"):
                text = "************************REQUIRED FIELD************************"
                fieldDetails += "<div style='text-align: center'><b>%s</b></div>" % text
                if self._generatePDFBundle:
                    pdfCell.append(generateParagraph(("<b>****REQUIRED FIELD****</b>")))
            if value.isSetType():
                # nice display of set members
                setIter = value.getSetMembers()
                fieldDetails += generateHtmlListData(setIter)
                if self._generatePDFBundle:
                    pdfCell.append(generatePDFListData(setIter))
            elif value.isFilePointerType():
                globalVar = value.getPointedToFile()
                if globalVar:
                    fieldDetails += (getFileManFileHypeLink(globalVar))
                    if self._generatePDFBundle:
                        if not globalVar.isFileManFile():
                            pdfFieldDetails += globalVar.getName()
                        elif globalVar.isSubFile():
                            pdfFieldDetails += getFileManSubFileHtmlFileNameByName(globalVar.getFileNo())
                        else:
                            pdfFieldDetails += getGlobalDisplayName(globalVar)
            elif value.isVariablePointerType():
                fileManFiles = value.getPointedToFiles()
                for pointedToFile in fileManFiles:
                    fieldDetails += getFileManFileHypeLink(pointedToFile) + "&nbsp;&nbsp;"
                    if self._generatePDFBundle:
                        if not pointedToFile.isFileManFile():
                            pdfFieldDetails += pointedToFile.getName()
                        elif pointedToFile.isSubFile():
                            pdfFieldDetails += getFileManSubFileHtmlFileNameByName(pointedToFile.getFileNo())
                        else:
                            pdfFieldDetails += getGlobalDisplayName(pointedToFile)
            elif value.isSubFilePointerType():
                filePointer = value.getPointedToSubFile()
                if filePointer:
                    fieldDetails += getFileManSubFileHypeLinkByName(filePointer.getFileNo())
                    if self._generatePDFBundle:
                        pdfFieldDetails += filePointer.getFileNo()
            # logic to append field extra details here
            fieldDetails += self.__generateFileManFieldPropsDetailsList__(value)
            fieldRow.append(fieldDetails)
            outputFieldsList.append(fieldRow)
            if self._generatePDFBundle:
                pdfCell.append(generateParagraph(pdfFieldDetails))
                numSections, pdfDetailsList = self.__generateFileManFieldPropsDetailsListPDF__(value)
                if pdfDetailsList is not None:
                    if numSections == 1:
                        pdfCell.append(pdfDetailsList)
                    else:
                        # make copy of the row
                        row = pdfFieldRow[:]
                        cell = pdfCell[:]
                        n = 0
                        for details in pdfDetailsList:
                            cell.append(details)
                            row.append(cell)
                            if n > 0:
                                row[0] = (generateParagraph(fieldNo + " (cont.)"))
                            pdfOutputFieldsList.append(row)
                            row = pdfFieldRow[:]
                            cell =[]
                            n += 1
                if numSections < 2: # 0 or 1
                    pdfFieldRow.append(pdfCell)
                    pdfOutputFieldsList.append(pdfFieldRow)
        fieldHeaderList = ["Field #", "Name", "Loc", "Type", "Details"]
        self.writeGenericTablizedHtmlData(fieldHeaderList, outputFieldsList, outputFile, "fmFields")
        if self._generatePDFBundle:
            columns = 13
            columnWidth = self.doc.width/columns
            colWidths = [columnWidth, columnWidth*2, columnWidth, columnWidth*2, columnWidth*7]
            self.__writeGenericTablizedPDFData__(fieldHeaderList, pdfOutputFieldsList, pdf,
                                                  columnWidths=colWidths, isString=False)

#===============================================================================
#
#===============================================================================
    def __generateFileManFieldPropsDetailsList__(self, fileManField):
        if not fileManField:
            return ""
        propList = fileManField.getPropList()
        if not propList:
            return ""
        output = "<p><ul>"
        for (name, values) in propList:
            output += "<li><dl><dt>%s&nbsp;&nbsp;<code>%s</code></dt>" % (name, values[0])
            for value in values[1:]:
                output += "<dd><pre>%s</pre></dd>" % value
            output += "</dl></li>"
        output += "</ul>"
        return output

    def __generateFileManFieldPropsDetailsListPDF__(self, fileManField):
        # TODO: The formatting on this is not identical to the HTML page (above)
        if not fileManField:
            return 0, None
        propList = fileManField.getPropList()
        if not propList:
            return 0, None
        if len(propList) <= 1:
            output = []
            for (name, values) in propList:
                item = []
                item.append(generateParagraph("<b>%s</b> %s" % (name, values[0])))
                for value in values[1:]:
                    item.append(generateParagraph(value))
                output.append(ListItem(item, leftIndent=7, bulletOffsetY=-3))
            return 1, generateList(output)
        retval = []
        output = []
        for (name, values) in propList:
            if "CROSS-REFERENCE" in name or \
               "TECHNICAL DESCR" in name or \
               "DESCRIPTION" in name or \
               "FIELD INDEX" in name:
                # Start a new row for each potentially really long field...
                # This is an attempt to keep the entire row on one page
                # (reportlab limitation)
                retval.append(generateList(output))
                output = []
            fieldName = generateParagraph("<b>%s</b> %s" % (name, values[0]))
            if "TECHNICAL DESCR" not in name and "DESCRIPTION" not in name:
                item = []
                item.append(fieldName)
                for value in values[1:]:
                    item.append(generateParagraph(value))
                output.append(ListItem(item, leftIndent=7, bulletOffsetY=-3))
            # Each paragraph of 'TECHNICAL DESCR' and 'DESCRIPTION' is split
            # into its own row
            else:
                for value in values[1:]:
                    item = []
                    item.append(fieldName)
                    item.append(generateParagraph(value))
                    # TODO: This shouldn't be bulleted, just indented
                    retval.append(generateList(item))
        retval.append(generateList(output))
        return len(retval), retval

#===============================================================================
#
#===============================================================================
    def generateGlobalPointedToSection(self, globalVar, outputFile, pdf,
                                       isPointedBy, classid=""):
        if isPointedBy:
            pointedByGlobals = globalVar.getAllReferencedFileManFiles()
        else:
            pointedByGlobals = globalVar.getAllReferredFileManFiles()
        sortedPackage = sorted(sorted(pointedByGlobals.keys()),
                           key=lambda item: len(pointedByGlobals[item]),
                           reverse=True)
        infoHeader = ["Package", "Total", "FileMan Files"]
        itemList = []
        if pdf and self._generatePDFBundle:
            pdfItemList = []
        for package in sortedPackage:
            globalDict = pointedByGlobals[package]
            itemRow = []
            itemRow.append(getPackageHyperLinkByName(package.getName()))
            itemRow.append(len(globalDict))
            #
            if pdf and self._generatePDFBundle:
                pdfItemRow = []
                pdfItemRow.append(generateParagraph(package.getName()))
                pdfItemRow.append(generateParagraph(str(len(globalDict))))
                #
                pdfGlobalData = []
            #
            globalData = ""
            index = 0
            for Global in sorted(globalDict.keys()):
                globalData += ("<a class=\"e1\" href=\"%s\">%s</a>" %
                             (getGlobalHtmlFileNameByName(Global.getName()),
                              getGlobalDisplayName(Global)))
                if pdf and self._generatePDFBundle:
                    pdfData = getGlobalDisplayName(Global)
                detailedList = globalDict[Global]
                if not detailedList:
                    continue
                fieldLinkGlobal = Global
                if not isPointedBy:
                    fieldLinkGlobal = globalVar
                globalData +="["
                if pdf and self._generatePDFBundle:
                    pdfData += "["
                index = 0
                for item in detailedList:
                    if not item[1]:
                        itemHtmlText = ("<a class=\"e2 %s\" href=\"%s#%s\">%s</a>" %
                                       (classid,
                                        getGlobalHtmlFileNameByName(fieldLinkGlobal.getName()),
                                        item[0], item[0]))
                        if pdf and self._generatePDFBundle:
                            itemPDFText = item[0]
                    else:
                        itemHtmlText = ("<a class=\"e2\" href=\"%s#%s\">#%s(%s)</a>" %
                                       (getFileManSubFileHtmlFileNameByName(item[1]),
                                        item[0], item[1], item[0]))
                        if pdf and self._generatePDFBundle:
                            itemPDFText = "#%s(%s)" % (item[1], item[0])
                    globalData += itemHtmlText
                    if pdf and self._generatePDFBundle:
                        pdfData += itemPDFText
                    if index < len(detailedList) - 1:
                        globalData += ",&nbsp"
                    index += 1
                globalData +="]"
                if pdf and self._generatePDFBundle:
                    pdfData += "]"
                if (index + 1) % 4 == 0:
                    globalData += "<BR>"
                else:
                    globalData += "&nbsp;&nbsp;&nbsp;&nbsp;"
                index += 1
                if pdf and self._generatePDFBundle:
                    pdfGlobalData.append(generateParagraph(pdfData))

            itemRow.append(globalData)
            if pdf and self._generatePDFBundle:
                pdfItemRow.append(pdfGlobalData)

            itemList.append(itemRow)
            if pdf and self._generatePDFBundle:
                pdfItemList.append(pdfItemRow)
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid)
        if pdf and self._generatePDFBundle:
            columns = 8
            columnWidth = self.doc.width/columns
            colWidths = [columnWidth, columnWidth, columnWidth * 6]
            self.__writeGenericTablizedPDFData__(infoHeader, pdfItemList, pdf,
                                                 columnWidths=colWidths, isString=False)

#===============================================================================
#
#===============================================================================
    def generateGlobalRoutineDependentsSection(self, depRoutines,
                                               outputFile, pdf, classid=""):
        sortedPackage = sorted(sorted(depRoutines.keys()),
                               key=lambda item: len(depRoutines[item]),
                               reverse=True)
        infoHeader = ["Package", "Total", "Routines"]
        itemList = []
        if self._generatePDFBundle:
            pdfItemList = [] # No html markup
        for package in sortedPackage:
            routineSet = depRoutines[package]
            #
            itemRow = []
            itemRow.append(getPackageHyperLinkByName(package.getName()))
            itemRow.append(len(routineSet))
            #
            if self._generatePDFBundle:
                pdfItemRow = []
                pdfItemRow.append(package.getName())
                pdfItemRow.append(len(routineSet))
                #
                pdfRoutineData = ""
            #
            routineData = ""
            index = 0
            for routine in sorted(routineSet):
                routineData += ("<a class=\"e1\" href=\"%s\">%s" %
                             (getPackageComponentLink(routine),
                              routine.getName()))
                if (index + 1) % 8 == 0:
                    routineData += "</a><BR>"
                else:
                    routineData += "</a>&nbsp;&nbsp;&nbsp;&nbsp;"
                if self._generatePDFBundle:
                    pdfRoutineData += routine.getName() + " "
                index += 1
            itemRow.append(routineData)
            itemList.append(itemRow)
            if self._generatePDFBundle:
                pdfItemRow.append(pdfRoutineData)
                pdfItemList.append(pdfItemRow)
        self.writeGenericTablizedHtmlData(infoHeader, itemList, outputFile, classid)
        if self._generatePDFBundle:
            columns = 8
            columnWidth = self.doc.width/columns
            colWidths = [columnWidth, columnWidth, columnWidth * 6]
            self.__writeGenericTablizedPDFData__(infoHeader, pdfItemList, pdf, colWidths)

#===============================================================================
# method to generate the interactive detail list page between any two packages
#===============================================================================
    def generatePackagePackageInteractionDetail(self):
        packDepDict = dict()
        for package in self._allPackages.itervalues():
            for depDict in (package.getPackageRoutineDependencies(),
                            package.getPackageGlobalRoutineDependencies(),
                            package.getPackageGlobalDependencies(),
                            package.getPackageFileManFileDependencies(),
                            package.getPackageFileManDbCallDependencies()):
                self._updatePackageDepDict(package, depDict, packDepDict)
        for (key, value) in packDepDict.iteritems():
            self.generatePackageInteractionDetailPage(key, value[0], value[1])

    def generateGlobalICRSection(self, icrInfo, outfile, pdf):
      headerList = ["ICR LINK", "Subscribing Package(s)",
                    "Fields Referenced", "Description"]
      icrTable = []
      if self._generatePDFBundle:
        icrTablePDF = []
      for entry in icrInfo:
        icrLink = "<a href='%s'>ICR #%s</a>" % (getICRHtmlFileName(entry), entry["NUMBER"])
        subscribingPackage = ""
        if self._generatePDFBundle:
            icrLinkPDF = generateParagraph("ICR #%s" % entry["NUMBER"])
            subscribingPackagesPDF = []
        if "SUBSCRIBING PACKAGE" in entry:
            subscribingPackages = []
            for value in entry["SUBSCRIBING PACKAGE"]:
                pkgName = value["SUBSCRIBING PACKAGE"][0] if type(value["SUBSCRIBING PACKAGE"]) is list else value["SUBSCRIBING PACKAGE"]
                subscribingPackage += "<li>" + getPackageHyperLinkByName(pkgName) + "</li>"
                if pkgName in PACKAGE_MAP:
                    pkgName = PACKAGE_MAP[pkgName]
                subscribingPackages.append(generateParagraph(pkgName))
            if self._generatePDFBundle:
                subscribingPackagesPDF = generateList(subscribingPackages)
        fieldsReferenced = ""
        if self._generatePDFBundle:
            fieldsReferencedPDF = []
        if ("GLOBAL REFERENCE" in entry):
          for reference in entry["GLOBAL REFERENCE"]:
            if "FIELD NUMBER" in reference:
              for value in reference["FIELD NUMBER"]:
                name = value["FIELD NAME"] if "FIELD NAME" in value else ""
                num = value["FIELD NUMBER"] if "FIELD NUMBER" in value else ""
                accessString = value["ACCESS"] if "ACCESS" in value else ""
                fieldsReferenced += "%s (<a href='#%s'>%s</a>). <br/> <b>Access:</b> %s" % (name, num, num, accessString)
                fieldsReferenced += "<br/><br/>"
                if self._generatePDFBundle:
                    fieldsReferencedPDF.append(generateParagraph("%s (%s)." % (name, num)))
                    fieldsReferencedPDF.append(generateParagraph("<b>Access:</b> %s" % accessString))
        elif self._generatePDFBundle:
            fieldsReferencedPDF.append(generateParagraph(""))
        description = ""
        if ("GLOBAL REFERENCE" in entry):
          for reference in entry["GLOBAL REFERENCE"]:
            if "GLOBAL DESCRIPTION" in reference:
              for value in reference["GLOBAL DESCRIPTION"]:
                description += value
        row = [icrLink, subscribingPackage, fieldsReferenced, description]
        icrTable.append(row)
      self.writeGenericTablizedHtmlData(headerList, icrTable, outfile, "icrVals")
      if self._generatePDFBundle:
          pdfRow = [icrLinkPDF, subscribingPackagesPDF,
                    fieldsReferencedPDF, generateParagraph(description)]
          icrTablePDF.append(pdfRow)
          columns = 10
          columnWidth = self.doc.width/columns
          colWidths = [columnWidth, columnWidth * 2, columnWidth * 3, columnWidth * 4]
          self.__writeGenericTablizedPDFData__(headerList, icrTablePDF, pdf,
                                                  columnWidths=colWidths, isString=False)

    def _updatePackageDepDict(self, package, depDict, packDepDict):
        for depPack in depDict.iterkeys():
            fileName = getPackageDependencyHtmlFileName(package.getName(),
                                                        depPack.getName())
            if fileName not in packDepDict:
                packDepDict[fileName] = (package, depPack)

#===============================================================================
# method to generate the detail of package
#===============================================================================
    def generatePackageRoutineDependencyDetailPage(self, package, depPackage,
                                                   outputFile, titleIndex):
        packageHyperLink = getPackageHyperLinkByName(package.getName())
        depPackageHyperLink = getPackageHyperLinkByName(depPackage.getName())
        routineDepDict = package.getPackageRoutineDependencies()
        globalDepDict = package.getPackageGlobalDependencies()
        globalRtnDepDict = package.getPackageGlobalRoutineDependencies()
        fileManDepDict = package.getPackageFileManFileDependencies()
        dbCallDepDict = package.getPackageFileManDbCallDependencies()
        optionDepDict = package.getPackageComponentDependencies()
        gblgblDepDicts = package.getPackageGlobalGlobalDependencies()
        callerRoutines = set()
        calledRoutines = set()
        optionCallRoutines = set()
        globalRtnCallRoutines = set()
        globalRtnCalledRoutines = set()
        globalGblCallRoutines = set()
        globalGblCalledRoutines = set()
        optionCalledRoutines = set()
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
        if optionDepDict and depPackage in optionDepDict:
            optionCallRoutines = optionDepDict[depPackage][0]
            optionCalledRoutines = optionDepDict[depPackage][1]
            titleList = titleList + ["Package Component(s)"+titleIndex, "Package Component called Routines"+titleIndex]
        if globalRtnDepDict and depPackage in globalRtnDepDict:
            globalRtnCallRoutines = globalRtnDepDict[depPackage][0]
            globalRtnCalledRoutines = globalRtnDepDict[depPackage][1]
            titleList = titleList + ["RCaller Globals"+titleIndex, "GCalled Routines"+titleIndex]
        if gblgblDepDicts and depPackage in gblgblDepDicts:
            globalGblCallRoutines = gblgblDepDicts[depPackage][0]
            globalGblCalledRoutines = gblgblDepDicts[depPackage][1]
            titleList = titleList + ["GCaller Globals"+titleIndex, "Called Globals"+titleIndex]

        # TODO: Refactor code so that we don't have to call
        # writePDFCustomization directly and can use generateNavigationBar
        # Generate PDF customization dialog
        pdfList = titleList
        pdfList.append("Legend Graph")
        writePDFCustomization(outputFile, pdfList)

        optionCalledHtml = "<span class=\"comment\">%d</span>" % len(optionCalledRoutines)
        optionCallerHtml = "<span class=\"comment\">%d</span>" % len(optionCallRoutines)
        gblRtnCallerHtml = "<span class=\"comment\">%d</span>" % len(globalRtnCallRoutines)
        gblRtnCalledHtml = "<span class=\"comment\">%d</span>" % len(globalRtnCalledRoutines)
        gblGblCallerHtml = "<span class=\"comment\">%d</span>" % len(globalGblCallRoutines)
        gblGblCalledHtml = "<span class=\"comment\">%d</span>" % len(globalGblCalledRoutines)
        totalCallerHtml = "<span class=\"comment\">%d</span>" % len(callerRoutines)
        totalCalledHtml = "<span class=\"comment\">%d</span>" % len(calledRoutines)
        totalReferredRoutineHtml = "<span class=\"comment\">%d</span>" % len(referredRoutines)
        totalReferredGlobalHtml = "<span class=\"comment\">%d</span>" % len(referredGlobals)
        totalReferredFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(referredFileManFiles)
        totalReferencedFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(referencedFileManFiles)
        totalDbCallRoutinesHtml = "<span class=\"comment\">%d</span>" % len(dbCallRoutines)
        totalDbCallFileManFilesHtml = "<span class=\"comment\">%d</span>" % len(dbCallFileManFiles)
        summaryHeader = "Summary:<BR> Total %s routine(s) in %s called total %s routine(s) in %s" % (totalCallerHtml,
                                                                                                     packageHyperLink,
                                                                                                     totalCalledHtml,
                                                                                                     depPackageHyperLink)
        summaryHeader += "<BR> Total %s Global(s) in %s called total %s routine(s) in %s" % (gblRtnCallerHtml,
                                                                                               packageHyperLink,
                                                                                               gblRtnCalledHtml,
                                                                                               depPackageHyperLink)
        summaryHeader += "<BR> Total %s Global(s) in %s called total %s Global(s) in %s" % (gblGblCallerHtml,
                                                                                               packageHyperLink,
                                                                                               gblGblCalledHtml,
                                                                                               depPackageHyperLink)
        summaryHeader += "<BR> Total %s Package Component(s) in %s called total %s routine(s) in %s" % (optionCallerHtml,
                                                                                               packageHyperLink,
                                                                                               optionCalledHtml,
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
        writeSubSectionHeader(summaryHeader, outputFile, classid="summary")

        # Print out the routine details
        if callerRoutines or calledRoutines:
            sectionHeader = "Routines --> Routines"
            self.writeSectionHeader(sectionHeader, sectionHeader, outputFile)
            writeSectionBegin(outputFile)
            if callerRoutines:
                header = "Caller Routines List in %s : %s" % \
                          (packageHyperLink, totalCallerHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(callerRoutines),
                                              outputFile,
                                              getPackageComponentLink,
                                              nameFunc=self.getRoutineDisplayName,
                                              classid="callerRoutines",
                                              useColor=False)
            if calledRoutines:
                header = "Called Routines List in %s : %s" % \
                          (depPackageHyperLink, totalCalledHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(calledRoutines),
                                              outputFile,
                                              getPackageComponentLink,
                                              nameFunc=self.getRoutineDisplayName,
                                              classid="calledRoutines",
                                              useColor=False)
            writeSectionEnd(outputFile)
            writeSectionEnd(outputFile) # Close accordion

        # print out the Global -> routine details
        if globalRtnCallRoutines or globalRtnCalledRoutines:
            sectionHeader = "Globals --> Routines"
            self.writeSectionHeader(sectionHeader, sectionHeader, outputFile)
            writeSectionBegin(outputFile)
            if globalRtnCallRoutines:
                header = "Caller Global List in %s : %s" % \
                          (packageHyperLink, gblRtnCallerHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(globalRtnCallRoutines),
                                              outputFile,
                                              getGlobalHtmlFileName,
                                              classid="rcallerGlobals")
            if globalRtnCalledRoutines:
                header = "Called Routines List in %s : %s" % \
                          (depPackageHyperLink, gblRtnCalledHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(globalRtnCalledRoutines),
                                              outputFile,
                                              getPackageComponentLink,
                                              nameFunc=self.getRoutineDisplayName,
                                              classid="gcalledRoutines",
                                              useColor=False)
            writeSectionEnd(outputFile)
            writeSectionEnd(outputFile) # Close accordion

        # print out the Global -> global details
        if globalGblCallRoutines or globalGblCalledRoutines:
            sectionHeader = "Globals --> Globals"
            self.writeSectionHeader(sectionHeader, sectionHeader, outputFile)
            writeSectionBegin(outputFile)
            if globalGblCallRoutines:
                header = "Caller Global List in %s : %s" % \
                          (packageHyperLink, gblGblCallerHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(globalGblCallRoutines),
                                              outputFile,
                                              getGlobalHtmlFileName,
                                              classid="gCallerGlobals")
            if globalGblCalledRoutines:
                header = "Called Globals List in %s : %s" % \
                          (depPackageHyperLink, gblGblCalledHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(globalGblCalledRoutines),
                                              outputFile,
                                              getGlobalHtmlFileName,
                                              classid="calledGlobals")
            writeSectionEnd(outputFile)
            writeSectionEnd(outputFile) # Close accordion

        # print out the Package Component details
        if optionCallRoutines or optionCalledRoutines:
            sectionHeader = "Package Components List --> Routines"
            self.writeSectionHeader(sectionHeader, sectionHeader, outputFile)
            writeSectionBegin(outputFile)
            if optionCallRoutines:
                header = "Caller Package Components List in %s : %s" % \
                          (packageHyperLink, optionCallerHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(optionCallRoutines),
                                              outputFile,
                                              getPackageComponentLink,
                                              nameFunc=self.getPackageComponentDisplayName,
                                              classid="PCObjects")
            if optionCalledRoutines:
                header = "Called Routines in %s : %s" % \
                          (depPackageHyperLink, optionCalledHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(optionCalledRoutines),
                                              outputFile,
                                              getPackageComponentLink,
                                              nameFunc=self.getRoutineDisplayName,
                                              classid="PCcalledRoutines",
                                              useColor=False)
            writeSectionEnd(outputFile)
            writeSectionEnd(outputFile) # Close accordion

        if referredRoutines or referredGlobals:
            sectionHeader = "Routines --> Globals"
            self.writeSectionHeader(sectionHeader, sectionHeader, outputFile)
            writeSectionBegin(outputFile)
            if referredRoutines:
                header = "Referred Routines List in %s : %s" % \
                          (packageHyperLink, totalReferredRoutineHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(referredRoutines),
                                              outputFile,
                                              getPackageComponentLink,
                                              nameFunc=self.getRoutineDisplayName,
                                              classid="referredRoutines",
                                              useColor=False)
            if referredGlobals:
                header = "Referenced Globals List in %s : %s" % \
                          (depPackageHyperLink, totalReferredGlobalHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(referredGlobals),
                                              outputFile,
                                              getGlobalHtmlFileName,
                                              classid="referredGlobals")
            writeSectionEnd(outputFile)
            writeSectionEnd(outputFile) # Close accordion

        if referredFileManFiles or referencedFileManFiles:
            sectionHeader = "FileMan Files --> FileMan Files"
            self.writeSectionHeader(sectionHeader, sectionHeader, outputFile)
            writeSectionBegin(outputFile)
            if referredFileManFiles:
                header = "Referred FileMan Files List in %s : %s" % \
                          (packageHyperLink, totalReferredFileManFilesHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(referredFileManFiles),
                                              outputFile,
                                              getGlobalHtmlFileName,
                                              nameFunc=getGlobalDisplayName,
                                              classid="referredFileManFiles")
            if referencedFileManFiles:
                header = "Referenced FileMan Files List in %s : %s" % \
                          (depPackageHyperLink, totalReferencedFileManFilesHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(referencedFileManFiles),
                                              outputFile,
                                              getGlobalHtmlFileName,
                                              nameFunc=getGlobalDisplayName,
                                              classid="referencedFileManFiles")
            writeSectionEnd(outputFile)
            writeSectionEnd(outputFile) # Close accordion

        if dbCallRoutines or dbCallFileManFiles:
            sectionHeader = "FileMan Db Call Routines --> FileMan Files"
            self.writeSectionHeader(sectionHeader, sectionHeader, outputFile)
            writeSectionBegin(outputFile)
            if dbCallRoutines:
                header = "FileMan Db Call Routines List in %s : %s" % \
                          (packageHyperLink, totalDbCallRoutinesHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(dbCallRoutines),
                                              outputFile,
                                              getPackageComponentLink,
                                              nameFunc=self.getRoutineDisplayName,
                                              classid="dbCallRoutines",
                                              useColor=False)
            if dbCallFileManFiles:
                header = "FileMan Db Call Accessed FileMan Files List in %s : %s" % \
                          (depPackageHyperLink, totalDbCallFileManFilesHtml)
                writeSubSectionHeader(header, outputFile)
                self.generateTablizedItemList(sorted(dbCallFileManFiles),
                                              outputFile,
                                              getGlobalHtmlFileName,
                                              classid="dbCallFileManFiles",
                                              useColor=False)
            writeSectionEnd(outputFile)
            writeSectionEnd(outputFile) # Close accordion
        outputFile.write("<br/>\n")

#===============================================================================
# method to generate the individual package/package interaction detail page
#===============================================================================
    def generatePackageInteractionDetailPage(self, fileName, package, depPackage):
        with open(os.path.join(self._outDir, fileName), 'w') as outputFile:
            self.__includeHeader__(outputFile)

            # Get package links
            packageHyperLink = getPackageHyperLinkByName(package.getName())
            depPackageHyperLink = getPackageHyperLinkByName(depPackage.getName())

            # Generate the index bar
            inputList = ["%s-->%s" % (package.getName(), depPackage.getName()),
                         "%s-->%s" % (depPackage.getName(), package.getName())]
            archList = [package.getName(), depPackage.getName()]
            self.generateNavigationBar(outputFile, inputList, archList)

            # Title and header
            pageTitle = package.getName() + " : " + depPackage.getName()
            outputFile.write("<title id=\"pageTitle\">" + pageTitle + "</title>")
            outputFile.write("<div><h1>%s and %s Interaction Details</h1></div>\n" %
                              (packageHyperLink, depPackageHyperLink))

            # Legends
            outputFile.write(self.legend)

            # Accordion
            outputFile.write(ACCORDION)

            # Package --> Dep. Package
            self.writeSectionHeader("%s-->%s :" % (packageHyperLink, depPackageHyperLink),
                                    package.getName(), outputFile,
                                    isAccordion=False)
            self.generatePackageRoutineDependencyDetailPage(package, depPackage,
                                                            outputFile, "_1")
            writeSectionEnd(outputFile)
            # Dep. Package --> Package
            self.writeSectionHeader("%s-->%s :" % (depPackageHyperLink, packageHyperLink),
                                    depPackage.getName(), outputFile,
                                    isAccordion=False)
            self.generatePackageRoutineDependencyDetailPage(depPackage, package,
                                                            outputFile, "_2")
            writeSectionEnd(outputFile)
            self.generateFooterWithNavigationBar(outputFile, inputList, archList)

    ###########################################################################
    def __parseReadCmd__(self, matchArray, routine, lineNo):
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
      lineList =  SPLIT_LINE.split(line)
      lastIndex = 0
      for i in lineList:
        # Captures the conditional value of the write, while trying to remove false matches like "WRITE" as an entry point
        match = CONDITIONAL.search(i)
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
    def __generateSourceCodePageByName__(self, sourceCodeName, routine):
        if not routine:
            logger.error("Routine cannot be None")
            return
        package = routine.getPackage()
        if not package:
            logger.error("Routine %s does not belong to a package" % routine)
            return
        packageName = package.getName()
        routineName = routine.getName()
        calledRoutines = routine.getCalledRoutines()
        labels = routine.getLabelReferences()
        filename = os.path.join(self._outDir,
                                getRoutineSourceHtmlFileName(sourceCodeName))
        with open(filename, 'w') as outputFile:
            try:
                sourcePath = getRoutineSourceCodeFileByName(sourceCodeName,
                                                            packageName,
                                                            self._repDir)
                with open(sourcePath, 'r') as sourceFile:
                    self.__includeSourceHeader__(outputFile)
                    outputFile.write("<title id=\"pageTitle\">Routine: " + sourceCodeName + "</title>")
                    outputFile.write("<div><h1>%s.m</h1></div>\n" % sourceCodeName)
                    outputFile.write("<div id='pageCommands' style='background: white;'>")
                    outputFile.write("  <a href=\"%s\">Go to the documentation of this file.</a>" %
                                     getPackageComponentLink(routine))
                    if routine._structuredCode:
                      outputFile.write(SWAP_VIEW_HTML)
                    outputFile.write('</div>')
                    outputFile.write("<div id=\"terseDisplay\">")
                    # Inititalize the new variables
                    lineNo = 1
                    entry = ""
                    entryOffset = 0
                    currentEntryPoint = routineName
                    comment=[]
                    icrJson=[]
                    inComment=False
                    for line in sourceFile:
                        idVal = ""
                        line = line.replace("<", "&lt")
                        line = line.replace(">", "&gt")
                        if lineNo <= 1:
                            routine.addComment(line)
                        if lineNo > 1 and ENTRY_POINT.search(line):
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
                            entry = line
                          currentEntryPoint = entry.split("(")[0]
                          entryOffset= 0
                          comment.append(commentString)
                          if not commentString.startswith(";"):
                            comment = []
                            # if No comment on the first line, assume no other comments will follow it
                            inComment =  False
                          icrJson = self.queryICRInfo(packageName.upper(),"ROUTINE", routineName)
                          idVal = "id=\"%s\"" % currentEntryPoint
                        # Check for more comments that are 1 space in from the beginning of the line
                        elif inComment and COMMENT.search(line):
                          comment.append(line)
                        else:
                          # If here, assume we have reached the code part of the entry point and stop checking for comments
                          inComment = False
                        readCmdMatches = READ_CMD.findall(line)
                        if readCmdMatches:
                            self.__parseReadCmd__(readCmdMatches, routine, currentEntryPoint+"+"+str(entryOffset))
                        if WRITE_CMD.search(line):
                            self.__parseWriteCmd__(line, routine, currentEntryPoint+"+"+str(entryOffset))
                        #if "^" in line:
                        rtnLinks = routineCall.search(line)
                        if rtnLinks:
                          #  find captured groupings
                          for pairFound in sorted(routineCall.finditer(line), key=lambda match: match.span()[0], reverse=True ):
                            pair = pairFound.groups()
                            stop = pairFound.span()[1]
                            start = pairFound.span()[0]
                            if pair[1]:
                              #  replace them with links to new pages
                              for value in calledRoutines.values():
                                if Routine(pair[1]) in value.keys():
                                  replaceLink = line[start:stop]
                                  entryLink ="<a class=\"pln\" href=\"%s/Routine_%s_source.html#%s\">%s^%s</a>" % (DOX_URL, pair[1].replace('%',''), pair[0], pair[0], pair[1])
                                  replaceString = "%s^%s" % pair
                                  line = line[:start] + replaceLink.replace(replaceString, entryLink)+ line[stop:]
                            elif pair[0] in labels:
                              entryLink ="<a class=\"pln\" href=\"%s/Routine_%s_source.html#%s\">%s</a>" % (DOX_URL, routineName.replace('%',''), pair[0], pair[0])
                              replaceLink = line[start:stop]
                              line = line[:start] + replaceLink.replace(pair[0], entryLink)+ line[stop:]
                        outputFile.write("<pre style=\"padding:unset; border: none; margin:unset; display: inline;\" %s class=\"prettyprint lang-mumps linenums:%s\">%s</pre>" % (idVal, lineNo,line))
                        lineNo += 1
                        entryOffset += 1
            except Exception, e:
                logger.error(e)
                return
            routine.addEntryPoint(entry, comment, icrJson)

            outputFile.write("</div>\n")
            if routine._structuredCode:
              outputFile.write("<div id=\"expandedDisplay\" style='display:none;'>")
              lineNo = 1
              for line in routine._structuredCode:
                #if "^" in line:
                rtnLinks = routineCallExpanded.search(line)
                if rtnLinks:
                  #  find captured groupings
                  for pair in routineCallExpanded.findall(line):
                    if pair[1]:
                    #  replace them with links to new pages
                      for value in calledRoutines.values():
                        if Routine(pair[1]) in value.keys():
                          entryLink ="<a class=\"pln\" href=\"%s/Routine_%s_source.html#%s\">%s^%s</a>" % (DOX_URL, pair[1].replace("%",''), pair[0], pair[0], pair[1])
                          line = line.replace("%s^%s" % pair, entryLink)
                    elif pair[0] in labels:
                      entryLink ="<a class=\"pln\" href=\"%s/Routine_%s_source.html#%s\">%s</a>" % (DOX_URL, routineName.replace("%",''), pair[0], pair[0])
                      line = line.replace(pair[0], entryLink)
                if len(line):
                  outputFile.write("<pre style=\"padding:unset; border: none; margin:unset;\" class=\"prettyprint lang-mumps linenums:%s\">%s</pre>\n" % (lineNo, line))
                  lineNo = lineNo + 1
              outputFile.write("</div>\n")
            outputFile.write(FOOTER)

#===============================================================================
# Method to generate individual source code page for Platform Dependent Routines
#===============================================================================
    def __generatePlatformDependentRoutineSourcePage__(self, genericRoutine):
        allRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in allRoutines.itervalues():
            routine = routineInfo[0]
            sourceCodeName = routine.getOriginalName()
            self.__generateSourceCodePageByName__(sourceCodeName, routine)

#===============================================================================
# Method to generate individual source code page
# sourceDir should be VistA-M git repository
#===============================================================================
    def generateAllSourceCodePage(self):
        for packageName in self._allPackages.iterkeys():
            for (routineName, routine) in self._allPackages[packageName].getAllRoutines().iteritems():
                if self._crossRef.isPlatformGenericRoutineByName(routineName):
                    self.__generatePlatformDependentRoutineSourcePage__(routine)
                    continue
                # check for platform dependent routine
                if not routine.hasSourceCode():
                    continue
                sourceCodeName = routine.getOriginalName()
                self.__generateSourceCodePageByName__(sourceCodeName, routine)

#===============================================================================
# utility method to show component type
#===============================================================================
    def getPackageComponentDisplayName(self, routine):
        routineName = routine.getName()
        if "componentType" in dir(routine):
            componentType = routine.componentType.strip()
            if componentType in COMPONENT_TYPE_DICT:
                return "%s<sup>(%s)</sup>" % (routineName, COMPONENT_TYPE_DICT[componentType])
        return routineName

    def getRoutineDisplayName(self, routine):
        return routine.getName()

    def getGlobalEntryName(self, routine):
        if ".01" in routine:
          return routine['.01']
        else:
          return "Entry: %s" % routine["IENum"]

    def getGlobalEntryHTML(self, routine):
        return "%s/%s/%s-%s.html" % (VIVIAN_URL, routine["GlobalNum"].replace(".","_"),routine["GlobalNum"],routine["IENum"])

#===============================================================================
# Method to generate routine Index page
#===============================================================================
    def generateRoutineIndexPage(self):
        indexList = [char for char in string.uppercase]
        indexList.insert(0, "%")
        indexList.insert(0, "$")
        indexList.sort()
        routinesList = []
        for routine in self._allRoutines.itervalues():
            routinesList.append(routine.getName())
        sortedItems = indexList + routinesList
        sortedItems = sorted(sortedItems, key=lambda s: s.lower())
        totalCol = 4
        self._generateIndexPage("routines.html", "Routine", totalCol,
                                sortedItems, getRoutineLink,
                                self.getRoutineDisplayNameByName, indexList)

    def getRoutineDisplayNameByName(self, routineName):
        routine = self._crossRef.getRoutineByName(routineName)
        routineName = routine.getName()
        if isinstance(routine, PlatformDependentGenericRoutine):
            return "%s<sup>(%s)</sup>" % (routineName, "platform dependent generic routine")
        if not routine.hasSourceCode():
            return "%s<sup>(%s)</sup>" % (routineName, "no source")
        return routineName

#===============================================================================
#
#===============================================================================
    def copyFilesToOutputDir(self):
       cssFile = os.path.join(os.path.abspath(self._docRepDir),
                              "Web/DoxygenStyle.css")
       # Always copy this file, even if not generating PDF bundles
       pdfFile = os.path.join(os.path.abspath(self._docRepDir),
                              "PythonScripts/PDF_Script.js")
       shutil.copy(cssFile, self._outDir)
       shutil.copy(pdfFile, self._outDir)

    def zipPDFFiles(self):
        toZip = [x[0] for x in os.walk(self._pdfOutDir)]
        for dir in toZip[1:]: # Don't zip top-level directory
            shutil.make_archive(dir, 'zip', dir)
        # TODO: Delete non-zipped directories?

#===============================================================================
#
#===============================================================================
    def generatePackageIndexPage(self):
        packagesList = self._allPackages.keys()
        indexList = [char for char in string.uppercase]
        indexList.insert(0, '0-9')
        indexList.sort()
        sortedItems = indexList + packagesList
        sortedItems = sorted(sortedItems, key=lambda s: s.lower())
        totalCol = 3
        self._generateIndexPage("packages.html", "Package", totalCol,
                                sortedItems, getPackageHtmlFileName, None, indexList)

#=======================================================================
# Method to generate package dependency/dependent section info
#=======================================================================
    def generatePackageDependencySection(self, depPackages, packagesMerged,
                                         packageName, outputFile,
                                         pdf, isDependencyList=True):
        totalPackages = len(depPackages)
        if isDependencyList:
            sectionGraphHeader = "Dependency Graph"
            sectionListHeader = "Package Dependency List"
            packageSuffix = "_dependency"
        else:
            sectionGraphHeader = "Dependent Graph"
            sectionListHeader = "Package Dependent List"
            packageSuffix = "_dependent"
        if self._generatePDFBundle:
            paragraphs = []
        else:
            paragraphs = None
        self.writeSectionHeader(sectionGraphHeader, sectionGraphHeader,
                                outputFile, paragraphs,
                                isAccordion=False)
        # TODO: This section is copy + paste from __writeRoutineDepGraph__
        outputFile.write("<div class=\"contents\">\n")
        # TODO: Copy + paste from GraphGenerator::_generatePackageDependencyGraph
        if totalPackages > 0 and totalPackages <= MAX_DEPENDENCY_LIST_SIZE:
            try:
                # write the image of the dependency graph
                fileNamePrefix = normalizePackageName(packageName) + packageSuffix
                with open(os.path.join(self._outDir, packageName, fileNamePrefix + ".cmapx"), 'r') as cmapFile:
                    # Don't use os.path.join
                    imageFileName = packageName + "/" + fileNamePrefix + ".png"
                    outputFile.write("<img id=\"package%sGraph\" src=\"%s\" border=\"0\" alt=\"Call Graph\" usemap=\"#%s\"/>\n"
                               % (packageSuffix, imageFileName, fileNamePrefix))
                    if self._generatePDFBundle:
                        self.__writeImageToPDF__(imageFileName, paragraphs)
                    # append the content of map outputFile
                    for line in cmapFile:
                        outputFile.write(line)
            except:
                logger.error(e)

        total = "%s, Total: %d " % (sectionListHeader, totalPackages)
        writeSubSectionHeader(total, outputFile)
        # Only write the key if there are packages
        key = """Format:&nbsp;&nbsp;
                        package[# of caller routines(R) -> # of called routines(R):
                        # of global-accessing routines(R) -> # of called globals(G):
                        # of caller fileman files(F) -> # of called fileman files(F):
                        # of caller routines(R) -> # of fileman files accessed via db call(F):
                        # of package components accessing routines(PC) -> # of called routines(R):
                        # of caller globals(G) -> # of called routines (R):
                        # of caller globals(G) -> # of called globals (G):"""
        outputFile.write("<h4>%s</h4><BR>\n" % key)
        if self._generatePDFBundle:
            paragraphs.append(Spacer(1, 1))
            paragraphs.append(Paragraph(total, styles['Heading3']))
            paragraphs.append(Spacer(1, 1))
            paragraphs.append(generateParagraph(key))
            paragraphs.append(Spacer(1, 10))

        outputFile.write("<div><table>\n")
        numOfCol = 6
        numOfRow = totalPackages / numOfCol + 1
        if self._generatePDFBundle:
            PDFData = []
        for index in range(numOfRow):
            if self._generatePDFBundle:
                PDFRow = []
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
                    depMetricsList = packagesMerged[depPackage]
                    linkName, tooltip, edgeStyle = getPackageGraphEdgePropsByMetrics(
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
                    if self._generatePDFBundle:
                        PDFRow.append(generateParagraph("%s [%s]" % (depPackageName, linkName)))
            if self._generatePDFBundle and PDFRow:
                PDFData.append(PDFRow)
            outputFile.write("</tr>\n")
        outputFile.write("</table></div>\n")
        if self._generatePDFBundle:
            t = self.__generatePDFTable__(PDFData, numOfCol)
            paragraphs.append(t)
        if self._generatePDFBundle:
            pdf.append(KeepTogether(paragraphs))
        writeSectionEnd(outputFile)
        outputFile.write("</div>\n")

#==============================================================================
#
#==============================================================================
    def writeTitleBlock(self, pageTitle, title, package, outputFile, pdf,
                        extraHtmlHeader=None, extraPDFHeader=None,
                        accordion=True):
        if self._generatePDFBundle:
            self.__writePDFTitleBlock__(title, package, pdf, extraPDFHeader)

        outputFile.write("<title id=\"pageTitle\">%s</title>\n" % pageTitle)
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">\n")
        if package is not None:
            outputFile.write(("<h4>Package: %s</h4>\n"
                               % getPackageHyperLinkByName(package.getName())))
        if extraHtmlHeader:
            outputFile.write("<h4>%s</h4>\n" % extraHtmlHeader)
        outputFile.write("<h1>%s</h1>\n" % title)
        outputFile.write("</div>\n") # _header
        outputFile.write("</div>\n") # headertitle
        outputFile.write("<br/>\n")

        if accordion:
            outputFile.write(ACCORDION)

    def __writePDFTitleBlock__(self, title, package, pdf, extraPDFHeader=None):
        if package is not None:
            pdf.append(Paragraph("Package: %s" % package.getName(), styles['Heading4']))
            pdf.append(Spacer(1, 10))
        if extraPDFHeader:
            pdf.append(Paragraph(extraPDFHeader, styles['Heading4']))
            pdf.append(Spacer(1, 10))
        pdf.append(Paragraph(title, styles['Title']))

    def _writeIndexTitleBlock(self, title, outputFile):
        title = "%s Index List" % title
        outputFile.write("<title>%s</title>"% title)
        outputFile.write("<div class=\"_header\">\n")
        outputFile.write("<div class=\"headertitle\">")
        outputFile.write("<h1>%s</h1>\n" % title)
        outputFile.write("</div>\n") # _header
        outputFile.write("</div>\n") # headertitle
        outputFile.write("<br/>\n")

#===============================================================================
# method to generate a tablized representation of data
#==============================================================================
    def generateTablizedItemList(self, sortedItemList, outputFile,
                                 htmlMappingFunc, nameFunc=None, totalCol=8,
                                 classid="", useColor=True, additionalDetailsURL=""):
        pdfTable = []
        objectCount = 0
        totalNumRoutine = 0
        if sortedItemList:
            totalNumRoutine = len(sortedItemList)
        if totalNumRoutine > 0:
            outputFile.write("<div class=\"contents\"><table>\n")
            numOfRow = totalNumRoutine / totalCol + 1
            for index in range(numOfRow):
                if self._generatePDFBundle:
                    pdfRow = []
                outputFile.write("<tr class=\"%s\">" % classid)
                for i in range(totalCol):
                    position = index * totalCol + i
                    if position < totalNumRoutine:
                        item = sortedItemList[position]
                        linkName = htmlMappingFunc(item)
                        if useColor:
                            borderColorString = findDotColor(item)
                        else:
                            borderColorString = "black"
                        if nameFunc:
                            displayName = nameFunc(item)
                        else:
                            displayName = item
                        outputFile.write("<td style=\"border: 2px solid %s;\" class=\"indexkey\"><a class=\"e1\" href=\"%s\">%s</a>&nbsp;&nbsp;&nbsp;&nbsp;</td>"
                                   % (borderColorString, linkName, displayName))
                        objectCount += 1
                        if self._generatePDFBundle:
                            # format name for pdf
                            displayName = str(displayName)
                            displayName = displayName.replace("<li>", "")
                            displayName = displayName.replace("</li>", " ")
                            displayName = displayName.replace("<ul>", "")
                            displayName = displayName.replace("</ul>", "")
                            displayName = displayName.replace("&sup2", "")
                            lines = displayName.split("<br>")
                            if len(lines) > 1:
                                pdfCell = []
                                for line in lines:
                                    pdfCell.append(generateParagraph((line)))
                                pdfRow.append(pdfCell)
                            else:
                                pdfRow.append(generateParagraph((displayName)))
                outputFile.write("</tr>\n")
                if self._generatePDFBundle and pdfRow:
                    pdfTable.append(pdfRow)
                if objectCount > 1000:
                    outputFile.write("<tr><td colspan=\"%s\">For the entire list of entries see: <a href=\"%s\">Here</a></td></tr>" % (totalCol, additionalDetailsURL) )
                    break
            outputFile.write("</table>\n</div>\n")
        else:
            outputFile.write("<div>\n</div>\n")
        return pdfTable

#===============================================================================
#
#===============================================================================
    def __generatePDFTable__(self, data, columnWidths=None):
        if columnWidths is None:
            # Auto-generated columns
            t = Table(data)
        elif type(columnWidths) is not list:
            # Evenly spaced columns
            columns = columnWidths
            t = Table(data, colWidths=[self.doc.width/columns]*columns)
        else:
            # Custom width columns
            t = Table(data, colWidths=columnWidths)
        t.setStyle(TableStyle([('INNERGRID', (0,0), (-1,-1), 0.25, colors.black),
                               ('BOX', (0,0), (-1,-1), 0.25, colors.black),
                               ('VALIGN', (0,0), (-1,-1), 'TOP'),
                               ]))
        return t

    def __writeImageToPDF__(self, imageFileName, pdf):
        if not os.path.exists(os.path.join(self._outDir, imageFileName)):
            return
        # Get image dimensions so can be scaled (if needed)
        im = PIL.Image.open(os.path.join(self._outDir, imageFileName))
        width, height = letter
        if im.width > width or im.height > height:
            rh = 1.0
            rw = 1.0
            if im.height > height: rh = height / im.height
            if im.width > width: rw = width / im.width
            r = min([rh, rw])
            pdf.append(Image(os.path.join(self._outDir, imageFileName),
                                im.width * r, im.height * r))
        else:
            pdf.append(Image(os.path.join(self._outDir, imageFileName)))

    def __writePDFLegends__(self, pdf):
        pdf.append(Paragraph("Legends:", styles['Heading3']))
        # No color legend in PDFs
        # TODO: Copy + paste from PC_LEGEND
        table = []
        for key, value in COMPONENT_TYPE_DICT.iteritems():
              table.append([key, value])
        # TODO: Columns to fit contents + left aligned
        self.__writeGenericTablizedPDFData__(["Package Component", "Superscript"],
                                             table, pdf)

   # TODO: Copy + paste XINDEXLegend
    def __writePDFXIndexLegend__(self, pdf):
        # TODO: Align left
        pdf.append(Paragraph("Legend:", styles['Heading3']))
        table = []
        table.append([">>", "Not killed explicitly"])
        table.append(["*", "Changed"])
        table.append(["!", "Killed"])
        table.append(["~", "Newed"])
        pdf.append(self.__generatePDFTable__(table))

#===============================================================================
#
#===============================================================================
    def writeGenericTablizedHtmlData(self, headerList, itemList, outputFile, classid):
        outputFile.write("<div><table>\n")
        if headerList:
            outputFile.write("<tr class=\"%s\" >\n" % (classid))
            for header in headerList:
                outputFile.write("<th class=\"IndexKey\">%s</th>\n" % ( header))
            outputFile.write("</tr>\n")
        for itemRow in itemList:
            writeTableRow(itemRow, outputFile, rowClassId=classid)
        outputFile.write("</table></div></div>\n")  # the second </div> closes the accordion

    def __writeGenericTablizedPDFData__(self, headerList, itemList, pdf,
                                        columnWidths=None, isString=True):
        table = []
        if headerList:
            table.append(generatePDFTableHeader(headerList, False))
        for itemRow in itemList:
            row = []
            for data in itemRow:
                if isString:
                    # Make sure data is a string...
                    data = str(data)
                    # ... and then remove html markup
                    data = data.replace("<para>", "")
                    data = data.replace("</para>", "")
                    data = data.replace("<BR>", "")
                    data = re.sub(r'<a href=".*?\.html">', "", data)
                    data = data.replace("</a>", "")
                    data = re.sub(r'<.*?>', "", data)
                    data = re.sub(r'<.*?', "", data)
                    row.append(generateParagraph((data)))
                else:
                    row.append(data)
                table.append(row)
        t = self.__generatePDFTable__(table, columnWidths)
        pdf.append(t)

#===============================================================================
# method to generate individual package page
#===============================================================================
    def generateIndividualPackagePage(self):
        for packageName in self._allPackages.iterkeys():
            if self._generatePDFBundle:
                self.__setupPDF__(isLandscape=True)
                pdf = []
            else:
                pdf = None

            # Collect the data for this package so we know which sections to
            # include
            package = self._allPackages[packageName]
            #
            dependencyPackages, dependencyPackgesMerged = \
                mergeAndSortDependencyListByPackage(package, True)
            #
            dependentPackages, dependentPackagesMerged = \
                mergeAndSortDependencyListByPackage(package, False)
            # Find all ICR entries that have the package as a "CUSTODIAL Package"
            icrList = self.queryICRInfo(packageName.upper(),"*","*")
            # Separate fileman files and non-fileman globals
            fileManList, globalList = [], []
            allGlobals = package.getAllGlobals()
            for globalVar in allGlobals.itervalues():
                if globalVar.isFileManFile():
                    fileManList.append(globalVar)
                else:
                    globalList.append(globalVar)
            #
            routinesList = package.getAllRoutines().values()

            # Build list of sections with data
            indexList = ["Namespace", "Doc"]
            if dependencyPackages:
                indexList.append("Dependency Graph")
            if dependentPackages:
                indexList.append("Dependent Graph")
            if icrList:
                # Note: This must match the key in 'titleDic' in the
                # 'Package' section (PDF_Script.js). Also, must be
                # different than 'Global' ICR section name.
                icrSectionName = "ICR Entries"
                indexList.append(icrSectionName)
            if fileManList:
                indexList.append("FileMan Files")
            if globalList:
                indexList.append("Non-FileMan Globals")
            if routinesList:
                indexList.append("Routines")
            generatePackageComponents = False
            for keyVal in PACKAGE_COMPONENT_MAP:
                  totalObjectDict = package.getAllPackageComponents(keyVal)
                  if totalObjectDict:
                      generatePackageComponents = True
                      indexList.append(keyVal.replace("_"," "))

            filename = os.path.join(self._outDir, getPackageHtmlFileName(packageName))
            with open(filename, 'w') as outputFile:
                # Write the _header part
                self.__includeHeader__(outputFile)

                pdfList = indexList
                if generatePackageComponents:
                    pdfList.append("Legend Graph")
                self.generateNavigationBar(outputFile, indexList,
                                           printList=pdfList,
                                           packageName=packageName)

                # Title
                title = "Package: %s" % packageName
                self.writeTitleBlock(title, title, None, outputFile, pdf)

                # Namespace
                # Note: We're passing the package here, NOT the packageName
                self.generatePackageNamespaceSection(package, outputFile, pdf)

                # Link to VA documentation (do not write in pdf)
                # Note: We're passing the package here, NOT the packageName
                self.generatePackageDocumentationSection(package, outputFile)

                # Dependency Graph
                if dependencyPackages:
                    self.generatePackageDependencySection(dependencyPackages,
                                                          dependencyPackgesMerged,
                                                          packageName,
                                                          outputFile, pdf, True)
                # Dependent Graph
                if dependentPackages:
                    self.generatePackageDependencySection(dependentPackages,
                                                          dependentPackagesMerged,
                                                          packageName,
                                                          outputFile, pdf, False)

                # ICR Entries
                if icrList:
                    sortedICRList = sorted(icrList, key=lambda item: float(item["NUMBER"]))
                    self.generatePackageSection(icrSectionName, getICRHtmlFileName,
                                                getICRDisplayName, "icrVals",
                                                sortedICRList, outputFile, pdf,
                                                useColor=False)

                # FileMan files
                if fileManList:
                    # sorted by fileMan file No
                    sortedFileManList = sorted(fileManList, key=lambda item: float(item.getFileNo()))
                    # Note: In generateTablizedItemList, number of columns is set to 8
                    self.generatePackageSection("FileMan Files",
                                                getGlobalHtmlFileName,
                                                getGlobalDisplayName, "fmFiles",
                                                sortedFileManList, outputFile, pdf,
                                                pdfColumnWidths=8)

                # Non-FileMan Globals
                if globalList:
                    # sorted by global Name
                    sortedGlobalList = sorted(globalList, key=lambda item: item.getName())
                    self.generatePackageSection("Non-FileMan Globals",
                                                getGlobalHtmlFileName,
                                                getGlobalDisplayName, "nonfmFiles",
                                                sortedGlobalList, outputFile, pdf)

                # Routines
                if routinesList:
                    # sorted by routine Name
                    sortedRoutinesList = sorted(routinesList, key=lambda item: item.getName())
                    self.generatePackageSection("Routines",
                                                getPackageComponentLink,
                                                self.getRoutineDisplayName,
                                                "rtns", sortedRoutinesList,
                                                outputFile, pdf)

                # Package Components
                if generatePackageComponents:
                    outputFile.write(self.legend)
                    if self._generatePDFBundle:
                        pdf.append(Spacer(1, 10))
                        self.__writePDFLegends__(pdf)
                    # Note: We're passing the package here, NOT the packageName
                    self.generatePackageComponentsSections(package, outputFile, pdf)

                self.generateFooterWithNavigationBar(outputFile, indexList)

            if self._generatePDFBundle:
                pdfFileName = os.path.join(self.__getPDFDirectory__(packageName),
                                           getPackagePdfFileName(packageName))
                self.__writePDFFile__(pdf, pdfFileName)

#==============================================================================
# Method to generate Package section
#==============================================================================
    def generatePackageSection(self, sectionName, htmlMappingFunction,
                               nameFunction, classid, sortedDataList,
                               outputFile, pdf, pdfColumnWidths=None,
                               useColor=True):
        pdfSection = []
        self.writeSectionHeader("%s, Total: %d"
                                    % (sectionName, len(sortedDataList)),
                                sectionName, outputFile, pdfSection)
        pdfData = self.generateTablizedItemList(sortedDataList, outputFile,
                                                htmlMappingFunction,
                                                nameFunc=nameFunction,
                                                classid=classid,
                                                useColor=useColor)
        if pdfData and self._generatePDFBundle:
            table = self.__generatePDFTable__(pdfData, pdfColumnWidths)
            pdfSection.append(table)
            pdf.append(KeepTogether(pdfSection))
        writeSectionEnd(outputFile)

#==============================================================================
# Method to generate Package Namespace section info
#==============================================================================
    def generatePackageNamespaceSection(self, package, outputFile, pdf):
        self.writeSectionHeader("Namespace", "Namespace", outputFile, pdf,
                                isAccordion=False)
        outputFile.write("<div class=packageNamespace>")
        namespace = "Namespace: %s" \
                        % listDataToCommaSeperatorString(package.getNamespaces())
        outputFile.write("<div><p><h4 id=\"packageNamespace\">%s</h4></div>" % namespace)
        if self._generatePDFBundle:
            pdf.append(generateParagraph(namespace))
        globalNamespaces = package.getGlobalNamespace()
        if globalNamespaces and len(globalNamespaces) > 0:
            globalNamespace = "Additional Global Namespace: %s" \
                                  % listDataToCommaSeperatorString(globalNamespaces)
            outputFile.write("<div><p><h4 id=\"packageNamespace\">" + globalNamespace + "</h4></div>")
            if self._generatePDFBundle:
                pdf.append(generateParagraph(globalNamespace))
        outputFile.write("</div>")
        writeSectionEnd(outputFile)

#==============================================================================
# Method to generate Package Documentation section info
#==============================================================================
    def generatePackageDocumentationSection(self, package, outputFile):
        self.writeSectionHeader("Documentation", "Doc", outputFile, None,
                                isAccordion=False)
        if len(package.getDocLink()) > 0:
            outputFile.write("<div><p><h4 id=\"packageDocs\">VA documentation in the <a target='blank' href=\"%s\">VistA Documentation Library</a></p></div>" % package.getDocLink())
            if len(package.getDocMirrorLink()) > 0:
                outputFile.write("&nbsp;or&nbsp;<a href=\"%s\">OSEHRA Mirror site</a></h4></div>\n" % package.getDocMirrorLink())
        else:
            outputFile.write("<div><p><h4><a href=\"https://www.va.gov/vdl/\">VA documentation in the VistA Documentation Library</a></h4></p></div>\n")
        writeSectionEnd(outputFile)

#==============================================================================
# Method to generate Package Components sections
#==============================================================================
    def generatePackageComponentsSections(self, package, outputFile, pdf):
        for keyVal in PACKAGE_COMPONENT_MAP:
            totalObjectDict = package.getAllPackageComponents(keyVal)
            if not totalObjectDict:
                continue
            totalComponents  = []
            for value in totalObjectDict.itervalues():
                totalComponents.append(value)
            sortedComponents = sorted(totalComponents, key=lambda x:x.getName())
            componentType = keyVal.replace("_"," ")
            self.generatePackageSection(componentType,
                                        getPackageComponentLink,
                                        self.getPackageComponentDisplayName,
                                        keyVal+"_data", sortedComponents,
                                        outputFile, pdf, 8)


    def __getDataEntryDetailHtmlLink__(self, fileNo, ien):
      return "%s/%s/%s-%s.html" % (VIVIAN_URL, fileNo.replace('.','_'), fileNo, ien)

    def __convertRPCDataReference__(self, variables, routine=None):
        return self.__convertRtnDataReference__(variables, '8994')

    def __convertHL7DataReference__(self, variables, routine=None):
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

    ###########################################################################

    def __convertGlobalVarToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=True,
                                                   routine=routine)

    def __convertNakedGlobaToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=False,
                                                   routine=routine)

    def __convertMarkedItemToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=False,
                                                   routine=routine)

    def __convertLabelReferenceToTableData__(self, variables, routine=None):
        return self.__convertVariableToTableData__(variables, isGlobal=False,
                                                   routine=routine)

    def __convertVariableToTableData__(self, variables, isGlobal=False,
                                       routine=None):
        output = []
        allVars = variables.keys()
        allVars.sort()
        for varName in allVars:
            if varName is None:
              continue
            var = variables[varName]
            if isGlobal and varName in self._allGlobals:
                globalVar = self._allGlobals[varName]
                varName = getFileManFileHyperLinkWithNameFileNo(globalVar)
            lineOccurrencesString = self.__generateLineOccurrencesString__(var.getLineOffsets(), routine)
            output.append(((var.getPrefix()+varName).strip(), lineOccurrencesString))
        return output

    def __convertExternalReferenceToTableData__(self, variables, routine=None):
        output = []
        allVars = sorted(variables.iterkeys(), key=itemgetter(0,1))
        for nameTag in allVars:
            lineOccurrencesString = self.__generateLineOccurrencesString__(variables[nameTag], routine)
            output.append(("%s^%s" %(nameTag[1], getRoutineHypeLinkByName(nameTag[0])),
                           lineOccurrencesString))
        return output

    def __generateLineOccurrencesString__(self, lineOccurrences, routine):
        lineOccurrencesString = ""
        for index, offset in enumerate(lineOccurrences):
            offsetStr = offset
            if routine:
              searchRes = SPLITVAL.search(offset)
              if searchRes:
                  offsetStr = self.__findDataURL__(offset,routine,searchRes.group("splitval"))
            if index > 0:
                lineOccurrencesString += ",&nbsp;"
            lineOccurrencesString += offsetStr
            if (index + 1) % LINE_TAG_PER_LINE == 0:
                lineOccurrencesString += "<BR>"
        return lineOccurrencesString

    def __findDataURL__(self, name, routine, splitStr):
        (field, ienVal) = name.split(splitStr)
        if "+" in ienVal:
            ienVal = ienVal.split("+")[0]
        if splitStr == "DATA":
            datafill = (self.__getDataEntryDetailHtmlLink__(routine.getFileNo(), ienVal), ienVal)
        else:
            datafill = ienVal
        dataLink = DATA_URL_DICT[splitStr] % datafill
        return "<a href=\"#%s\">%s</a>%s" % (field, field, dataLink)

    ###########################################################################

    def __convertFileManDbCallToTableData__(self, variables, routine=None):
        output = []
        fileNos = variables.keys()
        fileNos.sort()
        for fileNo in fileNos:
            varInst, tags = variables[fileNo]
            if varInst.getFileNo() and varInst.isSubFile():
                varName = getFileManSubFileHypeLinkByName(varInst.getFileNo())
            else:
                varName = getFileManFileHyperLinkWithNameFileNo(varInst)
            callTagsStr = ""
            index = 0
            for item in tags:
                if index > 0:
                    callTagsStr += ", &nbsp;"
                if item is None:
                    callTagsStr += "Classic Fileman Calls"
                else:
                    tag, rtn = item.split('^')
                    callTagsStr += tag + '^' + getRoutineHypeLinkByName(rtn)
                index += 1
            output.append((varName, callTagsStr))
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

    ###########################################################################
    # Generator functions
    def __writeRoutineInfoSection__(self, routine, data, header, link,
                                    outputFile, pdf, classid):
        self.writeSectionHeader(header, link, outputFile, pdf, isAccordion=False)
        outputFile.write("<div>")
        for comment in data:
            outputFile.write("<p><span class=\"information %s\">%s</span></p>\n" % (classid, comment))
            if self._generatePDFBundle:
                pdf.append(generateParagraph(comment))
        outputFile.write("</div>")

    def __writeRoutineSourceSection__(self, routine, data, header, link,
                                      outputFile, pdf, classid,
                                      isAccordion=False):
        # Do not write source file link in PDF
        self.writeSectionHeader(header, link, outputFile, None, isAccordion)
        outputFile.write("<div class=\"%s\">" % classid)
        outputFile.write("<p><span class=\"sourcefile\">Source file &lt;<a class=\"el\" href=\"%s\">%s.m</a>&gt;</span></p>"
            % (getRoutineSourceHtmlFileName(routine.getOriginalName()),
               routine.getOriginalName()))
        outputFile.write("</div>\n")

    # Generate routine variables sections
    # (e.g. Local Variables or Global Variables)
    def __writeRoutineVariableSection__(self, routine, data, header, link,
                                        outputFile, pdf, classid, tableHeader,
                                        convFunc):
        if self._generatePDFBundle:
            pdfSection = []
        else:
            pdfSection = None
        self.writeSectionHeader(header, header, outputFile, pdfSection)
        outputFile.write("<div class=\"contents\">\n")
        if header == "Local Variables":
            outputFile.write(XINDEXLegend)
            if self._generatePDFBundle:
                self.__writePDFXIndexLegend__(pdfSection)
                pdfSection.append(Spacer(1, 10))
        outputList = convFunc(data, routine=routine)
        self.writeGenericTablizedHtmlData(tableHeader, outputList, outputFile, classid)
        outputFile.write("</div>\n")
        if self._generatePDFBundle:
            # 'Line Occurrences' column can be really long
            columns = 4
            columnWidth = self.doc.width/columns
            columnWidths = [columnWidth, columnWidth * 3]
            self.__writeGenericTablizedPDFData__(tableHeader, outputList,
                                                 pdfSection, columnWidths)
            pdf.append(KeepTogether(pdfSection))

    ###########################################################################
    def __generateICRInformation__(self, icrVals):
      icrString = ""
      for icrEntry in icrVals:
        icrString += "<li><a href='%s'>ICR #%s</a></li>" % (getICRHtmlFileName(icrEntry),icrEntry["NUMBER"])
        if "STATUS" in icrEntry:
          icrString +="<ul><li>Status: %s</li></ul>" % (icrEntry["STATUS"])
        if "USAGE" in icrEntry:
          icrString +="<ul><li>Usage: %s</li></ul>" % (icrEntry["USAGE"])
      return icrString

    def __generateICRInformationPDF__(self, icrVals): # No links
      icrList = []
      for icrEntry in icrVals:
        icrList.append("ICR #%s" % icrEntry["NUMBER"])
        if "STATUS" in icrEntry:
          icrList.append("Status: %s" % icrEntry["STATUS"])
        if "USAGE" in icrEntry:
          icrList.append("Usage: %s" % icrEntry["USAGE"])
      return generatePDFListData(icrList)

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
          outstring += "<li>%s %s</li>" % (entryDict[key],entry[key].replace('<','&lt').replace('>','&gt'))
      outstring +=  "</ul>"
      return outstring

    def __writeInteractionCommandPDF__(self, entry):
      out = []
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
          text = "%s %s" % (entryDict[key],entry[key])
          # TODO: Want to use 'Preformatted' instead of 'Paragraph' but it
          # doesn't wrap! Filter out problematic characters instead
          text = re.sub(r'<.*?>', "", text)
          text = re.sub(r'<.*?', "", text)
          out.append(ListItem(generateParagraph(text), leftIndent=7))
      return generateList(out)

    def __writeEntryPointSection__(self, routine, data, header, link,
                                   outputFile, pdf, classid, tableHeader):
        self.writeSectionHeader("Entry Points", "Entry Points",
                                outputFile, pdf)
        entryPoints = routine.getEntryPoints()
        tableData = []
        if self._generatePDFBundle:
            pdfData = []
        for entry in entryPoints:
            row = []
            if self._generatePDFBundle:
                pdfRow = []
            comments = entryPoints[entry]["comments"] if entryPoints[entry]["comments"] else ""
            # Build table row
            row.append(entry)
            if self._generatePDFBundle:
                pdfRow.append(generateParagraph(entry))
            val = ""
            if self._generatePDFBundle:
                pdfVal = []
            for line in comments:
                val += line + '<br/>'
                # TODO: Want to use 'Preformatted' instead of 'Paragraph' but it
                # doesn't wrap! Filter out problematic characters instead
                line = re.sub(r'<.*?>', "", line)
                line = re.sub(r'<.*?', "", line)
                if self._generatePDFBundle:
                    pdfVal.append(Paragraph(line, styles['Heading6']))
            row.append(val)
            row.append(self.__generateICRInformation__(entryPoints[entry]["icr"]))
            tableData.append(row)
            if self._generatePDFBundle:
                pdfRow.append(pdfVal)
                pdfRow.append(self.__generateICRInformationPDF__(entryPoints[entry]["icr"]))
                pdfData.append(pdfRow)
        self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid)
        if self._generatePDFBundle:
            self.__writeGenericTablizedPDFData__(tableHeader, pdfData, pdf, isString=False)

    def __writeInteractionSection__(self, routine, data, header, link,
                                    outputFile, pdf, classid, tableHeader):
        self.writeSectionHeader("Interaction Calls", "Interaction Calls",
                                outputFile, pdf)
        calledRtns = routine.getFilteredExternalReference(['DIR','VALM','DDS','DIE','DIC','%ZIS','DIALOG','DIALOGU'])
        if self._generatePDFBundle:
            self.__writePDFInteractionSection__(data, calledRtns, pdf, tableHeader)
        tableData = []
        for entry in data:  # R and W commands
          functionCall = "Function Call: %s" % entry['type']
          row = []
          row.append(functionCall)
          row.append(self.__writeInteractionCommandHTML__(entry))
          tableData.append(row)
        # Write out the entries that are "interaction" routines
        for entry in calledRtns:
          row = []
          row.append("Routine Call")
          val = "<ul>"
          val += "<li>" + entry[0] + "</li>"
          # Nicely show the ENTRYPOINT+OFFSET values for location
          if type(calledRtns[entry]) is list:
            val += "<li>Line Location:</li>"
            val += "<ul>"
            for location in calledRtns[entry]:
              val += "<li>" + location + "</li>"
            val += "</ul>"
          else:
            val += "<li>" + str(calledRtns[entry]) + "</li>"
          val += "</ul>"
          row.append(val)
          tableData.append(row)
        self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid)

    def __writePDFInteractionSection__(self, data, calledRtns, pdf, tableHeader):
        pdfTableData = []
        for entry in data:  # R and W commands
            functionCall = "Function Call: %s" % entry['type']
            pdfRow = []
            pdfRow.append(generateParagraph(functionCall))
            pdfRow.append(self.__writeInteractionCommandPDF__(entry))
            pdfTableData.append(pdfRow)
        # Write out the entries that are "interaction" routines
        for entry in calledRtns:
            pdfRow = []
            pdfRow.append(generateParagraph("Routine Call"))
            pdfVal = []
            pdfVal.append(entry[0])
            # Nicely show the ENTRYPOINT+OFFSET values for location
            if type(calledRtns[entry]) is list:
                pdfVal.append("Line Location:")
                for location in calledRtns[entry]:
                    pdfVal.append(location)
            else:
                pdfVal.append(calledRtns[entry])
            pdfRow.append(generatePDFListData(pdfVal))
            pdfTableData.append(pdfRow)
        self.__writeGenericTablizedPDFData__(tableHeader, pdfTableData, pdf, isString=False)

    ###########################################################################
    # Generator function
    def __writeRoutineDepGraphSection__(self, routine, data, header, link,
                                        outputFile, pdf, classid, isDependency=True):
        pdfSection = []
        self.writeSectionHeader(header, link, outputFile, pdfSection,
                                isAccordion=False)
        # sort the key by Total # of routines
        sortedDepRoutines = sorted(sorted(data.keys()),
                                   key=lambda item: len(data[item]),
                                   reverse=True)

        # Count total number of routines
        # TODO: Copy + paste from GraphGenerator::_generateRoutineDependencyGraph
        totalRoutines = 0
        for callDict in data.itervalues():
            totalRoutines += len(callDict)
        if totalRoutines > 0 and totalRoutines <= MAX_DEPENDENCY_LIST_SIZE:
            self.__writeRoutineDepGraph__(routine, header, outputFile, pdfSection,
                                          isDependency)
        self.__writeRoutineDepTable__(data, header, outputFile, pdfSection,
                                      classid, isDependency)
        if self._generatePDFBundle:
            pdf.append(KeepTogether(pdfSection))

    def __writeRoutineDepGraph__(self, routine, header, outputFile, pdfSection,
                                 isDependency):
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        # TODO: This section is copy + paste from generatePackageDependencySection
        if isDependency:
            routineSuffix = "called"
        else:
            routineSuffix = "caller"
        normalizedRoutineName = normalizeName(routineName)
        fileNamePrefix = "%s_%s" % (normalizedRoutineName, routineSuffix)
        fileName = os.path.join(self._outDir, packageName, fileNamePrefix + ".cmapx")
        try:
            # append the content of map outputFile
            with open(fileName, 'r') as cmapFile:
                if not isDependency:
                    # We don't have enough information to color-code dependency
                    # (call) graphs. The legend is only generated for caller graphs.
                    outputFile.write(self.legend)
                    if self._generatePDFBundle:
                        self.__writePDFLegends__(pdfSection)
                        pdfSection.append(Spacer(1, 10))
                outputFile.write("<div class=\"contents\">\n")
                # Don't use os.path.join
                imageFileName = packageName + "/" + fileNamePrefix + ".png"
                outputFile.write("<img id=\"img_%s\"src=\"%s\" border=\"0\" alt=\"%s\" usemap=\"#%s\"/>\n"
                           % (routineSuffix,
                              urllib.quote(imageFileName),
                              header,
                              fileNamePrefix))
                if self._generatePDFBundle:
                    self.__writeImageToPDF__(imageFileName, pdfSection)
                # Skip first line - id and name are incorrect for routines that
                # start with %
                next(cmapFile)
                # Re-write line with correct id and name
                outputFile.write("<map id=\"%s\" name=\"%s\">"
                                    % (fileNamePrefix, fileNamePrefix))
                for line in cmapFile:
                    outputFile.write(line)
        except Exception, e:
            logger.error(e)

    def __writeRoutineDepTable__(self, data, header, outputFile, pdf,
                                 classid, isDependency):
        tableData = []  # html
        if self._generatePDFBundle:
            pdfTableData = []
        totalNum = 0
        # sort the key by Total # of routines
        sortedDepRoutines = sorted(sorted(data.keys()),
                                   key=lambda item: len(data[item]),
                                   reverse=True)
        for depPackage in sortedDepRoutines:
            routineNameLink = ""
            if self._generatePDFBundle:
                routineName = "" # Printed to PDF, no links
            index = 0
            for depRoutine in sorted(data[depPackage].keys()):
                totalNum += 1
                if isDependency: # append tag information for called routines
                    allTags = data[depPackage][depRoutine].keys()
                    allTags.sort()
                    # format the tag
                    tagString = ",".join(allTags)
                    if len(allTags) > 1:
                        tagString = "(%s)" % tagString
                    tagString += "^"
                    routineNameLink += tagString
                    if self._generatePDFBundle:
                        routineName += tagString
                depRoutineName = depRoutine.getName()
                routineNameLink += "<a href=%s>%s</a>" % (getPackageComponentLink(depRoutine),
                                                          depRoutineName)
                routineNameLink += "&nbsp;&nbsp;"
                if (index + 1) % 8 == 0:
                    routineNameLink += "<BR>"
                if self._generatePDFBundle:
                    routineName += depRoutine.getName()
                    routineName += "  "
                index += 1
            depPackageName = depPackage.getName()
            totalRoutinesInDepPackage = "%d" % len(data[depPackage])
            row = [getPackageHyperLinkByName(depPackageName),
                   totalRoutinesInDepPackage,
                   routineNameLink]
            tableData.append(row)
            if self._generatePDFBundle:
                # No html links in PDF table
                pdfRow = [depPackage.getName(),
                          totalRoutinesInDepPackage,
                          routineName]
                pdfTableData.append(generatePDFTableRow(pdfRow))
        subSectionHeader = "%s Total: %d" % (header, totalNum)
        writeSubSectionHeader(subSectionHeader, outputFile)
        tableHeader = ["Package", "Total", header]
        self.writeGenericTablizedHtmlData(tableHeader, tableData, outputFile, classid)
        if self._generatePDFBundle:
            paragraphs = []
            paragraphs.append(Paragraph(subSectionHeader, styles['Heading3']))
            pdfTableData.append(generatePDFTableHeader(tableHeader, False))
            columns = 10
            columnWidth = self.doc.width/columns
            columnWidths = [columnWidth * 2, columnWidth, columnWidth * 7]
            t = self.__generatePDFTable__(pdfTableData, columnWidths)
            paragraphs.append(t)
            pdf.append(KeepTogether(paragraphs))

    ###########################################################################
    # NOTE: When called with an existingOutFile, we're actually writing a
    # GLOBAL page. When 'isPackageComponent' is True, we're writing a
    # PACKAGE COMPONENT page.
    def __generateIndividualRoutinePage__(self, routine, pdf, platform=None,
                                          existingOutFile=None,
                                          isPackageComponent=False):
        assert routine
        routineName = routine.getName()
        # Note: name must be different so section can be printed in PDF
        #       correctly - see PDF_Script.js.
        if isPackageComponent:
            sourceGenerator = self.__writePackageComponentSourceSection__
            sourceName = "Source Information"
        else:
            sourceGenerator = self.__writeRoutineSourceSection__
            sourceName = "Source"
        # This is a list of sections that might be applicable to a routine
        sectionGenLst = [
           # Name section
           {
             "name": "Info", # this is also the link name
             "header": "Information", # this is the actual display name
             "data": routine.getComment, # the data source
             "generator": self.__writeRoutineInfoSection__, # section generator
             "classid": "header"
           },
           # Source section
           {
             "name": sourceName, # this is also the link name
             "header": "Source Information", # this is the actual display name
             "data": routine.hasSourceCode, # the data source
             "generator": sourceGenerator, # section generator
             "classid": "source"
           },
           # Call Graph section
           {
             "name": "Call Graph", # this is also the link name
             "data": routine.getCalledRoutines, # the data source
             "generator": self.__writeRoutineDepGraphSection__, # section generator
             "classid": "callG"
           },
           # Caller Graph section
           {
             "name": "Caller Graph", # this is also the link name
             "data": routine.getCallerRoutines, # the data source
             "generator": self.__writeRoutineDepGraphSection__, # section generator
             "classid":"callerG",
             "geneargs": [False]
           },
            # Entry Point section
           {
             "name": "Entry Points", # this is also the link name
             "data": routine.getEntryPoints, # the data source
             "generator": self.__writeEntryPointSection__, # section generator
             "geneargs": [ENTRY_POINT_SECTION_HEADER_LIST], # extra argument
             "classid": "entrypoint"
           },
           # External References section
           {
             "name": "External References", # this is also the link name
             "data": routine.getExternalReference, # the data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [PACKAGE_OBJECT_SECTION_HEADER_LIST,
                          self.__convertExternalReferenceToTableData__], # extra argument
             "classid": "external"
           },
           # Interaction Code section
           {
             "name": "Interaction Calls", # this is also the link name
             "data": routine.getInteractionEntries, # the data source
             "generator": self.__writeInteractionSection__, # section generator
             "geneargs": [DEFAULT_VARIABLE_SECTION_HEADER_LIST], # extra argument
             "classid": "interactioncalls"
           },
           # Used in RPC section
           {
             "name": "Used in RPC", # this is also the link name
             "data": self.__getRpcReferences__, # the data source
             "dataarg": [routineName], # extra arguments for data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [RPC_REFERENCE_SECTION_HEADER_LIST,
                          self.__convertRPCDataReference__], # extra argument
             "classid": "rpc"
           },
           # Used in HL7 Interface section
           {
             "name": "Used in HL7 Interface", # this is also the link name
             "data": self.__getHl7References__, # the data source
             "dataarg": [routineName], # extra arguments for data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [HL7_REFERENCE_SECTION_HEADER_LIST,
                          self.__convertHL7DataReference__], # extra argument
             "classid": "hl7"
           },
           # FileMan Files Accessed Via FileMan Db Call section
           {
             "name": "FileMan Files Accessed Via FileMan Db Call", # this is also the link name
             "data": routine.getFilemanDbCallGlobals, # the data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [FILENO_FILEMANDB_SECTION_HEADER_LIST,
                          self.__convertFileManDbCallToTableData__], # extra argument
             "classid": "dbCall"
           },
           # Global Variables Directly Accessed section
           {
             "name": "Global Variables Directly Accessed", # this is also the link name
             "data": routine.getGlobalVariables, # the data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [GLOBAL_VARIABLE_SECTION_HEADER_LIST,
                          self.__convertGlobalVarToTableData__], # extra argument
             "classid": "directAccess"
           },
           # Label References section
           {
             "name": "Label References", # this is also the link name
             "data": routine.getLabelReferences, # the data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [LABEL_REFERENCE_SECTION_HEADER_LIST,
                          self.__convertLabelReferenceToTableData__], # extra argument
             "classid": "label"
           },
           # Naked Globals section
           {
             "name": "Naked Globals", # this is also the link name
             "data": routine.getNakedGlobals, # the data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [PACKAGE_OBJECT_SECTION_HEADER_LIST,
                          self.__convertNakedGlobaToTableData__], # extra argument
             "classid": "naked"
           },
           # Local Variables section
           {
             "name": "Local Variables", # this is also the link name
             "data": routine.getLocalVariables, # the data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [PACKAGE_OBJECT_SECTION_HEADER_LIST,
                          self.__convertVariableToTableData__], # extra argument
             "classid": "local"
           },
           # Marked Items section
           {
             "name": "Marked Items", # this is also the link name
             "data": routine.getMarkedItems, # the data source
             "generator": self.__writeRoutineVariableSection__, # section generator
             "geneargs": [PACKAGE_OBJECT_SECTION_HEADER_LIST,
                          self.__convertMarkedItemToTableData__], # extra argument
             "classid": "marked"
           },
        ]
        package = routine.getPackage()
        if existingOutFile:
            outputFile = existingOutFile
        else:
            htmlFileName = getPackageObjHtmlFileName(routine)
            outputFile = open(os.path.join(self._outDir, htmlFileName), 'w')
            self.__includeHeader__(outputFile)
        if isPackageComponent:
            indexList = []
            idxLst = []
            for idx, item in enumerate(sectionGenLst):
                extraarg = item.get('dataarg', [])
                if item['data'](*extraarg):
                    indexList.append(item['name'])
                    idxLst.append(idx)
        else:
            indexList, idxLst = findRelevantIndex(sectionGenLst, existingOutFile)
        if not existingOutFile:
            self.generateNavigationBar(outputFile, indexList, printList=indexList)
            if isPackageComponent:
                title = routine._title.replace("_"," ") + ": " + routineName
                routineHeader = title
            else:
                title = "Routine: %s" % routineName
                routineHeader = title
                if platform:
                    routineHeader += " Platform: %s" % platform
            self.writeTitleBlock(title, routineHeader, package,
                                 outputFile, pdf,
                                 accordion=not isPackageComponent)
        for idx in idxLst:
            sectionGen = sectionGenLst[idx]
            data = sectionGen['data'](*sectionGen.get('dataarg', []))
            link = sectionGen['name']
            header = sectionGen.get('header', link)
            classid  = sectionGen.get('classid', "")
            geneargs = sectionGen.get('geneargs', []) # optional
            sectionGen['generator'](routine, data, header, link, outputFile,
                                    pdf, classid, *geneargs)
            writeSectionEnd(outputFile)
            if isPackageComponent and header == "Local Variables":
                outputFile.write("</div>\n")
        if not existingOutFile:
            self.generateFooterWithNavigationBar(outputFile, indexList)
            outputFile.close()

#===============================================================================
# Method to generate page for platform-dependent generic routine page
#===============================================================================
    def __generatePlatformDependentGenericRoutinePage__(self, genericRoutine, pdf):
        # Generate the subpage for each platform routines
        platformDepRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in platformDepRoutines.itervalues():
            routineInfo[0]._title = "Routine"
            self.__generateIndividualRoutinePage__(routineInfo[0], pdf,
                                                   routineInfo[1])

        # Generate page for the platform-dependent generic routine page
        indexList = ["Platform Dependent Routines", "Caller Graph"]
        routineName = genericRoutine.getName()
        package = genericRoutine.getPackage()
        filename = os.path.join(self._outDir, getPackageObjHtmlFileName(genericRoutine))
        with open(filename, 'w') as outputFile:
            self.__includeHeader__(outputFile)
            self.generateNavigationBar(outputFile, indexList, printList=indexList)
            title = "Routine: %s" % routineName
            self.writeTitleBlock(title, title, package, outputFile, pdf,
                                 accordion=False)

            # 'Platform Dependent Routines' section
            self.writeSectionHeader("Platform Dependent Routines",
                                    "DepRoutines", outputFile, pdf)
            tableRowList = []
            pdfTableRowList = []
            for routineInfo in platformDepRoutines.itervalues():
                routineName = routineInfo[0].getName()
                platform = routineInfo[1]
                tableRowList.append([getRoutineHypeLinkByName(routineName), platform])
                if self._generatePDFBundle:
                    pdfTableRowList.append([routineName, platform])
            headerList = ["Routine", "Platform"]
            self.writeGenericTablizedHtmlData(headerList, tableRowList, outputFile, "platformDepRoutines")
            if self._generatePDFBundle:
                self.__writeGenericTablizedPDFData__(headerList, pdfTableRowList, pdf)

            # 'Caller Graph' and 'Caller Routines' sections
            callerRoutines = genericRoutine.getCallerRoutines()
            if callerRoutines:
                sectionGraphHeader = "Caller Graph"
                self.__writeRoutineDepGraphSection__(genericRoutine,
                                                     callerRoutines,
                                                     sectionGraphHeader,
                                                     sectionGraphHeader,
                                                     outputFile, pdf,
                                                     "callerG",
                                                     isDependency=False)

            outputFile.write("<br/>\n")
            self.generateFooterWithNavigationBar(outputFile, indexList)

#===============================================================================
# Method to generate all individual Package Components pages
#===============================================================================
    def __writePackageComponentSourceSection__(self, routine, data, header,
                                               link, outputFile, pdf, classid):
        fileNo = PACKAGE_COMPONENT_MAP[routine.getObjectType()]
        sourcePath = os.path.join(self._outDir, "..", fileNo.replace(".",'_'),
                                  "%s-%s.html" % (fileNo, routine.getIEN()))
        self.writeSectionHeader(header, link, outputFile, pdf, isAccordion=False)
        try:
          with open(sourcePath, 'r') as file:
              fileLines = file.readlines()
              outputFile.write("<div><table>")
              if self._generatePDFBundle:
                  pdfRow =[]
                  pdfTableData = []
              outrowString=""
              inPre = False
              # TODO: This is assumes no whitespace. Source file is generated by
              #       FileManGlobalDataParser
              #       (DataTableHtml.py --> outputFileEntryTableList()).
              for line in fileLines[fileLines.index( '<thead>\n'):]:
                if line.strip() == "":
                  continue
                if inPre:
                  outrowString += line
                if "<pre>" in line:
                  inPre = True
                elif "</pre>" in line:
                  if self._generatePDFBundle:
                    pdfRow[1] += outrowString
                  outrowString=""
                  inPre = False
                if self._generatePDFBundle:
                    TDmatch = re.match("<td>(?P<val>.+)(<[/]td>)*", line)
                    DTmatch = re.match("<dt>(?P<val>.+)(<[/]dt>)*", line)
                    if TDmatch:
                      pdfRow.append(TDmatch.groups()[0])
                    elif DTmatch:
                      if len(pdfRow) == 1:
                        pdfRow.append(DTmatch.groups()[0])
                      else:
                        pdfRow[1] += "\n\r" + DTmatch.groups()[0]
                outputFile.write(line.replace('<tr>','<tr class="%s">' % classid).replace('<td>','<td class="IndexValue %s">' % classid).replace('<th>','<th class="indexkey %s">' % classid))
                if self._generatePDFBundle and "</tr>" in line:
                  pdfTableData.append(pdfRow)
                  pdfRow = []
              outputFile.write("</div></table>")
          if self._generatePDFBundle:
              self.__writeGenericTablizedPDFData__(["Name", "Value"], pdfTableData, pdf)
        except:
            outputFile.write("<div><p %s>Source Info Missing</p></div>" % classid)
        writeSectionEnd(outputFile)

    def generatePackageInformationPages(self):
        for keyVal in PACKAGE_COMPONENT_MAP:
            logger.info("Start generating all individual %s......" % keyVal)
            for package in self._allPackages.itervalues():
                for routine in package.getAllPackageComponents(keyVal).itervalues():
                    routine._title = keyVal
                    package = routine.getPackage()
                    packageName = package.getName()
                    if self._generatePDFBundle:
                        self.__setupPDF__()
                    pdf = []
                    self.__generateIndividualRoutinePage__(routine, pdf,
                                                           isPackageComponent=True)
                    if self._generatePDFBundle:
                        pdfFileName = getPackageObjHtmlFileName(routine).replace("html", "pdf")
                        self.__writePDFFile__(pdf, os.path.join(self.__getPDFDirectory__(packageName), pdfFileName))
            logger.info("End of generating all individual %s......", keyVal)

    def generatePackageComponentIndexPage(self, keyVal, outputFile):
        outputFile.write('<div class="componentList" style="display: none;" id=%s>' % keyVal)
        title = keyVal.replace("_"," ")

        indexList = [char for char in string.uppercase]
        indexList.insert(0, "%")
        indexList.insert(0, '0-9')
        indexList.sort()
        components = []
        for package in self._allPackages.itervalues():
            for object in package.getAllPackageComponents(keyVal).itervalues():
                components.append(object)
        sortedComponents = indexList + components
        sortedComponents = sorted(sortedComponents, key=lambda s: str(s).lower())

        totalCol = 4
        self._writeIndex(outputFile, title, totalCol, sortedComponents,
                         getPackageComponentLink,
                         self.getPackageComponentDisplayName, indexList,
                         indexSuffix="_%s" % keyVal)
        outputFile.write('</div>')

    def generatePackageComponentListIndexPage(self):
        with open(os.path.join(self._outDir,"PackageComponents.html"), 'w') as outputFile:
            self.__includeHeader__(outputFile)
            outputFile.write("""
<script type='text/javascript'>
$( document ).ready(function() {
  $(".componentList").first().show()
  $("#componentSelector").on("change", function(event) {
      $(".componentList").hide()
      $("#"+$(event.target).val().replace(/ /g,"_")).show()
  })
})
</script>
            """)
            self._writeIndexTitleBlock("Package Component", outputFile)
            outputFile.write(PC_LEGEND)
            outputFile.write("<div><label for=\"componentSelector\">Select Package Component Type:</label></div>")
            allObjects = PACKAGE_COMPONENT_MAP.keys()
            allObjects.sort()
            outputFile.write("<select id='componentSelector'>")
            for objectKey in allObjects:
                outputFile.write("<option class=\"IndexKey\">%s</option>" % objectKey.replace("_"," "))
            outputFile.write("</select>\n")
            for objectKey in allObjects:
                self.generatePackageComponentIndexPage(objectKey, outputFile)
            outputFile.write(FOOTER)

#===============================================================================
# Method to generate all individual routine pages
#===============================================================================
    def generateAllIndividualRoutinePage(self):
        logger.info("Start generating all individual Routines......")
        totalNoRoutines = len(self._allRoutines)
        routineIndex = 0
        for package in self._allPackages.itervalues():
            packageName = package.getName()
            for routine in package.getAllRoutines().itervalues():
                if (routineIndex + 1) % PROGRESS_METER == 0:
                    logger.info("Processing %d of total %d" % (routineIndex, totalNoRoutines))
                routineIndex += 1
                if self._generatePDFBundle:
                    self.__setupPDF__(isLandscape=True)
                pdf = []
                routine._title = "Routine"
                # handle the special case for platform dependent routine
                if self._crossRef.isPlatformGenericRoutineByName(routine.getName()):
                    self.__generatePlatformDependentGenericRoutinePage__(routine, pdf)
                else:
                    self.__generateIndividualRoutinePage__(routine, pdf)

                if self._generatePDFBundle:
                    pdfRoutineFileName = getRoutinePdfFileName(routine.getName())
                    pdfPackageDir = self.__getPDFDirectory__(packageName)
                    pdfFileName = os.path.join(pdfPackageDir, pdfRoutineFileName)
                    self.__writePDFFile__(pdf, pdfFileName)

        logger.info("End of generating individual routines......")


#===============================================================================
# main
#===============================================================================
def run(args):
    global VIVIAN_URL
    global DOX_URL
    VIVIAN_URL = getViViaNURL(args.local)
    DOX_URL = getDOXURL(args.local)
    icrJsonFile = os.path.abspath(args.icrJsonFile)
    parsedICRJSON = parseICRJson(icrJsonFile)
    crossRef = CrossReferenceBuilder().buildCrossReferenceWithArgs(args,
                                                                   icrJson=parsedICRJSON,
                                                                   inputTemplateDeps=readIntoDictionary(args.inputTemplateDep),
                                                                   sortTemplateDeps=readIntoDictionary(args.sortTemplateDep),
                                                                   printTemplateDeps=readIntoDictionary(args.printTemplateDep)
                                                                   )
    logger.info ("Starting generating web pages....")
    doxDir = os.path.join(args.patchRepositDir, 'Utilities/Dox')
    webPageGen = WebPageGenerator(crossRef,
                                  args.outDir,
                                  args.pdfOutDir,
                                  args.MRepositDir,
                                  doxDir,
                                  args.rtnJson,
                                  args.filesJson,
                                  args.pdf)
    webPageGen.generateWebPage()
    logger.info ("End of generating web pages....")

if __name__ == '__main__':
    crossRefArgParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
        description='VistA Visual Cross-Reference Documentation Generator',
        parents=[crossRefArgParse])
    parser.add_argument('-po', '--pdfOutDir', required=True,
                        help='Output PDF directory')
    parser.add_argument('-rj','--rtnJson', required=True,
                        help='routine reference in VistA data file in JSON format')
    parser.add_argument('-icr','--icrJsonFile', required=True,
                        help='JSON formatted information of DBIA/ICR')
    parser.add_argument('-st','--sortTemplateDep', required=True,
                        help='CSV formatted "Relational Jump" field data for Sort Templates')
    parser.add_argument('-it','--inputTemplateDep', required=True,
                        help='CSV formatted "Relational Jump" field data for Input Templates')
    parser.add_argument('-pt','--printTemplateDep', required=True,
                        help='CSV formatted "Relational Jump" field data for Print Templates')
    parser.add_argument('-local', help='Use links to local DOX pages')
    parser.add_argument('-pdf', action='store_true',
                        help='generate html')
    parser.add_argument('-fj','--filesJson', required=True,
                        help='Repository information in JSON format')
    result = parser.parse_args();

    initLogging(result.logFileDir, DEFAULT_OUTPUT_LOG_FILE_NAME)
    logger.debug(result)


    run(result)
