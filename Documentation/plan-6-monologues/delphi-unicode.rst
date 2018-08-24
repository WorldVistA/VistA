Converting CPRS to talk to VistA using UTF-8
============================================

Introduction to Plan VI (aka Plan 6)
------------------------------------
OSEHRA just started a project called Plan VistA Internationlization (VI)--and
in order to distinguish it from VistA Imaging, we decided to call it Plan 6.
The objective of the project is to allow VistA to be easily modified by
international users for use in their own countries in local languages and local
dates. It is not intended to be a through implementation in a specific language.

One of the first stages of OSEHRA's Plan 6 work is for CPRS to be able to talk
to VistA in UTF-8. Since Delphi XE (released in 2009), Delphi supported Unicode
strings as UTF-16. This allows us for the first time to transparently support
different character sets within the same sysatem, and it allowed us to
represent glyph based languages (such as Chinese) for the first time in CPRS.

I (Sam Habiel) was very involved in choosing a character set for VistA's
implementation in Jordan, where various elements needed to be represented in
Arabic. You can find my adventures linked from my `home page
<http://smh101.com>`. In the end, due to the fact that Delphi 2006 only allowed
us to use single bytes for each character, we ended up using Windows Code Page
1256 for all of VistA. It worked, but it required us to write some hooks in
order to talk to other systems that used Unicode (e.g. Printers).

Modifying the XWB Broker - Try 1 and why were only partially successful
-----------------------------------------------------------------------
We found out quickly that we needed to modify a single broker file: `wsockc.pas
https://github.com/OSEHRA/VistA/blob/master/Packages/RPC%20Broker/BDK/Source/wsockc.pas`.
It was easier said than done. Writing network communication code is hard; and
trying to adapt the existing older string types turned out to be problematic.
These are the main issues:

* Pascal has been continously enhanced--most bafflingly to me: it has three
  different string types for different circumstances--all of which were being
  used in the codebase: Pascal strings; regular reference counted strings; and
  zero terminated strings.
* Correct Unicode converstion methods are hard to find. There are so many of
  them, and some of them produce the wrong result (e.g. `UTF8ToString()
  http://docwiki.embarcadero.com/Libraries/Tokyo/en/System.UTF8ToString`)
  strips the initial character of the output--possibly it wants to create a
  Pascal string, not a reference counted string.
* ``wsockc.pas`` was not refactored with the advent of Delphi XE--the algorithm
  was kept the same as in the previous single byte encoding versions of Delphi.
  However, the algorithm was incorrect at this point in time whenever any multibyte
  string was entered into CPRS.

The following is the main receive loop as as result of our first try. Code
containing "//" was previous code that was commented out.

.. code:: pascal

  //  BufSend, BufRecv, BufPtr: PChar;
  BufSend, BufRecv, BufPtr: PAnsiChar;
  ...

  repeat
    BytesRead := recv(hSocket, BufPtr^, BytesLeft, 0);

    if BytesRead > 0 then begin
      if BufPtr[BytesRead-1] = #4 then begin
  //    sBuf := ConCat(sBuf, BufPtr);xe3
        sBuf := sBuf + Utf8ToUnicodeString(BufPtr);
      end else begin
        BufPtr[BytesRead] := #0;
  //    sBuf := ConCat(sBuf, BufPtr);
        sBuf := sBuf + Utf8ToUnicodeString(BufPtr);
      end;
      Inc(BytesTotal, BytesRead);
    end;

    if BytesRead <= 0 then begin
      if BytesRead = SOCKET_ERROR then
        NetError('recv', 0)
      else
        NetError('connection lost', 0);
      break;
    end;
  until BufPtr[BytesRead-1] = #4;
  sBuf := Copy(sBuf, 1, pos(#4,sBuf)-1);

This code worked for receiving data from VistA, but was incorrect in other
respects. The biggest problem we had was that the BytesRead count did not
reflect the end of the string anymore--and we didn't know anyway in which to
fix this--thus the hacky copy at the end that guesses the end of the string.
