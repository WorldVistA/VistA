Howto Update Spreadsheets
=========================

This document describes how to update the ``Packages/Uncategorized/*.csv`` FOIA
patch spreadsheets using the latest ``.xls`` files from the VA VistA FOIA site.

Branch
------

Create a branch, say ``upstream-spreadsheets``, starting from the last commit
that updated the ``.csv`` files from the FOIA site::

 base=$(git rev-list master -n 1 --author='va.gov' -- 'Packages/Uncategorized/*.csv') &&
 git checkout -b upstream-spreadsheets $base

It is important to base the update branch on a version that has no other
modifications since the last update from the FOIA site.  This way the branch
represents only the upstream changes and can be merged with changes made in
other branches instead of overwriting them.

Download
--------

Download the ``.xls`` files from the FOIA web site for some ``${year}``::

 wget --continue --input-file=- --user-agent='' \
  https://downloads.va.gov/files/FOIA/Software/DBA_VistA_FOIA_System_Files/Listing_of_Released_VistA_Patches_${year}.xls

Convert
-------

Obtain the ``xlsx2csv`` tool and hack it to recognize the VA dates::

 git clone https://github.com/dilshod/xlsx2csv.git &&
 (cd xlsx2csv && git reset --hard fa44ba6f &&
  sed -i '/  '"'"'d-mmm-yyyy'"'"'/ {p;i\
  '"'"'[$-409]d-mmm-yyyy;@'"'"' : '"'"'date'"'"',
  d}' xlsx2csv.py)

Run ``xlsx2csv`` to convert the ``.xls`` files to ``.csv`` format::

 mkdir -p Packages/Uncategorized &&
 for xls in *.xls; do
   csv="Packages/Uncategorized/${xls/xls/csv}" &&
   python xlsx2csv/xlsx2csv.py --ignoreempty --dateformat='%Y-%m-%d' "${xls}" "${csv}" &&
   fromdos "${csv}"
 done &&
 rm *.xls &&
 rm -rf xlsx2csv

Remove extra rows from end of files by hand if desired.

If xlsx2csv complains about the format, use MS Excel to convert the
.xls files to .xlsx and adjust the above command accordingly.

Commit
------

Add the changes and commit them with the VA as author::

 git add Packages/Uncategorized/*.csv
 git commit --author='US DVA <va.gov>'

Mention in the commit message this instructions file and the URL of the
``.xls`` file downloaded.

Merge
-----

Create a branch, say ``update-spreadsheets``, and merge the upstream changes::

 git checkout -b update-spreadsheets master
 git merge upstream-spreadsheets

If there are conflicts resolve them and commit with a message describing how.

Finally, push this topic for review like any other change.
