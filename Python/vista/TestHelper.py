'''
Created on Mar 2, 2012

@author: pbradley
'''
import csv
import logging

class TestError(Exception):
    ''' Unexpected test result exception '''
    def __init__(self, value):
        self.value = value
    def __str__(self):
        return repr(self.value)

class CSVFileReader(object):
    '''
    classdocs
    '''

    def getfiledata (self, fname, fhkey, getrow=None):
        infile = open(fname)
        csvreader = csv.DictReader(infile, delimiter='|')
        table = {}
        for rowdata in csvreader:
            key = rowdata.pop(fhkey)
            table[key] = rowdata
        if getrow is None:
            return table
        else:
            row = {getrow: table[getrow]}
            return row
