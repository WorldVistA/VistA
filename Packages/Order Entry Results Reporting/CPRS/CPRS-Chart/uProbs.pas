unit uProbs;

interface

uses
    SysUtils, Windows, Messages, Controls, Classes, StdCtrls, ORfn,
    ORCtrls, Dialogs, Forms, Grids, graphics, ORNet, uConst, Vawrgrid;

const
  fComStart=4;
  {OSE/SMH - v used to be $C(254); but that caused problems with UTF-8 communication
   with VistA as $C(254) is not a valid UTF-8 codepoint. I chose "|" instead as
   it is not commonly used in VistA expect in Word Processing fields as placeholders.}
  v:char = '|';
  PL_OP_VIEW:char = 'C';
  PL_IP_VIEW:char = 'S';
  PL_UF_VIEW:char = 'U';
  PL_CLINIC:char ='C';
  PL_WARD:char='W';
  ACTIVE_LIST_CAP='Active Problems';
  INACTIVE_LIST_CAP='Inactive Problems';
  BOTH_LIST_CAP= 'Active and Inactive Problems';
  REMOVED_LIST_CAP='Removed Problems';

type

{Key/value -internal/external pairs}
 TKeyVal=class(TObject)
   Id:string;
   name:string; {may want to use instead of id sometime}
   intern:string;
   extern:string;
   internOrig:string;
   externOrig:string;
   function GetDHCPField:string;
 public
   procedure DHCPtoKeyVal(DHCPFld:String);
   property DHCPField:string read GetDHCPField;
 end;

 TComment=class(TObject)
   IFN:string;
   Facility:string;
   Narrative:string;
   Status:String;
   DateAdd:string;
   AuthorID:string;
   AuthorName:String;
   StatusFlag:string; {used for processing adds/deletes}
   function GetExtDateAdd:string;
   function GetAge:boolean;
   constructor Create(dhcpcom:string);
   destructor Destroy; override;
   function TComtoDHCPCom:string;
   property ExtDateAdd:string read GetExtDateAdd;
   property IsNew:boolean read GetAge;
 end;

 TCoordExpr = class(TObject)
   IFN:                   String;
   icdId:                 String;
   icdCode:               String;
   snomedConcept:         String;
   snomedDesignation:     String;
   snomedConceptVUID:     String;
   snomedDesignationVUID: String;
   constructor Create(dhcpCoordExpr: String);
   destructor Destroy; override;
   function TCoordExprtoDHCPCoordExpr: String;
 end;

  {patient qualifiers}
 TPLPt=class(TObject)
   PtVAMC:string;
   PtDead:string;
   PtBid:string;
   PtServiceConnected:boolean;
   PtAgentOrange:boolean;
   PtRadiation:boolean;
   PtEnvironmental:boolean;
   PtHNC:boolean;
   PtMST:boolean;
   PtSHAD:boolean;
   PtCL: Boolean;
   constructor Create(Alist:TStringList);
   function GetGMPDFN(dfn:string;name:String):string;
   function Today:string;
 end;

 { User params}
 TPLUserParams=class(TObject)
   usPrimeUser:Boolean; {GMPLUSER true if clinical entry, false if clerical}
   usDefaultView:String;
   usCurrentView:String; {what view does user currently have? (OP,IP,Preferred,Unfilterred)}
   usVerifyTranscribed:Boolean; {authority to verify transcribed problems}
   usPromptforCopy:boolean;
   usUseLexicon:boolean; {user will be using Lexicon}
   usReverseChronDisplay:Boolean;
   usViewAct:String; {viewing A)ctive, I)nactive, B)oth, R)emoved problems}
   usViewProv:String; {prov (ptr #200) of  displayed list or 0 for all}
   usService:String; {user's service/section}
   {I can't see where either of the ViewClin or ViewServ vals are setup in the
    M application. They are documented in the PL V2.0 tech manual though}
   usViewServ:string; {should be a list of ptr to file 49, format ptr/ptr/...}
   usViewClin:string; {should be a list of ptr to file 44, format ptr/ptr/...}
   usViewComments: string;
   usDefaultContext: string;
   usTesting:boolean; {used for test purposes only}
   usClinList:TstringList;
   usServList:TstringList;
   usSuppressCodes: Boolean; {Suppress presentation of codes during Lexicon Look-up}
   constructor Create(alist:TstringList);
   destructor Destroy; override;
 end;

 {filter lists}
 TPLFilters = class(TObject)
   ProviderList:TstringList;
   ClinicList:TstringList;
   ServiceList:TStringList;
   constructor create;
   destructor Destroy; override;
 end;

{problem record}
 TProbRec = class(TObject)
 private
   fNewrec:Tstringlist;
   fOrigRec:TStringList;
   fPIFN:String;
   fDiagnosis:Tkeyval;        {.01}
   fModDate:TKeyVal;          {.03}
   fNarrative:TKeyVal;        {.05}
   fEntDate:TKeyVal;          {.08}
   fStatus:TKeyVal;           {.12}
   fOnsetDate:TKeyVal;        {.13}
   fProblem:TKeyVal;          {1.01}
   fCondition:TKeyVal;        {1.02}
   fEntBy:TKeyVal;            {1.03}
   fRecBy:TKeyVal;            {1.04}
   fRespProv:TKeyVal;         {1.05}
   fService:TKeyVal;          {1.06}
   fResolveDate:TKeyVal;      {1.07}
   fClinic:TKeyVal;           {1.08}
   fRecordDate:TKeyVal;       {1.09}
   fServCon:TKeyVal;          {1.1}
   fAOExposure:TKeyVal;       {1.11}
   fRadExposure:TKeyVal;      {1.12}
   fGulfExposure:TKeyVal;     {1.13}
   fPriority:TKeyVal;         {1.14}
   fHNC:TKeyVal;              {1.15}
   fMST:TKeyVal;              {1.16}
   fCV:TKeyVal;               {1.17}  // this is not used  value is always NULL
   fSHAD:TKeyVal;             {1.18}
   fCL:TKeyVal;               {1.19}
   fSCTConcept:TKeyval;       {80001}
   fSCTDesignation:TKeyVal;   {80002}
   fNTRTRequested: TKeyVal;   {80101}
   fNTRTComment: TKeyVal;     {80102}
   fCodeDate: TKeyVal;        {80201}
   fCodeSystem: TKeyVal;      {80202}
   fFieldList:TstringList; {list of fields by name and class (TKeyVal or TComment)}
   fFilerObj:TstringList;
   fCmtIsXHTML: boolean;
   fCmtNoEditReason: string;
   Procedure LoadField(Fldrec:TKeyVal;Id:String;name:string);
   Procedure CreateFields;
   procedure LoadComments;
   procedure SetDate(datefld:TKeyVal;dt:TDateTime);
   function GetModDate:TDateTime;
   procedure SetModDate(value:TDateTime);
   function GetEntDate:TDateTime;
   procedure SetEntDate(value:TDateTime);
   procedure SetOnsetDate(value:TDateTime);
   function GetOnsetDate:TDateTime;
   Function GetSCProblem:String;
   Procedure SetSCProblem(value:String);
   Function GetAOProblem:String;
   Procedure SetAOProblem(value:String);
   Function GetRADProblem:String;
   Procedure SetRADProblem(value:String);
   Function GetENVProblem:String;
   Procedure SetENVProblem(value:String);
   Function GetHNCProblem:String;
   Procedure SetHNCProblem(value:String);
   Function GetMSTProblem:String;
   Procedure SetMSTProblem(value:String);
   Function GetSHADProblem:String;
   Procedure SetSHADProblem(value:String);
   Function GetCLProblem:String;
   Procedure SetCLProblem(value:String);
   function GetStatus:String;
   procedure SetStatus(value:String);
   function GetPriority:String;
   procedure SetPriority(value:String);
   function GetRESDate:TDateTime;
   procedure SetRESDate(value:TDateTime);
   function GetRECDate:TDateTime;
   procedure SetRECDate(value:TDateTime);
   procedure SetNarrative(value:TKeyVal);
   function GetTDateTime(dt:string):TDateTime;
   function GetFilerObject:TstringList;
   function GetAltFilerObject:TstringList;
   function GetCommentCount:integer;
   Procedure EraseComments(clist:TList);
   function GetModDatstr:string;
   procedure SetModDatStr(value:string);
   function GetEntDatstr:string;
   procedure SetEntDatStr(value:string);
   function GetOnsetDatstr:string;
   procedure SetOnsetDatStr(value:string);
   function GetResDatstr:string;
   procedure SetResDatStr(value:string);
   function GetRecDatstr:string;
   procedure SetRecDatStr(value:string);
   procedure SetDateString(df:TKeyVal;value:string);
   function GetCondition:string;
   procedure SetCondition(value:String);
   function GetCodeDate: TDateTime;
   procedure SetCodeDate(value: TDateTime);
   function GetCodeDateStr: String;
   procedure SetCodeDateStr(value: String);
 public
   fComments:TList; {comments}
   fCoordExprs:TList; {coordinate expressions}
   procedure AddNewComment(Txt:string);
   procedure AddNewCoordExpr(Txt:string);
   function FieldChanged(fldName:string):Boolean;
   constructor Create(AList:TstringList);
   destructor Destroy;override;
   property RawNewRec:TstringList read fNewRec;
   property RawOrigRec:TStringList read fOrigRec;
   property DateModified:TDateTime read GetModDate write SetModDate;
   property DateModStr:string read GetModDatStr write SetModDatStr;
   property DateEntered:TDateTime read GetEntDate write SetEntDate;
   property DateEntStr:string read GetEntDatStr write SetEntDatStr;
   property DateOnset:TDateTime read GetOnsetDate write SetOnsetDate;
   property DateOnsetStr:string read GetOnsetDatStr write SetOnsetDatStr;
   property SCProblem:String read GetSCProblem write SetSCProblem;
   property AOProblem:String read GetAOProblem write SetAOProblem;
   property RADProblem:String read GetRadProblem write SetRADProblem;
   property ENVProblem:String read GetENVProblem write SetENVProblem;
   property HNCProblem:String read GetHNCProblem write SetHNCProblem;
   property MSTProblem:String read GetMSTProblem write SetMSTProblem;
   property SHADProblem:String read GetSHADProblem write SetSHADProblem;
   property CLProblem:String read GetCLProblem write SetCLProblem;
   property Status:String read GetStatus write SetStatus;
   property Narrative:TKeyVal read fNarrative write SetNarrative;
   property Diagnosis:TKeyVal read fDiagnosis write fDiagnosis;
   property SCTConcept:TKeyVal read fSCTConcept write fSCTConcept;
   property SCTDesignation:TKeyVal read fSCTDesignation write fSCTDesignation;
   property NTRTRequested:TKeyVal read fNTRTRequested write fNTRTRequested;
   property NTRTComment:TKeyVal read fNTRTComment write fNTRTComment;
   property CodeDate: TDateTime read GetCodeDate write SetCodeDate;
   property CodeDateStr: String read GetCodeDateStr write SetCodeDateStr;
   property CodeSystem: TKeyVal read fCodeSystem write fCodeSystem;
   property Problem:TKeyVal read fProblem write fProblem;
   property RespProvider:TKeyVal read fRespProv write fRespProv;
   property EnteredBy:TKeyVal read fEntBy write fEntBy;
   property RecordedBy:TKeyVal read fRecBy write fRecBy;
   property Service:TKeyVal read fService write fService;
   property Clinic:TKeyVal read fClinic write fClinic;
   property DateResolved:TDateTime read GetResDate write SetResdate;
   property DateResStr:string read GetResDatStr write SetResDatStr;
   property DateRecorded:TDateTime read GetRecDate write SetRecdate;
   property DateRecStr:string read GetRecDatStr write SetRecDatStr;
   property Priority:string read GetPriority write SetPriority;
   property Comments:TList read fComments write fComments;
   property CoordExprs: TList read fCoordExprs write fCoordExprs;
   property Condition:string read GetCondition write SetCondition;
   property CommentCount:integer read GetCommentCount;
   property FilerObject:TstringList read GetFilerObject;
   property AltFilerObject:TstringList read GetAltFilerObject;
   property PIFN:string read fPIFN write fPIFN;
   property CmtIsXHTML: boolean read fCmtIsXHTML;
   property CmtNoEditReason: string read fCmtNoEditReason;
 end;

var
  ProbRec         :TProbRec;
  PLPt            :TPLPt;
  PLUser          :TPLUserParams;
  pProviderID     :int64; {this is provider reviewing record, not resp provider}
  pProviderName   :string; {ditto}
  PLFilters       :TPLFilters;
  PLProblem       :string; {this is problem selected from lexicon lookup form}
  RequestNTRT     :Boolean;
  NTRTComment :String;

procedure GetListforIP(Alist:TstringList; AGrid: TCaptionListBox);
procedure GetListforOP(Alist:TstringList; AGrid: TCaptionListBox);
procedure LoadFilterList(Alist:TstringList;DestList:TstringList);
procedure ShowFilterStatus(s: string);
procedure InitViewFilters(Alist:TstringList);
procedure SetViewFilters(Alist:TStringList);
Function DateStringOK(ds:string):string;
Function StripSpace(str:string):string;
function ByProvider:String;
function ForChars(Num, FontWidth: Integer): Integer;
procedure GetFontInfo(AHandle: THandle; var FontWidth, FontHeight: Integer);
function ShortDateStrToDate(shortdate: string): string ;
//function NewComment: string    ;
//function EditComment(OldValue: string): string ;
function FixQuotes(Instring: string): string;

implementation

uses
  uGlobalVar, rCore, uCore, System.Types, rMisc;

const
  Months: array[1..12] of string[3] = ('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC');

{------------------- TKeyVal Class -----------------}
function TKeyVal.GetDHCPField:string;
begin
  result := intern + u + extern;
end;

procedure TKeyVal.DHCPtoKeyVal(DHCPFld:String);
begin
  intern := Piece(DHCPFld,u,1);
  extern := Piece(DHCPFLd,u,2);
end;

{------------------- TComment Class ----------------}
constructor TComment.Create(dhcpcom:string);
begin
  {create and instantiate a Tcomment object}
  IFN:=Piece(dhcpcom,u,1);
  Facility:=Piece(dhcpcom,u,2);
  Narrative:=Piece(dhcpcom,u,3);
  Status:=Piece(dhcpcom,u,4);
  DateAdd:=Piece(dhcpcom,u,5);
  AuthorID:=Piece(dhcpcom,u,6);
  AuthorName:=Piece(dhcpcom,u,7);
  StatusFlag:='';
end;

destructor TComment.Destroy;
begin
  inherited destroy;
end;

function TComment.TComtoDHCPCom:string;
begin
  Narrative := FixQuotes(Narrative);
  if uppercase(IFN)='NEW' then {new note}
    result := Narrative
  else {potential edit of existing note}
    result := IFN + u + Facility + u + Narrative + u +
            Status + u + DateAdd + u + AuthorID; {leave off author name}
end;

function TComment.GetExtDateAdd:String;
begin
  result := FormatFMDateTime('dddddd',StrToFloat(DateAdd)) ;
end;

function TComment.Getage:boolean;
begin
  result := uppercase(IFN)='NEW';
end;

{------------------- TCoordExpr Class ----------------}
constructor TCoordExpr.Create(dhcpCoordExpr:string);
begin
  {create and instantiate a TCoordExpr object}
  IFN := Piece(dhcpCoordExpr, u, 1);
  icdId := Piece(dhcpCoordExpr, u, 2);
  icdCode := Piece(dhcpCoordExpr, u, 3);
  snomedConcept := Piece(dhcpCoordExpr, u, 4);
  snomedDesignation := Piece(dhcpCoordExpr, u, 5);
  snomedConceptVUID := Piece(dhcpCoordExpr, u, 6);
  snomedDesignationVUID := Piece(dhcpCoordExpr, u, 7);
end;

destructor TCoordExpr.Destroy;
begin
  inherited destroy;
end;

function TCoordExpr.TCoordExprtoDHCPCoordExpr: String;
begin
  result := IFN + u + icdId + u + icdCode + u + snomedConcept + u +
          snomedDesignation + u + snomedConceptVUID + u + snomedDesignationVUID;
end;

{-------------------------- TPLPt Class ----------------------}
constructor TPLPt.Create(Alist:TStringList);
var
  i: integer;
begin
  for i := 0 to AList.Count - 1 do
    case i of
      0: PtVAMC             := copy(Alist[i],1,999);
      1: PtDead             := AList[i];
      2: PtServiceConnected := (AList[i] = '1');
      3: PtAgentOrange      := (AList[i] = '1');
      4: PtRadiation        := (AList[i] = '1');
      5: PtEnvironmental    := (AList[i] = '1');
      6: PtBID              := Alist[i];
      7: PtHNC              := (AList[i] = '1');
      8: PtMST              := (AList[i] = '1');
     //9:CombatVet   Not tracked in Problem list
      10: PtSHAD             := (AList[i] = '1');
      11: PtCL               := (AList[i] = '1');
    end;
end;

function TPLPt.GetGMPDFN(dfn:string;name:string):string;
begin
  result := dfn + u + name + u + PtBID + u + PtDead
end;

function TPLPt.Today:string;
{returns string in DHCP^mmm dd yyyy format}
begin
  result := Piece(FloatToStr(FMToday),'.',1) + u + FormatFMDateTime('dddddd',FMToday) ;
end;

{-------------------- TUserParams -------------------------------}
constructor TPLUserParams.create(alist:TstringList);
var
  p:string;
  i:integer;
begin
  usPrimeUser           := false;
  usDefaultView         := '';
  usVerifyTranscribed   := True;   // SHOULD DEFAULT BE FALSE???
  usPromptforCopy       := false;
  usUseLexicon          := false;
  usReverseChronDisplay := true;
  usViewAct             := 'A';
  usViewProv            := '0^All';
  usService             := '';
  usViewcomments        := '0';
  usClinList            := TstringList.create;
  usServList            := TstringList.create;
  if alist.count=0 then exit;  {BAIL OUT IF LIST EMPTY}
  //usPrimeUser           := False;  {for testing}
  usPrimeUser           := (alist[0]='1');
  usDefaultView         := alist[1];
  if usDefaultView = '' then
    begin
      if Patient.Inpatient then usDefaultView := PL_IP_VIEW
      else usDefaultView := PL_OP_VIEW;
    end;
  usVerifyTranscribed   := (alist[2]='1');
  usPromptforCopy       := (alist[3]='1');
  //usUseLexicon          := False;  {for testing}
  usUseLexicon          := (alist[4]='1');
  usReverseChronDisplay := (alist[5]='1');
  usViewAct             := alist[6];
  usViewProv            := alist[7];
  usService             := alist[8];
  usViewServ            := alist[9];
  usViewClin            := alist[10];
  usTesting             := (alist[11]<>'');
  usViewComments        := AList[12];
  usSuppressCodes       := (Alist[13]='1');
  usCurrentView         := usDefaultView;
  usDefaultContext      := ';;' + usViewAct + ';' + usViewComments + ';' + Piece(usViewProv, U, 1);
  if usViewClin <> '' then
    begin
      i := 1;
      repeat
        begin
          p := Piece(usViewClin,'/',i);
          inc(i);
          if p <> '' then usClinList.add(p);
        end;
      until p = '';
    end;
  if usViewServ <> '' then
    begin
      i := 1;
      repeat
        begin
          p := Piece(usViewServ,'/',i);
          inc(i);
          if p <> '' then usServList.add(p);
        end;
      until p = '';
    end;
end;

destructor TPLUserParams.Destroy;
begin
  usClinList.free;
  usServList.free;
  inherited destroy;
end;

{-------------------- TPLFilters -------------------}
constructor TPLFilters.Create;
begin
  ProviderList := TstringList.create;
  ClinicList   := TstringList.create;
  ServiceList  := TStringList.create;
end;

destructor  TPLFilters.destroy;
begin
  ProviderList.free;
  ClinicList.Free;
  ServiceList.Free;
  inherited destroy;
end;

{------------------ TProbRec -----------------------}
constructor TProbRec.create(AList:TstringList);
var
  i: integer;
begin
  fFieldList := TstringList.create;
  fFilerObj := TStringList.Create;
  fNewRec := TstringList.create;
  for i := 0 to Pred(Alist.count) do
    if copy(Alist[i],1,3) = 'NEW' then fNewRec.add(Alist[i]);
  fOrigRec := TStringList.Create;
  for i := 0 to pred(Alist.count) do
    if copy(Alist[i],1,3) = 'ORG' then fOrigRec.add(Alist[i]);
  CreateFields;
  {names selected to agree with subscripts of argument array to callable
   entrypoints in ^GMPUTL where possible.}
  LoadField(fDiagnosis,'.01','DIAGNOSIS');
  LoadField(fModDate,'.03','MODIFIED');
  LoadField(fNarrative,'.05','NARRATIVE');
  LoadField(fEntDate,'.08','ENTERED');
  LoadField(fStatus,'.12','STATUS');
  LoadField(fOnsetDate,'.13','ONSET');
  LoadField(fProblem,'1.01','LEXICON');
  LoadField(fCondition,'1.02','CONDITION');
  LoadField(fEntBy,'1.03','ENTERER');
  LoadField(fRecBy,'1.04','RECORDER');
  LoadField(fRespProv,'1.05','PROVIDER');
  LoadField(fService,'1.06','SERVICE');
  LoadField(fResolveDate,'1.07','RESOLVED');
  LoadField(fClinic,'1.08','LOCATION');
  LoadField(fRecordDate,'1.09','RECORDED');
  LoadField(fServCon,'1.1','SC');
  LoadField(fAOExposure,'1.11','AO');
  LoadField(fRadExposure,'1.12','IR');
  LoadField(fGulfExposure,'1.13','EC');
  LoadField(fPriority,'1.14','PRIORITY');
  LoadField(fHNC,'1.15','HNC');
  LoadField(fMST,'1.16','MST');
  LoadField(fCV,'1.17','CV');   // not used at this time
  LoadField(fSHAD,'1.18','SHD');
  LoadField(fCL, '1.19', 'CL');
  LoadField(fSCTConcept,'80001','SCTC');
  LoadField(fSCTDesignation,'80002','SCTD');
  LoadField(fNTRTRequested, '80101', 'NTRT');
  LoadField(fNTRTComment, '80102', 'NTRTC');
  LoadField(fCodeDate, '80201', 'CODEDT');
  LoadField(fCodeSystem, '80202', 'CODESYS');
  LoadComments;
end;

destructor TProbRec.destroy;
begin
  fOrigRec.free;
  fNewrec.free;
  fDiagnosis.free;
  fModDate.free;
  fNarrative.free;
  fEntDate.free;
  fStatus.free;
  fOnsetDate.free;
  fProblem.free;
  fCondition.free;
  fRespProv.free;
  fEntBy.free;
  fRecBy.Free;
  fService.free;
  fResolveDate.free;
  fClinic.free;
  fRecordDate.free;
  fServCon.free;
  fAOExposure.free;
  fRadExposure.free;
  fGulfExposure.free;
  fPriority.free;
  fHNC.free;
  fMST.free;
  fSHAD.Free;
  fCV.Free;
  fCL.Free;
  fSCTConcept.free;
  fSCTDesignation.free;
  fNTRTRequested.Free;
  fNTRTComment.Free;
  fFieldList.free;
  fFilerObj.free;
  EraseComments(fComments);
  fComments.free;
  inherited Destroy;
end;

procedure TProbRec.EraseComments(clist:TList);
var
  i:integer;
begin
  if clist.count>0 then
    begin
      for i:=0 to pred(clist.count) do
        TComment(clist[i]).free;
    end;
end;

procedure TProbRec.CreateFields;
begin
  fDiagnosis:=TKeyVal.create;
  fModDate:=TKeyVal.create;
  fNarrative:=TKeyVal.create;
  fEntDate:=TKeyVal.create;
  fStatus:=TKeyVal.create;
  fOnsetDate:=TKeyVal.create;
  fProblem:=TKeyVal.create;
  fCondition:=TKeyVal.create;
  fEntBy:=TKeyVal.create;
  fRecBy:=TKeyVal.create;
  fRespProv:=TKeyVal.create;
  fService:=TKeyVal.create;
  fResolveDate:=TKeyVal.create;
  fClinic:=TKeyVal.create;
  fRecordDate:=TKeyVal.create;
  fServCon:=TKeyVal.create;
  fAOExposure:=TKeyVal.create;
  fRadExposure:=TKeyVal.create;
  fGulfExposure:=TKeyVal.create;
  fPriority:=TKeyVal.create;
  fHNC:=TKeyVal.create;
  fMST:=TKeyVal.create;
  fCV := TKeyVal.create;
  fSHAD:=TKeyVal.Create;
  fCL := TKeyVal.Create;
  fSCTConcept:=TKeyVal.Create;
  fSCTDesignation:=TKeyVal.Create;
  fNTRTRequested := TKeyVal.Create;
  fNTRTComment := TKeyVal.Create;
  fCodeDate := TKeyVal.create;
  fCodeSystem := TKeyVal.create;
  fComments:=TList.create;
end;

procedure TProbRec.LoadField(Fldrec:TKeyVal;Id:String;name:string);
var
  i:integer;
  fldval:string;

  function GetOrigVal(id:string):string;
  var
    i:integer;
  begin
    i := 0;
    Result := '^';
    if fOrigRec.count = 0 then exit;
    while (i < fOrigRec.Count) and (Piece(fOrigRec[i],v,2)<>id) do inc(i);
    if i = fOrigRec.Count then exit;
    if Piece(fOrigRec[i],v,2) = id then Result := Piece(fOrigRec[i],v,3)
  end;

begin
  i := -1;
  repeat
   inc(i);
  until (Piece(fNewRec[i],v,2) = id) or (i = Pred(fNewRec.count));
  if Piece(fNewrec[i],v,2) = id then
    fldVal := Piece(fNewrec[i],v,3)
  else
    fldVal := '^';
  fldRec.id := id;
  fldrec.name := name;
  fldRec.intern := Piece(fldVal,'^',1);
  fldRec.extern := Piece(fldval,'^',2);
  {get the original values for later comparison}
  fldVal := GetOrigVal(id);
  fldRec.internOrig := Piece(fldVal,'^',1);
  fldRec.externOrig := Piece(fldVal,'^',2);
  {add this field to list}
  fFieldList.addobject(id,fldrec);
end;

procedure TProbrec.LoadComments;
var
  i,j:integer;
  cv, noedit:string;
  co:TComment;
  first:boolean;
begin
  j := 1; {first comment must be 1 or greater}
  first := true;
  for i := 0 to Pred(fNewRec.count) do
  begin
    if Piece(Piece(fNewRec[i],v,2),',',1) = '10' then
    begin
      if first then {the first line is just a counter}
      begin
        first := false;
        // 'NEW-10,0-1^These notes are now in XHTML format and must be modified via CPRS-R.'
        noedit := Piece(fNewRec[i], v, 3);
        if Piece(noedit, U, 1) = '-1' then
        begin
          fCmtIsXHTML := TRUE;
          fCmtNoEditReason := Piece(noedit, U, 2);
        end
        else
        begin
          fCmtIsXHTML := FALSE;
          fCmtNoEditReason := '';
        end;
      end
      else
      begin
        cv := Piece(fNewRec[i],v,3);
        co := TComment.Create(cv);
        fComments.add(co); {put object in list}
        fFieldList.addObject('10,' + inttostr(j),co);
        inc(j);
      end;
    end;
  end;
end;

function TProbRec.GetCodeDate: TDateTime;
var
  dt:string;
begin
  dt := fCodeDate.extern;
  result := GetTDateTime(dt);
end;

function TProbRec.GetCodeDateStr: String;
begin
  result := fCodeDate.extern;
end;

function TProbRec.GetCommentCount:integer;
begin
  result := fComments.count;
end;

procedure TProbRec.AddNewComment(Txt:string);
var
  cor:TComment;
begin
  cor := TComment.create('NEW^^' + txt + '^A^' + FloatToStr(FMToday) + '^' + IntToStr(User.DUZ));
  fComments.add(cor);
  fFieldList.addObject('10,"NEW",' + inttostr(fComments.count),cor);
end;

procedure TProbRec.AddNewCoordExpr(txt: string);
var
  ce: TCoordExpr;
begin
  ce := TCoordExpr.create('NEW^^' + txt + '^A^' + FloatToStr(FMToday) + '^' + IntToStr(User.DUZ));
  fCoordExprs.add(ce);
  fFieldList.addObject('10,"NEW",' + inttostr(fComments.count), ce);
end;

function TProbrec.GetModDate:TDateTime;
var
  dt:string;
begin
  dt := fModDate.extern;
  result := GetTDateTime(dt);
end;

procedure TProbrec.SetModDate(value:TDateTime);
begin
  SetDate(fModDate,value);
end;

function TProbRec.GetModDatstr:string;
begin
  result := fModdate.extern;
end;

procedure TProbRec.SetModDatStr(value:String);
begin
  SetDateString(fModDate,value);
end;

procedure TProbRec.SetDateString(df:TKeyVal;value:string);
var
  {c:char;
  days:longint;}
  fmresult: double ;
begin
  {try  }
  if (value = '') then
    begin
      df.Intern := '';
      df.Extern := '';
    end
  else
    begin
      fmresult := StrToFMDateTime(value) ;
      if fmresult = -1 then
        begin
          df.intern := '0';
          df.extern := '';
        end
      else
        begin
          df.intern := Piece(FloatToStr(fmresult),'.',1);
          df.extern := FormatFMDateTime('dddddd',fmresult);
        end ;
    end;
end;

function  TProbrec.GetEntDate:TDateTime;
var
  dt:string;
begin
  dt := fEntDate.extern;
  result := GetTDateTime(dt);
end;

procedure TProbrec.SetEntDate(value:TDateTime);
begin
  SetDate(fEntDate,value);
end;

function TProbRec.GetEntDatstr:string;
begin
  result:=fEntdate.extern;
end;

procedure TProbRec.SetEntDatStr(value:String);
begin
  SetDateString(fEntDate,value);
end;

function  TProbrec.GetOnsetDate:TDateTime;
var
  dt:string;
begin
  dt := fOnsetDate.extern;
  result := GetTDateTime(dt);
end;

procedure TProbrec.SetOnsetDate(value:TDateTime);
begin
  SetDate(fOnsetDate,value);
end;

function TProbRec.GetOnsetDatstr:string;
begin
  result := fOnsetdate.extern;
end;

procedure TProbRec.SetOnsetDatStr(value:String);
begin
  SetDateString(fOnsetDate,value);
end;

procedure TProbrec.SetDate(datefld:TKeyVal;dt:TDateTime);
begin
  datefld.extern := DatetoStr(dt);
  datefld.intern := FloatToStr(DateTimetoFMDateTime(dt));
end;

function TProbrec.GetSCProblem:String;
begin
  result := fServCon.Intern;
end;

function TProbRec.GetCondition:string;
begin
  result := fCondition.Intern;
end;

procedure TProbRec.SetCodeDate(value: TDateTime);
begin
  SetDate(fCodeDate,value);
end;

procedure TProbRec.SetCodeDateStr(value: String);
begin
  SetDateString(fCodeDate, value);
end;

procedure TProbRec.SetCondition(value:string);
begin
  if (uppercase(value[1])='T') or (value='1') then
    begin
      fCondition.intern := 'T';
      fCondition.extern := 'Transcribed';
    end
  else if (uppercase(value[1]) = 'P') or (value = '0') then
    begin
      fCondition.intern := 'P';
      fCondition.extern := 'Permanent';
    end
  else if uppercase(value[1]) = 'H' then
    begin
      fCondition.intern := 'H';
      fCondition.extern := 'Hidden';
    end;
end;

procedure TProbRec.SetSCProblem(value:String);
begin
  if value = '1' then
  begin
    fServCon.intern := '1';
    fServCon.Extern := 'YES';
  end
  else if value = '0' then
  begin
    fServCon.intern := '0';
    fServCon.Extern := 'NO';
  end
  else
  begin
    fServCon.intern :='';
    fServCon.extern := 'Unknown';
  end;
end;

function  TProbrec.GetAOProblem:String;
begin
  result := fAOExposure.Intern;
end;

procedure TProbRec.SetAOProblem(value:String);
begin
  if value = '1' then
  begin
    fAOExposure.intern := '1';
    fAOExposure.extern := 'Yes';
  end
  else if value = '0' then
  begin
    fAOExposure.intern := '0';
    fAOExposure.extern := 'No';
  end
  else
  begin
    fAOExposure.intern := '';
    fAOExposure.extern := 'Unknown';
  end;
end;

function  TProbrec.GetRADProblem:String;
begin
  result := fRADExposure.Intern;
end;

procedure TProbRec.SetRADProblem(value:String);
begin
  if value = '1' then
  begin
    fRADExposure.intern := '1';
    fRADExposure.extern := 'Yes';
  end
  else if value  = '0' then
  begin
    fRADExposure.intern := '0';
    fRADExposure.extern := 'No';
  end
  else
  begin
    fRADExposure.intern := '';
    fRADExposure.extern := 'Unknown';
  end;
 end;

function TProbrec.GetENVProblem:String;
begin
  result := fGulfExposure.Intern;
end;

procedure TProbRec.SetENVProblem(value:String);
begin
  if value = '1' then
  begin
    fGulfExposure.intern := '1';
    fGulfExposure.extern := 'Yes';
  end
  else if value = '0' then
  begin
    fGulfExposure.intern := '0';
    fGulfExposure.extern := 'No';
  end
  else
  begin
    fGulfExposure.intern := '';
    fGulfExposure.extern := 'Unknown';
  end;
 end;

function TProbrec.GetHNCProblem:String;
begin
  result := fHNC.Intern;
end;

procedure TProbRec.SetHNCProblem(value:String);
begin
  if value = '1' then
  begin
    fHNC.intern := '1';
    fHNC.extern := 'Yes';
  end
  else if value = '0' then
  begin 
    fHNC.intern := '0';
    fHNC.extern := 'No';
  end
  else
  begin
    fHNC.intern := '';
    fHNC.extern := 'Unknown';
  end;

 end;

function TProbrec.GetMSTProblem:String;
begin
  result := fMST.Intern;
end;

procedure TProbRec.SetMSTProblem(value:String);
begin
  if value = '1' then
  begin
    fMST.intern := '1';
    fMST.extern := 'Yes';
  end
  else if value = '0' then
  begin
    fMST.intern := '0';
    fMST.extern := 'No';
  end
  else
  begin
    fMST.intern := '';
    fMST.extern := 'Unknown';
  end;
 end;

function TProbrec.GetSHADProblem:String;
begin
    result := fSHAD.intern;
end;

procedure TProbRec.SetSHADProblem(value:String);
begin
    if value = '1' then
    begin
      fSHAD.intern := '1';
      fSHAD.extern := 'Yes';
    end
    else if value = '0' then
    begin
      fSHAD.intern := '0';
      fSHAD.extern := 'No';
    end
    else
    begin
        fSHAD.intern := '';
        fSHAD.extern := 'Unknown';
    end;
end;

function TProbrec.GetCLProblem:String;
begin
    result := fCL.intern;
end;

procedure TProbRec.SetCLProblem(value:String);
begin
    if value = '1' then
    begin
      fCL.intern := '1';
      fCL.extern := 'Yes';
    end
    else if value = '0' then
    begin
      fCL.intern := '0';
      fCL.extern := 'No';
    end
    else
    begin
        fCL.intern := '';
        fCL.extern := 'Unknown';
    end;
end;


function TProbRec.GetStatus:String;
begin
  result := Uppercase(fStatus.intern);
end;

procedure TProbRec.SetStatus(value:String);
begin
  if (UpperCase(Value) = 'ACTIVE') or (Uppercase(value) = 'A') then
    begin
      fStatus.intern := 'A';
      fStatus.extern := 'ACTIVE';
    end
  else
    begin
      fStatus.intern := 'I';
      fStatus.extern := 'INACTIVE';
    end;
end;

function TProbRec.GetPriority:String;
begin
  result := Uppercase(fPriority.intern);
end;

procedure TProbRec.SetPriority(value:String);
begin
  if (UpperCase(Value) = 'ACUTE') or (Uppercase(value) = 'A') then
  begin
    fPriority.intern := 'A';
    fPriority.extern := 'ACUTE';
  end
  else if (UpperCase(Value) = 'CHRONIC') or (UpperCase(value) = 'C') then
  begin
    fPriority.intern := 'C';
    fPriority.extern := 'CHRONIC';
  end
  else
  begin
    fPriority.intern := '@';
    fPriority.extern := '';
  end;
end;

function  TProbrec.GetResDate:TDateTime;
var
  dt:string;
begin
  dt := fResolveDate.extern;
  result := GetTDateTime(dt);
end;

procedure TProbrec.SetResDate(value:TDateTime);
begin
  SetDate(fResolveDate,value);
end;

function TProbRec.GetResDatstr:string;
begin
  result := fResolvedate.extern;
end;

procedure TProbRec.SetResDatStr(value:String);
begin
  SetDateString(fResolveDate,value);
end;

function TProbrec.GetRecDate:TDateTime;
var
  dt:string;
begin
  dt := fRecordDate.extern;
  result := GetTDateTime(dt);
end;

procedure TProbrec.SetRecDate(value:TDateTime);
begin
  SetDate(fRecordDate,value);
end;

function TProbRec.GetRecDatstr:string;
begin
  result := fRecordDate.extern;
end;

procedure TProbRec.SetRecDatStr(value:String);
begin
  SetDateString(fRecordDate,value);
end;

procedure TProbRec.SetNarrative(value:TKeyVal);
begin
  if (value.intern = '') or (value.extern = '') then
    begin
      InfoBox('Both internal and external values required', 'Error', MB_OK or MB_ICONERROR);
      exit;
    end;
  fNarrative.intern := value.intern;
  fNarrative.extern := value.extern;
end;

function TProbRec.GetTDateTime(dt:string):TDateTime;
begin
  try
    if dt = '' then result := 0 else result := StrtoDate(dt);
  except on exception do
    result := 0;
  end;
end;

{--------------------------------- Filer Objects -------------------------}

function TProbRec.GetFilerObject:TstringList;
{return array for filing in dhcp}
var
  i:integer;
  fldID,fldVal: string;
begin
  fFilerObj.clear;
  for i := 0 to pred(fFieldList.count) do
    begin
      fldID := fFieldList[i];
      if pos(',',fldID)>0 then {is a comment field}
        fldVal := TComment(fFieldList.objects[i]).TComtoDHCPCom
      else {is a regular field}
        begin
          if fldID = '1.02' then {have to make exception for CONDITION field}
            fldVal := TKeyVal(fFieldList.objects[i]).intern
          else
            fldVal := FixQuotes(TKeyVal(fFieldList.objects[i]).DHCPField);
        end;
      fFilerObj.add('GMPFLD(' + fldID + ')="' + fldVal + '"');
    end;
  fFilerObj.add('GMPFLD(10,0)="' + inttostr(fComments.count) + '"');
   {now get original fields}
  for i := 0 to pred(fOrigRec.count) do
    begin
      fldVal  := fOrigRec[i];
      fldID   := Piece(fldVal,v,2);
      fldVal  := FixQuotes(Piece(fldVal,v,3));
      fFilerObj.add('GMPORIG(' + fldID + ')="' + fldVal + '"');
    end;
  result := fFilerObj;
end;

function TProbRec.GetAltFilerObject:TstringList;
{return array for filing in dhcp via UPDATE^GMPLUTL}
{NOTES:
  - leave narrative out, looks like inclusion causes new entry
  - Date recorded (1.09) is non-editable, causes error if present}
var
  i: integer;
  fldID,fldVal, Fields: string;
begin
  fFilerObj.Clear;
  if IsLejeuneActive then
   Fields := '^.01^.12^.13^1.01^1.05^1.07^1.08^1.1^1.11^1.12^1.13^1.15^1.16^1.18^1.19^80001^80002^80201^80202^'
  else
   Fields := '^.01^.12^.13^1.01^1.05^1.07^1.08^1.1^1.11^1.12^1.13^1.15^1.16^1.18^80001^80002^80201^80202^';
  for i := 0 to pred(fFieldList.count) do
    begin
      fldID := fFieldList[i];
      if pos(u + fldID + u, Fields) > 0 then
        {is a field eligible for update}
        begin
          fldVal := TKeyVal(fFieldList.objects[i]).intern;
          fFilerObj.add('ORARRAY("' + TkeyVal(fFieldList.objects[i]).Name + '")="' + fldVal + '"');
        end;
    end;
  fFilerObj.add('ORARRAY("PROBLEM")="' + fPIFN + '"');
  result := fFilerObj;
end;

function TProbRec.FieldChanged(fldName:string):boolean;
var
  i: integer;
begin
  i := -1;
  repeat
    inc(i);
  until (TKeyVal(fFieldList.objects[i]).name = fldName) or
        (i=Pred(fFieldList.count));
  if (TKeyVal(fFieldList.objects[i]).name = fldName) and
     (TKeyVal(fFieldList.objects[i]).intern = TKeyVal(fFieldList.objects[i]).internOrig) then
    Result := false
  else
    Result := true;
end;

{----------------------------------- Check Date -------------------------------}

function DateStringOK(ds: string): string;
var
  fmresult: double ;
begin
  ds := StripSpace(ds);
  result := ds;
  if ds = '' then exit;
  if Copy(ds,1,1) = ',' then ds := Copy(ds, 2, 99) ;
  fmresult := StrToFMDateTime(ds) ;
  if fmresult = -1 then
    result := 'ERROR'
  else
    result := FormatFMDateTime('dddddd',fmresult) ;
end;

function StripSpace(str: string): string;
var
  i,j: integer;
begin
  i := 1;
  j := length(str);
  while str[i] = #32 do inc(i);
  while str[j] = #32 do dec(j);
  result := copy(str, i, j-i+1);
end;

{-------------------- procedures used in View Filters ----------------------}

procedure GetListforIP(Alist:TstringList; AGrid: TCaptionListBox);
var
  i:integer;
  sv:string;
  anon:boolean;
begin
  anon:=false;
  with AGrid do
    for i := 0 to pred(items.count) do
      begin
        //pt := cells[12,i];
          {location type is ward, or no clinic and service is non nil}
        {if (pt = PL_WARD) or ((cells[10,i] = '') and (cells[11,i] <> '')) then
          begin }
            sv := Piece( items[i], U, 12);
            if sv <> '' then
              begin
                if Alist.indexof(sv) < 0 then Alist.add(sv);
              end
            else if (sv = '')  and (not anon) then
              begin
                Alist.add('-1^<None recorded>');
                anon := true;
              end;
          //end;
      end;
end;

Procedure GetListforOP(Alist:TstringList; AGrid: TCaptionListBox);
var {get list of extant clinics from patient's problem list}
  i: integer;
  clin: string;
  anon: boolean;
begin
  anon := false;
  with AGrid do
    for i := 0 to pred(items.count) do
      {begin
        pt := cells[12,i];
        if pt <> PL_WARD then}
          begin
            clin := Piece( items[i], U, 11);
            if ((clin = '') or (clin = '0')) and (not anon) then
              begin
                AList.add('-1^<None recorded>'); {add a holder for "no clinic"}
                anon := true;
              end
            else if (clin<>'') and (Alist.indexof(clin)<0) then
              Alist.add(clin);
          end;
       //end;
end;

procedure LoadFilterList(Alist: TstringList; DestList: TstringList);
var
  i:integer;
begin
  for i := 0 to pred(Alist.count) do DestList.add(Piece(Alist[i],u,1));
end;

procedure ShowFilterStatus(s: string);
var
  lin:string;
begin
  if      s = PL_OP_VIEW then lin := 'View clinics'
  else if s = PL_IP_VIEW then lin := 'View services'
  else                        lin := 'View all problems';
  Application.ProcessMessages;
end;

function ByProvider: string;
begin
  result := '';
  if PLFilters.ProviderList.count > 0 then
    if PLFilters.ProviderList[0] <> '0' then result := 'by Provider';
end;

procedure SetViewFilters(Alist:TStringList);
begin
  if PLFilters.ProviderList.count = 0 then
    PLFilters.ProviderList.add('0'); {default to all provides if none selected}
  if PLUser.usCurrentView = PL_OP_VIEW then
    begin
      if PLFilters.ClinicList.count = 0 then
        begin
          //GetListforOP(Alist);
          LoadFilterList(Alist,PLFilters.ClinicList);
        end;
      //PostMessage(frmProblems.Handle, UM_PLFILTER,0,0);
    end
  else if PLUser.usCurrentView = PL_IP_VIEW then
    begin
      if PLFilters.ServiceList.count=0 then
        begin
          //GetListforIP(Alist);
          LoadFilterList(Alist,PLFilters.ServiceList);
        end;
      //PostMessage(frmProblems.Handle, UM_PLFILTER,0,0);
    end
  else {if no default view specified, assumed to be unfiltered}
    PlUser.usCurrentView := PL_UF_VIEW;
  ShowFilterStatus(PlUser.usCurrentView);
end;

procedure InitViewFilters(Alist: TstringList);
var
  i:integer;
begin
  if PLUser.usCurrentView = '' then PLUser.usCurrentView := PL_UF_VIEW;

  if (PLUser.usViewProv = '') or (Piece(PLUser.usViewProv, U, 1) = '0') then
    begin
      PLFilters.ProviderList.clear;
      PLFilters.Providerlist.add('0');
    end
  else {conserve user preferred provider}
    PLFilters.ProviderList.Add(Piece(PLUser.usViewProv, U, 1));

  if PLUser.usCurrentView = PL_UF_VIEW then
    begin {no filter on patient type, so do routine filter on provider and bail}
      SetViewFilters(Alist);
      //exit;
    end;

  if (PLUser.usCurrentView = PL_OP_VIEW) and (PLUser.usViewClin = '') then
    begin {no user preferred list of clinics, so get standard list and bail}
      SetViewFilters(Alist);
      //exit;
    end;

  if (PLUser.usCurrentView = PL_IP_VIEW) and (PLUser.usViewServ = '') then
    begin {no user preferred list of services, so get standard list  and bail}
      SetViewFilters(Alist);
      //exit;
    end;

  if (PLUser.usCurrentView = PL_OP_VIEW) and (PLUser.usClinList.Count > 0) then
    begin {conserve user preferred clinic list}
      for i := 0 to pred(PLUser.usClinList.Count) do
        PLFilters.ClinicList.add(PLUser.usClinList[i]);
    end;

  if PLUser.usCurrentView = PL_IP_VIEW then
    begin {conserve user preferred service list}
      for i := 0 to pred(PLUser.usServList.Count) do
        PLFilters.ServiceList.add(PLUser.usServList[i]);
    end;

//  ShowFilterStatus(PlUser.usCurrentView);
//  PostMessage(frmProblems.Handle, UM_PLFILTER,0,0);
end;

function ForChars(Num, FontWidth: Integer): Integer;
begin
  Result := Num * FontWidth;
end;

procedure GetFontInfo(AHandle: THandle; var FontWidth, FontHeight: Integer);
{ pass in a FONT HANDLE & return character width & height }
var
  DC: HDC;
  SaveFont: HFont;
  FontMetrics: TTextMetric;
  size: TSize ;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, AHandle);
  GetTextExtentPoint32(DC, UpperCaseLetters + LowerCaseLetters, 52, size);
  FontWidth := size.cx div 52;
  GetTextMetrics(DC, FontMetrics);
  FontHeight := FontMetrics.tmHeight;
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
end;

function ShortDateStrToDate(shortdate: string): string ;
{Converts date in format 'mmm dd,yy' or 'mmm dd,yyyy' to standard 'mm/dd/yy'}
var
  month,day,year: string ;
  i: integer ;
begin
  result := 'ERROR' ;
  if ((Pos(' ',shortdate) <> 4) or (Pos(',',shortdate) <> 7)) then exit ;  {no spaces or comma}
  for i := 1 to 12 do
    if String(Months[i]) = UpperCase(Copy(shortdate,1,3)) then month := IntToStr(i);
  if month = '' then exit ;    {invalid month name}
  day  := IntToStr(StrToInt(Copy(shortdate,5,2))) ;
  year := IntToStr(StrToInt(Copy(shortdate,8,99))) ;
  result := month+'/'+day+'/'+year ;
end ;

(*function NewComment: string ;
var
  frmProbCmt: TfrmProbCmt ;
begin
  frmProbCmt := TfrmProbCmt.Create(Application) ;
  try
    frmProbCmt.Execute;
    result := frmProbCmt.CmtResult ;
  finally
    frmProbCmt.Free ;
  end ;
end ;

function EditComment(OldValue: string): string ;
var
  frmProbCmt: TfrmProbCmt ;
begin
  frmProbCmt := TfrmProbCmt.Create(Application) ;
  try
    frmProbCmt.edComment.Text := Piece(OldValue, U, 2);
    frmProbCmt.Execute;
    result := frmProbCmt.CmtResult ;
  finally
    frmProbCmt.Free ;
  end ;
end ;*)

function FixQuotes(InString: string): string;
var
  i: integer;
  OutString: string;
begin
  OutString := '';
  for i := 1 to Length(InString) do
    if CharAt(InString, i) = '"' then
      OutString := OutString + '""'
    else
      OutString := OutString + CharAt(InString, i);
  Result := OutString;
end;

end.
