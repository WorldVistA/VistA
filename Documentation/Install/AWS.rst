AWS EC2 Vagrant Configuration
=============================

.. role:: usertype
    :class: usertype

Vagrant allows for pluggable providers for Virtual Machines (VMs). Among the
providers is a Amazon Web Services (AWS) Elastic Compute Cloud (EC2) provider.
This uses EC2 to provision a VM that can then be used to install VistA onto.

Vagrant will interact with EC2 using the publicly available Application
Programming Interfaces (APIs) to create a VM from scratch.

Requirements
------------

 * A `Amazon Web Services`_ account

 * All of the basic requirements for Vagrant_

 * An SSH Public/Private keypair generated from the AWS console

Setup
-----

The Vagrant file uses environment variables to provide the configuration of
Amazon EC2 specific configuration (so Vagrantfile modifications shouldn't be
necessary). The environment variables are:

 * AWS_ACCESS_KEY_ID: Your AWS access key

 * AWS_SECRET_ACCESS_KEY: Your AWS secret access key

 * AWS_KEYPAIR_NAME: Name of the keypair you want to use generated from AWS

 * AWS_PRIVATE_KEY: Used to connect the remote VM from the local host. This
   should be a path to a private key (ex: ~/.ec2/primary.pem).

The Vagrantfile defaults to creating a t1.micro instance (smallest available),
Ubuntu 12.04 LTS 64 bit VM in us-east-1.

An easy way of setting up these variables is to run the setupEC2.sh command in
the VistA/Scripts/Install/Ubuntu directory and answer the prompts with the
correct answer (the script does no validation - it blindly takes your input).
The script will create a EC2.sh file that can be sourced so it will setup your
environment variables without hand setting them every time. You can also re-run
setupEC2.sh at any time to use new values (it will overwrite your existing
EC2.sh).

Configuration
-------------

To provision a new EC2 instance you need to set the above environment variables.

.. parsed-literal::

    ~$ :usertype:`cd Development/VistA/Scripts/Install/Ubuntu`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export AWS_ACCESS_KEY_ID="YourAccessKeyID"`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export AWS_SECRET_ACCESS_KEY="YourSecretAccessKey"`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export AWS_KEYPAIR_NAME="YourKeypairName"`
    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`export AWS_PRIVATE_KEY="PathToYourPrivateKey"`

After these environment variables are setup you can then "vagrant up" a new VM.

Note: You can only have one Vagrant VM running at a time regardless of provider
(VirtualBox, Rackspace, etc.)

.. parsed-literal::

    ~/Development/VistA/Scripts/Install/Ubuntu$ :usertype:`vagrant up --provider=aws`

You should be able to see in the EC2 interface the creation of a new VM. The
console will also reflect what is going on, and should look similar to
VirtualBox provisioning.


.. _`Amazon Web Services`: http://aws.amazon.com/
.. _Vagrant: Vagrant.rst
