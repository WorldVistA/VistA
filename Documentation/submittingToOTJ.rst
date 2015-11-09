******************************************
Submitting to the OSEHRA Technical Journal
******************************************

Substantial code contributions such as new VistA modules or a major refactoring
of the existing code base require a submission to the OSEHRA Technical Journal
(OTJ). OTJ submissions allow for a more thorough description of the submitted
code.  It also allows community members to download, use, try, and maintain the
submitted code prior to, and independently of, its progress through the OSEHRA
Certification Process.

For submissions that are not expected to go through the OSEHRA Certification
Process, there is no minimum set of objects.  We recommend that a technical
document, such as a Business Requirements Document or Software Design Document,
accompany the submission.

For those submissions that are expected to be part of the OSEHRA Certification
Process, OSEHRA requires a minimum set of objects in order to proceed through
the evaluation:

1.  The code for the submission.  This code **must** be released under the
    `Apache 2.0`_ license in order to be considered for OSEHRA Certification.

2.  The tests for the submission.  Since OSEHRA Level 1 certification is
    reserved for legacy VA code, all new submissions are required to have
    tests. Ideally, the tests would execute using the OSEHRA Code Testing
    framework. But OSEHRA will also accept a description of any additional
    functional tests that should be carried out manually to fully test the
    system.

3.  A Technical Article that describes the functional goals of the submission,
    the use of the submission and any additional details that may help a user
    of the software and for the subsequent developers who will maintain the
    codebase.

    Technical Articles are expected to follow the style of a technical report,
    with particular focus on providing guidance for the future use and
    maintenance of the new code contribution.

Once the submission is ready, go to the OTJ and click on ``New Publication`` as
shown in Figure 1.

.. figure::
   http://code.osehra.org/content/named/SHA1/7246bd-selectNewPublication.png
   :align: center
   :alt:  OTJ Main page with New Publication highlighted

Figure 1 - OSEHRA Technical Journal home page with the "New Publication" button
indicated by the  arrow.

The submission process will walk the submitter through the required steps of
the submission process, including:

* Choosing an OTJ Issue to submit to.
* Agreeing to the open source license for the Technical Article
* Filling in the contact and general information of the submission

  * The fields marked with a star ``*`` are required for submission.


.. figure::
   http://code.osehra.org/content/named/SHA1/0f35c6-submissionInformation.png
   :align: center
   :alt:  OTJ information page for submission

Figure 2 - OSEHRA Technical Journal "Manage Submission" page

Once the information is entered, click ``Next`` at the bottom of the page to
proceed to the second page of the OTJ Submission process.

This next page is the hub where all of the objects for the submission are
uploaded to the OSEHRA Technical Journal.  The minimum set of files for a
complete submission are those mentioned above.  This page also allows for the
submission of auxiliary files. These additional files could consist of:

  * Other supporting documents, such as a major technique paper or
    additional design documentation
  * Testing Data
  * An optional developer specific logo

The upload of each file is done by selecting the proper upload type from the
dropdown menu, selecting the proper file from the local system, and then
uploading it to the OTJ.  For an upload with multiple files or directories
within the desired content: use an archival tool, such as zip or tar.zip, to
combine the files into a single archive to upload.

.. figure::
   http://code.osehra.org/content/named/SHA1/fa2f4c-submissionUpload.png
   :align: center
   :alt:  OTJ upload page with possible selections shown

Figure 3 - OSEHRA Technical Journal "Manage Files" page with selection menu expanded


**Note:** If the code is in a publicly-available Git repository, the submitter
can submit a link to the repository and the OTJ will generate a zip file from
the ``master`` branch of the given repository. Selecting the
``Github repository`` option from the upload type will prompt the user for a
URL pointing to the repository.

At the end of the process the article and code is uploaded to the OTJ and,
after approval by an OTJ Administrator, becomes available for download,
review, comments, and eventual placement onto the OSEHRA Priority Queue.


.. _`Apache 2.0`: http://www.apache.org/licenses/LICENSE-2.0
