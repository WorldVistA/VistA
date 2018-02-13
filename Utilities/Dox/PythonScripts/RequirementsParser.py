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
    # First, acquire pages from http://code.osehra.org
    xlsfileName="Open Needs_Epics with BFFs (for Open Source)_July2017.xls"
    quotedURL = urllib.quote("code.osehra.org/files/requirements/"+xlsfileName)
    urllib.urlretrieve("http://%s" % quotedURL,xlsfileName)
    quotedURL = urllib.quote("code.osehra.org/files/requirements/pastData.json")
    urllib.urlretrieve("http://%s" % quotedURL,"oldRequirements.json")

    args.ReqJsonFile = os.path.join(args.outdir, "Requirements.json")
    filename = os.path.basename(xlsfileName)[:-4] # Remove '.txt'
    curDate = filename[filename.rfind("_")+1:]
    RequirementsXLStoJSON.convertExcelToJson(xlsfileName,args.ReqJsonFile,"oldRequirements.json",curDate)
    converter = RequirementsJSONtoHTML.RequirementsConverter(os.path.join(args.outdir,"requirements"))
    converter.convertJsonToHtml(args.ReqJsonFile)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA Requirements Parser')
    parser.add_argument('outdir', help='path to the output web page directory')
    result = parser.parse_args()
    initConsoleLogging()
    run(result)