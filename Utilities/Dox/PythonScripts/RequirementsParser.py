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
import RequirementsXLStoJSON
import RequirementsJSONtoHTML

import argparse
import os
import urllib

from LogManager import initConsoleLogging

def run(args):
    if args.localReq:
      print "Using local Requirements file: %s" % args.localReq
      xlsfileName = args.localReq
    else:
      # First, acquire pages from http://code.osehra.org
      xlsfileName="Open Needs_Epics with BFFs (for Open Source)_July2017.xls"
      print "Downloading %s from http://code.osehra.org" % xlsfileName
      quotedURL = urllib.quote("code.osehra.org/files/requirements/"+xlsfileName)
      urllib.urlretrieve("http://%s" % quotedURL,xlsfileName)
    if args.localPast:
      print "Using local pastData file: %s" % args.localPast
      pastDataFileName = args.localPast
    else:
      pastDataURL= "code.osehra.org/files/requirements/requirements_oldest/requirements.json"
      print "Downloading %s" % pastDataURL
      quotedURL = urllib.quote(pastDataURL)
      urllib.urlretrieve("http://%s" % quotedURL,"oldRequirements.json")
      pastDataFileName = "oldRequirements.json"

    args.ReqJsonFile = os.path.join(args.outdir, "Requirements.json")
    filename = os.path.basename(xlsfileName)[:-5] # Remove '.txt'
    curDate = filename[filename.rfind("_")+1:]
    RequirementsXLStoJSON.convertExcelToJson(xlsfileName, args.ReqJsonFile, pastDataFileName, curDate)
    converter = RequirementsJSONtoHTML.RequirementsConverter(os.path.join(args.outdir,"requirements"))
    converter.convertJsonToHtml(args.ReqJsonFile)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA Requirements Parser')
    parser.add_argument('-o','--outdir', help='path to the output web page directory')
    parser.add_argument('-lr','--localReq', help='path to a local requirements file')
    parser.add_argument('-lp','--localPast', help='path to a local JSON of the previous requirements information')
    result = parser.parse_args()
    initConsoleLogging()
    run(result)