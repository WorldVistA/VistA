=======================
OSEHRA Testing Changes
=======================

When using the ``TEST_VISTA_SETUP`` option of the OSEHRA Testing Harness,
certain routines are replaced during the run of the process.  This replacement
was used to eliminate platform-specific functionality from being
executed.

Each of these changes are added to the system via the import of a ``.ro`` file
which brings along a single routine to add to the system.  The ``.ro`` file has
two parts to its name, one of which determines when the import is to happen.
The first part of the ``.ro`` file is the name of the routine that it imports
followed by a period.  The next part should be one of two strings:

* all

  * If the routine should be installed in all M[UMPS] environments

* gtm

  * if the routine should only be installed on a GT.M system


For example, the ``XINDX2.gtm.ro`` file will import the ``XINDX2.m`` routine and
it will only be installed on a GT.M system.  ``DPTLK7.all.ro`` will import the
``DPTLK7.m`` routine and will be installed in both Cache and GT.M.

Each of the installed routines has a comment block which spans the length of
each change.  The comment block has information about the person who made the
change and the purpose of that change.


ZTLOAD1
-------

**The ZTLOAD1 routine is only replaced on GT.M systems**

Problem
++++++++

The ZTLOAD1 routine is replaced to eliminate a disparity in how the transaction
processing happens between a Cache and a GT.M system.  This was a known problem
to the open source community that presented itself when attempting to `add a
user`_ to the VistA system.  A JIRA issue for this problem can be found on the
`ZTLOAD1 OSEHRA JIRA tracker`_.

Solution
++++++++

The solution for this was to comment out the transaction start, ``TSTART``,
which was found in the ``RECORD`` entry point and the transaction commit,
``TCOMMIT``, found in the ``SCHED`` entry point.

XINDX2
-------

**The XINDX2 routine is only replaced on GT.M systems**

Problem
++++++++

The XINDX2 routine has a entry point, ``OBJTST`` which it uses to determine if
a Cache class object is present on the local system.  This entry point causes
the XINDEX tool to crash on the GT.M platform due to the absence of these
classes.

An issue tracker item for this problem can be found on the `XINDX2 OSEHRA JIRA
tracker`_

Solution
++++++++

To prevent the crash from occurring OSEHRA has added the following
lines at ``OBJTST+1^XINDX2``::

  ;; Begin Change (OSEHRA/JL) Return 1 for non-Cache system
  Q:^%ZOSF("OS")'["OpenM" 1
  ;; END Change (OSEHRA/JL)

This stops the processing of the entry point by returning the value of 1 if the
``OS`` of the system does not contain the "OpenM" string.  This will prevent
the checking of Cache classes on systems that are not of the Cache type.


DPTLK7
-------

Problem
++++++++

A recent patch to the Registration package introduced a new prompt in the
Patient Registration process.  It asks for the user to perform an
Enterprise Search to check for duplicate patients.  This uses a Cache class to
call out to a web service for the check and registration is blocked unless this
query is performed.

The information about the patch which introduced this error and the other
information uncovered during the debugging can be found on the `DPTLK7 OSEHRA
JIRA tracker`_


Solution
+++++++++

The change made to the routine consists of commenting out a series of lines
which will lead to the calling of the Cache Classes.  Specifically, the changes
are to comment out lines which will call to the MPI.  OSEHRA comments out calls
to ``MPIADD`` and ``PATIENT^MPIFXMLP`` in the ``PROMPT^DPTLK7`` entry point.

These occurrences are
marked with a comment structure like the one above::

  ; OSEHRA Change by J. Snyder <http://issues.osehra.org/browse/OAT-189>
  ; Commented out the following line(s)
  ; D PATIENT^MPIFXMLP(.DGMPIR,.DGMPI)
  ; end OSEHRA Change

This eliminates the calls to the MPI framework and allows the patient
registration to continue.

.. _`ZTLOAD1 OSEHRA JIRA tracker`: http://issues.osehra.org/browse/OAT-14
.. _`XINDX2 OSEHRA JIRA tracker`: http://issues.osehra.org/browse/OAT-95
.. _`DPTLK7 OSEHRA JIRA tracker`: http://issues.osehra.org/browse/OAT-189
.. _`add a user`: https://www.osehra.org/discussion/locking-problem-gtm
