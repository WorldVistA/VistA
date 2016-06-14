""" This module is going to parse ICR in JSON format and convert to html web page
"""
import json
import argparse
from LogManager import logger, initConsoleLogging
from ICRSchema import ICR_FILE_KEYWORDS_LIST
from DataTableHtml import data_table_reference, data_table_list_init_setup
from DataTableHtml import data_table_large_list_init_setup, data_table_record_init_setup
from DataTableHtml import outputDataTableHeader, outputCustomDataTableHeader
from DataTableHtml import writeTableListInfo, outputDataListTableHeader
from DataTableHtml import outputLargeDataListTableHeader, outputDataRecordTableHeader
from DataTableHtml import outputFileEntryTableList, safeElementId, safeFileName

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

    """ Summary page will contain
        IEN: the number field
        Name: The name of the ICR
        Date Created:
        Status:
        Custodial Package:
        Type:
        Usage:
    """
    def _generateICRSummaryPage(self, inputJson):
        listName = 'ICRSummary'
        pkgName = 'All-ICR'
        list_fields = [
            ('IEN', 'NUMBER'),
            ('Name', None),
            ('Type', None),
            ('Custodial Package', None),
            ('Date Created', None),
            ('DBIC Approval Status', None),
            ('Status', None),
            ('Usage', None),
            ('File #', None),
            ('Global root', None),
            ('Remote Procedure', None),
            ('Routine', None),
            ('Date Activated', None),
            ('DBA Comments', 'DBA Comments'),
            ('Custodial ISC', None)
        ]
        outDir = self._outDir
        with open("%s/%s-%s.html" % (outDir, pkgName, listName), 'w+') as output:
            output.write("<html>\n")
            tName = safeElementId("%s-%s" % (listName, pkgName))
            outputDataListTableHeader(output, tName)
            output.write("<body id=\"dt_example\">")
            output.write("""<div id="container" style="width:80%">""")
            output.write("<h1>%s %s List</h1>" % (pkgName, listName))
            # pkgLinkName = getPackageHRefLink(pkgName)
            output.write("<h1>Package: %s %s List</h1>" % (pkgName, listName))
            outputDataTableHeader(output, [x[0] for x in list_fields], tName)
            """ table body """
            output.write("<tbody>\n")
            """ Now convert the ICR Data to Table data """
            for icrEntry in inputJson:
                tableRow = [""]*len(list_fields)
                output.write("<tr>\n")
                for idx, id in enumerate(list_fields):
                    if id[1] == None and id[0].upper() in icrEntry:
                        tableRow[idx] = icrEntry[id[0].upper()]
                    elif id[1] and id[1] in icrEntry:
                        tableRow[idx] = icrEntry[id[1]]
                for item in tableRow:
                    #output.write("<td class=\"ellipsis\">%s</td>\n" % item)
                    output.write("<td>%s</td>\n" % item)
            output.write("</tr>\n")
            output.write("</tbody>\n")
            output.write("</table>\n")
            output.write("</div>\n")
            output.write("</div>\n")
            output.write ("</body></html>\n")

    def _generateICRIndividualPage(self, icrJson):
        pass



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA ICR File Parser')
    parser.add_argument('icrJsonFile', help='path to the VistA ICR JSON file')
    parser.add_argument('outDir', help='path to the output web page directory')
    result = parser.parse_args()
    initConsoleLogging()
    if result.icrJsonFile:
        icrJsonToHtml = ICRJsonToHtml(result.outDir)
        icrJsonToHtml.converJsonToHtml(result.icrJsonFile)