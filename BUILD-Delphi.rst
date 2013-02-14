.. title: OSEHRA VistA Delphi Packages

============================
OSEHRA VistA Delphi Packages
============================

Use the following steps to build VistA Delphi packages from this source.

1. Install Delphi 2007 from `Embarcadero`_.
   At the time of this writing Embarcadero Delphi XE2 is the latest
   version but the license still allows installation of Delphi 2007.
   On 64-bit Windows the installer places msbuild rules in the wrong
   framework directory as discussed in `Embarcadero QC Report 54409`_.

   The suggested workaround is to copy::

    c:\Windows\Microsoft.NET\Framework\v2.0.50727\Borland.*.Targets

   to::

    c:\Windows\Microsoft.NET\Framework64\v2.0.50727\

   after the installation completes.

2. Install `CMake`_ 2.8 or higher.

3. Run a command prompt with the Delphi tools available::

    Start -> CodeGear RAD Studio -> RAD Studio Command Prompt

4. Make a build directory in this source tree::

    cd path\to\VistA-Delphi
    mkdir build
    cd build

5. This source contains CMake input files to generate build files.
   Run CMake and enable the project BUILD_DELPHI option::

    cmake .. -G"Borland Makefiles" -DBUILD_DELPHI=ON

   CMake will generate Delphi 2007 project files.

6. CMake also generates a Makefile to drive the Delphi build from the
   command line using ``msbuild``.  Run ``make``::

    make

   This will build the Delphi project files in the proper order.

7. Look for build outputs in the build tree under::

    CPRS/Bin/$(Configuration)

   where ``$(Configuration)`` is ``Debug`` or ``Release``.

.. _`Embarcadero`: http://www.embarcadero.com/
.. _`Embarcadero QC Report 54409`: http://qc.embarcadero.com/wc/qcmain.aspx?d=54409
.. _`CMake`: http://www.cmake.org
