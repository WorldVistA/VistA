OSEHRA Patch Notes for NDF*4.0*533:
===================================

PSN*4.0*533 has a potential issue with missing entries found in the
DRUG INTERACTION(#56) file.  If certain entries within the file are missing,
the post-install routine will crash.

Fix:
-----

The fix is to generate the entries that are updated as part of the KIDS
file. The entries that OSEHRA needed to update are as follows:

.. parsed-Literal::

    VISTA>S ^PS(56,1961,0)="MAGNESIUM/ZALCITABINE (DIDEOXYCYTIDINE,ddC)^255^3150^2^1^10624"
    VISTA>
    VISTA>S ^PS(56,531,0)="LOMEFLOXACIN/MAGNESIUM^3183^255^2^1^28817^3141031"
    VISTA>
    VISTA>S ^PS(56,513,0)="ENOXACIN/MAGNESIUM^2779^255^2^1^37112^3141031"

If the patch has been installed and the post-install has crashed, the entries
can be added and the install restarted to complete the installation of the
patch.