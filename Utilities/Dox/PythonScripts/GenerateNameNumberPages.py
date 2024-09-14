#---------------------------------------------------------------------------
# Copyright 2014 The Open Source Electronic Health Record Agent
# Copyright 2024 Sam Habiel. Fix DOX link.
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
import os
import sys
import re
from datetime import datetime
import glob
import cgi
import re
import json
import argparse

FILE_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.normpath(os.path.join(FILE_DIR, "../../../Scripts"))
if SCRIPTS_DIR not in sys.path:
  sys.path.append(SCRIPTS_DIR)
crossRef = None
from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser, parseCrossRefGeneratorWithArgs
from CrossReference import CrossReference
from UtilityFunctions import getPackageHtmlFileName
from DataTableHtml import outputDataTableHeader, outputCustomDataTableHeader, outputDataTableFooter
from DataTableHtml import outputDataListTableHeader
from LogManager import initLogging, logger

def generateListingPage(outDir, pageData, dataType):
    outDir = os.path.join(outDir, dataType.replace(".", "_"))
    if not os.path.exists(outDir):
      os.mkdir(outDir)
    with open("%s/%s.html" % (outDir, dataType), 'w') as output:
      output.write("<html>\n")
      outputDataListTableHeader(output, dataType, pageData["headers"], pageData["headers"], [])
      output.write("<body id=\"dt_example\">")
      output.write("""<div id="container" style="width:80%">""")
      output.write("<h1> %s Data List</h1>" % (dataType))
      outputCustomDataTableHeader(output, pageData["headers"], dataType)
      output.write("<tbody>\n")
      for object in pageData["records"]:
        object.pop(0)
        output.write("<tr>\n")
        # """ table body """
        for idx, item in enumerate(object):
          pageObject = item
          if idx in [0, 5]:  # Col 0 in Namespace table is namespace, Col 5 in Numberspace table is namespace
            pageObject=""
            allnmsp = item.split(",")
            for nmsp in allnmsp:
              result = crossRef.__categorizeVariableNameByNamespace__(nmsp.strip())
              if result[0] != None:
                pageObject += """<a href='../../dox/%s'>%s</a></br> """ % (getPackageHtmlFileName(result[1].getName()), nmsp)
              else:
                pageObject += nmsp + "</br>"
            output.write("<td>%s</td>\n" % pageObject)
          else:
                output.write("<td>%s</td>\n" % item)
        output.write("</tr>\n")
      output.write("</tbody>\n")
      output.write("</table>\n")
      output.write("</div>\n")
      output.write("</div>\n")
      output.write ("</body></html>\n")

if __name__ == '__main__':
  initParser = createInitialCrossRefGenArgParser()
  parser = argparse.ArgumentParser(
        description='VistA Visual Namespace and Numberspace Generator',
        parents=[initParser])
  parser.add_argument('-o', '--outDir', required=True,
                      help='Output Web Page directory')
  parser.add_argument('-lf', '--logFileDir', required=True,
                      help='Logfile directory')
  parser.add_argument('-nn', '--NameNumberdir', required=True,
                      help='Path to directory with Name/Numberspace listing')
  result = parser.parse_args()
  initLogging(result.logFileDir, "GenerateNameNumberPages.log")
  logger.debug(result)

  for file in glob.glob(os.path.join(result.NameNumberdir, "*.json")):
    jsonData = json.load(open(file, "r"))
    dataType = jsonData["headers"][0]
    if "Number" in dataType:
      dataType = "Numberspace"
    crossRef = parseCrossRefGeneratorWithArgs(result)
    generateListingPage(result.outDir, jsonData, dataType)
