Using a Pre-created Virtual Machine
===================================

.. role:: usertype
    :class: usertype

Some users prefer to create their own Virtual Machines (VM)s ahead of time
instead of using Vagrant to create the VM on-demand or for installing on
bare-metal.

This requires more manual steps to get started and will mostly replicate the
steps that Vagrant would have done for you automatically.

Requirements
------------

 * An Ubuntu VM (Ubuntu 12.04 LTS tested)
 * Login information for a user with sudo access (you are on your own to do the
   substitution if you login as root)
 * Familiarity with Linux

Install
-------

The script can be downloaded and executed from the git repository:

.. parsed-literal::

    ~$ :usertype:`curl https://raw.github.com/OSEHRA/VistA/master/Scripts/Install/Ubuntu/autoInstaller.sh | sudo bash`

This will download and execute the autoInstaller script using the defaults
embedded in the script.

If you would like to use some of the command line options you can do the
following:

.. parsed-literal::

     ~$ :usertype:`curl --remote-name https://raw.github.com/OSEHRA/VistA/master/Scripts/Install/Ubuntu/autoInstaller.sh`
     ~$ :usertype:`chmod +x autoInstaller.sh`

A full explanation of the command-line options of autoInstaller.sh is
available by typing ``sudo ./autoInstaller.sh -h``.

If you'd like to recreate what is done during a ``vagrant up`` in a vagrant
based install type: ``sudo ./autoInstaller.sh -e``. This will create an
instance named "osehra" and install EWD.js.

Irregardless of the option selected you will have to logout and back in for
certain changes to take effect.

Note: if you use the skip testing step no configuration will be done and you
will have to add all of the required users and patients for your configuration.

See the Vagrant_ document for more information regarding default user names,
passwords, ports, etc. that are used as defaults.

.. _Vagrant: Vagrant.rst
