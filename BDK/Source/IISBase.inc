{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Contains TRPCBroker and related components.
	Current Release: Version 1.1 Patch 47 (Oct. 11, 2007))
*************************************************************** }

{===============================================================================
  Ray Konopka's Conference 2001 Include File

  This file is included into each component unit and serves as a common
  place to add conditional defines and compiler directives to be used by all
  component units.

  Copyright © 1995-2001 by Ray Konopka
===============================================================================}

{$IFDEF WIN32}
  {$DEFINE D2_OR_HIGHER}
{$ENDIF}

{$IFNDEF VER80}
  {$IFNDEF VER90}
    {$IFNDEF VER93}
      {$DEFINE D3_OR_HIGHER}
      {$IFNDEF VER100}
        {$DEFINE BCB3_OR_HIGHER}
        {$IFNDEF VER110}
          {$DEFINE D4_OR_HIGHER}
          {$IFNDEF VER120}
            {$DEFINE BCB4_OR_HIGHER}
            {$IFNDEF VER125}
              {$DEFINE D5_OR_HIGHER}
              {$DEFINE BCB5_OR_HIGHER}
              {$IFNDEF VER130}
                {$DEFINE D6_OR_HIGHER}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF D6_OR_HIGHER}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

{$IFDEF VER80}
  {$DEFINE D1_ONLY}
{$ENDIF}
{$IFDEF VER90}
  {$DEFINE D2_ONLY}
{$ENDIF}
{$IFDEF VER100}
  {$DEFINE D3_ONLY}
{$ENDIF}
{$IFDEF VER110}
  {$DEFINE BCB3_ONLY}
  {$OBJEXPORTALL ON}
{$ENDIF}
{$IFDEF VER120}
  {$DEFINE D4_ONLY}
{$ENDIF}
{$IFDEF VER125}
  {$DEFINE BCB4_ONLY}
  {$OBJEXPORTALL ON}
{$ENDIF}
{$IFDEF VER130}
  {$IFDEF BCB}
    {$DEFINE BCB5_ONLY}
    {$OBJEXPORTALL ON}
  {$ELSE}
    {$DEFINE D5_ONLY}
  {$ENDIF}
{$ENDIF}
{$IFDEF VER140}
  {$DEFINE D6_ONLY}
{$ENDIF}



{== Code Generation Directives ==}

{$F-}    { Force Far Calls }
{$A+}    { Word Align Data }
{$U-}    { Pentium-Save FDIV }
{$K-}    { Smart Callbacks }
{$W-}    { Windows Stack Frame }


{== Runtime Errors ==}

{$IFOPT D+}
  {$R+}    { Range Checking - On - if compiled with Debug Information }
{$ELSE}
  {$R-}    { Range Checking - Off - if compiled without Debug Information }
{$ENDIF}

{$S-}    { Stack Checking }
{$I+}    { I/O Checking }
{$Q-}    { Overflow Checking }


{== Syntax Options ==}

{$V-}    { Strict Var-Strings }
{$B-}    { Complete Boolean Evaluation }
{$X+}    { Extended Syntax }
{$T-}    { Typed @ Operator }
{$P+}    { Open Parameters }
{$IFDEF D4_OR_HIGHER}
{$J+}    { Writeable Typed Constants }
{$ENDIF}

{== Miscellaneous Directives ==}

{$C MOVEABLE DEMANDLOAD DISCARDABLE}    { Code Segment Attribute }
{$G+}    { 286 Instructions }
{$N+}    { Numeric Coprocessor }
{$Z-}    { Word Size Enumerated Types }

{$IFDEF WIN32}
{$H+}    { Long String Support }
{$ENDIF}

