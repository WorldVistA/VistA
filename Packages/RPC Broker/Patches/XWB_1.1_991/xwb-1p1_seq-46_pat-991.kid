KIDS Distribution saved on Sep 06, 2013@09:10:45
EMERGENCY Released XWB*1.1*991 SEQ #46 from OSEHRA
**KIDS**:XWB*1.1*991^

**INSTALL NAME**
XWB*1.1*991
"BLD",9049,0)
XWB*1.1*991^RPC BROKER^0^3130906^n
"BLD",9049,1,0)
^^207^207^3130906^
"BLD",9049,1,1,0)
$TXT Created by MARSHALL,RICK at KERNEL.MUMPS.ORG  (KIDS) on Tuesday, 08/16/2013 at 15:30
"BLD",9049,1,2,0)
=============================================================================
"BLD",9049,1,3,0)
Run Date: SEP 6, 2013                      Designation: XWB*1.1*991
"BLD",9049,1,4,0)
Package : XWB - RPC BROKER                    Priority: EMERGENCY
"BLD",9049,1,5,0)
Version : 1.1        SEQ #46                    Status: Released
"BLD",9049,1,6,0)
                  Compliance Date: SEP 30, 2013
"BLD",9049,1,7,0)
=============================================================================
"BLD",9049,1,8,0)
 
"BLD",9049,1,9,0)
Associated patches (must be installed BEFORE XWB*1.1*991):
"BLD",9049,1,10,0)
  (v)XWB*1.1*28 SEQ #25, M2M Broker, 17 OCT 2002
"BLD",9049,1,11,0)
  (v)XWB*1.1*41 SEQ #29, M2M Infinite Loop, 27 APR 2004
"BLD",9049,1,12,0)
  (v)XWB*1.1*34 SEQ #33, M2M Bug Fixes, 26 OCT 2005
"BLD",9049,1,13,0)
  (v)XWB*1.1*43 SEQ #36, New broker long timeout fix, 15 MAY 2006
"BLD",9049,1,14,0)
  (v)XWB*1.1*45 SEQ #38, Broker Security Enhancement, 18 SEP 2006
"BLD",9049,1,15,0)
  (v)XWB*1.1*49 SEQ #40, Improve Support for Linux, 31 MAR 2009
"BLD",9049,1,16,0)
  (v)XWB*1.1*53 SEQ #42, Broker Security Update, 28 APR 2010
"BLD",9049,1,17,0)
  (v)XWB*1.1*35 SEQ #44, MISSING LABEL 'RPUT', 5 NOV 2012
"BLD",9049,1,18,0)
 
"BLD",9049,1,19,0)
Subject: M2M Security Fixes Part 1
"BLD",9049,1,20,0)
 
"BLD",9049,1,21,0)
Category: 
"BLD",9049,1,22,0)
  - Routine
"BLD",9049,1,23,0)
  - Other
"BLD",9049,1,24,0)
 
"BLD",9049,1,25,0)
Source: OSEHRA (http://www.osehra.org)
"BLD",9049,1,26,0)
  
"BLD",9049,1,27,0)
  This is NOT a VA patch. It was developed by an OSEHRA working group,
"BLD",9049,1,28,0)
  the Special Software Enhancement Project. Check with your VISTA support
"BLD",9049,1,29,0)
  experts before installing this patch.
"BLD",9049,1,30,0)
 
"BLD",9049,1,31,0)
 
"BLD",9049,1,32,0)
Description:
"BLD",9049,1,33,0)
============
"BLD",9049,1,34,0)
 Recently, a software vulnerability was identified in VISTA. The
"BLD",9049,1,35,0)
 vulnerability would allow hackers to gain access to VISTA code and data
"BLD",9049,1,36,0)
 through Remote Procedure Calls (RPCs).
"BLD",9049,1,37,0)
 
"BLD",9049,1,38,0)
 Patch XWB*1.1*991 fixes the vulnerability. The patch makes five kinds of
"BLD",9049,1,39,0)
 changes to the broker:
"BLD",9049,1,40,0)
   1. Security improvements
"BLD",9049,1,41,0)
   2. New VISTA parameter: XWBM2M
"BLD",9049,1,42,0)
   3. M2M Broker now responds properly to VISTA parameter XWBDEBUG
"BLD",9049,1,43,0)
   4. Improved support for the broker on GT.M on Linux
"BLD",9049,1,44,0)
   5. General cleanup, annotation, and debugging
"BLD",9049,1,45,0)
             
"BLD",9049,1,46,0)
 To limit the ability of hackers to discover and exploit the
"BLD",9049,1,47,0)
 vulnerability, we are keeping its exact nature confidential until we are
"BLD",9049,1,48,0)
 sure that most sites are protected. More information about the
"BLD",9049,1,49,0)
 vulnerability, and what was done to patch it, will be released in a
"BLD",9049,1,50,0)
 future patch.
"BLD",9049,1,51,0)
 
"BLD",9049,1,52,0)
 The patch introduces a new parameter: XWBM2M. This parameter can be set
"BLD",9049,1,53,0)
 to "No, Disabled" ONLY at sites that are NOT using software that depends
"BLD",9049,1,54,0)
 on the M-to-M Broker (such as VISTA Imaging). If your site IS using
"BLD",9049,1,55,0)
 software that depends on the M-to-M Broker (such as VISTA Imaging), you
"BLD",9049,1,56,0)
 should leave this parameter set to the default of "Yes, Enabled."
"BLD",9049,1,57,0)
 
"BLD",9049,1,58,0)
 Package Elements Included:
"BLD",9049,1,59,0)
 ==========================
"BLD",9049,1,60,0)
 Routine XWBDLOG is used for Broker debug logging.
"BLD",9049,1,61,0)
 Routine XWBM2MC is the M-to-M Broker client routine.
"BLD",9049,1,62,0)
 Routine XWBP991 is the post-install for this patch.
"BLD",9049,1,63,0)
 Routine XWBRL is the M-to-M Broker socket manager (link methods).
"BLD",9049,1,64,0)
 Routine XWBRM is the M-to-M Broker request manager.
"BLD",9049,1,65,0)
 Routine XWBRMX is the M-to-M Broker XML message parser.
"BLD",9049,1,66,0)
 Routine XWBRPC is the M-to-M Broker parsed-message request handler.
"BLD",9049,1,67,0)
 Routine XWBTCPM is the RPC Broker main routine.
"BLD",9049,1,68,0)
 Routine XWBUTL is the M-to-M Broker utilities library.
"BLD",9049,1,69,0)
 Routine XWBVLL is the M-to-M Broker listener.
"BLD",9049,1,70,0)
 Parameter Definition XWBM2M is the M-to-M Broker Enabled? parameter.
"BLD",9049,1,71,0)
 
"BLD",9049,1,72,0)
 Documentation Changes:
"BLD",9049,1,73,0)
 ======================
"BLD",9049,1,74,0)
 The most up-to-date Remote Procedure Call (RPC) Broker end-user documentation
"BLD",9049,1,75,0)
 is available on the VHA Software Document Library (VDL) at the following
"BLD",9049,1,76,0)
 Internet Website: http://www.va.gov/vdl/application.asp?appid=23 
"BLD",9049,1,77,0)
 
"BLD",9049,1,78,0)
 NOTE: VISTA documentation is made available online in Microsoft Word format
"BLD",9049,1,79,0)
 (.DOC) and Adobe Acrobat Portable Document Format (.PDF).
"BLD",9049,1,80,0)
 
"BLD",9049,1,81,0)
 Although this patch introduces a new parameter and changes to several
"BLD",9049,1,82,0)
 routines, for security reasons the RPC Broker documentation will not be
"BLD",9049,1,83,0)
 updated until part two of this series of patches is released.
"BLD",9049,1,84,0)
  
"BLD",9049,1,85,0)
 Test Sites:
"BLD",9049,1,86,0)
 ==========
"BLD",9049,1,87,0)
 Oroville Hospital (Linux/GT.M)
"BLD",9049,1,88,0)
 
"BLD",9049,1,89,0)
 Remedy Tickets:
"BLD",9049,1,90,0)
 ==============
"BLD",9049,1,91,0)
 none
"BLD",9049,1,92,0)
 
"BLD",9049,1,93,0)
 Blood Bank Team Coordination: 
"BLD",9049,1,94,0)
 =============================
"BLD",9049,1,95,0)
 EFFECT ON BLOOD BANK FUNCTIONAL REQUIREMENTS: Patch XWB*1.1*991 contains
"BLD",9049,1,96,0)
 changes to a package referenced in VHA OI SEPG SOP 192-023 Review of VISTA
"BLD",9049,1,97,0)
 Patches for Effects on VISTA Blood Bank Software. This patch does not alter or
"BLD",9049,1,98,0)
 modify any VISTA Blood Bank software-design safeguards or safety-critical
"BLD",9049,1,99,0)
 elements or functions.
"BLD",9049,1,100,0)
 
"BLD",9049,1,101,0)
 RISK ANALYSIS: Changes made by patch XWB*1.1*991 have no effect on Blood Bank
"BLD",9049,1,102,0)
 software functionality, therefore RISK is none.
"BLD",9049,1,103,0)
 
"BLD",9049,1,104,0)
 Installation Instructions: 
"BLD",9049,1,105,0)
 ==========================
"BLD",9049,1,106,0)
 1. The patch should be installed when users are off the system and broker
"BLD",9049,1,107,0)
    services are disabled.
"BLD",9049,1,108,0)
 
"BLD",9049,1,109,0)
 2. You DO NOT need to stop Taskman or the background filers.
"BLD",9049,1,110,0)
 
"BLD",9049,1,111,0)
 3. On the KIDS menu, under the Installation menu, use the following options:
"BLD",9049,1,112,0)
 
"BLD",9049,1,113,0)
    Load a Distribution
"BLD",9049,1,114,0)
    Verify Checksums in Transport Global
"BLD",9049,1,115,0)
    Print Transport Global
"BLD",9049,1,116,0)
    Compare Transport Global to Current System
"BLD",9049,1,117,0)
    Backup a Transport Global
"BLD",9049,1,118,0)
 
"BLD",9049,1,119,0)
 4. On the KIDS menu, under the Installation menu, use the following option:
"BLD",9049,1,120,0)
 
"BLD",9049,1,121,0)
    Install Package(s)
"BLD",9049,1,122,0)
    Select INSTALL NAME: XWB*1.1*991
"BLD",9049,1,123,0)
 
"BLD",9049,1,124,0)
    Install Questions for XWB*1.1*991
"BLD",9049,1,125,0)
 
"BLD",9049,1,126,0)
    Want KIDS to INHIBIT LOGONs during the install? YES//
"BLD",9049,1,127,0)
    Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//
"BLD",9049,1,128,0)
 
"BLD",9049,1,129,0)
     Install Started for XWB*1.1*991 :
"BLD",9049,1,130,0)
                   Aug 20, 2013@13:12:51
"BLD",9049,1,131,0)
 
"BLD",9049,1,132,0)
    Build Distribution Date: Aug 19, 2013
"BLD",9049,1,133,0)
 
"BLD",9049,1,134,0)
     Installing Routines:
"BLD",9049,1,135,0)
                   Aug 20, 2013@13:12:51
"BLD",9049,1,136,0)
 
"BLD",9049,1,137,0)
     Installing PACKAGE COMPONENTS:
"BLD",9049,1,138,0)
 
"BLD",9049,1,139,0)
     Installing PARAMETER DEFINITION
"BLD",9049,1,140,0)
                   Aug 20, 2013@13:12:51
"BLD",9049,1,141,0)
 
"BLD",9049,1,142,0)
     Running Post-Install Routine: POST^XWBP991
"BLD",9049,1,143,0)
 
"BLD",9049,1,144,0)
       Parameter XWBM2M set to default of Yes, Enabled.
"BLD",9049,1,145,0)
 
"BLD",9049,1,146,0)
     Updating Routine file...
"BLD",9049,1,147,0)
 
"BLD",9049,1,148,0)
     Updating KIDS files...
"BLD",9049,1,149,0)
 
"BLD",9049,1,150,0)
     XWB*1.1*991 Installed.
"BLD",9049,1,151,0)
                   Aug 20, 2013@13:12:51
"BLD",9049,1,152,0)
 
"BLD",9049,1,153,0)
     NO Install Message sent 
"BLD",9049,1,154,0)
 
"BLD",9049,1,155,0)
 5. If your site is NOT running software that depends on the M-to-M Broker
"BLD",9049,1,156,0)
    (such as VISTA Imaging), set the XWBM2M parameter to 'No, Disabled' as
"BLD",9049,1,157,0)
    described in the Description section above.
"BLD",9049,1,158,0)
 
"BLD",9049,1,159,0)
 6. Let users back on the system and enable broker services.
"BLD",9049,1,160,0)
 
"BLD",9049,1,161,0)
 Install Completed
"BLD",9049,1,162,0)
 
"BLD",9049,1,163,0)
 
"BLD",9049,1,164,0)
Routine Information:
"BLD",9049,1,165,0)
====================
"BLD",9049,1,166,0)
The second line of each of these routines now looks like:
"BLD",9049,1,167,0)
 ;;1.1;RPC BROKER;**[Patch List]**;Mar 28, 1997;Build 3
"BLD",9049,1,168,0)
 
"BLD",9049,1,169,0)
The checksums below are new checksums, and
"BLD",9049,1,170,0)
 can be checked with CHECK1^XTSUMBLD.
"BLD",9049,1,171,0)
 
"BLD",9049,1,172,0)
Routine Name: XWBDLOG
"BLD",9049,1,173,0)
    Before:   B6484698   After:  B17906363  **35,991**
"BLD",9049,1,174,0)
Routine Name: XWBM2MC
"BLD",9049,1,175,0)
    Before:   B58578138   After:  B63427122  **28,34,991**
"BLD",9049,1,176,0)
Routine Name: XWBP991
"BLD",9049,1,177,0)
    Before:        n/a   After:  B1514642  **991**
"BLD",9049,1,178,0)
Routine Name: XWBRL
"BLD",9049,1,179,0)
    Before:  B13318398   After:  B24123947  **28,34,991**
"BLD",9049,1,180,0)
Routine Name: XWBRM
"BLD",9049,1,181,0)
    Before:  B13950171   After:  B10532495  **28,45,991**
"BLD",9049,1,182,0)
Routine Name: XWBRMX
"BLD",9049,1,183,0)
    Before:  B7578330   After:  B6795392  **28,991**
"BLD",9049,1,184,0)
Routine Name: XWBRPC
"BLD",9049,1,185,0)
    Before:  B59522634   After:  B180526853  **28,34,991**
"BLD",9049,1,186,0)
Routine Name: XWBTCPM
"BLD",9049,1,187,0)
    Before:  B56306340   After:  B84873953  **35,43,49,53,991**
"BLD",9049,1,188,0)
Routine Name: XWBUTL
"BLD",9049,1,189,0)
    Before:  B10435731   After:  B19872185  **28,34,991**
"BLD",9049,1,190,0)
Routine Name: XWBVLL
"BLD",9049,1,191,0)
    Before:  B15486790   After:  B24429511  **28,41,34,991**
"BLD",9049,1,192,0)
 
"BLD",9049,1,193,0)
Routine list of preceding patches: 28, 34, 35, 45, 53
"BLD",9049,1,194,0)
 
"BLD",9049,1,195,0)
 
"BLD",9049,1,196,0)
=============================================================================
"BLD",9049,1,197,0)
User Information:
"BLD",9049,1,198,0)
Entered By  : MARSHALL,RICK                 Date Entered  : AUG 16, 2013
"BLD",9049,1,199,0)
Completed By: IVEY,JOEL                     Date Completed: AUG 22, 2013
"BLD",9049,1,200,0)
Released By : EDWARDS,CHRISTOPHER           Date Released : SEP 6, 2013
"BLD",9049,1,201,0)
=============================================================================
"BLD",9049,1,202,0)
 
"BLD",9049,1,203,0)
 
"BLD",9049,1,204,0)
Packman Mail Message:
"BLD",9049,1,205,0)
=====================
"BLD",9049,1,206,0)
 
"BLD",9049,1,207,0)
$END TXT
"BLD",9049,4,0)
^9.64PA^^
"BLD",9049,6.3)
9
"BLD",9049,"INIT")
POST^XWBP991
"BLD",9049,"KRN",0)
^9.67PA^779.2^20
"BLD",9049,"KRN",.4,0)
.4
"BLD",9049,"KRN",.401,0)
.401
"BLD",9049,"KRN",.402,0)
.402
"BLD",9049,"KRN",.403,0)
.403
"BLD",9049,"KRN",.5,0)
.5
"BLD",9049,"KRN",.84,0)
.84
"BLD",9049,"KRN",3.6,0)
3.6
"BLD",9049,"KRN",3.8,0)
3.8
"BLD",9049,"KRN",9.2,0)
9.2
"BLD",9049,"KRN",9.8,0)
9.8
"BLD",9049,"KRN",9.8,"NM",0)
^9.68A^10^10
"BLD",9049,"KRN",9.8,"NM",1,0)
XWBP991^^0^B1514642
"BLD",9049,"KRN",9.8,"NM",2,0)
XWBDLOG^^0^B17906363^B6484698
"BLD",9049,"KRN",9.8,"NM",3,0)
XWBRM^^0^B10532495^B13950171
"BLD",9049,"KRN",9.8,"NM",4,0)
XWBRPC^^0^B180526853^B59522634
"BLD",9049,"KRN",9.8,"NM",5,0)
XWBTCPM^^0^B84873953^B56306340
"BLD",9049,"KRN",9.8,"NM",6,0)
XWBUTL^^0^B19872185^B10435731
"BLD",9049,"KRN",9.8,"NM",7,0)
XWBVLL^^0^B24429511^B15486790
"BLD",9049,"KRN",9.8,"NM",8,0)
XWBRL^^0^B24123947^B13318398
"BLD",9049,"KRN",9.8,"NM",9,0)
XWBRMX^^0^B6795392^B7578330
"BLD",9049,"KRN",9.8,"NM",10,0)
XWBM2MC^^0^B63427122^B58578138
"BLD",9049,"KRN",9.8,"NM","B","XWBDLOG",2)

"BLD",9049,"KRN",9.8,"NM","B","XWBM2MC",10)

"BLD",9049,"KRN",9.8,"NM","B","XWBP991",1)

"BLD",9049,"KRN",9.8,"NM","B","XWBRL",8)

"BLD",9049,"KRN",9.8,"NM","B","XWBRM",3)

"BLD",9049,"KRN",9.8,"NM","B","XWBRMX",9)

"BLD",9049,"KRN",9.8,"NM","B","XWBRPC",4)

"BLD",9049,"KRN",9.8,"NM","B","XWBTCPM",5)

"BLD",9049,"KRN",9.8,"NM","B","XWBUTL",6)

"BLD",9049,"KRN",9.8,"NM","B","XWBVLL",7)

"BLD",9049,"KRN",19,0)
19
"BLD",9049,"KRN",19.1,0)
19.1
"BLD",9049,"KRN",101,0)
101
"BLD",9049,"KRN",409.61,0)
409.61
"BLD",9049,"KRN",771,0)
771
"BLD",9049,"KRN",779.2,0)
779.2
"BLD",9049,"KRN",870,0)
870
"BLD",9049,"KRN",8989.51,0)
8989.51
"BLD",9049,"KRN",8989.51,"NM",0)
^9.68A^1^1
"BLD",9049,"KRN",8989.51,"NM",1,0)
XWBM2M^^0
"BLD",9049,"KRN",8989.51,"NM","B","XWBM2M",1)

"BLD",9049,"KRN",8989.52,0)
8989.52
"BLD",9049,"KRN",8994,0)
8994
"BLD",9049,"KRN","B",.4,.4)

"BLD",9049,"KRN","B",.401,.401)

"BLD",9049,"KRN","B",.402,.402)

"BLD",9049,"KRN","B",.403,.403)

"BLD",9049,"KRN","B",.5,.5)

"BLD",9049,"KRN","B",.84,.84)

"BLD",9049,"KRN","B",3.6,3.6)

"BLD",9049,"KRN","B",3.8,3.8)

"BLD",9049,"KRN","B",9.2,9.2)

"BLD",9049,"KRN","B",9.8,9.8)

"BLD",9049,"KRN","B",19,19)

"BLD",9049,"KRN","B",19.1,19.1)

"BLD",9049,"KRN","B",101,101)

"BLD",9049,"KRN","B",409.61,409.61)

"BLD",9049,"KRN","B",771,771)

"BLD",9049,"KRN","B",779.2,779.2)

"BLD",9049,"KRN","B",870,870)

"BLD",9049,"KRN","B",8989.51,8989.51)

"BLD",9049,"KRN","B",8989.52,8989.52)

"BLD",9049,"KRN","B",8994,8994)

"BLD",9049,"PRET")

"BLD",9049,"QDEF")
^^^^^^^^NO
"BLD",9049,"QUES",0)
^9.62^^
"BLD",9049,"REQB",0)
^9.611^8^8
"BLD",9049,"REQB",1,0)
XWB*1.1*28^2
"BLD",9049,"REQB",2,0)
XWB*1.1*34^2
"BLD",9049,"REQB",3,0)
XWB*1.1*41^2
"BLD",9049,"REQB",4,0)
XWB*1.1*35^2
"BLD",9049,"REQB",5,0)
XWB*1.1*43^2
"BLD",9049,"REQB",6,0)
XWB*1.1*49^2
"BLD",9049,"REQB",7,0)
XWB*1.1*53^2
"BLD",9049,"REQB",8,0)
XWB*1.1*45^2
"BLD",9049,"REQB","B","XWB*1.1*28",1)

"BLD",9049,"REQB","B","XWB*1.1*34",2)

"BLD",9049,"REQB","B","XWB*1.1*35",4)

"BLD",9049,"REQB","B","XWB*1.1*41",3)

"BLD",9049,"REQB","B","XWB*1.1*43",5)

"BLD",9049,"REQB","B","XWB*1.1*45",8)

"BLD",9049,"REQB","B","XWB*1.1*49",6)

"BLD",9049,"REQB","B","XWB*1.1*53",7)

"INIT")
POST^XWBP991
"KRN",8989.5,1870,0)
70;DIC(9.4,^XWBM2M^1
"KRN",8989.5,1870,1)
1
"KRN",8989.51,693,-1)
0^1
"KRN",8989.51,693,0)
XWBM2M^M-to-M Broker Enabled?^0^^Enable M-to-M Broker
"KRN",8989.51,693,1)
S^0:No, Disabled;1:Yes, Enabled^Enter NO if you want to disable the M-to-M Broker; defaults to Yes, Enabled.
"KRN",8989.51,693,4,0)
^8989.514^1^1
"KRN",8989.51,693,4,1,0)
M-TO-M BROKER
"KRN",8989.51,693,4,"B","M-TO-M BROKER",1)

"KRN",8989.51,693,20,0)
^^6^6^3130819^
"KRN",8989.51,693,20,1,0)
This parameter controls whether the M-to-M Broker is enabled or disabled 
"KRN",8989.51,693,20,2,0)
at this site. It includes both a package-level and a system-level 
"KRN",8989.51,693,20,3,0)
parameter. The package-level defaults to Yes, Enabled, but if the site
"KRN",8989.51,693,20,4,0)
does not actually use any external clients that require the M-to-M Broker,
"KRN",8989.51,693,20,5,0)
it can be disabled to increase system security, by setting the system-
"KRN",8989.51,693,20,6,0)
level parameter to No, Disabled.
"KRN",8989.51,693,30,0)
^8989.513I^2^2
"KRN",8989.51,693,30,1,0)
1^4.2
"KRN",8989.51,693,30,2,0)
2^9.4
"MBREQ")
0
"ORD",20,8989.51)
8989.51;20;;;PAR1E1^XPDTA2;PAR1F1^XPDIA3;PAR1E1^XPDIA3;PAR1F2^XPDIA3;;PAR1DEL^XPDIA3(%)
"ORD",20,8989.51,0)
PARAMETER DEFINITION
"PKG",70,-1)
1^1
"PKG",70,0)
RPC BROKER^XWB^Remote Procedure Call Broker
"PKG",70,20,0)
^9.402P^^
"PKG",70,22,0)
^9.49I^1^1
"PKG",70,22,1,0)
1.1^3051119^2971118^1
"PKG",70,22,1,"PAH",1,0)
991^3130906
"PKG",70,22,1,"PAH",1,1,0)
^^207^207^3130906
"PKG",70,22,1,"PAH",1,1,1,0)
$TXT Created by MARSHALL,RICK at KERNEL.MUMPS.ORG  (KIDS) on Tuesday, 08/16/2013 at 15:30
"PKG",70,22,1,"PAH",1,1,2,0)
=============================================================================
"PKG",70,22,1,"PAH",1,1,3,0)
Run Date: SEP 6, 2013                      Designation: XWB*1.1*991
"PKG",70,22,1,"PAH",1,1,4,0)
Package : XWB - RPC BROKER                    Priority: EMERGENCY
"PKG",70,22,1,"PAH",1,1,5,0)
Version : 1.1        SEQ #46                    Status: Released
"PKG",70,22,1,"PAH",1,1,6,0)
                  Compliance Date: SEP 30, 2013
"PKG",70,22,1,"PAH",1,1,7,0)
=============================================================================
"PKG",70,22,1,"PAH",1,1,8,0)
 
"PKG",70,22,1,"PAH",1,1,9,0)
Associated patches (must be installed BEFORE XWB*1.1*991):
"PKG",70,22,1,"PAH",1,1,10,0)
  (v)XWB*1.1*28 SEQ #25, M2M Broker, 17 OCT 2002
"PKG",70,22,1,"PAH",1,1,11,0)
  (v)XWB*1.1*41 SEQ #29, M2M Infinite Loop, 27 APR 2004
"PKG",70,22,1,"PAH",1,1,12,0)
  (v)XWB*1.1*34 SEQ #33, M2M Bug Fixes, 26 OCT 2005
"PKG",70,22,1,"PAH",1,1,13,0)
  (v)XWB*1.1*43 SEQ #36, New broker long timeout fix, 15 MAY 2006
"PKG",70,22,1,"PAH",1,1,14,0)
  (v)XWB*1.1*45 SEQ #38, Broker Security Enhancement, 18 SEP 2006
"PKG",70,22,1,"PAH",1,1,15,0)
  (v)XWB*1.1*49 SEQ #40, Improve Support for Linux, 31 MAR 2009
"PKG",70,22,1,"PAH",1,1,16,0)
  (v)XWB*1.1*53 SEQ #42, Broker Security Update, 28 APR 2010
"PKG",70,22,1,"PAH",1,1,17,0)
  (v)XWB*1.1*35 SEQ #44, MISSING LABEL 'RPUT', 5 NOV 2012
"PKG",70,22,1,"PAH",1,1,18,0)
 
"PKG",70,22,1,"PAH",1,1,19,0)
Subject: M2M Security Fixes Part 1
"PKG",70,22,1,"PAH",1,1,20,0)
 
"PKG",70,22,1,"PAH",1,1,21,0)
Category: 
"PKG",70,22,1,"PAH",1,1,22,0)
  - Routine
"PKG",70,22,1,"PAH",1,1,23,0)
  - Other
"PKG",70,22,1,"PAH",1,1,24,0)
 
"PKG",70,22,1,"PAH",1,1,25,0)
Source: OSEHRA (http://www.osehra.org)
"PKG",70,22,1,"PAH",1,1,26,0)
  
"PKG",70,22,1,"PAH",1,1,27,0)
  This is NOT a VA patch. It was developed by an OSEHRA working group,
"PKG",70,22,1,"PAH",1,1,28,0)
  the Special Software Enhancement Project. Check with your VISTA support
"PKG",70,22,1,"PAH",1,1,29,0)
  experts before installing this patch.
"PKG",70,22,1,"PAH",1,1,30,0)
 
"PKG",70,22,1,"PAH",1,1,31,0)
 
"PKG",70,22,1,"PAH",1,1,32,0)
Description:
"PKG",70,22,1,"PAH",1,1,33,0)
============
"PKG",70,22,1,"PAH",1,1,34,0)
 Recently, a software vulnerability was identified in VISTA. The
"PKG",70,22,1,"PAH",1,1,35,0)
 vulnerability would allow hackers to gain access to VISTA code and data
"PKG",70,22,1,"PAH",1,1,36,0)
 through Remote Procedure Calls (RPCs).
"PKG",70,22,1,"PAH",1,1,37,0)
 
"PKG",70,22,1,"PAH",1,1,38,0)
 Patch XWB*1.1*991 fixes the vulnerability. The patch makes five kinds of
"PKG",70,22,1,"PAH",1,1,39,0)
 changes to the broker:
"PKG",70,22,1,"PAH",1,1,40,0)
   1. Security improvements
"PKG",70,22,1,"PAH",1,1,41,0)
   2. New VISTA parameter: XWBM2M
"PKG",70,22,1,"PAH",1,1,42,0)
   3. M2M Broker now responds properly to VISTA parameter XWBDEBUG
"PKG",70,22,1,"PAH",1,1,43,0)
   4. Improved support for the broker on GT.M on Linux
"PKG",70,22,1,"PAH",1,1,44,0)
   5. General cleanup, annotation, and debugging
"PKG",70,22,1,"PAH",1,1,45,0)
             
"PKG",70,22,1,"PAH",1,1,46,0)
 To limit the ability of hackers to discover and exploit the
"PKG",70,22,1,"PAH",1,1,47,0)
 vulnerability, we are keeping its exact nature confidential until we are
"PKG",70,22,1,"PAH",1,1,48,0)
 sure that most sites are protected. More information about the
"PKG",70,22,1,"PAH",1,1,49,0)
 vulnerability, and what was done to patch it, will be released in a
"PKG",70,22,1,"PAH",1,1,50,0)
 future patch.
"PKG",70,22,1,"PAH",1,1,51,0)
 
"PKG",70,22,1,"PAH",1,1,52,0)
 The patch introduces a new parameter: XWBM2M. This parameter can be set
"PKG",70,22,1,"PAH",1,1,53,0)
 to "No, Disabled" ONLY at sites that are NOT using software that depends
"PKG",70,22,1,"PAH",1,1,54,0)
 on the M-to-M Broker (such as VISTA Imaging). If your site IS using
"PKG",70,22,1,"PAH",1,1,55,0)
 software that depends on the M-to-M Broker (such as VISTA Imaging), you
"PKG",70,22,1,"PAH",1,1,56,0)
 should leave this parameter set to the default of "Yes, Enabled."
"PKG",70,22,1,"PAH",1,1,57,0)
 
"PKG",70,22,1,"PAH",1,1,58,0)
 Package Elements Included:
"PKG",70,22,1,"PAH",1,1,59,0)
 ==========================
"PKG",70,22,1,"PAH",1,1,60,0)
 Routine XWBDLOG is used for Broker debug logging.
"PKG",70,22,1,"PAH",1,1,61,0)
 Routine XWBM2MC is the M-to-M Broker client routine.
"PKG",70,22,1,"PAH",1,1,62,0)
 Routine XWBP991 is the post-install for this patch.
"PKG",70,22,1,"PAH",1,1,63,0)
 Routine XWBRL is the M-to-M Broker socket manager (link methods).
"PKG",70,22,1,"PAH",1,1,64,0)
 Routine XWBRM is the M-to-M Broker request manager.
"PKG",70,22,1,"PAH",1,1,65,0)
 Routine XWBRMX is the M-to-M Broker XML message parser.
"PKG",70,22,1,"PAH",1,1,66,0)
 Routine XWBRPC is the M-to-M Broker parsed-message request handler.
"PKG",70,22,1,"PAH",1,1,67,0)
 Routine XWBTCPM is the RPC Broker main routine.
"PKG",70,22,1,"PAH",1,1,68,0)
 Routine XWBUTL is the M-to-M Broker utilities library.
"PKG",70,22,1,"PAH",1,1,69,0)
 Routine XWBVLL is the M-to-M Broker listener.
"PKG",70,22,1,"PAH",1,1,70,0)
 Parameter Definition XWBM2M is the M-to-M Broker Enabled? parameter.
"PKG",70,22,1,"PAH",1,1,71,0)
 
"PKG",70,22,1,"PAH",1,1,72,0)
 Documentation Changes:
"PKG",70,22,1,"PAH",1,1,73,0)
 ======================
"PKG",70,22,1,"PAH",1,1,74,0)
 The most up-to-date Remote Procedure Call (RPC) Broker end-user documentation
"PKG",70,22,1,"PAH",1,1,75,0)
 is available on the VHA Software Document Library (VDL) at the following
"PKG",70,22,1,"PAH",1,1,76,0)
 Internet Website: http://www.va.gov/vdl/application.asp?appid=23 
"PKG",70,22,1,"PAH",1,1,77,0)
 
"PKG",70,22,1,"PAH",1,1,78,0)
 NOTE: VISTA documentation is made available online in Microsoft Word format
"PKG",70,22,1,"PAH",1,1,79,0)
 (.DOC) and Adobe Acrobat Portable Document Format (.PDF).
"PKG",70,22,1,"PAH",1,1,80,0)
 
"PKG",70,22,1,"PAH",1,1,81,0)
 Although this patch introduces a new parameter and changes to several
"PKG",70,22,1,"PAH",1,1,82,0)
 routines, for security reasons the RPC Broker documentation will not be
"PKG",70,22,1,"PAH",1,1,83,0)
 updated until part two of this series of patches is released.
"PKG",70,22,1,"PAH",1,1,84,0)
  
"PKG",70,22,1,"PAH",1,1,85,0)
 Test Sites:
"PKG",70,22,1,"PAH",1,1,86,0)
 ==========
"PKG",70,22,1,"PAH",1,1,87,0)
 Oroville Hospital (Linux/GT.M)
"PKG",70,22,1,"PAH",1,1,88,0)
 
"PKG",70,22,1,"PAH",1,1,89,0)
 Remedy Tickets:
"PKG",70,22,1,"PAH",1,1,90,0)
 ==============
"PKG",70,22,1,"PAH",1,1,91,0)
 none
"PKG",70,22,1,"PAH",1,1,92,0)
 
"PKG",70,22,1,"PAH",1,1,93,0)
 Blood Bank Team Coordination: 
"PKG",70,22,1,"PAH",1,1,94,0)
 =============================
"PKG",70,22,1,"PAH",1,1,95,0)
 EFFECT ON BLOOD BANK FUNCTIONAL REQUIREMENTS: Patch XWB*1.1*991 contains
"PKG",70,22,1,"PAH",1,1,96,0)
 changes to a package referenced in VHA OI SEPG SOP 192-023 Review of VISTA
"PKG",70,22,1,"PAH",1,1,97,0)
 Patches for Effects on VISTA Blood Bank Software. This patch does not alter or
"PKG",70,22,1,"PAH",1,1,98,0)
 modify any VISTA Blood Bank software-design safeguards or safety-critical
"PKG",70,22,1,"PAH",1,1,99,0)
 elements or functions.
"PKG",70,22,1,"PAH",1,1,100,0)
 
"PKG",70,22,1,"PAH",1,1,101,0)
 RISK ANALYSIS: Changes made by patch XWB*1.1*991 have no effect on Blood Bank
"PKG",70,22,1,"PAH",1,1,102,0)
 software functionality, therefore RISK is none.
"PKG",70,22,1,"PAH",1,1,103,0)
 
"PKG",70,22,1,"PAH",1,1,104,0)
 Installation Instructions: 
"PKG",70,22,1,"PAH",1,1,105,0)
 ==========================
"PKG",70,22,1,"PAH",1,1,106,0)
 1. The patch should be installed when users are off the system and broker
"PKG",70,22,1,"PAH",1,1,107,0)
    services are disabled.
"PKG",70,22,1,"PAH",1,1,108,0)
 
"PKG",70,22,1,"PAH",1,1,109,0)
 2. You DO NOT need to stop Taskman or the background filers.
"PKG",70,22,1,"PAH",1,1,110,0)
 
"PKG",70,22,1,"PAH",1,1,111,0)
 3. On the KIDS menu, under the Installation menu, use the following options:
"PKG",70,22,1,"PAH",1,1,112,0)
 
"PKG",70,22,1,"PAH",1,1,113,0)
    Load a Distribution
"PKG",70,22,1,"PAH",1,1,114,0)
    Verify Checksums in Transport Global
"PKG",70,22,1,"PAH",1,1,115,0)
    Print Transport Global
"PKG",70,22,1,"PAH",1,1,116,0)
    Compare Transport Global to Current System
"PKG",70,22,1,"PAH",1,1,117,0)
    Backup a Transport Global
"PKG",70,22,1,"PAH",1,1,118,0)
 
"PKG",70,22,1,"PAH",1,1,119,0)
 4. On the KIDS menu, under the Installation menu, use the following option:
"PKG",70,22,1,"PAH",1,1,120,0)
 
"PKG",70,22,1,"PAH",1,1,121,0)
    Install Package(s)
"PKG",70,22,1,"PAH",1,1,122,0)
    Select INSTALL NAME: XWB*1.1*991
"PKG",70,22,1,"PAH",1,1,123,0)
 
"PKG",70,22,1,"PAH",1,1,124,0)
    Install Questions for XWB*1.1*991
"PKG",70,22,1,"PAH",1,1,125,0)
 
"PKG",70,22,1,"PAH",1,1,126,0)
    Want KIDS to INHIBIT LOGONs during the install? YES//
"PKG",70,22,1,"PAH",1,1,127,0)
    Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO//
"PKG",70,22,1,"PAH",1,1,128,0)
 
"PKG",70,22,1,"PAH",1,1,129,0)
     Install Started for XWB*1.1*991 :
"PKG",70,22,1,"PAH",1,1,130,0)
                   Aug 20, 2013@13:12:51
"PKG",70,22,1,"PAH",1,1,131,0)
 
"PKG",70,22,1,"PAH",1,1,132,0)
    Build Distribution Date: Aug 19, 2013
"PKG",70,22,1,"PAH",1,1,133,0)
 
"PKG",70,22,1,"PAH",1,1,134,0)
     Installing Routines:
"PKG",70,22,1,"PAH",1,1,135,0)
                   Aug 20, 2013@13:12:51
"PKG",70,22,1,"PAH",1,1,136,0)
 
"PKG",70,22,1,"PAH",1,1,137,0)
     Installing PACKAGE COMPONENTS:
"PKG",70,22,1,"PAH",1,1,138,0)
 
"PKG",70,22,1,"PAH",1,1,139,0)
     Installing PARAMETER DEFINITION
"PKG",70,22,1,"PAH",1,1,140,0)
                   Aug 20, 2013@13:12:51
"PKG",70,22,1,"PAH",1,1,141,0)
 
"PKG",70,22,1,"PAH",1,1,142,0)
     Running Post-Install Routine: POST^XWBP991
"PKG",70,22,1,"PAH",1,1,143,0)
 
"PKG",70,22,1,"PAH",1,1,144,0)
       Parameter XWBM2M set to default of Yes, Enabled.
"PKG",70,22,1,"PAH",1,1,145,0)
 
"PKG",70,22,1,"PAH",1,1,146,0)
     Updating Routine file...
"PKG",70,22,1,"PAH",1,1,147,0)
 
"PKG",70,22,1,"PAH",1,1,148,0)
     Updating KIDS files...
"PKG",70,22,1,"PAH",1,1,149,0)
 
"PKG",70,22,1,"PAH",1,1,150,0)
     XWB*1.1*991 Installed.
"PKG",70,22,1,"PAH",1,1,151,0)
                   Aug 20, 2013@13:12:51
"PKG",70,22,1,"PAH",1,1,152,0)
 
"PKG",70,22,1,"PAH",1,1,153,0)
     NO Install Message sent 
"PKG",70,22,1,"PAH",1,1,154,0)
 
"PKG",70,22,1,"PAH",1,1,155,0)
 5. If your site is NOT running software that depends on the M-to-M Broker
"PKG",70,22,1,"PAH",1,1,156,0)
    (such as VISTA Imaging), set the XWBM2M parameter to 'No, Disabled' as
"PKG",70,22,1,"PAH",1,1,157,0)
    described in the Description section above.
"PKG",70,22,1,"PAH",1,1,158,0)
 
"PKG",70,22,1,"PAH",1,1,159,0)
 6. Let users back on the system and enable broker services.
"PKG",70,22,1,"PAH",1,1,160,0)
 
"PKG",70,22,1,"PAH",1,1,161,0)
 Install Completed
"PKG",70,22,1,"PAH",1,1,162,0)
 
"PKG",70,22,1,"PAH",1,1,163,0)
 
"PKG",70,22,1,"PAH",1,1,164,0)
Routine Information:
"PKG",70,22,1,"PAH",1,1,165,0)
====================
"PKG",70,22,1,"PAH",1,1,166,0)
The second line of each of these routines now looks like:
"PKG",70,22,1,"PAH",1,1,167,0)
 ;;1.1;RPC BROKER;**[Patch List]**;Mar 28, 1997;Build 3
"PKG",70,22,1,"PAH",1,1,168,0)
 
"PKG",70,22,1,"PAH",1,1,169,0)
The checksums below are new checksums, and
"PKG",70,22,1,"PAH",1,1,170,0)
 can be checked with CHECK1^XTSUMBLD.
"PKG",70,22,1,"PAH",1,1,171,0)
 
"PKG",70,22,1,"PAH",1,1,172,0)
Routine Name: XWBDLOG
"PKG",70,22,1,"PAH",1,1,173,0)
    Before:   B6484698   After:  B17906363  **35,991**
"PKG",70,22,1,"PAH",1,1,174,0)
Routine Name: XWBM2MC
"PKG",70,22,1,"PAH",1,1,175,0)
    Before:   B58578138   After:  B63427122  **28,34,991**
"PKG",70,22,1,"PAH",1,1,176,0)
Routine Name: XWBP991
"PKG",70,22,1,"PAH",1,1,177,0)
    Before:        n/a   After:  B1514642  **991**
"PKG",70,22,1,"PAH",1,1,178,0)
Routine Name: XWBRL
"PKG",70,22,1,"PAH",1,1,179,0)
    Before:  B13318398   After:  B24123947  **28,34,991**
"PKG",70,22,1,"PAH",1,1,180,0)
Routine Name: XWBRM
"PKG",70,22,1,"PAH",1,1,181,0)
    Before:  B13950171   After:  B10532495  **28,45,991**
"PKG",70,22,1,"PAH",1,1,182,0)
Routine Name: XWBRMX
"PKG",70,22,1,"PAH",1,1,183,0)
    Before:  B7578330   After:  B6795392  **28,991**
"PKG",70,22,1,"PAH",1,1,184,0)
Routine Name: XWBRPC
"PKG",70,22,1,"PAH",1,1,185,0)
    Before:  B59522634   After:  B180526853  **28,34,991**
"PKG",70,22,1,"PAH",1,1,186,0)
Routine Name: XWBTCPM
"PKG",70,22,1,"PAH",1,1,187,0)
    Before:  B56306340   After:  B84873953  **35,43,49,53,991**
"PKG",70,22,1,"PAH",1,1,188,0)
Routine Name: XWBUTL
"PKG",70,22,1,"PAH",1,1,189,0)
    Before:  B10435731   After:  B19872185  **28,34,991**
"PKG",70,22,1,"PAH",1,1,190,0)
Routine Name: XWBVLL
"PKG",70,22,1,"PAH",1,1,191,0)
    Before:  B15486790   After:  B24429511  **28,41,34,991**
"PKG",70,22,1,"PAH",1,1,192,0)
 
"PKG",70,22,1,"PAH",1,1,193,0)
Routine list of preceding patches: 28, 34, 35, 45, 53
"PKG",70,22,1,"PAH",1,1,194,0)
 
"PKG",70,22,1,"PAH",1,1,195,0)
 
"PKG",70,22,1,"PAH",1,1,196,0)
=============================================================================
"PKG",70,22,1,"PAH",1,1,197,0)
User Information:
"PKG",70,22,1,"PAH",1,1,198,0)
Entered By  : MARSHALL,RICK                 Date Entered  : AUG 16, 2013
"PKG",70,22,1,"PAH",1,1,199,0)
Completed By: IVEY,JOEL                     Date Completed: AUG 22, 2013
"PKG",70,22,1,"PAH",1,1,200,0)
Released By : EDWARDS,CHRISTOPHER           Date Released : SEP 6, 2013
"PKG",70,22,1,"PAH",1,1,201,0)
=============================================================================
"PKG",70,22,1,"PAH",1,1,202,0)
 
"PKG",70,22,1,"PAH",1,1,203,0)
 
"PKG",70,22,1,"PAH",1,1,204,0)
Packman Mail Message:
"PKG",70,22,1,"PAH",1,1,205,0)
=====================
"PKG",70,22,1,"PAH",1,1,206,0)
 
"PKG",70,22,1,"PAH",1,1,207,0)
$END TXT
"QUES","XPF1",0)
Y
"QUES","XPF1","??")
^D REP^XPDH
"QUES","XPF1","A")
Shall I write over your |FLAG| File
"QUES","XPF1","B")
YES
"QUES","XPF1","M")
D XPF1^XPDIQ
"QUES","XPF2",0)
Y
"QUES","XPF2","??")
^D DTA^XPDH
"QUES","XPF2","A")
Want my data |FLAG| yours
"QUES","XPF2","B")
YES
"QUES","XPF2","M")
D XPF2^XPDIQ
"QUES","XPI1",0)
YO
"QUES","XPI1","??")
^D INHIBIT^XPDH
"QUES","XPI1","A")
Want KIDS to INHIBIT LOGONs during the install
"QUES","XPI1","B")
NO
"QUES","XPI1","M")
D XPI1^XPDIQ
"QUES","XPM1",0)
PO^VA(200,:EM
"QUES","XPM1","??")
^D MG^XPDH
"QUES","XPM1","A")
Enter the Coordinator for Mail Group '|FLAG|'
"QUES","XPM1","B")

"QUES","XPM1","M")
D XPM1^XPDIQ
"QUES","XPO1",0)
Y
"QUES","XPO1","??")
^D MENU^XPDH
"QUES","XPO1","A")
Want KIDS to Rebuild Menu Trees Upon Completion of Install
"QUES","XPO1","B")
NO
"QUES","XPO1","M")
D XPO1^XPDIQ
"QUES","XPZ1",0)
Y
"QUES","XPZ1","??")
^D OPT^XPDH
"QUES","XPZ1","A")
Want to DISABLE Scheduled Options, Menu Options, and Protocols
"QUES","XPZ1","B")
NO
"QUES","XPZ1","M")
D XPZ1^XPDIQ
"QUES","XPZ2",0)
Y
"QUES","XPZ2","??")
^D RTN^XPDH
"QUES","XPZ2","A")
Want to MOVE routines to other CPUs
"QUES","XPZ2","B")
NO
"QUES","XPZ2","M")
D XPZ2^XPDIQ
"RTN")
10
"RTN","XWBDLOG")
0^2^B17906363
"RTN","XWBDLOG",1,0)
XWBDLOG ;ISF/RWF - Debug Logging for Broker ; 8/28/2013 10:38am
"RTN","XWBDLOG",2,0)
 ;;1.1;RPC BROKER;**35,991**;Mar 28, 1997;Build 9
"RTN","XWBDLOG",3,0)
 ;
"RTN","XWBDLOG",4,0)
 QUIT  ; routine XWBDLOG is not callable at the top
"RTN","XWBDLOG",5,0)
 ;
"RTN","XWBDLOG",6,0)
 ; Change History:
"RTN","XWBDLOG",7,0)
 ;
"RTN","XWBDLOG",8,0)
 ; 2004 12 08 ISF/RWF: XWB*1.1*35 SEQ #30, NON-callback server. Original
"RTN","XWBDLOG",9,0)
 ; routine created.
"RTN","XWBDLOG",10,0)
 ;
"RTN","XWBDLOG",11,0)
 ; 2013 08 16-28 VEN/JLI&TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBDLOG",12,0)
 ; LOG extended to save arrays. LOGSTART changed to echo style. Updated
"RTN","XWBDLOG",13,0)
 ; VIEW subroutines to show debugging arrays. Annotated. Change History
"RTN","XWBDLOG",14,0)
 ; added. in XWBDLOG, LOGSTART, LOG, VIEW, V1, V2, VL1, VL2, EOR.
"RTN","XWBDLOG",15,0)
 ;
"RTN","XWBDLOG",16,0)
 ;
"RTN","XWBDLOG",17,0)
LOGSTART(RTN) ;Setup the log, Clear the log location
"RTN","XWBDLOG",18,0)
 ; input:
"RTN","XWBDLOG",19,0)
 ;   RTN = name of initial logging routine
"RTN","XWBDLOG",20,0)
 ; output: new log started in ^XTMP("XWBLOG"_$J)
"RTN","XWBDLOG",21,0)
 ;
"RTN","XWBDLOG",22,0)
 Q:'$G(XWBDEBUG)  ; don't log unless XWBDEBUG parameter is set
"RTN","XWBDLOG",23,0)
 ;
"RTN","XWBDLOG",24,0)
 N LOG S LOG="XWBLOG"_$J ; this job's log subscript
"RTN","XWBDLOG",25,0)
 K ^XTMP(LOG) ; clear our log
"RTN","XWBDLOG",26,0)
 S ^XTMP(LOG,0)=$$HTFM^XLFDT($$HADD^XLFDT($H,7))_"^"_$$DT^XLFDT ; started
"RTN","XWBDLOG",27,0)
 S ^XTMP(LOG,.1)=0 ; initialize log-entry counter
"RTN","XWBDLOG",28,0)
 D LOG("Log start: "_$$HTE^XLFDT($H)) ; record start of log
"RTN","XWBDLOG",29,0)
 D LOG(RTN) ; record initial logging routine
"RTN","XWBDLOG",30,0)
 ;
"RTN","XWBDLOG",31,0)
 QUIT  ; end of LOGSTART
"RTN","XWBDLOG",32,0)
 ;
"RTN","XWBDLOG",33,0)
 ;
"RTN","XWBDLOG",34,0)
LOG(MSG,ROOT) ;Record Debug Info
"RTN","XWBDLOG",35,0)
 ; input:
"RTN","XWBDLOG",36,0)
 ;   MSG = text to record, up to 243 characters
"RTN","XWBDLOG",37,0)
 ;   ROOT = [optional] name of array to record
"RTN","XWBDLOG",38,0)
 ; output: new entry in ^XTMP("XWBLOG"_$J)
"RTN","XWBDLOG",39,0)
 ;
"RTN","XWBDLOG",40,0)
 Q:'$G(XWBDEBUG)  ; don't log unless XWBDEBUG parameter is set
"RTN","XWBDLOG",41,0)
 ;
"RTN","XWBDLOG",42,0)
 N LOG S LOG="XWBLOG"_$J ; this job's log subscript
"RTN","XWBDLOG",43,0)
 N CNT S CNT=1+$G(^XTMP(LOG,.1)) ; get next log #
"RTN","XWBDLOG",44,0)
 S ^XTMP(LOG,.1)=CNT ; update next log #
"RTN","XWBDLOG",45,0)
 S ^XTMP(LOG,CNT)=$E($H_"^"_MSG,1,255) ; record log message
"RTN","XWBDLOG",46,0)
 I $G(ROOT)'="" D  ; if there's an array to record
"RTN","XWBDLOG",47,0)
 . M ^XTMP(LOG,CNT)=@ROOT ; record it
"RTN","XWBDLOG",48,0)
 ;
"RTN","XWBDLOG",49,0)
 QUIT  ; end of LOG
"RTN","XWBDLOG",50,0)
 ;
"RTN","XWBDLOG",51,0)
 ;
"RTN","XWBDLOG",52,0)
VIEW ;View log files
"RTN","XWBDLOG",53,0)
 N DIRUT,XWB,DIR,IX,X,CON,IXNEXT
"RTN","XWBDLOG",54,0)
 D HOME^%ZIS
"RTN","XWBDLOG",55,0)
 W !,"Log Files"
"RTN","XWBDLOG",56,0)
 S XWB="XWBLOG",CON=""
"RTN","XWBDLOG",57,0)
 F  S XWB=$O(^XTMP(XWB)) Q:XWB'["XWBLOG"  D
"RTN","XWBDLOG",58,0)
 . D V1(.XWB)
"RTN","XWBDLOG",59,0)
 . I 'IXNEXT I $$WAIT(.CON) S:CON=3 XWB="XWC"
"RTN","XWBDLOG",60,0)
 . Q
"RTN","XWBDLOG",61,0)
 Q
"RTN","XWBDLOG",62,0)
 ;
"RTN","XWBDLOG",63,0)
V1(XWB) ;View one log
"RTN","XWBDLOG",64,0)
 N IX,X,CNT,V2LEN
"RTN","XWBDLOG",65,0)
 S IX=.9,X=$G(^XTMP(XWB,IX)),CON=0,CNT=+$G(^XTMP(XWB,.1))
"RTN","XWBDLOG",66,0)
 S IXNEXT=0
"RTN","XWBDLOG",67,0)
 Q:CNT<1
"RTN","XWBDLOG",68,0)
 W !!,"Log from Job ",$E(XWB,7,99)," ",CNT," Lines"
"RTN","XWBDLOG",69,0)
 F  S IX=$O(^XTMP(XWB,IX)) Q:'$L(IX)  S X=^XTMP(XWB,IX) D VL1(IX,X) Q:IXNEXT  I $D(^XTMP(XWB,IX))>1 S V2LEN=$L("^XTMP("""_XWB_""","_IX) D V2("^XTMP("""_XWB_""","_IX) ; JLI 130819
"RTN","XWBDLOG",70,0)
 Q
"RTN","XWBDLOG",71,0)
 ;
"RTN","XWBDLOG",72,0)
V2(GLOB) ; handle arrays under the top level
"RTN","XWBDLOG",73,0)
 N JX,X,ISDATA
"RTN","XWBDLOG",74,0)
 S JX=-1
"RTN","XWBDLOG",75,0)
 F  S JX=$O(@(GLOB_","""_JX_""")")) Q:'$L(JX)  S XGLOB=GLOB_","""_JX_""")" S ISDATA=$D(@XGLOB)#2 S:ISDATA X=@(XGLOB) D:ISDATA VL2(XGLOB,X) Q:IXNEXT  I $D(@(XGLOB))>1 D V2(GLOB_","""_JX_"""") Q:IXNEXT
"RTN","XWBDLOG",76,0)
 Q
"RTN","XWBDLOG",77,0)
 ;
"RTN","XWBDLOG",78,0)
VL1(J,K) ;Write a line
"RTN","XWBDLOG",79,0)
 I $Y'<IOSL,$$WAIT(.CON) S IXNEXT=1 S:CON=3 XWB="XWC" Q
"RTN","XWBDLOG",80,0)
 Q:'$D(^XTMP(XWB,IX))
"RTN","XWBDLOG",81,0)
 N H,D,T,I
"RTN","XWBDLOG",82,0)
 S H=$P($$HTE^XLFDT($P(K,"^"),"2S"),"@",2)_" = "
"RTN","XWBDLOG",83,0)
 S D=$P(K,"^",2,99),K=D
"RTN","XWBDLOG",84,0)
 I D?.E1C.E D
"RTN","XWBDLOG",85,0)
 . S D=""
"RTN","XWBDLOG",86,0)
 . F I=1:1:$L(K) S T=$A(K,I),D=D_$S(T>31:$E(K,I),1:"\"_$E((1000+T),3,4))
"RTN","XWBDLOG",87,0)
 . Q
"RTN","XWBDLOG",88,0)
 S T=$L(H)
"RTN","XWBDLOG",89,0)
 F  W !,H,?T,$E(D,1,68) S H="",D=$E(D,69,999) Q:'$L(D)
"RTN","XWBDLOG",90,0)
 Q
"RTN","XWBDLOG",91,0)
 ;
"RTN","XWBDLOG",92,0)
VL2(J,K) ; write line of array
"RTN","XWBDLOG",93,0)
 ; ZEXCEPT: IXNEXT   defined and newed in VIEW
"RTN","XWBDLOG",94,0)
 ; ZEXCEPT: IX,CNT,V2LEN   defined and newed in V1
"RTN","XWBDLOG",95,0)
 ; ZEXCEPT: XWB     argument to V1
"RTN","XWBDLOG",96,0)
 N D
"RTN","XWBDLOG",97,0)
 I $Y'<IOSL,$$WAIT(.CON) S IX="A",IXNEXT=1 S:CON=3 XWB="XWC" Q
"RTN","XWBDLOG",98,0)
 S D=$E(J,V2LEN+1,999)_" : "_K
"RTN","XWBDLOG",99,0)
 F  W !,?11,$E(D,1,68) S D=$E(D,69,999) Q:'$L(D)
"RTN","XWBDLOG",100,0)
 Q
"RTN","XWBDLOG",101,0)
 ;
"RTN","XWBDLOG",102,0)
WAIT(CON) ;continue/kill/exit
"RTN","XWBDLOG",103,0)
 S DIR("?")="Enter RETURN to continue, Next for next log, Kill to remove log, Exit to quit log view."
"RTN","XWBDLOG",104,0)
 S DIR("A")="Return to continue, Next log, Exit: "
"RTN","XWBDLOG",105,0)
 S DIR(0)="SAB^1:Continue;2:Next;3:Exit;4:Kill",DIR("B")="Continue"
"RTN","XWBDLOG",106,0)
 D ^DIR
"RTN","XWBDLOG",107,0)
 S CON=+Y
"RTN","XWBDLOG",108,0)
 I Y=4 D K1(XWB,0) H 1
"RTN","XWBDLOG",109,0)
 I Y=1 W @IOF
"RTN","XWBDLOG",110,0)
 Q Y>1
"RTN","XWBDLOG",111,0)
 ;
"RTN","XWBDLOG",112,0)
K1(REF,S) ;Kill one
"RTN","XWBDLOG",113,0)
 I REF["XWBLOG" K ^XTMP(REF)
"RTN","XWBDLOG",114,0)
 I 'S W !,"Log "_REF_" deleted."
"RTN","XWBDLOG",115,0)
 Q
"RTN","XWBDLOG",116,0)
 ;
"RTN","XWBDLOG",117,0)
KILLALL ;KILL ALL LOG Entries
"RTN","XWBDLOG",118,0)
 N DIR,XWB
"RTN","XWBDLOG",119,0)
 S DIR(0)="Y",DIR("A")="Remove all XWB log entries",DIR("B")="No"
"RTN","XWBDLOG",120,0)
 D ^DIR Q:Y'=1
"RTN","XWBDLOG",121,0)
 S XWB="XWBLOG"
"RTN","XWBDLOG",122,0)
 F  S XWB=$O(^XTMP(XWB)) Q:XWB'["XWBLOG"  D K1(XWB,1)
"RTN","XWBDLOG",123,0)
 W !,"Done"
"RTN","XWBDLOG",124,0)
 Q
"RTN","XWBDLOG",125,0)
 ;
"RTN","XWBDLOG",126,0)
 ;
"RTN","XWBDLOG",127,0)
EOR ; end of routine XWBDLOG
"RTN","XWBM2MC")
0^10^B63427122
"RTN","XWBM2MC",1,0)
XWBM2MC ;OIFO-Oakland/REM - M2M Broker Client APIs ; 08/29/2013  9:33am
"RTN","XWBM2MC",2,0)
 ;;1.1;RPC BROKER;**28,34**;Mar 28, 1997;Build 9
"RTN","XWBM2MC",3,0)
 ;
"RTN","XWBM2MC",4,0)
 QUIT  ; routine XWBRPC is not callable at the top
"RTN","XWBM2MC",5,0)
 ;
"RTN","XWBM2MC",6,0)
 ;
"RTN","XWBM2MC",7,0)
 ; Change History:
"RTN","XWBM2MC",8,0)
 ;
"RTN","XWBM2MC",9,0)
 ; 2002 08 10 OIFO/REM: XWB*1.1*28 SEQ #25, M2M Broker. Original routine
"RTN","XWBM2MC",10,0)
 ; created. 
"RTN","XWBM2MC",11,0)
 ;
"RTN","XWBM2MC",12,0)
 ; 2005 10 26 OIFO/REM: XWB*1.1*34 SEQ #33, M2M Bug Fixes. Ensure RES
"RTN","XWBM2MC",13,0)
 ; is defined. Error exception if RPCNAM not defined. Killed XWBY before
"RTN","XWBM2MC",14,0)
 ; going to PARSE^XWBRPC. Returned 0 when error occurs and XWBY=error
"RTN","XWBM2MC",15,0)
 ; msg. Added new module to GET the division for a user. Added new
"RTN","XWBM2MC",16,0)
 ; module to SET the division for a user. Killed entry for current
"RTN","XWBM2MC",17,0)
 ; context in ^TMP("XWBM2M",$J). Commented out line; will do PRE in
"RTN","XWBM2MC",18,0)
 ; REQUEST^XWBRPCC. Sent PORT;IP to ERROR so it's included in error
"RTN","XWBM2MC",19,0)
 ; msg. Added 2 more error msg for GETDIV and SETDIV.
"RTN","XWBM2MC",20,0)
 ; in CALLRPC, GETDIV, SETDIV, CLEAN, PARAM, ERROR, ERRMSGS.
"RTN","XWBM2MC",21,0)
 ;
"RTN","XWBM2MC",22,0)
 ; 2013 08 29 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBM2MC",23,0)
 ; Fixed bug in recognizing error messages; it was too case sensitive;
"RTN","XWBM2MC",24,0)
 ; replaced with $translate; combine near-duplicate error checks;
"RTN","XWBM2MC",25,0)
 ; resolve inconsistency in where error message is returned by
"RTN","XWBM2MC",26,0)
 ; returning it in both places for backward compatibility.
"RTN","XWBM2MC",27,0)
 ; Change History added. in XWBM2MC, CALLRPC, EOR.
"RTN","XWBM2MC",28,0)
 ;
"RTN","XWBM2MC",29,0)
 ;
"RTN","XWBM2MC",30,0)
CONNECT(PORT,IP,AV) ;Establishes the connection to the server.
"RTN","XWBM2MC",31,0)
 ;CONNECT returns 1=successful, 0=failed
"RTN","XWBM2MC",32,0)
 ;PORT - PORT number where listener is running.
"RTN","XWBM2MC",33,0)
 ;IP - IP address where the listener is running.
"RTN","XWBM2MC",34,0)
 ;AV - Access and verify codes to sign on into VistA.
"RTN","XWBM2MC",35,0)
 ;DIV - User division.
"RTN","XWBM2MC",36,0)
 ;
"RTN","XWBM2MC",37,0)
 ;K XWBPARMS
"RTN","XWBM2MC",38,0)
 N XWBSTAT,XWBPARMS
"RTN","XWBM2MC",39,0)
 S XWBPARMS("ADDRESS")=IP,XWBPARMS("PORT")=PORT
"RTN","XWBM2MC",40,0)
 S XWBPARMS("RETRIES")=3 ;Retries 3 times to open
"RTN","XWBM2MC",41,0)
 ;
"RTN","XWBM2MC",42,0)
 ;p34-send PORT;IP to ERROR so it's included in error msg.
"RTN","XWBM2MC",43,0)
 I '$$OPEN^XWBRL(.XWBPARMS) D ERROR(1,PORT_";"_IP) Q 0
"RTN","XWBM2MC",44,0)
 D SAVDEV^%ZISUTL("XWBM2M PORT")
"RTN","XWBM2MC",45,0)
 ;
"RTN","XWBM2MC",46,0)
 ;XUS SIGNON SETUP RPC
"RTN","XWBM2MC",47,0)
 I '$$SIGNON() D ERROR(2) S X=$$CLOSE() Q 0
"RTN","XWBM2MC",48,0)
 ; Results from XUS Signon
"RTN","XWBM2MC",49,0)
 ; 1=server name, 2=volume, 3=uci, 4=device, 5=# attempts
"RTN","XWBM2MC",50,0)
 ; 6=skip signon-screen
"RTN","XWBM2MC",51,0)
 ;M ^TMP("XWBM2M",$J,"XUS SIGNON")=^TMP("XWBM2MRPC",$J,"RESULTS") ;Remove after testing **REM
"RTN","XWBM2MC",52,0)
 ;
"RTN","XWBM2MC",53,0)
 ;Validate AV codes
"RTN","XWBM2MC",54,0)
 ;S AV=$$CHARCHK^XWBUTL(AV) ;Convert and special char
"RTN","XWBM2MC",55,0)
 I '$$VALIDAV(AV) D ERROR(3) S X=$$CLOSE() Q 0
"RTN","XWBM2MC",56,0)
 ;
"RTN","XWBM2MC",57,0)
 I $G(^TMP("XWBM2MRPC",$J,"RESULTS",1))'>0 D ERROR(4) S X=$$CLOSE() Q 0
"RTN","XWBM2MC",58,0)
 ;M ^TMP("XWBM2M",$J,"XUS AV CODE")=^TMP("XWBM2MRPC",$J,"RESULTS") ;Remove after testing **REM
"RTN","XWBM2MC",59,0)
 ;
"RTN","XWBM2MC",60,0)
 D USE^%ZISUTL("XWBM2M CLIENT") U IO
"RTN","XWBM2MC",61,0)
 S ^TMP("XWBM2M",$J,"CONNECTED")=1
"RTN","XWBM2MC",62,0)
 Q 1
"RTN","XWBM2MC",63,0)
 ;
"RTN","XWBM2MC",64,0)
ISCONT() ;Function to check connection status. 1=connect, 0=not connect
"RTN","XWBM2MC",65,0)
 Q $G(^TMP("XWBM2M",$J,"CONNECTED"),0)
"RTN","XWBM2MC",66,0)
 ;
"RTN","XWBM2MC",67,0)
SETCONTX(CONTXNA) ;Set context and returns 1=successful or 0=failed
"RTN","XWBM2MC",68,0)
 N REQ,XWBPARMS,X
"RTN","XWBM2MC",69,0)
 S ^TMP("XWBM2M",$J,"CONTEXT")=""
"RTN","XWBM2MC",70,0)
 K ^TMP("XWBM2M",$J,"ERROR","SETCONTX")
"RTN","XWBM2MC",71,0)
 ;;D PRE,SETPARAM(1,"STRING",$$CHARCHK^XWBUTL($$ENCRYP^XUSRB1(CONTXNA)))
"RTN","XWBM2MC",72,0)
 D PRE,SETPARAM(1,"STRING",$$ENCRYP^XUSRB1(CONTXNA))
"RTN","XWBM2MC",73,0)
 S X=$$CALLRPC("XWB CREATE CONTEXT","REQ",1)
"RTN","XWBM2MC",74,0)
 S REQ=$G(REQ(1))
"RTN","XWBM2MC",75,0)
 I REQ'=1 S ^TMP("XWBM2ME",$J,"ERROR","SETCONTX")=REQ Q 0
"RTN","XWBM2MC",76,0)
 S ^TMP("XWBM2M",$J,"CONTEXT")=CONTXNA
"RTN","XWBM2MC",77,0)
 Q 1
"RTN","XWBM2MC",78,0)
 ;
"RTN","XWBM2MC",79,0)
GETCONTX(CONTEXT) ;Returns current context
"RTN","XWBM2MC",80,0)
 S CONTEXT=$G(^TMP("XWBM2M",$J,"CONTEXT"))
"RTN","XWBM2MC",81,0)
 I CONTEXT="" Q 0
"RTN","XWBM2MC",82,0)
 Q 1
"RTN","XWBM2MC",83,0)
 ;
"RTN","XWBM2MC",84,0)
SETPARAM(INDEX,TYPE,VALUE) ;Set a Params entry
"RTN","XWBM2MC",85,0)
 S XWBPARMS("PARAMS",INDEX,"TYPE")=TYPE
"RTN","XWBM2MC",86,0)
 S XWBPARMS("PARAMS",INDEX,"VALUE")=VALUE
"RTN","XWBM2MC",87,0)
 Q
"RTN","XWBM2MC",88,0)
 ;
"RTN","XWBM2MC",89,0)
PARAM(PARAMNUM,ROOT) ;Build the PARAM data structure
"RTN","XWBM2MC",90,0)
 ;p34-comment out line. Will do PRE in REQUEST^XWBRPCC
"RTN","XWBM2MC",91,0)
 ;
"RTN","XWBM2MC",92,0)
 I PARAMNUM=""!(ROOT="") Q 0
"RTN","XWBM2MC",93,0)
 ;D PRE ;*p34
"RTN","XWBM2MC",94,0)
 M XWBPARMS("PARAMS",PARAMNUM)=@ROOT
"RTN","XWBM2MC",95,0)
 Q 1
"RTN","XWBM2MC",96,0)
 ;
"RTN","XWBM2MC",97,0)
 ;
"RTN","XWBM2MC",98,0)
CALLRPC(RPCNAM,RES,CLRPARMS) ;Call to RPC and wraps RPC in XML
"RTN","XWBM2MC",99,0)
 ;RPCNAM -RPC name to run
"RTN","XWBM2MC",100,0)
 ;RES -location where to place results.  If no RES, then results will be
"RTN","XWBM2MC",101,0)
 ; placed in ^TMP("XWBM2M",$J,"RESULTS")
"RTN","XWBM2MC",102,0)
 ;CLRPARMS - 1=clear PARAMS, 0=do not clear PARAMS.  Default is 1.
"RTN","XWBM2MC",103,0)
 ;
"RTN","XWBM2MC",104,0)
 N ER,ERX,GL
"RTN","XWBM2MC",105,0)
 I '$D(RES) S RES="" ;*p34-make sure RES is defined.
"RTN","XWBM2MC",106,0)
 I '$D(RPCNAM) D  Q 0  ;*p34-error if RPCNAM not defined.
"RTN","XWBM2MC",107,0)
 .I $G(RES)'="" S @RES="Pass in NULL for RPCNAM."
"RTN","XWBM2MC",108,0)
 .I $G(RES)="" S ^TMP("XWBM2MRPC",$J,"RESULTS",1)="Pass in NULL for RPCNAM."
"RTN","XWBM2MC",109,0)
 K ^TMP("XWBM2MRPC",$J,"RESULTS") ;Clear before run new RPC
"RTN","XWBM2MC",110,0)
 K ^TMP("XWBM2ME",$J,"ERROR","CALLRPC")
"RTN","XWBM2MC",111,0)
 I '$$ISCONT() D ERROR(5) Q 0  ;Not connected so do not run RPC
"RTN","XWBM2MC",112,0)
 D SAVDEV^%ZISUTL("XWBM2M CLIENT")
"RTN","XWBM2MC",113,0)
 D USE^%ZISUTL("XWBM2M PORT") U IO
"RTN","XWBM2MC",114,0)
 S XWBPARMS("URI")=RPCNAM
"RTN","XWBM2MC",115,0)
 S XWBCRLFL=0
"RTN","XWBM2MC",116,0)
 D REQUEST^XWBRPCC(.XWBPARMS)
"RTN","XWBM2MC",117,0)
 I XWBCRLFL D  Q 0
"RTN","XWBM2MC",118,0)
 . I $G(CLRPARMS)'=0 K XWBPARMS("PARAMS")
"RTN","XWBM2MC",119,0)
 . K RES
"RTN","XWBM2MC",120,0)
 . D USE^%ZISUTL("XWBM2M CLIENT") U IO
"RTN","XWBM2MC",121,0)
 ;
"RTN","XWBM2MC",122,0)
 ;Check if needed!!  **REM
"RTN","XWBM2MC",123,0)
 ;;IF $G(XWBPARMS("RESULTS"))="" SET XWBPARMS("RESULTS")=$NA(^TMP("XWBRPC"))
"RTN","XWBM2MC",124,0)
 ;
"RTN","XWBM2MC",125,0)
 I '$$EXECUTE^XWBVLC(.XWBPARMS) D  Q 0  ;Run RPC and place raw XML results
"RTN","XWBM2MC",126,0)
 .D ERROR(6)
"RTN","XWBM2MC",127,0)
 .D USE^%ZISUTL("XWBM2M CLIENT") U IO
"RTN","XWBM2MC",128,0)
 ;
"RTN","XWBM2MC",129,0)
 S XWBY="" I RES'="" S XWBY=RES K @($G(XWBY)) ;*p34-kill XWBY before PARSE
"RTN","XWBM2MC",130,0)
 D PARSE^XWBRPC(.XWBPARMS,XWBY)
"RTN","XWBM2MC",131,0)
 ;
"RTN","XWBM2MC",132,0)
 ; handle errors - return 0 and @XWBY = error message
"RTN","XWBM2MC",133,0)
 I $G(RES)="" N XWBY S XWBY=$NA(^TMP("XWBM2MRPC",$J,"RESULTS"))
"RTN","XWBM2MC",134,0)
 I $G(@XWBY)="",$G(@XWBY@(1))="" D  Q ERX ; return error
"RTN","XWBM2MC",135,0)
 . S ER=$G(^TMP("XWBM2MVLC",$J,"XML",2))
"RTN","XWBM2MC",136,0)
 . ; if error, ER = "<vistalink type=""VA.RPC.Error"" >"
"RTN","XWBM2MC",137,0)
 . S ERX=$$UP^XLFSTR(ER)'["ERROR" ; 1 if success, 0 if error
"RTN","XWBM2MC",138,0)
 . Q:ERX  ; no error
"RTN","XWBM2MC",139,0)
 . S @XWBY=ER ; error for RES'=""
"RTN","XWBM2MC",140,0)
 . S @XWBY@(1)=ER ; for RES="" (keep for backward compatibility)
"RTN","XWBM2MC",141,0)
 . D USE^%ZISUTL("XWBM2M CLIENT") U IO
"RTN","XWBM2MC",142,0)
 ;
"RTN","XWBM2MC",143,0)
 I $G(CLRPARMS)'=0 K XWBPARMS("PARAMS") ;Default is to clear
"RTN","XWBM2MC",144,0)
 D USE^%ZISUTL("XWBM2M CLIENT") U IO
"RTN","XWBM2MC",145,0)
 ;
"RTN","XWBM2MC",146,0)
 Q 1 ; return success ; end of $$CALLRPC
"RTN","XWBM2MC",147,0)
 ;
"RTN","XWBM2MC",148,0)
 ;
"RTN","XWBM2MC",149,0)
CLOSE() ;Close connection
"RTN","XWBM2MC",150,0)
 I '$$ISCONT() D ERROR(5) Q 0  ;Not connected
"RTN","XWBM2MC",151,0)
 D SAVDEV^%ZISUTL("XWBM2M CLIENT")
"RTN","XWBM2MC",152,0)
 D USE^%ZISUTL("XWBM2M PORT") U IO
"RTN","XWBM2MC",153,0)
 D CLOSE^XWBRL
"RTN","XWBM2MC",154,0)
 D RMDEV^%ZISUTL("XWBM2M PORT")
"RTN","XWBM2MC",155,0)
 D CLEAN
"RTN","XWBM2MC",156,0)
 S ^TMP("XWBM2M",$J,"CONNECTED")=0
"RTN","XWBM2MC",157,0)
 Q 1
"RTN","XWBM2MC",158,0)
 ;
"RTN","XWBM2MC",159,0)
CLEAN ;Clean up
"RTN","XWBM2MC",160,0)
 ;*p34-kills entry for current context in ^TMP("XWBM2M",$J)
"RTN","XWBM2MC",161,0)
 ;
"RTN","XWBM2MC",162,0)
 I '$G(XWBDBUG) K XWBPARMS
"RTN","XWBM2MC",163,0)
 K ^TMP("XWBM2M",$J),^TMP("XWBM2MRPC",$J),^TMP("XWBM2MVLC",$J)
"RTN","XWBM2MC",164,0)
 K ^TMP("XWBM2MRL"),^TMP("XWBM2ML",$J),^TMP("XWBVLL")
"RTN","XWBM2MC",165,0)
 K XWBTDEV,XWBTID,XWBVER,XWBCBK,XWBFIRST,XWBTO,XWBQUIT,XWBREAD
"RTN","XWBM2MC",166,0)
 K XWBRL,XWBROOT,XWBSTOP,XWBX,XWBY,XWBYX,XWBREQ,XWBCOK
"RTN","XWBM2MC",167,0)
 K XWBCLRFL
"RTN","XWBM2MC",168,0)
 Q
"RTN","XWBM2MC",169,0)
 ;
"RTN","XWBM2MC",170,0)
SIGNON() ;
"RTN","XWBM2MC",171,0)
 ;Encrpt AV before sending with RPC
"RTN","XWBM2MC",172,0)
 N XWBPARMS,XWBY
"RTN","XWBM2MC",173,0)
 K XWBPARMS
"RTN","XWBM2MC",174,0)
 S XWBPARMS("URI")="XUS SIGNON SETUP"
"RTN","XWBM2MC",175,0)
 S XWBCRLFL=0
"RTN","XWBM2MC",176,0)
 D REQUEST^XWBRPCC(.XWBPARMS)
"RTN","XWBM2MC",177,0)
 I XWBCRLFL Q 0
"RTN","XWBM2MC",178,0)
 ;
"RTN","XWBM2MC",179,0)
 ;Check if needed!!  **REM
"RTN","XWBM2MC",180,0)
 ;;IF $G(XWBPARMS("RESULTS"))="" SET XWBPARMS("RESULTS")=$NA(^TMP("XWBRPC",$J,"XML"))
"RTN","XWBM2MC",181,0)
 ;
"RTN","XWBM2MC",182,0)
 I '$$EXECUTE^XWBVLC(.XWBPARMS) Q 0 ;Run RPC and place raw XML results in ^TMP("XWBM2MVLC"
"RTN","XWBM2MC",183,0)
 S XWBY="" D PARSE^XWBRPC(.XWBPARMS,XWBY) ;Parse out raw XML and place results in ^TMP("XWBM2MRPC"
"RTN","XWBM2MC",184,0)
 Q 1
"RTN","XWBM2MC",185,0)
 ;
"RTN","XWBM2MC",186,0)
VALIDAV(AV) ;Check AV code
"RTN","XWBM2MC",187,0)
 K XWBPARMS
"RTN","XWBM2MC",188,0)
 S AV=$$ENCRYP^XUSRB1(AV) ;Encrypt access/verify codes
"RTN","XWBM2MC",189,0)
 D PRE
"RTN","XWBM2MC",190,0)
 ;
"RTN","XWBM2MC",191,0)
 ; -String parameter type
"RTN","XWBM2MC",192,0)
 S XWBPARMS("PARAMS",1,"TYPE")="STRING"
"RTN","XWBM2MC",193,0)
 ;;S XWBPARMS("PARAMS",1,"VALUE")=$$CHARCHK^XWBUTL(AV)
"RTN","XWBM2MC",194,0)
 S XWBPARMS("PARAMS",1,"VALUE")=AV
"RTN","XWBM2MC",195,0)
 S XWBPARMS("URI")="XUS AV CODE"
"RTN","XWBM2MC",196,0)
 S XWBCRLFL=0
"RTN","XWBM2MC",197,0)
 D REQUEST^XWBRPCC(.XWBPARMS)
"RTN","XWBM2MC",198,0)
 I XWBCRLFL Q 0
"RTN","XWBM2MC",199,0)
 ;
"RTN","XWBM2MC",200,0)
 ;Check if needed!!  **REM
"RTN","XWBM2MC",201,0)
 ;;IF $G(XWBPARMS("RESULTS"))="" SET XWBPARMS("RESULTS")=$NA(^TMP("XWBRPC",$J,"XML"))
"RTN","XWBM2MC",202,0)
 ;
"RTN","XWBM2MC",203,0)
 I '$$EXECUTE^XWBVLC(.XWBPARMS) Q 0 ;Run RPC and place raw XML results in ^TMP("XWBM2MVLC"
"RTN","XWBM2MC",204,0)
 S XWBY="" D PARSE^XWBRPC(.XWBPARMS,XWBY) ;Parse out raw XML and place results in ^TMP("XWBM2MRPC"
"RTN","XWBM2MC",205,0)
 K XWBPARMS
"RTN","XWBM2MC",206,0)
 Q 1
"RTN","XWBM2MC",207,0)
 ;
"RTN","XWBM2MC",208,0)
GETDIV(XWBDIVG) ;*p34-gets the division for a user.
"RTN","XWBM2MC",209,0)
 ;Returns 1-succuss, 0=fail
"RTN","XWBM2MC",210,0)
 ;XWBDIVG - where the division string will be places.
"RTN","XWBM2MC",211,0)
 ;Return value for XWBDIVG:
"RTN","XWBM2MC",212,0)
 ; XWBDIVG(1)=number of divisions
"RTN","XWBM2MC",213,0)
 ; XWBDIVG(#)='ien;station name;station#' delimitated with ";"
"RTN","XWBM2MC",214,0)
 ; If a user has only 1 divison, then XWBDIVG(1)=0 because Kernel
"RTN","XWBM2MC",215,0)
 ; will automatically assign that division as a default.  Use IEN to
"RTN","XWBM2MC",216,0)
 ; set division in $$SETDIV.
"RTN","XWBM2MC",217,0)
 N RPC,ROOT
"RTN","XWBM2MC",218,0)
 K XWBPARMS
"RTN","XWBM2MC",219,0)
 D PRE,SETPARAM(1,"STRING","DUMBY")
"RTN","XWBM2MC",220,0)
 I '$$CALLRPC^XWBM2MC("XUS DIVISION GET",XWBDIVG,0) D ERROR(10) Q 0
"RTN","XWBM2MC",221,0)
 K XWBPARMS
"RTN","XWBM2MC",222,0)
 Q 1
"RTN","XWBM2MC",223,0)
 ;
"RTN","XWBM2MC",224,0)
SETDIV(XWBDIVS) ;*p34-sets the division for a user.
"RTN","XWBM2MC",225,0)
 ;Returns 1-success, 0=fail
"RTN","XWBM2MC",226,0)
 ;XWBDIVS - Division to set. Use IEN from $$GETDIV.
"RTN","XWBM2MC",227,0)
 N REQ
"RTN","XWBM2MC",228,0)
 K XWBPARMS
"RTN","XWBM2MC",229,0)
 S REQ="RESULT"
"RTN","XWBM2MC",230,0)
 D PRE,SETPARAM(1,"STRING",XWBDIVS)
"RTN","XWBM2MC",231,0)
 I '$$CALLRPC^XWBM2MC("XUS DIVISION SET",REQ,0) D ERROR(11) Q 0
"RTN","XWBM2MC",232,0)
 K XWBPARMS
"RTN","XWBM2MC",233,0)
 Q 1
"RTN","XWBM2MC",234,0)
 ;
"RTN","XWBM2MC",235,0)
PRE ;Prepare the needed PARMS **REM might not need PRE
"RTN","XWBM2MC",236,0)
 ;S XWBCON="DSM" ;Check if needed!!  **REM
"RTN","XWBM2MC",237,0)
 ;
"RTN","XWBM2MC",238,0)
 S XWBPARMS("MODE")="RPCBroker"
"RTN","XWBM2MC",239,0)
 Q
"RTN","XWBM2MC",240,0)
 ;
"RTN","XWBM2MC",241,0)
ERROR(CODE,STR) ;Will write error msg and related API in TMP
"RTN","XWBM2MC",242,0)
 ;*p34-new STR to append to error msg.
"RTN","XWBM2MC",243,0)
 N API,X
"RTN","XWBM2MC",244,0)
 S API=$P($T(ERRMSG+CODE),";;",3)
"RTN","XWBM2MC",245,0)
 S X=$NA(^TMP("XWBM2ME",$J,"ERROR",API)),@X=$P($T(ERRMSG+CODE),";;",2)_$G(STR) ;*p34
"RTN","XWBM2MC",246,0)
 Q
"RTN","XWBM2MC",247,0)
 ;
"RTN","XWBM2MC",248,0)
ERRMSG ; Error messages
"RTN","XWBM2MC",249,0)
 ;*p34-add 2 more error msg for GETDIV and SETDIV.
"RTN","XWBM2MC",250,0)
 ;;Could not open connection ;;CONNECT
"RTN","XWBM2MC",251,0)
 ;;XUS SIGNON SETUP RPC failed ;;SIGNON
"RTN","XWBM2MC",252,0)
 ;;XUS AV CODE RPC failed ;;SIGNON
"RTN","XWBM2MC",253,0)
 ;;Invalid user, no DUZ returned ;;SIGNON
"RTN","XWBM2MC",254,0)
 ;;There is no connection ;;CALLRPC
"RTN","XWBM2MC",255,0)
 ;;RPC could not be processed ;;CALLRPC
"RTN","XWBM2MC",256,0)
 ;;Remote Procedure Unknown ;;SERVER
"RTN","XWBM2MC",257,0)
 ;;Control Character Found ;;CALLRPC
"RTN","XWBM2MC",258,0)
 ;;Error in division return ;;CONNECT
"RTN","XWBM2MC",259,0)
 ;;Could not obtain list of valid divisions for current user ;;GETDIV
"RTN","XWBM2MC",260,0)
 ;;Could not Set active Division for current user ;;SETDIV
"RTN","XWBM2MC",261,0)
 Q
"RTN","XWBM2MC",262,0)
 ;
"RTN","XWBM2MC",263,0)
 ;
"RTN","XWBM2MC",264,0)
EOR ; end of routine XWBM2MC
"RTN","XWBP991")
0^1^B1514642
"RTN","XWBP991",1,0)
XWBP991 ;VEN/TOAD - XWB*1.1*991 Post-install ; 8/28/2013 10:40am
"RTN","XWBP991",2,0)
 ;;1.1;RPC BROKER;**991**;Mar 28, 1997;Build 9
"RTN","XWBP991",3,0)
 ;
"RTN","XWBP991",4,0)
 QUIT  ; routine XWBP991 is not callable at the top
"RTN","XWBP991",5,0)
 ;
"RTN","XWBP991",6,0)
 ; Change History:
"RTN","XWBP991",7,0)
 ;
"RTN","XWBP991",8,0)
 ; 2013 08 19-28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBP991",9,0)
 ; Original routine created to set the new XWBM2M package-parameter
"RTN","XWBP991",10,0)
 ; to enable the M-to-M Broker.
"RTN","XWBP991",11,0)
 ;
"RTN","XWBP991",12,0)
 ;
"RTN","XWBP991",13,0)
POST ; Post-install for XWB*1.1*991
"RTN","XWBP991",14,0)
 ;
"RTN","XWBP991",15,0)
 ; 1. set XWBM2M package-parameter
"RTN","XWBP991",16,0)
 ;
"RTN","XWBP991",17,0)
 N XWBERR ; error message from setting XWBM2M
"RTN","XWBP991",18,0)
 D PUT^XPAR("PKG","XWBM2M",1,1,.XWBERR) ; set default value of XWBM2M
"RTN","XWBP991",19,0)
 ;
"RTN","XWBP991",20,0)
 ; 2. report results to screen & Install file
"RTN","XWBP991",21,0)
 ;
"RTN","XWBP991",22,0)
 N XWBMSG S XWBMSG(1)="   "
"RTN","XWBP991",23,0)
 I $G(XWBERR) D  ; if set failed
"RTN","XWBP991",24,0)
 . S XWBMSG(2)="   Error setting parameter XWBM2M: "_XWBERR_"."
"RTN","XWBP991",25,0)
 E  D  ; if it succeeded
"RTN","XWBP991",26,0)
 . S XWBMSG(2)="   Parameter XWBM2M set to default of Yes, Enabled."
"RTN","XWBP991",27,0)
 D MES^XPDUTL(.XWBMSG)
"RTN","XWBP991",28,0)
 ;
"RTN","XWBP991",29,0)
 QUIT  ; end of POST
"RTN","XWBP991",30,0)
 ;
"RTN","XWBP991",31,0)
 ;
"RTN","XWBP991",32,0)
EOR ; end of routine XWBP991
"RTN","XWBRL")
0^8^B24123947
"RTN","XWBRL",1,0)
XWBRL ;OIFO-Oakland/REM - M2M Link Methods ; 08/28/2013 10:40am
"RTN","XWBRL",2,0)
 ;;1.1;RPC BROKER;**28,34,991**;Mar 28, 1997;Build 9
"RTN","XWBRL",3,0)
 ;
"RTN","XWBRL",4,0)
 QUIT  ; routine XWBRL is not callable at the top
"RTN","XWBRL",5,0)
 ;
"RTN","XWBRL",6,0)
 ; Change History:
"RTN","XWBRL",7,0)
 ;
"RTN","XWBRL",8,0)
 ; 2002 08 10 OIFO/REM: XWB*1.1*28 SEQ #25, M2M Broker. Original routine
"RTN","XWBRL",9,0)
 ; created.
"RTN","XWBRL",10,0)
 ;
"RTN","XWBRL",11,0)
 ; 2005 10 26 OIFO/REM: XWB*1.1*34 SEQ #33, M2M Bug Fixes. Made sure that
"RTN","XWBRL",12,0)
 ; XWBOS is defined. Modified code to support the new meaning of $X in
"RTN","XWBRL",13,0)
 ; Cache 5.x. Removed intervening lines that call WBF. Added code to
"RTN","XWBRL",14,0)
 ; include option for GT.M. Added line for XWBTCPM to read by Wally's
"RTN","XWBRL",15,0)
 ; non-call back service. in WRITE.
"RTN","XWBRL",16,0)
 ;
"RTN","XWBRL",17,0)
 ; 2013 08 19-28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBRL",18,0)
 ; Fix bugs in handling of GT.M. Make values for XWBOS in this routine
"RTN","XWBRL",19,0)
 ; match what they're set to in XWBTCPM, and change tests to correspond.
"RTN","XWBRL",20,0)
 ; Standardize initialization of locals and log. Change WBF to use
"RTN","XWBRL",21,0)
 ; XWBT("BF") for buffer flush. Add init variables to cleanup list.
"RTN","XWBRL",22,0)
 ; Adjust test for pre-loaded buffer in READ. Optimize performance
"RTN","XWBRL",23,0)
 ; for GT.M on Linus systems by reading one character at a time.
"RTN","XWBRL",24,0)
 ; Eliminate unneeded subroutines. Refactor for clarity.
"RTN","XWBRL",25,0)
 ; Change History added.
"RTN","XWBRL",26,0)
 ; in XWBRL, INIT, OPEN, READ, CHK, WRITE, POST, WBF, CLOSE, FINAL, EOR.
"RTN","XWBRL",27,0)
 ;
"RTN","XWBRL",28,0)
 ;
"RTN","XWBRL",29,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRL",30,0)
 ;                    Methods for Read from and to TCP/IP Socket
"RTN","XWBRL",31,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRL",32,0)
READ(XWBROOT,XWBREAD,XWBTO,XWBFIRST,XWBSTOP) ;
"RTN","XWBRL",33,0)
 ;
"RTN","XWBRL",34,0)
 ; -- initialize tcp processing variables
"RTN","XWBRL",35,0)
 I $G(XWBOS)="" D  ; if we have not already initialized,
"RTN","XWBRL",36,0)
 . D INIT^XWBTCPM ; set up locals and start log
"RTN","XWBRL",37,0)
 ;
"RTN","XWBRL",38,0)
 ; -- initialize subroutine variables
"RTN","XWBRL",39,0)
 NEW X,EOT,OUT,STR,LINE,PIECES,DONE,TOFLAG,XWBCNT,XWBLEN
"RTN","XWBRL",40,0)
 SET STR="",EOT=$C(4),DONE=0,LINE=0
"RTN","XWBRL",41,0)
 ;
"RTN","XWBRL",42,0)
 ; -- From XWBTCPM startup, One time thing *p34
"RTN","XWBRL",43,0)
 I $G(XWBRBUF)'="" D  ; if we've already read in the first message
"RTN","XWBRL",44,0)
 . S STR=XWBRBUF ; preload message
"RTN","XWBRL",45,0)
 . S XWBTO=0 ; change time-out (no need to wait, we have it)
"RTN","XWBRL",46,0)
 . S XWBFIRST=0 ; the next read is not the first read
"RTN","XWBRL",47,0)
 . K XWBRBUF ; clear flag
"RTN","XWBRL",48,0)
 ;
"RTN","XWBRL",49,0)
 ; -- optimize performance on GT.M systems
"RTN","XWBRL",50,0)
 I XWBOS["GT.M" D  ; for GT.M systems
"RTN","XWBRL",51,0)
 . S XWBREAD=1 ; always read one character at a time
"RTN","XWBRL",52,0)
 ;
"RTN","XWBRL",53,0)
 ; -- READ needs work for length checking ; This needs work!!
"RTN","XWBRL",54,0)
 FOR  READ XWBX#XWBREAD:XWBTO SET TOFLAG=$T DO CHK DO:'XWBSTOP  QUIT:DONE
"RTN","XWBRL",55,0)
 . IF $L(STR)+$L(XWBX)>400 DO ADD(STR) S STR=""
"RTN","XWBRL",56,0)
 . SET STR=STR_XWBX
"RTN","XWBRL",57,0)
 . FOR  Q:STR'[$C(10)  DO ADD($P(STR,$C(10))) SET STR=$P(STR,$C(10),2,999)
"RTN","XWBRL",58,0)
 . IF STR[EOT SET STR=$P(STR,EOT) DO ADD(STR) SET DONE=1 QUIT
"RTN","XWBRL",59,0)
 . SET PIECES=$L(STR,">")
"RTN","XWBRL",60,0)
 . IF PIECES>1 DO ADD($P(STR,">",1,PIECES-1)_">") SET STR=$P(STR,">",PIECES,999)
"RTN","XWBRL",61,0)
 ;
"RTN","XWBRL",62,0)
 QUIT 1 ; always return true ; end of READ
"RTN","XWBRL",63,0)
 ;
"RTN","XWBRL",64,0)
 ;
"RTN","XWBRL",65,0)
ADD(TXT) ; -- add new intake line
"RTN","XWBRL",66,0)
 SET LINE=LINE+1
"RTN","XWBRL",67,0)
 SET @XWBROOT@(LINE)=TXT
"RTN","XWBRL",68,0)
 QUIT
"RTN","XWBRL",69,0)
 ;
"RTN","XWBRL",70,0)
 ;
"RTN","XWBRL",71,0)
CHK ; -- check if first read and change timeout and chars to read
"RTN","XWBRL",72,0)
 IF 'TOFLAG,XWBFIRST SET XWBSTOP=1,DONE=1 QUIT  ; -- could cause small msg to not process
"RTN","XWBRL",73,0)
 SET XWBFIRST=0
"RTN","XWBRL",74,0)
 SET XWBREAD=100,XWBTO=2 ;M2M changed XWBTO=2
"RTN","XWBRL",75,0)
 ;
"RTN","XWBRL",76,0)
 ; -- optimize performance on GT.M systems
"RTN","XWBRL",77,0)
 I XWBOS["GT.M" D  ; for GT.M systems
"RTN","XWBRL",78,0)
 . S XWBREAD=1 ; always read one character at a time
"RTN","XWBRL",79,0)
 ;
"RTN","XWBRL",80,0)
 QUIT  ; end of CHK
"RTN","XWBRL",81,0)
 ;
"RTN","XWBRL",82,0)
 ;
"RTN","XWBRL",83,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRL",84,0)
 ;                      Methods for Opening and Closing Socket
"RTN","XWBRL",85,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRL",86,0)
OPEN(XWBPARMS) ; -- Open tcp/ip socket
"RTN","XWBRL",87,0)
 NEW I,POP
"RTN","XWBRL",88,0)
 SET POP=1
"RTN","XWBRL",89,0)
 ;
"RTN","XWBRL",90,0)
 ; -- initialize tcp processing variables
"RTN","XWBRL",91,0)
 I $G(XWBOS)="" D  ; if we have not already initialized,
"RTN","XWBRL",92,0)
 . D INIT^XWBTCPM ; set up locals and start log
"RTN","XWBRL",93,0)
 ;
"RTN","XWBRL",94,0)
 DO SAVDEV^%ZISUTL("XWBM2M CLIENT") ;M2M changed name
"RTN","XWBRL",95,0)
 FOR I=1:1:XWBPARMS("RETRIES") DO CALL^%ZISTCP(XWBPARMS("ADDRESS"),XWBPARMS("PORT")) QUIT:'POP
"RTN","XWBRL",96,0)
 ; Device open
"RTN","XWBRL",97,0)
 ;
"RTN","XWBRL",98,0)
 IF 'POP USE IO QUIT 1
"RTN","XWBRL",99,0)
 ; Device not open
"RTN","XWBRL",100,0)
 QUIT 0
"RTN","XWBRL",101,0)
 ;
"RTN","XWBRL",102,0)
CLOSE ; -- close tcp/ip socket
"RTN","XWBRL",103,0)
 ; -- tell server to Stop() connection
"RTN","XWBRL",104,0)
 ;
"RTN","XWBRL",105,0)
 ; -- initialize tcp processing variables
"RTN","XWBRL",106,0)
 I $G(XWBOS)="" D  ; if we have not already initialized,
"RTN","XWBRL",107,0)
 . D INIT^XWBTCPM ; set up locals and start log
"RTN","XWBRL",108,0)
 ;
"RTN","XWBRL",109,0)
 DO PRE
"RTN","XWBRL",110,0)
 DO WRITE($$XMLHDR^XWBUTL()_"<vistalink type='Gov.VA.Med.Foundations.CloseSocketRequest' ></vistalink>")
"RTN","XWBRL",111,0)
 DO POST
"RTN","XWBRL",112,0)
 ;
"RTN","XWBRL",113,0)
 ; -Read results from server close string.  **M2M
"RTN","XWBRL",114,0)
 IF $G(XWBPARMS("CCLOSERESULTS"))="" SET XWBPARMS("CCLOSERESULTS")=$NA(^TMP("XWBM2MRL",$J,"XML"))
"RTN","XWBRL",115,0)
 SET XWBROOT=XWBPARMS("CCLOSERESULTS") K @XWBROOT
"RTN","XWBRL",116,0)
 SET XWBREAD=20,XWBTO=1,XWBFIRST=0,XWBSTOP=0
"RTN","XWBRL",117,0)
 SET XWBCOK=$$READ^XWBRL(XWBROOT,.XWBREAD,.XWBTO,.XWBFIRST,.XWBSTOP)
"RTN","XWBRL",118,0)
 ;
"RTN","XWBRL",119,0)
 KILL XWBDEBUG,XWBM2M,XWBOS,XWBPARMS,XWBPARMS,XWBRBUF,XWBT,XWBTIME
"RTN","XWBRL",120,0)
 DO CLOSE^%ZISTCP
"RTN","XWBRL",121,0)
 DO USE^%ZISUTL("XWBM2M CLIENT") ; Change name **M2M
"RTN","XWBRL",122,0)
 DO RMDEV^%ZISUTL("XWBM2M CLIENT")
"RTN","XWBRL",123,0)
 QUIT
"RTN","XWBRL",124,0)
 ;
"RTN","XWBRL",125,0)
 ;
"RTN","XWBRL",126,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRL",127,0)
 ;                          Methods for Writing to TCP/IP Socket
"RTN","XWBRL",128,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRL",129,0)
PRE ; -- prepare socket for writing
"RTN","XWBRL",130,0)
 SET $X=0
"RTN","XWBRL",131,0)
 QUIT
"RTN","XWBRL",132,0)
 ;
"RTN","XWBRL",133,0)
 ;
"RTN","XWBRL",134,0)
WRITE(STR) ; -- write a data string to socket
"RTN","XWBRL",135,0)
 ; input:
"RTN","XWBRL",136,0)
 ;   STR = string to write
"RTN","XWBRL",137,0)
 ; throughput:
"RTN","XWBRL",138,0)
 ;   if tcp vars not set when WRITE is called, WRITE sets them
"RTN","XWBRL",139,0)
 ; output:
"RTN","XWBRL",140,0)
 ;   string is written to socket in packets of up to 255 characters
"RTN","XWBRL",141,0)
 ;   with buffer flushes in between
"RTN","XWBRL",142,0)
 ;
"RTN","XWBRL",143,0)
 ; -- initialize tcp processing variables
"RTN","XWBRL",144,0)
 I $G(XWBOS)="" D  ; if we have not already initialized,
"RTN","XWBRL",145,0)
 . D INIT^XWBTCPM ; set up locals and start log
"RTN","XWBRL",146,0)
 ;
"RTN","XWBRL",147,0)
 ; send data for DSM (requires buffer flush (!) every 511 chars)
"RTN","XWBRL",148,0)
 ; GT.M is the same as DSM.
"RTN","XWBRL",149,0)
 ; Use an arbitrary value of 255 as the Write limit.
"RTN","XWBRL",150,0)
 ;*p34-modified write to for Cache 5 in case less than 255 char.
"RTN","XWBRL",151,0)
 ;
"RTN","XWBRL",152,0)
 F  Q:'$L(STR)  D  ; continue until string fully written
"RTN","XWBRL",153,0)
 . W $E(STR,1,255) ; write next 255 characters
"RTN","XWBRL",154,0)
 . W @XWBT("BF") ; write buffer flush
"RTN","XWBRL",155,0)
 . S STR=$E(STR,256,99999) ; remove the written characters
"RTN","XWBRL",156,0)
 ;
"RTN","XWBRL",157,0)
 QUIT  ; end of WRITE
"RTN","XWBRL",158,0)
 ;
"RTN","XWBRL",159,0)
 ;
"RTN","XWBRL",160,0)
POST ; -- send eot and flush socket buffer
"RTN","XWBRL",161,0)
 ; input:
"RTN","XWBRL",162,0)
 ;   XWBT("BF") = buffer-flush control character for this implementation
"RTN","XWBRL",163,0)
 ; output:
"RTN","XWBRL",164,0)
 ;   EOT and buffer flush
"RTN","XWBRL",165,0)
 ;
"RTN","XWBRL",166,0)
 DO WRITE($C(4)) ; end-of-transmission
"RTN","XWBRL",167,0)
 I $X>0 W @XWBT("BF") ; write buffer flush
"RTN","XWBRL",168,0)
 ;
"RTN","XWBRL",169,0)
 QUIT  ; end of POST
"RTN","XWBRL",170,0)
 ;
"RTN","XWBRL",171,0)
 ;
"RTN","XWBRL",172,0)
EOR ; end of routine XWBRL
"RTN","XWBRM")
0^3^B10532495
"RTN","XWBRM",1,0)
XWBRM ;OIFO-Oakland/REM - M2M Broker Server Request Mgr ; 8/28/2013 10:41am
"RTN","XWBRM",2,0)
 ;;1.1;RPC BROKER;**28,45,991**;Mar 28, 1997;Build 9
"RTN","XWBRM",3,0)
 ;
"RTN","XWBRM",4,0)
 QUIT  ; routine XWBRM is not callable at the top
"RTN","XWBRM",5,0)
 ;
"RTN","XWBRM",6,0)
 ; Change History:
"RTN","XWBRM",7,0)
 ;
"RTN","XWBRM",8,0)
 ; 2002 08 10 OIFO/REM: XWB*1.1*28 SEQ #25, M2M Broker. Original routine
"RTN","XWBRM",9,0)
 ; created.
"RTN","XWBRM",10,0)
 ;
"RTN","XWBRM",11,0)
 ; 2004 04 27 OIFO/REM: XWB*1.1*45 SEQ #38, Broker Security Enhancement.
"RTN","XWBRM",12,0)
 ; Begin plugging hole caused by CAPRI. in EN.
"RTN","XWBRM",13,0)
 ;
"RTN","XWBRM",14,0)
 ; 2013 08 16-28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBRM",15,0)
 ; Log close and error events. Eliminate unused flag XWBM2M; lets new
"RTN","XWBRM",16,0)
 ; XWBM2M parameter occupy that name. Refactor EN. Eliminate unfinished
"RTN","XWBRM",17,0)
 ; & unused subroutines. Change History added.
"RTN","XWBRM",18,0)
 ; in XWBRM, EN, SECCHK, CHKTOKEN, CHKDUZ, SECERR, SECERRS, EOR.
"RTN","XWBRM",19,0)
 ;
"RTN","XWBRM",20,0)
 ;
"RTN","XWBRM",21,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRM",22,0)
 ;                             Server Request Manager (SRM)
"RTN","XWBRM",23,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRM",24,0)
 ;
"RTN","XWBRM",25,0)
EN(XWBROOT) ; -- main entry point for SRM
"RTN","XWBRM",26,0)
 ; input:
"RTN","XWBRM",27,0)
 ;   XWBROOT = name of array where raw message input is stored
"RTN","XWBRM",28,0)
 ; output:
"RTN","XWBRM",29,0)
 ;   return value = true (1) if it's okay to continue
"RTN","XWBRM",30,0)
 ;      false (0) if not
"RTN","XWBRM",31,0)
 ;      but the return value is ignored by NXTCALL^XWBVLL
"RTN","XWBRM",32,0)
 ;   XWBSTOP = true (1) if the main loop should stop after this
"RTN","XWBRM",33,0)
 ;      false (0) if it should continue processing XML messages
"RTN","XWBRM",34,0)
 ;
"RTN","XWBRM",35,0)
 ; -- parse the xml
"RTN","XWBRM",36,0)
 N XWBOPT S XWBOPT="" ; option flags for XML parse
"RTN","XWBRM",37,0)
 N XWBDATA ; return array for parsed XML message
"RTN","XWBRM",38,0)
 D EN^XWBRMX(XWBROOT,.XWBOPT,.XWBDATA) ; parse the message
"RTN","XWBRM",39,0)
 ;
"RTN","XWBRM",40,0)
 ; -- allow broker-security-enhancement visitor access from M2M^XUSBSE1
"RTN","XWBRM",41,0)
 I $G(XWBDATA("URI"))="XUS GET VISITOR" D  Q 1
"RTN","XWBRM",42,0)
 . D EN^XWBRPC(.XWBDATA) ; call the visitor RPC
"RTN","XWBRM",43,0)
 . I '$D(DUZ) S XWBSTOP=1 ; only continue loop if IDed user
"RTN","XWBRM",44,0)
 ;
"RTN","XWBRM",45,0)
 ; -- initialize for XUS SIGNON SETUP
"RTN","XWBRM",46,0)
 I $G(XWBDATA("MODE"))="RPCBroker",XWBDATA("URI")="XUS SIGNON SETUP" D
"RTN","XWBRM",47,0)
 . S XWBTDEV=""
"RTN","XWBRM",48,0)
 . S XWBTIP=""
"RTN","XWBRM",49,0)
 . S XWBVER="1.1" ; Broker version
"RTN","XWBRM",50,0)
 . S XWBSTOP=0 ; for signon setup, continue main loop afterward
"RTN","XWBRM",51,0)
 ;
"RTN","XWBRM",52,0)
 ; -- single call processing
"RTN","XWBRM",53,0)
 I $G(XWBDATA("MODE"),"single call")="single call" D
"RTN","XWBRM",54,0)
 . S XWBSTOP=1 ; for a single call, we will not continue the loop after
"RTN","XWBRM",55,0)
 ;
"RTN","XWBRM",56,0)
 ; -- check if app defined
"RTN","XWBRM",57,0)
 I $G(XWBDATA("APP"))="" D  Q 0
"RTN","XWBRM",58,0)
 . D RMERR(1) ; report missing app
"RTN","XWBRM",59,0)
 ;
"RTN","XWBRM",60,0)
 ; -- process close request
"RTN","XWBRM",61,0)
 I $G(XWBDATA("APP"))="CLOSE" D  Q 0
"RTN","XWBRM",62,0)
 . D:$G(DUZ) LOGOUT^XUSRB ; logout user and cleanup
"RTN","XWBRM",63,0)
 . D RESPONSE^XWBVL() ; send XML response
"RTN","XWBRM",64,0)
 . I $G(XWBDEBUG) D  ; if debugging is on
"RTN","XWBRM",65,0)
 . . D LOG^XWBDLOG("Close App") ; record close event
"RTN","XWBRM",66,0)
 . S XWBSTOP=1 ; end main loop
"RTN","XWBRM",67,0)
 ;
"RTN","XWBRM",68,0)
 ; -- screen out all non-RPC apps
"RTN","XWBRM",69,0)
 I $G(XWBDATA("APP"))'="RPC" Q 0
"RTN","XWBRM",70,0)
 ;
"RTN","XWBRM",71,0)
 ; -- call app to write to socket
"RTN","XWBRM",72,0)
 N XWBMODE S XWBMODE=$G(XWBDATA("MODE")) ; identify M-to-M Broker mode
"RTN","XWBRM",73,0)
 D EN^XWBRPC(.XWBDATA) ; call remote procedure & send reply to client
"RTN","XWBRM",74,0)
 ;
"RTN","XWBRM",75,0)
 QUIT 1 ; end of EN
"RTN","XWBRM",76,0)
 ;
"RTN","XWBRM",77,0)
 ;
"RTN","XWBRM",78,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRM",79,0)
 ;                 Request Manager and Security Error Handlers
"RTN","XWBRM",80,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRM",81,0)
 ;
"RTN","XWBRM",82,0)
RMERR(XWBCODE) ; -- send request error message
"RTN","XWBRM",83,0)
 NEW XWBDAT,XWBMSG
"RTN","XWBRM",84,0)
 SET XWBMSG=$P($TEXT(RMERRS+XWBCODE),";;",2)
"RTN","XWBRM",85,0)
 SET XWBDAT("MESSAGE TYPE")="Gov.VA.Med.Foundations.Errors"
"RTN","XWBRM",86,0)
 SET XWBDAT("ERRORS",1,"CODE")=1
"RTN","XWBRM",87,0)
 SET XWBDAT("ERRORS",1,"ERROR TYPE")="request manager"
"RTN","XWBRM",88,0)
 SET XWBDAT("ERRORS",1,"CDATA")=1
"RTN","XWBRM",89,0)
 SET XWBDAT("ERRORS",1,"MESSAGE",1)="An Request Manager error occurred: "_XWBMSG
"RTN","XWBRM",90,0)
 DO ERROR^XWBUTL(.XWBDAT)
"RTN","XWBRM",91,0)
 QUIT
"RTN","XWBRM",92,0)
 ;
"RTN","XWBRM",93,0)
RMERRS ; -- application errors
"RTN","XWBRM",94,0)
 ;;No valid application specified.
"RTN","XWBRM",95,0)
 ;
"RTN","XWBRM",96,0)
 ;
"RTN","XWBRM",97,0)
EOR ; end of routine XWBRM
"RTN","XWBRMX")
0^9^B6795392
"RTN","XWBRMX",1,0)
XWBRMX ;OIFO-Oakland/REM - M2M Broker Server Request Mgr ; 08/28/2013 10:41am
"RTN","XWBRMX",2,0)
 ;;1.1;RPC BROKER;**28,991**;Mar 28, 1997;Build 9
"RTN","XWBRMX",3,0)
 ;
"RTN","XWBRMX",4,0)
 QUIT  ; routine XWBRMX is not callable at the top
"RTN","XWBRMX",5,0)
 ;
"RTN","XWBRMX",6,0)
 ; Change History:
"RTN","XWBRMX",7,0)
 ;
"RTN","XWBRMX",8,0)
 ; 2002 08 10 OIFO/REM: XWB*1.1*28 SEQ #25, M2M Broker. Original routine
"RTN","XWBRMX",9,0)
 ; created.
"RTN","XWBRMX",10,0)
 ;
"RTN","XWBRMX",11,0)
 ; 2013 08 16-28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBRMX",12,0)
 ; Eliminate unused lines in ELEST that set DUZ and tokens (unfinished).
"RTN","XWBRMX",13,0)
 ; Change History added. in XWBRMX, ELEST, EOR.
"RTN","XWBRMX",14,0)
 ;
"RTN","XWBRMX",15,0)
 ;
"RTN","XWBRMX",16,0)
 ;----------------------------------------------------------------------
"RTN","XWBRMX",17,0)
 ;
"RTN","XWBRMX",18,0)
 ;    Request Manager -Parse XML Requests using SAX interface
"RTN","XWBRMX",19,0)
 ;
"RTN","XWBRMX",20,0)
 ;----------------------------------------------------------------------
"RTN","XWBRMX",21,0)
 ;
"RTN","XWBRMX",22,0)
EN(DOC,XWBOPT,XWBDATA) ; -- Parse XML uses SAX parser
"RTN","XWBRMX",23,0)
 N XWBCBK,XWBINVAL
"RTN","XWBRMX",24,0)
 SET XWBINVAL="#UNKNOWN#"
"RTN","XWBRMX",25,0)
 ;
"RTN","XWBRMX",26,0)
 SET XWBDATA("DUZ")=XWBINVAL ;**M2M don't need duz
"RTN","XWBRMX",27,0)
 SET XWBDATA("SECTOKEN")=XWBINVAL
"RTN","XWBRMX",28,0)
 DO SET(.XWBCBK)
"RTN","XWBRMX",29,0)
 DO EN^MXMLPRSE(DOC,.XWBCBK,.XWBOPT)
"RTN","XWBRMX",30,0)
 ;
"RTN","XWBRMX",31,0)
 ;;D ^%ZTER
"RTN","XWBRMX",32,0)
 ;
"RTN","XWBRMX",33,0)
ENQ Q
"RTN","XWBRMX",34,0)
 ;
"RTN","XWBRMX",35,0)
SET(CBK) ; -- set the event interface entry points
"RTN","XWBRMX",36,0)
 SET XWBCBK("STARTELEMENT")="ELEST^XWBRMX"
"RTN","XWBRMX",37,0)
 SET XWBCBK("ENDELEMENT")="ELEND^XWBRMX"
"RTN","XWBRMX",38,0)
 SET XWBCBK("CHARACTERS")="CHR^XWBRMX"
"RTN","XWBRMX",39,0)
 QUIT
"RTN","XWBRMX",40,0)
 ;
"RTN","XWBRMX",41,0)
ESC(X) ; -- convert special characters to \x format
"RTN","XWBRMX",42,0)
 Q X
"RTN","XWBRMX",43,0)
 ;
"RTN","XWBRMX",44,0)
 N C,Y,Z
"RTN","XWBRMX",45,0)
 F Z=1:1 S C=$E(X,Z) Q:C=""  D
"RTN","XWBRMX",46,0)
 .S Y=$TR(C,$C(9,10,13,92),"tnc")
"RTN","XWBRMX",47,0)
 .S:C'=Y $E(X,Z)="" ;$S(Y="":"\\",1:"\"_Y),Z=Z+1
"RTN","XWBRMX",48,0)
 Q X
"RTN","XWBRMX",49,0)
 ;
"RTN","XWBRMX",50,0)
ELEST(ELE,ATR) ; -- element start
"RTN","XWBRMX",51,0)
 IF ELE="vistalink",$G(ATR("type"))="Gov.VA.Med.RPC.Request" DO
"RTN","XWBRMX",52,0)
 . SET XWBDATA("APP")="RPC"
"RTN","XWBRMX",53,0)
 . ;SET XWBDATA("MODE")=$G(ATR("mode"),"singleton") ;Comment out for M2M
"RTN","XWBRMX",54,0)
 . SET XWBDATA("MODE")=$G(ATR("mode"),"RPCBroker") ;M2M change to RPCBroker
"RTN","XWBRMX",55,0)
 ;
"RTN","XWBRMX",56,0)
 IF ELE="vistalink",$G(ATR("type"))="Gov.VA.Med.Foundations.CloseSocketRequest" DO  QUIT
"RTN","XWBRMX",57,0)
 . SET XWBDATA("APP")="CLOSE"
"RTN","XWBRMX",58,0)
 . SET XWBDATA("MODE")=$G(ATR("mode"),"single call")
"RTN","XWBRMX",59,0)
 ;
"RTN","XWBRMX",60,0)
 IF ELE="session" SET XWBSESS=1 QUIT
"RTN","XWBRMX",61,0)
 ; -- set session vars here so apps can use during xml parsing
"RTN","XWBRMX",62,0)
 ;
"RTN","XWBRMX",63,0)
 ;*M2M - check for RPCBroker
"RTN","XWBRMX",64,0)
 IF $G(XWBSESS) DO  QUIT
"RTN","XWBRMX",65,0)
 . IF ELE="security" SET XWBSEC=1 QUIT
"RTN","XWBRMX",66,0)
 ;
"RTN","XWBRMX",67,0)
 ; -- // TODO: make dynamic off RPC app config
"RTN","XWBRMX",68,0)
 IF $GET(XWBDATA("APP"))="RPC" DO ELEST^XWBRPC(.ELE,.ATR)
"RTN","XWBRMX",69,0)
 Q
"RTN","XWBRMX",70,0)
 ;
"RTN","XWBRMX",71,0)
ELEND(ELE) ; -- element end
"RTN","XWBRMX",72,0)
 IF ELE="session" KILL XWBSESS QUIT
"RTN","XWBRMX",73,0)
 IF $G(XWBSESS) DO  QUIT
"RTN","XWBRMX",74,0)
 . IF ELE="security" KILL XWBSEC
"RTN","XWBRMX",75,0)
 ;
"RTN","XWBRMX",76,0)
 ;
"RTN","XWBRMX",77,0)
 ; -- // TODO: make dynamic off RPC app config
"RTN","XWBRMX",78,0)
 IF $G(XWBDATA("APP"))="RPC" DO ELEND^XWBRPC(.ELE)
"RTN","XWBRMX",79,0)
 Q
"RTN","XWBRMX",80,0)
 ;
"RTN","XWBRMX",81,0)
CHR(TXT) ;
"RTN","XWBRMX",82,0)
 ; -- // TODO:  make dynamic off RPC app config
"RTN","XWBRMX",83,0)
 IF $G(XWBDATA("APP"))="RPC" DO CHR^XWBRPC(.TXT)
"RTN","XWBRMX",84,0)
 Q
"RTN","XWBRMX",85,0)
 ;
"RTN","XWBRMX",86,0)
 ;
"RTN","XWBRMX",87,0)
EOR ; end of routine XWBRMX
"RTN","XWBRPC")
0^4^B180526853
"RTN","XWBRPC",1,0)
XWBRPC ;OIFO-Oakland/REM - M2M Broker Server MRH ; 8/28/2013 10:42am
"RTN","XWBRPC",2,0)
 ;;1.1;RPC BROKER;**28,34,991**;Mar 28, 1997;Build 9
"RTN","XWBRPC",3,0)
 ;
"RTN","XWBRPC",4,0)
 QUIT  ; routine XWBRPC is not callable at the top
"RTN","XWBRPC",5,0)
 ;
"RTN","XWBRPC",6,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRPC",7,0)
 ;                   RPC Server: Message Request Handler (MRH)
"RTN","XWBRPC",8,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRPC",9,0)
 ;
"RTN","XWBRPC",10,0)
 ; Change History:
"RTN","XWBRPC",11,0)
 ;
"RTN","XWBRPC",12,0)
 ; 2002 08 10 OIFO/REM: XWB*1.1*28 SEQ #25, M2M Broker. Original routine
"RTN","XWBRPC",13,0)
 ; created. 
"RTN","XWBRPC",14,0)
 ;
"RTN","XWBRPC",15,0)
 ; 2005 10 26 OIFO/REM: XWB*1.1*34 SEQ #33, M2M Bug Fixes. Added
"RTN","XWBRPC",16,0)
 ; $$CHARCHK^XWBUTL before writing to WRITE^XWBRL to escape CR. Removed
"RTN","XWBRPC",17,0)
 ; $C(13). CR were not being stripped out in result. in PROCESS.
"RTN","XWBRPC",18,0)
 ;
"RTN","XWBRPC",19,0)
 ; 2013 08 16-28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes. LOG
"RTN","XWBRPC",20,0)
 ; eliminated. Calls to LOG replaced with calls to LOG^XWBDLOG.
"RTN","XWBRPC",21,0)
 ; Overhauled ERROR to make it extensible and easier to call; reduced
"RTN","XWBRPC",22,0)
 ; from three parameters to two. Added ERRORS to calculate error
"RTN","XWBRPC",23,0)
 ; messages from codes. Simplified calls to ERROR to eliminating
"RTN","XWBRPC",24,0)
 ; old third parameter (error message). Refactored EN and added call
"RTN","XWBRPC",25,0)
 ; to CHKPRMIT. Added CHKPRMIT based on subroutine in XWBSEC. Move
"RTN","XWBRPC",26,0)
 ; ERROR and ERRORS right after EN. Shift most "free" RPCs into a new
"RTN","XWBRPC",27,0)
 ; list of RPCs that are free but require signon first. Add a special
"RTN","XWBRPC",28,0)
 ; category for XUS GET VISITOR - free but must *not* have signed on
"RTN","XWBRPC",29,0)
 ; yet. Annotated. Change History added.
"RTN","XWBRPC",30,0)
 ; in XWBRPC, EN, ERROR, ERRORS, CHKPRMIT, FREERPCS, FALWAYS, FBEFORE,
"RTN","XWBRPC",31,0)
 ; FBROKER, FSIGNON, FVISTAL, EOR.
"RTN","XWBRPC",32,0)
 ;
"RTN","XWBRPC",33,0)
 ; TO DO
"RTN","XWBRPC",34,0)
 ;
"RTN","XWBRPC",35,0)
 ; In a future Kernel patch, add XUS GET VISITOR to the XUS SIGNON
"RTN","XWBRPC",36,0)
 ; broker-context option, so its special handling can be removed from
"RTN","XWBRPC",37,0)
 ; CHKPRMIT, and so BEFORE can be deleted.
"RTN","XWBRPC",38,0)
 ;
"RTN","XWBRPC",39,0)
 ;
"RTN","XWBRPC",40,0)
EN(XWBDATA) ; -- handle parsed messages request (check & run RPC)
"RTN","XWBRPC",41,0)
 ; input:
"RTN","XWBRPC",42,0)
 ;   XWBDATA = parsed XML message
"RTN","XWBRPC",43,0)
 ; output:
"RTN","XWBRPC",44,0)
 ;   log & transmit successful RPC results
"RTN","XWBRPC",45,0)
 ;   or log & transmit error condition
"RTN","XWBRPC",46,0)
 ;
"RTN","XWBRPC",47,0)
 ; to do: build/call common broker api for RPC lookup. See XWBBRK.
"RTN","XWBRPC",48,0)
 ;
"RTN","XWBRPC",49,0)
 S U="^" ; I'm skeptical that this line is needed
"RTN","XWBRPC",50,0)
 ;
"RTN","XWBRPC",51,0)
 ; 1. check remote procedure name
"RTN","XWBRPC",52,0)
 ;
"RTN","XWBRPC",53,0)
 N RPCURI S RPCURI=$G(XWBDATA("URI")) ; get RPC name
"RTN","XWBRPC",54,0)
 I RPCURI="" D  Q  ; missing RPC name
"RTN","XWBRPC",55,0)
 . D ERROR(1,"NONE") ; No Remote Procedure Specified
"RTN","XWBRPC",56,0)
 ;
"RTN","XWBRPC",57,0)
 ; 2. find remote procedure
"RTN","XWBRPC",58,0)
 ;
"RTN","XWBRPC",59,0)
 N RPCIEN S RPCIEN=$O(^XWB(8994,"B",RPCURI,"")) ; index on Name (.01)
"RTN","XWBRPC",60,0)
 I RPCIEN'>0 D  Q  ; if name is not in Name index
"RTN","XWBRPC",61,0)
 . D ERROR(2,RPCURI) ; Remote Procedure Unknown
"RTN","XWBRPC",62,0)
 . D ERROR^XWBM2MC(7) ;Write error in TMP **M2M
"RTN","XWBRPC",63,0)
 ;
"RTN","XWBRPC",64,0)
 ; 3. check remote procedure record
"RTN","XWBRPC",65,0)
 ;
"RTN","XWBRPC",66,0)
 N RPC0 S RPC0=$G(^XWB(8994,RPCIEN,0)) ; Remote Procedure (8994) header
"RTN","XWBRPC",67,0)
 I RPC0="" D  Q  ; if header node is empty
"RTN","XWBRPC",68,0)
 . D ERROR(3,RPCURI) ; Remote Procedure Blank
"RTN","XWBRPC",69,0)
 ;
"RTN","XWBRPC",70,0)
 ; 4. get essential remote procedure fields
"RTN","XWBRPC",71,0)
 ;
"RTN","XWBRPC",72,0)
 S RPCURI=$P(RPC0,U) ; Name (.01) fld
"RTN","XWBRPC",73,0)
 N TAG S TAG=$P(RPC0,U,2) ; Tag (.02) fld
"RTN","XWBRPC",74,0)
 N ROU S ROU=$P(RPC0,U,3) ; Routine (.03) fld
"RTN","XWBRPC",75,0)
 S XWBPTYPE=$P(RPC0,U,4) ; Return Value Type (.04) fld
"RTN","XWBRPC",76,0)
 N RPCINACT S RPCINACT=$P(RPC0,U,6) ; Inactive (.06) fld
"RTN","XWBRPC",77,0)
 S XWBWRAP=$P(RPC0,U,8) ; Word Wrap On (.08) fld
"RTN","XWBRPC",78,0)
 ;
"RTN","XWBRPC",79,0)
 ; 5. ensure remote procedure is active
"RTN","XWBRPC",80,0)
 ;
"RTN","XWBRPC",81,0)
 ; 1 = Inactive, 2 = Local Inactive (Active Remotely)
"RTN","XWBRPC",82,0)
 I RPCINACT=1!(RPCINACT=2) D  Q  ; if inactive
"RTN","XWBRPC",83,0)
 . D ERROR(4,RPCURI) ; Remote Procedure Inactive
"RTN","XWBRPC",84,0)
 ;
"RTN","XWBRPC",85,0)
 ; 6. check whether user has permission to run this remote procedure
"RTN","XWBRPC",86,0)
 ;
"RTN","XWBRPC",87,0)
 N XWBNOPE S XWBNOPE=$$CHKPRMIT(RPCURI) ; check permissions
"RTN","XWBRPC",88,0)
 I XWBNOPE'="" D  Q  ; if no permission
"RTN","XWBRPC",89,0)
 . D ERROR(XWBNOPE,RPCURI) ; log & transmit error
"RTN","XWBRPC",90,0)
 K XWBNOPE ; otherwise, we have permission, so clear the local
"RTN","XWBRPC",91,0)
 ;
"RTN","XWBRPC",92,0)
 ; 7. build & log method signature
"RTN","XWBRPC",93,0)
 ;
"RTN","XWBRPC",94,0)
 N METHSIG S METHSIG=TAG_"^"_ROU_"(.XWBR"_$G(XWBDATA("PARAMS"))_")"
"RTN","XWBRPC",95,0)
 I $G(XWBDEBUG)>1 D  ; if debug=2 or 3, "verbose" or "very verbose"
"RTN","XWBRPC",96,0)
 . D LOG^XWBDLOG("Method Signature = "_METHSIG)
"RTN","XWBRPC",97,0)
 ;
"RTN","XWBRPC",98,0)
 ; 8. run method (remote procedure)
"RTN","XWBRPC",99,0)
 ;
"RTN","XWBRPC",100,0)
 ; note: See that the NULL device is current
"RTN","XWBRPC",101,0)
 N XWBR ; results from remote procedure
"RTN","XWBRPC",102,0)
 D @METHSIG ; call RPC
"RTN","XWBRPC",103,0)
 ;
"RTN","XWBRPC",104,0)
 ; 9. log results
"RTN","XWBRPC",105,0)
 ;
"RTN","XWBRPC",106,0)
 I $G(XWBDEBUG)>2 D  ; if debug=3, "very verbose"
"RTN","XWBRPC",107,0)
 . D LOG^XWBDLOG("Response Sent","XWBR")
"RTN","XWBRPC",108,0)
 ;
"RTN","XWBRPC",109,0)
 ; 10. transmit results to client via socket
"RTN","XWBRPC",110,0)
 ;
"RTN","XWBRPC",111,0)
 D USE^%ZISUTL("XWBM2M SERVER") ; use socket
"RTN","XWBRPC",112,0)
 U IO ;**M2M use server IO ; I'm unclear why USE^%ZISUTL isn't enough
"RTN","XWBRPC",113,0)
 D SEND(.XWBR) ; transmit results
"RTN","XWBRPC",114,0)
 ;
"RTN","XWBRPC",115,0)
 ; 11. clean up after remote procedure
"RTN","XWBRPC",116,0)
 ;
"RTN","XWBRPC",117,0)
 D CLEAN ; clear parameters (why nothing else?)
"RTN","XWBRPC",118,0)
 ;
"RTN","XWBRPC",119,0)
 QUIT  ; end of EN
"RTN","XWBRPC",120,0)
 ;
"RTN","XWBRPC",121,0)
 ;
"RTN","XWBRPC",122,0)
ERROR(ERROR,RPCURI) ; -- send rpc application error
"RTN","XWBRPC",123,0)
 ; input:
"RTN","XWBRPC",124,0)
 ;   ERROR = error, either numeric code or text message.
"RTN","XWBRPC",125,0)
 ;      See ERRORS below for values & meanings.
"RTN","XWBRPC",126,0)
 ;   RPCURI = name (URI) of remote procedure
"RTN","XWBRPC",127,0)
 ;      if the code is for an error message that includes the RPC name
"RTN","XWBRPC",128,0)
 ;      then RPCURI is required; otherwise it's optional
"RTN","XWBRPC",129,0)
 ; output:
"RTN","XWBRPC",130,0)
 ;   XML error message is transmitted to the client via the socket
"RTN","XWBRPC",131,0)
 ;   error is logged if debugging is on
"RTN","XWBRPC",132,0)
 ;
"RTN","XWBRPC",133,0)
 ; -- build error message from code
"RTN","XWBRPC",134,0)
 ;
"RTN","XWBRPC",135,0)
 N CODE,MSG
"RTN","XWBRPC",136,0)
 I ERROR D  ; if ERROR is a numeric code, calculate the message
"RTN","XWBRPC",137,0)
 . S CODE=ERROR ; since there's a numeric code, save it
"RTN","XWBRPC",138,0)
 . N MSGREC S MSGREC=$T(ERRORS+ERROR)
"RTN","XWBRPC",139,0)
 . S MSG=$P(MSGREC,";",4) ; first part of error message
"RTN","XWBRPC",140,0)
 . N MSGP2 S MSGP2=$P(MSGREC,";",5) ; second part of error message
"RTN","XWBRPC",141,0)
 . Q:MSGP2=""  ; if no second part, we're done building error message
"RTN","XWBRPC",142,0)
 . S MSG=MSG_RPCURI_MSGP2 ; otherwise, build the rest of the message
"RTN","XWBRPC",143,0)
 E  D  ; if it's a string, then it is the message
"RTN","XWBRPC",144,0)
 . S CODE=0 ; since there's no code, create a placeholder
"RTN","XWBRPC",145,0)
 . S MSG=ERROR
"RTN","XWBRPC",146,0)
 ;
"RTN","XWBRPC",147,0)
 ; -- log error if debugging is on
"RTN","XWBRPC",148,0)
 ;
"RTN","XWBRPC",149,0)
 I $G(XWBDEBUG) D  ; log read error if debugging is on
"RTN","XWBRPC",150,0)
 . N XWBENAME ; name of error
"RTN","XWBRPC",151,0)
 . I XWBDEBUG=1 D  ; if debug=1, "on"
"RTN","XWBRPC",152,0)
 . . S XWBENAME="Error"
"RTN","XWBRPC",153,0)
 . E  D  ; if debug=2 or 3, "verbose" or "very verbose"
"RTN","XWBRPC",154,0)
 . . S XWBENAME="Error: "_MSG
"RTN","XWBRPC",155,0)
 . D LOG^XWBDLOG(XWBENAME) ; log the error
"RTN","XWBRPC",156,0)
 ;
"RTN","XWBRPC",157,0)
 ; -- build & transmit error message to client
"RTN","XWBRPC",158,0)
 ;
"RTN","XWBRPC",159,0)
 D PRE^XWBRL
"RTN","XWBRPC",160,0)
 D WRITE^XWBRL($$XMLHDR^XWBUTL())
"RTN","XWBRPC",161,0)
 D WRITE^XWBRL("<vistalink type=""VA.RPC.Error"" >")
"RTN","XWBRPC",162,0)
 D WRITE^XWBRL("<errors>")
"RTN","XWBRPC",163,0)
 D WRITE^XWBRL("<error code="""_CODE_""" uri="""_$G(RPCURI)_""" >")
"RTN","XWBRPC",164,0)
 D WRITE^XWBRL("<msg>"_$G(MSG)_"</msg>")
"RTN","XWBRPC",165,0)
 D WRITE^XWBRL("</error>")
"RTN","XWBRPC",166,0)
 D WRITE^XWBRL("</errors>")
"RTN","XWBRPC",167,0)
 D WRITE^XWBRL("</vistalink>")
"RTN","XWBRPC",168,0)
 D POST^XWBRL ; send eot and flush buffer
"RTN","XWBRPC",169,0)
 ;
"RTN","XWBRPC",170,0)
 ; -- clean up message handler environment
"RTN","XWBRPC",171,0)
 ;
"RTN","XWBRPC",172,0)
 D CLEAN
"RTN","XWBRPC",173,0)
 ;
"RTN","XWBRPC",174,0)
 QUIT  ; end of ERROR
"RTN","XWBRPC",175,0)
 ;
"RTN","XWBRPC",176,0)
 ;
"RTN","XWBRPC",177,0)
ERRORS ; error messages for each error code (1-5 picked by code)
"RTN","XWBRPC",178,0)
 ;;1;No Remote Procedure Specified.
"RTN","XWBRPC",179,0)
 ;;2;Remote Procedure Unknown: ';' cannot be found.
"RTN","XWBRPC",180,0)
 ;;3;Remote Procedure Blank: ';' contains no information.
"RTN","XWBRPC",181,0)
 ;;4;Remote Procedure Inactive: ';' cannot be run at this time.
"RTN","XWBRPC",182,0)
 ;;5;Application context has not been created.
"RTN","XWBRPC",183,0)
 ;;6;No such option in the "B" cross reference of the Option File.
"RTN","XWBRPC",184,0)
 ;;7;No such option in the Option File.
"RTN","XWBRPC",185,0)
 ;;8;This option is not a Client/Server-type option.
"RTN","XWBRPC",186,0)
 ;;9;Option out of order with message: |msg|.
"RTN","XWBRPC",187,0)
 ;;10;Option locked, |user| does not hold the key.
"RTN","XWBRPC",188,0)
 ;;11;Reverse lock, |user| holds the key.
"RTN","XWBRPC",189,0)
 ;;12;This option is time restricted.
"RTN","XWBRPC",190,0)
 ;;13;User |user| does not have access to option |option|
"RTN","XWBRPC",191,0)
 ;;14;No RPC subfile defined for the option |option|.
"RTN","XWBRPC",192,0)
 ;;15;No remote procedure calls registered for the option |option|.
"RTN","XWBRPC",193,0)
 ;;16;No RPC by that name in the "B" cross-reference of the Remote Procedure File.
"RTN","XWBRPC",194,0)
 ;;17;No such procedure in the Remote Procedure File.
"RTN","XWBRPC",195,0)
 ;;18;The remote procedure |rpc| is not registered to the option |option|.
"RTN","XWBRPC",196,0)
 ;;19;Remote procedure is locked.
"RTN","XWBRPC",197,0)
 ;;20;Remote procedure request failed rules test.
"RTN","XWBRPC",198,0)
 ;;21;Your menus are being rebuilt.  Please try again later.
"RTN","XWBRPC",199,0)
 ;
"RTN","XWBRPC",200,0)
 ;
"RTN","XWBRPC",201,0)
CLEAN ; -- clean up message handler environment
"RTN","XWBRPC",202,0)
 NEW POS
"RTN","XWBRPC",203,0)
 ; -- kill parameters
"RTN","XWBRPC",204,0)
 SET POS=0
"RTN","XWBRPC",205,0)
 FOR  S POS=$O(XWBDATA("PARAMS",POS)) Q:'POS  K @XWBDATA("PARAMS",POS)
"RTN","XWBRPC",206,0)
 Q
"RTN","XWBRPC",207,0)
 ;
"RTN","XWBRPC",208,0)
 ;
"RTN","XWBRPC",209,0)
CHKPRMIT(XWBRP) ; check whether remote procedure may be run
"RTN","XWBRPC",210,0)
 ; input:
"RTN","XWBRPC",211,0)
 ;   XWBRP = remote procedure to check
"RTN","XWBRPC",212,0)
 ; output = "" if user has permission, error code if not
"RTN","XWBRPC",213,0)
 ;
"RTN","XWBRPC",214,0)
 ; 1. default to allowing RPC to be run (no error code)
"RTN","XWBRPC",215,0)
 ;
"RTN","XWBRPC",216,0)
 ; 2. if we've identified the user and it's a programmer, run anything
"RTN","XWBRPC",217,0)
 ;
"RTN","XWBRPC",218,0)
 I $$KCHK^XUSRB("XUPROGMODE") Q "" ; user holds the XUPROGMODE key?
"RTN","XWBRPC",219,0)
 ;
"RTN","XWBRPC",220,0)
 ; 3. until user is identified, require signon context
"RTN","XWBRPC",221,0)
 ;
"RTN","XWBRPC",222,0)
 I '$G(DUZ) D  ; if we don't have a user
"RTN","XWBRPC",223,0)
 . S DUZ=0 ; set to no user
"RTN","XWBRPC",224,0)
 . S XQY0="XUS SIGNON" ; set to signon context
"RTN","XWBRPC",225,0)
 ;
"RTN","XWBRPC",226,0)
 ; 4. allow free RPCs, which can be called from any context
"RTN","XWBRPC",227,0)
 ;
"RTN","XWBRPC",228,0)
 N FREE S FREE=1 ; default to free
"RTN","XWBRPC",229,0)
 D
"RTN","XWBRPC",230,0)
 . N FIND S FIND=U_XWBRP_U ; encapsulated RPC name
"RTN","XWBRPC",231,0)
 . I $P($T(FALWAYS),";;",2,999)[FIND D  Q  ; RPCs that are always free
"RTN","XWBRPC",232,0)
 . I $P($T(FBEFORE),";;",2,999)[FIND D  Q  ; RPCs free before signon
"RTN","XWBRPC",233,0)
 . . I DUZ S FREE=0 ; not free after signon
"RTN","XWBRPC",234,0)
 . I 'DUZ S FREE=0 Q  ; remaining free RPCs are not free before signon
"RTN","XWBRPC",235,0)
 . Q:$P($T(FBROKER),";;",2,999)[FIND  ; free broker RPCs
"RTN","XWBRPC",236,0)
 . Q:$P($T(FSIGNON),";;",2,999)[FIND  ; free signon RPCs
"RTN","XWBRPC",237,0)
 . Q:$P($T(FVISTAL),";;",2,999)[FIND  ; free vistalink RPCs
"RTN","XWBRPC",238,0)
 . S FREE=0 ; all other RPCs require security checks
"RTN","XWBRPC",239,0)
 I FREE Q "" ; everyone has permission to run free RPCs
"RTN","XWBRPC",240,0)
 ;
"RTN","XWBRPC",241,0)
 ; 5. in signon context, only allow XUS and XWB remote procedures
"RTN","XWBRPC",242,0)
 ;
"RTN","XWBRPC",243,0)
 I $G(XQY0)="" Q 5
"RTN","XWBRPC",244,0)
 I XQY0="XUS SIGNON","^XUS^XWB^"'[(U_$E(XWBRP,1,3)_U) Q 5
"RTN","XWBRPC",245,0)
 ; 5 = Application context has not been created.
"RTN","XWBRPC",246,0)
 ;
"RTN","XWBRPC",247,0)
 ; 6. otherwise, screen remote procedure by context and user
"RTN","XWBRPC",248,0)
 ;
"RTN","XWBRPC",249,0)
 ; note: XQCS allows all users access to the XUS SIGNON context.
"RTN","XWBRPC",250,0)
 ; Also to any context in the XUCOMMAND menu.
"RTN","XWBRPC",251,0)
 ;
"RTN","XWBRPC",252,0)
 N XWBALLOW S XWBALLOW=$$CHK^XQCS(DUZ,$P(XQY0,U),XWBRP) ; do the check
"RTN","XWBRPC",253,0)
 I XWBALLOW Q "" ; if access is allowed
"RTN","XWBRPC",254,0)
 ;
"RTN","XWBRPC",255,0)
 QUIT XWBALLOW ; end of CHKPRMIT ; if not allowed, return error message
"RTN","XWBRPC",256,0)
 ;
"RTN","XWBRPC",257,0)
 ;
"RTN","XWBRPC",258,0)
FREERPCS ; list of RPCs always allowed
"RTN","XWBRPC",259,0)
 ;
"RTN","XWBRPC",260,0)
FALWAYS ;;^XWB IM HERE^XUS KAAJEE LOGOUT^
"RTN","XWBRPC",261,0)
FBEFORE ;;^XUS GET VISITOR^
"RTN","XWBRPC",262,0)
FBROKER ;;^XWB CREATE CONTEXT^XWB RPC LIST^XWB IS RPC AVAILABLE^
"RTN","XWBRPC",263,0)
FSIGNON ;;^XUS GET USER INFO^XUS GET TOKEN^XUS SET VISITOR^
"RTN","XWBRPC",264,0)
FVISTAL ;;^XUS KAAJEE GET USER INFO^
"RTN","XWBRPC",265,0)
 ;
"RTN","XWBRPC",266,0)
 ;
"RTN","XWBRPC",267,0)
SEND(XWBR) ; -- stream rpc data to client
"RTN","XWBRPC",268,0)
 NEW XWBFMT,XWBFILL
"RTN","XWBRPC",269,0)
 SET XWBFMT=$$GETFMT()
"RTN","XWBRPC",270,0)
 ; -- prepare socket for writing
"RTN","XWBRPC",271,0)
 DO PRE^XWBRL
"RTN","XWBRPC",272,0)
 ; -- initialize
"RTN","XWBRPC",273,0)
 DO WRITE^XWBRL($$XMLHDR^XWBUTL())
"RTN","XWBRPC",274,0)
 ;DO DOCTYPE
"RTN","XWBRPC",275,0)
 DO WRITE^XWBRL("<vistalink type=""Gov.VA.Med.RPC.Response"" ><results type="""_XWBFMT_""" ><![CDATA[")
"RTN","XWBRPC",276,0)
 ; -- results
"RTN","XWBRPC",277,0)
 DO PROCESS
"RTN","XWBRPC",278,0)
 ; -- finalize
"RTN","XWBRPC",279,0)
 DO WRITE^XWBRL("]]></results></vistalink>")
"RTN","XWBRPC",280,0)
 ; -- send eot and flush buffer
"RTN","XWBRPC",281,0)
 DO POST^XWBRL
"RTN","XWBRPC",282,0)
 ;
"RTN","XWBRPC",283,0)
 QUIT
"RTN","XWBRPC",284,0)
 ;
"RTN","XWBRPC",285,0)
DOCTYPE ;
"RTN","XWBRPC",286,0)
 DO WRITE^XWBRL("<!DOCTYPE vistalink [<!ELEMENT vistalink (results) ><!ELEMENT results (#PCDATA)><!ATTLIST vistalink type CDATA ""Gov.VA.Med.RPC.Response"" ><!ATTLIST results type (array|string) >]>")
"RTN","XWBRPC",287,0)
 QUIT
"RTN","XWBRPC",288,0)
 ;
"RTN","XWBRPC",289,0)
GETFMT() ; -- determine response format type
"RTN","XWBRPC",290,0)
 IF XWBPTYPE=1!(XWBPTYPE=5)!(XWBPTYPE=6) QUIT "string"
"RTN","XWBRPC",291,0)
 IF XWBPTYPE=2 QUIT "array"
"RTN","XWBRPC",292,0)
 ;
"RTN","XWBRPC",293,0)
 QUIT $S(XWBWRAP:"array",1:"string")
"RTN","XWBRPC",294,0)
 ;
"RTN","XWBRPC",295,0)
PROCESS ; -- send the real results
"RTN","XWBRPC",296,0)
 NEW I,T,DEL,V
"RTN","XWBRPC",297,0)
 ;
"RTN","XWBRPC",298,0)
 ;*p34-Remove $C(13). CR were not being stripped out in results to escape CR.
"RTN","XWBRPC",299,0)
 ;S DEL=$S(XWBMODE="RPCBroker":$C(13,10),1:$C(10))
"RTN","XWBRPC",300,0)
 S DEL=$S(XWBMODE="RPCBroker":$C(10),1:$C(10))
"RTN","XWBRPC",301,0)
 ;
"RTN","XWBRPC",302,0)
 ;*p34-When write XWBR, go thru $$CHARCHK^XWBUTL first.
"RTN","XWBRPC",303,0)
 ; -- single value
"RTN","XWBRPC",304,0)
 IF XWBPTYPE=1 SET XWBR=$G(XWBR) DO WRITE^XWBRL($$CHARCHK^XWBUTL($G(XWBR))) QUIT
"RTN","XWBRPC",305,0)
 ; -- table delimited by CR+LF - ARRAY
"RTN","XWBRPC",306,0)
 IF XWBPTYPE=2 DO  QUIT
"RTN","XWBRPC",307,0)
 . SET I="" FOR  SET I=$O(XWBR(I)) QUIT:I=""  DO WRITE^XWBRL($$CHARCHK^XWBUTL($G(XWBR(I)))),WRITE^XWBRL(DEL)
"RTN","XWBRPC",308,0)
 ; -- word processing
"RTN","XWBRPC",309,0)
 IF XWBPTYPE=3 DO  QUIT
"RTN","XWBRPC",310,0)
 . SET I="" FOR  SET I=$O(XWBR(I)) QUIT:I=""  DO WRITE^XWBRL($$CHARCHK^XWBUTL($G(XWBR(I)))) DO:XWBWRAP WRITE^XWBRL(DEL)
"RTN","XWBRPC",311,0)
 ; -- global array
"RTN","XWBRPC",312,0)
 IF XWBPTYPE=4 DO  QUIT
"RTN","XWBRPC",313,0)
 . SET I=$G(XWBR) QUIT:I=""  SET T=$E(I,1,$L(I)-1)
"RTN","XWBRPC",314,0)
 . I $D(@I)>10 S V=@I D WRITE^XWBRL($$CHARCHK^XWBUTL($G(V)))
"RTN","XWBRPC",315,0)
 . FOR  SET I=$Q(@I) QUIT:I=""!(I'[T)  S V=@I D WRITE^XWBRL($$CHARCHK^XWBUTL($G(V))) D:XWBWRAP&(V'=DEL) WRITE^XWBRL(DEL)
"RTN","XWBRPC",316,0)
 . IF $D(@XWBR) KILL @XWBR
"RTN","XWBRPC",317,0)
 ; -- global instance
"RTN","XWBRPC",318,0)
 IF XWBPTYPE=5 S XWBR=$G(@XWBR) D WRITE^XWBRL($$CHARCHK^XWBUTL($G(XWBR))) QUIT
"RTN","XWBRPC",319,0)
 ; -- variable length records only good up to 255 char)
"RTN","XWBRPC",320,0)
 IF XWBPTYPE=6 SET I="" FOR  SET I=$O(XWBR(I)) QUIT:I=""  DO WRITE^XWBRL($C($L(XWBR(I)))),WRITE^XWBRL(XWBR(I))
"RTN","XWBRPC",321,0)
 QUIT
"RTN","XWBRPC",322,0)
 ;
"RTN","XWBRPC",323,0)
 ;
"RTN","XWBRPC",324,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRPC",325,0)
 ;             RPC Server: Request Message XML SAX Parser Callbacks
"RTN","XWBRPC",326,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRPC",327,0)
ELEST(ELE,ATR) ; -- element start event handler
"RTN","XWBRPC",328,0)
 IF ELE="vistalink" KILL XWBSESS,XWBPARAM,XWBPN,XWBPTYPE QUIT
"RTN","XWBRPC",329,0)
 ;
"RTN","XWBRPC",330,0)
 IF ELE="rpc" SET XWBDATA("URI")=$$ESC^XWBRMX($G(ATR("uri"),"##Unkown RPC##")) QUIT
"RTN","XWBRPC",331,0)
 ;
"RTN","XWBRPC",332,0)
 IF ELE="param" DO  QUIT
"RTN","XWBRPC",333,0)
 . SET XWBPARAM=1
"RTN","XWBRPC",334,0)
 . SET XWBPN="XWBP"_ATR("position")
"RTN","XWBRPC",335,0)
 . SET XWBDATA("PARAMS",ATR("position"))=XWBPN
"RTN","XWBRPC",336,0)
 . SET XWBPTYPE=ATR("type")
"RTN","XWBRPC",337,0)
 . S XWBCHRST="" ;To accumulate char
"RTN","XWBRPC",338,0)
 ;
"RTN","XWBRPC",339,0)
 IF ELE="index" DO  QUIT
"RTN","XWBRPC",340,0)
 . ;SET @XWBPN@($$ESC^XWBRMX(ATR("name")))=$$ESC^XWBRMX(ATR("value"))
"RTN","XWBRPC",341,0)
 . S XWBPN("name")=$$ESC^XWBRMX(ATR("name")) ;rwf
"RTN","XWBRPC",342,0)
 . S XWBCHRST=""
"RTN","XWBRPC",343,0)
 ;
"RTN","XWBRPC",344,0)
 QUIT
"RTN","XWBRPC",345,0)
 ;
"RTN","XWBRPC",346,0)
ELEND(ELE) ; -- element end event handler
"RTN","XWBRPC",347,0)
 IF ELE="vistalink" KILL XWBPOS,XWBSESS,XWBPARAM,XWBPN,XWBPTYPE,XWBCHRST QUIT
"RTN","XWBRPC",348,0)
 ;
"RTN","XWBRPC",349,0)
 IF ELE="params" DO  QUIT
"RTN","XWBRPC",350,0)
 . NEW POS,PARAMS
"RTN","XWBRPC",351,0)
 . SET PARAMS="",POS=0
"RTN","XWBRPC",352,0)
 . FOR  SET POS=$O(XWBDATA("PARAMS",POS)) Q:'POS  SET PARAMS=PARAMS_",."_XWBDATA("PARAMS",POS)
"RTN","XWBRPC",353,0)
 . SET XWBDATA("PARAMS")=PARAMS
"RTN","XWBRPC",354,0)
 ;
"RTN","XWBRPC",355,0)
 IF ELE="param" D  Q
"RTN","XWBRPC",356,0)
 . I $G(XWBDEBUG)>2,$D(XWBPN),$D(@XWBPN) D  ; if debug=3, "very verbose"
"RTN","XWBRPC",357,0)
 . . D LOG^XWBDLOG("Param: "_XWBPN,$NA(@XWBPN))
"RTN","XWBRPC",358,0)
 . KILL XWBPARAM,XWBCHRST
"RTN","XWBRPC",359,0)
 ;
"RTN","XWBRPC",360,0)
 QUIT
"RTN","XWBRPC",361,0)
 ;
"RTN","XWBRPC",362,0)
 ;This can be called more than once for one TEXT string.
"RTN","XWBRPC",363,0)
CHR(TEXT) ; -- character value event handler <tag>TEXT</tag)
"RTN","XWBRPC",364,0)
 ;
"RTN","XWBRPC",365,0)
 IF $G(XWBPARAM) DO
"RTN","XWBRPC",366,0)
 . ;What to do if string gets too long?
"RTN","XWBRPC",367,0)
 . ;IF XWBPTYPE="string" SET XWBCHRST=XWBCHRST_$$ESC^XWBRMX(TEXT),@XWBPN=XWBCHRST QUIT
"RTN","XWBRPC",368,0)
 . IF XWBPTYPE="string" SET XWBCHRST=XWBCHRST_TEXT,@XWBPN=XWBCHRST  QUIT
"RTN","XWBRPC",369,0)
 . ;IF XWBPTYPE="ref" SET @XWBPN=$G(@$$ESC^XWBRMX(TEXT)) QUIT
"RTN","XWBRPC",370,0)
 . IF XWBPTYPE="ref" SET XWBCHRST=XWBCHRST_TEXT,@XWBPN=@XWBCHRST QUIT
"RTN","XWBRPC",371,0)
 . I XWBPTYPE="array" S XWBCHRST=XWBCHRST_TEXT,@XWBPN@(XWBPN("name"))=XWBCHRST Q  ;rwf
"RTN","XWBRPC",372,0)
 QUIT
"RTN","XWBRPC",373,0)
 ;
"RTN","XWBRPC",374,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRPC",375,0)
 ;            Parse Results of Successful Legacy RPC Request
"RTN","XWBRPC",376,0)
 ; ---------------------------------------------------------------------
"RTN","XWBRPC",377,0)
 ;
"RTN","XWBRPC",378,0)
 ; [Public/Supported Method]
"RTN","XWBRPC",379,0)
PARSE(XWBPARMS,XWBY) ; -- parse legacy rpc results ; uses SAX parser
"RTN","XWBRPC",380,0)
 NEW XWBCHK,XWBOPT,XWBTYPE,XWBCNT
"RTN","XWBRPC",381,0)
 ;
"RTN","XWBRPC",382,0)
 ;**M2M Result will go here.
"RTN","XWBRPC",383,0)
 I XWBY="" D
"RTN","XWBRPC",384,0)
 .IF $G(XWBY)="" SET XWBY=$NA(^TMP("XWBM2MRPC",$J,"RESULTS"))
"RTN","XWBRPC",385,0)
 .SET XWBYX=XWBY
"RTN","XWBRPC",386,0)
 .KILL @XWBYX
"RTN","XWBRPC",387,0)
 ;
"RTN","XWBRPC",388,0)
 DO SET
"RTN","XWBRPC",389,0)
 SET XWBOPT=""
"RTN","XWBRPC",390,0)
 DO EN^MXMLPRSE(XWBPARMS("RESULTS"),.XWBCBK,.XWBOPT)
"RTN","XWBRPC",391,0)
 Q
"RTN","XWBRPC",392,0)
 ;
"RTN","XWBRPC",393,0)
SET ; -- set the event interface entry points ;
"RTN","XWBRPC",394,0)
 SET XWBCBK("STARTELEMENT")="RESELEST^XWBRPC"
"RTN","XWBRPC",395,0)
 SET XWBCBK("ENDELEMENT")="RESELEND^XWBRPC"
"RTN","XWBRPC",396,0)
 SET XWBCBK("CHARACTERS")="RESCHR^XWBRPC"
"RTN","XWBRPC",397,0)
 QUIT
"RTN","XWBRPC",398,0)
 ;
"RTN","XWBRPC",399,0)
RESELEST(ELE,ATR) ; -- element start event handler
"RTN","XWBRPC",400,0)
 IF ELE="results" SET XWBTYPE=$G(ATR("type")),XWBCNT=0
"RTN","XWBRPC",401,0)
 QUIT
"RTN","XWBRPC",402,0)
 ;
"RTN","XWBRPC",403,0)
RESELEND(ELE) ; -- element end event handler
"RTN","XWBRPC",404,0)
 KILL XWBCNT,XWBTYPE
"RTN","XWBRPC",405,0)
 QUIT
"RTN","XWBRPC",406,0)
 ;
"RTN","XWBRPC",407,0)
RESCHR(TEXT) ; -- character value event handler
"RTN","XWBRPC",408,0)
 QUIT:$G(XWBTYPE)=""
"RTN","XWBRPC",409,0)
 QUIT:'$L(TEXT)  ; -- Sometimes sends in empty string
"RTN","XWBRPC",410,0)
 ;
"RTN","XWBRPC",411,0)
 IF XWBCNT=0,TEXT=$C(10) QUIT  ; -- bug in parser? always starts with $C(10)
"RTN","XWBRPC",412,0)
 ;
"RTN","XWBRPC",413,0)
 IF XWBTYPE="string" DO  QUIT
"RTN","XWBRPC",414,0)
 . SET XWBCNT=XWBCNT+1
"RTN","XWBRPC",415,0)
 . SET @XWBY@(XWBCNT)=TEXT
"RTN","XWBRPC",416,0)
 ;
"RTN","XWBRPC",417,0)
 IF XWBTYPE="array" DO
"RTN","XWBRPC",418,0)
 . SET XWBCNT=XWBCNT+1
"RTN","XWBRPC",419,0)
 . SET @XWBY@(XWBCNT)=$P(TEXT,$C(10))
"RTN","XWBRPC",420,0)
 QUIT
"RTN","XWBRPC",421,0)
 ;
"RTN","XWBRPC",422,0)
PARSEX(XWBPARMS,XWBY) ; -- parse legacy rpc results ; uses DOM parser
"RTN","XWBRPC",423,0)
 NEW XWBDOM
"RTN","XWBRPC",424,0)
 SET XWBDOM=$$EN^MXMLDOM(XWBPARMS("RESULTS"),"")
"RTN","XWBRPC",425,0)
 DO TEXT^MXMLDOM(XWBDOM,2,XWBY)
"RTN","XWBRPC",426,0)
 DO DELETE^MXMLDOM(XWBDOM)
"RTN","XWBRPC",427,0)
 QUIT
"RTN","XWBRPC",428,0)
 ;
"RTN","XWBRPC",429,0)
 ;
"RTN","XWBRPC",430,0)
 ; -------------------------------------------------------------------
"RTN","XWBRPC",431,0)
 ;                   Response Format Documentation
"RTN","XWBRPC",432,0)
 ; -------------------------------------------------------------------
"RTN","XWBRPC",433,0)
 ;
"RTN","XWBRPC",434,0)
 ;
"RTN","XWBRPC",435,0)
 ; [ Sample XML produced by a successful call of EN^XWBRPC(.XWBPARMS).
"RTN","XWBRPC",436,0)
 ;   SEND^XWBRPC does the actual work to produce response.             ]
"RTN","XWBRPC",437,0)
 ;
"RTN","XWBRPC",438,0)
 ; <?xml version="1.0" encoding="utf-8" ?>
"RTN","XWBRPC",439,0)
 ; <vistalink type="Gov.VA.Med.RPC.Response" >
"RTN","XWBRPC",440,0)
 ;     <results type="array" >
"RTN","XWBRPC",441,0)
 ;         <![CDATA[4261;;2961001.08^2^274^166^105^^2961001.1123^1^^9^2^8^10^^^^^^^10G1-ALN
"RTN","XWBRPC",442,0)
 ;         4270;;2961002.08^2^274^166^112^^^1^^9^2^8^10^^^^^^^10G8-ALN
"RTN","XWBRPC",443,0)
 ;         4274;;2961003.08^2^274^166^116^^^1^^9^2^8^10^^^^^^^10GD-ALN
"RTN","XWBRPC",444,0)
 ;         4340;;2961117.08^2^274^166^182^^2961118.1425^1^^9^2^8^10^^^^^^^10K0-ALN
"RTN","XWBRPC",445,0)
 ;         4342;;2961108.13^2^108^207^183^^2961118.1546^1^^9^2^8^10^^^^^^^10K2-ALN
"RTN","XWBRPC",446,0)
 ;         6394;;3000607.084^2^165^68^6479^^3000622.13^1^^9^1^8^10^^^^^^^197M-ALN]]>
"RTN","XWBRPC",447,0)
 ;     </results>
"RTN","XWBRPC",448,0)
 ; </vistalink>
"RTN","XWBRPC",449,0)
 ;
"RTN","XWBRPC",450,0)
 ; -------------------------------------------------------------------
"RTN","XWBRPC",451,0)
 ;
"RTN","XWBRPC",452,0)
 ; [ Sample XML produced by a unsuccessful call of EN^XWBRPC(.XWBPARMS).
"RTN","XWBRPC",453,0)
 ;   ERROR^XWBRPC does the actual work to produce response.             ]
"RTN","XWBRPC",454,0)
 ;
"RTN","XWBRPC",455,0)
 ; <?xml version="1.0" encoding="utf-8" ?>
"RTN","XWBRPC",456,0)
 ; <vistalink type="Gov.VA..Med.RPC.Error" >
"RTN","XWBRPC",457,0)
 ;    <errors>
"RTN","XWBRPC",458,0)
 ;       <error code="2" uri="XWB BAD NAME" >
"RTN","XWBRPC",459,0)
 ;           <msg>
"RTN","XWBRPC",460,0)
 ;              Remote Procedure Unknown: 'XWB BAD NAME' cannot be found.
"RTN","XWBRPC",461,0)
 ;           </msg>
"RTN","XWBRPC",462,0)
 ;       </error>
"RTN","XWBRPC",463,0)
 ;    </errors>
"RTN","XWBRPC",464,0)
 ; </vistalink>
"RTN","XWBRPC",465,0)
 ;
"RTN","XWBRPC",466,0)
 ; -------------------------------------------------------------------
"RTN","XWBRPC",467,0)
 ;
"RTN","XWBRPC",468,0)
 ;
"RTN","XWBRPC",469,0)
EOR ; end of routine XWBRPC
"RTN","XWBTCPM")
0^5^B84873953
"RTN","XWBTCPM",1,0)
XWBTCPM ;ISF/RWF - BROKER TCP/IP PROCESS HANDLER ; 8/28/2013 10:43am
"RTN","XWBTCPM",2,0)
 ;;1.1;RPC BROKER;**35,43,49,53,991**;Mar 28, 1997;Build 9
"RTN","XWBTCPM",3,0)
 ;Per VHA Directive 2004-038, this routine should not be modified
"RTN","XWBTCPM",4,0)
 ;Based on: XWBTCPC & XWBTCPL, Modified by ISF/RWF
"RTN","XWBTCPM",5,0)
 ;Changed to be started by TCPIP service or %ZISTCPS
"RTN","XWBTCPM",6,0)
 ;
"RTN","XWBTCPM",7,0)
 ; Change History:
"RTN","XWBTCPM",8,0)
 ;
"RTN","XWBTCPM",9,0)
 ; 2005 01 20 OIFO/RWF: XWB*1.1*35 SEQ #30, NON-callback server. Original
"RTN","XWBTCPM",10,0)
 ; routine created. 
"RTN","XWBTCPM",11,0)
 ;
"RTN","XWBTCPM",12,0)
 ; 2006 05 15 OIFO/RWF: XWB*1.1*43 SEQ #36, New broker long timeout fix.
"RTN","XWBTCPM",13,0)
 ; The original Broker and the new Broker had different timeout checks
"RTN","XWBTCPM",14,0)
 ; resulting in records remaining in a locked state long after client
"RTN","XWBTCPM",15,0)
 ; termination. Decreasing the BROKER ACTIVITY TIMEOUT caused problems
"RTN","XWBTCPM",16,0)
 ; with Imaging. The new broker was changed to use the same timeout check
"RTN","XWBTCPM",17,0)
 ; as the original broker, allowing the BROKER ACTIVITY TIMEOUT value to
"RTN","XWBTCPM",18,0)
 ; be changed back to its pre XWB*1.1*35 value of (180 was the
"RTN","XWBTCPM",19,0)
 ; recommended value). Also folded entry point for the new M-to-M Broker
"RTN","XWBTCPM",20,0)
 ; into this main broker entry point, to eliminate the need for a
"RTN","XWBTCPM",21,0)
 ; separate port, entry point, and VMS or Unix service. Also added
"RTN","XWBTCPM",22,0)
 ; GTMLNUX entry point to support running the Broker on GT.M on Linux
"RTN","XWBTCPM",23,0)
 ; using an xinetd service. in CONNTYPE, NEW, SETTIME, GTMLNUX.
"RTN","XWBTCPM",24,0)
 ;
"RTN","XWBTCPM",25,0)
 ; 2009 03 31 OIFO/JLI: XWB*1.1*49 SEQ #40, Improve Support for Linux.
"RTN","XWBTCPM",26,0)
 ; $$OS^XWBTCPM was changed to return "GT.M" under GTM. Revised to make
"RTN","XWBTCPM",27,0)
 ; Broker work with xinetd on Linux with Cache. in OS and passim.
"RTN","XWBTCPM",28,0)
 ;
"RTN","XWBTCPM",29,0)
 ; 2013 08 19-28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBTCPM",30,0)
 ; Load new parameter XWBM2M into new local variable XWBM2M to control
"RTN","XWBTCPM",31,0)
 ; whether the M-to-M Broker is suppressed. Changed call to M2M to
"RTN","XWBTCPM",32,0)
 ; honor the new XWBM2M parameter. Improved support for GT.M on Linux
"RTN","XWBTCPM",33,0)
 ; by preventing an error loop that generates ZINTRECURSEIO errors at
"RTN","XWBTCPM",34,0)
 ; WBF+3^XWBRW. Annotated & refactored CONNTYPE and INIT for clarity.
"RTN","XWBTCPM",35,0)
 ; Change History added. in XWBTCPM, CONNTYPE, ETRAP, INIT, EOR.
"RTN","XWBTCPM",36,0)
 ;
"RTN","XWBTCPM",37,0)
 ;
"RTN","XWBTCPM",38,0)
DSM ;DSM called from ucx, % passed in with device.
"RTN","XWBTCPM",39,0)
 D ESET
"RTN","XWBTCPM",40,0)
 ;Open the device
"RTN","XWBTCPM",41,0)
 S XWBTDEV=% X "O XWBTDEV:(TCPDEV):60" ;Special UCX/DSM open
"RTN","XWBTCPM",42,0)
 ;Go find the connection type
"RTN","XWBTCPM",43,0)
 U XWBTDEV
"RTN","XWBTCPM",44,0)
 G CONNTYPE
"RTN","XWBTCPM",45,0)
 ;
"RTN","XWBTCPM",46,0)
CACHEVMS ;Cache'/VMS tcpip entry point, called from XWBTCP_START.COM file
"RTN","XWBTCPM",47,0)
 D ESET
"RTN","XWBTCPM",48,0)
 S XWBTDEV=$S($ZV["VMS":"SYS$NET",1:$P) ;Support for both VMS/TCPIP and Linux/xinetd
"RTN","XWBTCPM",49,0)
 ; **Cache'/VMS specific code**
"RTN","XWBTCPM",50,0)
 O XWBTDEV::5
"RTN","XWBTCPM",51,0)
 X "U XWBTDEV:(::""-M"")" ;Packet mode like DSM
"RTN","XWBTCPM",52,0)
 G CONNTYPE
"RTN","XWBTCPM",53,0)
 ;
"RTN","XWBTCPM",54,0)
NT ;entry from ZISTCPS
"RTN","XWBTCPM",55,0)
 ;JOB LISTEN^%ZISTCPS("port","NT^XWBTCPM","stop code")
"RTN","XWBTCPM",56,0)
 D ESET
"RTN","XWBTCPM",57,0)
 S XWBTDEV=IO
"RTN","XWBTCPM",58,0)
 G CONNTYPE
"RTN","XWBTCPM",59,0)
 ;
"RTN","XWBTCPM",60,0)
GTMUCX(%) ;From ucx ZFOO
"RTN","XWBTCPM",61,0)
 ;If called from LISTEN^%ZISTCP(PORT,"GTM^XWBTCPM") S XWBTDEV=IO
"RTN","XWBTCPM",62,0)
 D ESET
"RTN","XWBTCPM",63,0)
 ;GTM specific code
"RTN","XWBTCPM",64,0)
 S @("$ZINTERRUPT=""I $$JOBEXAM^ZU($ZPOSITION)""")
"RTN","XWBTCPM",65,0)
 S XWBTDEV=% X "O %:(RECORDSIZE=512)"
"RTN","XWBTCPM",66,0)
 G CONNTYPE
"RTN","XWBTCPM",67,0)
 ;
"RTN","XWBTCPM",68,0)
GTMLNX ;From Linux xinetd script
"RTN","XWBTCPM",69,0)
 D ESET
"RTN","XWBTCPM",70,0)
 ;GTM specific code
"RTN","XWBTCPM",71,0)
 S @("$ZINTERRUPT=""I $$JOBEXAM^ZU($ZPOSITION)""")
"RTN","XWBTCPM",72,0)
 S XWBTDEV=$P X "U XWBTDEV:(nowrap:nodelimiter:ioerror=""TRAP"")"
"RTN","XWBTCPM",73,0)
 S %="",@("%=$ZTRNLNM(""REMOTE_HOST"")") S:$L(%) IO("GTM-IP")=%
"RTN","XWBTCPM",74,0)
 G CONNTYPE
"RTN","XWBTCPM",75,0)
 ;
"RTN","XWBTCPM",76,0)
ESET ;Set inital error trap
"RTN","XWBTCPM",77,0)
 S U="^",$ETRAP="D ^%ZTER H" ;Set up the error trap
"RTN","XWBTCPM",78,0)
 S X="",@("$ZT=X") ;Clear old trap
"RTN","XWBTCPM",79,0)
 Q
"RTN","XWBTCPM",80,0)
 ;
"RTN","XWBTCPM",81,0)
 ;
"RTN","XWBTCPM",82,0)
 ;Find the type of connection and jump to the processing routine.
"RTN","XWBTCPM",83,0)
CONNTYPE ;
"RTN","XWBTCPM",84,0)
 ; input:
"RTN","XWBTCPM",85,0)
 ;   error trap is set
"RTN","XWBTCPM",86,0)
 ;   any interrupts are set
"RTN","XWBTCPM",87,0)
 ;   socket to client is opened and used
"RTN","XWBTCPM",88,0)
 ;   XWBTDEV = the socket port
"RTN","XWBTCPM",89,0)
 ;
"RTN","XWBTCPM",90,0)
 N SOCK,TYPE,XWBAPVER,XWBCLMAN,XWBDEBUG,XWBENVL,XWBLOG,XWBM2M,XWBOS
"RTN","XWBTCPM",91,0)
 N XWBPTYPE,XWBSHARE,XWBT,XWBTBUF,XWBTIP,XWBTSKT,XWBVER,XWBWRAP
"RTN","XWBTCPM",92,0)
 D INIT ; set up common variables
"RTN","XWBTCPM",93,0)
 ;
"RTN","XWBTCPM",94,0)
 S XWB=$$BREAD^XWBRW(5,XWBTIME) ; read in the first message
"RTN","XWBTCPM",95,0)
 D LOG("MSG format is "_XWB_" type "_$S(XWB="[XWB]":"NEW",XWB="{XWB}":"OLD",XWB="<?xml":"M2M",XWB="~BSE~":"BSE",XWB="~EAC~":"EAC",XWB="~SVR~":"SVR",1:"Unk")) ; ID type
"RTN","XWBTCPM",96,0)
 ;
"RTN","XWBTCPM",97,0)
 I XWB["[XWB]" G NEW ; new Broker
"RTN","XWBTCPM",98,0)
 ;
"RTN","XWBTCPM",99,0)
 I XWB["{XWB}" G OLD^XWBTCPM1 ; old Broker
"RTN","XWBTCPM",100,0)
 ;
"RTN","XWBTCPM",101,0)
 I XWB["<?xml",XWBM2M G M2M ; M-to-M Broker, if allowed
"RTN","XWBTCPM",102,0)
 ;
"RTN","XWBTCPM",103,0)
 I $L($T(OTH^XWBTCPM2)) D  ; if it's a special supported message type
"RTN","XWBTCPM",104,0)
 . D OTH^XWBTCPM2 ; process it
"RTN","XWBTCPM",105,0)
 E  D  ; otherwise we don't support this message type
"RTN","XWBTCPM",106,0)
 . D LOG("Prefix not known: "_XWB) ; so just log it
"RTN","XWBTCPM",107,0)
 ;
"RTN","XWBTCPM",108,0)
 QUIT  ; end of CONNTYPE
"RTN","XWBTCPM",109,0)
 ;
"RTN","XWBTCPM",110,0)
 ;
"RTN","XWBTCPM",111,0)
NEWJOB() ;Check if OK to start a new job, Return 1 if OK, 0 if not OK.
"RTN","XWBTCPM",112,0)
 N X,Y,J,XWBVOL
"RTN","XWBTCPM",113,0)
 D GETENV^%ZOSV S XWBVOL=$P(Y,"^",2)
"RTN","XWBTCPM",114,0)
 S X=$O(^XTV(8989.3,1,4,"B",XWBVOL,0)),J=$S(X>0:^XTV(8989.3,1,4,X,0),1:"ROU^y^1")
"RTN","XWBTCPM",115,0)
 I $G(^%ZIS(14.5,"LOGON",XWBVOL)) Q 0 ;Check INHIBIT LOGONS?
"RTN","XWBTCPM",116,0)
 I $D(^%ZOSF("ACTJ")) X ^("ACTJ") I $P(J,U,3),($P(J,U,3)'>Y) Q 0
"RTN","XWBTCPM",117,0)
 Q 1
"RTN","XWBTCPM",118,0)
 ;
"RTN","XWBTCPM",119,0)
M2M ;M2M Broker
"RTN","XWBTCPM",120,0)
 S XWBRBUF=XWB_XWBRBUF,(IO,IO(0))=XWBTDEV G SPAWN^XWBVLL
"RTN","XWBTCPM",121,0)
 Q
"RTN","XWBTCPM",122,0)
 ;
"RTN","XWBTCPM",123,0)
NEW ;New broker
"RTN","XWBTCPM",124,0)
 S U="^",DUZ=0,DUZ(0)="",XWBVER=1.108
"RTN","XWBTCPM",125,0)
 D SETTIME(1) ;Setup for sign-on timeout
"RTN","XWBTCPM",126,0)
 U XWBTDEV D
"RTN","XWBTCPM",127,0)
 . N XWB,ERR,NATIP,I
"RTN","XWBTCPM",128,0)
 . S ERR=$$PRSP^XWBPRS
"RTN","XWBTCPM",129,0)
 . S ERR=$$PRSM^XWBPRS
"RTN","XWBTCPM",130,0)
 . S MSG=$G(XWB(4,"CMD")) ;Build connect msg.
"RTN","XWBTCPM",131,0)
 . S I="" F  S I=$O(XWB(5,"P",I)) Q:I=""  S MSG=MSG_U_XWB(5,"P",I)
"RTN","XWBTCPM",132,0)
 . ;Get the peer and save that IP.
"RTN","XWBTCPM",133,0)
 . S NATIP=$$GETPEER^%ZOSV S:'$L(NATIP) NATIP=$P(MSG,"^",2)
"RTN","XWBTCPM",134,0)
 . I NATIP'=$P(MSG,"^",2) S $P(MSG,"^",2)=NATIP
"RTN","XWBTCPM",135,0)
 . Q
"RTN","XWBTCPM",136,0)
 S X=$$NEWJOB() D:'X LOG("No New Connects")
"RTN","XWBTCPM",137,0)
 I ($P(MSG,U)'="TCPConnect")!('X) D QSND^XWBRW("reject"),LOG("reject: "_MSG) Q
"RTN","XWBTCPM",138,0)
 D QSND^XWBRW("accept"),LOG("accept") ;Ack
"RTN","XWBTCPM",139,0)
 S IO("IP")=$P(MSG,U,2),XWBTSKT=$P(MSG,U,3),XWBCLMAN=$P(MSG,U,4)
"RTN","XWBTCPM",140,0)
 S XWBTIP=$G(IO("IP"))
"RTN","XWBTCPM",141,0)
 ;start RUM for Broker Handler XWB*1.1*5
"RTN","XWBTCPM",142,0)
 D LOGRSRC^%ZOSV("$BROKER HANDLER$",2,1)
"RTN","XWBTCPM",143,0)
 ;GTM
"RTN","XWBTCPM",144,0)
 I $G(XWBT("PCNT")) D
"RTN","XWBTCPM",145,0)
 . S X=$NA(^XUTL("XUSYS",$J,1)) L +@X:0
"RTN","XWBTCPM",146,0)
 . D COUNT^XUSCNT(1),SETLOCK^XUSCNT(X)
"RTN","XWBTCPM",147,0)
 ;We don't use a callback
"RTN","XWBTCPM",148,0)
 K XWB,CON,LEN,MSG ;Clean up
"RTN","XWBTCPM",149,0)
 ;Attempt to share license, Must have TCP port open first.
"RTN","XWBTCPM",150,0)
 U XWBTDEV ;D SHARELIC^%ZOSV(1)
"RTN","XWBTCPM",151,0)
 ;setup null device "NULL"
"RTN","XWBTCPM",152,0)
 S %ZIS="0H",IOP="NULL" D ^%ZIS S XWBNULL=IO I POP S XWBERROR="No NULL device" D LOG(XWBERROR),EXIT Q
"RTN","XWBTCPM",153,0)
 D SAVDEV^%ZISUTL("XWBNULL")
"RTN","XWBTCPM",154,0)
 ;change process name
"RTN","XWBTCPM",155,0)
 D CHPRN("ip"_$P(XWBTIP,".",3,4)_":"_XWBTDEV)
"RTN","XWBTCPM",156,0)
 ;
"RTN","XWBTCPM",157,0)
RESTART ;The error trap returns to here
"RTN","XWBTCPM",158,0)
 N $ESTACK S $ETRAP="D ETRAP^XWBTCPM(0)"
"RTN","XWBTCPM",159,0)
 S DT=$$DT^XLFDT,DTIME=30
"RTN","XWBTCPM",160,0)
 U XWBTDEV D MAIN
"RTN","XWBTCPM",161,0)
 D LOG("Exit: "_XWBTBUF)
"RTN","XWBTCPM",162,0)
 ;Turn off the error trap for the exit
"RTN","XWBTCPM",163,0)
 S $ETRAP=""
"RTN","XWBTCPM",164,0)
 D EXIT ;Logout
"RTN","XWBTCPM",165,0)
 K XWBR,XWBARY
"RTN","XWBTCPM",166,0)
 ;stop RUM for handler XWB*1.1*5
"RTN","XWBTCPM",167,0)
 D LOGRSRC^%ZOSV("$BROKER HANDLER$",2,2)
"RTN","XWBTCPM",168,0)
 D USE^%ZISUTL("XWBNULL"),CLOSE^%ZISUTL("XWBNULL")
"RTN","XWBTCPM",169,0)
 ;Close in the calling script
"RTN","XWBTCPM",170,0)
 K SOCK,TYPE,XWBSND,XWBTYPE,XWBRBUF
"RTN","XWBTCPM",171,0)
 Q
"RTN","XWBTCPM",172,0)
 ;
"RTN","XWBTCPM",173,0)
MAIN ; -- main message processing loop. debug at MAIN+1
"RTN","XWBTCPM",174,0)
 F  D  Q:XWBTBUF="#BYE#"
"RTN","XWBTCPM",175,0)
 . ;Setup
"RTN","XWBTCPM",176,0)
 . S XWBAPVER=0,XWBTBUF="",XWBTCMD="",XWBRBUF=""
"RTN","XWBTCPM",177,0)
 . K XWBR,XWBARY,XWBPRT
"RTN","XWBTCPM",178,0)
 . ; -- read client request
"RTN","XWBTCPM",179,0)
 . S XR=$$BREAD^XWBRW(1,XWBTIME,1)
"RTN","XWBTCPM",180,0)
 . I '$L(XR) D LOG("Timeout: "_XWBTIME) S XWBTBUF="#BYE#" Q
"RTN","XWBTCPM",181,0)
 . S XR=XR_$$BREAD^XWBRW(4)
"RTN","XWBTCPM",182,0)
 . I XR="#BYE#" D  Q  ;Check for exit
"RTN","XWBTCPM",183,0)
 . . D QSND^XWBRW("#BYE#"),LOG("BYE CMD") S XWBTBUF="#BYE#"
"RTN","XWBTCPM",184,0)
 . . Q
"RTN","XWBTCPM",185,0)
 . S TYPE=(XR="[XWB]")  ;check HDR
"RTN","XWBTCPM",186,0)
 . I 'TYPE D LOG("Bad Header: "_XR) Q
"RTN","XWBTCPM",187,0)
 . D CALLP^XWBPRS(.XWBR,$G(XWBDEBUG)) ;Read the NEW Msg parameters and call RPC
"RTN","XWBTCPM",188,0)
 . IF XWBTCMD="#BYE#" D  Q
"RTN","XWBTCPM",189,0)
 . . D QSND^XWBRW("#BYE#"),LOG("BYE CMD") S XWBTBUF=XWBTCMD
"RTN","XWBTCPM",190,0)
 . . Q
"RTN","XWBTCPM",191,0)
 . U XWBTDEV
"RTN","XWBTCPM",192,0)
 . S XWBPTYPE=$S('$D(XWBPTYPE):1,XWBPTYPE<1:1,XWBPTYPE>6:1,1:XWBPTYPE)
"RTN","XWBTCPM",193,0)
 . ;I $G(XWBPRT) D RETURN^XWBPRS2 Q  ;New msg return
"RTN","XWBTCPM",194,0)
 . I '$G(XWBPRT) D SND^XWBRW ;Return data,flush buffer
"RTN","XWBTCPM",195,0)
 Q  ;End Of Main
"RTN","XWBTCPM",196,0)
 ;
"RTN","XWBTCPM",197,0)
 ;
"RTN","XWBTCPM",198,0)
ETRAP(EXIT) ; -- on trapped error, send error info to client
"RTN","XWBTCPM",199,0)
 N XWBERC,XWBERR
"RTN","XWBTCPM",200,0)
 ;Change trapping during trap.
"RTN","XWBTCPM",201,0)
 S $ETRAP="D ^%ZTER,ETRAP^XWBTCPM(1)"
"RTN","XWBTCPM",202,0)
 S XWBERC=$E($$EC^%ZOSV,1,200),XWBERR="M  ERROR="_XWBERC_$C(13,10)_"LAST REF="_$$LGR^%ZOSV
"RTN","XWBTCPM",203,0)
 I $EC["U411" S XWBERROR="U411",XWBSEC="",XWBERR="Data Transfer Error to Server"
"RTN","XWBTCPM",204,0)
 D ^%ZTER ;%ZTER clears $ZE and $ZCODE
"RTN","XWBTCPM",205,0)
 D LOG("In ETRAP: "_XWBERC) ;Log
"RTN","XWBTCPM",206,0)
 I (XWBERC["READ")!(XWBERC["WRITE")!(XWBERC["SYSTEM-F")!(XWBERC["IOEOF")!(XWBERC["ZINTRECURSEIO") D EXIT X "HALT "
"RTN","XWBTCPM",207,0)
 U XWBTDEV
"RTN","XWBTCPM",208,0)
 I $G(XWBT("PCNT")) L +^XUTL("XUSYS",$J,0):99
"RTN","XWBTCPM",209,0)
 E  L  ;Clear Locks
"RTN","XWBTCPM",210,0)
 ;
"RTN","XWBTCPM",211,0)
 I EXIT D EXIT X "HALT "
"RTN","XWBTCPM",212,0)
 D ESND^XWBRW($C(24)_XWBERR_$C(4))
"RTN","XWBTCPM",213,0)
 S $ETRAP="Q:($ESTACK&'$QUIT)  Q:$ESTACK -9 S $ECODE="""" D CLEANP^XWBTCPM G RESTART^XWBTCPM",$ECODE=",U99,"
"RTN","XWBTCPM",214,0)
 Q
"RTN","XWBTCPM",215,0)
 ;
"RTN","XWBTCPM",216,0)
CLEANP ;Clean up the partion
"RTN","XWBTCPM",217,0)
 N XWBTDEV,XWBNULL D KILL^XUSCLEAN
"RTN","XWBTCPM",218,0)
 Q
"RTN","XWBTCPM",219,0)
 ;
"RTN","XWBTCPM",220,0)
STYPE(X,WRAP) ;For backward compatability only
"RTN","XWBTCPM",221,0)
 I $D(WRAP) Q $$RTRNFMT^XWBLIB($G(X),WRAP)
"RTN","XWBTCPM",222,0)
 Q $$RTRNFMT^XWBLIB(X)
"RTN","XWBTCPM",223,0)
 ;
"RTN","XWBTCPM",224,0)
BREAD(L,T) ;read tcp buffer, L is length
"RTN","XWBTCPM",225,0)
 Q $$BREAD^XWBRW(L,$G(T))
"RTN","XWBTCPM",226,0)
 ;
"RTN","XWBTCPM",227,0)
CHPRN(N) ;change process name
"RTN","XWBTCPM",228,0)
 ;Change process name to N
"RTN","XWBTCPM",229,0)
 D SETNM^%ZOSV($E(N,1,15))
"RTN","XWBTCPM",230,0)
 Q
"RTN","XWBTCPM",231,0)
 ;
"RTN","XWBTCPM",232,0)
SETTIME(%) ;Set the Read timeout 0=RPC, 1=sign-on
"RTN","XWBTCPM",233,0)
 ; Increased timeout period (%=1) during signon from 90 to 180 for accessibility reasons
"RTN","XWBTCPM",234,0)
 S XWBTIME=$S($G(%):180,$G(XWBVER)>1.1:$$BAT^XUPARAM,1:36000),XWBTIME(1)=5 ; (*p35)
"RTN","XWBTCPM",235,0)
 Q
"RTN","XWBTCPM",236,0)
TIMEOUT ;Do this on MAIN  loop timeout
"RTN","XWBTCPM",237,0)
 I $G(DUZ)>0 D QSND^XWBRW("#BYE#") Q
"RTN","XWBTCPM",238,0)
 ;Sign-on timeout
"RTN","XWBTCPM",239,0)
 S XWBR(0)=0,XWBR(1)=1,XWBR(2)="",XWBR(3)="TIME-OUT",XWBPTYPE=2
"RTN","XWBTCPM",240,0)
 D SND^XWBRW
"RTN","XWBTCPM",241,0)
 Q
"RTN","XWBTCPM",242,0)
 ;
"RTN","XWBTCPM",243,0)
OS() ;Return the OS
"RTN","XWBTCPM",244,0)
 Q $S(^%ZOSF("OS")["OpenM":"OpenM",^%ZOSF("OS")["GT.M":"GT.M",^("OS")["DSM":"DSM",1:"UNK")
"RTN","XWBTCPM",245,0)
 ;
"RTN","XWBTCPM",246,0)
 ;
"RTN","XWBTCPM",247,0)
INIT ; Setup common variables for all brokers types
"RTN","XWBTCPM",248,0)
 S U="^"
"RTN","XWBTCPM",249,0)
 S XWBDEBUG=$$GET^XPAR("SYS","XWBDEBUG") ; enable or disable debug log
"RTN","XWBTCPM",250,0)
 S XWBM2M=$$GET^XPAR("ALL","XWBM2M") ; enable or disable M-to-M Broker
"RTN","XWBTCPM",251,0)
 S XWBOS=$$OS ; MUMPS implementation ("operating system")
"RTN","XWBTCPM",252,0)
 S XWBRBUF=""
"RTN","XWBTCPM",253,0)
 S XWBT("BF")=$S(XWBOS="GT.M":"#",1:"!") ; buffer flush
"RTN","XWBTCPM",254,0)
 S XWBT("PCNT")=0 ; count processes? default to false
"RTN","XWBTCPM",255,0)
 I XWBOS="GT.M",$L($T(^XUSCNT)) D  ; for GT.M systems
"RTN","XWBTCPM",256,0)
 . S XWBT("PCNT")=1 ; set flag to count processes
"RTN","XWBTCPM",257,0)
 S XWBTIME=10 ; default time-out (overridden for new & old broker)
"RTN","XWBTCPM",258,0)
 ;
"RTN","XWBTCPM",259,0)
 D LOGSTART^XWBDLOG("XWBTCPM") ; start broker log
"RTN","XWBTCPM",260,0)
 ;
"RTN","XWBTCPM",261,0)
 QUIT  ; end of INIT
"RTN","XWBTCPM",262,0)
 ;
"RTN","XWBTCPM",263,0)
 ;
"RTN","XWBTCPM",264,0)
DEBUG ;Entry point for debug, Build a server to get the connect
"RTN","XWBTCPM",265,0)
 ;Cache sample;ZB SERV+1^XWBTCPM:"L+" ZB ETRAP+1^XWBTCPM:"B"
"RTN","XWBTCPM",266,0)
 W !,"Before running this entry point set your debugger to stop at"
"RTN","XWBTCPM",267,0)
 W !,"the place you want to debug. Some spots to use:"
"RTN","XWBTCPM",268,0)
 W !,"'SERV+1^XWBTCPM', 'MAIN+1^XWBTCPM' or 'CAPI+1^XWBPRS.'",!
"RTN","XWBTCPM",269,0)
 W !,"or location of your choice.",!
"RTN","XWBTCPM",270,0)
 W !,"IP Socket to Listen on: " R SOCK:300,! Q:'$T!(SOCK["^")
"RTN","XWBTCPM",271,0)
 ;Use %ZISTCP to do a single server
"RTN","XWBTCPM",272,0)
 D LISTEN^%ZISTCP(SOCK,"SERV^XWBTCPM")
"RTN","XWBTCPM",273,0)
 U $P W !,"Done"
"RTN","XWBTCPM",274,0)
 Q
"RTN","XWBTCPM",275,0)
SERV ;Callback from the server
"RTN","XWBTCPM",276,0)
 S XWBTDEV=IO,XWBTIME(1)=3600 D INIT
"RTN","XWBTCPM",277,0)
 S XWBDEBUG=1,MSG=$$BREAD^XWBRW(5,60) ;R MSG#5
"RTN","XWBTCPM",278,0)
 D NEW
"RTN","XWBTCPM",279,0)
 S IO("C")=1 ;Cause the Listenr to stop
"RTN","XWBTCPM",280,0)
 Q
"RTN","XWBTCPM",281,0)
 ;
"RTN","XWBTCPM",282,0)
EXIT ;Close out
"RTN","XWBTCPM",283,0)
 I $G(DUZ) D LOGOUT^XUSRB
"RTN","XWBTCPM",284,0)
 I $G(XWBT("PCNT")) D COUNT^XUSCNT(-1)
"RTN","XWBTCPM",285,0)
 Q
"RTN","XWBTCPM",286,0)
 ;
"RTN","XWBTCPM",287,0)
LOG(MSG) ;Record Debug Info
"RTN","XWBTCPM",288,0)
 D:$G(XWBDEBUG) LOG^XWBDLOG(MSG)
"RTN","XWBTCPM",289,0)
 Q
"RTN","XWBTCPM",290,0)
 ;
"RTN","XWBTCPM",291,0)
 ;
"RTN","XWBTCPM",292,0)
EOR ; end of routine XWBTCPM
"RTN","XWBUTL")
0^6^B19872185
"RTN","XWBUTL",1,0)
XWBUTL ;OIFO-Oakland/REM - M2M Programmer Utilities ; 8/28/2013 10:44am
"RTN","XWBUTL",2,0)
 ;;1.1;RPC BROKER;**28,34,991**;Mar 28, 1997;Build 9
"RTN","XWBUTL",3,0)
 ;
"RTN","XWBUTL",4,0)
 QUIT  ; routine XWBUTL is not callable at the top
"RTN","XWBUTL",5,0)
 ;
"RTN","XWBUTL",6,0)
 ; Change History:
"RTN","XWBUTL",7,0)
 ;
"RTN","XWBUTL",8,0)
 ; 2002 08 10 OIFO/REM: XWB*1.1*28 SEQ #25, M2M Broker. Original routine
"RTN","XWBUTL",9,0)
 ; created. 
"RTN","XWBUTL",10,0)
 ;
"RTN","XWBUTL",11,0)
 ; 2005 10 26 OIFO/REM: XWB*1.1*34 SEQ #33, M2M Bug Fixes. Corrected typo
"RTN","XWBUTL",12,0)
 ; changing ">" to "<" in QUIT:STR'[">". Added "[]" as escape characters.
"RTN","XWBUTL",13,0)
 ; in CHARCHK.
"RTN","XWBUTL",14,0)
 ;
"RTN","XWBUTL",15,0)
 ; 2013 08 28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBUTL",16,0)
 ; Log error events. Refactor ERROR for clarity. Change History added.
"RTN","XWBUTL",17,0)
 ; in XWBUTL, ERROR, EOR.
"RTN","XWBUTL",18,0)
 ;
"RTN","XWBUTL",19,0)
 ;
"RTN","XWBUTL",20,0)
XMLHDR() ; -- provides current XML standard header
"RTN","XWBUTL",21,0)
 QUIT "<?xml version=""1.0"" encoding=""utf-8"" ?>"
"RTN","XWBUTL",22,0)
 ;
"RTN","XWBUTL",23,0)
 ;
"RTN","XWBUTL",24,0)
ERROR(XWBDAT) ; -- log & send error type message
"RTN","XWBUTL",25,0)
 ; input: XWBDAT array (see documentation in BUILD, below)
"RTN","XWBUTL",26,0)
 ; output:
"RTN","XWBUTL",27,0)
 ;   error is logged in the Broker's troubleshooting log
"RTN","XWBUTL",28,0)
 ;   error is transmitted via socket to the client
"RTN","XWBUTL",29,0)
 ;
"RTN","XWBUTL",30,0)
 ; 1. conditionally log error in Broker troubleshooting log
"RTN","XWBUTL",31,0)
 ;
"RTN","XWBUTL",32,0)
 I $G(XWBDEBUG) D  ; if debugging is on
"RTN","XWBUTL",33,0)
 . N XWBENAME ; name of error
"RTN","XWBUTL",34,0)
 . I XWBDEBUG=1 D  ; if debug=1, "on"
"RTN","XWBUTL",35,0)
 . . S XWBENAME="Error"
"RTN","XWBUTL",36,0)
 . E  D  ; if debug=2 or 3, "verbose" or "very verbose"
"RTN","XWBUTL",37,0)
 . . S XWBENAME="Error: "_$G(XWBDAT("ERRORS",1,"MESSAGE",1))
"RTN","XWBUTL",38,0)
 . N XWBARRAY ; error array, usually empty & not passed
"RTN","XWBUTL",39,0)
 . N XWBANAME S XWBANAME="" ; name of error array to pass
"RTN","XWBUTL",40,0)
 . I XWBDEBUG=3 D  ; if debug="very verbose"
"RTN","XWBUTL",41,0)
 . . M XWBARRAY=XWBDAT ; include the whole error type message
"RTN","XWBUTL",42,0)
 . . S XWBANAME="XWBARRAY" ; set name to pass
"RTN","XWBUTL",43,0)
 . D LOG^XWBDLOG(XWBENAME,XWBANAME) ; log the error
"RTN","XWBUTL",44,0)
 ;
"RTN","XWBUTL",45,0)
 ; 2. build XML error message to transmit
"RTN","XWBUTL",46,0)
 ;
"RTN","XWBUTL",47,0)
 N XWBMSG ; array to record XML error message
"RTN","XWBUTL",48,0)
 D BUILD("XWBMSG",.XWBDAT) ; build XML
"RTN","XWBUTL",49,0)
 ;
"RTN","XWBUTL",50,0)
 ; 3. transmit XML error message to client
"RTN","XWBUTL",51,0)
 ;
"RTN","XWBUTL",52,0)
 D PRE^XWBRL ; prepare socket for writing
"RTN","XWBUTL",53,0)
 N XWBLINE S XWBLINE=0 ; line # in XML message
"RTN","XWBUTL",54,0)
 F  D  Q:'XWBLINE  ; traverse all lines in msg
"RTN","XWBUTL",55,0)
 . S XWBLINE=$O(XWBMSG(XWBLINE)) ; traverse each line in msg
"RTN","XWBUTL",56,0)
 . Q:'XWBLINE  ; end loop when we're out of lines
"RTN","XWBUTL",57,0)
 . D WRITE^XWBRL(XWBMSG(XWBLINE)) ; write a line to the client
"RTN","XWBUTL",58,0)
 D POST^XWBRL ; send EOT and flush socket buffer
"RTN","XWBUTL",59,0)
 ;
"RTN","XWBUTL",60,0)
 QUIT  ; end of ERROR
"RTN","XWBUTL",61,0)
 ;
"RTN","XWBUTL",62,0)
 ;
"RTN","XWBUTL",63,0)
BUILD(XWBY,XWBDAT) ;  -- build xml in passed store reference (XWBY)
"RTN","XWBUTL",64,0)
 ; -- input format
"RTN","XWBUTL",65,0)
 ; XWBDAT("MESSAGE TYPE") = type of message (ex. Gov.VA.Med.RPC.Error)
"RTN","XWBUTL",66,0)
 ; XWBDAT("ERRORS",<integer>,"CODE") = error code
"RTN","XWBUTL",67,0)
 ; XWBDAT("ERRORS",<integer>,"ERROR TYPE") = type of error (system/application/security)
"RTN","XWBUTL",68,0)
 ; XWBDAT("ERRORS",<integer>,"MESSAGE",<integer>) = error message
"RTN","XWBUTL",69,0)
 ;
"RTN","XWBUTL",70,0)
 NEW XWBCODE,XWBI,XWBERR,XWBLINE,XWBETYPE
"RTN","XWBUTL",71,0)
 SET XWBLINE=0
"RTN","XWBUTL",72,0)
 ;
"RTN","XWBUTL",73,0)
 DO ADD($$XMLHDR())
"RTN","XWBUTL",74,0)
 DO ADD("<vistalink type="""_$G(XWBDAT("MESSAGE TYPE"))_""" >")
"RTN","XWBUTL",75,0)
 DO ADD("<errors>")
"RTN","XWBUTL",76,0)
 SET XWBERR=0
"RTN","XWBUTL",77,0)
 FOR  SET XWBERR=$O(XWBDAT("ERRORS",XWBERR)) Q:'XWBERR  DO
"RTN","XWBUTL",78,0)
 . SET XWBCODE=$G(XWBDAT("ERRORS",XWBERR,"CODE"),0)
"RTN","XWBUTL",79,0)
 . SET XWBETYPE=$G(XWBDAT("ERRORS",XWBERR,"ERROR TYPE"),0)
"RTN","XWBUTL",80,0)
 . DO ADD("<error type="""_XWBETYPE_""" code="""_XWBCODE_""" >")
"RTN","XWBUTL",81,0)
 . DO ADD("<msg>")
"RTN","XWBUTL",82,0)
 . IF $G(XWBDAT("ERRORS",XWBERR,"CDATA")) DO ADD("<![CDATA[")
"RTN","XWBUTL",83,0)
 . SET XWBI=0
"RTN","XWBUTL",84,0)
 . FOR  SET XWBI=$O(XWBDAT("ERRORS",XWBERR,"MESSAGE",XWBI)) Q:'XWBI  DO
"RTN","XWBUTL",85,0)
 . . DO ADD(XWBDAT("ERRORS",XWBERR,"MESSAGE",XWBI))
"RTN","XWBUTL",86,0)
 . IF $G(XWBDAT("ERRORS",XWBERR,"CDATA")) DO ADD("]]>")
"RTN","XWBUTL",87,0)
 . DO ADD("</msg>")
"RTN","XWBUTL",88,0)
 . DO ADD("</error>")
"RTN","XWBUTL",89,0)
 DO ADD("</errors>")
"RTN","XWBUTL",90,0)
 DO ADD("</vistalink>")
"RTN","XWBUTL",91,0)
 ;
"RTN","XWBUTL",92,0)
 QUIT
"RTN","XWBUTL",93,0)
 ;
"RTN","XWBUTL",94,0)
ADD(TXT) ; -- add line
"RTN","XWBUTL",95,0)
 SET XWBLINE=XWBLINE+1
"RTN","XWBUTL",96,0)
 SET @XWBY@(XWBLINE)=TXT
"RTN","XWBUTL",97,0)
 QUIT
"RTN","XWBUTL",98,0)
 ;
"RTN","XWBUTL",99,0)
CHARCHK(STR) ; -- replace xml character limits with entities
"RTN","XWBUTL",100,0)
 NEW A,I,X,Y,Z,NEWSTR
"RTN","XWBUTL",101,0)
 SET (Y,Z)=""
"RTN","XWBUTL",102,0)
 IF STR["&" SET NEWSTR=STR DO  SET STR=Y_Z
"RTN","XWBUTL",103,0)
 . FOR X=1:1  SET Y=Y_$PIECE(NEWSTR,"&",X)_"&amp;",Z=$PIECE(STR,"&",X+1,999) QUIT:Z'["&"
"RTN","XWBUTL",104,0)
 ;
"RTN","XWBUTL",105,0)
 ;*p34-typo, change ">" to "<" in Q:STR'[...
"RTN","XWBUTL",106,0)
 IF STR["<" FOR  SET STR=$PIECE(STR,"<",1)_"&lt;"_$PIECE(STR,"<",2,99) Q:STR'["<"
"RTN","XWBUTL",107,0)
 IF STR[">" FOR  SET STR=$PIECE(STR,">",1)_"&gt;"_$PIECE(STR,">",2,99) Q:STR'[">"
"RTN","XWBUTL",108,0)
 IF STR["'" FOR  SET STR=$PIECE(STR,"'",1)_"&apos;"_$PIECE(STR,"'",2,99) Q:STR'["'"
"RTN","XWBUTL",109,0)
 IF STR["""" FOR  SET STR=$PIECE(STR,"""",1)_"&quot;"_$PIECE(STR,"""",2,99) QUIT:STR'[""""
"RTN","XWBUTL",110,0)
 ;
"RTN","XWBUTL",111,0)
 ;*p34-add "[]" as escape characters.
"RTN","XWBUTL",112,0)
 IF STR["[" FOR  SET STR=$PIECE(STR,"[",1)_"&#91;"_$PIECE(STR,"[",2,99) Q:STR'["["
"RTN","XWBUTL",113,0)
 IF STR["]" FOR  SET STR=$PIECE(STR,"]",1)_"&#93;"_$PIECE(STR,"]",2,99) Q:STR'["]"
"RTN","XWBUTL",114,0)
 ;
"RTN","XWBUTL",115,0)
 ;Remove ctrl char's
"RTN","XWBUTL",116,0)
 S STR=$TR(STR,$C(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31))
"RTN","XWBUTL",117,0)
 ;FOR I=1:1:$LENGTH(STR) DO
"RTN","XWBUTL",118,0)
 ;. SET X=$EXTRACT(STR,I)
"RTN","XWBUTL",119,0)
 ;. SET A=$ASCII(X)
"RTN","XWBUTL",120,0)
 ;. IF A<31 S STR=$P(STR,X,1)_$P(STR,X,2,99)
"RTN","XWBUTL",121,0)
 QUIT STR
"RTN","XWBUTL",122,0)
 ;
"RTN","XWBUTL",123,0)
 ;D=0 STR 2 NUM, D=1 NUM 2 STR
"RTN","XWBUTL",124,0)
NUM(STR,D) ;Convert a string to numbers
"RTN","XWBUTL",125,0)
 N I,Y
"RTN","XWBUTL",126,0)
 S Y="",D=$G(D,0)
"RTN","XWBUTL",127,0)
 I D=0 F I=1:1:$L(STR) S Y=Y_$E(1000+$A(STR,I),2,4)
"RTN","XWBUTL",128,0)
 I D=1 F I=1:3:$L(STR) S Y=Y_$C($E(STR,I,I+2))
"RTN","XWBUTL",129,0)
 Q Y
"RTN","XWBUTL",130,0)
 ;
"RTN","XWBUTL",131,0)
 ;
"RTN","XWBUTL",132,0)
EOR ; end of routine XWBUTL
"RTN","XWBVLL")
0^7^B24429511
"RTN","XWBVLL",1,0)
XWBVLL ;OIFO-Oakland/REM - M2M Broker Listener ; 8/28/2013 10:45am
"RTN","XWBVLL",2,0)
 ;;1.1;RPC BROKER;**28,41,34,991**;Mar 28, 1997;Build 9
"RTN","XWBVLL",3,0)
 ;
"RTN","XWBVLL",4,0)
 QUIT  ; routine XWBVLL is not callable at the top
"RTN","XWBVLL",5,0)
 ;
"RTN","XWBVLL",6,0)
 ; Change History:
"RTN","XWBVLL",7,0)
 ;
"RTN","XWBVLL",8,0)
 ; 2002 08 10 OIFO/REM: XWB*1.1*28 SEQ #25, M2M Broker. Original routine
"RTN","XWBVLL",9,0)
 ; created. 
"RTN","XWBVLL",10,0)
 ;
"RTN","XWBVLL",11,0)
 ; 2004 04 27 OIFO/REM: XWB*1.1*41 SEQ #29, M2M Infinite Loop. Fixed
"RTN","XWBVLL",12,0)
 ; infinite loop bug in SYSERR. Created new Cache/VMS tcpip entry point,
"RTN","XWBVLL",13,0)
 ; called from XWBSERVER_START.COM file. in SYSERR, CACHEVMS.
"RTN","XWBVLL",14,0)
 ;
"RTN","XWBVLL",15,0)
 ; 2005 10 26 OIFO/REM: XWB*1.1*34 SEQ #33, M2M Bug Fixes. Added
"RTN","XWBVLL",16,0)
 ; "BrokerM2M" in message type. Removed the quotes (") after 'M:'. Added
"RTN","XWBVLL",17,0)
 ; new entry point to job off the listener for Cache: STRT^XWBVLL(PORT).
"RTN","XWBVLL",18,0)
 ; Cleared locks when error occurs. Halt for read/write errors.
"RTN","XWBVLL",19,0)
 ; in SYSERR, SYSERRS, STRT.
"RTN","XWBVLL",20,0)
 ;
"RTN","XWBVLL",21,0)
 ; 2013 08 16-28 VEN/TOAD: XWB*1.1*991 SEQ #46, M2M Security Fixes.
"RTN","XWBVLL",22,0)
 ; Replaced non-standard error logging. Log errors. Apply logging
"RTN","XWBVLL",23,0)
 ; levels. Fix init of variables & log. Annotated. Change History added.
"RTN","XWBVLL",24,0)
 ; in XWBVLL, SPAWN, NXTCALL, SYSERR, EOR.
"RTN","XWBVLL",25,0)
 ;
"RTN","XWBVLL",26,0)
 ;
"RTN","XWBVLL",27,0)
START(SOCKET) ;Entry point for Cache/NT
"RTN","XWBVLL",28,0)
 ;May be called directly to start the listener.
"RTN","XWBVLL",29,0)
 ;SOCKET -is the port# to start the listener on.
"RTN","XWBVLL",30,0)
 I ^%ZOSF("OS")'["OpenM" Q  ;Quits if not a Cache OS.
"RTN","XWBVLL",31,0)
 D LISTEN^%ZISTCPS(SOCKET,"SPAWN^XWBVLL")
"RTN","XWBVLL",32,0)
 Q
"RTN","XWBVLL",33,0)
 ;
"RTN","XWBVLL",34,0)
UCX ;DMS/VMS UCX entry point, called from XWBSERVER_START.COM file,
"RTN","XWBVLL",35,0)
 ;listener,  % = <input variable>
"RTN","XWBVLL",36,0)
 ;IF $G(%)="" DO ^%ZTER QUIT
"RTN","XWBVLL",37,0)
 SET (IO,IO(0))="SYS$NET"
"RTN","XWBVLL",38,0)
 ; **VMS specific code, need to share device**
"RTN","XWBVLL",39,0)
 OPEN IO:(TCPDEV):60 ELSE  SET ^TMP("XWB DSM CONNECT FAILURE",$H)="" QUIT
"RTN","XWBVLL",40,0)
 USE IO
"RTN","XWBVLL",41,0)
 DO SPAWN
"RTN","XWBVLL",42,0)
 QUIT
"RTN","XWBVLL",43,0)
 ;
"RTN","XWBVLL",44,0)
STRT(PORT) ;*p34-This entry is called from option "XWB M2M CACHE LISTENER" and jobs off the listener for Cache/NT.  Will call START.
"RTN","XWBVLL",45,0)
 ;PORT -is the port# to start the listener on.
"RTN","XWBVLL",46,0)
 J START^XWBVLL(PORT)::5 ;Used in place of TaskMan
"RTN","XWBVLL",47,0)
 Q
"RTN","XWBVLL",48,0)
 ;
"RTN","XWBVLL",49,0)
CACHEVMS ;Cache/VMS tcpip entry point, called from XWBSERVER_START.COM fLle *p41*
"RTN","XWBVLL",50,0)
 SET (IO,IO(0))="SYS$NET"
"RTN","XWBVLL",51,0)
 ; **CACHE/VMS specific code**
"RTN","XWBVLL",52,0)
 OPEN IO::60 ELSE  SET ^TMP("XWB DSM CONNECT FAILURE",$H)="" QUIT
"RTN","XWBVLL",53,0)
 X "U IO:(::""-M"")" ;Packet mode like DSM
"RTN","XWBVLL",54,0)
 DO SPAWN
"RTN","XWBVLL",55,0)
 QUIT
"RTN","XWBVLL",56,0)
 ;
"RTN","XWBVLL",57,0)
SPAWN ; -- spawned process
"RTN","XWBVLL",58,0)
 NEW XWBSTOP
"RTN","XWBVLL",59,0)
 SET XWBSTOP=0
"RTN","XWBVLL",60,0)
 ;
"RTN","XWBVLL",61,0)
 ; -- initialize tcp processing variables
"RTN","XWBVLL",62,0)
 I $G(XWBOS)="" D  ; if we have not already initialized,
"RTN","XWBVLL",63,0)
 . D INIT^XWBTCPM ; set up locals and start log
"RTN","XWBVLL",64,0)
 ;
"RTN","XWBVLL",65,0)
 ; -- set error trap
"RTN","XWBVLL",66,0)
 NEW $ESTACK,$ETRAP S $ETRAP="D ^%ZTER HALT"
"RTN","XWBVLL",67,0)
 ;
"RTN","XWBVLL",68,0)
 ; -- change job name if possible
"RTN","XWBVLL",69,0)
 ;DO SETNM^%ZOSV("XWBSERVER: Server") ;**M2M - comment out for now
"RTN","XWBVLL",70,0)
 DO SAVDEV^%ZISUTL("XWBM2M SERVER") ;**M2M save off server IO
"RTN","XWBVLL",71,0)
 ;
"RTN","XWBVLL",72,0)
 ; -- loop until told to stop
"RTN","XWBVLL",73,0)
 FOR  DO NXTCALL QUIT:XWBSTOP
"RTN","XWBVLL",74,0)
 ;
"RTN","XWBVLL",75,0)
 ; -- final/clean tcp processing variables
"RTN","XWBVLL",76,0)
 D RMDEV^%ZISUTL("XWBM2M SERVER") ;**M2M remove server IO
"RTN","XWBVLL",77,0)
 Q
"RTN","XWBVLL",78,0)
 ;
"RTN","XWBVLL",79,0)
NXTCALL ; -- do next call
"RTN","XWBVLL",80,0)
 NEW U,DTIME,DT,X,XWBROOT,XWBREAD,XWBTO,XWBFIRST,XWBOK,XWBRL,BUG
"RTN","XWBVLL",81,0)
 ;
"RTN","XWBVLL",82,0)
 ; -- set error trap
"RTN","XWBVLL",83,0)
 NEW $ESTACK,$ETRAP S $ETRAP="D SYSERR^XWBVLL"
"RTN","XWBVLL",84,0)
 ;
"RTN","XWBVLL",85,0)
 ; -- setup environment variables
"RTN","XWBVLL",86,0)
 SET U="^",DTIME=900,DT=$$DT^XLFDT()
"RTN","XWBVLL",87,0)
 SET XWBREAD=20,XWBTO=36000,XWBFIRST=1
"RTN","XWBVLL",88,0)
 ;
"RTN","XWBVLL",89,0)
 ; -- setup intake global - root is request data
"RTN","XWBVLL",90,0)
 SET XWBROOT=$NA(^TMP("XWBVLL",$J))
"RTN","XWBVLL",91,0)
 KILL @XWBROOT
"RTN","XWBVLL",92,0)
 ;
"RTN","XWBVLL",93,0)
 ; -- set parameters for RawLink
"RTN","XWBVLL",94,0)
 SET XWBRL("TIME OUT")=36000
"RTN","XWBVLL",95,0)
 SET XWBRL("READ CHARACTERS")=20
"RTN","XWBVLL",96,0)
 SET XWBRL("FIRST READ")=1
"RTN","XWBVLL",97,0)
 SET XWBRL("STORE")=XWBROOT
"RTN","XWBVLL",98,0)
 SET XWBRL("STOP FLAG")=XWBSTOP
"RTN","XWBVLL",99,0)
 ;
"RTN","XWBVLL",100,0)
 ; -- read from socket
"RTN","XWBVLL",101,0)
 SET XWBOK=$$READ^XWBRL(XWBROOT,.XWBREAD,.XWBTO,.XWBFIRST,.XWBSTOP)
"RTN","XWBVLL",102,0)
 ;
"RTN","XWBVLL",103,0)
 ; -- log request
"RTN","XWBVLL",104,0)
 I $G(XWBDEBUG)>1 D  ; if debug="verbose" or "very verbose"
"RTN","XWBVLL",105,0)
 . D LOG^XWBDLOG("Request Received",$NA(^TMP("XWBVLL",$J)))
"RTN","XWBVLL",106,0)
 ;
"RTN","XWBVLL",107,0)
 IF 'XWBOK GOTO NXTCALLQ
"RTN","XWBVLL",108,0)
 ;
"RTN","XWBVLL",109,0)
 ; -- call request manager
"RTN","XWBVLL",110,0)
 SET XWBOK=$$EN^XWBRM(XWBROOT)
"RTN","XWBVLL",111,0)
 ;
"RTN","XWBVLL",112,0)
NXTCALLQ ; -- exit
"RTN","XWBVLL",113,0)
 ;
"RTN","XWBVLL",114,0)
 QUIT
"RTN","XWBVLL",115,0)
 ;
"RTN","XWBVLL",116,0)
 ; ---------------------------------------------------------------------
"RTN","XWBVLL",117,0)
 ;                                System Error Handler
"RTN","XWBVLL",118,0)
 ; ---------------------------------------------------------------------
"RTN","XWBVLL",119,0)
SYSERR ; -- log & send system error message
"RTN","XWBVLL",120,0)
 ;p41-don't new $Etrap, it was causing infinite loop.
"RTN","XWBVLL",121,0)
 ;p34-added "BrokerM2M" in message type in SYSERR.
"RTN","XWBVLL",122,0)
 ;   -halt for read/write errors
"RTN","XWBVLL",123,0)
 ;
"RTN","XWBVLL",124,0)
 N XWBDAT,XWBMSG ;,$ETRAP ;*p41
"RTN","XWBVLL",125,0)
 S $ETRAP="D ^%ZTER HALT" ;If we get an error in the error handler just Halt
"RTN","XWBVLL",126,0)
 ;
"RTN","XWBVLL",127,0)
 S XWBMSG=$$EC^%ZOSV ;Get the error code
"RTN","XWBVLL",128,0)
 D ^%ZTER ;Save off the error
"RTN","XWBVLL",129,0)
 ;
"RTN","XWBVLL",130,0)
 S XWBDAT("MESSAGE TYPE")="Gov.VA.Med.BrokerM2M.Errors" ;*34
"RTN","XWBVLL",131,0)
 S XWBDAT("ERRORS",1,"CODE")=1
"RTN","XWBVLL",132,0)
 S XWBDAT("ERRORS",1,"ERROR TYPE")="system"
"RTN","XWBVLL",133,0)
 S XWBDAT("ERRORS",1,"CDATA")=1
"RTN","XWBVLL",134,0)
 S XWBDAT("ERRORS",1,"MESSAGE",1)=$P($TEXT(SYSERRS+1),";;",2)_XWBMSG
"RTN","XWBVLL",135,0)
 ;
"RTN","XWBVLL",136,0)
 ;*p34-will halt for read/write errors
"RTN","XWBVLL",137,0)
 I XWBMSG["<READ>" D:$G(XWBDEBUG)  HALT
"RTN","XWBVLL",138,0)
 . ; log read error if debugging is on
"RTN","XWBVLL",139,0)
 . N XWBENAME ; name of error
"RTN","XWBVLL",140,0)
 . I XWBDEBUG=1 D  ; if debug=1, "on"
"RTN","XWBVLL",141,0)
 . . S XWBENAME="Error"
"RTN","XWBVLL",142,0)
 . E  D  ; if debug=2 or 3, "verbose" or "very verbose"
"RTN","XWBVLL",143,0)
 . . S XWBENAME="Error: "_$G(XWBDAT("ERRORS",1,"MESSAGE",1))
"RTN","XWBVLL",144,0)
 . N XWBARRAY ; error array, usually empty & not passed
"RTN","XWBVLL",145,0)
 . N XWBANAME S XWBANAME="" ; name of error array to pass
"RTN","XWBVLL",146,0)
 . I XWBDEBUG=3 D  ; if debug="very verbose"
"RTN","XWBVLL",147,0)
 . . M XWBARRAY=XWBDAT ; include the whole error type message
"RTN","XWBVLL",148,0)
 . . S XWBANAME="XWBARRAY" ; set name to pass
"RTN","XWBVLL",149,0)
 . D LOG^XWBDLOG(XWBENAME,XWBANAME) ; log the error
"RTN","XWBVLL",150,0)
 ;
"RTN","XWBVLL",151,0)
 D ERROR^XWBUTL(.XWBDAT) ; transmit XML error message to client
"RTN","XWBVLL",152,0)
 ;
"RTN","XWBVLL",153,0)
 D UNWIND^%ZTER ;Return to NXTCALL loop
"RTN","XWBVLL",154,0)
 L  ;Clear locks *p34
"RTN","XWBVLL",155,0)
 ;
"RTN","XWBVLL",156,0)
 QUIT  ; end of SYSERR
"RTN","XWBVLL",157,0)
 ;
"RTN","XWBVLL",158,0)
 ;
"RTN","XWBVLL",159,0)
SYSERRS ; -- application errors
"RTN","XWBVLL",160,0)
 ;*p34-removed the quotes (") after 'M:'
"RTN","XWBVLL",161,0)
 ;;A system error occurred in M:
"RTN","XWBVLL",162,0)
 ;
"RTN","XWBVLL",163,0)
 ;
"RTN","XWBVLL",164,0)
EOR ; end of routine XWBVLL
"VER")
8.0^22.0
**END**
**END**
