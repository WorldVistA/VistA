{*********************************************************}
{*                  OVCXFRC0.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcxfrc0;
  {-transfer component editor}


interface

uses
  Windows, Classes, DesignIntf, DesignEditors, ExtCtrls, Forms, Messages, StdCtrls,
  SysUtils, OvcData;

type
  {component editor for the transfer component}
  TOvcTransferEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer): String;
      override;
    function GetVerbCount : Integer;
      override;
  end;


implementation

uses
  OvcConst, OvcEF, OvcRLbl, OvcXfer, OvcXfrC1;


{*** TOvcTransferEditor ***}

procedure TOvcTransferEditor.ExecuteVerb(Index : Integer);
var
  frmTransfer : TOvcfrmTransfer;
  I           : Integer;
  Len         : Integer;
  L           : TList;
  C           : TComponent;
  S           : string;
begin
  if Index = 0 then begin
    with TOvcTransfer(Component) do begin
      L := TList.Create;
      try
        frmTransfer := TOvcfrmTransfer.Create(Application);
        try
          {get list of components that are involved in transfer}
          GetTransferList(L);

          with frmTransfer do begin
            {find longest name in list}
            Len := 0;
            for I := 0 to L.Count-1 do begin
              C := TComponent(L[I]);
              if Length(C.Name) > Len then
                Len := Length(C.Name);
            end;

            {force handle creation}
            frmTransfer.HandleNeeded;
            lbAllComponents.HandleNeeded;
            lbAllComponents.Clear;

            {fill ListBox with component and class names}
            for I := 0 to L.Count-1 do begin
              C := TComponent(L[I]);
              S := C.Name + ':' + #9 + C.ClassName;
              lbAllComponents.Items.Add(S);
            end;
            lbAllComponents.SetTabStops([Len+5]);
          end;
          {tell property editor form the components form}
          frmTransfer.ComponentForm := Component.Owner;

          {let form use our component list}
          frmTransfer.ComponentList := L;

          {display the form}
          frmTransfer.ShowModal;
        finally
          frmTransfer.Free;
        end;
      finally
        L.Free;
      end;
    end;
  end;
end;

function TOvcTransferEditor.GetVerb(Index : Integer) : String;
begin
  Result := 'Generate Transfer Buffer...';
end;

function TOvcTransferEditor.GetVerbCount : Integer;
begin
  Result := 1;
end;


end.
