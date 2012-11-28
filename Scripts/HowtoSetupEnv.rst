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

* `pexpect`_: pexpect is used by python scripts to interact with VistA instances automatically.
  If your systems support yum or apt-get, you might be able to use::

    sudo yum install pexpect.noarch

  or::

    sudo apt-get install python-pexpect

  to install the pexpect package.
  You can also install pexpect as follows::

    wget http://pexpect.sourceforge.net/pexpect-2.3.tar.gz
    tar xzf pexpect-2.3.tar.gz
    cd pexpect-2.3
    sudo python ./setup.py install

----------------
Windows Platform
----------------

* `winpexpect`_: A version of pexpect that works under Windows.  The easiest way to install winpexpect package is to use python easy_install script::

   <path_to_python_install_dir>\Scripts\easy_install winpexpect

  You can also download source code directly from source section of `winpexpect`_ and install
  it using setup tools::

   cd <winpexpect_source_dir>
   <path_to_python_install_dir>\python setup.py install

* `pwin32 extension`_: A python windows extension used by winpexpect.
  To install python windows extension, please go to `pwin32 extension files`_ section
  and download right version of the windows installer.

* `plink`_: A command line interface to the `PuTTY`_ backend, together with winpexpect to
  interact with VistA instances via either telnet or ssh protocol.

  Just download the executable ``plink.exe`` and put it under windows ``%PATH%``.

.. _`Python 2.7`: http://www.python.org/download/releases/2.7.3/
.. _`pexpect`: http://www.noah.org/wiki/pexpect
.. _`winpexpect`: https://bitbucket.org/geertj/winpexpect/wiki/Home
.. _`pwin32 extension`: http://sourceforge.net/projects/pywin32/
.. _`pwin32 extension files`: http://sourceforge.net/projects/pywin32/files/
.. _`plink`: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
.. _`PuTTY`: http://www.chiark.greenend.org.uk/~sgtatham/putty/
