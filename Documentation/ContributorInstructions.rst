.. This page's content was taken from https://www.osehra.org/page/contributor-git-instructions

======================================
OSEHRA VistA Contributor Instructions
======================================

This page documents how to develop and submit a change to the OSEHRA VistA
repository. See our `repository page`_ for repository URLs and mirrors.

Setup
-----

Before you begin, perform initial setup:

* Create `GitHub account`_
* Fork the OSEHRA/VistA Repository

  * Visit https://github.com/OSEHRA/VistA

  * Click on "Fork" button in upper-right corner

  * Elect to fork to the user's account.

* Clone the newly forked repository:

  .. parsed-literal::

    $ git clone https://github.com/<username>/VistA.git

* Run the developer setup script to prepare your work tree and create Git
  command aliases used below:

  .. parsed-literal::

    $ Scripts/`SetupForDevelopment.sh`_

Workflow
--------

Our collaboration workflow, based on topic branches, consists of three main
steps:

1. Local Development

  a. Update
  b. Create a Topic

2. Code Review

  a. Share a Topic
  b. Revise a Topic

3. Integrate Changes

  a. Merge a Topic (requires authorization by OSEHRA)
  b. Delete a Topic

Update
+++++++

Update your local master branch:

.. parsed-literal::

  $ git `checkout`_ master
  $ git `pull`_

Create a Topic
+++++++++++++++
All new work must be committed on topic branches. Name topics like you might
name functions: concise but precise. A reader should have a general idea of the
feature or fix to be developed given just the branch name.

To start a new topic branch:

.. parsed-literal::

  $ git `fetch`_ origin
  $ git `checkout`_ -b my-topic origin/master

Edit files and create commits (repeat as needed):

.. parsed-literal::

  $ edit file1 file2 file3
  $ git `add`_ file1 file2 file3
  $ git `commit`_

Share a Topic
++++++++++++++

When a topic is ready for review and possible inclusion, share it by pushing to
your GitHub fork of OSEHRA/VistA.

Checkout the topic if it is not your current branch:

.. parsed-literal::

  $ git `checkout`_ my-topic

Check what commits will be pushed to GitHub for review:

.. parsed-literal::

  $ git `prepush`_

Push commits in your topic branch for review by the community:

.. parsed-literal::

  $ git push origin HEAD

Generate Pull Request

Visit the web page of the forked repository and click the "Pull Requests" tab

.. figure::
   http://code.osehra.org/content/named/SHA1/3ef997c6-prTab.png
   :align: center
   :alt: Screenshot of website with Pull Request tab highlighted

and then click on "New pull request" button.

.. figure::
   http://code.osehra.org/content/named/SHA1/832dedce-newPr.png
   :align: center
   :alt: Screenshot of website with new pull request button highlighted

Once the page loads, select the proper forks and branches for the pull request:

+-----------------+-----------------+
|     Option      |     Value       |
+=================+=================+
|   base fork     |  OSEHRA/VistA   |
+-----------------+-----------------+
|      base       |     master      |
+-----------------+-----------------+
|   head fork     |<username>/VistA |
+-----------------+-----------------+
|    compare      |    my-topic     |
+-----------------+-----------------+

A properly set up branch would look as follows:

.. figure::
   http://code.osehra.org/content/named/SHA1/58472476-selectBranches.png
   :align: center
   :alt: Screenshot of website highlights on needed objects to create pull request

Clicking on "Create pull request" will send an email to the administrators and kick off a
CI build of the incoming branch.

Revise a Topic
++++++++++++++

If a topic is approved during code review, skip to the next step. Otherwise,
revise the topic and push it back to code for another review.

Checkout the topic if it is not your current branch:

.. parsed-literal::

  $ git `checkout`_ my-topic

To revise the 3rd commit back on the topic:

.. parsed-literal::

  $ git `rebase`_ -i HEAD~3

*(Substitute the correct number of commits back, as low as 1.)*

Follow Git's interactive instructions. Preserve the Change-Id: line at the
bottom of each commit message.

Return to the previous step to share the revised topic.

Merge a Topic
+++++++++++++

After a topic has been reviewed and approved in GitHub it may be submitted to
the upstream repository.

**Only developers authorized by OSEHRA may perform this step.**

Use the "Merge pull request" button that appears on the change review page.

Delete a Topic
++++++++++++++

After a topic has been merged upstream, delete your local branch for the topic.

Checkout and update the **master** branch:

.. parsed-literal::

  $ git `checkout`_ master
  $ git `pull`_

Delete the local topic branch:

.. parsed-literal::

  $ git `branch`_ -d my-topic

The branch ``-d`` command works only when the topic branch has been correctly
merged. Use ``-D`` instead of ``-d`` to force the deletion of an unmerged topic
branch (warning - you could lose commits).

.. _`GitHub Account`: https://github.com/join
.. _`repository page`: https://www.osehra.org/page/osehra-code-repository
.. _`Code Review Access`: CodeReviewAccess.rst
.. _`SetupForDevelopment.sh`: http://code.osehra.org/gitweb?p=VistA.git;a=blob;f=Scripts/SetupForDevelopment.sh;hb=HEAD
.. _`checkout`: http://schacon.github.com/git/git-checkout.html
.. _`pull`: http://schacon.github.com/git/git-pull.html
.. _`fetch`: http://schacon.github.com/git/git-fetch.html
.. _`checkout`: http://schacon.github.com/git/git-checkout.html
.. _`add`: http://schacon.github.com/git/git-add.html
.. _`commit`: http://schacon.github.com/git/git-commit.html
.. _`rebase`: http://schacon.github.com/git/git-rebase.html
.. _`branch`: http://schacon.github.com/git/git-branch.html
.. _`prepush`: http://code.osehra.org/gitweb?p=VistA.git;a=blob;f=Scripts/GitSetup/SetupGitAliases.sh;hb=HEAD
.. _`gerrit-push`: http://code.osehra.org/gitweb?p=VistA.git;a=blob;f=Scripts/GitSetup/SetupGitAliases.sh;hb=HEAD
