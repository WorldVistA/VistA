unit fROR_PCall;
{
================================================================================
*
*       Package:        ROR - Clinical Case Registries
*       Date Created:   $Revision: 1 $  $Modtime: 8/05/08 5:15p $
*       Site:           Hines OIFO
*       Developers:     dddddomain.user@domain.ext
*
*       Description:    RPC call and RPC Error Window
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/ROR/fROR_PCall.pas $
*
* $History: fROR_PCall.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:29a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/ROR
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:38p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/Source/ROR
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:26p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/Source/ROR
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/14/07    Time: 10:29a
 * Created in $/Vitals GUI 2007/Vitals-5-0-18/ROR
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:43p
 * Created in $/Vitals/VITALS-5-0-18/ROR
 * GUI v. 5.0.18 updates the default vital type IENs with the local
 * values.
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/16/06    Time: 5:32p
 * Created in $/Vitals/Vitals-5-0-18/VITALS-5-0-18/ROR
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/24/05    Time: 3:32p
 * Created in $/Vitals/Vitals GUI  v 5.0.2.1 -5.0.3.1 - Patch GMVR-5-7 (CASMed, No CCOW) - Delphi 6/ROR
 * 
 * *****************  Version 3  *****************
 * User: Zzzzzzandria Date: 11/12/04   Time: 5:41p
 * Updated in $/CP Modernization/ROR
 * 
 * *****************  Version 2  *****************
 * User: Zzzzzzandria Date: 10/19/04   Time: 5:48p
 * Updated in $/CP Modernization/ROR
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 9/02/04    Time: 1:17p
 * Created in $/CP Modernization/ROR
 * 
 * *****************  Version 7  *****************
 * User: Zzzzzzgavris Date: 8/06/04    Time: 4:09p
 * Updated in $/CCR v1.0/Current
 *
 * *****************  Version 6  *****************
 * User: Zzzzzzgavris Date: 8/02/04    Time: 12:59p
 * Updated in $/CCR v1.0/Current
 *
 * *****************  Version 5  *****************
 * User: Zzzzzzgavris Date: 3/26/04    Time: 3:48p
 * Updated in $/ICR v3.0/Current
*
================================================================================
}
interface

uses
  Windows, Messages, SysUtils, Classes
  , Graphics
  , Controls
  , Forms
  , Dialogs
  , StdCtrls
//  , uROR_Utilities    - replaced by u_Common
  , TRPCB
  , CCOWRPCBroker
  , VERGENCECONTEXTORLib_TLB // not sure we need it here...
  ;

type

  TRPCMode = set of (

    rpcSilent,          // Do not show any error messages
                        // (only return the error codes)

    rpcNoResChk         // Do not check the Results array for the errors
                        // returned by the remote procedure. This flag must be
                        // used for the remote procedures that do not conform
                        // to the error reporting format supported by the
                        // CheckRPCError function.

  );

  TRPCErrorForm = class(TForm)
    Msg: TMemo;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function  CallRemoteProc( Broker: TRPCBroker; RemoteProcedure: String;
            Parameters: array of String; MultList: TStringList = nil;
            RPCMode: TRPCMode = []; RetList: TStrings = nil ): Boolean;

function  CallRemoteProcLog( Broker: TRPCBroker; RemoteProcedure: String;
            Parameters: array of String; MultList: TStringList = nil;
            RPCMode: TRPCMode = []; RetList: TStrings = nil ): Boolean;

function  CheckRPCError( RPCName: String; Results: TStrings;
            RPCMode: TRPCMode = [] ): Integer;

procedure LogString( ll: String );
procedure LogTimeString( ll: String );

//function  RPCErrorCode(Results: TStrings = nil): Integer;


var
  Log: TStrings;
  RPCBroker: TRPCBroker = nil;
  prevRPC: String;

implementation

uses
  uGMV_Common
  , uGMV_Engine
  ;
{$R *.DFM}

function CallRemoteProc(Broker: TRPCBroker; RemoteProcedure: String;
           Parameters: array of String; MultList: TStringList = nil;
           RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
var
  s,ss: String;
  i, j: Integer;

  procedure CheckBroker(aFlag:Boolean;aString:String='');
  begin
    if not aFlag then Exit;
    if not (Broker.ClearParameters and Broker.ClearResults) then
      begin
        if Broker.ClearParameters then s := ''
        else s := 'Clear Parameters = False'+ #13;
        if Broker.ClearResults then ss := ''
        else ss := 'Clear Results = False';

        ShowMessage('Vitals: Broker settings Error'+#13+
           aString+#13+
           s+ss+#13+
          'RPC: "'+Broker.RemoteProcedure+'"'+#13+
          'Prev RPC: "'+prevRPC+'"');
        Broker.ClearParameters := True;
        Broker.ClearResults := True;
      end;
  end;

begin
  Broker.RemoteProcedure := RemoteProcedure;

  CheckBroker(CheckBrokerFlag,'CallRemoteProc - In');
  PrevRPC := RemoteProcedure;

  Broker.Param.Clear;
  Broker.Results.Clear;

  i := 0;
  while i <= High(Parameters) do
    begin
      if (Copy(Parameters[i], 1, 1) = '@') and (Parameters[i] <> '@') then
        begin
          Broker.Param[i].Value := Copy(Parameters[i], 2, Length(Parameters[i]));
          Broker.Param[i].PType := Reference;
        end
      else
        begin
          Broker.Param[i].Value := Parameters[i];
          Broker.Param[i].PType := Literal;
        end;
      Inc(i);
    end;

  if MultList <> nil then
    if MultList.Count > 0 then
      begin
        for j := 1 to MultList.Count do
          Broker.Param[i].Mult[IntToStr(j)] := MultList[j-1];
        Broker.Param[i].PType := List;
      end;

  try
    Result := True;
    if RetList <> nil then
      begin
        RetList.Clear;
        Broker.lstCall(RetList);
      end
    else
      begin
        Broker.Call;
        RetList := Broker.Results;
      end;

  CheckBroker(CheckBrokerFlag,'CallRemoteProc - Out');

    if Not (rpcNoResChk in RPCMode) then
      if CheckRPCError(RemoteProcedure, RetList, RPCMode) <> 0 then
        Result := False;

  except
    on e: EBrokerError do
    begin
      if Not (rpcSilent in RPCMode) then
        MessageDialog('RPC Error',
          'Error encountered retrieving VistA data.' + #13 +
          'Server: ' + Broker.Server + #13 +
          'Listener port: ' + IntToStr(Broker.ListenerPort) + #13 +
          'Remote procedure: ' + Broker.RemoteProcedure + #13 +
          'Error is: ' + #13 +
          e.Message, mtError, [mbOK], mrOK, e.HelpContext);
      with Broker do
      begin
        Results.Clear;
        Results.Add('-1000^1');
        Results.Add('-1000^' + e.Message);
      end;
      Result := False;
    end;
  else
    raise;
  end;
end;

procedure LogString(ll: String);
begin
  try
    Log.Text := Log.Text + ll;
  except
  end;
end;

procedure LogTimeString(ll: String);
begin
  LogString(#13 +
    Format('%s : %s',[FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz',Now),ll]));
end;

function CallRemoteProcLog(Broker: TRPCBroker; RemoteProcedure: String;
           Parameters: array of String; MultList: TStringList = nil;
           RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
var
  i: integer;
begin
  LogTimeString('Start -- ' +RemoteProcedure);

  for i := 0 to High(Parameters) do
    LogString(#13+  '                                   ['+IntTosTr(i)+'] ' +Parameters[i]);
  if MultList <> nil then
    for I := 0 to MultList.Count - 1 do
      LogString(#13+  '                                   ['+IntTosTr(i)+'] ' +MultList[i]);

  if CallRemoteProc(Broker, RemoteProcedure, Parameters, MultList, RPCMode, RetList) then
    begin
      if RetList <> nil then
      for I := 0 to RetList.Count - 1 do
        LogString(#13+  '                                   ['+IntTosTr(i)+'] ' +RetList[i]);
      LogTimeString('Stop  -- 1 ' +RemoteProcedure);
      Result := True;
    end
  else
    begin
      LogTimeString('Stop  -- 0 ' +RemoteProcedure);
      Result := False;
    end;
end;

function CheckRPCError(RPCName: String; Results: TStrings;
           RPCMode: TRPCMode = [] ): Integer;
var
  i, n: Integer;
  buf, rc: String;
  form: TRPCErrorForm;
begin
  if Results.Count = 0 then
    begin
      Result := mrOK;
      buf := 'The ''' + RPCName + ''' remote procedure returned nothing!';
      if Not (rpcSilent in RPCMode) then
        MessageDialog('RPC Error', buf, mtError, [mbOK], mrOK, 0);
      Results.Add('-1001^1');
      Results.Add('-1001^' + buf);
      Exit;
    end;

  Result := 0;
  rc := Piece(Results[0], '^');

  if StrToIntDef(rc, 0) < 0 then
    begin
      Result := mrOK;
      if Not (rpcSilent in RPCMode) then
        begin
          form := TRPCErrorForm.Create(Application);
          n := StrToIntDef(Piece(Results[0], '^', 2), 0);
          with form.Msg.Lines do
            begin
              buf := 'The error code ''' + rc + ''' was returned by the '''
                + RPCName + ''' remote procedure!';
              if n > 0 then
                begin
                  buf := buf + ' The problem had been caused by the following ';
                  if n > 1 then
                    buf := buf + 'errors (in reverse chronological order):'
                  else
                    buf := buf + 'error: ';
                  Add(buf);
                  for i := 1 to n do
                    begin
                      if i >= Results.Count then
                        break;
                      buf := Results[i];
                      Add('');  Add(' ' + Piece(buf,'^',2));
                      Add(' Error Code: ' + Piece(buf,'^',1) + ';' + #9 +
                        'Place: ' + StringReplace(Piece(buf,'^',3),'~','^',[]));
                    end;
                end
              else
                Add(buf);
            end;
          Result := form.ShowModal;
          form.Free;
        end;
    end;

end;
{
function RPCErrorCode(Results: TStrings): Integer;
var
  res: TStrings;
begin
  if Assigned(Results) then
    res := Results
  else
    res := RPCBroker.Results;
  if res.Count > 0 then
    Result := StrToIntDef(Piece(Piece(res[0], '^'), '.'), -999)
  else
    Result := -999;
end;
}
////////////////////////////////////////////////////////////////////////////////

procedure TRPCErrorForm.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

begin
  PrevRPC := '';
end.
