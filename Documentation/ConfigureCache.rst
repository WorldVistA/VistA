=================
Configure Caché
=================

.. role:: usertype
    :class: usertype


All of the configuration steps are performed from the Caché terminal. Right
click on the Caché icon and select terminal from the pop-up to bring up a
Caché terminal.

The first step is to change from the default \"USER\" namespace to the
namespace that that was previously created. Enter \"D ^%CD\" to bring up a
prompt to accept the name of the new namespace that you want to enter. For
demonstration purposes, we will assume that the namespace is called \"VISTA\".


.. parsed-literal::

  USER> :usertype:`D ^%CD`

  Namespace: :usertype:`VISTA`
  You're in namespace VISTA
  Default directory is c:\\intersystems\\trycache\\mgr\\vista\\
  VISTA>

It is necessary to alter two devices within the File Manager. First, the $I
value of the TELNET device needs to be changed to let the Caché terminal
function as a display for the XINDEX routine.

The first step is to identify yourself as a programmer and gain permissions to
change the file attributes.  Enter \"S DUZ=1 D Q^DI\" to first get access to
the File Manager and then to start the File Manager. At the ``Select OPTION``
prompt, enter \"1\" to edit the file entries. Next, at the ``INPUT TO WHAT FILE:``
prompt, enter the word \"DEVICE\". And, finally, at the ``EDIT WHICH FIELD:`` prompt,
enter \"$I\". Enter <Enter> to end the field queries.

The system will respond with a ``Select DEVICE NAME:`` prompt, enter \"TELNET\" to
bring up an option menu and then enter the option that does not reference GT.M
or UNIX. When the system responds with ``$I: TNA//``, enter \"\|TNT\|\", and
press enter.


.. parsed-literal::

  VISTA> :usertype:`S DUZ=1 D Q^DI`

  VA FileMan 22.0

  Select OPTION: :usertype:`1`

  INPUT TO WHAT FILE: :usertype:`DEVICE`
  EDIT WHICH FIELD: ALL// :usertype:`$I`
  THEN EDIT FIELD: :usertype:`<ENTER>`

  Select DEVICE NAME: :usertype:`TELNET`
       1  TELNET    TELNET    TNA
       2  TELNET   GTM-UNIX-TELNET    TELNET   /dev/pts
  CHOOSE 1-2:  :usertype:`1`
  $I: TNA// :usertype:`|TNT|`


Next, the $I value of terminal (TRM) device needs to be changed to allow the
default IO device to work. On the next ``Select DEVICE NAME:`` prompt, enter
\"TRM\". After the ``$I: TRM//`` prompt, enter \"\|TRM\|:\|\". Finally, press
enter until the namespace prompt (in this case VISTA>) is reached.


.. parsed-literal::

  Select DEVICE NAME: :usertype:`TRM`
  $I: TRM// :usertype:`|TRM|:\|`

  Select DEVICE NAME: :usertype:`<ENTER>`
  Select OPTION:  :usertype:`<ENTER>`

  VISTA>
