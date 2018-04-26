import ICRFileToJson
import ICRJsonToHtml

import argparse
import os

from LogManager import initConsoleLogging
ICR_DIR = "ICR"

def run(args):
    filename = os.path.basename(args.icrfile)[:-4] # Remove '.txt'
    args.icrJsonFile = os.path.join(args.outdir, filename + ".JSON")
    ICRFileToJson.run(args)
    args.date = ICRFileToJson.date
    if args.date is None:
        # No date specified in the file, try to parse the filename
        # Expected format: <year>_<month>_<day>_IA_Listing_Descriptions.TXT
        filename = os.path.basename(args.icrfile)
        s = filename.find("_IA_Listing_Descriptions")
        if s > 0:
            date_str = filename[:s]
            vals = date_str.split("_")
            if len(vals) == 3:
                # Format: <month> <day>, <year>
                args.date = vals[1] + " " + vals[2] + ", " + vals[0]
    if args.html:
      ICRJsonToHtml.run(args)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='VistA ICR Parser')
    parser.add_argument('-mr', '--MRepositDir', required=True,
                          help='VistA M Component Git Repository Directory')
    parser.add_argument('-pr', '--patchRepositDir', required=True,
                          help="VistA Git Repository Directory")
    parser.add_argument('icrfile', help='path to the VistA ICR file')
    parser.add_argument('icrJsonFile', help='path to the output JSON file')
    parser.add_argument('outdir', help='path to the output web page directory')
    parser.add_argument('pdfOutdir', help='path to the output PDF directory')
    parser.add_argument('-html', action='store_true',
                          help='generate html')
    parser.add_argument('-pdf', action='store_true',
                          help='generate html')
    parser.add_argument('-local', action='store_true',
                      help='Use links to local DOX pages')
    result = parser.parse_args()
    initConsoleLogging()
    run(result)
