import ICRFileToJson
import ICRJsonToHtml

import argparse
import os

from LogManager import initConsoleLogging

def run(args):
    tmpJson = os.path.join(args.outDir, ".tmp.JSON")

    args.outJson = tmpJson
    ICRFileToJson.run(args)

    args.icrJsonFile = tmpJson
    ICRJsonToHtml.run(args)

    os.remove(tmpJson)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA ICR Parser')
    parser.add_argument('-mr', '--MRepositDir', required=True,
                          help='VistA M Component Git Repository Directory')
    parser.add_argument('-pr', '--patchRepositDir', required=True,
                          help="VistA Git Repository Directory")
    parser.add_argument('icrfile', help='path to the VistA ICR file')
    parser.add_argument('outDir', help='path to the output web page directory')
    result = parser.parse_args()
    initConsoleLogging()
    run(result)
