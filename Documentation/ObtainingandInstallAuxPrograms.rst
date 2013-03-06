Obtaining and Installing Auxiliary Programs
===========================================

.. role:: usertype
    :class: usertype

Testing the code requires several auxiliary programs to be available in the testing environment.
The first component is a test driver, CMake, that configures the testing system, manages the generation of automatic tests from a template, executes the tests, and reports test results to the OSEHRA Software Quality Dashboard.
In addition, some of the tests require scripting of user responses. For GT.M installations, the Linux utility Expect provides the scripting interface, while for Caché on Windows, this support is provided by the native scripting ability of the Caché Terminal.
Instructions on how to obtain and install these programs follow.

CMake testing utility
---------------------

The testing capabilities are contained within the CMake family of programs. Installers for Windows, Linux and Mac can be downloaded from: http://cmake.org/cmake/resources/software.html. Go to the website, select the appropriate binary release and follow the instructions on installing CMake.

Git
---
Git can be downloaded from http://git-scm.com. It is a \"free & open source, distributed version control system designed to handle everything from small to very large projects with speed and efficiency.\" It allows developers to create personal instances of a repository, maintain a set of local repository modifications, and contribute code back to the original repository. Standard installation scripts and documentation are available directly from the Git website.

Python
------
Python is a scripting language used to manage the packing and unpacking of the OSEHRA code base. It is free and Open Source. Python can be downloaded from http://www.python.org/download/ using the instructions on the web site.

Sikuli
-------
Optional Download:  Sikuli is a cross platform utility for test graphical user interfaces. Sikuli can be downloaded from http://sikuli.org/ using the instructions on the web site.  The VistA Functional Testing uses Sikuli to interact with a CPRS instance as a user would.  It uses a series of screenshots to find and act upon  various buttons, text fields, and icons.  At this point, CPRS only functions on a Windows operating system.  This makes the download optional for those that are using the testing on the Unix/Linux OS or those who do not plan to run the Functional Testing.

Scripting interfaces to OSEHRA codebase
---------------------------------------

The testing currently supports three types of MUMPS environments: Caché on Windows and Linux and GT.M on Linux.  Both programs use an interface to script the interaction with XINDEX.  Previously, we used two different programs(Expect, Caché Scripting) to connect to a system depending on the operating system.  Now we have created a python module, which is included in the VistA repository, that governs the connection to all three types of instances.  This simplifies the testing preparation, as only one python file can be used to test the various platforms of VistA.

The OSEHRAHelper.py_ uses two Python libraries to connect to the various instances:

* TELNET_ :  Used to connect to a Caché on Windows instance. The TELNET library is one of the standard libraries.

* PExpect_ :  Use to connect to both of the Linux variants.  This is not a library that is included in the standard Python installation, but no downloading  is necessary.  We have already included the files in the VistA Repository.

.. _TELNET: http://docs.python.org/2/library/telnetlib.html
.. _PExpect: http://www.noah.org/wiki/pexpect
.. _OSEHRAHelper.py: http://code.osehra.org/gitweb?p=OSEHRA-Automated-Testing.git;a=blob;f=lib/vista/OSEHRAHelper.py;h=efc640a8544bd187b4cdad65a1bee827b58cc4ac;hb=HEAD
