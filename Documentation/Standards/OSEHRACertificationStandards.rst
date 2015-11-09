******************************
OSEHRA Certification Standards
******************************

Adapted from here_.

Introduction
-------------

OSEHRA Open Source Software Quality Certification ("OSEHRA Certification") is a
general code evaluation framework designed to support the analysis of any size
of code submission, ranging from a bug fix/small code modification to addition
of new functionality or the certification of an entire health software system.
The certification recognizes four levels of software quality based upon eight
independent categories of certification criteria. The outcome of certification
scoring will be either a certification failure, or OSEHRA Certification at one
of the four levels. The OSEHRA Certification process is designed to evolve as
new code is submitted by the open source community and new interoperability
requirements and testing capabilities are provided. OSEHRA is prepared to work
with all community members

OSEHRA has created certification standards by which community members inspect
and certify code for compliance with standards of good software engineering
practices, which can accommodate specific VA interoperability needs; and which
also serve the needs of the open source community. These standards can be
applied to existing VistA code, which is scheduled for inclusion in the set of
OSEHRA VistA applications.

The following eight sections provide a detailed explanation of the scoring
methods that will be applied for each certification category.

Name/Number Space
-----------------

It is critical that that name space and number space designations be maintained
and enforced, particularly in M code. Overlapping of name spaces and number
spaces can potentially result in unreliable code and unforeseen consequences.
Thus, as a component of the technical evaluation, name spaces and number spaces
of code being evaluated will be compared to known allocations to ensure
appropriate usage.

Name and number space overlap evaluation will be scored on a pass/fail basis.
Issues associated with name and number space utilization will not be accepted.
Therefore all four levels of OSEHRA certification require that no issues be
identified.

Dependency/SAC
--------------

All code contributions will be tested to verify compliance with applicable
Standards and Conventions (SAC). This review will then be compared with
submitted documentation.  Any substantial discrepancy will result in rejection
of the contribution; failure to properly account for the potential impacts of a
contribution indicates that contribution is not tested enough for integration
into the core solution. It is understood that there are occasional valid
reasons for violating the SAC, but these should be identified and justified in
the documentation of the submission. As additional languages and coding styles
are brought into the community, the community will need to develop or adapt
additional style guides and automated routines to enforce the chosen style.

Dependency and SAC conformance will be evaluated on a pass/fail basis. All four
levels of OSEHRA certification require that no issues are identified for this
category.

Dependency and SAC conformance is tested for M[umps] code by the usage of the
XINDEX tool available within VistA.  Other languages will require the usage of
other programs which perform similar checks.  The Checkstyle_ program is used
for Java submissions while a Ruby submission would use something like Rubocop_.

Open Source License
-------------------

OSEHRA requires that all code submissions be made under the Apache 2 license.

Documentation
-------------

Documentation is intended to serve the needs of the OSEHRA community by
ensuring that submissions fully define the purpose, use, installation,
testing, algorithms, and other salient components of the submission.

  **Level 1** of the documentation category evaluation does not require that
  documentation is provided with the code.  This is to encourage community
  members to submit code contributions early.

  **Level 2** requires that a basic set of documentation is present which must
  include:

  * A description of the intended purpose and requirements of the codebase.
  * A description of the installation instructions of the application.
  * A description of how to test the code.

  **Level 3** requires, in addition to the documentation listed in Level 2, that
  documentation provides:

  * A description of the methods and relevant information needed to understand
    complex or difficult aspects of the code, such as complicated algorithms,
    algorithm provenance, or items that require clarification.

  **Level 4** requires that all of the documentation required up to Level 3, plus:

  * A description of ongoing or additional development work being performed on
    the codebase.

All of these may be contained in a single document such as an
OSEHRA Technical Journal article, or they may be provided separately in which
case the main document can simply be a reference to the rest of the submission.
Note that the VA has a substantial body of documentation artifacts as part of
their code development process to include the documents in the table below.
These documents are not required, but if present they can be used to meet the
documentation requirement.

+-------------------------------------------------------------------------------------------------+
|                       **Documentation Artifact Name**                                           |
+-------------------------------------------------------------------------------------------------+
| Business Requirements Document (BRD)                                                            |
+-------------------------------------------------------------------------------------------------+
| Software Requirements Specification (RSD)                                                       |
+-------------------------------------------------------------------------------------------------+
| Initial Operating Capability (IOC) Testing                                                      |
+-------------------------------------------------------------------------------------------------+
| Data Dictionary Modification Request (for Database Administrator)                               |
+-------------------------------------------------------------------------------------------------+
| Data Dictionary Modification Approval (from Database Administrator)                             |
+-------------------------------------------------------------------------------------------------+
| Integration Control Registrations (ICR)s                                                        |
+-------------------------------------------------------------------------------------------------+
| Clearance on potential impact on FDA Regulated interfaces or devices (from Package maintainers) |
+-------------------------------------------------------------------------------------------------+
| Change submission to Architecture Review Group                                                  |
+-------------------------------------------------------------------------------------------------+
| Application Self-Scoring Evaluation Support System (ASSESS) (Capacity Planning form)            |
+-------------------------------------------------------------------------------------------------+
| Patch Installation Instructions (Installation Guide)                                            |
+-------------------------------------------------------------------------------------------------+
| List of patch dependencies (Patch Release Check)                                                |
+-------------------------------------------------------------------------------------------------+
| National Patch Module Patch Template                                                            |
+-------------------------------------------------------------------------------------------------+
| Updated Documentation describing new Functionalities                                            |
+-------------------------------------------------------------------------------------------------+
| HL7 Messaging Coordinator Approval for related changes                                          |
+-------------------------------------------------------------------------------------------------+
| OED Testing Service Report                                                                      |
+-------------------------------------------------------------------------------------------------+

Code Review
-----------

A code review is one of the most effective methods for finding quality issues
in a codebase. Unfortunately, code reviews are also one of the most labor
intensive components of software quality efforts and they further require that
specialized skills from the community of developers are obtained to deeply
review the code and identify issues. As a result, OSEHRA will need to carefully
apply code review resources and spot check code under review for larger
contributions.

OSEHRA uses a combination of the Gerrit code review tool and the
OSEHRA Technical Journal for reviewing submitted code. These tools facilitate
communications and allow reviewer decisions and comments to be fully archived
for future investigations. In all cases, OSEHRA will require that critical
issues identified during code review are fixed. This includes any code
construct that could result in an incorrect calculation.

  **Level 1** of the code review category allows for the identification of
  large numbers of non-critical issues during the code review process.

  **Level 2** requires that only a small number of non-critical issues are
  found during code review.

  Finally, **Levels 3 and 4** both require that no issues are identified during
  code review.

Test Installation
-----------------

OSEHRA will install code contributions, using the provided documentation, on an
internally hosted testing instance of VistA. This instance will act as the
testing platform for OSEHRA to conduct its certification functions. OSEHRA will
verify whether the contribution properly installed or not.

  **Level 1** of the test installation category allows for the identification
  of large numbers of non-critical issues during the installation evaluation.

  **Level 2** requires that only a small number of non-critical issues are
  found during test installation.

  Finally, **Levels 3 and 4** both require that no issues are identified during
  test installation.

Regression Testing
------------------

Regression testing seeks to uncover software errors by retesting the program
after changes to the program (e.g. bug fixes or new functionality) have been
made. Some automated regression test capability is currently available to
OSEHRA. As the OSEHRA community expands, and developers become accustomed to
providing regression tests with code contributions, OSEHRA will have an
ever-growing number of automated regression tests to apply to the various
codebases. Tests from this regression testing infrastructure which are
applicable to the received code submission will be run to characterize and
document code behavior. In addition, high quality code (that which achieves the
higher levels of OSEHRA certification) should come complete with an
increasingly comprehensive set of regression tests.

  **Level 1** requires that the codebase under evaluation does not cause any
  failures in the existing set of OSEHRA automated regression tests.

  **Level 2** for the regression testing category requires that Level 1 is
  achieved and that the codebase has some additional regression tests that
  specifically test the capabilities of the codebase. These regression tests
  must be meaningful and show intent to objectively and automatically determine
  if computations are being performed correctly.

  **Level 3** builds upon Level 2 and further requires that the supplied
  regression tests achieve at least 50% code coverage for the code being
  contributed.

  **Level 4** extends upon the requirement of Level 3 and increases the code
  coverage requirement to 90%.

Functional Testing
------------------

Functional testing determines whether specific application functionality is
demonstrated within a working codebase. Although some of these tests can be
automated, significant benefits are obtained when a human observer conducts
the tests and is able to identify side effects and issues not anticipated by
the test designers. Similar to code review, manual functional testing is
highly labor intensive and is prohibitively expensive to use to check all
listed application functionality.

  **Level 1** of the functional testing category allows for the identification
  of large numbers of non-critical issues during the testing process.

  **Level 2** requires that only a small number of non-critical issues are
  found during functional testing.

  Finally, **Levels 3 and 4** both require that no issues are identified during
  functional testing.

Application of the Standards
----------------------------

Not all submissions to OSEHRA's code repository are capable, required, or
expected to meet all categories of certification criteria, and the OSEHRA
Certification Process will not be fully utilized in all cases.

For example, code reviews for the initial VistA FOIA/Enterprise submission will
not be expected to completely characterize the code, but manual review of some
source will be undertaken as a sanity check to increase confidence in the
codebase. Subsequent incremental submissions to the core modules will require
full review of source as part of the code intake process. Testing of the
current OSEHRA VistA, automated or manual, is limited due to the large codebase
involved and due to the time and effort required for generating the required
procedures and code; however, some testing has been and continues to be
submitted as part of the existing refactoring efforts and via community
contributions. Any applicable tests submitted to the testing environment will
be run against the core modules. As new or refactored components are added to
OSEHRA VistA, it is expected that additional documentation and testing
capabilities will be included in potential submissions to OSEHRA VistA and that
the OSEHRA Certification Process for OSEHRA VistA will evolve and become more
comprehensive. These newer submissions are expected to be certifiable at higher
levels, while the legacy code remains at Level 1 certification.

.. _here: https://www.osehra.org/sites/default/files/OSEHRA_Certification_Standards_V2.pdf
.. _Checkstyle: http://checkstyle.sourceforge.net/
.. _Rubocop: http://batsov.com/rubocop/
