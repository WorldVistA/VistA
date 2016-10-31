.. This page's content was taken from https://www.osehra.org/page/contributor-git-instructions

======================================
OSEHRA VistA Contributor Instructions
======================================

This page documents how to develop and submit a change to the OSEHRA VistA
repository. See our `repository page`_ for repository URLs and mirrors.

Setup
-----

Before you begin, perform initial setup:

* Register OSEHRA `Code Review Access`_
* Clone the repository:

  .. parsed-literal::

    $ git clone git://code.osehra.org/VistA.git

* Run the developer setup script to prepare your work tree and create Git
  command aliases used below:

  .. parsed-literal::

    $ Scripts/`SetupForDevelopment.sh`_

Enter the Gerrit user name registered above when prompted.

Workflow
--------

Our collaboration workflow, based on topic branches, consists of three main
steps:

1. Local Development

  a. Update
  b. Create a Topic

2. Code Review

  a. Share a Topic (requires `Code Review Access`_)
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
Gerrit. Be sure you have registered for `Code Review Access`_.

Checkout the topic if it is not your current branch:

.. parsed-literal::

  $ git `checkout`_ my-topic

Check what commits will be pushed to Gerrit for review:

.. parsed-literal::

  $ git `prepush`_

Push commits in your topic branch for review by the community:

.. parsed-literal::

  $ git `gerrit-push`_

Find your change in the OSEHRA Gerrit instance and add reviewers.

Revise a Topic
++++++++++++++

If a topic is approved during Gerrit review, skip to the next step. Otherwise,
revise the topic and push it back to Gerrit for another review.

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

After a topic has been reviewed and approved in Gerrit it may be submitted to
the upstream repository.

**Only developers authorized by OSEHRA may perform this step.**

Use the "Submit Patch Set" button that appears on the change review page.

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
