""" This module is going to parse ICR in JSON format and convert to html web page
"""
import json
import argparse
import os.path
import cgi
import logging
from LogManager import logger, initConsoleLogging
from ICRSchema import ICR_FILE_KEYWORDS_LIST, SUBFILE_FIELDS, isSubFile, isWordProcessingField
from WebPageGenerator import getPackageHtmlFileName
from WebPageGenerator import getRoutineHtmlFileName, normalizePackageName
from DataTableHtml import data_table_reference, data_table_list_init_setup
from DataTableHtml import data_table_large_list_init_setup, data_table_record_init_setup
from DataTableHtml import outputDataTableHeader, outputCustomDataTableHeader
from DataTableHtml import writeTableListInfo, outputDataListTableHeader
from DataTableHtml import outputLargeDataListTableHeader, outputDataRecordTableHeader
from DataTableHtml import outputFileEntryTableList, safeElementId, safeFileName

dox_url = "http://code.osehra.org/dox/"
""" Util function to generate link for the fie """
def getICRIndividualHtmlFileLinkByIen(ien):
    return '<a href=\"%s\">%s</a>' % ('ICR-' + ien + '.html', ien)

def getPackageHRefLink(pkgName):
    return pkgName

def getRoutineHRefLink(rtnName):
    return '<a href=\"%s%s\">%s</a>' % (dox_url, getRoutineHtmlFileName(rtnName), rtnName)

""" A list of fields that are part of the summary page for each package or all """
summary_list_fields = [
    ('IEN', 'NUMBER', getICRIndividualHtmlFileLinkByIen),
    ('Name', None, None),
    ('Type', None, None),
    ('Custodial Package', None, getPackageHRefLink),
    # ('Custodial ISC', None),
    ('Date Created', None, None),
    ('DBIC Approval Status', None, None),
    ('Status', None, None),
    ('Usage', None, None),
    ('File #', 'FILE NUMBER', None),
    ('Global root', None, None),
    ('Remote Procedure', None, None),
    ('Routine', None, getRoutineHRefLink),
    ('Date Activated', None, None)
]

class ICRJsonToHtml(object):

    def __init__(self, outDir):
        self._outDir = outDir

    """
    This is the entry point to convert JSON to html web pages

    It will generate a total ICR summary page as well individual pages for each package.
    It will also generate the pages for each individual ICR details

    """

    def converJsonToHtml(self, inputJsonFile):
        with open(inputJsonFile, 'r') as inputFile:
            inputJson = json.load(inputFile)
            self._generateICRSummaryPage(inputJson)


    """ Utility function to convert icrEntry to summary info """
    def _convertICREntryToSummaryInfo(self, icrEntry):
        summaryInfo = [""]*len(summary_list_fields)
        for idx, id in enumerate(summary_list_fields):
            if id[1] and id[1] in icrEntry:
                summaryInfo[idx] = icrEntry[id[1]]
            elif id[0].upper() in icrEntry:
                summaryInfo[idx] = icrEntry[id[0].upper()]
            if id[2]:
                summaryInfo[idx] = id[2](summaryInfo[idx])
        return summaryInfo

    """ Summary page will contain summary information
    """
    def _generateICRSummaryPage(self, inputJson):
        pkgJson = {} # group by package
        allpgkJson = []
        for icrEntry in inputJson:
            # self._generateICRIndividualPage(icrEntry)
            summaryInfo = self._convertICREntryToSummaryInfo(icrEntry)
            allpgkJson.append(summaryInfo)
            if 'CUSTODIAL PACKAGE' in icrEntry:
                pkgJson.setdefault(icrEntry['CUSTODIAL PACKAGE'],[]).append(summaryInfo)
        self._generateICRSummaryPageImpl(allpgkJson, 'ICR List', 'All', True)
        for pkgName, outJson in pkgJson.iteritems():
            self._generateICRSummaryPageImpl(outJson, 'ICR List', pkgName)

    def _generateICRSummaryPageImpl(self, inputJson, listName, pkgName, isForAll=False):
        outDir = self._outDir
        pkgHtmlName = pkgName
        outFilename = "%s/%s-%s.html" % (outDir, pkgName, listName)
        if not isForAll:
            pkgHtmlName = getPackageHtmlFileName(pkgName)
            outFilename = "%s/%s" % (outDir, pkgHtmlName)
        with open(outFilename, 'w+') as output:
            output.write("<html>\n")
            tName = safeElementId("%s-%s" % (listName, pkgName))
            outputDataListTableHeader(output, tName)
            output.write("<body id=\"dt_example\">")
            output.write("""<div id="container" style="width:80%">""")
            if isForAll:
                output.write("<h1>%s %s</h1>" % (pkgName, listName))
            else:
                output.write("<h2 align=\"right\"><a href=\"./All-%s.html\">"
                             "All %s</a></h2>" % (listName, listName))
                output.write("<h1>Package: %s %s</h1>" % (pkgName, listName))
            # pkgLinkName = getPackageHRefLink(pkgName)
            outputDataTableHeader(output, [x[0] for x in summary_list_fields], tName)
            """ table body """
            output.write("<tbody>\n")
            """ Now convert the ICR Data to Table data """
            for icrSummary in inputJson:
                output.write("<tr>\n")
                for item in icrSummary:
                    #output.write("<td class=\"ellipsis\">%s</td>\n" % item)
                    output.write("<td>%s</td>\n" % item)
            output.write("</tr>\n")
            output.write("</tbody>\n")
            output.write("</table>\n")
            output.write("</div>\n")
            output.write("</div>\n")
            output.write ("</body></html>\n")

    """ This is to generate a web page for each individual ICR entry """
    def _generateICRIndividualPage(self, icrJson):
        ien = icrJson['NUMBER']
        outIcrFile = os.path.join(self._outDir, 'ICR-' + ien + '.html')
        tName = safeElementId("%s-%s" % ('ICR', ien))
        with open(outIcrFile, 'w') as output:
            output.write ("<html>")
            outputDataRecordTableHeader(output, tName)
            output.write("<body id=\"dt_example\">")
            output.write("""<div id="container" style="width:80%">""")
            output.write ("<h1>%s (%s) &nbsp;&nbsp;  %s (%s)</h1>\n" % (icrJson['NAME'], ien,
                                                              'ICR',
                                                              ien))
            outputFileEntryTableList(output, tName)
            """ table body """
            self._icrDataEntryToHtml(output, icrJson)
            output.write("</tbody>\n")
            output.write("</table>\n")
            output.write("</div>\n")
            output.write("</div>\n")
            output.write ("</body></html>")

    def _icrDataEntryToHtml(self, output, icrJson):
        fieldList = ICR_FILE_KEYWORDS_LIST
        """ As we do not have a real schema to define the field order,
             we will have to guess the order here
        """
        for field in fieldList:
            if field in icrJson: # we have this field
                value = icrJson[field]
                if isSubFile(field):
                    output.write ("<tr>\n")
                    output.write("<td>%s</td>\n" % field)
                    output.write("<td>\n")
                    output.write ("<ol>\n")
                    self._icrSubFileToHtml(output, value, field)
                    output.write ("</ol>\n")
                    output.write("</td>\n")
                    output.write ("</tr>\n")
                    continue
                if isWordProcessingField(field):
                    if type(value) is list:
                        value = "\n".join(value)
                    value = '<pre>\n' + cgi.escape(value) + '\n</pre>\n'
                output.write ("<tr>\n")
                output.write ("<td>%s</td>\n" % field)
                output.write ("<td>%s</td>\n" % value)
                output.write ("</tr>\n")

    def _icrSubFileToHtml(self, output, icrJson, subFile):
        logger.debug('subFile is %s', subFile)
        logger.debug('icrJson is %s', icrJson)
        fieldList = SUBFILE_FIELDS[subFile]
        if subFile not in fieldList:
            fieldList.append(subFile)
        for icrEntry in icrJson:
            output.write ("<li>\n")
            for field in fieldList:
                if field in icrEntry: # we have this field
                    value = icrEntry[field]
                    logger.debug('current field is %s', field)
                    if isSubFile(field) and field != subFile: # avoid recursive subfile for now
                        logger.debug('field is a subfile %s', field)
                        output.write ("<dl><dt>%s:</dt>\n" % field)
                        output.write ("<dd>\n")
                        output.write ("<ol>\n")
                        self._icrSubFileToHtml(output, value, field)
                        output.write ("</ol>\n")
                        output.write ("</dd></dl>\n")
                        continue
                    if isWordProcessingField(field):
                        if type(value) is list:
                            value = "\n".join(value)
                        value = '<pre>\n' + cgi.escape(value) + '\n</pre>\n'
                    output.write ("<dt>%s:  &nbsp;&nbsp;%s</dt>\n" % (field, value))
            output.write ("</li>\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA ICR JSON to Html')
    parser.add_argument('icrJsonFile', help='path to the VistA ICR JSON file')
    parser.add_argument('outDir', help='path to the output web page directory')
    result = parser.parse_args()
    initConsoleLogging()
    # initConsoleLogging(logging.DEBUG)
    if result.icrJsonFile:
        icrJsonToHtml = ICRJsonToHtml(result.outDir)
        icrJsonToHtml.converJsonToHtml(result.icrJsonFile)