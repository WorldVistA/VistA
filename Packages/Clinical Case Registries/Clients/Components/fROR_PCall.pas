unit fROR_PCall;
{
================================================================================
*
*       Package:        ROR - Clinical Case Registries
*       Date Created:   $Revision: 1 $  $Modtime: 12/20/07 12:43p $
*       Site:           Hines OIFO
*       Developers:     dddddomain.user@domain.ext
*
*       Description:    RPC call and RPC Error Window
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/CCR-COMPONENTS/fROR_PCall.pas $
*
* $History: fROR_PCall.pas $
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 8/12/09    Time: 8:28a
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/CCR-COMPONENTS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 3/09/09    Time: 3:37p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_6/CCR-COMPONENTS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 1/13/09    Time: 1:25p
 * Created in $/Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_4/CCR-COMPONENTS
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 2:54p
 * Created in $/Vitals GUI/CCR-COMPONENTS
 * CCR Components. Version used in Vitals GUI 5.0.18
 * 
 * *****************  Version 1  *****************
 * User: Zzzzzzandria Date: 5/11/07    Time: 2:34p
 * Created in $/Vitals/CCR-COMPONENTS
 * 
 * *****************  Version 17  *****************
 * User: Zzzzzzgavris Date: 8/08/05    Time: 3:55p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 16  *****************
 * User: Zzzzzzgavris Date: 1/18/05    Time: 3:40p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 15  *****************
 * User: Zzzzzzgavris Date: 1/10/05    Time: 3:49p
 * Updated in $/CCR v1.0/Current/Components
 * 
 * *****************  Version 13  *****************
 * User: Zzzzzzgavris Date: 10/15/04   Time: 10:15a
 * Updated in $/CCR v1.0/Current
 *
 * *****************  Version 12  *****************
 * User: Zzzzzzgavris Date: 10/15/04   Time: 10:11a
 * Updated in $/CCR v1.0/Current/Components
 *
*
================================================================================
}
interface

uses
  SysUtils, Classes, Forms, Dialogs, TRPCB, StdCtrls, Controls, CCOWRPCBroker;

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

  //------------------------------- TRPCErrorForm ------------------------------

  TRPCErrorForm = class(TForm)
    Msg: TMemo;
    btnOk: TButton;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  //------------------------------- IRPCInterface ------------------------------

  IRPCInterface = interface(IInterface)
    ['{FAD698BB-63E9-408C-BFF7-8E4A8451B63B}']
    function CallProc(const RemoteProcedure: String;
      const Parameters: array of String; MultList: TStringList = nil;
      const RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
    function CheckError(const RPCName: String; RetList: TStrings = nil;
            const RPCMode: TRPCMode = []): Integer;
  end;

  //-------------------------------- TCCRLogMode -------------------------------

  TCCRLogMode = class(TPersistent)
  private
    fEnabled:      Boolean;
    fLimitParams:  Word;
    fLimitResults: Word;
    fParameters:   Boolean;
    fResults:      Boolean;

  public
    constructor Create;
    
    procedure Assign(aSource: TPersistent); override;

  published
    property Enabled: Boolean read fEnabled write fEnabled;
    property LimitParams: Word read fLimitParams write fLimitParams default 0;
    property LimitResults: Word read fLimitResults write fLimitResults default 0;
    property Parameters: Boolean read fParameters write fParameters default True;
    property Results: Boolean read fResults write fResults default True;

  end;

  //------------------------------- TCCRRPCBroker ------------------------------

  TCCRRPCBroker = class(TCCOWRPCBroker, IRPCInterface)
  private
    fLog:     TCCRLogMode;
    fLogData: TStringList;

    procedure setLog(const aValue: TCCRLogMode);

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    procedure AddLogString(const aValue: String); overload;
    procedure AddLogString(const aFormat: String; const ArgList: array of const); overload;
    function  CallProc(const aRemoteProcedure: String;
      const Parameters: array of String; MultList: TStringList = nil;
      const RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean; virtual;
    function  CheckError(const RPCName: String; RetList: TStrings = nil;
            const RPCMode: TRPCMode = []): Integer;

    property LogData: TStringList read fLogData;

  published
    property Log: TCCRLogMode read fLog write setLog;

  end;

function  CallRemoteProc( Broker: TRPCBroker; RemoteProcedure: String;
            Parameters: array of String; MultList: TStringList = nil;
            RPCMode: TRPCMode = []; RetList: TStrings = nil ): Boolean;

function  CheckRPCError( RPCName: String; Results: TStrings;
            RPCMode: TRPCMode = [] ): Integer;

implementation
{$R *.DFM}

uses
  Math, uROR_Utilities;

function CallRemoteProc(Broker: TRPCBroker; RemoteProcedure: String;
           Parameters: array of String; MultList: TStringList = nil;
           RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
var
  i, j: Integer;
begin
  Broker.RemoteProcedure := RemoteProcedure;
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
                  n := Results.Count - 1;
                  for i:=1 to n do
                    begin
                      buf := Results[i];
                      if Piece(buf, '^') <> '' then
                        begin
                          Add('');  Add(' ' + Piece(buf,'^',2));
                          Add(' Error Code: ' + Piece(buf,'^',1) + ';' + #9 +
                            'Place: ' + StringReplace(Piece(buf,'^',3),'~','^',[]));
                        end
                      else
                        Add(' ' + Piece(buf,'^',2,999));
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

///////////////////////////////// TCCRLogMode \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRLogMode.Create;
begin
  inherited;
  fEnabled      := False;
  fLimitParams  := 0;
  fLimitResults := 0;
  fParameters   := True;
  fResults      := True;
end;

procedure TCCRLogMode.Assign(aSource: TPersistent);
begin
  if aSource is TCCRLogMode then
    with TCCRLogMode(aSource) do
      begin
        Self.fEnabled      := fEnabled;   
        Self.fLimitParams  := fLimitParams;
        Self.fLimitResults := fLimitResults;
        Self.fParameters   := fParameters;
        Self.fResults      := fResults;
      end
  else
    inherited;
end;

//////////////////////////////// TCCRRPCBroker \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRRPCBroker.Create(anOwner: TComponent);
begin
  inherited;
  fLog     := TCCRLogMode.Create;
  fLogData := TStringList.Create;
end;

destructor TCCRRPCBroker.Destroy;
begin
  FreeAndNil(fLogData);
  FreeAndNil(fLog);
  inherited;
end;

procedure TCCRRPCBroker.AddLogString(const aValue: String);
begin
  LogData.Add(aValue);
end;

procedure TCCRRPCBroker.AddLogString(const aFormat: String; const ArgList: array of const);
begin
  AddLogString(Format(aFormat, ArgList));
end;

function TCCRRPCBroker.CallProc(const aRemoteProcedure: String;
  const Parameters: array of String; MultList: TStringList = nil;
  const RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
var
  i, j, n: Integer;
begin
  RemoteProcedure := aRemoteProcedure;
  n := High(Parameters);

  if Log.Enabled then
    begin
      AddLogString('');
      AddLogString('RPC: %s', [aRemoteProcedure]);
      if Log.Parameters then
        for j:=0 to n do
          AddLogString('     P[%02d]: ''%s''', [j,Parameters[j]]);
    end;

  i := 0;
  while i <= n do
    begin
      if (Copy(Parameters[i], 1, 1) = '@') and (Parameters[i] <> '@') then
        begin
          Param[i].Value := Copy(Parameters[i], 2, Length(Parameters[i]));
          Param[i].PType := Reference;
        end
      else
        begin
          Param[i].Value := Parameters[i];
          Param[i].PType := Literal;
        end;
      Inc(i);
    end;

  if MultList <> nil then
    if MultList.Count > 0 then
      begin
        if Log.Enabled and Log.Parameters then
          begin
            if Log.LimitParams > 0 then
              n := Min(MultList.Count, Log.LimitParams) - 1
            else
              n := MultList.Count - 1;
            for j:=0 to n do
              AddLogString('     M[%02d]: ''%s''', [j,MultList[j]]);
            if n < (MultList.Count-1) then
              AddLogString('     ...');
          end;
        for j:=1 to MultList.Count do
          Param[i].Mult[IntToStr(j)] := MultList[j-1];
        Param[i].PType := List;
      end;

  try
    Result := True;
    if RetList <> nil then
      begin
        RetList.Clear;
        lstCall(RetList);
      end
    else
      begin
        Call;
        RetList := Results;
      end;

    if Not (rpcNoResChk in RPCMode) then
      if CheckRPCError(aRemoteProcedure, RetList, RPCMode) <> 0 then
        Result := False;

  except
    on e: EBrokerError do
    begin
      if Not (rpcSilent in RPCMode) then
        MessageDialog('RPC Error',
          'Error encountered retrieving VistA data.' + #13 +
          'Server: ' + Server + #13 +
          'Listener port: ' + IntToStr(ListenerPort) + #13 +
          'Remote procedure: ' + aRemoteProcedure + #13 +
          'Error is: ' + #13 +
          e.Message, mtError, [mbOK], mrOK, e.HelpContext);
      Results.Clear;
      Results.Add('-1000^1');
      Results.Add('-1000^' + e.Message);
      Result := False;
    end;
  else
    raise;
  end;

  if Log.Enabled and Log.Results then
    begin
      if Log.LimitResults > 0 then
        n := Min(RetList.Count, Log.LimitResults) - 1
      else
        n := RetList.Count - 1;
      for j:=0 to n do
        AddLogString('     R[%02d]: ''%s''', [j,RetList[j]]);
      if n < (RetList.Count-1) then
        AddLogString('     ...');
    end;
end;

function TCCRRPCBroker.CheckError(const RPCName: String; RetList: TStrings;
  const RPCMode: TRPCMode): Integer;
var
  i, n: Integer;
  buf, rc: String;
  form: TRPCErrorForm;
begin
  if not Assigned(RetList) then
    RetList := Results;
    
  if RetList.Count = 0 then
    begin
      Result := mrOK;
      buf := 'The ''' + RPCName + ''' remote procedure returned nothing!';
      if Not (rpcSilent in RPCMode) then
        MessageDialog('RPC Error', buf, mtError, [mbOK], mrOK, 0);
      RetList.Add('-1001^1');
      RetList.Add('-1001^' + buf);
      Exit;
    end;

  Result := 0;
  rc := Piece(RetList[0], '^');

  if StrToIntDef(rc, 0) < 0 then
    begin
      Result := mrOK;
      if Not (rpcSilent in RPCMode) then
        begin
          form := TRPCErrorForm.Create(Application);
          try
            n := StrToIntDef(Piece(RetList[0], '^', 2), 0);
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
                        buf := RetList[i];
                        Add('');  Add(' ' + Piece(buf,'^',2));
                        Add(' Error Code: ' + Piece(buf,'^',1) + ';' + #9 +
                          'Place: ' + StringReplace(Piece(buf,'^',3),'~','^',[]));
                      end;
                  end
                else
                  Add(buf);
              end;
            Result := form.ShowModal;
          finally
            form.Free;
          end;
        end;
    end;
end;

procedure TCCRRPCBroker.setLog(const aValue: TCCRLogMode);
begin
  fLog.Assign(aValue);
end;

//////////////////////////////// TRPCErrorForm \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TRPCErrorForm.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
