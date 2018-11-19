## Introduction
This is a bug fix release. It adds no new functionality. Bugs are fixed in ZSY,
ZOSVGUX, ZISHGUX, and XPDUTL.

Authored on 10/22/2018 by Sam Habiel; licensed under Apache 2.0.

## Download Location
https://github.com/shabiel/Kernel-GTM/releases/tag/XU-8.0-10004. You can either
get the unified build that installs 10001, 10002 and 10004; just 10004 if you
are keeping up to date; or `virgin_install.zip` zip file to install in instances
where KIDS is not operational yet. The zip file is cumulative of all the Kernel
Changes.

## Install Instructions
Minimum GT.M Version: 6.1
Minimum Cache Version: 2014.1

NB: This is the last version that will support GT.M 6.1. All the next versions
will require V6.3-001A as the mimimum version.

See the list of external dependencies first before installing.

No pre-install; no post-install instructions.

Normal KIDS install. The multibuild installs XU\*8.0\*10001 & 10002 as well.
It's safe to reinstall. Please see the instructions for XU\*8.0\*10001 for
warnings, esp regarding the renaming of Taskman Site Parameters.

## Special Notes
None

## Options Affected
None

## Package Usage
This just updates the infrastructure. Users do not interact with this package
per se, except for using ZSY (see Documentation section).

## Documentation
See the documentation folder for documentation for the new APIs in %ZISH,
RETURN^%ZOSV, and on how to use ^ZSY. The rest of the APIs are documented in
the VA manual found on the VDL
(https://www.va.gov/vdl/documents/Infrastructure/Kernel/krn8_0dg.pdf)

## Error Codes
### %ZISH
* `,U-INVALID-DIRECTORY,` - Default directory does not exist. Fix Kernel Primary HFS Directory.
* `,U-ERROR,` - If GTM/YDB says region doesn't exist for a global. Should never happen.
### ZSY
* ",U-lsof-or-other-not-found," - lsof command not found. On Cygwin, maybe something else. Install lsof.
### %ZOSV
* ",U255," - $$RTNDIR^%ZOSV failed to find a routine directory. Check your $gtmroutines variable.

## Internal Interfaces
This is a kernel package and it has a large amount of published and unpublished
APIs supplied by the Kernel.

## External Interfaces
The following system utilities must be present.

* `lsof` (GT.M only)
* `ps` (GT.M only)
* `awk` (GT.M/Cygwin Only)
* `openssl` (all)
* `shasum` (GT.M only)
* `xxd` (GT.M only)
* `base64` (GT.M only)
* `dig` (GT.M only)
* `ipcs` (GT.M/Linux Only)
* `rm/del` (all)
* `mv` (all)
* `wc` (GT.M/Cygwin)
* `grep` (GT.M/Cygwin)
* `stat` (all except Cache/Windows)
* `mkdir` (all)
* `wget` (all)
* `file` (all except Cache/Windows)
* `gzip` (all except Cache/Windows)
* `cut` (GT.M/Cygwin)
* `dos2unix` (all except Cache/Windows)

ON Cache/WINDOWS (not Cygwin), you need to install the latest products from here:
* Openssl for Windows: https://slproweb.com/products/Win32OpenSSL.html
* Wget for Windows: https://eternallybored.org/misc/wget/

## Change Log
### ZSY
* Look for `lsof` in `/usr/sbin` as well.
* Don't assume U variable will be present in destination processes
* DEFAULT region is not assumed to be named "DEFAULT"
* Preliminary implementation of DEBUG; not usable yet
* ZSY is much faster on Darwin now
* HALTALL bug fix--procs(i) array may not be in order; resulting in missed processes
* $ZINT of $ZINT is us, not the one in ZU.

### ZOSVGUX
* $$EC won't cut off long global references anymore due to bad parsing (used by %ZTER)
* $T +0 use for routines in order not to missing them if they contain no literals under GTM/YDB.
* DEFAULT region is not assumed to be named "DEFAULT"

### ZISHGUX
* $T +0 use for routines in order not to missing them if they contain no literals under GTM/YDB.
* Error trap in $$FTG was improved; previously, it crashed if you didn't have gtm_zquit_anyways set to 1.

### XPDUTL
* $$PATCH^XPDUTL used to be limited up to a max patch number of 999.

## Package Components
```
PACKAGE: XU*8.0*10004     Oct 23, 2018 2:05 pm                      PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: KERNEL                         ALPHA/BETA TESTING: NO

DESCRIPTION:
Authored on 10/22/2018 by Sam Habiel; licensed under Apache 2.0

Kernel fixes for Cache/GTM.

This is what's fixed:
- ZSY:
-- Look for lsof in /usr/sbin as well.
-- Don't assume U variable will be present in destination processes
-- DEFAULT region is not assumed to be named "DEFAULT"
-- Preliminary implementation of DEBUG; not usable yet
-- ZSY is much faster on Darwin now
-- HALTALL bug fix--procs(i) array may not be in order; resulting in
missed processes
-- $ZINT of $ZINT is us, not the one in ZU.

- ZOSVGUX:
-- $EC won't cut off long global references anymore due to bad parsing
-- $T +0 use for routines in order not to missing them if they contain no
literals under GTM/YDB.
-- DEFAULT region is not assumed to be named "DEFAULT"

- ZISHGUX: $T +0 use.
-- $T +0 use for routines in order not to missing them if they contain no
literals under GTM/YDB.

- XPDUTL: $$PATCH^XPDUTL used to be limited up to a max patch number of
999.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE: POST^XU810004           DELETE POST-INIT ROUTINE: No
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   XPDUTL                                         SEND TO SITE
   ZISHGUX                                        SEND TO SITE
   ZOSVGUT5                                       SEND TO SITE
   ZOSVGUX                                        SEND TO SITE
   ZSY                                            SEND TO SITE
```
## Routine Checksums
```
XPDUTL    value = 24584734
XU810004  value = 34349
ZISHGUX   value = 87467441
ZOSVGUT5  value = 2329177
ZOSVGUX   value = 48377511
ZSY       value = 414695741
```
## Unit Tests
```
FOIA201805>d ^ZOSVGUT5


 ------------------------------------------------------------ ZOSVGUT5 ------------------------------------------------------------
ZTMGRSET - ZTMGRSET Rename GTM Routines

Rename the routines in Patch 10004

ZTMGRSET Version 8.0 Patch level **34,36,69,94,121,127,136,191,275,355,446,584,10001,10003**
HELLO! I exist to assist you in correctly initializing the current account.
I think you are using GT.M (Unix)

I will now rename a group of routines specific to your operating system.
Routine:  ZOSVGUX Loaded, Saved as    %ZOSV

Routine:  ZIS4GTM
Routine:  ZISFGTM
Routine:  ZISHGUX Loaded, Saved as    %ZISH
Routine:  XUCIGTM
Routine: ZOSV2GTM
Routine:  ZISTCPS
Routine:  ZOSVKRG
Routine: ZOSVKSGE
Routine: ZOSVKSGS
Routine: ZOSVKSGD

Now to load routines common to all systems.
Routine:   ZTLOAD
Routine:  ZTLOAD1
Routine:  ZTLOAD2
Routine:  ZTLOAD3
Routine:  ZTLOAD4
Routine:  ZTLOAD5
Routine:  ZTLOAD6
Routine:  ZTLOAD7
Routine:      ZTM
Routine:     ZTM0
Routine:     ZTM1
Routine:     ZTM2
Routine:     ZTM3
Routine:     ZTM4
Routine:     ZTM5
Routine:     ZTM6
Routine:     ZTMS
Routine:    ZTMS0
Routine:    ZTMS1
Routine:    ZTMS2
Routine:    ZTMS3
Routine:    ZTMS4
Routine:    ZTMS5
Routine:    ZTMS7
Routine:    ZTMSH
Routine:     ZTER
Routine:    ZTER1
Routine:      ZIS
Routine:     ZIS1
Routine:     ZIS2
Routine:     ZIS3
Routine:     ZIS5
Routine:     ZIS6
Routine:     ZIS7
Routine:     ZISC
Routine:     ZISP
Routine:     ZISS
Routine:    ZISS1
Routine:    ZISS2
Routine:   ZISTCP
Routine:   ZISUTL
Routine:     ZTPP
Routine:     ZTP1
Routine:   ZTPTCH
Routine:   ZTRDEL
Routine:   ZTMOVE
Routine:    ZTBKC

ALL DONE.---------------------------------------------------------------------------------------------------------  [OK]   88.993ms
EC - $$EC^%ZOSV.--------------------------------------------------------------------------------------------------  [OK]    0.000ms
ZSY - RUN ZSY with lsof in sbin

GT.M System Status users on 23-OCT-18 14:09:47 - (stats reflect accessing DEFAULT region ONLY except *)
PID   PName   Device       Routine            Name                CPU Time OP/READ   NTR/NTW        NR0123    #L   %LSUCC  %CFAIL R MB*      W MB*    SP MB*
1412  22      BG-0         IDLE+3^%ZTM        Taskman ROU 1          Oct   0.00      521k/15k       13/1/0/0  0    99.73%  3.61%  0.00       0.00     0.14
2912  22      BG-0         GO+26^XMKPLQ       POSTMASTER             Oct   88761.00  87k/0k         0/0/0/0   2    76/76   0.00%  0.00       0.00     0.14
3768  mumps   BG-0         GETTASK+3^%ZTMS1   Sub 3768            14:00:46 0.00      5542/542       0/0/0/0   1    99.91%  0.00%  0.00       0.00     0.14
9716  mumps                                                       00:00:02 PROCESS NOT RESPONDING                                 0.00       0.00     0.00
13020 mumps                                                       00:00:02 PROCESS NOT RESPONDING                                 0.00       0.00     0.00
13204 22      BG-0         GO+12^XMTDT        POSTMASTER             Oct   0.00      24k/0k         0/0/0/0   2    9/9     0/12   0.00       0.00     0.14
14072 22      BG-S9000     LGTM+25^%ZISTCPS   POSTMASTER             Oct   0.00      121k/20k       10/0/0/0  2    52/52   3.15%  0.00       0.00     0.14
14976 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 14976           14:00:43 0.00      2892/277       0/0/0/0   1    100.00% 0.00%  0.00       0.00     0.14
15216 mumps   /dev/pty1    INTRPTALL+8^ZSY    Sub 15216           14:09:33 0.00      58/3           0/0/0/0   1    0/0     0/3    0.00       0.00     0.14
15528 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 15528           14:00:40 0.00      2902/278       0/0/0/0   1    99.91%  0.00%  0.00       0.00     0.14
16312 mumps   BG-0         GO+28^XMTDL        POSTMASTER          14:00:49 9090.00   9134/520       0/0/0/0   2    100.00% 0.00%  0.00       0.00     0.14
19344 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 19344           14:00:45 0.00      2862/274       0/0/0/0   1    100.00% 0.00%  0.00       0.00     0.14
19696 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 19696           14:00:41 0.00      2882/276       0/0/0/0   1    100.00% 0.00%  0.00       0.00     0.14
19868 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 19868           14:07:58 0.00      692/57         0/0/0/0   1    100.00% 0/57   0.00       0.00     0.14
21136 mumps   BG-0         GETTASK+3^%ZTMS1                       14:00:50 732.25    5887/297       0/0/0/0   1    100.00% 0.00%  0.00       0.00     0.14
21388 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 21388           14:00:47 0.00      2842/272       0/0/0/0   1    99.91%  0.00%  0.00       0.00     0.14
21452 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 21452           14:00:44 0.00      2862/274       0/0/0/0   1    100.00% 0.00%  0.00       0.00     0.14
22452 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 22452           14:00:42 0.00      2872/275       0/0/0/0   1    100.00% 0.00%  0.00       0.00     0.14

Total 18 users.
.--------------------------------------------------------------------------------------------------------------------  [OK] 1390.001ms
ACTJ - Use of $T +0.-------------------------------------------------------------------------------------------------  [OK]    0.000ms
PATCH - $$PATCH^XPDUTL, which prv accepted only 3 digits.------------------------------------------------------------  [OK]    0.000ms
MAXREC - $$MAXREC^%ZISH - $T +0....----------------------------------------------------------------------------------  [OK]    7.995ms

Ran 1 Routine, 6 Entry Tags
Checked 9 tests, with 0 failures and encountered 0 errors.
```
# Test Sites
CRH

# Future Plans
This was just a bug fix release. Development continues on KMP Port and TLS
support for VistA.
