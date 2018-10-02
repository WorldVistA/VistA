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

import argparse
import os
import subprocess

from LogManager import logger, initLogging

from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser
from CrossReference import PlatformDependentGenericRoutine

from UtilityFunctions import *

# Do not generate the graph if have more than 30 nodes
MAX_DEPENDENCY_LIST_SIZE = 30

class GraphGenerator:
    def __init__(self, crossReference, outDir, docRepDir, dot):
        self._crossRef = crossReference
        self._allPackages = crossReference.getAllPackages()
        self._outDir = outDir
        self._docRepDir = docRepDir
        self._dot = dot

    def generateGraphs(self):
        self.generatePackageDependenciesGraph()
        self.generatePackageDependentsGraph()
        self.generateRoutineCallGraph()
        self.generateRoutineCallerGraph()
        self.generateColorLegend()

    #==========================================================================
    #
    #==========================================================================
    def generatePackageDependenciesGraph(self, isDependency=True):
        # generate all dot file and use dot to generated the image file format
        if isDependency:
            name = "dependencies"
        else:
            name = "dependents"
        logger.info("Start generating package %s......" % name)
        logger.info("Total Packages: %d" % len(self._allPackages))
        for package in self._allPackages.values():
            self.generatePackageDependencyGraph(package, isDependency)
        logger.info("End of generating package %s......" % name)

    #==========================================================================
    #
    #==========================================================================
    def generatePackageDependentsGraph(self):
        self.generatePackageDependenciesGraph(False)

    #==========================================================================
    ## Method to generate the package dependency/dependent graph
    #==========================================================================
    def generatePackageDependencyGraph(self, package, dependencyList=True):
        # merge the routine and package list
        depPackages, depPackageMerged = mergeAndSortDependencyListByPackage(
                                                                      package,
                                                                      dependencyList)
        if dependencyList:
            packageSuffix = "_dependency"
        else:
            packageSuffix = "_dependent"
        packageName = package.getName()
        normalizedName = normalizePackageName(packageName)
        totalPackage = len(depPackageMerged)
        if  (totalPackage == 0) or (totalPackage > MAX_DEPENDENCY_LIST_SIZE):
            logger.info("Nothing to do exiting... Package: %s Total: %d " %
                         (packageName, totalPackage))
            return
        try:
            dirName = os.path.join(self._outDir, packageName)
            if not os.path.exists(dirName):
                os.makedirs(dirName)
        except OSError, e:
            logger.error("Error making dir %s : Error: %s" % (dirName, e))
            return
        output = open(os.path.join(dirName, normalizedName + packageSuffix + ".dot"), 'w')
        output.write("digraph %s {\n" % (normalizedName + packageSuffix))
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
            edgeStartNode = normalizedName
            edgeEndNode = normalizedDepPackName
            edgeLinkArch = packageName
            toolTipStartPackage = packageName
            toolTipEndPackage = depPackageName
            if not dependencyList:
                edgeStartNode = normalizedDepPackName
                edgeEndNode = normalizedName
                edgeLinkArch = depPackageName
                toolTipStartPackage = depPackageName
                toolTipEndPackage = packageName
            (edgeLabel, edgeToolTip, edgeStyle) = getPackageGraphEdgePropsByMetrics(depMetricsList,
                                                                                    toolTipStartPackage,
                                                                                    toolTipEndPackage)
            output.write("\t%s->%s [label=\"%s\" weight=%d URL=\"%s#%s\" style=\"%s\" labeltooltip=\"%s\" edgetooltip=\"%s\"];\n" % (edgeStartNode,
                                                     edgeEndNode,
                                                     edgeLabel,
                                                     edgeWeight,
                                                     edgeLinkURL,
                                                     edgeLinkArch,
                                                     edgeStyle,
                                                     edgeToolTip,
                                                     edgeToolTip))
        output.write("}\n")
        output.close()
        # use dot tools to generated the image and client side mapping
        outputName = os.path.join(dirName, normalizedName + packageSuffix + ".png")
        outputmap = os.path.join(dirName, normalizedName + packageSuffix + ".cmapx")
        inputName = os.path.join(dirName, normalizedName + packageSuffix + ".dot")
        # this is to generated the image in gif format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                               outputName,
                                                               outputmap,
                                                               inputName)
        logger.debug("command is %s" % command)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))

    #===============================================================================
    #
    #===============================================================================
    def generateRoutineCallGraph(self, isCalled=True):
        logger.info("Start Routine generating call graph......")
        for package in self._allPackages.itervalues():
            routines = package.getAllRoutines()
            for routine in routines.itervalues():
                isPlatformGenericRoutine = self._crossRef.isPlatformGenericRoutineByName(routine.getName())
                if isCalled and isPlatformGenericRoutine:
                    self.generatePlatformGenericDependencyGraph(routine, isCalled)
                else:
                    self.generateRoutineDependencyGraph(routine, isCalled)
        logger.info("End of generating call graph......")

    #==========================================================================
    # Method to generate routine caller graph for platform dependent routines
    #==========================================================================
    def generatePlatformGenericDependencyGraph(self, genericRoutine, isDependency):
        assert genericRoutine
        assert isinstance(genericRoutine, PlatformDependentGenericRoutine)
        if not isDependency:
            return
        platformRoutines = genericRoutine.getAllPlatformDepRoutines()
        for routineInfo in platformRoutines.itervalues():
            self.generateRoutineDependencyGraph(routineInfo[0], isDependency)

    #==========================================================================
    #
    #==========================================================================
    def generateRoutineCallerGraph(self):
        self.generateRoutineCallGraph(False)

    #==========================================================================
    ## generate all dot file and use dot to generated the image file format
    #==========================================================================
    def generateRoutineDependencyGraph(self, routine, isDependency=True):
        if not routine.getPackage():
            return
        routineName = routine.getName()
        packageName = routine.getPackage().getName()
        if isDependency:
            depRoutines = routine.getCalledRoutines()
            routineSuffix = "_called"
            totalDep = routine.getTotalCalled()
        else:
            depRoutines = routine.getCallerRoutines()
            routineSuffix = "_caller"
            totalDep = routine.getTotalCaller()
        # do not generate graph if no dep routines or
        # totalDep routines > max_dependency_list
        if (not depRoutines
            or len(depRoutines) == 0
            or  totalDep > MAX_DEPENDENCY_LIST_SIZE):
            logger.debug("No called Routines found! for routine:%s package:%s" % (routineName, packageName))
            return
        try:
            dirName = os.path.join(self._outDir, packageName)
            if not os.path.exists(dirName):
                os.makedirs(dirName)
        except OSError, e:
            logger.error("Error making dir %s : Error: %s" % (dirName, e))
            return
        output = open(os.path.join(dirName, routineName + routineSuffix + ".dot"), 'wb')
        output.write("digraph \"%s\" {\n" % (routineName + routineSuffix))
        output.write("\tnode [shape=box fontsize=14];\n") # set the node shape to be box
        output.write("\tnodesep=0.45;\n") # set the node sep to be 0.15
        output.write("\transsep=0.45;\n") # set the rank sep to be 0.75
#        output.write("\tedge [fontsize=12];\n") # set the edge label and size props
        if routine.getPackage() not in depRoutines:
            output.write("\tsubgraph \"cluster_%s\"{\n" % (routine.getPackage()))
            output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % routineName)
            output.write("\t}\n")
        for (package, callDict) in depRoutines.iteritems():
            output.write("\tsubgraph \"cluster_%s\"{\n" % (package))
            for routine in callDict.keys():
                output.write("\t\t\"%s\" [penwidth=2 %s URL=\"%s\" tooltip=\"%s\"];\n" % (routine,
                                                         findDotColor(routine),
                                                         getPackageObjHtmlFileName(routine),
                                                         getPackageObjHtmlFileName(routine)
                                                        ))
                if str(package) == packageName:
                    output.write("\t\t\"%s\" [style=filled fillcolor=orange];\n" % routineName)
            output.write("\t\tlabel=\"%s\";\n" % package)
            output.write("\t}\n")
            for (routine, tags) in callDict.iteritems():
                if isDependency:
                    output.write("\t\t\"%s\"->\"%s\"" % (routineName, routine))
                else:
                    output.write("\t\t\"%s\"->\"%s\"" % (routine, routineName))
                output.write(";\n")
        output.write("}\n")
        output.close()
        outputName = os.path.join(dirName, routineName + routineSuffix + ".png")
        outputmap = os.path.join(dirName, routineName + routineSuffix + ".cmapx")
        inputName = os.path.join(dirName, routineName + routineSuffix + ".dot")
        # this is to generated the image in png format and also cmapx (client side map) to make sure link
        # embeded in the graph is clickable
        # @TODO this should be able to run in parallel
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                               outputName,
                                                               outputmap,
                                                               inputName)
        logger.debug("command is %s" % command)
        retCode = subprocess.call(command, shell=True)
        if retCode != 0:
            logger.error("calling dot with command[%s] returns %d" % (command, retCode))

    #==========================================================================
    #  Generate Color legend image
    #==========================================================================
    def generateColorLegend(self, isCalled=True):
        command = "\"%s\" -Tpng -o\"%s\" -Tcmapx -o\"%s\" \"%s\"" % (self._dot,
                                                    os.path.join(self._outDir,"colorLegend.png"),
                                                    os.path.join(self._outDir,"colorLegend.cmapx"),
                                                    os.path.join(self._docRepDir,'callerGraph_color_legend.dot'))
        logger.debug("command is %s" % command)
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
  graphGenerator = GraphGenerator(crossRef,
                                  args.outDir,
                                  doxDir,
                                  args.dot)
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
    result = parser.parse_args();

    initLogging(result.logFileDir, "GraphGen.log")
    logger.debug(result)

    run(result)
