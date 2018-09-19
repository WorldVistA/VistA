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

Tutorial Video
--------------

There is a tutorial video that demonstrates this procedure in a Windows
environment on YouTube_. This is highly recommended for new users to Vagrant or
VistA.

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
top. Vagrant also shows the operating system icons to the left of the links to
make the choice easier.

You can install Vagrant at this point. It is a simple installer that you can
take the defaults through the installation process.

NOTE: OSEHRA has tested Vagrant 2.1.2 with VirtualBox 5.1.28. Other compatible
versions may be used.

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

NOTE: The guides assume that you will use a git-bash or a bash shell for
all future interactions with Vagrant.

You can clone the VistA repository anywhere but for simplicity we'll clone it
into a new Development directory

.. parsed-literal::

    ~$ :usertype:`cd ~`
    ~$ :usertype:`mkdir Development`
    ~$ :usertype:`cd Development`
    ~/Development$ :usertype:`git clone https://github.com/OSEHRA/VistA.git`

This should only take a few minutes to finish.

Install Vagrant VirtualBox Guest Additions Plugin
-------------------------------------------------

With the latest versions of VirtualBox and Vagrant the mounting of the shared
folders may fail. By adding a plugin to Vagrant the Virtualbox Guest Additions
will be automatically installed when a VM is brought up.

To install the plugin perform the following

.. parsed-literal::

    ~$ :usertype:`cd ~`
    ~$ :usertype:`vagrant plugin install vagrant-vbguest`

You may see an error that the installer "Could not find the X.Org or XFree86
Window System, skipping.". This error is ok and will not cause any issues. This
is because the created VM doesn't contain a GUI/X Window System.

Start the provisioning process
------------------------------

Now since we have a clone of the VistA repository we now need to provision a
new virtual machine using Vagrant. This process is automated and should take
about 30 minutes to complete.

NOTE: If you would like to not install the development directories by default
(necessary for the ability to re-run the testing or ImportRG.cmake) you must
manually edit the ``Vagrantfile`` located in ``Scripts/Install/Ubuntu`` and
remove the ``-e`` on line 147. It should look like:
``s.args = "-i " + "#{ENV['instance']}"``

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

NOTE: If you are using a cloud provider (AWS/EC2, Rackspace) you will have to
open the cloud firewall for the following ports before you begin the
provisioning process.

 * 9430 - RPC Broker

 * 8001 - VistA Link

 * 22/2222 - SSH (2222 is used for the VirtualBox provider)

The Access/Verify codes are the same used in OSEHRA automated testing.

NOTE: CPRS uses the RPC Broker and the correct commandline arguments for
VirtualBox are: S=127.0.0.1 P=9430. If you used a cloud provider
(Rackspace, AWS) the easist way to find out what the S= needs to be is to lookup
your DNS address in the management portal of your cloud provider.

You can also access the VM using another SSH program (ex: PuTTY) by using the
address as described in the note above and using the correct port 22 for cloud
installs and 2222 for local VirtualBox installs.

VistA User Accounts
-------------------

System Manager:

 * Access: SM1234

 * Verify: SM1234!!!

Doctor:

 * Access: fakedoc1

 * Verify: 1Doc!@#$

 * Electronic Signature: ROBA123

Nurse:

 * Access: fakenurse1

 * Verify: 1Nur!@#$

 * Electronic Signature: MARYS123

Clerk:

 * Access: fakeclerk1

 * Verify: 1Cle!@#$

 * Electronic Signature: CLERKJ123

CPRS and Other GUI programs
---------------------------

The GUIs including CPRS are available from the OSEHRA site:

http://www.osehra.org/document/guis-used-automatic-functional-testing

Accessing Roll-and-Scroll
-------------------------

There are two user accounts that are created automatically during the
installation process that make accessing VistA easier:

NOTE: by default ${instance} is osehra.

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

NOTE: Everytime a new vagrant VM is created a new SSH machine key is generated,
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

NOTE: the prompt ``OSEHRA>`` is based on the $instance variable as referenced
above.

.. parsed-literal::

    OSEHRA> :usertype:`D ^ZU`

To access the files using SFTP you must connect as the vagrant user or the
account pre created if you are using a cloud provider (EC2/Rackspace).

Shutdown Vagrant VM
-------------------

You can shutdown the VistA instance by typing ``vagrant halt`` or ``vagrant suspend``.

``vagrant halt`` will stop the created VM and shutdown the guest operating
system. To continue using the created VM type ``vagrant up`` and it will start
the VM again.

``vagrant suspend`` will "pause" the VM - save the memory and execution state
to disk. This is useful when you want to save the state you were working in
and return to it quickly. To continue using the suspended VM type
``vagrant resume``.

EWD.js integration
------------------

By default EWD.js is installed during the ``vagrant up`` process. Full
documentation and sample urls are available at the `M/Gateway`_ site. The
relevant configuration paramaters are below:

Passwords:

  * EWDMonitor: keepThisSecret!

Ports:

 * EWD.js: 8080 (https)

 * EWDRest: 8000 (https)

 * EWDVistATerm: 8081 (https)

Services:

 * EWD.js: ${instance}vista-ewdjs

   * This controls EWD.js, EWDRest, and EWDVistATerm

To control the EWD service type:

.. parsed-literal::

     ~$ :usertype:`sudo service ${instance}vista-ewdjs {start,stop,restart}`

Where ${instance} is the name of the instance and {start,stop,restart} is the
function you want to perform.

The log files for EWD.js and EWDRest are located in /home/$instance/log/:

 * ewdjs.log
 * ewdjsErr.log
 * ewdRestOut.log
 * ewdRestErr.log
 * ewdVistATermOut.log
 * ewdVistATermErr.log

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
.. _YouTube: http://www.youtube.com/watch?v=eogchJncTlc
.. _Vagrantfile: https://github.com/OSEHRA/VistA/blob/master/Scripts/Install/Ubuntu/Vagrantfile
.. _autoInstaller.sh: https://github.com/OSEHRA/VistA/blob/master/Scripts/Install/Ubuntu/autoInstaller.sh
.. _Install: https://github.com/OSEHRA/VistA/tree/master/Scripts/Install
.. _Ubuntu: https://github.com/OSEHRA/VistA/tree/master/Scripts/Install/Ubuntu
.. _`M/Gateway`: http://gradvs1.mgateway.com/download/EWDjs.pdf
