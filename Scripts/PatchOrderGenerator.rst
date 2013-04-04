How to use PatchOrderGenerator.py
=================================

This document describes the usage of PatchOrderGenerator python module

Description
-----------

As the name indicates, this module is mainly used to generate a valid order to apply patches.
It will scan recursively for all valid patch files under the directory provided, generate
the dependencies graph, and output a valid patch order based on topologic sort.

Dependencies considered:

* Dependencies specified in KIDS build

* Dependencies based on KIDS installation information file

* Implicit Dependencies based on sequence number

* Explicit Dependencies specified in CSV file if there is one, sample CSV file can be found under ``/Packages/Uncategorized/``

Command::

  python PatchOrderGenerator.py <path_to_patches_dir>

Sample output::

  $ python PatchOrderGenerator.py ../Packages/Kernel/Patches/
  ......
  2013-04-19 15:36:14,633 INFO After topologic sort 40
  ({'Name': 'XU*8.0*551'}, {'Seq#': '448'}, {'KIDS': 'XU-8_SEQ-448_PAT-551.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*537'}, {'Seq#': '449'}, {'KIDS': 'XU-8_SEQ-449_PAT-537.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*567'}, {'Seq#': '451'}, {'KIDS': 'XU-8_SEQ-451_PAT-567.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*504'}, {'Seq#': '452'}, {'KIDS': 'XU-8_SEQ-452_PAT-504.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*431'}, {'Seq#': '453'}, {'KIDS': 'XU-8_SEQ-453_PAT-431.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*553'}, {'Seq#': '454'}, {'KIDS': 'XU-8_SEQ-454_PAT-553.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*560'}, {'Seq#': '455'}, {'KIDS': 'XU-8_SEQ-455_PAT-560.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*554'}, {'Seq#': '456'}, {'KIDS': 'XU-8_SEQ-456_PAT-554.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*571'}, {'Seq#': '457'}, {'KIDS': 'XU-8_SEQ-457_PAT-571.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*557'}, {'Seq#': '458'}, {'KIDS': 'XU-8_SEQ-458_PAT-557.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*569'}, {'Seq#': '459'}, {'KIDS': 'XU-8_SEQ-459_PAT-569.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*581'}, {'Seq#': '460'}, {'KIDS': 'XU-8_SEQ-460_PAT-581.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*543'}, {'Seq#': '461'}, {'KIDS': 'XU-8_SEQ-461_PAT-543.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*572'}, {'Seq#': '462'}, {'KIDS': 'XU-8_SEQ-462_PAT-572.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*570'}, {'Seq#': '463'}, {'KIDS': 'XU-8_SEQ-463_PAT-570.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*586'}, {'Seq#': '464'}, {'KIDS': 'XU-8_SEQ-464_PAT-586.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*555'}, {'Seq#': '465'}, {'KIDS': 'XU-8_SEQ-465_PAT-555.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*594'}, {'Seq#': '466'}, {'KIDS': 'XU-8_SEQ-466_PAT-594.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*535'}, {'Seq#': '467'}, {'KIDS': 'XU-8_SEQ-467_PAT-535.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*573'}, {'Seq#': '468'}, {'KIDS': 'XU-8_SEQ-468_PAT-573.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*574'}, {'Seq#': '469'}, {'KIDS': 'XU-8_SEQ-469_PAT-574.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*566'}, {'Seq#': '470'}, {'KIDS': 'XU-8_SEQ-470_PAT-566.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*591'}, {'Seq#': '471'}, {'KIDS': 'XU-8_SEQ-471_PAT-591.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*582'}, {'Seq#': '472'}, {'KIDS': 'XU-8_SEQ-472_PAT-582.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*513'}, {'Seq#': '473'}, {'KIDS': 'XU-8_SEQ-473_PAT-513.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*595'}, {'Seq#': '474'}, {'KIDS': 'XU-8_SEQ-474_PAT-595.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*590'}, {'Seq#': '475'}, {'KIDS': 'XU-8_SEQ-475_PAT-590.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*601'}, {'Seq#': '476'}, {'KIDS': 'XU-8_SEQ-476_PAT-601.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*502'}, {'Seq#': '477'}, {'KIDS': 'XU-8_SEQ-477_PAT-502.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*547'}, {'Seq#': '478'}, {'KIDS': 'XU-8_SEQ-478_PAT-547.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*587'}, {'Seq#': '479'}, {'KIDS': 'XU-8_SEQ-479_PAT-587.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*596'}, {'Seq#': '480'}, {'KIDS': 'XU-8_SEQ-480_PAT-596.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*599'}, {'Seq#': '481'}, {'KIDS': 'XU-8_SEQ-481_PAT-599.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*593'}, {'Seq#': '482'}, {'KIDS': 'XU-8_SEQ-482_PAT-593.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*604'}, {'Seq#': '483'}, {'KIDS': 'XU-8_SEQ-483_PAT-604.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*584'}, {'Seq#': '484'}, {'KIDS': 'XU-8_SEQ-484_PAT-584.KIDs'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*585'}, {'Seq#': '485'}, {'KIDS': 'XU-8_SEQ-485_PAT-585.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*598'}, {'Seq#': '487'}, {'KIDS': 'XU-8_SEQ-487_PAT-598.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*522'}, {'Seq#': '493'}, {'KIDS': 'XU-8_SEQ-493_PAT-522.KID'}, {'CSVDep': None})
  ({'Name': 'XU*8.0*602'}, {'Seq#': '494'}, {'KIDS': 'XU-8_SEQ-494_PAT-602.KID'}, {'CSVDep': None})
