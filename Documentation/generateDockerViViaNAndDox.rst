===========================================================================
Instructions for Using Docker to Generate ViViaN and DOX
===========================================================================

.. sectnum::

This document describes the steps required to generate the Visualizing VistA
and Namespace (ViViaN) tool and the Visual Cross Reference Documentation (DOX)
pages utilizing a set of OSEHRA developed Docker scripts.  These scripts are
provided to minimize the set up work necessary and automate the generation of a
copy of ViViaN and the DOX pages.

See `Generate ViViaN and DOX`_ for detailed steps.

The scripts will

* Provision a Rocky Linux container
* Install Intersystems IRIS from supplied installer
* Export the VistA code from a given IRIS.DAT file
* Execute the tasks to generate the ViViaN and DOX pages
* Install Apache web server
* Clone ViViaN repository and set up data for viewing

Prerequisites
**************

Required Tools
--------------

+-----------------------------+---------------------------------------------------------------+
|    Tools                    |                        Web Link                               |
+-----------------------------+---------------------------------------------------------------+
| Docker (Community Edition)  | https://www.docker.com/community-edition                      |
+-----------------------------+---------------------------------------------------------------+
|       Git                   | www.git-scm.com                                               |
+-----------------------------+---------------------------------------------------------------+

Source Files
------------

The scripts expect three files to be supplied in order to set up the environment:

+--------------------------------+---------------------------------------------------------------+
|    Input file                  |                        Description                            |
+--------------------------------+---------------------------------------------------------------+
|         IRIS.DAT               | A .dat file which contains the VistA instance to display      |
+--------------------------------+---------------------------------------------------------------+
|         IRIS.key (optional)    | A license file for the IRIS instance                         |
+--------------------------------+---------------------------------------------------------------+
| IRIS-<version>lnxrh8x64.tar.gz | An IRIS install zip file for RedHat Linux                     |
|                                | **Must contain a irisinstall_silent file to be executed,**    |
|                                | (Tested using the 2023.3.0.254.0 version)                     |
+--------------------------------+---------------------------------------------------------------+


Docker Set Up
--------------

OSEHRA recommends that the settings of the default Docker container be updated
prior to executing these scripts. The testing machines were built with the
following settings:

+-----------------+--------------------------------------------------------+
|  Setting        |   Value                                                |
+-----------------+--------------------------------------------------------+
|  CPUs           |    9                                                   |
+-----------------+--------------------------------------------------------+
|  Memory         |    9000MB                                              |
+-----------------+--------------------------------------------------------+
| Disk Image size |    200GB                                               |
+-----------------+--------------------------------------------------------+

For information on how to set these parameters, see the following URL:

  https://docs.docker.com/config/containers/resource_constraints/

or access the "Advanced" section from the "Settings" on Docker for Windows.


Tool Generation
***************

OSEHRA Source Repository
------------------------

+-----------------+--------------------------------------------------------+
|   Code Bases    |   Web Link                                             |
+-----------------+--------------------------------------------------------+
|  docker-vista   |    https://github.com/WorldVistA/docker-vista          |
+-----------------+--------------------------------------------------------+

Use Git to make a local clone of the docker-vista repository.

.. parsed-literal::

  $ git clone https://github.com/WorldVistA/docker-vista.git
  Cloning into 'docker-vista'...
  .
  .
  .

Place Source files
------------------

Now that the repository has been cloned, copy the three Cache source files from
the above table into the ``docker-vista/iris-files`` directory.

The testing instances used had the following ``iris-files`` directory:

.. parsed-literal::

  $ ls iris-files
    IRIS.DAT
    IRIS_Community-2023.3.0.254.0-lnxrh8x64.tar.gz

Execute Docker Build
--------------------

**This process will take several hours and should not require the user to
interact with the process.**

The Docker command to execute the building of the files is as follows. The only
argument in the following command that can be modified by the user is the value
given to the ``-t`` flag. This will be used as the tag of the image and will be
referenced when starting the image in a container.

.. parsed-literal::

  docker build --progress=plain --no-cache --build-arg flags="-c -b -v -p ./Common/vivianPostInstall.sh" --build-arg entry="/opt/irissys" --build-arg instance="foia" -t irisviv .

Docker will then execute the commands in the DockerFile, culminating in a
Docker image which has all of the necessary programs and files to view the
ViViaN and DOX pages via a web browser.

The script will describe each step as the Docker process runs and will print a
large amount of information to the terminal window. A snippet of the run looks
as below:

.. parsed-literal::

  Sending build context to Docker daemon  4.064GB
  Step 1/23 : FROM rockylinux:8.9
   ---> 2d194b392dd1
  Step 2/23 : RUN echo "multilib_policy=best" >> /etc/yum.conf
   ---> Using cache
   ---> 5ee20b2f2935
  Step 3/23 : RUN yum  -y update &&     yum install -y gcc-c++ git xinetd perl curl python openssh-server openssh-clients expect man python-argparse sshpass wget make cmake dos2unix which unzip lsof net-tools || true &&     yum install -y http://libslack.org/daemon/download/daemon-0.6.4-1.i686.rpm > /dev/null &&     package-cleanup --cleandupes &&     yum  -y clean all
   ---> Running in 80cf308fdc58
  Loaded plugins: fastestmirror, ovl
  Determining fastest mirrors
   * base: mirror.wdc1.us.leaseweb.net
   * extras: mirror.cogentco.com
   * updates: mirror.clarkson.edu
  Resolving Dependencies
  --> Running transaction check
  ---> Package libgcc.x86_64 0:4.8.5-16.el7_4.1 will be updated
  ---> Package libgcc.x86_64 0:4.8.5-16.el7_4.2 will be an update
  ---> Package libstdc++.x86_64 0:4.8.5-16.el7_4.1 will be updated
  ---> Package libstdc++.x86_64 0:4.8.5-16.el7_4.2 will be an update
  ---> Package systemd.x86_64 0:219-42.el7_4.7 will be updated
  ---> Package systemd.x86_64 0:219-42.el7_4.10 will be an update
  ---> Package systemd-libs.x86_64 0:219-42.el7_4.7 will be updated
  ---> Package systemd-libs.x86_64 0:219-42.el7_4.10 will be an update
  ---> Package tzdata.noarch 0:2018c-1.el7 will be updated
  ---> Package tzdata.noarch 0:2018d-1.el7 will be an update
  --> Finished Dependency Resolution

  Dependencies Resolved

  ================================================================================
   Package             Arch          Version                 Repository      Size
  ================================================================================
  Updating:
   libgcc              x86_64        4.8.5-16.el7_4.2        updates         98 k
  .
  .
  .

When the command returns, after the 23rd step, the image has been built and can
be started in a Docker container with the next command.

Start Docker Container
**********************

To run the recently built image in a Docker container, we execute a command in
the ``docker-vista`` directory again. This command forwards a series of ports on
the host machine to ports on the running container. This is done to allow:

* SSH access to the Docker container
* viewing of the Cache Management Portal
* access the web server that is on the container.

The final argument given to the command is the tag of the image built in the
previous step. If you changed the tag there, ensure that it is changed here a
well.


.. parsed-literal::

  docker run -p 2222:22 -p 57772:57772 -p 3080:80 -d --name=vivianvista vivian

An explanation of the arguments to the command is broken down here:

+-----------------------------+---------------------------------------------------------------+
|   Argument                  |                        Explanation                            |
+-----------------------------+---------------------------------------------------------------+
| -p HostPort:ContainerPort   | Forwards the port of the host system to the port of the       |
|                             | running container                                             |
+-----------------------------+---------------------------------------------------------------+
|       -d                    | Starts the container and run it in the background             |
+-----------------------------+---------------------------------------------------------------+
|       --name                | Container name (used when stopping or starting containers)    |
+-----------------------------+---------------------------------------------------------------+
|       tag                   | Tag specified when ``docker build`` was run                   |
+-----------------------------+---------------------------------------------------------------+

In most setups, the user should not need to modify the port forwarding
commands. If the host port is in use, modifiy the first number of the pair to
an available port.

The initial return of the command is simply the ID of the started container.

.. parsed-literal::

  $ docker run -p 2222:22 -p 57772:57772 -p 3080:80 -d --name=vivianvista viviandocker
    d8b6e1b46aa7

The Docker container can be verified as running by executing the ``docker ps``
command to display running tasks. An example of the output after running the
command above is shown here:

.. parsed-literal::

  $ docker ps
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                                                                                          NAMES
  d8b6e1b46aa7        vivian              "/bin/sh -c /opt/cac…"   2 hours ago         Up 2 hours          0.0.0.0:8001->8001/tcp, 0.0.0.0:8080->8080/tcp, 0.0.0.0:9430->9430/tcp, 0.0.0.0:57772->57772/tcp, 0.0.0.0:2222->22/tcp, 0.0.0.0:3080->80/tcp   vivianvista

Review the Results
******************

Once the container is up and running, the HTML pages of ViViaN and DOX can be
accessed from a web browser on the host system. A container run using the above
command would be accessed through the following URLs:

ViViaN:

.. parsed-literal::

   http://localhost:3080/vivian/

or the DOX pages:

.. parsed-literal::

   http://localhost:3080/dox/

.. _`Generate ViViaN and DOX`: ./generateViViaNAndDox.rst

Deploying Vivian on a Public Server from the Docker Container
*************************************************************
Go inside the container and tar the server root:

.. parsed-literal::

   docker exec -it vivianvista bash
   cd /var/www/html/
   tar -czvf /vivian-April2023.tgz ./*

Copy them out from the docker container on your Linux machine:

.. parsed-literal::

   docker cp cache:/var/www/html/vivian-April2023.tgz /home/nancy

Move the ``tgz`` to the destination public server, and unzip at the website root, e.g.
(assuming the website root is ``/var/www/html/vivian/``):

.. parsed-literal::

   mkdir /var/www/html/vivian; tar xzvf vivian-April2023.tgz -C /var/www/html/vivian/

Vivian does not come with an ``index.html`` page. You have to either supply your own or
symlink an ``index.php`` to ``vivian/index.php``.
