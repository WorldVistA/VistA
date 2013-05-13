To generate the html documentation using the existing myconf.py, myindex.rst, mycode.rst:

a. run sphinx-quickstart command and answer yes (Y) to "automatically insert docstrings from modules (y/N) [n]:"
b. rename myconf.py to conf.py, myindex.rst to index.rst, and mycode.rst to code.rst
c. make clean ; make html

For reference

1. myconf.py
-- generated using sphinx-quickstart command and answering yes (Y) to "automatically insert docstrings from modules (y/N) [n]: "
-- edit as shown below

::

 # If extensions (or modules to document with autodoc) are in another directory,
 # add these directories to sys.path here. If the directory is relative to the
 # documentation root, use os.path.abspath to make it absolute, like shown here.
 sys.path.insert(0, os.path.abspath('.'))
 sys.path.insert(0, os.path.abspath('./Packages/Scheduling/Testing/RAS'))
 sys.path.insert(0, os.path.abspath('./Packages/Problem List/Testing/RAS'))
 sys.path.insert(0, os.path.abspath('./Packages/Registration/Testing/RAS'))
 sys.path.insert(0, os.path.abspath('./Testing/Functional/RAS/lib'))
 sys.path.insert(0, os.path.abspath('./Python/vista'))

2. myindex.rst
-- generated using sphinx-quickstart and then edited to include "code" reference

3. mycode.rst
-- generated manually
