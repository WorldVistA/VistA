Viewing the Results
===================

.. role:: usertype
    :class: usertype

Executing  \"ctest  \- Experimental\" or \"ctest \- Nightly,\" for example,  will upload the test results to the OSEHRA Software Quality Dashboard (http://code.osehra.org/CDash/index.php?project=Open+Source+EHR) as shown below.
Note that the entries are organized by sections for different test types, Nightly or Experimental. The site name is the name of the machine running the tests, and build name is the operating system.

.. figure:: http://code.osehra.org/content/named/SHA1/2c29c641-Dashboard.png
   :align: center
   :alt:  OSEHRA Software Quality Dashboard

The coverage results are found at the bottommost section of the dashboard page.

.. figure:: http://code.osehra.org/content/named/SHA1/6025479c-DashboardCoverageHighLight.png
   :align: center
   :alt:  OSEHRA Software Quality Dashboard with the Coverage section highlighted

Clicking on the percentage will open a new page with detailed information on the individual files
sorted by percentage of the lines of the files used and a line-by-line display of what code was executed.

.. figure:: http://code.osehra.org/content/named/SHA1/71cbd0bf-ExampleDashboardCoverage.png
   :align: center
   :alt:  Example coverage report using the SDCO21.m routine

More detailed information about the Dashboard's capabilities and displays can be found here_.

.. _here: http://public.kitware.com/Wiki/CDash:Documentation
