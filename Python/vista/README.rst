===============
Python Modules
===============

This file contains information about the Python libraries used in the
VistA repository.

---------------------------
ParseCSVforPackagePrefixes
---------------------------

The ParseCSVforPackagePrefixes is a set of functions used to capture the
prefixes for each VistA package to create the list of routines to test
using the XINDEX utility.

It does this by parsing a supplied .csv file, typically the Packages.csv,
and finding the fields that have a "Prefixes" heading for a specific package,
except in the case of the Uncategorized package.  The prefix has a
notation on whether the prefix belongs to the package or not.  This
boolean is an exclamation point before the prefix: "!xxx".  If the exclamation
point is found, it is replaced with a single quote "'", which is the "^%RD"
routine syntax for excluding something from a list. Each prefix has a "*"
appended to capture all routines with that prefix, no matter what follows after
it.

The Uncategorized Package is an exception.  The parsing for this package does
not look for a single subset of prefixes, it captures all prefixes and reverses
the inclusion boolean.

Each of these lists of prefixes is then sorted by length and returned.
Running the file directly will print the result to the screen.

This capability can be demonstrated with the testing.csv file.  Entering the
following command::

  python ParseCSVforPackagePrefixes.py Test PackagePrefixSample.csv

will print the ordered list of prefixes for the Test package from the
PackagePrefixSample.csv that looks like this::

['ABC', "'BCD", "'DEF", "'ABCD"]

Running an "Uncategorized" with the PPMTest.csv will show the results
of the manipulation that would happen in the Uncategorized test.::

  python ParseCSVforPackagePrefixes.py Uncategorized PackagePrefixSample.csv

will use all prefixes with the inclusion boolean switched.  It prints
a list like the following:::

  ["'ABC", "'BCD", "'DEF", 'ABCD', "'CDEH", 'DEFG']
