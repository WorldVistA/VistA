Howto Setup Environment to Run Python Scripts
=============================================

This document describes how to setup an environment to run python scripts.

--------------
Python Version
--------------

* `Python 2.7`_ is preferred, if not available, need at least python 2.6 with
  argument parser support. Do not use python 3.0 and up as that is not backward compatible with 2.7.

--------------
Linux Platform
--------------

No additional software setup is needed on this platform.

Please make sure:

* ``ccontrol`` is in ``$PATH`` if using InterSystems Caché.
* ``mumps``, ``mupip`` can be found using the ``$gtm_dist`` environment variable.

----------------
Windows Platform
----------------

Some additional software setup is needed on this platform.

* `pwin32 extension`_: A python windows extension used by winpexpect.
  To install python windows extension, please go to `pwin32 extension files`_ section
  and download right version of the windows installer.

* `plink`_: A command line interface to the `PuTTY`_ backend, together with winpexpect to
  interact with VistA instances via either telnet or ssh protocol.

  Just download the executable ``plink.exe`` and put it under windows ``%PATH%``.

Also make sure:

* ``ccontrol.exe`` is under windows ``%PATH%``.
* Telnet port 23 is open and directly accessible in InterSystems Caché.

.. _`Python 2.7`: http://www.python.org/download/releases/2.7.3/
.. _`pwin32 extension`: http://sourceforge.net/projects/pywin32/
.. _`pwin32 extension files`: http://sourceforge.net/projects/pywin32/files/
.. _`plink`: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
.. _`PuTTY`: http://www.chiark.greenend.org.uk/~sgtatham/putty/
