#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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
import csv,os,sys

class Prefix:
  def __init__(self, exclude, name):
    self.exclude = exclude
    self.name = name
  def __str__(self):
    return self.exclude + self.name
  def __cmp__(l,r):
    """Order prefixes from shortest to longest, ignoring exclude mark."""
    if len(l.name) < len(r.name):
        return -1
    elif len(l.name) > len(r.name):
        return +1
    else:
        return cmp(l.name,r.name)

def FindPackagePrefixes(packagename,packages_csv_file):
  packages_csv = csv.DictReader(open(packages_csv_file,'rb'))
  package_dir_name = packagename.replace('_',' ')
  packageprefix = []
  """
   This section finds the package prefixes that will be used for the XINDEX testing.
   This list is then sorted by size to be used in either the ^%RD utility (Cache) or
   the ^%RSEL utility (GT.M)

   Uncategorized:  Takes all package prefixes from the Packages.csv file and
   changes the list of prefixes so that the package-prefixed routines will be removed
   from the listing, and the excluded-prefixed routines are kept.  This will remove the
   routines that we know are part of a package, leaving behind only the Uncategorized.
   IE:
   Clinical Information Resource Network  RG        ->     'RG
                                          MRF       ->     'MRF
                                          !RGED     ->     RGED
                                          !RGUT     ->     RGUT
                                          !RGWB     ->     RGWB
  All other Packages:  Take the package prefixes that correspond to their respective
  and use the prefixes without changing the inclusion boolean.  This setup will give
  the list of routines for each individual package.

  Clinical Information Resource Network RG        ->     RG
                                        MRF       ->     MRF
                                        !RGED     ->     'RGED
                                        !RGUT     ->     'RGUT
                                        !RGWB     ->     'RGWB
  The prefixes are then sorted shortest to longest by length, and passed to the function that
  uses the routine utility to list the proper routines.

  The above prefixes will create a list like this:
  ['RG', 'MRF', "'RGED", "'RGUT", "'RGWB"]
  """
  included = set()
  excluded = set()
  if packagename == "Uncategorized":
    for fields in packages_csv:
      if fields['Prefixes']:
        prefix = fields['Prefixes']
        if prefix.startswith("!"):
          included.add(prefix[1:])
        else:
          excluded.add(prefix)
    # Exclude all system (%) routines
    excluded.add("%")
    included = included - excluded
  else:
    inSpecifiedPackage=False
    for fields in packages_csv:
      newDirName = fields['Directory Name']
      if newDirName:
        if newDirName == package_dir_name:
          inSpecifiedPackage=True
        elif inSpecifiedPackage:
          break
      if inSpecifiedPackage:
        prefix = fields['Prefixes']
        if prefix:
          if prefix.startswith("!"):
            excluded.add(prefix[1:])
          else:
            included.add(prefix)
    excluded = excluded - included

  included_prefixes = [Prefix( "",x) for x in included]
  excluded_prefixes = [Prefix("'",x) for x in excluded]
  prefixes = sorted(included_prefixes+excluded_prefixes)
  return [str(x) for x in prefixes]

def FindPackageFiles(packagename,packages_csv_file):
  packages_csv = csv.DictReader(open(packages_csv_file,'rb'))
  package_dir_name = packagename.replace('_',' ')
  packageprefix = []
  """
   This section finds the FileMan file names that are contained in each package.  The
   list will be passed to the "Verify Fields" Utility option of FileMan to check the
   database as a test.

   At this point, we will simply return the list for each package.
  """

  included = set()
  inSpecifiedPackage=False
  for fields in packages_csv:
    newDirName = fields['Directory Name']
    if newDirName:
      if newDirName == package_dir_name:
        inSpecifiedPackage=True
      elif inSpecifiedPackage:
        break
    if inSpecifiedPackage:
      filenum = fields['File Numbers']
      if filenum:
          included.add(filenum)

  included_File_Names = [Prefix( "",x) for x in included]
  File_Names = sorted(included_File_Names)
  return [str(x) for x in File_Names]

if __name__ == '__main__':
  print ('sys.argv is %s' % sys.argv)
  if len(sys.argv) <= 1:
    print ('Need the two arguments arguments:packagename,packages_csv_file ')
    sys.exit()
  prefixes = FindPackagePrefixes(sys.argv[1], sys.argv[2])
  files = FindPackageFiles(sys.argv[1], sys.argv[2])
  print prefixes
  print "********************************"
  print files