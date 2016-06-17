""" This module is going to parse ICR in JSON format and convert to html web page
"""
import json
import argparse
import os.path
import cgi
import logging
import pprint

from LogManager import logger, initConsoleLogging
from ICRSchema import ICR_FILE_KEYWORDS_LIST, SUBFILE_FIELDS, isSubFile, isWordProcessingField
from WebPageGenerator import getPackageHtmlFileName, getGlobalHtmlFileNameByName
from WebPageGenerator import getRoutineHtmlFileName, normalizePackageName
from DataTableHtml import data_table_reference, data_table_list_init_setup
from DataTableHtml import data_table_large_list_init_setup, data_table_record_init_setup
from DataTableHtml import outputDataTableHeader, outputCustomDataTableHeader
from DataTableHtml import writeTableListInfo, outputDataListTableHeader
from DataTableHtml import outputLargeDataListTableHeader, outputDataRecordTableHeader
from DataTableHtml import outputFileEntryTableList, safeElementId, safeFileName

from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser
from InitCrossReferenceGenerator import parseCrossRefGeneratorWithArgs
from FileManGlobalDataParser import generateSingleFileFieldToIenMappingBySchema

dox_url = "http://code.osehra.org/dox/"

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
    #  u'MASTER PATIENT INDEX',
    'MCCR BACKBILLING' : 'MCCR National Database - Field',
    #  u'MINIMAL PATIENT DATASET',
    #  u'MOBILE SCHEDULING APPLICATIONS SUITE',
    #  u'Missing Patient Register',
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

def normalizeName(name):
    return name.replace('/', ' ').replace('\'','').replace(',','').replace('.','').replace('&', 'and')

def useAjaxDataTable(len):
    return len > 4000 # if has more than 4000 entries, use ajax approach

pgkUpperCaseNameDict = dict()
rpcNameToIenMapping = dict()
RPC_FILE_NO = '8994'
RPC_NAME_FIELD_NO = '.01'

def addToPackageMap(icrEntry, pkgName):
    if 'CUSTODIAL PACKAGE' in icrEntry:
        icrPkg = icrEntry['CUSTODIAL PACKAGE']
        if icrPkg not in pkgMap:
            pkgMap[icrPkg] = pkgName
            logger.debug('[%s] ==> [%s]', icrPkg, pkgName)
        elif pkgMap[icrPkg] != pkgName:
            logger.debug('[%s] mapped to [%s] and [%s]', icrPkg, pkgMap[icrPkg], pkgName)

""" Util function to generate link for the fie """
def getICRIndividualHtmlFileLinkByIen(ien, icrEntry, **kargs):
    return '<a href=\"%s\">%s</a>' % ('ICR-' + ien + '.html', ien)

def getPackageHRefLink(pkgName, icrEntry, **kargs):
    if pkgName in pkgMap:
        pkgLink = getPackageHtmlFileName(pkgMap[pkgName])
        return '<a href=\"%s%s\">%s</a>' % (dox_url, pkgLink , pkgName)
    crossRef = None
    if 'crossRef' in kargs:
        crossRef = kargs['crossRef']
    if crossRef:
        if len(pgkUpperCaseNameDict) == 0 :
            for name in crossRef.getAllPackages().iterkeys():
                pgkUpperCaseNameDict[name.upper()] = name
        upperName = normalizeName(pkgName).upper()
        if upperName in pgkUpperCaseNameDict:
            addToPackageMap(icrEntry, pgkUpperCaseNameDict[upperName])
            return '<a href=\"%s%s\">%s</a>' % (dox_url, getPackageHtmlFileName(pgkUpperCaseNameDict[upperName]) , pkgName)
        pkg = crossRef.getPackageByName(pkgName)
        if not pkg:
            pkgRename = normalizeName(pkgName).title()
            # logger.warn('[%s] renamed as [%s]', pkgName, pkgRename)
            pkg = crossRef.getPackageByName(pkgRename)
        if not pkg:
            pkgRename = normalizeName(pkgName)
            pkg = crossRef.getPackageByName(pkgRename)
        if pkg:
            addToPackageMap(icrEntry, pkg.getName())
            pkgLink = getPackageHtmlFileName(pkg.getName())
            return '<a href=\"%s%s\">%s</a>' % (dox_url, pkgLink , pkgName)
        else:
            logger.debug('Can not find mapping for package: [%s]', pkgName)
    return pkgName

def getFileManFileHRefLink(fileNo, icrEntry, **kargs):
    crossRef = None
    if 'crossRef' in kargs:
        crossRef = kargs['crossRef']
    if crossRef:
        fileInfo = crossRef.getGlobalByFileNo(fileNo)
        if fileInfo:
            linkName = getGlobalHtmlFileNameByName(fileInfo.getName())
            logger.debug('link is [%s]', linkName)
            # addToPackageMap(icrEntry, fileInfo.getPackage().getName())
            return '<a href=\"%s%s\">%s</a>' % (dox_url, linkName, fileNo)
        else:
            logger.debug('Can not find file: [%s]', fileNo)
    return fileNo

def getRoutineHRefLink(rtnName, icrEntry, **kargs):
    crossRef = None
    if 'crossRef' in kargs:
        crossRef = kargs['crossRef']
    if crossRef:
        routine = crossRef.getRoutineByName(rtnName)
        if routine:
            logger.debug('Routine Name is %s, package: %s', routine.getName(), routine.getPackage())
            # addToPackageMap(icrEntry, routine.getPackage().getName())
            return '<a href=\"%s%s\">%s</a>' % (dox_url, getRoutineHtmlFileName(routine.getName()), rtnName)
        else:
            logger.debug('Can not find routine [%s]', rtnName)
            logger.debug('After Categorization: routine: [%s], info: [%s]', rtnName, crossRef.categorizeRoutineByNamespace(rtnName))
    return rtnName

def getRPCHRefLink(rpcName, icrEntry, **kargs):
    if rpcName in rpcNameToIenMapping:
        rpcFilename = '%s-%s.html' % (RPC_FILE_NO, rpcNameToIenMapping[rpcName])
        return '<a href=\"%s\">%s</a>' % (rpcFilename, rpcName)
    return rpcName

""" A list of fields that are part of the summary page for each package or all """
summary_list_fields = [
    ('IA #', 'NUMBER', getICRIndividualHtmlFileLinkByIen),
    ('Name', None, None),
    ('Type', None, None),
    ('Custodial Package', None, getPackageHRefLink),
    # ('Custodial ISC', None),
    ('Date Created', None, None),
    ('DBIC Approval Status', None, None),
    ('Status', None, None),
    ('Usage', None, None),
    ('File #', 'FILE NUMBER', getFileManFileHRefLink),
    # ('Global root', None, None),
    ('Remote Procedure', None, getRPCHRefLink),
    ('Routine', None, getRoutineHRefLink),
    ('Date Activated', None, None)
]

field_convert_map = {
    'FILE NUMBER': getFileManFileHRefLink,
    'ROUTINE': getRoutineHRefLink,
    'CUSTODIAL PACKAGE': getPackageHRefLink,
    'SUBSCRIBING PACKAGE': getPackageHRefLink,
    'REMOTE PROCEDURE': getRPCHRefLink
}


class ICRJsonToHtml(object):

    def __init__(self, crossRef, outDir):
        self._crossRef = crossRef
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
            if summaryInfo[idx] and id[2]:
                summaryInfo[idx] = id[2](summaryInfo[idx], icrEntry, crossRef=self._crossRef)
        return summaryInfo

    """ Summary page will contain summary information
    """
    def _generateICRSummaryPage(self, inputJson):
        pkgJson = {} # group by package
        allpgkJson = []
        for icrEntry in inputJson:
            self._generateICRIndividualPage(icrEntry)
            summaryInfo = self._convertICREntryToSummaryInfo(icrEntry)
            allpgkJson.append(summaryInfo)
            if 'CUSTODIAL PACKAGE' in icrEntry:
                pkgJson.setdefault(icrEntry['CUSTODIAL PACKAGE'],[]).append(summaryInfo)
        self._generateICRSummaryPageImpl(allpgkJson, 'ICR List', 'All', True)
        for pkgName, outJson in pkgJson.iteritems():
            self._generateICRSummaryPageImpl(outJson, 'ICR List', pkgName)
        logger.warn('Total # entry in pkgMap is [%s]', len(pkgMap))
        logger.warn('Total # entry in pkgJson is [%s]', len(pkgJson))
        pprint.pprint(set(pkgJson.keys()) - set(pkgMap.keys()))
        pprint.pprint(set(pgkUpperCaseNameDict.values()) - set(pkgMap.values()))
        # pprint.pprint(pkgMap)


    def _generateICRSummaryPageImpl(self, inputJson, listName, pkgName, isForAll=False):
        outDir = self._outDir
        pkgHtmlName = pkgName
        outFilename = "%s/%s-%s.html" % (outDir, pkgName, listName)
        if not isForAll:
            if pkgName in pkgMap:
                pkgName = pkgMap[pkgName]
            pkgHtmlName = pkgName + '-ICR.html'
            outFilename = "%s/%s" % (outDir, pkgHtmlName)
        with open(outFilename, 'w+') as output:
            output.write("<html>\n")
            tName = safeElementId("%s-%s" % (listName, pkgName))
            useAjax = useAjaxDataTable(len(inputJson))
            if useAjax:
                ajaxSrc = '%s_array.txt' % pkgName
                outputLargeDataListTableHeader(output, ajaxSrc, tName)
            else:
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
            if not useAjax:
                """ Now convert the ICR Data to Table data """
                for icrSummary in inputJson:
                    output.write("<tr>\n")
                    for item in icrSummary:
                        #output.write("<td class=\"ellipsis\">%s</td>\n" % item)
                        output.write("<td>%s</td>\n" % item)
                        output.write("</tr>\n")
            else:
                logging.info("Ajax source file: %s" % ajaxSrc)
                """ Write out the data file in JSON format """
                outJson = {"aaData": []}
                with open(os.path.join(outDir, ajaxSrc), 'w') as ajaxOut:
                    outArray =  outJson["aaData"]
                    for icrSummary in inputJson:
                        outArray.append(icrSummary)
                    json.dump(outJson, ajaxOut)
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
                value = self._convertIndividualFieldValue(field, icrJson, value)
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
                    value = self._convertIndividualFieldValue(field, icrEntry, value)
                    output.write ("<dt>%s:  &nbsp;&nbsp;%s</dt>\n" % (field, value))
            output.write ("</li>\n")

    def _convertIndividualFieldValue(self, field, icrEntry, value):
        if isWordProcessingField(field):
            if type(value) is list:
                value = "\n".join(value)
            value = '<pre>\n' + cgi.escape(value) + '\n</pre>\n'
            return value
        if field in field_convert_map:
            if type(value) is list:
                logger.warn('field: [%s], value:[%s], icrEntry: [%s]', field, value, icrEntry)
                return value
            value = field_convert_map[field](value, icrEntry, crossRef=self._crossRef)
            return value
        return value
    """ This function will read all entries in RPC file file# 8994 and return a mapping
        of RPC Name => IEN.
    """


def createArgParser():
    initParser = createInitialCrossRefGenArgParser()
    parser = argparse.ArgumentParser(description='VistA ICR JSON to Html',
                                     parents=[initParser])
    parser.add_argument('icrJsonFile', help='path to the VistA ICR JSON file')
    parser.add_argument('outDir', help='path to the output web page directory')
    return parser

def createRemoteProcedureMapping(result, crossRef):
    return generateSingleFileFieldToIenMappingBySchema(result.MRepositDir,
                                                       crossRef,
                                                       RPC_FILE_NO,
                                                       RPC_NAME_FIELD_NO)

if __name__ == '__main__':
    parser = createArgParser()
    result = parser.parse_args()
    initConsoleLogging()
    crossRef = parseCrossRefGeneratorWithArgs(result)
    # pprint.pprint(set(crossRef.getAllPackages().keys()))
    # initConsoleLogging(logging.DEBUG)
    if result.icrJsonFile:
        rpcNameToIenMapping = createRemoteProcedureMapping(result, crossRef)
        icrJsonToHtml = ICRJsonToHtml(crossRef, result.outDir)
        icrJsonToHtml.converJsonToHtml(result.icrJsonFile)