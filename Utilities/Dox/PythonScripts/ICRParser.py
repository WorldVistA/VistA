#!/usr/bin/env python
#---------------------------------------------------------------------------
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
#---------------------------------------------------------------------------

import argparse

from ICRFileToJson import convertICRToJson
from ICRJsonToHtml import convertJson
import ICRSchema

from LogManager import initConsoleLogging

# Note: The parameter names in the generate_<...> functions
# must match the argument names *exactly*
def generate_json(icrFile=None, icrJsonFile=None):
    # Convert ICR file to JSON
    convertICRToJson(icrFile, icrJsonFile)


def generate_html(icrFile=None, icrJsonFile=None, MRepositDir=None,
                  patchRepositDir=None, outDir=None, local=False):
    _generate(icrFile, icrJsonFile, MRepositDir, patchRepositDir,
              generateHTML=True, outDir=outDir, local=local)


def generate_pdf(icrFile=None, icrJsonFile=None, MRepositDir=None,
                 patchRepositDir=None, pdfOutDir=None, local=False):
    _generate(icrFile, icrJsonFile, MRepositDir, patchRepositDir,
              generatePDF=True, pdfOutDir=pdfOutDir, local=local)


def generate_all(icrFile=None, icrJsonFile=None, MRepositDir=None,
                 patchRepositDir=None, outDir=None, pdfOutDir=None,
                 local=False):
    _generate(icrFile, icrJsonFile, MRepositDir, patchRepositDir,
              generateHTML=True, generatePDF=True,
              outDir=outDir, pdfOutDir=pdfOutDir, local=local)


def _generate(icrFile, icrJsonFile, MRepositDir=None, patchRepositDir=None,
              generateHTML=False, generatePDF=False,
              outDir=None, pdfOutDir=None, local=False):
    initConsoleLogging()

    generate_json(icrFile, icrJsonFile)
    if generateHTML or generatePDF:
        # Look for date file was created
        date = ICRSchema.getDate(icrFile)
        convertJson(icrJsonFile, date, MRepositDir, patchRepositDir,
                    generateHTML=generateHTML, generatePDF=generatePDF,
                    outDir=outDir, pdfOutDir=pdfOutDir, local=local)


def create_arg_parser():
    parser = argparse.ArgumentParser(description='VistA ICR Parser')

    # All parsers use these arguments
    base_parser = argparse.ArgumentParser(add_help=False)
    base_parser.add_argument('icrFile',  help='path to the VistA ICR file')
    base_parser.add_argument('icrJsonFile', help='path to the output JSON file')

    subparsers = parser.add_subparsers()
    # Create the parser for the "json" command
    json_parser = subparsers.add_parser('json', parents=[base_parser],
                                        help='Convert ICR file to JSON')
    json_parser.set_defaults(func=generate_json)

    # Both html and pdf parsers use these arguments
    html_and_pdf_parser = argparse.ArgumentParser(add_help=False)
    html_and_pdf_parser.add_argument('-mr', '--MRepositDir', required=True,
                                     help='VistA M Component Git Repository Directory')
    html_and_pdf_parser.add_argument('-pr', '--patchRepositDir', required=True,
                                     help="VistA Git Repository Directory")
    html_and_pdf_parser.add_argument('-local', action='store_true',
                                     help='Use links to local DOX pages')

    # Create the parser for the "html" command
    html_parser = subparsers.add_parser('html', parents=[base_parser, html_and_pdf_parser],
                                        help='Convert ICR file to JSON and HTML')
    html_parser.add_argument('-o', '--outDir', required=True,
                                     help='path to the output web page directory')
    html_parser.set_defaults(func=generate_html)

    # Create the parser for the "pdf" command
    pdf_parser = subparsers.add_parser('pdf', parents=[base_parser, html_and_pdf_parser],
                                        help='Convert ICR file to JSON and PDF')
    pdf_parser.add_argument('-po', '--pdfOutDir', required=True,
                            help='path to the output PDF directory')
    pdf_parser.set_defaults(func=generate_pdf)

    # Create the parser for the "all" command
    all_parser = subparsers.add_parser('all', parents=[base_parser, html_and_pdf_parser],
                                        help='Convert ICR file to JSON, PDF and HTML')
    all_parser.add_argument('-o', '--outDir', required=True,
                            help='path to the output web page directory')
    all_parser.add_argument('-po', '--pdfOutDir', required=True,
                            help='path to the output PDF directory')
    all_parser.set_defaults(func=generate_all)

    # Create the parser for the "all" command

    return parser

if __name__ == '__main__':
    arg_parser = create_arg_parser()
    args = arg_parser.parse_args()
    kargs = vars(args)
    func = kargs["func"]
    del kargs["func"]
    func(**kargs)
