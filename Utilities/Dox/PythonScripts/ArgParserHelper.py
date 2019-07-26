import argparse

def createArgParser():
    parser = argparse.ArgumentParser(add_help=False) # no help page
    argGroup = parser.add_argument_group(
                              'Initial CrossReference Generator Arguments',
                              "Argument for generating initial CrossReference")
    argGroup.add_argument('-mr', '--MRepositDir', required=True,
                          help='VistA M Component Git Repository Directory')
    argGroup.add_argument('-pr', '--patchRepositDir', required=True,
                          help="VistA Git Repository Directory")
    return parser
