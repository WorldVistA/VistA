# A python script to generate graphs used by the
# Visual Cross Reference Documentation (DOX) pages.
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

import argparse
import os
import re
import subprocess

from multiprocessing.dummy import Pool as ThreadPool

from LogManager import logger, initLogging

from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser

from UtilityFunctions import getPackageHtmlFileName, getPackageDependencyHtmlFile
from UtilityFunctions import getPackageObjHtmlFileName, getPackageGraphEdgePropsByMetrics
from UtilityFunctions import mergeAndSortDependencyListByPackage, normalizePackageName
from UtilityFunctions import normalizeName, parseICRJson, readIntoDictionary
from UtilityFunctions import PACKAGE_COMPONENT_MAP, MAX_DEPENDENCY_LIST_SIZE

class GraphGenerator:
    def __init__(self, crossReference, outDir, docRepDir, dot):
        self._crossRef = crossReference
        self._allPackages = crossReference.getAllPackages()
        self._outDir = outDir
        self._docRepDir = docRepDir
        self._dot = dot
        self._isDependency = False

        # Check for package directories once
        # TODO: Should delete empty directories after graphs are generated?
        for package in self._allPackages.itervalues():
            try:
                packageName = package.getName()
                dirName = os.path.join(self._outDir, packageName)
                if not os.path.exists(dirName):
                    os.makedirs(dirName)
            except OSError, e:
                logger.error("Error making dir %s : Error: %s" % (dirName, e))

    def generateGraphs(self):
        self.generatePackageDependenciesGraph()
        self.generatePackageDependentsGraph()
        self.generateRoutineCallGraph()
        self.generateRoutineCallerGraph()
        self.generateColorLegend()

    #==========================================================================
    ## Methods to generate the package dependency/dependent graphs
    #==========================================================================
    def generatePackageDependenciesGraph(self, isDependency=True):
        # generate all dot file and use dot to generated the image file format
        self._isDependency = isDependency
        if self._isDependency:
            name = "dependencies"
        else:
            name = "dependents"
        logger.info("Start generating package %s......" % name)
        logger.info("Total Packages: %d" % len(self._allPackages))

        # Make the Pool of workers
        pool = ThreadPool(4)
        # Create graphs in their own threads
        pool.map(self._generatePackageDependencyGraph, self._allPackages.values())
        # close the pool and wait for the work to finish
        pool.close()
        pool.join()

        logger.info("End of generating package %s......" % name)

    def generatePackageDependentsGraph(self):
        self.generatePackageDependenciesGraph(False)

    def _generatePackageDependencyGraph(self, package):
        # merge the routine and package list
        depPackages, depPackageMerged = mergeAndSortDependencyListByPackage(package, self._isDependency)
        packageName = package.getName()
        totalPackage = len(depPackageMerged)
        if (totalPackage == 0) or (totalPackage > MAX_DEPENDENCY_LIST_SIZE):
            logger.info("Nothing to do exiting... Package: %s Total: %d " %
                         (packageName, totalPackage))
            return

        dirName = os.path.join(self._outDir, packageName)
        if self._isDependency:
            packageSuffix = "_dependency"
        else:
            packageSuffix = "_dependent"
        normalizedName = normalizePackageName(packageName)
        dotFilename = os.path.join(dirName, "%s%s.dot" % (normalizedName, packageSuffix))
        with open(dotFilename, 'w') as output:
            output.write("digraph %s%s {\n" % (normalizedName, packageSuffix))
            output.write("\tnode [shape=box fontsize=14];\n") # set the node shape to be box
            output.write("\tnodesep=0.35;\n") # set the node sep to be 0.35
            output.write("\transsep=0.55;\n") # set the rank sep to be 0.75
            output.write("\tedge [fontsize=12];\n") # set the edge label and size props
            output.write("\t%s [style=filled fillcolor=orange label=\"%s\"];\n" % (normalizedName,
                                                                                   packageName))
            for depPackage in depPackages:
                depPackageName = depPackage.getName()
                normalizedDepPackName = normalizePackageName(depPackageName)
                output.write("\t%s [label=\"%s\" URL=\"%s\"];\n" % (normalizedDepPackName,
                                                                    depPackageName,
                                                                    getPackageHtmlFileName(depPackageName)))
                depMetricsList = depPackageMerged[depPackage]
                edgeWeight = sum(depMetricsList[0:7:2])
                edgeLinkURL = getPackageDependencyHtmlFile(normalizedName, normalizedDepPackName)
                if self._isDependency:
                    edgeStartNode = normalizedName
                    edgeEndNode = normalizedDepPackName
                    edgeLinkArch = packageName
                    toolTipStartPackage = packageName
                    toolTipEndPackage = depPackageName
                else:
                    edgeStartNode = normalizedDepPackName
                    edgeEndNode = normalizedName
                    edgeLinkArch = depPackageName
                    toolTipStartPackage = depPackageName
                    toolTipEndPackage = packageName
                (edgeLabel, edgeToolTip, edgeStyle) = getPackageGraphEdgePropsByMetrics(depMetricsList,
                                                                                        toolTipStartPackage,
                                                                                        toolTipEndPackage)
                output.write("\t%s->%s [label=\"%s\" weight=%d URL=\"%s#%s\" style=\"%s\" labeltooltip=\"%s\" edgetooltip=\"%s\"];\n" %
                                (edgeStartNode, edgeEndNode, edgeLabel,
                                 edgeWeight, edgeLinkURL, edgeLinkArch,
                                 edgeStyle, edgeToolTip, edgeToolTip))
            output.write("}\n")

        pngFilename = os.path.join(dirName, "%s%s.png" % (normalizedName, packageSuffix))
        cmapxFilename = os.path.join(dirName, "%s%s.cmapx" % (normalizedName, packageSuffix))
        self._generateImagesFromDotFile(pngFilename, cmapxFilename, dotFilename)

    #===============================================================================
    #
    #===============================================================================
    def generateRoutineCallGraph(self, isCalled=True):
        logger.info("Start Routine generating call graph......")
        self._isDependency = isCalled

        # Make a list of all routines we want to process
        allRoutines = []
        for package in self._allPackages.itervalues():
            for routine in package.getAllRoutines().itervalues():
                isPlatformGenericRoutine = self._crossRef.isPlatformGenericRoutineByName(routine.getName())
                if self._isDependency and isPlatformGenericRoutine:
                    platformRoutines = routine.getAllPlatformDepRoutines()
                    for routineInfo in platformRoutines.itervalues():
                        allRoutines.append(routineInfo[0])
                else:
                    allRoutines.append(routine)

        # Add other package components too
        # TODO: This logic is copied from
        #       WebPageGenerator::generatePackageInformationPages(),
        #       could be improved in both places
        for keyVal in PACKAGE_COMPONENT_MAP:
            for package in self._allPackages.itervalues():
                allRoutines.extend(package.getAllPackageComponents(keyVal).itervalues())

        # Make the Pool of workers
        pool = ThreadPool(4)
        # Create graphs in their own threads
        pool.map(self._generateRoutineDependencyGraph, allRoutines)
        # close the pool and wait for the work to finish
        pool.close()
        pool.join()

        logger.info("End of generating call graph......")

    def generateRoutineCallerGraph(self):
        self.generateRoutineCallGraph(False)

    def _generateRoutineDependencyGraph(self, routine):
        package = routine.getPackage()
        if not package:
            return
        routineName = routine.getName()
        packageName = package.getName()
        if self._isDependency:
            depRoutines = routine.getCalledRoutines()
            routineSuffix = "_called"
        else:
            depRoutines = routine.getCallerRoutines()
            routineSuffix = "_caller"

        # do not generate graph if no dep routines or
        # total dep routines > max_dependency_list
        if not depRoutines:
            logger.debug("No called Routines found! for routine:%s package:%s" %
                            (routineName, packageName))
            return
        # Count total number of routines
        totalRoutines = 0
        for callDict in depRoutines.itervalues():
            totalRoutines += len(callDict)
        if totalRoutines > MAX_DEPENDENCY_LIST_SIZE:
            logger.debug("Skipping... Found %d dep routines for routine:%s package:%s (max allowed %d)" %
                            (totalRoutines, routineName, packageName, MAX_DEPENDENCY_LIST_SIZE))
            return

        dirName = os.path.join(self._outDir, packageName)
        normalizedName = normalizeName(routineName)
        normalizedName = normalizedName.replace("$","\$")
        dotFilename = os.path.join(dirName, "%s%s.dot" % (normalizedName, routineSuffix))

        with open(dotFilename, 'wb') as output:
            escapedName = normalizedName.replace("%","\%")
            output.write("digraph \"%s%s\" {\n" % (normalizedName, routineSuffix))
            output.write("\tnode [shape=box fontsize=14];\n") # set the node shape to be box
            output.write("\tnodesep=0.45;\n") # set the node sep to be 0.15
            output.write("\transsep=0.45;\n") # set the rank sep to be 0.75
    #        output.write("\tedge [fontsize=12];\n") # set the edge label and size props
            if package not in depRoutines:
                output.write("\tsubgraph \"cluster_%s\"{\n" % package)
                output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % escapedName)
                output.write("\t}\n")

            for (depPackage, callDict) in depRoutines.iteritems():
                output.write("\tsubgraph \"cluster_%s\"{\n" % depPackage)
                for depRoutine in callDict.keys():
                    normalizedDepName = re.sub("[ /.*?&<>:]", '_', depRoutine.getName())
                    escapedDepRoutineName = normalizedDepName.replace("%","\%")
                    output.write("\t\t\"%s\" [penwidth=2 color=black URL=\"%s\" tooltip=\"%s\"];\n" %
                                    (escapedDepRoutineName,
                                     getPackageObjHtmlFileName(depRoutine),
                                     getPackageObjHtmlFileName(depRoutine)))
                    if str(depPackage) == packageName:
                        output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % escapedName)
                output.write("\t\tlabel=\"%s\";\n" % depPackage)
                output.write("\t}\n")
                for depRoutine in callDict:
                    normalizedDepName = re.sub("[ /.*?&<>:]", '_', depRoutine.getName())
                    escapedDepRoutineName = normalizedDepName.replace("%","\%")
                    if self._isDependency:
                        output.write("\t\t\"%s\"->\"%s\"" % (escapedName, escapedDepRoutineName))
                    else:
                        output.write("\t\t\"%s\"->\"%s\"" % (escapedDepRoutineName, escapedName))
                    output.write(";\n")
            output.write("}\n")

        pngFilename = os.path.join(dirName, "%s%s.png" % (normalizedName, routineSuffix))
        cmapxFilename = os.path.join(dirName, "%s%s.cmapx" % (normalizedName, routineSuffix))
        self._generateImagesFromDotFile(pngFilename, cmapxFilename, dotFilename)

    #==========================================================================
    #  Generate Color legend image
    #==========================================================================
    def generateColorLegend(self):
        self._generateImagesFromDotFile(os.path.join(self._outDir,"colorLegend.png"),
                                        os.path.join(self._outDir,"colorLegend.cmapx"),
                                        os.path.join(self._docRepDir,'callerGraph_color_legend.dot'))

    #==========================================================================

    def _generateImagesFromDotFile(self, pngFilename, cmapxFilename, dotFilename):
        # Generate the image in png format and also cmapx (client side map) to
        # make sure link embeded in the graph is clickable
        # @TODO this should be able to run in parallel
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                                     pngFilename,
                                                                     cmapxFilename,
                                                                     dotFilename)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))


#===============================================================================
# main
#===============================================================================
def run(args):
    logger.info ("Parsing ICR JSON file....")
    icrJsonFile = os.path.abspath(args.icrJsonFile)
    parsedICRJSON = parseICRJson(icrJsonFile)
    logger.info ("Building cross reference....")
    doxDir = os.path.join(args.patchRepositDir, 'Utilities/Dox')
    crossRef = CrossReferenceBuilder().buildCrossReferenceWithArgs(args,
                                                                   icrJson=parsedICRJSON,
                                                                   inputTemplateDeps=readIntoDictionary(args.inputTemplateDep),
                                                                   sortTemplateDeps=readIntoDictionary(args.sortTemplateDep),
                                                                   printTemplateDeps=readIntoDictionary(args.printTemplateDep)
                                                                   )
    logger.info ("Starting generating graphs....")
    graphGenerator = GraphGenerator(crossRef, args.outDir, doxDir, args.dot)
    graphGenerator.generateGraphs()

    logger.info ("End of generating graphs")

if __name__ == '__main__':
    crossRefArgParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
        description='VistA Visual Cross-Reference Graph Generator',
        parents=[crossRefArgParse])
    parser.add_argument('-dot', required=True,
                        help='path to the folder containing dot excecutable')
    parser.add_argument('-icr','--icrJsonFile', required=True,
                        help='JSON formatted information of DBIA/ICR')
    parser.add_argument('-st','--sortTemplateDep', required=True,
                        help='CSV formatted "Relational Jump" field data for Sort Templates')
    parser.add_argument('-it','--inputTemplateDep', required=True,
                        help='CSV formatted "Relational Jump" field data for Input Templates')
    parser.add_argument('-pt','--printTemplateDep', required=True,
                        help='CSV formatted "Relational Jump" field data for Print Templates')
    result = parser.parse_args()

    initLogging(result.logFileDir, "GraphGen.log")
    logger.debug(result)

    run(result)
