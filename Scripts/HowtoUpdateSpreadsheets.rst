Howto Update Spreadsheets
=========================

This document describes how to update the ``Packages/Uncategorized/*.csv`` FOIA
patch spreadsheets using the latest ``.xls`` file from the OSEHRA FOIA VistA
site.

Download
--------

Download the ``.xls`` file from the OSEHRA FOIA VistA web site for the current ``${year}``::

 wget --continue --input-file=- --user-agent='' \
  https://foia-vista.osehra.org/DBA_VistA_FOIA_System_Files/All_Listing_of_Released_VistA_Patches/${year}_Listing_of_Released_VistA_Patches.xls

Convert
-------

First, use MS Excel to convert the ``.xls`` file to ``.xlsx`` by opening the
file and saving as 'Excel Workbook'.

Next, obtain the ``xlsx2csv`` tool and hack it to recognize the VA dates::

 git clone https://github.com/dilshod/xlsx2csv.git &&
 (cd xlsx2csv && git reset --hard fa44ba6f &&
  sed -i '/  '"'"'d-mmm-yyyy'"'"'/ {p;i\
  '"'"'[$-409]d-mmm-yyyy;@'"'"' : '"'"'date'"'"',
  d}' xlsx2csv.py)

Run ``xlsx2csv`` to convert the ``.xlsx`` file to ``.csv`` format::

 python xlsx2csv/xlsx2csv.py --ignoreempty --dateformat='%Y-%m-%d' ${year}_Listing_of_Released_VistA_Patches.xlsx ${year}_Listing_of_Released_VistA_Patches.csv

Remove extra rows from end of the file by hand if desired.
