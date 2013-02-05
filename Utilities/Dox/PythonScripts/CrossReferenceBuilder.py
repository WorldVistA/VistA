#!/usr/bin/env python

# A Python model to build CrossRefence Python Object Model based on input
#---------------------------------------------------------------------------
# Copyright 2012 The Open Source Electronic Health Record Agent
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

from CallerGraphParser import CallerGraphLogFileParser
from DataDictionaryParser import DataDictionaryListFileLogParser
import os

class CrossReferenceBuilder(object):
    def __init__(self):
        pass
    def buildCrossReference(self, xindexLogDir, codeRepositDir,
                            docRepositDir, filemanSchemaDir=None):
        logParser = CallerGraphLogFileParser()
        packagesDir = os.path.join(codeRepositDir, "Packages")
        logParser.parsePercentRoutineMappingFile(os.path.join(docRepositDir,
                                                "PercentRoutineMapping.csv"))
        logParser.parsePackagesFile(os.path.join(codeRepositDir,
                                                 "Packages.csv"))
        logParser.parsePlatformDependentRoutineFile(os.path.join(docRepositDir,
                                                    "PlatformDependentRoutine.csv"))
        logParser.findGlobalsBySourceV2(packagesDir, "*/Globals/*.zwr")
        routineFilePattern = "*/Routines/*.m"
        logParser.findPackagesAndRoutinesBySource(packagesDir, routineFilePattern)
        logParser.parsePackageDocumentationLink(os.path.join(docRepositDir,
                                                "PackageToVDL.csv"))
        callLogPattern = "*.log"
        logParser.parseAllCallerGraphLog(xindexLogDir, callLogPattern)
        if filemanSchemaDir:
            dataDictLogParser = DataDictionaryListFileLogParser(logParser.getCrossReference())
            dataDictLogParser.parseAllDataDictionaryListLog(filemanSchemaDir,"*.schema")
            dataDictLogParser.parseAllDataDictionaryListLog(filemanSchemaDir,".*.schema")
        logParser.getCrossReference().generateAllPackageDependencies()
        return logParser.getCrossReference()

    def buildCrossReferenceFromMongoDB(self):
        pass