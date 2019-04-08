Adding Korean ICD-10 To Lexicon
===============================

**Sam Habiel, Pharm.D.**/
**OSEHRA**/
**4 April 2019**

It has been a while since the last full blog post on the Plan VI project. This 
post will be the first in a series focusing on the changes needed in the VistA
M side code in order for VistA to be usable outside of the US.

This post focuses on modifying the VistA Lexicon to contain the Korean ICD-10
system in order for VistA to be usable in Korea for clinical purposes. We end
up looking at two different ways in which we can do that.

Statement of the Task
---------------------
The Korean ICD-10 system used in Korea is known as KCD-7. We wanted to be able
to use KCD-7 in CPRS for encounters instead of ICD-10-CM-US. The KCD-7 I was
provided only included diagnoses, not the ICD-10 procedures. So my focus was
only on diagnoses.

I was supplied a spreadsheet of the KCD-7 codes. Here's a screenshot


.. figure::
   images/lexicon-01-KCD7-original-spreadsheet.png
   :align: center
   :alt: KCD-7

   KCD-7
   
Research on how to Update ICD-10 Codes
--------------------------------------
Before starting translation of the US entries, I did some research on how the
ICD-10 codes are updated. I was lucky in finally receiving (after many attempts)
a response to a FOIA request from the VA on the code that updates the Lexicon.
I also was lucky in knowing a developer who worked on the Lexicon, who was able
to answer some of the questions on some processes not documented in the code.

The FOIA response is a zip file `over here
<https://github.com/OSEHRA-Sandbox/VistA-M/releases/download/kcd7/LEXFOIA_ICD-10_scrubbed.zip>`_.
For ease of reference, I extracted all the routines into the
`reference-lex-icd10-code <./reference-lex-icd10-code/>`_ folder.

Here's a table of my summary exploration of the code.

==============                      =========
Routine                             Purpose  
==============                      =========
^ZZLEXX (MAIN -> CS -> DIA)         Menus
LOAD^ZZLEXXAA                       Main Driver
ZZLEXXAM (PATH, OPEN, CLOSE)        File system operations (paths hardcoded)
NTO^ZZLEXXAM                        Comparison
FILE^ZZLEXXAC                       Main Updater
EN^ZZLEXMD                          Update Counts
==============                      =========

For me, the most important part of this code is FILE^ZZLEXXAC. So here's a
detailed breakout of this code.

+------------+----------------------------------------------------------+
| Tag        | Description                                              |
+============+==========================================================+
| CODE       | Add ICD-10 Code to File 80                               |
+------------+----------------------------------------------------------+
| STAT       | Update 80/66 (Status Multiple)                           |
+------------+----------------------------------------------------------+
| SHORT      | Update 80/67 (Short Description Multiple)                |
+------------+----------------------------------------------------------+
| LONG       | Update 80/68 (Long Description Multiple)                 |
+------------+----------------------------------------------------------+
| LEX^ZZLEXXAD |                                                        |
|            | * Precalculate IENs (see note below)                     |
|            | * Add 757 (Expression) pointer to 757.01                 |
|            | * Add Long Description to 757.01 .01 field               |
|            | * Create 757.001 (Frequency) entry dinummed to 757       |
|            | * Create 757.02 (ICD Code) (points to 757 and 757.01)    |
|            | * Create 757.1 (Semantic Map) entry                      |
+------------+----------------------------------------------------------+
| SUP^ZZLEXXAS | Applies commonly used medical abbreviations. Adds to   |
|            | - 80/68/2                                                |
|            | - 757.01/5                                               |
+------------+----------------------------------------------------------+
| IX^ZZLEXXAC | Indexes the entries in                                  |
|            | - 80                                                     |
|            | - 757                                                    |
|            | - 757.001                                                |
|            | - 757.01                                                 |
|            | - 757.02                                                 |
|            | - 757.1                                                  |
+------------+----------------------------------------------------------+

IEN pre-calculation is rather intriguing. There is no reason that I could see
to need to pre- calculate the IENs for the Lexicon. You could just get the next
available number. Whatever the reason, the precalculation looks like this:

* ICD-10: 5 million to 7 million
* SNOMED-CT: >7 million
* All other terminolgies: Next available number; less than 5 million.

Initial Plan and Surpise
------------------------
Initially, I thought that the task will simply involve the translation of
ICD-10; essentially, the replacement of the English Text with Korean text. So
that's what I started doing.

What I eventually found out though is that there was a low overlap between
ICD-10-CM-US and KCD-7. Only 6286 of 12871 clinically selectable codes in KCD-7
were also clinically selectable in the US. I did not do a thorough investigation,
but I think I can divide the issues into three types:

* The US version of ICD-10 is older, and does not contain many codes. E.g.
  X69.1, which is "Intentional self-poisoning by and exposure to other and
  unspecified chemicals and noxious substances, residential institution".
* Various US codes specifY the number of times something happened (initial,
  episode, second episode, or more than that). Many of the accident codes
  (starting with with X) don't have any commonality due to that.
* More detailed subspecifications. Either the US version is more subspecified;
  or the Korean version is. For example, to select a tuberculosis of the lung 
  diagnosis in KCD-7, you need to to select A15.00 (Tuberculous of lung with
  cavitation, confirmed by sputum microscopy with or without culture), or
  A15.01 (Tuberculous of lung without cavitation or unspecified, confirmed by
  sputum microscopy with or without culture). In the US, you only have one
  code: A15.0, tuberculosis of the lung.

Due to that, doing a translation is not quite feasible. A translation would be
a translation of ICD-10-CM-US, which are not the codes being used in Korea. So
that left me with two avenues to pursue: Delete the US version and replace it
with KCD-7; or inactivate the US version and add KCD-7. The latter option is
harder and would have required more investigation; so I opted to doing the
easier option: Replace ICD-10 in VistA.

