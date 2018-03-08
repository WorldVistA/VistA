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
import sys
import os
import time
import TestHelper
from OSEHRAHelper import PROMPT

introText = """**************************************************
  *  Welcome to VistA
  **************************************************
  *
  * Use the following credentials for Robert Alexander
  *   Access:  fakedoc1
  *   Verify:  1Doc!@#$
  *
  * Use the following credentials for Mary Smith (Nurse)
  *   Access:  fakenurse1
  *   Verify:  1Nur!@#$
  *
  * Use the following credentials for Joe Clerk (Clerk)
  *   Access:  fakeclerk1
  *   Verify:  1Cle!@#$
  *
  * If you have any issue, please email your question to admin@osehra.org
  **************************************************
"""

def startFileman(VistA):
  # Start FileMan as the programmer user and set XUMF to 1 which lets the user
  # change information in Kernel files
  # Starts at the VistA Prompt
  VistA.wait(PROMPT)
  VistA.write('S DUZ=1 S XUMF=1 D Q^DI')
  VistA.wait('Select OPTION:')

def signonZU(VistA,acc_code,ver_code):
  # Sign a user into the ZU menu system
  # The User must have a valid access code and verify code.
  # If the user needs to change the Verify Code, the script will append a "!" to the old code
  # and use that as the new one.
  # Starts at the VistA prompt.
  VistA.wait(PROMPT,60)
  VistA.write('D ^ZU')
  VistA.wait('ACCESS CODE:')
  VistA.write(acc_code)
  VistA.wait('VERIFY CODE:')
  VistA.write(ver_code)
  index = VistA.multiwait(['TYPE NAME','verify code:'])
  if index==1:
    VistA.write(ver_code)
    VistA.wait('VERIFY CODE:')
    VistA.write(ver_code+"!")
    VistA.wait('right:')
    VistA.write(ver_code+"!")
    VistA.wait('TYPE NAME:')
  VistA.write('')

def initializeFileman(VistA,site_name,site_number):
  # Initializes FileMan via the DINIT routine.
  # The command needs a site name to change to and a local site number
  # Script uses value of CMake variable TEST_VISTA_SETUP_SITE_NAME as the name
  # and 6161 as the site number.
  VistA.write('D ^DINIT')
  VistA.wait('Initialize VA FileMan now?')
  VistA.write('Yes')
  VistA.wait('SITE NAME:')
  VistA.write(site_name)
  VistA.wait('SITE NUMBER')
  VistA.write(site_number)
  # It will also change the operating system file to match the local environment type
  # found by the set up.
  VistA.wait('Do you want to change the MUMPS OPERATING SYSTEM File?')
  VistA.write('Yes')
  VistA.wait('TYPE OF MUMPS SYSTEM YOU ARE USING')
  if VistA.type=='cache':
    VistA.write('CACHE')
  else:
    VistA.write('GT.M(UNIX)')
  VistA.wait(PROMPT,60)
  # Use the ZUSET routine to rename the correct ZU* for the system.
  VistA.write('D ^ZUSET')
  VistA.wait('Rename')
  VistA.write('Yes')

def setupPrimaryHFSDir(VistA,hfs_dir):
  # Set up the primary HFS directory from the
  # Kernel System Parameters file
  #
  # "@" to remove or set a new file path.
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('KERNEL SYSTEM PARAMETERS')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('PRIMARY HFS DIRECTORY')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('')
  VistA.wait('DOMAIN NAME')
  # `1 is the notation to grab the entry with a number of 1
  VistA.write('`1')
  VistA.wait('PRIMARY HFS DIRECTORY')
  VistA.write(os.path.normpath(hfs_dir))
  # Multiwait to capture the possible outcomes:
  # SURE YOU WANT TO DELETE:   File has an entry and the @ will delete it
  # DOMAIN NAME:               Entry was an acceptable response
  # PRIMARY HFS DIRECTORY:     Response was not accepted, could be due to
  #                            deleting an empty file entry
  index = VistA.multiwait(['SURE YOU WANT TO DELETE','DOMAIN NAME','PRIMARY HFS DIRECTORY'])
  if index == 0:
    VistA.write('Y')
    VistA.wait('DOMAIN NAME')
  if index == 2:
    VistA.write("")
    VistA.wait("DOMAIN NAME")
  VistA.write('')
  VistA.wait('Select OPTION:')
  VistA.write('')

def setupIntroText(VistA):
  # Set up the introduction text for the VistA system
  #
  # Normally, is displayed on CPRS and other GUIs
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('KERNEL SYSTEM PARAMETERS')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('INTRO MESSAGE')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('')
  VistA.wait('DOMAIN NAME')
  # `1 is the notation to grab the entry with a number of 1
  VistA.write('`1')
  index = VistA.multiwait(['EDIT Option','1>$'])
  if index == 0:
    VistA.write("D")
    VistA.wait('Delete from line')
    VistA.write("1")
    VistA.wait('thru')
    VistA.write("")
    VistA.wait('OK TO REMOVE')
    VistA.write("Y")
    VistA.wait('ARE YOU SURE')
    VistA.write("Y")
    VistA.wait('EDIT Option')
    VistA.write("A")
    VistA.wait('Add lines')
  VistA.write(introText+'\r')
  VistA.wait("EDIT Option")
  VistA.write("")
  VistA.wait("DOMAIN NAME")
  VistA.write('')
  VistA.wait('Select OPTION:')
  VistA.write('')

def configureNULLDevice(VistA):
  # Ensure that the null device is correctly configured by adding
  # a $I for the correct platform rather than VMS and removing
  # sign-on capabilities
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('DEVICE')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('$I\rSIGN-ON/SYSTEM DEVICE\r')
  VistA.wait('NAME:')
  VistA.write('NULL\r1')
  VistA.wait('//')
  #  Path added is dependent on the platform that is being used.
  if sys.platform=='win32':
    VistA.write('//./nul\rNO\r')
  else:
    VistA.write('/dev/null\rNO\r')
  VistA.wait("Select OPTION")
  VistA.write("")

def configureConsoleDevice(VistA):
  # Ensure that the console device is correctly configured by adding
  # sign-on capabilities
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('DEVICE')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('SIGN-ON/SYSTEM DEVICE\r')
  VistA.wait('NAME:')
  VistA.write('/dev/tty')
  VistA.wait('SYSTEM DEVICE')
  VistA.write('Y\r')
  VistA.wait("Select OPTION")
  VistA.write("")

def setupVistADomain(VistA,site_name):
  # Enter the site name into the DOMAIN file via FileMan
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('DOMAIN\r')
  VistA.wait('Select DOMAIN NAME')
  VistA.write(site_name)
  # Multiwait for possible outcomes:
  # Are you adding:    Domain is new and will add it to the system
  # NAME:              Domain exists already
  index = VistA.multiwait(["Are you adding","NAME"])
  if index == 0:
    VistA.write("Y")
  else:
    VistA.write("")
  VistA.wait("FLAGS")
  VistA.write('^\r\r')
  VistA.wait(PROMPT,60)
  # christen the domain via the XMUDCHR routine.
  VistA.write('D CHRISTEN^XMUDCHR')
  VistA.wait('Are you sure you want to change the name of this facility?')
  VistA.write('Yes')
  VistA.wait('Select DOMAIN NAME')
  VistA.write(site_name)
  VistA.wait('PARENT')
  VistA.write('')
  VistA.wait('TIME ZONE')
  # Attempts to pull the timezone from the local machine via Python
  # If entry is not accepted, will default to EST
  VistA.write(time.strftime('%Z').replace(' Time',''))
  index = VistA.multiwait([VistA.prompt,'TIME ZONE'])
  if index==1:
    VistA.write('EST')
    VistA.wait(PROMPT,60)
  # Next, Find IEN of new site name and add entries of new domain to
  # Kernel System Parameters and RPC Broker Site Parameters files
  VistA.IEN('DOMAIN',site_name)
  VistA.wait(PROMPT,60)
  VistA.write('S $P(^XWB(8994.1,1,0),"^")=' + VistA.IENumber)
  VistA.write('S $P(^XTV(8989.3,1,0),"^")=' + VistA.IENumber)
  # Then, re-index both files with the FileMan Utility.
  startFileman(VistA)
  VistA.write('UTILITY')
  VistA.wait('UTILITY OPTION')
  VistA.write('RE')
  VistA.wait_re('MODIFY WHAT FILE')
  VistA.write('8989.3\rNO\rY\rY')
  VistA.wait('UTILITY OPTION')
  VistA.write('RE')
  VistA.wait_re('MODIFY WHAT FILE')
  VistA.write('8994.1\rNO\rY\rY\r')
  VistA.wait('Select OPTION')
  VistA.write("")

def setupBoxVolPair(VistA,volume_set,site_name,tcp_port):
  # Query the instance for the Box-volume pair of the machine
  VistA.getenv(volume_set)
  # Rename the first Box-volume entry in the Taskman Site Parameters file
  #  to match what was queried above
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('14.7')
  VistA.wait('ALL//')
  VistA.write('')
  VistA.wait('Select TASKMAN SITE PARAMETERS BOX-VOLUME PAIR:')
  VistA.write('`1')
  VistA.wait('//')
  VistA.write(VistA.boxvol)
  VistA.wait('RESERVED')
  VistA.write('^\r')
  #time.sleep(5)
  # Add the Box-volume pair to the RPC Broker parameters for the local domain
  # Also adds the information for the new style RPC Broker Listener on the supplied TCP port
  # if a Cache system, will start a task to start the Listener, and put the
  # listener under the Listener Starter's control
  # if a GT.M system, will create the information but not start it.
  VistA.wait('Select OPTION')
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('8994.1')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('LISTENER')
  VistA.wait("SUB-FIELD")
  VistA.write("")
  VistA.wait("THEN EDIT FIELD")
  VistA.write("")
  VistA.wait('Select RPC BROKER SITE PARAMETERS DOMAIN NAME')
  VistA.write(site_name)
  VistA.wait("OK")
  VistA.write("Y")
  VistA.wait("BOX-VOLUME PAIR")
  VistA.write(VistA.boxvol + '\r')
  VistA.wait("BOX-VOLUME PAIR")
  VistA.write("")
  VistA.wait("Select PORT")
  VistA.write(tcp_port + '\rY')
  if VistA.type=='cache':
    VistA.write('1\r1\r1\r')
  else:
    VistA.write('1\r\r\r')
  VistA.wait("Select OPTION")
  VistA.write("")

def setupVolumeSet(VistA,site_name,volume_set,namespace=""):
  # Rename first entry in the Volume Set file to match
  # the CMake value of TEST_VISTA_SETUP_VOLUME_SET.
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('14.5\r')
  VistA.wait('Select VOLUME SET')
  VistA.write('`1')
  VistA.wait('VOLUME SET:')
  VistA.write(volume_set+ '\r\r\r\r\r')
  VistA.wait('TASKMAN FILES UCI')
  if VistA.type=='cache':
    VistA.write(namespace+'\r\r\r\r\r\r')
  else:
    VistA.write(volume_set +'\r\r\r\r\r\r')
  # Add the Volume set information to the Kernel System Parameters File
  VistA.wait('Select OPTION')
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('KERNEL SYSTEM PARAMETERS\rVOLUME SET\r\r')
  VistA.wait('Select KERNEL SYSTEM PARAMETERS DOMAIN NAME:')
  VistA.write(site_name + '\r')
  VistA.wait('VOLUME SET')
  VistA.write(volume_set)
  index = VistA.multiwait(['Are you adding','VOLUME SET'])
  if index==0:
    VistA.write('Y')
  elif index==1:
    VistA.write('')
  # Set up basic information about sign-on to the domain via the Volume Set
  VistA.wait('MAX SIGNON ALLOWED')
  VistA.write('500')
  VistA.wait('LOG SYSTEM RT')
  VistA.write('N')
  VistA.wait('VOLUME SET')
  VistA.write('\r\r')

def scheduleOption(VistA,optionName):
  # If using Cache as the M environment, Schedule a task to start the
  # XWB Listener Starter on the start up of TaskMan
  VistA.wait(PROMPT)
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('Select OPTION NAME')
  VistA.write('EVE\r1')
  VistA.wait('Systems Manager Menu')
  VistA.write('Taskman Management')
  VistA.wait('Select Taskman Management')
  VistA.write('SCHED')
  VistA.wait('reschedule:')
  VistA.write(optionName + '\rY')
  VistA.wait('COMMAND:')
  VistA.write('\r^SPECIAL QUEUEING\rSTARTUP\rS\rE\r')
  VistA.wait('Select Taskman Management')
  VistA.write('')
  VistA.wait('Systems Manager Menu')
  VistA.write('')
  VistA.wait('Do you really want to halt')
  VistA.write('Y')

def restartTaskMan(VistA):
  # Restarts the TaskMan instance via the Taskman Management Utilities Menu.

  VistA.wait(PROMPT)
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('Select OPTION NAME')
  VistA.write('EVE\r1')
  VistA.wait('Systems Manager Menu')
  VistA.write('Taskman Management')
  VistA.wait('Select Taskman Management')
  VistA.write('Taskman Management Utilities')
  VistA.wait('Select Taskman Management Utilities')
  VistA.write('Restart Task Manager\rY')
  VistA.wait('Select Taskman Management Utilities')
  VistA.write('')
  VistA.wait('Select Taskman Management')
  VistA.write('')
  VistA.wait('Select Systems Manager Menu')
  VistA.write('')
  VistA.wait('Do you really want to halt')
  VistA.write('Y')
  VistA.wait(PROMPT)
  VistA.write('K')

def addSystemManager(VistA):
  # Add the super user System Manager via the User Management Menu
  # Set basic information about the user: Name,SSN, Sex ....
  VistA.wait(PROMPT,60)
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('Select OPTION NAME')
  VistA.write('EVE\r1')
  VistA.wait('Systems Manager Menu')
  VistA.write('USER MANAGEMENT')
  VistA.wait('User Management')
  VistA.write('ADD')
  VistA.wait('Enter NEW PERSON')
  VistA.write('MANAGER,SYSTEM')
  index = VistA.multiwait(['Are you adding','Want to reactivate'])
  if index == 0:
    VistA.write('Y')
    VistA.wait('INITIAL:')
    VistA.write('SM')
    VistA.wait('SSN:')
    VistA.write('000000001')
    VistA.wait('SEX:')
    VistA.write('M')
    VistA.wait('NPI')
    VistA.write('')
    VistA.wait('NAME COMPONENTS')
  # A ScreenMan form opens at this point, and the following information is set:
  # Primary Menu:   EVE
  # Secondary Menu: OR PARAM COORDINATOR MENU, TIU IRM MAINTENANCE MENU,
  #                 XPAR MENU TOOLS,DG REGISTER PATIENT
  # Access Code:    SM1234
  # Verify Code:    SM1234!!
  VistA.write('\r\r\r\r\r^PRIMARY MENU OPTION\rEVE\r1\r^Want to edit ACCESS CODE\rY\rSM1234\rSM1234\r^Want to edit VERIFY CODE\rY\rSM1234!!\rSM1234!!\r^SECONDARY MENU OPTIONS\rOR PARAM COORDINATOR MENU\rY\r\r\r\rTIU IRM MAINTENANCE MENU\rY\r\r\r\rXPAR MENU TOOLS\rY\r\r\r\rDG REGISTER PATIENT\rY\r\r\r\r^MULTIPLE SIGN-ON\r1\r1\r99\r^SERVICE/SECTION\rIRM\rS\rE')
  # Exiting the ScreenMan form, Allocate Security Keys
  # For Kernel Access:     XUMGR, XUPROG, XUPROGMODE
  # and Scheduling Access: SD SUPERVISOR, SDWL PARAMETER, SDWL MENU
  VistA.wait('User Account Access Letter')
  VistA.write('NO')
  VistA.wait('wish to allocate security keys?')
  VistA.write('Y')
  VistA.wait('Allocate key')
  VistA.write('XUMGR')
  VistA.wait('Another key')
  VistA.write('XUPROG\r1')
  VistA.wait('Another key')
  VistA.write('XUPROGMODE')
  VistA.wait('Another key')
  VistA.write('SD SUPERVISOR')
  VistA.wait('Another key')
  VistA.write('SDWL PARAMETER')
  VistA.wait('Another key')
  VistA.write('SDWL MENU')
  VistA.wait('Another key')
  VistA.write('')
  VistA.wait('Another holder')
  VistA.write('')
  VistA.wait('YES//')
  VistA.write('')
  VistA.wait('mail groups?')
  VistA.write('\r')
  VistA.wait('Systems Manager Menu')
  VistA.write('\rY')
  VistA.wait(PROMPT,60)
  # Get the record number of the user that was just created
  VistA.IEN('NEW PERSON','MANAGER,SYSTEM')
  VistA.wait(PROMPT,60)
  # Set a piece of the New Person global corresponding to the MANAGER,SYSTEM
  # to "@" to tell FileMan that user is a programmer
  VistA.write('S DUZ=' + VistA.IENumber + ' S $P(^VA(200,DUZ,0),"^",4)="@"')


def addInstitution(VistA,inst_name,station_number):
  # In FileMan, add a entry to the Institution file
  # Pass in the name and number as arguments to allow for
  # multiple additions.
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE:')
  VistA.write('4')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('STATION NUMBER')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('')
  VistA.wait('Select INSTITUTION NAME:')
  VistA.write(inst_name)
  index = VistA.multiwait(['Are you adding','STATION NUMBER'])
  if index==0:
    VistA.write('Y')
    VistA.wait('STATION NUMBER:')
  VistA.write(station_number)
  VistA.wait('Select INSTITUTION NAME:')
  VistA.write('')
  VistA.wait('Select OPTION:')
  VistA.write('')

def addDivision(VistA,div_name, facility_number,station_number):
  # Adds a division to the VistA instance via FileMan,
  # Each Division needs a name and a facility number.  The station number
  # points back to the recently created Institution
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE:')
  VistA.write('40.8')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('FACILITY NUMBER')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('INSTITUTION FILE POINTER')
  VistA.wait('THEN EDIT FIELD')
  VistA.write('')
  VistA.wait('DIVISION NAME')
  VistA.write(div_name)
  VistA.wait('Are you adding')
  VistA.write('Y')
  VistA.wait('MEDICAL CENTER DIVISION NUM:')
  VistA.write('')
  VistA.wait('FACILITY NUMBER')
  VistA.write(facility_number)
  VistA.write('')
  VistA.wait('INSTITUTION FILE POINTER')
  VistA.write(station_number)
  VistA.wait('DIVISION NAME')
  VistA.write('')
  VistA.wait('Select OPTION')
  VistA.write('')

def setupWard(VistA, division, institution, ward_name, clinic_name, order, specialty='Cardiac Surgery', bed_array = [["1-A","testBed1"]] ):
  # Set up an inpatient ward for lodging of users and inpatient medication prescription
  # taken from the ADTActions script of Registration Roll-And-Scroll testing
  VistA.wait(PROMPT)
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('OPTION NAME:')
  # DEFINE THE WARD
  VistA.write('WARD DEFINITION ENTRY')
  VistA.wait('NAME:')
  VistA.write(ward_name)
  VistA.wait('No//')
  VistA.write('YES')
  VistA.wait('POINTER:')
  VistA.write(clinic_name)
  VistA.wait('ORDER:')
  VistA.write(order)
  VistA.wait(ward_name)
  VistA.write('')
  VistA.wait('WRISTBAND:')
  VistA.write('YES')
  VistA.wait('DIVISION:')
  VistA.write(division)
  VistA.wait('INSTITUTION:')
  VistA.write(institution)
  VistA.wait('6100')
  VistA.write('')
  VistA.wait('BEDSECTION:')
  VistA.write('bedselect')
  VistA.wait('SPECIALTY:')
  VistA.write(specialty)
  VistA.wait('SERVICE:')
  VistA.write('S')
  VistA.wait('LOCATION:')
  VistA.write('north')
  VistA.wait('WARD:')
  VistA.write('1')
  VistA.wait('DATE:')
  VistA.write('T')
  VistA.wait('No//')
  VistA.write('YES')
  VistA.wait('BEDS:')
  VistA.write('20')
  VistA.wait('ILL:')
  VistA.write('1')
  VistA.wait('SYNONYM:')
  VistA.write('')
  VistA.wait('G&L ORDER:')
  VistA.write('')
  VistA.wait('TOTALS:')
  VistA.write('')
  VistA.wait('NAME:')
  VistA.write('')
  addBedsToWard(VistA, ward_name, bed_array)

def addBedsToWard(VistA, ward_name, bed_array):
  VistA.wait(PROMPT)
  VistA.write('S DUZ=1 D ^XUP')
  # SETUP BEDS
  VistA.wait('OPTION NAME:')
  VistA.write('ADT SYSTEM')
  VistA.wait('Option:')
  VistA.write('ADD')
  for sitem in bed_array:
     VistA.wait('NAME:')
     VistA.write(sitem[0])
     VistA.wait('No//')
     VistA.write('yes')
     VistA.wait('NAME:')
     VistA.write('')
     VistA.wait('DESCRIPTION:')
     VistA.write(sitem[1])
     VistA.wait('No//')
     VistA.write('yes')
     VistA.wait('ASSIGN:')
     VistA.write(ward_name)
     VistA.wait('No//')
     VistA.write('yes')
     VistA.wait('ASSIGN:')
     VistA.write('')
  VistA.wait('NAME:')
  VistA.write('')
  VistA.wait('Option:')
  VistA.write('')
  VistA.wait('YES//')
  VistA.write('')

def modifyDVBParams(VistA):
  VistA.wait(PROMPT)
  VistA.write('D ^XUP')
  # ADD ENTRY TO FILE 395 DVB PARAMETERS
  VistA.wait('NAME:')
  VistA.write('ZZFILEMAN')
  VistA.wait('OPTION:')
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('395')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('ALL')
  VistA.wait('Select DVB PARAMETERS ONE:')
  VistA.write('1')
  VistA.wait('No//')
  VistA.write('yes')
  VistA.wait('SCREENS?:')
  VistA.write('NO')
  VistA.wait('DAY:')
  VistA.write('^NEW IDCU INTERFACE')
  VistA.wait('INTERFACE:')
  VistA.write('0')
  VistA.wait('Difference:')
  VistA.write('')
  VistA.wait('DIVISION:')
  VistA.write('YES')
  VistA.wait('GROUP:')
  VistA.write('^')
  VistA.wait('Select DVB PARAMETERS ONE:')
  VistA.write('')
  VistA.wait('OPTION:')
  VistA.write('')

def addtoMASParameter(VistA, institution, medical_center):
  # ADD ENTRY TO MAS PARAMETER
  VistA.wait(PROMPT)
  VistA.write('D ^XUP')
  VistA.write('1')
  VistA.wait('Select OPTION NAME')
  VistA.write('ADT SYSTEM')
  VistA.wait('ADT System Definition Menu')
  VistA.write('MAS Parameter Entry')
  VistA.wait('Enter 1-3 to EDIT, or RETURN to QUIT')
  VistA.write('1')
  VistA.wait('MEDICAL CENTER NAME')
  VistA.write(medical_center)
  VistA.wait('AFFILIATED')
  VistA.write('NO')
  VistA.wait('MULTIDIVISION MED CENTER')
  VistA.write('NO')
  VistA.wait('NURSING HOME WARDS')
  VistA.write('')
  VistA.wait('DOMICILIARY WARDS')
  VistA.write('')
  VistA.wait('SYSTEM TIMEOUT')
  VistA.write('30')
  VistA.wait('AUTOMATIC PTF MESSAGES')
  VistA.write('')
  VistA.wait('PRINT PTF MESSAGES')
  VistA.write('')
  VistA.wait('DEFAULT PTF MESSAGE PRINTER')
  VistA.write('')
  VistA.wait('SHOW STATUS SCREEN')
  VistA.write('YES')
  VistA.wait('USE HIGH INTENSITY ON SCREENS')
  VistA.write('^^')
  VistA.wait('Enter 1-3 to EDIT, or RETURN to QUIT')
  VistA.write('2')
  VistA.wait('DAYS TO UPDATE MEDICAID')
  VistA.write('365')
  VistA.wait('DAYS TO MAINTAIN G&L CORR')
  VistA.write('30')
  VistA.wait('TIME FOR LATE DISPOSITION')
  VistA.write('30')
  VistA.wait('SUPPLEMENTAL 10/10')
  VistA.write('0')
  VistA.wait(':')
  VistA.write('^ASK DEVICE IN REGISTRATION')
  VistA.wait('ASK DEVICE IN REGISTRATION')
  VistA.write('YES')
  VistA.wait('DAYS TO MAINTAIN SENSITIVITY')
  VistA.write('30')
  VistA.wait(':')
  VistA.write('^^')
  VistA.wait('Enter 1-3 to EDIT, or RETURN to QUIT')
  VistA.write('3')
  VistA.wait(':')
  VistA.write('^INSTITUTION FILE POINTER')
  VistA.wait('INSTITUTION FILE POINTER')
  VistA.write(institution)
  VistA.wait(':')
  VistA.write('^^')
  VistA.wait('Enter 1-3 to EDIT, or RETURN to QUIT')
  VistA.write('')
  VistA.wait('ADT System Definition Menu')
  VistA.write('')
  VistA.wait('YES//')
  VistA.write('')
  VistA.wait(PROMPT)
  VistA.write('')


def setupNursLocation(VistA, unit_name):
  # Set up a NURS LOCATION entity so that BCMA can connect to the system.
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE:')
  VistA.write('NURS LOCATION')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('')
  VistA.wait('NURSING UNIT NAME')
  VistA.write(unit_name)
  VistA.wait('Are you adding')
  VistA.write('Y')
  VistA.wait('Are you adding')
  VistA.write('Y')
  VistA.wait('PRODUCT LINE')
  VistA.write('NURSING')
  VistA.wait('CARE SETTING')
  VistA.write("INPATIENT")
  VistA.wait('UNIT TYPE')
  VistA.write("CLINICAL")
  VistA.wait('INPATIENT DSS DEPARTMENT')
  VistA.write('')
  VistA.wait('PATIENT CARE FLAG')
  VistA.write('A')
  VistA.wait('INACTIVE FLAG')
  VistA.write('A')
  VistA.wait('MAS WARD')
  VistA.write('')
  VistA.wait('AMIS BED SECTION')
  VistA.write('')
  VistA.wait('PROFESSIONAL PERCENTAGE')
  VistA.write('')
  VistA.wait('UNIT EXPERIENCE')
  VistA.write('')
  VistA.wait('POC DATA ENTRY PERSONNEL')
  VistA.write('')
  VistA.wait('POC DATA APPROVAL PERSONNEL')
  VistA.write('')
  VistA.wait('SERVICE DATE')
  VistA.write('')
  VistA.wait('SERVICE DATE')
  VistA.write('')
  VistA.wait('STATUS')
  VistA.write('')
  VistA.wait('NURSING UNIT NAME')
  VistA.write('')
  VistA.wait('Select OPTION')
  VistA.write('')

def setupStrepTest(VistA):
  # The Sikuli test for CPRS orders a Streptozyme test for the patient
  # This information ensures the test can be ordered at the VistA Health care
  # Facility

  # Add a NUMERIC IDENTIFIER to the Chemistry ACCESSION Area
  # This is necessary to add a laboratory test to an Accession
  # area at an Institution.
  startFileman(VistA)
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('ACCESSION\r1')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('.4\r')
  VistA.wait('Select ACCESSION AREA')
  VistA.write('CHEMISTRY')
  VistA.wait('NUMERIC IDENTIFIER')
  VistA.write('CH\r')

  # Change the STREPTOZYME test to be accessioned through the Chemistry
  # area at the Vista Health Care institution
  VistA.wait('OPTION')
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('LABORATORY TEST')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('ACCESSION AREA\r\r')
  VistA.wait('Select LABORATORY TEST NAME')
  VistA.write('STREPTOZYME')
  VistA.wait('Select INSTITUTION')
  VistA.write('VISTA HEALTH CARE')
  VistA.wait('ACCESSION AREA')
  VistA.write('CHEMISTRY')
  VistA.wait('Select LABORATORY TEST NAME')
  VistA.write('')
  # Change the Package Prefix of the ONCE schedule to be
  # used by the Laboratory
  VistA.wait('OPTION')
  VistA.write('1')
  VistA.wait_re('INPUT TO WHAT FILE')
  VistA.write('ADMINISTRATION SCHEDULE')
  VistA.wait('EDIT WHICH FIELD')
  VistA.write('PACKAGE PREFIX\r')
  VistA.wait('Select ADMINISTRATION SCHEDULE NAME')
  VistA.write('ONCE')
  VistA.wait('P')
  VistA.write('LR')
  VistA.wait('ADMINISTRATION SCHEDULE')
  VistA.write('')
  VistA.wait('Select OPTION')
  VistA.write('')

  # Set Up the Quick Order entry for the Strep Throat
  # Default to a one time, swab collection.
  VistA.wait(PROMPT)
  VistA.write('K  D ^XUP')
  VistA.wait("Access Code")
  VistA.write("SM1234")
  index = VistA.multiwait(['Select OPTION NAME','TERMINAL TYPE NAME'])
  if index ==1:
    VistA.write("C-VT220")
    VistA.wait("Select OPTION NAME")
  VistA.write("Systems Manager Menu")
  VistA.wait('Systems Manager Menu')
  VistA.write('CPRS Configuration')
  VistA.wait('CPRS Configuration')
  VistA.write('MM')
  VistA.wait('Order Menu Management')
  VistA.write('QO')
  VistA.wait('Select QUICK ORDER NAME')
  VistA.write('LRZ STREP TEST')
  VistA.wait('Are you adding')
  VistA.write('Y')
  VistA.wait('TYPE OF QUICK ORDER')
  VistA.write('LAB\r')
  VistA.wait('DISPLAY TEXT')
  VistA.write('STREP TEST')
  VistA.wait('VERIFY ORDER')
  VistA.write('Y')
  VistA.wait('DESCRIPTION')
  VistA.write('N\r')
  VistA.wait('Lab Test')
  VistA.write('STREP\r2')
  VistA.wait('Collected By')
  VistA.write('SP')
  VistA.wait('Collection Sample')
  VistA.write('SWAB\r')
  VistA.wait('Collection Date/Time')
  VistA.write('TODAY\r')
  VistA.wait('How often')
  VistA.write('ONCE')
  VistA.wait('PLACE//')
  VistA.write('\r\r')
  VistA.wait('Option')
  VistA.write('ST')
  VistA.wait('Select ORDER SET NAME')
  VistA.write('STREP TEST')
  VistA.wait('Are you adding')
  VistA.write('Y')
  VistA.wait('Do you wish to copy')
  VistA.write('No\r')
  VistA.wait('DISPLAY TEXT')
  VistA.write('Strep Test\r\r\r')
  VistA.wait('COMPONENT SEQUENCE')
  VistA.write('10\r')
  VistA.wait('ITEM:')
  VistA.write('LRZ STREP TEST\r\r\r\r') # Return to EVE menu
  VistA.wait("Systems Manager Menu")
  VistA.write("")
  VistA.wait("Do you really")
  VistA.write("Y")

def registerVitalsCPRS(VistA):
  # Register the DLL versions for Vitals and the executable version for
  # CPRS through the XPAR Menu.  This information should match the versions
  # that will be used during testing.
  # Files can be downloaded: http://www.osehra.org/document/guis-used-automatic-functional-testing
  VistA.wait(PROMPT,60)
  VistA.write('S GMVDLL=\"GMV_VITALSVIEWENTER.DLL:v. 08/11/09 15:00\"')
  VistA.wait(PROMPT,60)
  VistA.write('D EN^XPAR(\"SYS\",\"GMV DLL VERSION\",GMVDLL,1)')
  VistA.wait(PROMPT,60)
  VistA.write('S GMVDLL=\"GMV_VITALSVIEWENTER.DLL:v. 01/21/11 12:52\"')
  VistA.wait(PROMPT,60)
  VistA.write('D EN^XPAR(\"SYS\",\"GMV DLL VERSION\",GMVDLL,1)')
  VistA.wait(PROMPT,60)
  VistA.write('S GMVGUI=\"VITALSMANAGER.EXE:5.0.26.1\"')
  VistA.wait(PROMPT,60)
  VistA.write('D EN^XPAR(\"SYS\",\"GMV GUI VERSION\",GMVGUI,1)')
  VistA.wait(PROMPT,60)
  VistA.write('S GMVGUI=\"VITALS.EXE:5.0.26.1\"')
  VistA.wait(PROMPT,60)
  VistA.write('D EN^XPAR(\"SYS\",\"GMV GUI VERSION\",GMVGUI,1)')

def addDoctor(VistA,name,init,SSN,sex,AC,VC1):
  # Adds a Doctor user into the system via the User Management Menu as
  # the System Manager.
  # Needs:
  # Doctor Name, Doctor Initials, SSN, Sex, Access Code, Verify Code
  VistA.write('USER MANAGEMENT')
  VistA.wait('User Management')
  VistA.write('ADD')
  VistA.wait('name')
  VistA.write(name+'\rY')
  VistA.wait('INITIAL:')
  VistA.write(init)
  VistA.wait('SSN:')
  VistA.write(SSN)
  VistA.wait('SEX:')
  VistA.write(sex)
  VistA.wait('NPI')
  VistA.write('')
  VistA.wait('NAME COMPONENTS')
  # A ScreenMan form opens at this point, and the following information is set:
  # Primary Menu:   XUCORE
  # Secondary Menu: PSB GUI CONTEXT, GMPL MGT MENU, OR CPRS GUI CHART, GMV V/M GUI,
  # Access Code:    <passed as argument>
  # Verify Code:    <passed as argument>
  # No restriction on Patient Selection
  # Allowed multiple sign-ons
  # Allopathic and Osteopathic Physicians as the Person Class
  # Core CPRS Tab access
  VistA.write('\r\r\r\r\r^PRIMARY MENU OPTION\rXUCOR\r^SECONDARY MENU OPTIONS\rPSB GUI CONTEXT\rY\r\r\r\rGMPL MGT MENU\rY\r\r\r\rOR CPRS GUI CHART\rY\r\r\r\rGMV V/M GUI\rY\r\r\r\r^Want to edit ACCESS CODE\rY\r'+AC+'\r'+AC+'\r^Want to edit VERIFY CODE\rY\r'+VC1+'\r'+VC1+'\rVISTA HEALTH CARE\rY\r\r\r\r\r^SERVICE/SECTION\rIRM\r^Language\r\r767\rY\rY\rT-1\r\r^RESTRICT PATIENT SELECTION\r0\r\rCOR\rY\rT-1\r\r^MULTIPLE SIGN-ON\r1\r1\r99\r^\rS\rE')
  # Exiting the ScreenMan form, Allocate Security Keys
  # PROVIDER,GMV MANAGER,LRLAB,LRVERIFY,ORES,SD SUPERVISOR,SDWL PARAMETER,SDWL MENU,
  VistA.wait('User Account Access Letter')
  VistA.write('NO')
  VistA.wait('wish to allocate security keys?')
  VistA.write('Y')
  VistA.wait('Allocate key')
  VistA.write('PROVIDER\r1')
  VistA.wait('Another key')
  VistA.write('GMV MANAGER')
  VistA.wait('Another key')
  VistA.write('LRLAB')
  VistA.wait('Another key')
  VistA.write('LRVERIFY')
  VistA.wait('Another key')
  VistA.write('ORES')
  VistA.wait('Another key')
  VistA.write('SD SUPERVISOR')
  VistA.wait('Another key')
  VistA.write('SDWL PARAMETER')
  VistA.wait('Another key')
  VistA.write('SDWL MENU')
  VistA.wait('Another key')
  VistA.write('PSB MANAGER')
  VistA.wait('Another key')
  VistA.write('')
  VistA.wait('Another holder')
  VistA.write('')
  VistA.wait('Do you wish to proceed')
  VistA.write('Yes')
  VistA.wait('add this user to mail groups')
  VistA.write('NO')
  VistA.wait("User Management")
  VistA.write("")

def addNurse(VistA,name,init,SSN,sex,AC,VC1):
  # Adds a Nurse user into the system via the User Management Menu as
  # the System Manager.
  # Needs:
  # Nurse Name, Nurse Initials, SSN, Sex, Access Code, Verify Code
  VistA.wait("Systems Manager Menu")
  VistA.write("User Management")
  VistA.wait('User Management')
  VistA.write('ADD')
  VistA.wait('name')
  VistA.write(name+'\rY')
  VistA.wait('INITIAL:')
  VistA.write(init)
  VistA.wait('SSN:')
  VistA.write(SSN)
  VistA.wait('SEX:')
  VistA.write(sex)
  VistA.wait('NPI')
  VistA.write('')
  VistA.wait('NAME COMPONENTS')
  # A ScreenMan form opens at this point, and the following information is set:
  # Primary Menu:   XUCORE
  # Secondary Menu: PSB GUI CONTEXT, GMPL MGT MENU, OR CPRS GUI CHART, GMV V/M GUI,
  # Access Code:    <passed as argument>
  # Verify Code:    <passed as argument>
  # No restriction on Patient Selection
  # Allowed multiple sign-ons
  # Nursing Service Provider as the Person Class
  # Core CPRS Tab access
  VistA.write('\r\r\r\r\r^PRIMARY MENU OPTION\rXUCOR\r^SECONDARY MENU OPTIONS\rPSB GUI CONTEXT\rY\r\r\r\rGMPL MGT MENU\rY\r\r\r\rOR CPRS GUI CHART\rY\r\r\r\rGMV V/M GUI\rY\r\r\r\r^Want to edit ACCESS CODE\rY\r'+AC+'\r'+AC+'\r^Want to edit VERIFY CODE\rY\r'+VC1+'\r'+VC1+'\rVISTA HEALTH CARE\rY\r\r\r\r\r^SERVICE/SECTION\rIRM\r^Language\r\r289\rY\rY\rT-1\r\r^RESTRICT PATIENT SELECTION\r0\r\rCOR\rY\rT-1\r\r^MULTIPLE SIGN-ON\r1\r1\r99\r^\rS\rE')
  # Exiting the ScreenMan form, Allocate Security Keys
  # PROVIDER,ORELSE
  VistA.wait('User Account Access Letter')
  VistA.write('NO')
  VistA.wait('wish to allocate security keys?')
  VistA.write('Y')
  VistA.wait('Allocate key')
  VistA.write('PSB MANAGER')
  VistA.wait('Another key')
  VistA.write('PROVIDER\r1')
  VistA.wait('Another key')
  VistA.write('ORELSE\r')
  VistA.wait('Another holder')
  VistA.write('')
  VistA.wait('Do you wish to proceed')
  VistA.write('Yes')
  VistA.wait('add this user to mail groups')
  VistA.write('NO')
  VistA.wait("User Management")
  VistA.write("")

def addClerk(VistA,name,init,SSN,sex,AC,VC1):
  # Adds a Clerk user into the system via the User Management Menu as
  # the System Manager.
  # Needs:
  # Clerk Name, Clerk Initials, SSN, Sex, Access Code, Verify Code
  VistA.wait("Systems Manager Menu")
  VistA.write("User Management")
  VistA.wait('User Management')
  VistA.write('ADD')
  VistA.wait('name')
  VistA.write(name+'\rY')
  VistA.wait('INITIAL:')
  VistA.write(init)
  VistA.wait('SSN:')
  VistA.write(SSN)
  VistA.wait('SEX:')
  VistA.write(sex)
  VistA.wait('NPI')
  VistA.write('')
  VistA.wait('NAME COMPONENTS')
  # A ScreenMan form opens at this point, and the following information is set:
  # Primary Menu:   XUCORE
  # Secondary Menu: GMPL DATA ENTRY
  # Access Code:    <passed as argument>
  # Verify Code:    <passed as argument>
  # No restriction on Patient Selection
  # Allowed multiple sign-ons
  # Core CPRS Tab access
  VistA.write('\r\r\r\r\r^PRIMARY MENU OPTION\rXUCOR\r^SECONDARY MENU OPTIONS\rGMPL DATA ENTRY\rY\r\r\r\rOR CPRS GUI CHART\rY\r\r\r\rGMV V/M GUI\rY\r\r\r\r^Want to edit ACCESS CODE\rY\r'+AC+'\r'+AC+'\r^Want to edit VERIFY CODE\rY\r'+VC1+'\r'+VC1+'\rVISTA HEALTH CARE\rY\r\r\r\r\r^SERVICE/SECTION\rIRM\r^RESTRICT PATIENT SELECTION\r0\r\rCOR\rY\rT-1\r\r^MULTIPLE SIGN-ON\r1\r1\r99\r^\rS\rE')
  # Exiting the ScreenMan form, Allocate Security Key
  # ORELSE
  VistA.wait('User Account Access Letter')
  VistA.write('NO')
  VistA.wait('wish to allocate security keys?')
  VistA.write('Y')
  VistA.wait('Allocate key')
  VistA.write('ORELSE')
  VistA.wait('Another key')
  VistA.write('')
  VistA.wait('Another holder')
  VistA.write('')
  VistA.wait('Do you wish to proceed')
  VistA.write('Yes')
  VistA.wait('add this user to mail groups')
  VistA.write('NO')
  VistA.wait("User Management")
  VistA.write("")

def createOrderMenu(VistA):
  # Create the Quick Order Menu to have the LRZ Strep Test as a selectable option while
  # not removing the old entries.
  VistA.wait('Systems Manager Menu')
  VistA.write('CPRS Configuration') # We can jump straight to the CPRS (Clin Coord) menu
  VistA.wait('CPRS Configuration')
  VistA.write('MM') # Order Menu Management
  VistA.wait('Order Menu Management')
  VistA.write('MN') # Enter/edit order menus
  VistA.wait('ORDER MENU:')
  VistA.write('ORZ GEN MED WRITE ORDERS LIST') # New menu name
  VistA.wait('Are you adding')
  VistA.write('Y')
  VistA.wait('Do you wish to copy an existing menu')
  VistA.write('N')
  VistA.wait('DISPLAY TEXT')
  VistA.write('') # Ignored by GUI
  VistA.wait('Edit') # DESCRIPTION field
  VistA.write('N')
  #VistA.write('General Medicine Write Orders list') # Menu description
  #VistA.wait('2')
  #VistA.write('') # End of DESCRIPTION
  #VistA.wait('EDIT') # Editor options
  #VistA.write('') # We are done with the DESCRIPTION
  VistA.wait('COLUMN WIDTH')
  VistA.write('80') # Default to 80 characters
  VistA.wait('MNEMONIC WIDTH')
  VistA.write('') # Ignored by GUI
  VistA.wait('PATH SWITCH')
  VistA.write('') # Ignored by GUI
  VistA.wait('ENTRY ACTION')
  VistA.write('') # Shown because we have programmer access - Ignore this field
  VistA.wait('EXIT ACTION')
  VistA.write('') # Shown because we have programmer access - Ignore this field
  # Begin ScreenMan form
  VistA.wait('Action')
  VistA.write('Add')
  VistA.wait('Add')
  VistA.write('Menu Items') # Add Menu Items to this Order Menu
  # Add items to menu - repeat for each menu item
  # Begin 'Add New Orders' menu
  VistA.wait('ITEM')
  VistA.write('OR ADD MENU CLINICIAN')
  VistA.wait('ROW')
  VistA.write('1')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Add New Orders'
  # Begin 'Allergies' package menu
  VistA.wait('ITEM')
  VistA.write('GMRAOR ALLERGY ENTER/EDIT')
  VistA.wait('ROW')
  VistA.write('2')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Allergies'
  # Begin 'Diet' package menu
  VistA.wait('ITEM')
  VistA.write('FHW1')
  VistA.wait('ROW')
  VistA.write('3')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Diet'
  # Begin 'Meds, Inpatient' package menu
  VistA.wait('ITEM')
  VistA.write('PSJ OR PAT OE')
  VistA.wait('ROW')
  VistA.write('4')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Meds, Inpatient'
  # Begin 'Meds, Non-VA' package menu
  VistA.wait('ITEM')
  VistA.write('PSH OERR')
  VistA.wait('ROW')
  VistA.write('5')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Meds, Non-VA'
  # Begin 'Meds, Outpatient' package menu
  VistA.wait('ITEM')
  VistA.write('PSO OERR')
  VistA.wait('ROW')
  VistA.write('6')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Meds, Outpatient'
  # Begin 'IV Fluids' package menu
  VistA.wait('ITEM')
  VistA.write('PSJI OR PAT FLUID OE')
  VistA.wait('ROW')
  VistA.write('7')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'IV Fluids'
  # Begin 'Lab Tests' package menu
  VistA.wait('ITEM')
  VistA.write('LR OTHER LAB TESTS')
  VistA.wait('ROW')
  VistA.write('8')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Lab Tests'
  # Begin 'Imaging' package menu
  VistA.wait('ITEM')
  VistA.write('RA OERR EXAM')
  VistA.wait('ROW')
  VistA.write('9')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Imaging'
  # Begin 'Consult' package menu
  VistA.wait('ITEM')
  VistA.write('GMRCOR CONSULT')
  VistA.wait('ROW')
  VistA.write('10')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Consult'
  # Begin 'Procedure' package menu
  VistA.wait('ITEM')
  VistA.write('GMRCOR REQUEST')
  VistA.wait('ROW')
  VistA.write('11')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Procedure'
  # Begin 'Vitals' package menu
  VistA.wait('ITEM')
  VistA.write('GMRVOR')
  VistA.wait('CHOOSE') # There is more than one GMRVOR* menu
  VistA.write('1') # GMRVOR is the entire menu name and is the first one
  VistA.wait('ROW')
  VistA.write('12')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Vitals'
  # Begin 'Text Only Order' package menu
  VistA.wait('ITEM')
  VistA.write('OR GXTEXT WORD PROCESSING ORDER')
  VistA.wait('ROW')
  VistA.write('13')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'Text Only Order'
  # Begin 'STREP TEST' quick order menu
  VistA.wait('ITEM')
  VistA.write('LRZ STREP TEST')
  VistA.wait('ROW')
  VistA.write('14')
  VistA.wait('COLUMN')
  VistA.write('1')
  VistA.wait('DISPLAY TEXT')
  VistA.write('')
  VistA.wait('MNEMONIC')
  VistA.write('')
  # End 'STREP TEST'
  VistA.wait('ITEM')
  VistA.write('') # Done adding menus
  VistA.wait('Action')
  VistA.write('Quit') # Done editing this menu
  VistA.wait('Order Menu Management') # Need to get to CPRS Manager Menu
  VistA.write('General Parameter Tools')
  VistA.wait('General Parameter Tools') # The System Manager has this as a secondary menu (can jump to it)
  VistA.write('EP') # Edit Parameter
  VistA.wait('PARAMETER DEFINITION NAME')
  VistA.write('ORWDX WRITE ORDERS LIST') # Parameter used to control Write Orders list
  VistA.wait('selection')
  VistA.write('8') # Set it for the entire System
  VistA.wait('Order Dialog')
  VistA.write('ORZ GEN MED WRITE ORDERS LIST') # Order menu we want to use
  VistA.write('\r\r\r\r') # we are done. Stay at the EVE menu

def addAllergiesPermission(VistA):
  # Add permissions for all users to mark an Allergy as "Entered in error"
  # in CPRS.  Done in the CPRS Configuration menu.
  # Start from the Systems Manager Menu
  # Exits to Systems Manager Menu
  VistA.wait('Systems Manager Menu')
  VistA.write('CPRS Configuration')
  VistA.wait('CPRS Configuration')
  VistA.write('GUI PARAMETERS')
  VistA.wait('GUI Parameters')
  VistA.write('GUI Mark Allergy Entered in Error')
  VistA.wait('Enter selection')
  VistA.write('4\rY\r\r')

def addTemplatePermission(VistA,init):
  # Add permission for the Nurse to create note templates  that can be
  # shared in the domain.
  VistA.wait('Systems Manager Menu')
  VistA.write('TIU Maintenance')
  VistA.wait('TIU Maintenance')
  VistA.write('User Class Management')
  VistA.wait('User Class Management')
  VistA.write('List Membership by User')
  VistA.wait('Select USER')
  VistA.write('MS\rAdd\rClinical Coordinator\rT-1\r\r\r')
  VistA.wait('Option')
  VistA.write('\r')

def setNonExpiringCodes(VistA, nameArray):
  startFileman(VistA)
  VistA.write('ENTER')
  VistA.wait('Input to what File')
  VistA.write('NEW PERSON')
  VistA.wait_re('EDIT WHICH FIELD')
  VistA.write('7.2')
  VistA.wait('THEN EDIT')
  VistA.write('')
  for name in nameArray:
    VistA.wait("NEW PERSON NAME")
    VistA.write(name)
    VistA.wait('VERIFY CODE never expires')
    VistA.write('Y')
  VistA.wait("NEW PERSON NAME")
  VistA.write('')
  VistA.wait_re('Select OPTION')
  VistA.write('')

def createClinic(VistA,name,abbrv,service):
  # Add clinic via the XUP menu to allow scheduling
  # Clinic Information:
  #   Clinic meets at the Facility:     Yes
  #   Non-Count clinic:                 No
  #   Stop Code:                        301 (General Internal Medicine)
  #   Allowable consecutive no-shows:   0
  #   Max # days for booking in future: 90
  #   Time for Clinic start:            80
  #   Max # days for Auto-rebook:       90
  #   Maximum Overbooks per day:        0
  #   Length of Appointment:            30
  #   Variable Length Appointments?:    Y
  #   Display increments per hour:      2
  VistA.wait(PROMPT)
  VistA.write('W $$NOSEND^VAFHUTL')
  VistA.wait('0')
  VistA.write('S DUZ=1 D ^XUP')
  VistA.wait('OPTION NAME:')
  VistA.write('SDBUILD')
  VistA.wait('CLINIC NAME:')
  VistA.write(name)
  VistA.wait('Are you adding')
  VistA.write('Y')
  VistA.wait('NAME')
  VistA.write('')
  VistA.wait('ABBREVIATION')
  VistA.write(abbrv)
  while True:
    index = VistA.multiwait(['SERVICE','CLINIC MEETS','PATIENT FRIENDLY NAME','ALLOW DIRECT PATIENT','DISPLAY CLIN APPT'])
    if index == 0:
      break;
    if index == 2:
      VistA.write('')
    else:
      VistA.write('Y')
  VistA.write(service)
  VistA.wait('NON-COUNT CLINIC')
  VistA.write('N')
  VistA.wait('STOP CODE NUMBER')
  VistA.write('301\r\r')
  VistA.wait('TELEPHONE')
  VistA.write('555-555-1414\r\r\r\r\r\r\r\r\r\r\r')
  index = VistA.multiwait(['ALLOWABLE CONSECUTIVE NO-SHOWS','WORKLOAD VALIDATION'])
  if index == 1:
    VistA.write('')
    VistA.wait('ALLOWABLE CONSECUTIVE NO-SHOWS')
  VistA.write('0')
  VistA.wait('FUTURE BOOKING')
  VistA.write('90')
  VistA.wait('HOUR CLINIC DISPLAY BEGINS')
  VistA.write('8\r')
  VistA.wait('AUTO-REBOOK')
  VistA.write('90\r\r\r\r\r')
  VistA.wait('MAXIMUM')
  VistA.write('0\r')
  VistA.wait('LENGTH OF APP')
  VistA.write('30')
  VistA.wait('VARIABLE')
  VistA.write('Yes')
  VistA.wait('DISPLAY INCREMENTS PER HOUR')
  VistA.write('2')
  # Sets availability for Clinic. Dates below are for a work week (Mon-Fri)
  # Sets 4 appointment slots from 8am to 3pm with a half hour lunch break of
  # no appointments.  This will be set for all week days in future.
  dates = ['JUL 2,2012','JUL 3,2012','JUL 4,2012','JUL 5,2012','JUL 6,2012']
  for date in dates:
    VistA.wait('AVAILABILITY DATE')
    VistA.write(date)
    VistA.wait('TIME')
    VistA.write('0800-1200\r4')
    VistA.wait('TIME')
    VistA.write('1230-1500\r4')
    VistA.wait('TIME')
    VistA.write('')
    VistA.wait('PATTERN OK')
    VistA.write('Yes')
  VistA.wait('AVAILABILITY DATE')
  VistA.write('')
  VistA.wait('CLINIC NAME:')
  VistA.write('')

def setupElectronicSignature(VistA,AC,VC1,VC2,sigcode):
  # Signs a created user into the ZU Menu system to add a signature code for
  # document signing.  It will force the user to change the verify code,
  VistA.wait(PROMPT,60)
  VistA.write('D ^ZU')
  VistA.wait('ACCESS CODE:')
  VistA.write(AC)
  VistA.wait('VERIFY CODE:')
  VistA.write(VC1)
  VistA.wait('verify code:')
  VistA.write(VC1)
  VistA.wait('VERIFY CODE:')
  VistA.write(VC2)
  VistA.wait('right:')
  VistA.write(VC2)
  VistA.wait('TYPE NAME')
  VistA.write('')
  # then will enter the User's Toolbox to change the signature information.
  VistA.wait('Core Applications')
  VistA.write('USER\'s TOOLBOX')
  VistA.wait('Toolbox')
  VistA.write('ELE')
  VistA.wait('INITIAL')
  VistA.write('')
  VistA.wait('SIGNATURE BLOCK PRINTED NAME')
  VistA.write('')
  VistA.wait('SIGNATURE BLOCK TITLE')
  VistA.write('\r\r\r')
  VistA.wait('SIGNATURE CODE')
  VistA.write(sigcode)
  VistA.wait('SIGNATURE CODE FOR VERIFICATION')
  VistA.write(sigcode)
  VistA.wait('Toolbox')
  VistA.write('\r\r\r')

  # Add patient through the
  # Function arguments:
  # VistA, Patient Name, Patient Sex,Patient DOB, Patient SSN, Patient Veteran?
def addPatient(VistA,pfile):
    '''Add ALL patients from specified CSV '''
    preader = TestHelper.CSVFileReader()
    prec = preader.getfiledata(pfile, 'key')
    for pitem in prec:
      VistA.write('S DUZ=1 D ^XUP')
      VistA.wait('Select OPTION NAME')
      VistA.write('Core Applications\r')
      VistA.wait("Select Core Applications")
      VistA.write("ADT Manager Menu")
      while True:
        index = VistA.multiwait(['to continue','Select ADT Manager Menu',"Select Registration Menu"])
        if index == 0:
          VistA.write('')
        elif index == 1:
          VistA.write("Registration Menu")
        elif index == 2:
          VistA.write('Register a Patient')
          break
      index = VistA.multiwait(['PATIENT NAME',"Select 1010 printer"])
      if index == 1:
        VistA.write("NULL")
        VistA.wait('PATIENT NAME')
      VistA.write(prec[pitem]['fullname'].rstrip().lstrip())
      index = VistA.multiwait(['ARE YOU ADDING','Enterprise Search'])
      VistA.write('Y')
      if index == 1:
        while True:
          index = VistA.multiwait(['FAMILY','GIVEN','MIDDLE NAME','PREFIX','SUFFIX',
          'DEGREE','SOCIAL SECURITY','DATE OF BIRTH','SEX','MAIDEN NAME','CITY','STATE',
          'MULTIPLE BIRTH','PHONE NUMBER','ARE YOU ADDING'])
          if index == 14:
            VistA.write('Y')
            break
          elif index == 6:
            VistA.write(pitem)
          elif index == 7:
            VistA.write(prec[pitem]['dob'].rstrip().lstrip())
          elif index == 8:
            VistA.write(prec[pitem]['sex'].rstrip().lstrip())
          else:
            VistA.write('')
        VistA.wait('to continue')
        VistA.write('')
        VistA.wait('MULTIPLE BIRTH INDICATOR')
        VistA.write('')
        VistA.wait('MAIDEN NAME:')
        VistA.write('')
      else:
        VistA.wait('SEX')
        VistA.write(prec[pitem]['sex'].rstrip().lstrip())
        VistA.wait('DATE OF BIRTH')
        VistA.write(prec[pitem]['dob'].rstrip().lstrip())
        VistA.wait('SOCIAL SECURITY NUMBER')
        VistA.write(pitem)
        VistA.wait('TYPE')
        VistA.write(prec[pitem]['type'].rstrip().lstrip())
        VistA.wait('PATIENT VETERAN')
        VistA.write(prec[pitem]['veteran'].rstrip().lstrip())
        VistA.wait('SERVICE CONNECTED')
        VistA.write(prec[pitem]['service'].rstrip().lstrip())
        VistA.wait('MULTIPLE BIRTH INDICATOR')
        VistA.write(prec[pitem]['twin'].rstrip().lstrip())
        index = VistA.multiwait(["Do you still",'FAMILY'])
        if index == 0:
          VistA.write('Y')
          VistA.wait("FAMILY")
        VistA.write('^\r')
        VistA.wait('MAIDEN NAME:')
        VistA.write('')
      VistA.wait('[CITY]')
      VistA.write(prec[pitem]['cityob'].rstrip().lstrip())
      VistA.wait('[STATE]')
      VistA.write(prec[pitem]['stateob'].rstrip().lstrip())
      VistA.wait('ALIAS')
      VistA.write('')
      searchArray = ['exit:', VistA.prompt]
      if VistA.type=='cache':
        searchArray.append(VistA.namespace)
      index = VistA.multiwait(searchArray)
      if index == 0:
        VistA.write('\r')
        VistA.wait('Patient Data')
        VistA.write('Y')
        VistA.wait('QUIT')
        VistA.write('4')
        VistA.wait('COUNTRY')
        VistA.write('')
        VistA.wait('STREET ADDRESS')
        VistA.write('834 Ocean Vista Avenue\r')
        VistA.wait('ZIP')
        VistA.write('90401')
        VistA.wait('CITY')
        VistA.write('1')
        VistA.wait('PHONE NUMBER')
        VistA.write('310-555-2233\r\r')
        VistA.wait('changes')
        VistA.write('Y\r')
        VistA.wait('QUIT')
        VistA.write('\r\r')
        VistA.wait('QUIT')
        VistA.write('1')
        VistA.wait('PRIMARY NOK')
        VistA.write('Carter,David J Sr')
        VistA.wait('RELATIONSHIP')
        VistA.write('FATHER')
        VistA.wait('ADDRESS')
        VistA.write('Y')
        VistA.wait('WORK PHONE')
        VistA.write('310-555-9876\r^')
        VistA.wait('condition')
        VistA.write('N')
        VistA.wait('today')
        VistA.write('Y')
        VistA.wait('Registration login')
        VistA.write('NOW')
        VistA.wait(PROMPT)
