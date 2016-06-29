import csv
import json
import argparse
import os.path

from LogManager import logger, initConsoleLogging


CSV_FIELD_MAP = [
    ('IA #', 'number'),
    ('NAME', 'name'),
    ('TYPE', 'type'),
    ('DATE CREATED', 'date'),
    ('STATUS', 'status')
]

""" This python module will convert ICR Json file into Csv for Visualization """
class ICRJsonToCsv (object):
    def __init__(self):
        pass
    def generateCsvByJson(self, inputJsonFile, outputCsvFile):
        with open(inputJsonFile, 'r') as inJson:
            icrJson = json.load(inJson)
            with open(outputCsvFile, 'w') as outCsv:
                csvWrt = csv.writer(outCsv, lineterminator="\n")
                csvWrt.writerow([x[1] for x in CSV_FIELD_MAP])
                CSV_FIELD_NAME = [x[0] for x in CSV_FIELD_MAP]
                for icrItem in icrJson:
                    curRow = []
                    isValidData = True
                    for fld in CSV_FIELD_NAME:
                        if fld in icrItem:
                            curRow.append(icrItem[fld])
                        else:
                            isValidData = False
                            break
                    if isValidData:
                        csvWrt.writerow(curRow)
    def generatePackageDependencyJson(self, inputJsonFile, outputDepFile):
        outDep = {}
        with open(inputJsonFile, 'r') as inJson:
            icrJson = json.load(inJson)
            for icrItem in icrJson:
                curIaNum = icrItem['IA #']
                if 'STATUS' not in icrItem or icrItem['STATUS'] != 'Active':
                    continue
                if 'CUSTODIAL PACKAGE' in icrItem:
                    curPkg = icrItem['CUSTODIAL PACKAGE']
                    outDep.setdefault(curPkg,{})
                    if 'SUBSCRIBING PACKAGE' in icrItem:
                        for subPkg in icrItem['SUBSCRIBING PACKAGE']:
                            if 'SUBSCRIBING PACKAGE' in subPkg:
                                subPkgName = subPkg['SUBSCRIBING PACKAGE']
                                subDep = outDep.setdefault(subPkgName, {}).setdefault('dependencies',{})
                                subDep.setdefault(curPkg, []).append(curIaNum)
                                curDep = outDep.setdefault(curPkg, {}).setdefault('dependents', {})
                                curDep.setdefault(subPkgName, []).append(curIaNum)
        with open(outputDepFile, 'w') as outJson:
            json.dump(outDep, outJson, indent=4)

def createArgParser():
    parser = argparse.ArgumentParser(description='Convert VistA ICR JSON to csv for Visualization')
    parser.add_argument('icrJsonFile', help='path to the VistA ICR JSON file')
    parser.add_argument('-csv', '--outCsvFile', help='path to the output csv file')
    parser.add_argument('-dep', '--pkgDepJsonFile', help='path to the output package dependency JSON file')
    return parser



if __name__ == '__main__':
    parser = createArgParser()
    result = parser.parse_args()
    initConsoleLogging()
    # initConsoleLogging(logging.DEBUG)
    if result.icrJsonFile:
        icrJsonToHtml = ICRJsonToCsv()
    if result.outCsvFile:
        icrJsonToHtml.generateCsvByJson(result.icrJsonFile, result.outCsvFile)
    if result.pkgDepJsonFile:
        icrJsonToHtml.generatePackageDependencyJson(result.icrJsonFile, result.pkgDepJsonFile)
