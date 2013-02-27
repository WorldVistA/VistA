#!/usr/bin/env python

# A Python model to read/write CrossReference as XML/JSON format
#---------------------------------------------------------------------------
# Copyright 2011 The Open Source Electronic Health Record Agent
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
#----------------------------------------------------------------
from CrossReference import CrossReference, Routine, Package, Global, PlatformDependentGenericRoutine
from CrossReference import LocalVariable, GlobalVariable, NakedGlobal, MarkedItem, LabelReference
from CrossReference import FileManFieldFactory, FileManFile
from xml.etree.ElementTree import ElementTree, Element, SubElement, parse, dump
import argparse
import os
import CallerGraphParser
from datetime import datetime, date, time
import json
from LogManager import logger, initConsoleLogging
import logging
from CrossReferenceBuilder import CrossReferenceBuilder
from CrossReferenceBuilder import createCrossReferenceLogArgumentParser
import base64
import pymongo
import json
import glob
class CrossRefXMLEncoder:
    def __init__(self):
        self.crossRef = CrossReference()
        self.root = Element("CrossReference", version="1.0")
    def __init__(self, crossRef):
        self.crossRef = crossRef
        self.root = Element("CrossReference", version="1.0")
    def getCrossReference(self):
        return self.crossRef
    def outputRoutineVariables(self, parent, variables, tag):
        variablesElement = SubElement(parent, tag)
        for var in variables:
            varElement = SubElement(variablesElement, "Var",
                                  name=var.getName(),
                                  EK=str(var.getNotKilledExp()),
                                  N=str(var.getNewed()),
                                  C=str(var.getChanged()),
                                  K=str(var.getKilled()))
    def outputRoutineCalledRoutines(self, parent, calledRoutines):
        calledRoutinesElement = SubElement(parent, "CalledRoutines")
        for callInfo in calledRoutines:
            varElement = SubElement(calledRoutinesElement, "Routine",
                                  name=callInfo.getCalledRoutine().getName())
    def outputRoutinesAsXML(self, parent):
        allRoutineElement = SubElement(parent, "Routines")
        allRoutines = self.crossRef.getAllRoutines()
        for routine in allRoutines.values():
            packageName = ""
            package = routine.getPackage()
            if package:
                packageName = package.getName()
            routineElement = SubElement(allRoutineElement, "Routine",
                                        name=routine.getName(),
                                        package=packageName)
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "LocalVariables")
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "GlobalVariables")
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "NakedGlobals")
            self.outputRoutineVariables(routineElement,
                                        routine.getLocalVariables(),
                                        "MarkedItems")
            self.outputRoutineCalledRoutines(routineElement,
                                             routine.getCalledRoutines())
    def outputOrphanRoutinesAsXML(self, parent):
        routinesElement = SubElement(parent, "OrphanRoutines")
        for routineName in self.crossRef.getOrphanRoutines():
            routineElement = SubElement(routinesElement, "Routine", name=routineName)
    def outputPackagesAsXML(self, parent):
        allPackageElement = SubElement(parent, "Packages")
        allPackages = self.crossRef.getAllPackages()
        for packageName in allPackages.iterkeys():
            packageElement = SubElement(allPackageElement, "Package",
                                        name=packageName,
                                        total="%d" % len(allPackages[packageName].getAllRoutines()))
    def outputRoutinesAsPlainLog(self, outputFile):
        outputFile.write("Total Routines, %s" % len(allRoutines))
    def outputPackagesAsPlainLog(self, outputFile):
        allPackages = self.crossRef.getAllPackages()
        outputFile.write("Total Packages, %d" % len(allPackages))
        for packageName, package in allPackages.iteritems():
            outputFile.write("Package,%s, Total,%d" % (packageName, len(package.getAllRoutines())))
    def outputAsXML(self, outputFile):
        self.outputPackagesAsXML(self.root)
        self.outputRoutinesAsXML(self.root)
        self.outputOrphanRoutinesAsXML(self.root)
        fileHandle = open(outputFile, 'w')
        ElementTree(self.root).write(fileHandle, "utf-8")
    def outputAsPlainLog(self, outputFile):
        fileHandle = open(outputFile, 'w')
        self.outputPackagesAsPlainLog(fileHandle)
        self.outputRoutinesAsPlainLog(fileHandle)
        self.outputOrphanRoutinesAsPlainLog(fileHandle)
    def loadFromXML(self, inputFile):
        pass
#===============================================================================
# class to encode CrossReference as JSON format
#===============================================================================
class CrossRefJSONEncoder(object):
    def __init__(self, CrossRef):
        self._crossRef = CrossRef
        self._routineEncoder = RoutineJSONEncoder()
        self._globalEncoder = GlobalJSONEncoder()
        self._packageEncoder = PackageJSONEncoder()
        self._fileManFileEncoder = FileManFileEncoder()
    def outputCrossRefAsJSON(self, outDir):
        allRoutines = self._crossRef.getAllRoutines()
        for routine in allRoutines.itervalues():
            self.__outputIndividualRoutine__(outDir, routine)
        allGlobals = self._crossRef.getAllGlobals()
        for Global in allGlobals.itervalues():
            if not Global.isFileManFile():
                self.__outputIndividualGlobal__(outDir, Global)
            else:
                self.__outputIndividualFileManFile__(outDir, Global)
                if not Global.getAllSubFiles(): continue
                for subFile in Global.getAllSubFiles().itervalues():
                    self.__outputIndividualSubFile__(outDir, subFile)
        for Package in self._crossRef.getAllPackages().itervalues():
            self.__outputIndividualPackage__(outDir, Package)
    def __outputIndividualRoutine__(self, outDir, routine):
        logger.info("Writing Routine %s" % routine)
        outputFile = open(os.path.join(outDir,"Routine_%s.json" % routine.getName()),'wb')
        outputFile.write(self._routineEncoder.outputRoutine(routine))
        outputFile.write("\n")
        outputFile.close()
        if isinstance(routine, PlatformDependentGenericRoutine):
            routineList = [x[0] for x in routine.getAllPlatformDepRoutines().itervalues()]
            for depRoutine in routineList:
                self.__outputIndividualRoutine__(outDir, depRoutine)

    def __outputIndividualGlobal__(self, outDir, Global):
        logger.info("Writing Global %s" % Global)
        outputFile = open(os.path.join(outDir,"Global_%s.json" % base64.urlsafe_b64encode(Global.getName())),'wb')
        outputFile.write(self._globalEncoder.outputResult(Global))
        outputFile.write("\n")
        outputFile.close()

    def __outputIndividualFileManFile__(self, outDir, Global):
        logger.info("Writing Global %s" % Global)
        jsonResult = self._fileManFileEncoder.outputResult(Global)
        outputFile = open(os.path.join(outDir,"Global_%s.json" % base64.urlsafe_b64encode(Global.getName())),'wb')
        outputFile.write(jsonResult)
        outputFile.write("\n")
        outputFile.close()
        logger.info("Writing FileManFile %s" % Global.getFileNo())
        outputFile = open(os.path.join(outDir,"FileManFile_%s.json" % (Global.getFileNo())),'wb')
        outputFile.write(jsonResult)
        outputFile.write("\n")
        outputFile.close()
    def __outputIndividualSubFile__(self, outDir, subFile):
        logger.info("Writing SubFile %s" % subFile)
        outputFile = open(os.path.join(outDir,"SubFile_%s.json" % (subFile.getFileNo())),'wb')
        outputFile.write(self._fileManFileEncoder.outputSubFile(subFile))
        outputFile.write("\n")
        outputFile.close()

    def __outputIndividualPackage__(self, outDir, Package):
        logger.info("Writing Package %s" % Package)
        outputFile = open(os.path.join(outDir,"Package_%s.json" % (Package.getName().replace(' ','_').replace('-','_'))),'wb')
        outputFile.write(self._packageEncoder.outputPackage(Package))
        outputFile.write("\n")
        outputFile.close()

class RoutineJSONEncoder(object):
    def __init__(self):
        pass
    def outputRoutine(self, Routine):
        outputDict = dict()
        if isinstance(Routine, PlatformDependentGenericRoutine):
            platformList = self.__outputPlatformDepRoutineList__(Routine)
            outputDict["platform_dep_list"] = platformList
        outputDict["name"] = Routine.getName()
        outputDict["package"] = Routine.getPackage().getName()
        outputDict["comments"] = Routine.getComment()
        outputDict["original_name"] = Routine.getOriginalName()
        outputDict["source_code"] = Routine.hasSourceCode()
        localVars = self.__outputAbstractVariables__(Routine.getLocalVariables())
        outputDict["local_variables"] = localVars
        globalVars = self.__outputAbstractVariables__(Routine.getGlobalVariables())
        outputDict["global_variables"] = globalVars
        nakedVars = self.__outputAbstractVariables__(Routine.getNakedGlobals())
        outputDict["naked_globals"] = nakedVars
        markedItems = self.__outputAbstractVariables__(Routine.getMarkedItems())
        outputDict["marked_items"] = markedItems
        labelRefs = self.__outputAbstractVariables__(Routine.getLabelReferences())
        outputDict["label_references"] = labelRefs
        outputDict["referred_globals"] = self.__outputReferredGlobals__(Routine.getReferredGlobal())
        outputDict["total_called_routines"] = Routine.getTotalCalled()
        outputDict["called_routines"] = self.__outputCallDepRoutines__(Routine.getCalledRoutines())
        outputDict["caller_routines"] = self.__outputCallDepRoutines__(Routine.getCallerRoutines())
        return json.dumps(outputDict)

    def __outputPlatformDepRoutineList__(self, platformRoutine):
        assert isinstance(platformRoutine, PlatformDependentGenericRoutine)
        outList = [{"routine":x[0].getName(), "platform":x[1]} for x in platformRoutine.getAllPlatformDepRoutines().itervalues()]
        return outList

    def __outputAbstractVariables__(self, abstractVariables):
        if not abstractVariables or len(abstractVariables) == 0:
            return None
        sortedList = [abstractVariables[x] for x in sorted(abstractVariables.keys())]
        abVarList = [self.__outputAbstractVariable__(x) for x in sortedList]
        return abVarList

    def __outputAbstractVariable__(self, AbstractVariable):
        outputDict = dict()
        outputDict["name"] = AbstractVariable.getName()
        outputDict["prefix"] = AbstractVariable.getPrefix()
        outputDict["offset"] = AbstractVariable.getLineOffsets()
        return outputDict

    def __outputReferredGlobals__(self, refGlobals):
        if not refGlobals or len(refGlobals) == 0:
            return None
        return sorted(refGlobals.keys())
    def __outputCallDepRoutines__(self, depRoutines):
        if not depRoutines or len(depRoutines) == 0:
            return None
        outputResult = []
        for (package, Routines) in depRoutines.iteritems():
            packageDict = dict()
            packageDict["package"] = package.getName()
            packageDict["routines"] = []
            for (routine, calltags) in Routines.iteritems():
                routineDict =  dict()
                routineDict["routine"] = routine.getName()
                routineDict["tags"] = []
                for (calltag, lineOccurences) in calltags.iteritems():
                    calltagDict = dict()
                    calltagDict['tag'] = calltag
                    calltagDict['occurences'] = lineOccurences
                    routineDict["tags"].append(calltagDict)
                packageDict["routines"].append(routineDict)
            outputResult.append(packageDict)
        return outputResult
def unitTestRoutineJSONEncoder(outputFile):
    testPA = Package("TestPA")
    testPB = Package("TestPB")
    testPC = Package("TestPC")
    calledRoutineA = Routine("TestRA", testPB)
    calledRoutineB = Routine("TestRB", testPC)
    testRoutine = Routine("TestRA", testPA)
    localVar = LocalVariable("TSTLA",">>","YU+4,XU+1*")
    testRoutine.addLocalVariables(localVar)
    localVar = LocalVariable("TSTLB",">>","YU+1*,XU+3*")
    testRoutine.addLocalVariables(localVar)
    globalVar = GlobalVariable("TSTGA",">>","YU+4,XU+1*")
    testRoutine.addGlobalVariables(globalVar)
    nakedVar = NakedGlobal("^(20.2",None,"YU+4,XU+1")
    testRoutine.addNakedGlobals(nakedVar)
    labelRef = LabelReference("DD",None,"YU+4,XU+1")
    testRoutine.addLabelReference(labelRef)
    globalVar = Global("^TMP(\"TEST\"", None, None, None)
    testRoutine.addReferredGlobal(globalVar)
    globalVar = Global("^TMP($J", None, None, None)
    testRoutine.addReferredGlobal(globalVar)
    testRoutine.addCalledRoutines(calledRoutineA,"$$DT","N+1,Y+3")
    testRoutine.addCalledRoutines(calledRoutineB,"$$OUT","Y+1,Z+3")
    output = RoutineJSONEncoder().outputRoutine(testRoutine)
    outputFile = open(outputFile, "wb")
    outputFile.write(output)
    outputFile.write("\n")
class PackageJSONEncoder(object):
    def __init__(self):
        self._outputDict = dict()
    def outputPackage(self, Package):
        self._outputDict.clear()
        outputDict = self._outputDict
        outputDict['name'] = Package.getName()
        outputDict['routines'] = [x for x in Package.getAllRoutines().iterkeys()]
        outputDict['non_fileman_globals'] = []
        outputDict['fileman_globals'] = []
        for globalVar in Package.getAllGlobals().itervalues():
            globalName = globalVar.getName()
            if globalVar.isFileManFile():
                fileNo = globalVar.getFileNo()
                fileName = globalVar.getFileManName()
                outputDict['fileman_globals'].append(dict({'name': globalName,
                                                           'file_no': fileNo,
                                                           'file_name': fileName}))
            else:
                outputDict['non_fileman_globals'].append(globalName)
        outputDict['original_name'] = Package.getOriginalName()
        outputDict['namespace'] = Package.getNamespaces()
        outputDict['globalspace'] = Package.getGlobalNamespace()
        outputDict['docLink'] = Package.getDocLink()
        outputDict['mirrorLink'] = Package.getDocMirrorLink()
        outputDict['dependency'] = self.__outputDependency__(Package)
        outputDict['dependent'] = self.__outputDependent__(Package)
        return json.dumps(outputDict)
    def __outputDependency__(self, Package):
        outputDict = dict() # aggregate all the information together
        routineDeps = Package.getPackageRoutineDependencies()
        for (key, value) in routineDeps.iteritems():
            packageName = key.getName()
            if packageName not in outputDict:
                outputDict[packageName] = dict()
            outputDict[packageName]['routine_dependency'] = dict()
            outputDict[packageName]['routine_dependency']["called_routines"]=[x.getName() for x in value[0]]
            outputDict[packageName]['routine_dependency']["caller_routines"]=[x.getName() for x in value[1]]
        globalDeps = Package.getPackageGlobalDependencies()
        for (key, value) in globalDeps.iteritems():
            packageName = key.getName()
            if packageName not in outputDict:
                outputDict[packageName] = dict()
            outputDict[packageName]['global_dependency']= dict()
            outputDict[packageName]['global_dependency']["access_routine"]=[x.getName() for x in value[0]]
            outputDict[packageName]['global_dependency']["accessed_globals"]=[x.getName() for x in value[1]]
        fileManDeps = Package.getPackageFileManFileDependencies()
        for (key, value) in fileManDeps.iteritems():
            packageName = key.getName()
            if packageName not in outputDict:
                outputDict[packageName] = dict()
            outputDict[packageName]['filemanfile_dependency']= dict()
            outputDict[packageName]['filemanfile_dependency']["filemanfiles"]=[x.getName() for x in value[0]]
            outputDict[packageName]['filemanfile_dependency']["pointer_to_files"]=[x.getName() for x in value[1]]
        return [{"package":x,"dependency_details":y} for x,y in outputDict.iteritems()]
    def __outputDependent__(self, Package):
        outputDict = dict() # aggregate all the information together
        routineDeps = Package.getPackageRoutineDependents()
        for (key, value) in routineDeps.iteritems():
            packageName = key.getName()
            if packageName not in outputDict:
                outputDict[packageName] = dict()
            outputDict[packageName]['routine_dependent'] = dict()
            outputDict[packageName]['routine_dependent']["caller_routines"]=[x.getName() for x in value[0]]
            outputDict[packageName]['routine_dependent']["called_routines"]=[x.getName() for x in value[1]]
        globalDeps = Package.getPackageGlobalDependents()
        for (key, value) in globalDeps.iteritems():
            packageName = key.getName()
            if packageName not in outputDict:
                outputDict[packageName] = dict()
            outputDict[packageName]['global_dependent']= dict()
            outputDict[packageName]['global_dependent']["access_routine"]=[x.getName() for x in value[0]]
            outputDict[packageName]['global_dependent']["accessed_globals"]=[x.getName() for x in value[1]]
        fileManDeps = Package.getPackageFileManFileDependents()
        for (key, value) in fileManDeps.iteritems():
            packageName = key.getName()
            if packageName not in outputDict:
                outputDict[packageName] = dict()
            outputDict[packageName]['filemanfile_dependent']= dict()
            outputDict[packageName]['filemanfile_dependent']["pointed_to_by"]=[x.getName() for x in value[0]]
            outputDict[packageName]['filemanfile_dependent']["filemanfiles"]=[x.getName() for x in value[1]]
        return [{"package":x,"dependency_details":y} for x,y in outputDict.iteritems()]

class GlobalJSONEncoder(object):
    def __init__(self):
        self._outputDict = dict()
    def outputResult(self, Global):
        self._outputDict.clear()
        self.__outputGlobal__(Global)
        self.__outputOtherInfo__(Global)
        return json.dumps(self._outputDict)
    def __outputGlobal__(self, Global):
        outputDict = self._outputDict
        outputDict["name"] = Global.getName()
        outputDict["package"] = Global.getPackage().getName()
        outputDict["accessed_by_routines"] = self.__outputAccessByRoutineList__(Global)
    def __outputAccessByRoutineList__(self, Global):
        outputList =[{"package":x.getName(),"routines":[z.getName() for z in y]} for (x,y) in Global.getAllReferencedRoutines().iteritems()]
        return outputList
    def __outputOtherInfo__(self, Global):
        pass

class FileManFileEncoder(GlobalJSONEncoder):
    def __init__(self):
        GlobalJSONEncoder.__init__(self)
    def outputSubFile(self, subFile):
        return self.__outputIndividualFileManSubFile__(subFile)

    def __outputOtherInfo__(self, fileManGlobal):
        outputDict = self._outputDict
        outputDict["file_no"] = fileManGlobal.getFileNo()
        outputDict["file_name"] = fileManGlobal.getFileManName()
        outputDict['description'] = fileManGlobal.getDescription()
        outputDict['fields'] = self.__outputFileManFields__(fileManGlobal.getAllFileManFields())
        if not fileManGlobal.isSubFile():
            if fileManGlobal.getAllSubFiles():
                outputDict['subfiles'] = [x for x in fileManGlobal.getAllSubFiles().iterkeys()]
            else:
                outputDict['subfiles'] = None
        else:
            parentFileList = []
            parentFile = fileManGlobal.getParentFile()
            while parentFile:
                parentFileList.append(parentFile.getFileNo())
                parentFile = parentFile.getParentFile()
            outputDict['parent_file'] = parentFileList

    def __outputIndividualFileManField__(self, FileManField):
        fieldDict = dict()
        fieldDict['field_no'] = FileManField.getFieldNo()
        fieldDict['name'] = FileManField.getName()
        fieldDict['location'] = FileManField.getLocation()
        fieldDict['type'] = FileManField.getType()
        fieldDict['typename'] = FileManField.getTypeName()
        fieldDict['isRequired'] = FileManField.isRequired()
        fieldDict['isAudited'] = FileManField.isAudited()
        fieldDict['isAddNewEntryWithoutAsking'] = FileManField.isAddNewEntryWithoutAsking()
        fieldDict['isMultiplyAsked'] = FileManField.isMultiplyAsked()
        fieldDict['isKeyField'] = FileManField.isKeyField()
        if FileManField.isFilePointerType():
            filePointedTo = FileManField.getPointedToFile()
            if filePointedTo:
                fieldDict['filePointedTo'] = filePointedTo.getFileNo()
            else:
                fieldDict['filePointedTo'] = None
        elif FileManField.isSetType():
            fieldDict['set_memembers'] = FileManField.getSetMembers()
        elif FileManField.isSubFilePointerType():
            filePointedTo = FileManField.getPointedToSubFile()
            if filePointedTo:
                fieldDict['subfilePointedTo'] = filePointedTo.getFileNo()
            else:
                fieldDict['subfilePointedTo'] = None
        elif FileManField.isVariablePointerType():
            pointedToFiles = FileManField.getPointedToFiles()
            if pointedToFiles:
                fieldDict['pointedToFileList'] = [x.getFileNo() for x in pointedToFiles]
            else:
                fieldDict['pointedToFileList'] = None
        elif FileManField.isWordProcessingType():
            fieldDict['isNoWrap'] = FileManField.getNoWrap()
        return fieldDict

    def __outputFileManFields__(self, FileManFields):
        if not FileManFields: return None
        outputList = []
        for fileManField in FileManFields.itervalues():
            outputList.append(self.__outputIndividualFileManField__(fileManField))
        return outputList

    def __outputFileManSubFile__(self, fileManSubFiles):
        outputList = []
        for fileManSubFile in fileManSubFiles:
            outputList.append(self.__outputIndividualFileManSubFile__(fileManSubFile))
        return outputList
    def __outputIndividualFileManSubFile__(self, fileManSubFile):
        assert(fileManSubFile.isSubFile())
        self._outputDict.clear()
        self.__outputOtherInfo__(fileManSubFile)
        return json.dumps(self._outputDict)


def insertJSONFileToMongdb(jsonFilePath, connection, filePattern,
                           dbName, tableName, key, isUnique=True):
    globFiles = glob.glob(os.path.join(jsonFilePath, filePattern))
    if not globFiles or len(globFiles) == 0:
        return
    database = connection[dbName]
    table = database[tableName]
    if key:
        table.ensure_index(key, unique=isUnique)
    for file in globFiles:
        fileHandle = open(file, 'rb')
        logger.info("Reading file %s" % file)
        result = table.insert(json.load(fileHandle))
        logger.info("inserting result is %s" % result)
        fileHandle.close()

def insertAllJSONFilestoMongodb(jsonFilePath):
    outputTuple = (("Routine_*.json", "routines", "name", True),
                   ("Global_*.json", "globals", "name", True),
                   ("Package_*.json", "packages", "name", True),
                   ("FileManFile_*.json", "filemanfiles", "file_no", True),
                   ("SubFile_*.json", "subfiles", "file_no", True)
                   )
    dbName = "vista"
    connection = pymongo.Connection()
    for item in outputTuple:
        insertJSONFileToMongdb(jsonFilePath, connection, item[0],
                               dbName, item[1], item[2], item[3])
    connection.close()

def findRoutineFromMongoDb(routineName):
    conn = pymongo.Connection()
    vistadb = conn.vista
    routinesTable = vistadb.routines
    routine = routinesTable.find_one({"name":"%s" % routineName})
    assert routine
    import pprint
    pprint.pprint(routine)

def findPackageFromMongoDb(packageName):
    conn = pymongo.Connection()
    vistadb = conn.vista
    packageTable = vistadb.packages
    package = packageTable.find_one({"name":"%s" % packageName})
    assert package
    import pprint
    pprint.pprint(package)

def loadCrossRefFromMongoDB():
    conn = pymongo.Connection()
    vistadb = conn.vista
    packageTable = vistadb.packages
    packages = packageTable.find()
    crossRef = CrossReference()
    packageDecoder = PackageJSONDecoder(crossRef)
    for packageJson in packages:
        logger.info("decoding Package: %s" % packageJson['name'])
        packageDecoder.decodePackage(packageJson)
    routinesTable = vistadb.routines
    routines = routinesTable.find()
    routineDecoder = RoutineJSONDecode(crossRef)
    for routineJson in routines:
        logger.info("decoding Routine: %s" % routineJson['name'])
        routineDecoder.decodeRoutine(routineJson)
    fileManFileDecoder = FileManFileDecode(crossRef)
    globalsTable = vistadb.globals
    globalFiles = globalsTable.find()
    for globalFileJson in globalFiles:
        logger.info("decoding global: %s" % globalFileJson['name'])
        fileManFileDecoder.decodeGlobal(globalFileJson)
    subFilesTable = vistadb.subfiles
    subFiles = subFilesTable.find()
    for subFileJson in subFiles:
        logger.info("decoding subfile: %s" % subFileJson['file_no'])
        fileManFileDecoder.decodeSubFile(subFileJson)
    return crossRef
class PackageJSONDecoder(object):
    def __init__(self, CrossRef):
        self._crossRef = CrossRef
    def decodePackage(self, PackageJson):
        packageName = PackageJson["name"]
        crossRef = self._crossRef
        if not crossRef.hasPackage(packageName):
            crossRef.addPackageByName(packageName)
        Package = crossRef.getPackageByName(packageName)
        self.__setPackageProperties__(Package, PackageJson)
        self.__handleAllRoutines__(Package, PackageJson)
        self.__handleAllGlobals__(Package, PackageJson)
        self.__handleNamespaces__(Package, PackageJson)
    def __setPackageProperties__(self, Package, PackageJson):
        if "original_name" in PackageJson:
            Package.setOriginalName(PackageJson["original_name"])
        if "docLink" in PackageJson:
            Package.setDocLink(PackageJson["docLink"])
        if "mirrorLink" in PackageJson:
            Package.setMirrorLink(PackageJson["mirrorLink"])
    def __handleAllRoutines__(self, Package, PackageJson):
        assert "routines" in PackageJson
        crossRef = self._crossRef
        for routineName in PackageJson['routines']:
            crossRef.addRoutineToPackageByName(routineName, Package.getName())
    def __handleAllGlobals__(self, Package, PackageJson):
        crossRef = self._crossRef
        for globalName in PackageJson['non_fileman_globals']:
            crossRef.addGlobalToPackageByName(globalName, Package.getName())
        packageName = PackageJson["name"]
        package = crossRef.getPackageByName(packageName)
        for fileManGlobalDict in PackageJson['fileman_globals']:
            globalName = fileManGlobalDict['name']
            fileNo = fileManGlobalDict['file_no']
            fileName = fileManGlobalDict['file_name']
            GlobalVar = Global(globalName, fileNo, fileName, package)
            crossRef.addGlobalToPackage(GlobalVar, packageName)
    def __handleNamespaces__(self, Package, PackageJson):
        if "namespace" in PackageJson and PackageJson['namespace']:
            for namespace in PackageJson['namespace']:
                Package.addNamespace(namespace)
        if "globalnamespace" in PackageJson and PackageJson['globalnamespace']:
            for globalNamespace in PackageJson['globalnamespace']:
                Package.addGlobalNamespace(globalNamespace)

class RoutineJSONDecode(object):
    def __init__(self, CrossRef):
        self._crossRef = CrossRef
    def decodeRoutine(self, RoutineJson):
        crossRef = self._crossRef
        assert 'name' in RoutineJson
        assert 'package' in RoutineJson
        routineName = RoutineJson['name']
        packageName = RoutineJson['package']
        hasSourceCode = False
        if "source_code" in RoutineJson:
            hasSourceCode = RoutineJson['source_code']
        if not crossRef.hasRoutine(RoutineJson['name']):
            crossRef.addRoutineToPackageByName(routineName,
                                               packageName,
                                               hasSourceCode)
        Routine = crossRef.getRoutineByName(routineName)
        assert Routine.getPackage().getName() == packageName
        self.__setRoutineProperties__(Routine, RoutineJson)
        for item in ('local_variables', 'global_variables',
                     'marked_items', 'label_references', 'naked_globals'):
            self.__handleAbstractVariables__(item, Routine, RoutineJson)
        self.__handleReferredGlobals__(Routine, RoutineJson)
        self.__handleCalledRoutines__(Routine, RoutineJson)
    def __setRoutineProperties__(self, Routine, RoutineJson):
        if "original_name" in RoutineJson:
            Routine.setOriginalName(RoutineJson['original_name'])
        if "comments" in RoutineJson and RoutineJson['comments']:
            for comment in RoutineJson['comments']:
                Routine.addComment(comment)

    def __handleAbstractVariables__(self, nameTag, Routine, RoutineJson):
        abstractVarDict = {
                            'local_variables': (LocalVariable, Routine.addLocalVariables),
                            'global_variables': (GlobalVariable, Routine.addGlobalVariables),
                            'marked_items': (MarkedItem, Routine.addMarkedItems),
                            'label_references': (LabelReference, Routine.addLabelReference),
                            'naked_globals': (NakedGlobal, Routine.addNakedGlobals)
                          }
        abstractVariables = RoutineJson.get(nameTag)
        if not abstractVariables: return
        for abstractVar in abstractVariables:
            var = abstractVarDict[nameTag][0](abstractVar['name'],
                                              abstractVar['prefix'],
                                              ",".join(abstractVar["offset"]))
            abstractVarDict[nameTag][1](var)
    def __handleCalledRoutines__(self, Routine, RoutineJson):
        calledRoutines = RoutineJson.get("called_routines")
        if not calledRoutines: return
        for calledRoutineJson in calledRoutines:
            packageRoutines = calledRoutineJson['routines']
            for routine in packageRoutines:
                routineName = routine['routine']
                calledRoutine = self._crossRef.getRoutineByName(routineName)
                assert calledRoutine
                tags = routine['tags']
                for tagDict in tags:
                    Routine.addCalledRoutines(calledRoutine,
                                              tagDict['tag'],
                                              ",".join(tagDict['occurences']))
    def __handleReferredGlobals__(self, Routine, RoutineJson):
        referredGlobalsJson = RoutineJson.get('referred_globals')
        if not referredGlobalsJson: return
        for referredGlobal in referredGlobalsJson:
            Routine.addReferredGlobal(self._crossRef.getGlobalByName(referredGlobal))

class GlobalJSONDecode(object):
    def __init__(self, crossRef):
        self._crossRef = crossRef
    def decodeGlobal(self, GlobalJson):
        GlobalName = GlobalJson['name']
        Global = self._crossRef.getGlobalByName(GlobalName)
        assert Global
        if "file_no" in GlobalJson:
            self.__decodeFileManFile__(Global, GlobalJson)
    def __decodeFileManFile__(self, Global, GlobalJson):
        pass

class FileManFileDecode(GlobalJSONDecode):
    def __init__(self, CrossRef):
        GlobalJSONDecode.__init__(self, CrossRef)

    def decodeSubFile(self, subFileJson):
        subFileNo = subFileJson['file_no']
        assert "parent_file" in subFileJson
        rootFileNo = subFileJson['parent_file'][-1]
        rootFileManFile = self._crossRef.getGlobalByFileNo(rootFileNo)
        assert rootFileManFile
        subFileManFile = rootFileManFile.getSubFileByFileNo(subFileNo)
        assert subFileManFile
        subFileManFile.setFileManName(subFileJson['file_name'])
        self.__decodeFileManFile__(subFileManFile, subFileJson, rootFileManFile)

    def __decodeFileManFile__(self, fileManFile, fileManFileJson, rootFileManFile=None):
        assert fileManFile.getFileNo() == fileManFileJson['file_no']
        assert fileManFile.getFileManName() == fileManFileJson['file_name']
        if fileManFileJson.get('description'):
            fileManFile.setDescription(fileManFileJson['description'])
        fileManFieldsJson = fileManFileJson['fields']
        if not fileManFieldsJson: return
        subFilesJson = fileManFileJson.get('subfiles')
        if subFilesJson:
            self.__handleFileManSubFiles__(fileManFile, subFilesJson)
        for fileManFieldJson in fileManFieldsJson:
            self.__decodeFileManField__(fileManFile, fileManFieldJson, rootFileManFile)
    def __handleFileManSubFiles__(self, fileManFile, subFilesJson):
        for subFileNo in subFilesJson:
            fileManFile.addFileManSubFile(FileManFile(subFileNo, "", fileManFile))
    def __decodeFileManField__(self, fileManFile, fileManFieldJson, rootFileManFile=None):
        fieldNo = fileManFieldJson['field_no']
        fieldName = fileManFieldJson['name']
        location = fileManFieldJson['location']
        type = fileManFieldJson['type']
        fileManField = FileManFieldFactory.createField(fieldNo, fieldName, type, location)
        fileManField.setTypeName(fileManFieldJson['typename'])
        fileManField.setRequired(fileManFieldJson['isRequired'])
        fileManField.setAudited(fileManFieldJson['isAudited'])
        fileManField.setAddNewEntryWithoutAsking(fileManFieldJson['isAddNewEntryWithoutAsking'])
        fileManField.setMultiplyAsked(fileManFieldJson['isMultiplyAsked'])
        if fileManField.isFilePointerType():
            fileNo = fileManFieldJson['filePointedTo']
            if fileNo:
                filePointedTo = self._crossRef.getGlobalByFileNo(fileNo)
                assert filePointedTo
                fileManField.setPointedToFile(filePointedTo)
        elif fileManField.isSetType():
            fileManField.setSetMembers(fileManFieldJson['set_memembers'])
        elif fileManField.isVariablePointerType():
            pointedToFiles = [self._crossRef.getGlobalByFileNo(x) for x in fileManFieldJson['pointedToFileList']]
            fileManField.setPointedToFiles (pointedToFiles)
        elif fileManField.isWordProcessingType():
            fileManField.setNoWrap(fileManFieldJson['isNoWrap'])
        elif fileManField.isSubFilePointerType():
            subFileNo = fileManFieldJson['subfilePointedTo']
            parentFile = fileManFile
            if rootFileManFile:
                parentFile = rootFileManFile
            fileManField.setPointedToSubFile(parentFile.getSubFileByFileNo(subFileNo))
        fileManFile.addFileManField(fileManField)
if __name__ == '__main__':
    initConsoleLogging()
    crossRefArgParse = createCrossReferenceLogArgumentParser()
    parser = argparse.ArgumentParser(
                      description='VistA Cross Reference Externalization',
                      parents=[crossRefArgParse])
    parser.add_argument('-O', '--outputDir', required=True,
                        help='Output Directory')
#    parser.add_argument('-I', required=False, dest='inputXMLFile',
#                        help='Input XML File')
    result = parser.parse_args();
#    if result['inputXMLFile']:
#        crossRefXML = CrossRefXMLEncoder()
#        crossRefXML.loadFromXML(result['inputXMLFile'])
#        crossRef = crossRefXML.getCrossReference()
#        crossRef.getPackageByName("Kernel").printResult()
#        exit()
    logger.info( "Starting parsing caller graph log file....")
    crossRefA = CrossReferenceBuilder().buildCrossReference(result)
#    logger.info("Generating Cross-Reference JSON output files")
#    crossRefEncoder = CrossRefJSONEncoder(crossRef)
#    crossRefEncoder.outputCrossRefAsJSON(result.outputDir)
    # now save to mongodb
#    logger.info("Save to mongodb")
#    insertAllJSONFilestoMongodb(result['outputDir'])
    logger.info("Loading CrossRef from mongodb")
    #crossRefB = loadCrossRefFromMongoDB()
    #crossRefB.generateAllPackageDependencies()
    #package = crossRefA.getPackageByName("VA FileMan")
    #package.printResult()
    #package = crossRefB.getPackageByName("VA FileMan")
    #package.printResult()
#    routineA = crossRefA.getRoutineByName("DIC")
#    routineA.printResult()
#    routineA = crossRefB.getRoutineByName("DIC")
#    routineA.printResult()
#    globalVar = crossRefA.getGlobalByName("^DIC(19")
#    globalVar.printResult()
#    globalVar = crossRefB.getGlobalByName("^DIC(19")
#    globalVar.printResult()
