How to use KIDSBuildParser.py
=============================

This document describes the usage of KIDSBuildParser python module

Verify a KIDS build
-------------------

Right now it will validate

* Basic KIDS format
* Routine checksum

command::

  python KIDSBuildParser.py -i <path_to_kids_build> -v

Sample output::

  python KIDSBuildParser.py -i ../Packages/Kernel/Patches/XU_8.0_581/XU-8_SEQ-460_PAT-581.KID -v

  2013-04-03 16:52:10,384 INFO Parsing KIDS file ../Packages/Kernel/Patches/XU_8.0_581/XU-8_SEQ-460_PAT-581.KID
  XU*8.0*581, seq:460, ver:None, pre:None, env:None, post:POST^XU8P581, delEnv:False, delPost:True, delPre:False,
  dependency builds: [['XU*8.0*571', '0']]
  totalRoutine Affected:1,
  [(Name:XU8P581, checksum:23916414, expected checksum:23916414, flag:Install)
  ]
  2013-04-03 16:52:10,394 INFO ../Packages/Kernel/Patches/XU_8.0_581/XU-8_SEQ-460_PAT-581.KID is valid

Print checksum of a routine file
--------------------------------

command::

  python KIDSBuildParser.py -i <path_to_routine_file> -c

Sample output::

  $ python KIDSBuildParser.py -i ~/git/VistA-M/Packages/Kernel/Routines/XUS.m -c
  Checksum is: 31567708

Output all routines in a KIDS build
-----------------------------------

Routines are stored in the host file system under the folder based on the install name(s) of KIDS Build

command::

  python KIDSBuildParser.py -i <path_to_kids_build> -o <path_to_output_dir>

Sample output::

  $ python KIDSBuildParser.py -i ../Packages/MultiBuilds/ARCH_PILOT_PROJECT_INCREMENT_3_0.KID -o ~/tmp/ARCH_PILOT_PROJECT_3_0/

  2013-04-04 13:17:57,382 INFO Parsing KIDS file ../Packages/MultiBuilds/ARCH_PILOT_PROJECT_INCREMENT_3_0.KID
  ['ARCH PILOT PROJECT INCREMENT 3.0', 'FB*3.5*138', 'PXRM*2.0*23']
  ARCH PILOT PROJECT INCREMENT 3.0, seq:None, ver:None, pre:None, env:None, post:None, delEnv:False, delPost:False, delPre:False,
  dependency builds: None
  totalRoutine Affected:None,
  None
  FB*3.5*138, seq:None, ver:None, pre:None, env:None, post:None, delEnv:False, delPost:False, delPre:False,
  dependency builds: None
  totalRoutine Affected:1,
  [(Name:FBARCH0, checksum:26823995, expected checksum:26823995, flag:Install)
  ]
  PXRM*2.0*23, seq:None, ver:None, pre:PRE^PXRMP23I, env:None, post:POST^PXRMP23I, delEnv:False, delPost:False, delPre:False,
  dependency builds: [['FB*3.5*138', '2'], ['PXRM*2.0*20', '2']]
  totalRoutine Affected:3,
  [(Name:PXRMARCH, checksum:4665333, expected checksum:4665333, flag:Install)
  , (Name:PXRMP23E, checksum:831621, expected checksum:831621, flag:Install)
  , (Name:PXRMP23I, checksum:4131496, expected checksum:4131496, flag:Install)
  ]

Output Directory structure::

  $ ls  ~/tmp/ARCH_PILOT_PROJECT_3_0/*
  /c/Users/jason.li/tmp/ARCH_PILOT_PROJECT_3_0/FB_3.5_138:
  FBARCH0.m

  /c/Users/jason.li/tmp/ARCH_PILOT_PROJECT_3_0/PXRM_2.0_23:
  PXRMARCH.m  PXRMP23E.m  PXRMP23I.m
