unit FTemplateReport;

interface

uses
  ORExtensions,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, uConst, VA508AccessibilityManager;

const
  UM_TEMPLATE_FIELDS = UM_SELECT + 10;
  UM_SHARED_TEMPLATES = UM_SELECT + 11;

type
  TfrmTemplateReport = class(TfrmBase508Form)
    pnlButtons: TPanel;
    reReport: ORExtensions.TRichEdit;
    pnlStatusBar: TPanel;
    btnCopy: TButton;
    lblCurrent: TLabel;
    lblCount: TLabel;
    btnCancel: TButton;
    procedure UMTemplateFields(var Message: TMessage); message UM_TEMPLATE_FIELDS;
    procedure UMSharedTemplates(var Message: TMessage); message UM_SHARED_TEMPLATES;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTemplateFields: boolean;
    FRunning: boolean;
    FAbort: boolean;
    FCount: integer;
  public
    procedure ReportReady;
    procedure UpdateLbls(txt: string);
    property TemplateFields: boolean read FTemplateFields write FTemplateFields;
    property Running: boolean read FRunning write FRunning;
    property Abort: boolean read FAbort write FAbort;
    property Count: integer read FCount write FCount;
  end;

procedure RunTemplateErrorReport(RunTemplateFields: boolean = false);
implementation

{$R *.dfm}
uses ORFn, uTemplateFields, rTemplates, Clipbrd, uTemplates, dShared,
  UResponsiveGUI;

procedure RunTemplateErrorReport(RunTemplateFields: boolean = false);
var
  frmTemplateReport: TfrmTemplateReport;
  runReport: boolean;

  procedure SetupTemplateFields;
  begin
    with frmTemplateReport do
    begin
      Caption := 'Template Field Error Report';
    end;
  end;

  procedure SetupSharedTemplates;
  begin
    with frmTemplateReport do
    begin
      Caption := 'Shared Template Error Report';
    end;
  end;

  function OK2RunSharedTemplateReport: boolean;
  begin
    Result := (InfoBox('Warning, Error Checking All Shared Templates can take a long time ' +
              'to run, depending on how many templates you have on your system.  ' +
              'Also, this report does not test template fields, other than to ' +
              'validate their existance.  To test all template fields run the ' +
              '"Error Check All Template Fields" menu option.' + CRLF + CRLF +
              'Are you sure you want to proceed?',
              'Warning', MB_YESNO or MB_ICONWARNING) = mrYes);
  end;

  function OK2RunTemplateFieldReport: boolean;
  begin
    Result := (InfoBox('Warning, Error Checking All Template Fields can take a long ' +
              'time to run, depending on how many template fields you have ' +
              'on your system.' + CRLF + CRLF + 'Are you sure you want to proceed?',
              'Warning', MB_YESNO or MB_ICONWARNING) = mrYes);
  end;

begin
  if RunTemplateFields then
    runReport := OK2RunTemplateFieldReport
  else
    runReport := OK2RunSharedTemplateReport;
  if runReport then
  begin
    frmTemplateReport := TfrmTemplateReport.Create(Application);
    with frmTemplateReport do
    begin
      TemplateFields := RunTemplateFields;
      if RunTemplateFields then
        SetupTemplateFields
      else
        SetupSharedTemplates;
      btnCopy.Enabled := False;
      Abort := False;
      Count := 0;
      ShowModal;
    end;
  end;
end;

procedure TfrmTemplateReport.btnCancelClick(Sender: TObject);
begin
  inherited;
  Abort := True;
  if btnCopy.Enabled then close; // Done with report
end;

procedure TfrmTemplateReport.btnCopyClick(Sender: TObject);
begin
  inherited;
  Clipboard.AsText := reReport.lines.Text;
  ShowMessage('Report Copied to Clipboard');
end;

procedure TfrmTemplateReport.FormCreate(Sender: TObject);
begin
  inherited;
  ResizeFormToFont(self);
end;

procedure TfrmTemplateReport.FormShow(Sender: TObject);
begin
  inherited;
  if TemplateFields then
    PostMessage(Handle, UM_TEMPLATE_FIELDS, 0, 0)
  else
    PostMessage(Handle, UM_SHARED_TEMPLATES, 0, 0);
end;

procedure TfrmTemplateReport.ReportReady;
begin
  if Abort then
    lblCurrent.Caption := 'Report Canceled at ' + lblCurrent.Caption
  else
    lblCurrent.Caption := '';
  btnCopy.Enabled := true;
  btnCancel.Caption := 'Done';
end;


procedure TfrmTemplateReport.UMSharedTemplates(var Message: TMessage);
var
  idx: integer;
  Lst, ErrorList: TStringList;
  tmp: TTemplate;
  Err: TStringList;
  name: string;

  procedure CheckNestedNodes(parent: TTemplate);
  var
    kids: TStringList;
    kid: TTemplate;
    i, j: integer;
    txt: string;

  begin
    kids := TStringList.Create;
    try
      GetTemplateChildren(parent.ID, kids);
      for i := 0 to kids.Count-1 do
      begin
        if Abort then break;
        kid := AddTemplate(kids[i], parent);
        Err.Clear;
        txt := kid.FullBoilerplate;
        dmodShared.BoilerplateOK(txt, #13, nil, Err);
        if Err.Count > 0 then
          ErrorList.AddStrings(Err);
        Err.Clear;
        ListTemplateFields(txt, Err, nil);
        if Err.Count > 0 then
          ErrorList.AddStrings(Err);
        name := kid.PrintName;
        tmp := kid.Parent;
        while assigned(tmp) do
        begin
          name := tmp.PrintName + '.' + name;
          tmp := tmp.Parent;
        end;
        UpdateLbls(name);
        if ErrorList.Count > 0 then
        begin
          reReport.Lines.Add('--- Template: ' + name + ' ' + StringOfChar('-',30));
          for j := 0 to ErrorList.Count-1 do
          begin
            if length(ErrorList[j]) > 0 then
              reReport.Lines.Add('  ' + ErrorList[j]);
          end;
        end;
        ErrorList.Clear;
        if kid.Children in [tcActive, tcBoth] then
          CheckNestedNodes(kid);
      end;
    finally
      kids.Free;
    end;
  end;

begin
  inherited;
  Message.Result := mrOk;
  if Running then exit;
  ErrorList := TStringList.Create;
  Err := TStringList.Create;
  lst := TStringList.Create;
  Running := True;
  try
    GetTemplateRoots(Lst);
    for idx := 0 to Lst.Count-1 do
    begin
      if Abort then break;
      tmp := AddTemplate(Lst[idx], nil);
      if tmp.RealType in [ttRoot, ttTitles, ttConsults, ttProcedures] then
        CheckNestedNodes(tmp);
    end;
  finally
    Lst.Free;
    Err.Free;
    ErrorList.Free;
    Running := False;
  end;
  ReportReady;
end;

procedure TfrmTemplateReport.UMTemplateFields(var Message: TMessage);
var
  i, j: integer;
  Done: boolean;
  tmp, lst, ErrorList: TStringList;
  StartFrom, name: string;
  fld: TTemplateField;

begin
  inherited;
  Message.Result := mrOk;
  if Running then exit;
  lst := TStringList.Create;
  tmp := TStringList.Create;
  ErrorList := TStringList.Create;
  Running := True;
  try
    Done := False;
    StartFrom := '';
    repeat
      SubSetOfTemplateFields(StartFrom, 1, Lst);
      if Lst.Count > 0 then
      begin
        for i := 0 to Lst.Count-1 do
        begin
          if Abort then break;
          name := Piece(Lst[i],U,2);
          ErrorList.Clear;
          UpdateLbls(name);
          fld := GetTemplateField(name, False);
          if assigned(fld) then
          begin
            tmp.Clear;
            Fld.ErrorCheckText(tmp);
            ListTemplateFields(tmp.Text, ErrorList, nil);
            if pos('|',tmp.Text)>0 then
            begin
              ErrorList.Add('Patient Data Object Delimiter "|" found.  Patient ' +
                            'Data Objects do not function inside Template Fields.');
            end;
          end
          else
            ErrorList.Add('Template Field "'+ name + '" not found.');
          if ErrorList.Count > 0 then
          begin
            reReport.Lines.Add('--- Template Field: ' + name + ' ' + StringOfChar('-',60));
            for j := 0 to ErrorList.Count-1 do
            begin
              if length(ErrorList[j]) > 0 then
                reReport.Lines.Add('  ' + ErrorList[j]);
            end;
          end;
        end;
        StartFrom := name;
      end
      else
        Done := TRUE;
    until Done or Abort;
  finally
    lst.Free;
    tmp.Free;
    ErrorList.Free;
    Running := False;
  end;
  ReportReady;
end;

procedure TfrmTemplateReport.UpdateLbls(txt: string);
begin
  lblCurrent.Caption := txt;
  Count := Count + 1;
  lblCount.Caption := IntToStr(Count);
  if Count mod 5 = 0 then
    TResponsiveGUI.ProcessMessages(True);
end;

end.
