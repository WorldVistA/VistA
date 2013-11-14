Rackspace Vagrant Configuration
===============================

.. role:: usertype
    :class: usertype

Vagrant allows for pluggable providers for Virtual Machines (VMs). Among the
providers is a Rackspace provider. This uses the Rackspace cloud to provision
a VM that can then be used to install VistA onto.

Vagrant will interact with Rackspace using the publicly available Application
Programming Interfaces (APIs) to create a VM from scratch.

Requirements
------------

 * A Rackspace_ account (A normal Cloud Account is fine)

 * All of the basic requirements for Vagrant_

 * An SSH Public/Private keypair

Setup
-----

The Vagrant file uses environment variables to provide the configuration of
Rackspace specific configuration (so Vagrantfile modifications shouldn't be
necessary). The environment variables are:

 * RS_USERNAME: Your Rackspace username (used to login to the Rackspace Cloud
   Control Panel)

 * RS_API_KEY: Found by going to your Account Settings in the Rackspace Cloud
   Control Panel)

 * RS_PUBLIC_KEY: Imported into the root account as an SSH authorized key. This
   should be a path to a public key (ex: ~/.ssh/id_rsa.pub).

 * RS_PRIVATE_KEY: Used to connect the remote VM from the local host. This
   should be a path to a private key (ex: ~/.ssh/id_rsa).

The Vagrantfile defaults to creating a 512MB VM (smallest available), Ubuntu
12.04 LTS 64 bit VM in the Chicago (ORD) Data Center.

An easy way of setting up these variables is to run the setupRackspace.sh
command in the VistA/Scripts/Install/Ubuntu directory and answer the prompts
with the correct answer (the script does no validation - it blindly takes your
input). The script will create a Rackspace.sh file that can be sourced so it
will setup your environment variables without hand setting them every time.
You can also re-run setupRackspace.sh at any time to use new values (it will
overwrite your existing Rackspace.sh).

Configuration
-------------

To provision a new Rackspace Cloud VM you need to set the above environment variables.

.. parsed-literal::

    ~$ :usertype:`cd Development/VistA/Scripts/Install/Ubuntu`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export RS_USERNAME="YourUserName"`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export RS_API_KEY="YourAPIKey"`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export RS_PUBLIC_KEY="PathToYourPublicKey.pub"`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export RS_PRIVATE_KEY="PathToYourPrivateKey"`

After these environment variables are setup you can then "vagrant up" a new VM.

Note: You can only have one Vagrant VM running at a time regardless of provider
(VirtualBox, Rackspace, etc.)

.. parsed-literal::

    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`vagrant up --provider=rackspace`

You should be able to see in the Cloud Control Panel the creation of a new VM.
The console will also reflect what is going on, and should look similar to
VirtualBox provisioning.


.. _Rackspace: https://cart.rackspace.com/cloud/
.. _Vagrant: Vagrant.rst
