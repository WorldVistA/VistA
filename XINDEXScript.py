import sys,os
sys.path = [sys.argv[7] + '/lib/vista'] + sys.path
from OSEHRAHelper import ConnectToMUMPS,PROMPT

VistA=ConnectToMUMPS(sys.argv[1],sys.argv[3],sys.argv[4])
if (sys.argv[5] and sys.argv[6]):
  VistA.login(sys.argv[5],sys.argv[6])
if VistA.type=='cache':
  try:
    VistA.ZN(sys.argv[4])
  except IndexError,no_namechange:
    pass

if sys.argv[8]=='ON':
  VistA.wait(PROMPT)
  VistA.startCoverage()
VistA.wait(PROMPT)
VistA.write('K ^XUTL("XQ",$J)')
VistA.write('D ^XINDEX')
if VistA.type == 'cache':
  VistA.wait('No =>')
  VistA.write('No')
arglist = sys.argv[2].split(',')
for routine in arglist:
  VistA.wait('Routine:')
  VistA.write(routine)
VistA.wait('Routine:')
VistA.write('')
selectionList = ['Select BUILD NAME:',
                 'Select INSTALL NAME:',
                 'Select PACKAGE NAME:']
while True:
  index = VistA.multiwait(selectionList)
  VistA.write('')
  if index == len(selectionList) - 1:
    break
VistA.wait('warnings?')
VistA.write('No')
VistA.wait('routines?')
VistA.write('NO')
VistA.wait('DEVICE:')
VistA.write(';;9999')
if sys.platform == 'win32':
  VistA.wait('Right Margin:')
  VistA.write('')
VistA.write('')
VistA.wait('continue:',60)
VistA.write('')
VistA.wait('--- END ---',60)
if sys.argv[8]=='ON':
  VistA.stopCoverage(os.path.normpath(sys.argv[1]))
VistA.write('h')
