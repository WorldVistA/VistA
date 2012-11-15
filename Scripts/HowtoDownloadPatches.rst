Howto Download Patches
======================

This document describes how to download patches from the VA VistA FOIA site.

Approach
--------

Use ``wget`` to download files automatically into a local ``FOIA/`` directory
mirroring the paths found on the FOIA site.  While all options shown are
important, note the following in particular:

* ``--wait``: Delay between downloads to avoid hammering the server.
* ``--accept``: Download only standard patch files.
* ``--force-directories``: Store locally using the site directory structure.

Download
--------

Run shell code to generate a list of download URLs and pipe it into a wget
invocation as shown here::

 {
 echo "https://downloads.va.gov/files/FOIA/Software/$file1"
 echo "https://downloads.va.gov/files/FOIA/Software/$file2"
 } |
 wget --continue --input-file=- --recursive --wait=10 --random-wait \
      --user-agent= --execute robots=off --reject 'index.html*' --level=10 \
      --accept '*.KID,*.KIDs,*.TXT,*.txt' \
      --no-parent --force-directories --no-host-directories --cut-dirs=1

Use exactly the ``wget`` command-line shown.  Vary only the list of URLs.
If the download fails intermittently the command may be re-run and it will
skip already-fetched files.

Cleanup
-------

Convert text files to LF-only newlines::

 find FOIA -regex '.*\.\(KID\|KIDs\|TXT\|txt\)$' -print0 |xargs -0 fromdos

Commit
------

Add the changes and commit them with the VA as author::

 git add FOIA/
 git commit --author='US DVA <va.gov>'

Mention in the commit message this instructions file and the shell code used to
produce the list of URLs piped to ``wget``.  Summarize in the first line of the
message the group of patches downloaded.
