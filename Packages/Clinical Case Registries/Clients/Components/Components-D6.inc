// Content of this file is based on taht of OVC.INC from the Orpheus package.

{$IFNDEF VER80}       {Delphi 1.0}
 {$DEFINE VERSION2}   {Delphi 2.0 or higher}
{$ENDIF}

{$IFDEF VERSION2}
 {$IFNDEF VER90}      {Delphi 2.0}
  {$DEFINE VERSION3}  {Delphi 3.0 or higher}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION3}
 {$IFNDEF VER100}     {Delphi 3}
  {$DEFINE VERSION4}  {Delphi 4.0 or higher}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION4}
 {$IFNDEF VER120}     {Delphi 4}
  {$DEFINE VERSION5}  {Delphi 5.0 or higher}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION5}
 {$IFNDEF VER130}     {Delphi 5}
  {$DEFINE VERSION6}  {Delphi 6.0 or higher}
 {$ENDIF}
{$ENDIF}

{$IFDEF VERSION6}
 {$IFNDEF VER140}     {Delphi 6}
  {$DEFINE VERSION7}  {Delphi 7.0 or higher}
 {$ENDIF}
{$ENDIF}
