===================
Vagrant Integration
===================

What is Vagrant
---------------

.. role:: usertype
    :class: usertype

Vagrant_ is an opensource application that makes setting up development
environments easy. It essentially is an automated virtual machine (VM)
provisioner which can talk to a variety of providers (VirtualBox, Rackspace,
AWS, etc.) to create a base VM and deploy the developed application within it.
Go read more about the history of vagrant here_

Why Vagrant?
------------

Vagrant fulfills the following requirements:

 * Open Source

 * Compatible with multiple VM providers including cloud providers

 * Easy to write automation scripts

 * Easy for end users to use

How do I use Vagrant?
---------------------

First you need to download and install a few utilities:

Vagrant
-------

Vagrant can be download from http://downloads.vagrantup.com/. You need to
download the correct version of vagrant according to your operating system.

The vagrant download site is organized so the latest version is always at the
top. OSEHRA has tested Vagrant 1.3.5, but there is no reason at this point
newer versions won't work.

Vagrant also shows the operating system icons to the left of the links to make
the choice easier.

You can install Vagrant at this point. It is a simple installer that you can
take the defaults through the installation process.

VirtualBox
----------

VirtualBox is an open source virtual machine provider that works with Vagrant.
VirtualBox can be downloaded from https://www.virtualbox.org/wiki/Downloads.

As with Vagrant above select the correct binary package for your operating
system. You do not need to download the Extension Pack or any other extra
packages from VirtualBox.

You can install VirtualBox at this point. It is a simple installer that you can
take the defaults through the installation process.

Git
---

To download the OSEHRA/VistA repository you need Git, which is available at
http://www.git-scm.com. Git is an open source distributed version control
system that is incredibly popular for managing the source code of projects.

On the right side of the screen there is a monitor and should display the
correct version of git for your operating system.

You can install Git at this point. It is a simple installer that you can take
the defaults through the installation process.

Clone the VistA repository
--------------------------

The VistA repository contains all of the project specific files for telling
Vagrant what to do and how to do it.

We'll begin by opening a git-bash prompt (Windows) or a bash shell (\*nix).

Note: The guides assume that you will use a git-bash or a bash shell for
all future interactions with Vagrant.

You can clone the VistA repository anywhere but for simplicity we'll clone it
into a new Development directory

.. parsed-literal::

    ~$ :usertype:`cd ~`
    ~$ :usertype:`mkdir Development`
    ~$ :usertype:`cd Development`
    ~/Development$ :usertype:`git clone https://github.com/OSEHRA/VistA.git`

This should only take a few minutes to finish.

Start the provisioning process
------------------------------

Now since we have a clone of the VistA repository we now need to provision a
new virtual machine using Vagrant. This process is automated and should take
about 30 minutes to complete.

The scripts to provision the VM are located in VistA/Scripts/Install_ and the
Vagrant file is located in VistA/Scripts/Install/Ubuntu_, since we provision an
Ubuntu Virtual Machine.

.. parsed-literal::
    ~$ :usertype:`cd Development/VistA/Scripts/Install/Ubuntu`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`vagrant up`

There will be lots of console output in green and red text. For advanced users
green text would be from standard out and red text is from standard error. Just
because text is in red it doesn't mean that there really is an error. Vagrant
will display an error message if there truly is an error. If something goes
wrong you can post a message to the OSEHRA VistA project at
http://www.osehra.org with the screen output and someone can help from there.

Accessing VistA
---------------

The VM sets up the RPC broker which is used for CPRS, Vitals, and other GUIs
and VistAlink. Regular ssh is also available. The VM will open the following
ports on VirtualBox.

Note: If you are using a cloud provider (AWS/EC2, Rackspace) you will have to
open the cloud firewall for the following ports before you begin the
provisioning process.

 * 9430 - RPC Broker

 * 8001 - VistA Link

 * 22/2222 - SSH (2222 is used for the VirtualBox provider)

The Access/Verify codes are the same used in OSEHRA automated testing.

Note: CPRS uses the RPC Broker and the correct commandline arguments for
VirtualBox are: S=127.0.0.1 P=9430. If you used a cloud provider
(Rackspace, AWS) the easist way to find out what the S= needs to be is to lookup
your DNS address in the management portal of your cloud provider.

You can also access the VM using another SSH program (ex: PuTTY) by using the
address as described in the note above and using the correct port 22 for cloud
installs and 2222 for local VirtualBox installs.

Accessing Roll-and-Scroll
-------------------------

There are two user accounts that are created automatically during the
installation process that make accessing VistA easier:

Tied user account

 * User Name: ${instance}tied

 * Password: tied

Programmer user account

 * UserName: ${instance}prog

 * Password: prog

The ${instance}tied is designed for regular VistA users to access
roll-and-scroll applications. This user is tied to the ^ZU routine.

To login as a tied user using the default osehra instance:

.. parsed-literal::

    ~$ :usertype:`ssh -p 2222 osehratied@localhost`

Then type the password above at the password prompt

The ${instance}prog is designed for programmer users to access the M prompt.
This is the equivalent of typing mumps -dir at the command line.

To login as a programmer user using the default osehra instance:

.. parsed-literal::

    ~$ :usertype:`ssh -p 2222 osehraprog@localhost`

Then type the password above at the password prompt

Note: Everytime a new vagrant VM is created a new SSH machine key is generated,
which has a new fingerprint. Some SSH clients will complain about this and will
prevent you from logging on. There are typically instructions in the error
message to resolve this connection problem.

To login as a regular linux user (with sudo privileges):

.. parsed-literal::

    ~$ :usertype:`cd Development/VistA/Scripts/Install/Ubuntu`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`vagrant ssh`

You can now use the system like any other linux box. If you need to access the
VistA environment you can perform the following command:

.. parsed-literal::

    vagrant\@vagrant-ubuntu-precise-32:~$ :usertype:`mumps -dir`

Which will give you a programmer prompt. To get to the normal VistA login
screen type the following:

.. parsed-literal::

    FOIA> :usertype:`D ^ZU`

Technical Details
-----------------

All of the magic happens in two files:

 * Vagrantfile_

 * autoInstaller.sh_

Vagrantfile
-----------

The Vagrantfile is what tells Vagrant what to do. This contains configuration
for the base Virtual Machine that will be created, for example Ubuntu 12.04
LTS, and where to get it. The Vagrantfile also contains information about the
provisioner to use (shell, chef, puppet, etc.) to use, what order, and where
the files are. Currently only the shell provisioner is used.

For more information about Vagrantfiles read the Vagrant documentation located
at http://docs.vagrantup.com/v2/vagrantfile/index.html

autoInstaller.sh
----------------

This is the script that is used by the shell provisioner. It does what the
label says - it automatically installs VistA onto a machine. This is a
non-interactive (automated) installer that will ensure the prerequsites are met
(CMake, git, etc.), install GT.M, create a VistA instance, run a dashboard
build - which will import all of the VistA routines and globals into the`
created VistA instance and will run a series of baseline tests, which will also
populate some test data into the system.

autoInstaller.sh basically chains together the scripts contained within the
parent directories in the correct order.

.. _Vagrant: http://www.vagrantup.com
.. _here: http://www.vagrantup.com/about.html
.. _Vagrantfile: https://github.com/OSEHRA/VistA/blob/master/Scripts/Install/Ubuntu/Vagrantfile
.. _autoInstaller.sh: https://github.com/OSEHRA/VistA/blob/master/Scripts/Install/Ubuntu/autoInstaller.sh
.. _Install: https://github.com/OSEHRA/VistA/tree/master/Scripts/Install
.. _Ubuntu: https://github.com/OSEHRA/VistA/tree/master/Scripts/Install/Ubuntu
