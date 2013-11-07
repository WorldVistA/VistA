Obtaining the VistA-M Source Code
=================================

.. role:: usertype
    :class: usertype

We need to retrieve the VistA-M source code (MUMPS code) that will be used to
populate Caché or GTM  and generally construct the local VistA environment.
Begin by bringing up a Git Bash terminal from the installed Git system.

.. parsed-literal::

  user@machine ~
  $

The git interface is a command-prompt interface with much of the functionality
that should be familiar to Linux users; commands like \"ls\" and \"cd\"
perform as they would in Cygwin shell or a Linux terminal. Git specific actions
are always preceded by the \"git\" command on the input line. The command
\"git --help\" displays a list of the most common commands.

.. parsed-literal::

  user@machine ~
  $ :usertype:`git --help`

  usage: git [--version] [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p|--paginate|--no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           [-c name=value] [--help]
           <command> [<args>]

  The most commonly used git commands are:
    add        Add file contents to the index
    bisect     Find by binary search the change that introduced a bug
    branch     List, create, or delete branches
    checkout   Checkout a branch or paths to the working tree
    clone      Clone a repository into a new directory
    commit     Record changes to the repository
    diff       Show changes between commits, commit and working tree, etc
    fetch      Download objects and refs from another repository
    grep       Print lines matching a pattern
    init       Create an empty git repository or reinitialize an existing one
    log        Show commit logs
    merge      Join two or more development histories together
    mv         Move or rename a file, a directory, or a symlink
    pull       Fetch from and merge with another repository or a local branch
    push       Update remote refs along with associated objects
    rebase     Forward-port local commits to the updated upstream head
    reset      Reset current HEAD to the specified state
    rm         Remove files from the working tree and from the index
    show       Show various types of objects
    status     Show the working tree status
    tag        Create, list, delete or verify a tag object signed with GPG

To obtain a copy of the repository, create a directory (Folder) to hold the
repository code and "cd" into that directory. Enter the commands

.. parsed-literal::

  $ :usertype:`git clone git://code.osehra.org/VistA-M.git`
  Cloning into 'VistA-M'...
  .
  .
  .
  $ :usertype:`cd VistA-M`

to make a local clone of the remote repository.

The following step is only required for InterSystems Caché Single-User or small
license count licenses:

Edit `ZU.m`_,  located in /Packages/Kernel/Routines/, and comment out the code
followed by JOBCHK tag by placing a semi-colon (;) right after JOBCHK tag.

.. parsed-literal::

  JOBCHK :usertype:`;` I $$AVJ^%ZOSV()<3 W $C(7),!!,"\*\* TROUBLE \*\* - \*\* CALL IRM NOW! \*\*" G H

Similarly, edit `ZUONT.m`_, also located in /Packages/Kernel/Routines/, and comment out the following code.

.. parsed-literal::

   :usertype:`;` I $$AVJ^%ZOSV()<3 W $C(7),!!,"\*\* TROUBLE \*\* - \*\* CALL IRM NOW! \*\*" G HALT

Note: If somehow ZU.m does not exist, it is OK to just make change to ZUONT.m.

.. _ZUONT.m: http://code.osehra.org/gitweb?p=VistA-M.git;a=blob;f=Packages/Kernel/Routines/ZUONT.m
.. _ZU.m: http://code.osehra.org/gitweb?p=VistA-M.git;a=blob;f=Packages/Kernel/Routines/ZU.m
