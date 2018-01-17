Howto Download Patches
======================

This document describes how to download patches from the OSEHRA FOIA VistA site.

Approach
--------

Use ``wget`` to download files automatically into a local directory mirroring
the paths found on the OSEHRA FOIA VistA site.  For this document, we will
assume files are downloaded to a directory called 'FOIA'.  While all options
shown are important, note the following in particular:

* ``--wait``: Delay between downloads to avoid hammering the server.
* ``--accept``: Download only standard patch files.
* ``--force-directories``: Store locally using the site directory structure.

Download
--------

Run shell code to generate a list of download URLs and pipe it into a wget
invocation as shown here::

 {
 echo "https://foia-vista.osehra.org/Patches%20by%20Year%20and%20Month%20Released/$year/$month1"
 echo "https://foia-vista.osehra.org/Patches%20by%20Year%20and%20Month%20Released/$year/$month2"
 } |
 wget --continue --input-file=- --recursive --wait=10 --random-wait \
      --user-agent= --execute robots=off --reject 'index.html*' --level=10 \
      --accept '*.GBL,*.GBLs,*.KID,*.KIDs,*.KIDS,*.kid,*.kids,*.TXT,*.txt,*TXTs,*.txts' \
      --no-parent --force-directories --no-host-directories --cut-dirs=1

Use exactly the ``wget`` command-line shown.  Vary only the list of URLs.
If the download fails intermittently the command may be re-run and it will
skip already-fetched files.

Cleanup
-------

Convert text files to LF-only newlines::

 find FOIA -regex '.*\.\(GBL\|GBLs\|KID\|KIDs\|KIDS\|kid\|kids\|TXT\|TXTs\|txt\|txts\)$' -print0 |
 xargs -0 fromdos

Convert large files to content links referencing external data::

 python Scripts/ConvertToExternalData.py -i FOIA

Files 1 MiB or larger will be renamed to a ".ExternalData_" staging
file.

