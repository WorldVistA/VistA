from builtins import object
import json
import argparse
import os.path
import cgi
import sys

from LogManager import logger
from DataTableHtml import outputDataTableHeader, outputDataTableFooter
from DataTableHtml import writeTableListInfo, outputDataListTableHeader
from DataTableHtml import outputLargeDataListTableHeader, outputDataRecordTableHeader
from DataTableHtml import outputFileEntryTableList, safeElementId


def createArgParser():
    parser = argparse.ArgumentParser(description='VistA Requirements JSON to Html')
    parser.add_argument('reqJsonFile', help='path to the VistA Requirements JSON file')
    parser.add_argument('outDir', help='path to the output web page directory')
    return parser

fieldList = ["Name",'Id','Description',"BFFLink",'New Service Request','Type', 'Date Updated', "Update Status"]
searchColumnList = ["Name",'Id','Description',"BFFLink",'New Service Request']

allReqs = []
reqSummary=[]
def getReqHTMLLink(reqID, reqEntry, **kargs):
        rpcFilename = '%s-%s.html' % ("BFFReq",reqID )
        return '<a href=\"%s\">%s</a>' % (rpcFilename, reqID)

def convertBFFLinks(linkList, reqEntry, **kargs):
        returnList = []
        for entry in linkList:
          returnList.append('<a href="%s-%s.html">%s</a>' % (entry.replace('/','_'),"Req", entry))
        return returnList
def convertNSRLinks(linkVal, reqEntry, **kargs):
        returnList = []
        if type(linkVal) is list:
          for entry in linkVal:
            returnList.append('<a href="%s-%s.html">%s</a>' % (entry.split(":")[0],"Req", entry))
        else:
          returnList.append( '<a href="%s-%s.html">%s</a>' % (linkVal.split(":")[0],"Req", linkVal))
        return returnList

summary_list_fields = [
    ('name', None, None),
    ('busNeedId', None, getReqHTMLLink),
    ('description', None, None),
    ('BFFlink', None, convertBFFLinks),
    ('NSRLink', None, convertNSRLinks),
    ('type', None, None),
    ('dateUpdated', None, None),
    ('recentUpdate', None, None)
]
class RequirementsConverter(object):
    def __init__(self, outDir):
        self._outDir = outDir

    def _convertReqEntryToSummaryInfo(self, reqEntry):
        summaryInfo = [""]*len(summary_list_fields)
        for idx, id in enumerate(summary_list_fields):
            if id[1] and id[1] in reqEntry:
                summaryInfo[idx] = reqEntry[id[1]]
            elif id[0] in reqEntry:
                summaryInfo[idx] = reqEntry[id[0]]
            if summaryInfo[idx] and id[2]:
                summaryInfo[idx] = id[2](summaryInfo[idx], reqEntry)
        return summaryInfo

    def _reqEntryToHtml(self, output, reqJSON):
        for idx, id in enumerate(summary_list_fields):
            if id[0] in reqJSON: # we have this field
                value = reqJSON[id[0]]
                output.write ("<tr>\n")
                output.write ("<td>%s</td>\n" % fieldList[idx])
                output.write ("<td>%s</td>\n" % value)
                output.write ("</tr>\n")
    def _generateIndividualRequirementsPage(self,reqJSON):
        ien = reqJSON['busNeedId']
        outReqFile = os.path.join(self._outDir, 'BFFReq-' + str(ien) + '.html')
        tName = safeElementId("%s-%s" % ('BFFReq', ien))
        with open(outReqFile, 'w') as output:
            output.write ("<html>")
            outputDataRecordTableHeader(output, tName)
            output.write("<body id=\"dt_example\">")
            output.write("""<div id="container" style="width:80%">""")
            output.write ("<h1>%s (%s) &nbsp;&nbsp;  %s (%s)</h1>\n" % (reqJSON['name'], ien,
                                                              'Req',
                                                              ien))
            outputFileEntryTableList(output, tName)
            """ table body """
            reqSummary = self._convertReqEntryToSummaryInfo(reqJSON)
            for idx,item in enumerate(fieldList):
                output.write("<tr>\n")
                # List of objects should be displayed as a UL object
                output.write("<td>%s</td>"% item)
                if type(reqSummary[idx]) is list:
                  output.write("<td><ul>")
                  for entry in reqSummary[idx]:
                    output.write("<li>%s</li>\n" %  entry)
                  output.write("</ul></td>")
                # Otherwise, write it out as is
                else:
                  output.write("<td>%s</td>\n" %  reqSummary[idx])
                output.write("</tr>\n")
            output.write("</tbody>\n")
            output.write("</table>\n")
            output.write("</div>\n")
            output.write("</div>\n")
            output.write ("</body></html>")
    def convertJsonToHtml(self, inputJsonFile):
        with open(inputJsonFile, 'r') as inputFile:
            inputJson = json.load(inputFile)
            self._generateRequirementsSummaryPage(inputJson)

    def _generateRequirementsSummaryPageImpl(self, inputJson, listName, pkgName, isForAll=False):
        outDir = self._outDir
        listName = listName.strip()
        pkgName = pkgName.strip()
        pkgHtmlName = pkgName.replace('/','_')
        outFilename = "%s/%s-%s.html" % (outDir, pkgName.replace('/','_'), listName)
        if not isForAll:
            outFilename = "%s/%s-Req.html" % (outDir, pkgHtmlName)
        with open(outFilename, 'w+') as output:
            output.write("<html>\n")
            tName = "%s-%s" % (listName.replace(' ', '_'), pkgName.replace(' ', '_'))
            useAjax = False #useAjaxDataTable(len(inputJson))
            columnNames = fieldList
            searchColumns = searchColumnList
            if useAjax:
                ajaxSrc = '%s_array.txt' % pkgName
                outputLargeDataListTableHeader(output, ajaxSrc, tName,
                                                columnNames, searchColumns)
            else:
                outputDataListTableHeader(output, tName, columnNames, searchColumns, hideColumnNames=['Recently Updated'])
            output.write("<body id=\"dt_example\">")
            output.write("""<div id="container" style="width:80%">""")

            if isForAll:
                output.write("<h1>%s %s</h1>" % (pkgName, listName))
                reqData= inputJson
            else:
                reqData=inputJson[pkgName]
                output.write("<h2 align=\"right\"><a href=\"./All-%s.html\">"
                             "All %s</a></h2>" % (listName, listName))
                output.write("<h1>BFF Entry: %s %s</h1>" % (pkgName, listName))
            outputDataTableHeader(output, columnNames, tName)
            outputDataTableFooter(output, columnNames, tName)
            """ table body """
            output.write("<tbody>\n")
            if not useAjax:
                """ Now convert the requirements Data to Table data """
                for reqEntry in reqData:
                    output.write("<tr>\n")
                    if not isForAll:
                      reqSummary = self._convertReqEntryToSummaryInfo(reqEntry);
                      if not reqSummary in allReqs:
                        allReqs.append(reqSummary)
                    else:
                      reqSummary = reqEntry
                    for idx,item in enumerate(fieldList):
                        # List of objects should be displayed as a UL object
                        if type(reqSummary[idx]) is list:
                          output.write("<td><ul>")
                          for entry in reqSummary[idx]:
                            if pkgName in entry:
                              output.write("<li class='disabled'>%s</li>\n" %  entry)
                            else:
                              output.write("<li>%s</li>\n" %  entry)
                          output.write("</ul></td>")
                        # Otherwise, write it out as is
                        else:
                          if pkgName in str(reqSummary[idx]):
                            output.write("<td class='disabled'>%s</td>\n" %  reqSummary[idx])
                          else:
                            output.write("<td>%s</td>\n" %  reqSummary[idx])
                    output.write("</tr>\n")
            else:
                logger.info("Ajax source file: %s" % ajaxSrc)
                """ Write out the data file in JSON format """
                outJson = {"aaData": []}
                with open(os.path.join(outDir, ajaxSrc), 'w') as ajaxOut:
                    outArray =  outJson["aaData"]
                    for reqSummary in inputJson:
                        outArray.append(reqSummary)
                    json.dump(outJson, ajaxOut)
            output.write("</tbody>\n")
            output.write("</table>\n")
            output.write("</div>\n")
            output.write("</div>\n")
            output.write ("</body></html>\n")

    def findNSRValues(self,d,nsrSummary):
      if "NSRLink" in d:
        if type(d["NSRLink"]) is list:
          for entry in d["NSRLink"]:
            NSRVal = entry.split(":")[0]
            if not (NSRVal in nsrSummary):
              nsrSummary[NSRVal] = []
            if not (d in nsrSummary[NSRVal]):
              nsrSummary[NSRVal].append(d)
        else:
          NSRVal = d["NSRLink"].split(":")[0]
          if not (NSRVal in nsrSummary):
            nsrSummary[NSRVal] = []
          if not (d in nsrSummary[NSRVal]):
            nsrSummary[NSRVal].append(d)
      else:
        nsrSummary["NO NSR"].append(d)
      return nsrSummary

    def _generateRequirementsSummaryPage(self, inputJson):
        nsrSummary = {"NO NSR":[]}
        for key in inputJson:
          self._generateRequirementsSummaryPageImpl(inputJson, 'Requirement List', key, False)
          for bffEntry in inputJson[key]:
            nsrSummary= self.findNSRValues(bffEntry,nsrSummary)
            self._generateIndividualRequirementsPage(bffEntry)
        for NSRKey in nsrSummary:
          self._generateRequirementsSummaryPageImpl(nsrSummary, 'Requirement List', NSRKey, False)
        self._generateRequirementsSummaryPageImpl(allReqs, 'Requirement List', "All", True)
