*****************************************************
Reviewing Submissions in the OSEHRA Technical Journal
*****************************************************

To pass through the OSEHRA Certification process, a submission to the OSEHRA
Technical Journal must pass through a set of two reviews.
The first context is a technical peer review and attestation of code quality.
The second context is a Software Quality Assurance (Final) review which occurs
just prior to the assigning of the OSEHRA Certification Level.

The goal of the reviews is to demonstrate that the code is: functional,
safe to install and use, and compliant to OSEHRA and other programming
standards.

Submission Page
----------------

To access the review page, go to the OTJ site, log in and select the article you
want to review.  When the article submission page is loaded, you can access the
review page for the current phase by clicking the ``Review this publication``
link. (Figure 1).

.. figure::
   http://code.osehra.org/content/named/SHA1/4d7ed4-reviewThisPublication.png
   :align: center
   :alt:  Submission page

Figure 1 - OTJ Article page with ``review this publication`` link highlighted.

This will open the review page for a particular submission. The first section
of the review page shows information about the submission, information about
the review phase that the submission is in, and the
``OSEHRA Certification Standards Matrix``. After the certification matrix, the
page contains the questions to be answered for the review along with the
summary of results for the current set of questions.

Peer Review
-----------

The first step of a submission's Certification cycle is a Peer Review. A peer
review is a necessary confirmation that the submitted code is of sufficiently
high quality so as to be eligible for OSEHRA Certification.  Peer reviews can
be made by anyone, and multiple peer reviews are allowed and encouraged.
However, at least one passing peer review must be made by a trusted individual
if the code is to be considered for progressing to the next review phase.

The general process of the review is as follows:

* The Reviewer reads the documentation provided as part of the submission to
  ensure that all necessary information is present.
* The Reviewer builds or installs the submission, as necessary, following the
  instructions in the documentation.
* The Reviewer examines the output and runs the available tests to ensure that
  the program is built/installed correctly and that the submission functions as
  expected.
* The Reviewer completes the OSEHRA Peer review questions on the OTJ page.

Each question is multiple choice and contains a free-text box where comments
can be left relating to that specific question. The questions in the Peer
review are answered with ``High``, ``Medium``, ``Low``, or ``N/A`` for how well
the submission demonstrates the topic of the question.

When all questions have been answered in a section, the corresponding topic
summary will be updated to reflect that by the filling in of the checkbox that
corresponds to that section.

.. figure::
   http://code.osehra.org/content/named/SHA1/ae58db-peerReviewPage.png
   :align: center
   :alt:  Example completed Peer Review page

Figure 2 - OSEHRA Peer Review Page

Once all questions have been answered, or if the reviewer wishes to stop and
restart the review at a later time, click the ``Save`` button to submit the
answers and comments.

When the review is completed, an OTJ Administrator will be able to revisit the
review and update the submission as necessary. If the Peer Review is
acceptable, the submission will be moved to the Final Review stage.

If the outcome of the Peer Review results in a modification to and
re-submission of the product, another Peer Review will be necessary with the
new revision.  If the update was unrelated to the review and no problems are
found with the new revision, an administrator may move a Peer Review from one
revision to another.

Software Quality Assurance (Final) Review
-----------------------------------------

A final review is a necessary confirmation that all required procedures have
been executed and the submission is complete.  Only one passing final review is
required for a submission to achieve OSEHRA Certification.  As such, final
reviews should only be made by a trusted individual who *possesses sufficient
expertise.*

The general process for the Final Review is essentially the same as the one for
the Peer Review.
* The Reviewer reads the documentation provided as part of the submission to
  ensure that all necessary information is present.
* The Reviewer builds or installs the submission, as necessary, following the
  instructions in the documentation.
* The Reviewer examines the output and runs the available tests to ensure that
  the program is built/installed correctly and that the submission functions as
  expected.
* The Reviewer completes the OSEHRA Final review questions on the OTJ page.

The questions in the Final Review have a different focus and a different
set of answers to choose from.

The questions for the Final Review consist of 8 topics, each with a single
question to answer.  Each one of the topics corresponds to a column within the
``OSEHRA Certification Standards Matrix``. As each question is considered and
the available information checked against the OSEHRA Certification Standards,
answer each question with a value of ``Level 1`` through ``Level 4``.

**Note:** When a verdict has been reached for each question, it is expected
that the reviewer selects the highest level that corresponds to that answer.
For example, if no issues are found during the installation process, select
``Level 4`` instead of ``Level 3`` for the ``Test Installation`` category.

To see more a more detailed breakdown of each level of each topic, see the
`OSEHRA Certification Standards document`_

.. figure::
   http://code.osehra.org/content/named/SHA1/e47df7-finalReviewPage.png
   :align: center
   :alt:  Final Review page

Figure 3 - OSEHRA Final Review Page

Once all questions have been answered, or if the reviewer wishes to stop and
restart the review at a later time, click the ``Save`` button to submit the
answers and comments.

When the review is completed, an OTJ Administrator will be able to revisit the
review and update the submission as necessary. From the Final Review stage, the
submission can be moved to the "Completed" stage, where it will no longer allow
users to review the submission.  At this point, the only remaining step is to
assign the submission an OSEHRA Certification value.

Determining Certification Level
-------------------------------

Once the Final Review has been fully completed and the submission has been
moved to the "Completed" phase, the OSEHRA Certification Level can be assigned.
The OSEHRA Certification Level is determined by the lowest value assigned
across all 8 categories from the Final Review summary.  The OSEHRA
Certification Level can only be assigned by an OTJ Administrator.

.. _`OSEHRA Certification Standards document`: https://www.osehra.org/sites/default/files/OSEHRA_Certification_Standards_V2.pdf
