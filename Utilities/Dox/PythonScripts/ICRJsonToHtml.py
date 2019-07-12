# This module is parses ICR in JSON format and convert to html web page
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
#---------------------------------------------------------------------------

import json
import os.path
import cgi
import io
import re

from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.platypus import KeepTogether, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.pagesizes import letter, inch
from reportlab.lib import colors

from InitCrossReferenceGenerator import parseCrossReferenceGeneratorArgs
from FileManGlobalDataParser import generateSingleFileFieldToIenMappingBySchema
from LogManager import logger
from ICRSchema import ICR_FILE_KEYWORDS_LIST, RPC_FILE_NO, RPC_NAME_FIELD_NO
from ICRSchema import isSubFile, isWordProcessingField, SUBFILE_FIELDS
from UtilityFunctions import getPackageHtmlFileName, getGlobalHtmlFileNameByName
from UtilityFunctions import getRoutineHRefLink, PACKAGE_MAP, normalizePackageName
from UtilityFunctions import generatePDFTableHeader
from UtilityFunctions import getDOXURL, getViViaNURL
from DataTableHtml import outputDataTableHeader, outputDataTableFooter
from DataTableHtml import outputDataListTableHeader
from DataTableHtml import outputLargeDataListTableHeader, outputDataRecordTableHeader
from DataTableHtml import outputFileEntryTableList, safeElementId

# PDF stylesheet
STYLES = getSampleStyleSheet()

DOX_URL = None
VIVIAN_URL = None
FAILURES = []
pgkUpperCaseNameDict = dict()
RPC_NAME_TO_IEN_MAPPING = dict()

# This is the entry point to convert JSON to html web pages and/or PDFs
# It will generate a total ICR summary page as well individual pages for
# each package. It will also generate the pages for each individual ICR
# details.
def convertJson(inputJsonFile, date, MRepositDir, patchRepositDir,
                generateHTML, generatePDF, outDir=None, pdfOutDir=None,
                local=False):
    if not generateHTML and not generatePDF:
        raise Exception("Nothing to generate!")

    global DOX_URL
    global VIVIAN_URL
    DOX_URL = getDOXURL(local)
    VIVIAN_URL = getViViaNURL(local)

    if generateHTML:
        if not outDir:
            raise Exception("Must specify Output directory")
        if not os.path.exists(outDir):
            # Will also create intermediate directories if needed
            os.makedirs(outDir)

    if generatePDF:
        if not pdfOutDir:
            raise Exception("Must specify PDF Output directory")
        # Will also create intermediate directories if needed
        if not os.path.exists(pdfOutDir):
            os.makedirs(pdfOutDir)

    crossRef = parseCrossReferenceGeneratorArgs(MRepositDir,
                                                patchRepositDir)
    global RPC_NAME_TO_IEN_MAPPING
    RPC_NAME_TO_IEN_MAPPING = generateSingleFileFieldToIenMappingBySchema(MRepositDir,
                                                                          crossRef,
                                                                          RPC_FILE_NO,
                                                                          RPC_NAME_FIELD_NO)


    with open(inputJsonFile, 'r') as inputFile:
        pkgJson = {} # group by package
        allpkgJson = []
        inputJson = json.load(inputFile)
        for icrEntry in inputJson:
            if 'NUMBER' not in icrEntry:
                logger.error("Could not parse entry: " + str(icrEntry))
                continue
            if generatePDF:
                _generateICRIndividualPagePDF(icrEntry, date, pdfOutDir)
            if generateHTML:
                _generateICRIndividualPage(icrEntry, date, outDir, crossRef)
                summaryInfo = _convertICREntryToSummaryInfo(icrEntry, crossRef)
                allpkgJson.append(summaryInfo)
                if 'CUSTODIAL PACKAGE' in icrEntry:
                    pkgJson.setdefault(icrEntry['CUSTODIAL PACKAGE'],[]).append(summaryInfo)
        if generateHTML:
            _generateICRSummaryPageImpl(allpkgJson, 'ICR List', 'All', date,
                                        outDir, isForAll=True)
            for pkgName, outJson in pkgJson.iteritems():
                _generateICRSummaryPageImpl(outJson, 'ICR List', pkgName, date,
                                            outDir)
            logger.warn('Total # entry in PACKAGE_MAP is [%s]', len(PACKAGE_MAP))
            logger.warn('Total # entry in pkgJson is [%s]', len(pkgJson))
            _generatePkgDepSummaryPage(inputJson, date, outDir, crossRef)

        # TODO: Log failures

###############################################################################

""" Util function to generate link for the file """
def _getICRIndividualHtmlFileLinkByIen(value, icrEntry, **kargs):
    ien = icrEntry['NUMBER']
    ienDescription = ''
    if "GENERAL DESCRIPTION" in icrEntry:
      for line in icrEntry["GENERAL DESCRIPTION"]:
        if not line:  # Empty string
          ienDescription += '\n'
        else:
          ienDescription += ' ' + cgi.escape(line).replace('"', r"&quot;").replace("'", r"&quot;")
    return '<a title=\"%s\" href=\"%s\">%s</a>' % (ienDescription,'%s/ICR/ICR-%s.html' % 	 (VIVIAN_URL,ien), value)


def _getGeneralDescription(value, icrEntry, **kargs):
    description = ""
    if "GENERAL DESCRIPTION" in icrEntry:
      for line in icrEntry["GENERAL DESCRIPTION"]:
        if not line:  # Empty string
          description += '\n'
        else:
          description += '<br>' + cgi.escape(line).replace('"', r"&quot;").replace("'", r"&quot;")
    return description


def _getPackageHRefLink(pkgName, icrEntry, **kargs):
    global pgkUpperCaseNameDict
    if pkgName in PACKAGE_MAP:
        pkgLink = getPackageHtmlFileName(PACKAGE_MAP[pkgName])
        return '<a href=\"%s/%s\">%s</a>' % (DOX_URL, pkgLink, pkgName)
    crossRef = None
    if 'crossRef' in kargs:
        crossRef = kargs['crossRef']
    if crossRef:
        if not pgkUpperCaseNameDict:
            for name in crossRef.getAllPackages().iterkeys():
                pgkUpperCaseNameDict[name.upper()] = name
        upperName = _normalizeName(pkgName).upper()
        if upperName in pgkUpperCaseNameDict:
            _addToPackageMap(icrEntry, pgkUpperCaseNameDict[upperName])
            return '<a href=\"%s/%s\">%s</a>' % (DOX_URL,
                                                getPackageHtmlFileName(pgkUpperCaseNameDict[upperName]),
                                                pkgName)
        pkg = crossRef.getPackageByName(pkgName)
        if not pkg:
            pkgRename = _normalizeName(pkgName).title()
            pkg = crossRef.getPackageByName(pkgRename)
        if not pkg:
            pkgRename = _normalizeName(pkgName)
            pkg = crossRef.getPackageByName(pkgRename)
        if pkg:
            _addToPackageMap(icrEntry, pkg.getName())
            pkgLink = getPackageHtmlFileName(pkg.getName())
            return '<a href=\"%s/%s\">%s</a>' % (DOX_URL, pkgLink, pkgName)
        else:
            logger.warning('Cannot find mapping for package: [%s]', pkgName)
    return pkgName


def _getFileManFileHRefLink(fileNo, icrEntry, **kargs):
    crossRef = None
    if 'crossRef' in kargs:
        crossRef = kargs['crossRef']
    if crossRef:
        fileInfo = crossRef.getGlobalByFileNo(fileNo)
        if fileInfo:
            linkName = getGlobalHtmlFileNameByName(fileInfo.getName())
            # _addToPackageMap(icrEntry, fileInfo.getPackage().getName())
            return '<a href=\"%s/%s\">%s</a>' % (DOX_URL, linkName, fileNo)
        else:
            logger.warning('Cannot find file: [%s]', fileNo)
    return fileNo


def _getRoutineHRefLink(rtnName, icrEntry, **kargs):
    link = getRoutineHRefLink(rtnName, DOX_URL, **kargs)
    if link is None:
        link = rtnName
    return link


def _getRPCHRefLink(rpcName, icrEntry, **kargs):
    if rpcName in RPC_NAME_TO_IEN_MAPPING:
        filename ="%s-%s.html" % (RPC_FILE_NO, RPC_NAME_TO_IEN_MAPPING[rpcName])
        rpcFilename = "%s/%s/%s" % (VIVIAN_URL, RPC_FILE_NO, filename)
        return '<a href=\"%s\">%s</a>' % (rpcFilename, rpcName)
    return rpcName

""" A list of fields that are part of the summary page for each package or all """
SUMMARY_LIST_FIELDS = [
    ('IA #', 'NUMBER', None),
    ('Name', None, _getICRIndividualHtmlFileLinkByIen),
    ('Type', None, None),
    ('Custodial Package', None, _getPackageHRefLink),
    # ('Custodial ISC', None),
    ('Date Created', None, None),
    ('DBIC Approval Status', None, None),
    ('Status', None, None),
    ('Usage', None, None),
    ('File #', 'FILE NUMBER', _getFileManFileHRefLink),
    ('General Description', None, _getGeneralDescription),
    # ('Global root', None, None),
    ('Remote Procedure', None, _getRPCHRefLink),
    ('Routine', None, _getRoutineHRefLink),
    ('Date Activated', None, None)
]

FIELD_CONVERT_MAP = {
    'FILE NUMBER': _getFileManFileHRefLink,
    'GENERAL DESCRIPTION': _getGeneralDescription,
    'ROUTINE': _getRoutineHRefLink,
    'CUSTODIAL PACKAGE': _getPackageHRefLink,
    'SUBSCRIBING PACKAGE': _getPackageHRefLink,
    'REMOTE PROCEDURE': _getRPCHRefLink
}

# ----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

# Utility function to convert icrEntry to summary info
def _convertICREntryToSummaryInfo(icrEntry, crossRef):
    summaryInfo = [""] * len(SUMMARY_LIST_FIELDS)
    for idx, id in enumerate(SUMMARY_LIST_FIELDS):
        if id[1] and id[1] in icrEntry:
            summaryInfo[idx] = icrEntry[id[1]]
        elif id[0].upper() in icrEntry:
            summaryInfo[idx] = icrEntry[id[0].upper()]
        if summaryInfo[idx] and id[2]:
            summaryInfo[idx] = id[2](summaryInfo[idx], icrEntry, crossRef=crossRef)
    return summaryInfo


def _generatePkgDepSummaryPage(inputJson, date, outDir, crossRef):
    outDep = {}
    for icrItem in inputJson:
        if 'IA #' not in icrItem:
            logger.error("Failed to parse ICR entry " + str(icrItem))
            continue
        curIaNum = icrItem['IA #']
        # ignore the non-active icrs
        if 'STATUS' not in icrItem or icrItem['STATUS'] != 'Active':
            continue
        if 'CUSTODIAL PACKAGE' in icrItem:
            curPkg = icrItem['CUSTODIAL PACKAGE']
            outDep.setdefault(curPkg,{})
            if 'SUBSCRIBING PACKAGE' in icrItem:
                for subPkg in icrItem['SUBSCRIBING PACKAGE']:
                    if 'SUBSCRIBING PACKAGE' in subPkg:
                        subPkgName = subPkg['SUBSCRIBING PACKAGE']
                        if isinstance(subPkgName,list):
                          for subPkgNameEntry in subPkgName:
                            subDep = outDep.setdefault(subPkgNameEntry, {}).setdefault('dependencies',{})
                            subDep.setdefault(curPkg, []).append(curIaNum)
                            curDep = outDep.setdefault(curPkg, {}).setdefault('dependents', {})
                            curDep.setdefault(subPkgNameEntry, []).append(curIaNum)
                        else:
                          subDep = outDep.setdefault(subPkgName, {}).setdefault('dependencies',{})
                          subDep.setdefault(curPkg, []).append(curIaNum)
                          curDep = outDep.setdefault(curPkg, {}).setdefault('dependents', {})
                          curDep.setdefault(subPkgName, []).append(curIaNum)
    """ Convert outDep to html page """
    outFilename = os.path.join(outDir, "ICR-PackageDep.html")
    with open(outFilename, 'w+') as output:
        output.write("<html>\n")
        tName = safeElementId("%s-%s" % ('ICR', 'PackageDep'))
        outputDataListTableHeader(output, tName)
        output.write("<body id=\"dt_example\">")
        output.write("""<div id="container" style="width:80%">""")
        outputDataTableHeader(output, ['Package Name', 'Dependencies Information'], tName)
        """ table body """
        output.write("<tbody>\n")
        """ Now convert the ICR Data to Table data """
        for pkgName in sorted(outDep.iterkeys()):
            output.write("<tr>\n")
            output.write("<td>%s</td>\n" % _getPackageHRefLink(pkgName, {'CUSTODIAL PACKAGE': pkgName}, crossRef=crossRef))
            """ Convert the dependencies and dependent information """
            output.write("<td>\n")
            output.write ("<ol>\n")
            for pkgDepType in sorted(outDep[pkgName].iterkeys()):
                output.write ("<li>\n")
                output.write ("<dt>%s:</dt>\n" % pkgDepType.upper())
                depPkgInfo = outDep[pkgName][pkgDepType]
                for depPkgName in sorted(depPkgInfo.iterkeys()):
                    outputInfo = _getPackageHRefLink(depPkgName, {'CUSTODIAl PACKAGE': depPkgName}, crossRef=crossRef)
                    outputInfo += ': &nbsp;&nbsp Total # of ICRs %s : [' % len(depPkgInfo[depPkgName])
                    for icrNo in depPkgInfo[depPkgName]:
                        outputInfo += _getICRIndividualHtmlFileLinkByIen(icrNo, {'NUMBER': icrNo}, crossRef=crossRef) + '&nbsp;&nbsp'
                    outputInfo += ']'
                    output.write ("<dt>%s:</dt>\n" % outputInfo)
                output.write ("</li>\n")
            output.write ("</ol>\n")
            output.write("</td>\n")
            output.write ("</tr>\n")
        output.write("</tbody>\n")
        output.write("</table>\n")
        if date is not None:
            link = "https://foia-vista.osehra.org/VistA_Integration_Agreement/"
            output.write("<a href=\"%s\">Generated from %s IA Listing Descriptions</a>" % (link, date))
        output.write("</div>\n")
        output.write("</div>\n")
        output.write ("</body></html>\n")


def _generateICRSummaryPageImpl(inputJson, listName, pkgName, date, outDir,
                                isForAll=False):
    listName = listName.strip()
    pkgName = pkgName.strip()
    pkgHtmlName = pkgName
    outFilename = os.path.join(outDir, "%s-%s.html" % (pkgName, listName))
    if not isForAll:
        if pkgName in PACKAGE_MAP:
            pkgName = PACKAGE_MAP[pkgName]
        pkgHtmlName = pkgName + '-ICR.html'
        outFilename = "%s/%s" % (outDir, pkgHtmlName)
    with open(outFilename, 'w+') as output:
        output.write("<html>\n")
        tName = "%s-%s" % (listName.replace(' ', '_'), pkgName.replace(' ', '_'))
        useAjax = _useAjaxDataTable(len(inputJson))
        columnNames = [x[0] for x in SUMMARY_LIST_FIELDS]
        searchColumns = ['IA #', 'Name', 'Custodial Package',
                         'Date Created', 'File #', 'Remote Procedure',
                         'Routine', 'Date Activated', 'General Description']
        hideColumns = ['General Description']
        if useAjax:
            ajaxSrc = '%s_array.txt' % pkgName
            outputLargeDataListTableHeader(output, ajaxSrc, tName,
                                           columnNames, searchColumns,
                                           hideColumns)
        else:
            outputDataListTableHeader(output, tName, columnNames,
                                      searchColumns, hideColumns)
        output.write("<body id=\"dt_example\">")
        output.write("""<div id="container" style="width:80%">""")

        if isForAll:
            output.write("<title id=\"pageTitle\">%s %s</title>" % (pkgName, listName))
        else:
            output.write("<h2 align=\"right\"><a href=\"./All-%s.html\">"
                         "All %s</a></h2>" % (listName, listName))
            output.write("<h1>Package: %s %s</h1>" % (pkgName, listName))
        # pkgLinkName = _getPackageHRefLink(pkgName)
        outputDataTableHeader(output, columnNames, tName)
        outputDataTableFooter(output, columnNames, tName)
        """ table body """
        output.write("<tbody>\n")
        if not useAjax:
            """ Now convert the ICR Data to Table data """
            for icrSummary in inputJson:
                output.write("<tr>\n")
                for item in icrSummary:
                    #output.write("<td class=\"ellipsis\">%s</td>\n" % item)
                    output.write("<td>%s</td>\n" % item)
                output.write("</tr>\n")
        else:
            logger.debug("Ajax source file: %s" % ajaxSrc)
            """ Write out the data file in JSON format """
            outJson = {"aaData": []}
            with open(os.path.join(outDir, ajaxSrc), 'w') as ajaxOut:
                outArray =  outJson["aaData"]
                for icrSummary in inputJson:
                    outArray.append(icrSummary)
                json.dump(outJson, ajaxOut)
        output.write("</tbody>\n")
        output.write("</table>\n")
        if date is not None:
            link = "https://foia-vista.osehra.org/VistA_Integration_Agreement/"
            output.write("<a href=\"%s\">Generated from %s IA Listing Descriptions</a>" % (link, date))
        output.write("</div>\n")
        output.write("</div>\n")
        output.write ("</body></html>\n")


# This is to generate a web page for each individual ICR entry
def _generateICRIndividualPage(icrJson, date, outDir, crossRef):
    ien = icrJson['NUMBER']
    outIcrFile = os.path.join(outDir, 'ICR-' + ien + '.html')
    tName = safeElementId("%s-%s" % ('ICR', ien))
    with open(outIcrFile, 'w') as output:
        output.write("""<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">""")
        output.write ("<html>")
        output.write("""
<script src="https://code.jquery.com/ui/1.11.0/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css" />
""")
        outputDataRecordTableHeader(output, tName)
        output.write("""<script type="text/javascript" src="../dox/PDF_Script.js"></script>""")

        output.write("<div class=\"qindex\">\n")
        output.write("<a onclick=\"writeICRPDF()\" \
                         class=\"qindex\" href=\"#Print\">Print Page as PDF</a>")
        output.write("</div>")

        output.write("<body id=\"dt_example\">")
        output.write("""<div id="container" style="width:80%">""")
        output.write ("<title  id=\"pageTitle\">%s %s (%s)</title>\n" % (icrJson['NAME'], 'ICR', ien))
        output.write ("<h1>%s &nbsp;&nbsp;  %s (%s)</h1>\n" % (icrJson['NAME'], 'ICR', ien))
        outputFileEntryTableList(output, tName)
        # table body
        _icrDataEntryToHtml(output, icrJson, crossRef)
        output.write("</tbody>\n")
        output.write("</table>\n")
        if date is not None:
            # TODO: Add to PDF?
            link = "https://foia-vista.osehra.org/VistA_Integration_Agreement/"
            output.write("<a href=\"%s\">Generated from %s IA Listing Descriptions</a>" % (link, date))
        output.write("</div>\n")
        output.write("</div>\n")
        output.write ("</body></html>")


# This is to generate a pdf for each individual ICR entry
def _generateICRIndividualPagePDF(icrJson, date, pdfOutDir):
    ien = icrJson['NUMBER']
    if 'CUSTODIAL PACKAGE' in icrJson:
        packageName = icrJson['CUSTODIAL PACKAGE']
        pdfOutDir = os.path.join(pdfOutDir, normalizePackageName(packageName))
        if not os.path.exists(pdfOutDir):
            os.mkdir(pdfOutDir)
    else:
        # TODO: PDF will not be included in a package bundle and will not be
        #       accessible from the Dox pages
        logger.warn("Could not find package for: ICR %s" % ien)
    pdfFile = os.path.join(pdfOutDir, 'ICR-' + ien + '.pdf')

    # Setup the pdf document
    buf = io.BytesIO()
    doc = SimpleDocTemplate(
        buf,
        rightMargin=inch/2,
        leftMargin=inch/2,
        topMargin=inch/2,
        bottomMargin=inch/2,
        pagesize=letter,
    )
    pdf = []
    # Title
    pdf.append(Paragraph("%s %s (%s)" % (icrJson['NAME'], 'ICR', ien),
                         STYLES['Heading1']))

    # Table
    _icrDataEntryToPDF(pdf, icrJson, doc)

    try:
        doc.build(pdf)
        with open(pdfFile, 'w') as fd:
            fd.write(buf.getvalue())
    except:
        global FAILURES
        FAILURES.append(pdfFile)


def _icrDataEntryToHtml(output, icrJson, crossRef):
    fieldList = ['NUMBER'] + ICR_FILE_KEYWORDS_LIST
    # As we do not have a real schema to define the field order,
    # we will have to guess the order here
    for field in fieldList:
        if field in icrJson: # we have this field
            value = icrJson[field]
            if isSubFile(field):
                output.write ("<tr>\n")
                output.write("<td>%s</td>\n" % field)
                output.write("<td>\n")
                if isinstance(value, list) and isinstance(value[0], dict):
                    _writeTableOfValue(output, field, value, crossRef)
                else:
                    _icrSubFileToHtml(output, value, field, crossRef)
                output.write("</td>\n")
                output.write ("</tr>\n")
                continue
            value = _convertIndividualFieldValue(field, icrJson, value,
                                                 crossRef)
            output.write ("<tr>\n")
            output.write ("<td>%s</td>\n" % field)
            output.write ("<td>%s</td>\n" % value)
            output.write ("</tr>\n")


def _icrDataEntryToPDF(pdf, icrJson, doc):
    # Write the ICR data as a document (list) instead of
    # a table. Otherwise, the rows can become taller than
    # a page and reportlab will fail to create the pdf.

    fieldList = ['NUMBER'] + ICR_FILE_KEYWORDS_LIST
    # As we do not have a real schema to define the field order,
    # we will have to guess the order here
    description = ""
    for field in fieldList:
        if field in icrJson: # we have this field
            value = icrJson[field]
            if "GLOBAL REFERENCE" == field:
                _writeGlobalReferenceToPDF(value, pdf, doc)
                continue
            ###############################################################
            if "COMPONENT/ENTRY POINT" == field:
                _writeComponentEntryPointToPDF(value, pdf, doc)
                continue
            ###############################################################
            if "GENERAL DESCRIPTION" == field:
                description = []
                description.append(Paragraph('GENERAL DESCRIPTION', STYLES['Heading3']))
                if type(value) is list:
                    for line in value:
                        description.append(Paragraph(cgi.escape(line), STYLES['Normal']))
                else:
                    description.append(Paragraph(cgi.escape(value), STYLES['Normal']))
                if description:
                    pdf.append(KeepTogether(description))
                continue
            ###############################################################
            if isSubFile(field):
                pdf.append(Paragraph(field, STYLES['Heading3']))
                _icrSubFileToPDF(pdf, value, field)
                continue
            #####################################################
            value = _convertIndividualFieldValuePDF(field, value)
            row = []
            row.append(Paragraph(field, STYLES['Heading3']))
            row.append(value)
            pdf.append(KeepTogether(row))


def _writeGlobalReferenceToPDF(section, pdf, doc):
    for globalReference in section:
        globalReferenceSection = []
        name = globalReference["GLOBAL REFERENCE"]
        globalReferenceSection.append(Paragraph("%s : %s" % ("globalReference", name), STYLES['Heading3']))
        if 'GLOBAL DESCRIPTION' in globalReference:
            # TODO: Each line should be its own Paragraph
            description = globalReference["GLOBAL DESCRIPTION"]
            globalReferenceSection.append(_convertIndividualFieldValuePDF('GLOBAL DESCRIPTION', " ".join(description), True))
            globalReferenceSection.append(Spacer(1, 20))
        if 'FIELD NUMBER' in globalReference:
            fieldNumber = globalReference["FIELD NUMBER"]
            table = []
            fieldList = SUBFILE_FIELDS['FIELD NUMBER']
            if 'FIELD NUMBER' in fieldList:  # TODO: How does this happen?
                fieldList.remove('FIELD NUMBER')
            header = ["FIELD #"] + SUBFILE_FIELDS['FIELD NUMBER']
            header = [x if x != "LOCATION" else "LOC." for x in header]
            table.append(generatePDFTableHeader(header))
            for f in fieldNumber:
                if type(f) is dict:
                    row =[]
                    row.append(_convertIndividualFieldValuePDF('FIELD NUMBER', f['FIELD NUMBER'], False))
                    for field in SUBFILE_FIELDS['FIELD NUMBER']:
                        if field in f:
                            row.append(_convertIndividualFieldValuePDF(field, f[field], False, False))
                        else:
                            row.append(Paragraph("", STYLES['Normal']))
                    table.append(row)
            columns = 12
            columnWidth = doc.width/columns
            t = Table(table,
                      colWidths=[columnWidth, columnWidth*2, columnWidth*2, columnWidth*6, columnWidth])
            t.setStyle(TableStyle([('INNERGRID', (0,0), (-1,-1), 0.25, colors.black),
                                  ('BOX', (0,0), (-1,-1), 0.25, colors.black),
                                  ]))
            globalReferenceSection.append(t)
            pdf.append(KeepTogether(globalReferenceSection))


def _writeComponentEntryPointToPDF(section, pdf, doc):
  for component in section:
    componentSection = []
    name = component["COMPONENT/ENTRY POINT"]
    componentSection.append(Paragraph("%s : %s" % ("COMPONENT/ENTRY POINT", name), STYLES['Heading3']))
    if 'COMPONENT DESCRIPTION' in component:
        # TODO: Each line should be its own Paragraph
        description = component["COMPONENT DESCRIPTION"]
        if type(description) is list:
            description = " ".join(description)
        componentSection.append(_convertIndividualFieldValuePDF('COMPONENT DESCRIPTION', description, True))
        componentSection.append(Spacer(1, 20))
    if 'VARIABLES' in component:
        variables = component["VARIABLES"]
        table = []
        table.append(generatePDFTableHeader(["VARIABLES", "TYPE", "VARIABLES DESCRIPTION"]))
        for variable in variables:
            if type(variable) is dict:
                row =[]
                _variables = variable['VARIABLES']
                if type(_variables) is list:
                    _variables = _variables[0]
                    if "-" in _variables:
                        # TODO: This is a workaround for an error in original
                        # file, see ICR-639.
                        variable['VARIABLES'] = _variables.split("-")[0]
                        variable['VARIABLES DESCRIPTION'] = _variables.split("-")[1]
                    else:
                        # TODO: ICR-5317 VARIABLES are not
                        # parsed correctly. Skip them for now.
                        variable['VARIABLES'] = ""
                row.append(_convertIndividualFieldValuePDF('VARIABLES', variable['VARIABLES'], False))
                if 'TYPE' in variable:
                    if type(variable['TYPE']) is list:
                        # TODO: ICR-6551 VARIABLES are not
                        # parsed correctly. Skip them for now.
                        variable['TYPE'] = ""
                    row.append(_convertIndividualFieldValuePDF('TYPE', variable['TYPE'], False, False))
                else:
                    row.append(Paragraph("", STYLES['Normal']))
                if 'VARIABLES DESCRIPTION' in variable:
                    description = variable['VARIABLES DESCRIPTION']
                    if type(description) is list:
                        description = " ".join(description)
                        if len(description) > 1000:
                            # TODO: Skipping long descriptions for now
                            # See ICR-2916, ICR-3486, etc.
                            description = ""
                    row.append(_convertIndividualFieldValuePDF('VARIABLES DESCRIPTION', description, False, False))
                else:
                    row.append(Paragraph("", STYLES['Normal']))
                table.append(row)
            else:
                # TODO: Parsing error! See ICR-28
                pass
        columns = 10
        columnWidth = doc.width/columns
        t = Table(table, colWidths=[columnWidth*2, columnWidth, columnWidth*7])
        t.setStyle(TableStyle([('INNERGRID', (0,0), (-1,-1), 0.25, colors.black),
                              ('BOX', (0,0), (-1,-1), 0.25, colors.black),
                              ]))
        componentSection.append(t)
    pdf.append(KeepTogether(componentSection))

def _writeTableOfValue(output, field, value, crossRef):
  headerList = set()
  # Finds the longest header list to write out as table header
  for entry in value:
      headerList.update(set(entry.keys()))

  if len(headerList) == 1:
      val = headerList.pop()
      if len(value) == 1:
          # A single value in a single column, write as a regular field
          output.write(_convertIndividualFieldValue(val, entry, entry[val], crossRef))
      else:
          # A single column, write as a list
          output.write("<ul>\n")
          for entry in value:
              output.write("<li>%s</li>\n" %
                              _convertIndividualFieldValue(val, entry, entry[val], crossRef))
          output.write("</ul>\n")
      return

  # Make sure the header list is in a known order, with the field name first
  headerList = list(headerList)
  headerList.sort()
  if field in headerList:
    headerList.remove(field)
    headerList.insert(0, field)

  # Start table with the table header
  output.write("<table><thead><tr>\n")
  for val in headerList:
      output.write("<th>%s</th>\n" % val)
  output.write("</tr></thead><tbody>\n")
  # Loop through each value again to create a row
  for entry in value:
    # Find the result based on the header "key"
    for val in headerList:
      if val in entry:
        if (type(entry[val]) is list) and (type(entry[val][0]) is dict):
          if val == "VARIABLES" and entry[val][0]["VARIABLES"] and type(entry[val][0]["VARIABLES"]) is list:
            # This is a workaround for an error in original file,
            # VARIABLES section is not formatted correctly
            variables = entry[val][0]["VARIABLES"][0]
            # ICR-5317
            if "Type:" in variables:
                # <variableName> Type: <variable type> <description>
                ICR_5317_REGEX = re.compile("^(?P<varName>[A-Z]+)\s+Type:\s+(?P<varType>[A-Za-z]+)\s*(?P<description>.*)")
                ret = ICR_5317_REGEX.search(variables)
                entry[val][0]['VARIABLES'] = ret.group('varName')
                entry[val][0]['TYPE'] = ret.group('varType')
                entry[val][0]['VARIABLES DESCRIPTION'] = ret.group('description')
            else:
                # ICR-639
                entry[val][0]['VARIABLES'] = variables.split("-")[0]
                entry[val][0]['VARIABLES DESCRIPTION'] = variables.split("-")[1]
          output.write("<td>\n")
          _writeTableOfValue(output, val, entry[val], crossRef)
          output.write("</td>\n")
        else:
          output.write("<td>%s</td>\n" % _convertIndividualFieldValue(val, entry, entry[val], crossRef))
      # Not existing equals a blank box
      else:
        output.write("<td></td>\n")
    output.write("</tr>\n")
  output.write("</tbody></table>\n")

def _icrSubFileToHtml(output, icrJson, subFile, crossRef):
    fieldList = SUBFILE_FIELDS[subFile]
    if subFile not in fieldList:
        fieldList.append(subFile)
    for icrEntry in icrJson:
        output.write ("<li>\n")
        for field in fieldList:
            if field in icrEntry: # we have this field
                value = icrEntry[field]
                if isSubFile(field) and field != subFile: # avoid recursive subfile for now
                    if type(value) is list:
                        _writeTableOfValue(output, field, value, crossRef)
                    else:
                        output.write ("<dl><dt>%s:</dt>\n" % field)
                        output.write ("<dd>\n")
                        _icrSubFileToHtml(output, value, field, crossRef)
                        output.write ("</dd></dl>\n")
                    continue
                value = _convertIndividualFieldValue(field, icrEntry, value, crossRef)
                output.write ("<dt>%s:  &nbsp;&nbsp;%s</dt>\n" % (field, value))
        output.write ("</li>\n")


def _icrSubFileToPDF(pdf, icrJson, subFile):
    fieldList = SUBFILE_FIELDS[subFile]
    if subFile not in fieldList:
        fieldList.append(subFile)
    for icrEntry in icrJson:
        for field in fieldList:
            if field in icrEntry: # we have this field
                value = icrEntry[field]
                if isSubFile(field) and field != subFile: # avoid recursive subfile for now
                    _icrSubFileToPDF(pdf, value, field)
                    continue
                pdf.append(_convertIndividualFieldValuePDF(field, value, True))


def _convertIndividualFieldValue(field, icrEntry, value, crossRef):
    if isWordProcessingField(field):
        if type(value) is list:
            value = "\n".join(value)
        value = '<pre>\n' + cgi.escape(value) + '\n</pre>\n'
        return value
    if field in FIELD_CONVERT_MAP:
        if type(value) is list:
            return value
        value = FIELD_CONVERT_MAP[field](value, icrEntry, crossRef=crossRef)
        return value
    return value


def _convertIndividualFieldValuePDF(field, value, writeField=False,
                                    keepTogether=True):
    if isWordProcessingField(field):
        if type(value) is list:
            cell = []
            for item in value:
                text = cgi.escape(item)
                if writeField:
                  text = "%s : %s" % (field, text)
                # TODO: "Field:" should not be styled as 'Code'
                cell.append(Paragraph(text, STYLES['Normal']))
            if keepTogether:
                return KeepTogether(cell)
            else:
                return cell
        else:
            text = cgi.escape(value)
            if writeField:
              text = "%s : %s" % (field, text)
            # TODO: "Field:" should not be styled as 'Code'
            return Paragraph(text, STYLES['Normal'])
    if type(value) is list:
        cell = []
        for item in value:
            text = item
            if writeField:
              text = "%s : %s" % (field, text)
            cell.append(Paragraph(text, STYLES['Normal']))
        if keepTogether:
            return KeepTogether(cell)
        else:
            return cell
    else:
        text = value
        if writeField:
            text = "%s : %s" % (field, text)
        return Paragraph(text, STYLES['Normal'])


def _addToPackageMap(icrEntry, pkgName):
    if 'CUSTODIAL PACKAGE' in icrEntry:
        icrPkg = icrEntry['CUSTODIAL PACKAGE']
        if icrPkg not in PACKAGE_MAP:
            PACKAGE_MAP[icrPkg] = pkgName
        elif PACKAGE_MAP[icrPkg] != pkgName:
            logger.warning('[%s] mapped to [%s] and [%s]', icrPkg, PACKAGE_MAP[icrPkg], pkgName)

def _normalizeName(name):
    return name.replace('/', ' ').replace('\'','').replace(',','').replace('.','').replace('&', 'and')


def _useAjaxDataTable(len):
    return len > 4000 # if has more than 4000 entries, use ajax approach
