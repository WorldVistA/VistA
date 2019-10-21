# ---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Alliance
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
# ---------------------------------------------------------------------------
from future.utils import itervalues
import argparse
import json
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser
from CrossReferenceBuilder import CrossReferenceBuilder
from LogManager import initLogging, logger


def outputAllPackageDependency(crossRef, outputFile):
    dependents = {}
    depends = {}
    routines = {}
    files = {}
    fields = {}
    for pkg in itervalues(crossRef.getAllPackages()):
        pkgName = pkg.getName()
        logger.progress("Processing package %s" % pkgName)
        routines[pkgName] = len(pkg.getAllRoutines())
        numFiles = 0
        numFields = 0
        allGlobals = pkg.getAllGlobals()
        for globalVar in itervalues(allGlobals):
            if globalVar.isFileManFile():
                numFiles += 1
                allFields = globalVar.getAllFileManFields()
                if allFields:
                    numFields += len(allFields)
        files[pkgName] = numFiles
        fields[pkgName] = numFields
        # Collect a set of dependents / depends for each package
        depends[pkgName] = set()
        for depPkgs in [pkg.getPackageRoutineDependencies(),
                        pkg.getPackageGlobalDependencies(),
                        pkg.getPackageFileManFileDependencies(),
                        pkg.getPackageFileManDbCallDependencies()]:
            for depPkg in depPkgs:
                depPkgName = depPkg.getName()
                if depPkgName == pkgName:
                    # Current package, nothing to do
                    continue
                else:
                    # Add to dependency set
                    depends[pkgName].add(depPkgName)

                # Now let's add the current package as a dependent
                if depPkgName not in dependents:
                    dependents[depPkgName] = set()
                dependents[depPkgName].add(pkgName)

    # Build json output
    outJson = []
    for pkgName in depends:
        pkgjson = {'name': pkgName, "depends": list(depends[pkgName])}
        if pkgName in dependents:
            pkgjson['dependents'] = list(dependents[pkgName])
        else:
            pkgjson['dependents'] = []
        pkgjson['routines'] = routines[pkgName]
        pkgjson['files'] = files[pkgName]
        pkgjson['fields'] = fields[pkgName]
        outJson.append(pkgjson)

    # Write json file
    with open(outputFile, "w") as output:
        json.dump(outJson, output)


def main():
    crossRefParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
          description='VistA Cross-Reference Builder',
          parents=[crossRefParse])
    parser.add_argument('-pj', '--pkgDepJson',
                        help='Output JSON file for package dependencies')
    result = parser.parse_args()

    initLogging(result.logFileDir, "GeneratePackageDep.log")
    logger.debug(result)

    crossRefBlder = CrossReferenceBuilder()
    crossRef = crossRefBlder.buildCrossReferenceWithArgs(result)
    crossRef.generateAllPackageDependencies()
    outputAllPackageDependency(crossRef, result.pkgDepJson)


if __name__ == '__main__':
    main()
