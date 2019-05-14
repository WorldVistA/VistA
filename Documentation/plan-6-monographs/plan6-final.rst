Plan VI Final Write-up for Korean Phase
=======================================

**Sam Habiel, Pharm.D.**/
**OSEHRA**/
**14 May 2019**

This is a post that will summarize all of the changes that we made to VistA in
order for VistA to work with Korean. We will also describe some items that we
couldn't solve in our timeline. The table of contents should give you a good
idea of all the items in the list.

Overall Goal of the Project
---------------------------
I personally know how big VistA is; so we tried to focus the project on items
that will have wide applicability. That's why we focused on making CPRS usable
with other languages; and why we didn't spend as much time in Roll and Scroll
applications to do the same.

VistA must run in UTF-8 Mode
----------------------------
We used GT.M and YottaDB for the database. We needed to configure VistA to run
in UTF-8 mode. To do that, you need to do the following:

* libicu needs to be installed; and perhaps depending on your distribution,
  libicu-dev.
* ``$gtmroutines`` needs to point to routines in ``$gtm_dist/utf8`` (shared
  object for x64).
* Set ``LC_ALL`` and ``LC_LANG`` to the correct UTF-8 locale.
* ``gtm_chset`` needs to be ``utf-8``.
* ``gtm_icu_version`` needs to be set to the correct version of libicu. If you
  have libicu-dev, this is just a call to ``icu-config --version``.
* If importing from .zwr globals, modify them to add "UTF-8" on the first line
* Convert .zwr globals and .m routines from iso8859-1 encoding (how they are
  actually stored in VistA) to UTF-8 encoding. The ``recode`` or ``iconv``
  commmands are good for doing that.

The rest of the process is the normal process for creating a VistA instance.

CPRS Read/Write to VistA in UTF-8
---------------------------------
Briefly, what we had to do in the Broker is to rewrite wsockc.pas. This was
actually rather difficult, as it required good Object Pascal knowledge, which
wasn't my forte. Since all strings were in UTF-16 in Object Pascal, we had to
convert them to UTF-8 prior to being sent to VistA; and when we received from
VistA, we converted from UTF-8 to UTF-16 encoding. On the VistA side, the
changes were actually more limited: we only needed to change $L and $E to $ZL
and $ZE. There were some other minor changes that had to do with ensuring that
the broker know it had to operate in "M" mode rather than in UTF-8 mode, as
the strings coming from the broker were not complete yet.

There were two other Delphi side changes

* The Intro Text Rich Text Box was a custom component (to support URLs); but
  the custom component was ASCII only. The URL capability got taken out in the
  latest version of the broker; so in the end we just discarded the custom
  component and used the component that came with Delphi.
* There is a bug in ``ConvertSidToStringA`` (a Win32 function) in the Korean
  Locale, where it gives us garbage even though the SID is Alpha-numeric and is
  fully representable in ASCII. Switching to ``ConvertSidtoStringW`` fixes this
  problem.

With these changes, CPRS and any other Delphi Applications that include our
changes will be able to read and write UTF-8 to VistA.

This is described in far more detail `here <https://www.osehra.org/post/converting-cprs-talk-vista-using-utf-8>`_, or
`dupliciated here <http://smh101.com/articles/p6/cprs-unicode.html>`_.

Reports and TIU Unicode Support
-------------------------------
Reports displayed non-ASCII data saved into VistA as ???. This was easily
fixed; it was simply a Delphi procedure that needed to take an extra parameter.

TIU notes pasting and saving text was "cleaned up" with filters that removed
non-ASCII characters. This was done to prevent saving non-ASCII data to VistA;
since VistA now can take everything under the sun, we simply removed the
filter.

The last problem was that were was M side code that checked for the presence of
ASCII as a proxy for the note not being empty. That means if you wrote a note
with non-ASCII text with no spaces, it was considered "empty" and was deleted.
That was easy to fix.

This is described in more detail `here <https://www.osehra.org/post/reports-and-tiu-unicode-support>`_, or
`duplicated here <http://smh101.com/articles/p6/cprs-tiu.html>`_.

CPRS Localization Strategy and Framework
----------------------------------------
At this point, we can send and receive data fully in UTF-8; but all the labels
in the program are still in English. Our first "port of call" to was to check
the official translation framework provided by Delphi: The Integrated
Translation Environment (ITE). It had a large amount of problems; and we
actually coudln't use it even if we wanted to due to these issues. In the end
we looked at multiple open source projects, and we chose "Kryvich's Localizer"
because it's interoperable with ITE, it required very limited source code
changes to get it working; and it had a very simple output format. We
translated the CPRS strings into Korean and Chinese.

This is described in more detail `here <https://www.osehra.org/post/todays-presentation-delphi-localization-frameworks>`_
and `here <https://www.osehra.org/post/plan-vi-meeting-coming-102-8am-edt>`_; or
alternately duplicated `here <http://smh101.com/articles/p6/plan6-l10n-tools2_Format.pdf>`_
and `here <http://smh101.com/articles/p6/plan6-l10n-kryvich.pdf>`_.

