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

import sys,os,re,time
import TestHelper

def printMenuParentPairs(VistA,outputFile):
  VistA.write("S DUZ=1 D ^XUP")
  VistA.wait('Select OPTION NAME')
  VistA.write("Systems Manager Menu")
  VistA.wait("Systems Manager Menu")
  VistA.write("Menu Management")
  VistA.wait("Menu Management")
  VistA.write("List Options by Parents and Use")
  VistA.wait("PACKAGE/OPTION name")
  VistA.write("ALL")
  VistA.wait("DEVICE")
  VistA.write("HFS")
  VistA.wait("HOST FILE NAME")
  VistA.write(os.path.normpath(outputFile))
  VistA.wait("ADDRESS/PARAMETERS")
  if VistA.type=="GTM":
    VistA.write("NEWVERSION:NOREADONLY:VARIABLE")
  else:
    VistA.write('')
  VistA.wait("Menu Management")
  VistA.write("^")
  VistA.wait("Systems Manager Menu")
  VistA.write("^")

def printMenuTextPairs(VistA,outputFile):
  VistA.write("S DUZ=1 D Q^DI")
  VistA.wait('Select OPTION')
  VistA.write("PRINT FILE ENTRIES")
  VistA.wait_re("OUTPUT FROM WHAT FILE")
  VistA.write("OPTION")
  index = VistA.multiwait(["CHOOSE","SORT BY"])
  if index == 0:
    VistA.write("1")
    VistA.wait_re("SORT BY")
  VistA.write("")
  VistA.wait_re("START WITH NAME")
  VistA.write("")
  VistA.wait_re("FIRST PRINT FIELD")
  VistA.write(".01")
  VistA.wait_re("THEN PRINT FIELD")
  VistA.write("1")
  VistA.wait_re("THEN PRINT FIELD")
  VistA.write("")
  VistA.wait_re("Heading")
  VistA.write("")
  VistA.wait("DEVICE")
  VistA.write("HFS")
  VistA.wait("HOST FILE NAME")
  VistA.write(os.path.normpath(outputFile))
  VistA.wait("ADDRESS/PARAMETERS")
  if VistA.type=="GTM":
    VistA.write("NEWVERSION:NOREADONLY:VARIABLE")
  else:
    VistA.write('')
  VistA.wait("Select OPTION")
  VistA.write("")

def queryMenuName(VistA,optionname):
  try:
    return VistA.optionMenuTextDict[optionname]
  except KeyError:
    parents = optionname.split(",")
    return VistA.optionMenuTextDict[parents[0]]

def escapeMenuName(menuname):
  menuname = menuname.replace("-S-","").replace("-P-","").replace("-T-","")
  menuname = menuname.strip()
  return menuname

def findparentmenus(VistA,goal):
  try:
    if VistA.optionParentDict[goal] == '** no parents **':
      return True,str(goal)
    else:
      result = findparentmenus(VistA,escapeMenuName(VistA.optionParentDict[goal]))
      if result:
        return result[0], result[1]+ "|" + goal
  except KeyError:
    parents=goal.split(",")
    if VistA.optionParentDict[parents[0]] == '** no parents **':
      return True,str(parents[0])
    else:
      result = findparentmenus(VistA,escapeMenuName(VistA.optionParentDict[parents[0]]))
      if result:
        return result[0], result[1]+ "|" + parents[0]

def createOptionParentDictionary(VistA,filepath="blah2.txt"):
  import re
  if not os.path.exists(filepath):
    printMenuParentPairs(VistA,filepath)
  testinfo = file(filepath,"r").readlines()
  header = re.compile("^OPTION[ ]+PARENTS")
  width = re.compile("PARENTS")
  for line in testinfo:
    result = header.search(line)
    if result:
      space = width.search(line).start()
      break
  filelist=dict()
  optionsRE = re.compile("^[A-Z0-9-&,*#.!()% /]+")
  parentsRE = re.compile("\*\* no parents \*\*|[A-Z0-9-*()#%,&!. /]+")
  for line in testinfo:
    option = optionsRE.search(line[:space])
    parent = parentsRE.search(line[space:])
    if option and parent and (not "CROSS" in option.group(0) and not "SECONDARY" in parent.group(0) and not "PARENTS" in parent.group(0) and not "-----" in option.group(0) and not option.group(0) == '                               '):
      filelist[escapeMenuName(option.group(0))] = escapeMenuName(parent.group(0))
  return filelist

def createOptionMenuTextDictionary(VistA,filepath="blah3.txt"):
  import re
  if not os.path.exists(filepath):
    printMenuTextPairs(VistA,filepath)
  testinfo = file(filepath,"r").readlines()
  header = re.compile("^NAME[ ]+MENU TEXT")
  width = re.compile("MENU TEXT")
  for line in testinfo:
    result = header.search(line)
    if result:
      space = width.search(line).start()
      break
  filelist=dict()
  optionsRE = re.compile("^[A-Z0-9-*!#%&,.() /]+")
  menutextRE = re.compile("[A-Za-z0-9-*!%&#,.() /]+")
  for line in testinfo:
    option = optionsRE.search(line[:space])
    menutext = menutextRE.search(line[space:])
    if option and menutext and (not "CROSS" in option.group(0) and not "SECONDARY" in menutext.group(0) and not "menutextS" in menutext.group(0) and not option.group(0) == '                               '):
      filelist[escapeMenuName(option.group(0))] = escapeMenuName(menutext.group(0))
  return filelist

def findMenuPath(VistA,targetmenu,optionprintDirectory):
  menutext=[]
  parentfile    = os.path.join(optionprintDirectory,"MenuParentMap.txt")
  menutextfile  = os.path.join(optionprintDirectory,"MenuTextMap.txt")
  if not VistA.optionParentDict:
    VistA.optionParentDict   =createOptionParentDictionary(VistA,parentfile)
  if not VistA.optionMenuTextDict:
    VistA.optionMenuTextDict =createOptionMenuTextDictionary(VistA,menutextfile)
  test = findparentmenus(VistA,targetmenu)
  menupath = test[1].split("|")
  for menu in menupath:
    menutext.append(queryMenuName(VistA,menu))
  return menutext,menupath

def moveCommonPath(VistA,result):
  for index in range(0,len(VistA.MenuLocation)):
    try:
      if VistA.MenuLocation[index] == result[0]:
        result.pop(0)
        continue
      else:
        break
    except IndexError:
        break
  if index == 0:
    VistA.write("Quit")
    while True:
      index2 = VistA.multiwait([VistA.prompt,'Do you want to halt',"Option","to continue"])
      if index2==0:
        break
      if index2==1:
        VistA.write('Y')
      if index2==2:
        VistA.write('CONTINUE')
      if index2==3:
        VistA.write('')
    VistA.MenuLocation=[]
    VistA.write('D ^XUP')
    VistA.wait('Select OPTION NAME')
  else:
    for outindex in range(len(VistA.MenuLocation)-1,index-1,-1):
      while True:
        VistA.write("")
        index = VistA.multiwait(["to continue", "Select " + re.escape(VistA.MenuLocation[outindex]),"Select " + re.escape(VistA.MenuLocation[outindex-1])])
        if index == 2:
          break
      VistA.MenuLocation.pop(outindex)
  return result

def goToOption(VistA,targetmenuname,menuPrint,accesscode='',SToption=False):
  menutextresult,pathresult=findMenuPath(VistA,targetmenuname,menuPrint)
  if VistA.MenuLocation:
    newresult = moveCommonPath(VistA,menutextresult)
  else:
    VistA.MenuLocation=[]
    if accesscode:
      VistA.write('K  D ^XUP')
      VistA.wait('Access Code')
      VistA.write(accesscode)
    else:
      VistA.write('S DUZ=1,XUMF=1 D ^XUP')
    VistA.wait('Select OPTION NAME')
  for menuname in menutextresult:
    menufound = False
    VistA.write(menuname[:30])
    while not menufound:
      searchstrings = ["Site parameters must be specified",":","before you can continue","Do you wish", VistA.prompt,"Select OPTION NAME", '\\?\\?$']
      if SToption:
       searchstrings += ["Room","START WITH","Select Patient:","Select number","Enter selection","Site Name","You are not authorized","denied"]
      try:
        index = VistA.multiwait(searchstrings,90)
      except TestHelper.TestError:
        index = -1
      if index == -1:
        VistA.exitToPrompt()
        raise NameError("Unable to continue")
      if index == 0:
        VistA.write("No")
      if index == 1:
        if "to continue" in VistA.lastconnection:
          VistA.write("")
        elif "Select " + menuname in VistA.lastconnection:
          menufound=True
        elif "Select Action" in VistA.lastconnection:
          menufound=True
        elif "DIVISION" in VistA.lastconnection:
          VistA.write("VISTA MEDICAL CENTER")
        elif "CHOOSE" in VistA.lastconnection:
          while True:
            object = re.search("[0-9].+"+pathresult[menutextresult.index(menuname)],VistA.lastconnection)
            if not object is None:
              VistA.write(object.group(0)[0])
              break
            else:
              VistA.write("")
              index2 = VistA.multiwait(["CHOOSE","before you can continue","Option","Select OPTION NAME"])
              if index2 >= 1:
                VistA.write("")
                break
        #else:
        #  menufound=True
      if index == 2 or index == 3:
        VistA.write("^")
      if index >= 4 and index <=6:
        VistA.exitToPrompt()
        raise NameError("Menu Not Found")
      if index >6:
        VistA.write("^")
    VistA.MenuLocation.append(menuname)
