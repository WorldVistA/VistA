{ ******************************************************************************

   ___  __  ____  _  _      _    ____   __   ____  ____  ____
  / __)/  \(  _ \( \/ )    / )  (  _ \ / _\ / ___)(_  _)(  __)
 ( (__(  O )) __/ )  /    / /    ) __//    \\___ \  )(   ) _)
  \___)\__/(__)  (__/    (_/    (__)  \_/\_/(____/ (__) (____)


  Application Monitor Control unit

  Components:

  TCopyApplicationMonitor = This control is application wide and will
  contain the overall tracked clipboard.

  Functions:

  Register = Registers the control

  Conditional Defines:

  CPLOG  = If the CPLOG conditional define is set then when a log file of the
  Copy/Paste process is created and saved in the user's
  AppData\Local\[Application name] folder. A document is created per
  process.


  { ****************************************************************************** }

unit U_CPTAppMonitor;

interface

uses
  U_CptUtils, U_CPTCommon, System.Classes, System.SyncObjs, Vcl.Graphics,
  Vcl.ExtCtrls, U_CPTExtended, System.SysUtils,
  System.Math, Vcl.Dialogs, System.UITypes, System.IniFiles,
  Winapi.Windows, Vcl.Forms, Winapi.TlHelp32, IdHashSHA, Generics.Collections, vcl.StdCtrls;

Type
  /// <summary>This is the "overall" component. Each instance of <see cref="U_CPTPasteDetails|TCopyEditMonitor" /> and/or  <see cref="CopyMonitor|TCopyPasteDetails" /> will send into this.
  /// This control holds the collection of text that was copied so that each monitor can interact with it</summary>
  TCopyApplicationMonitor = class(TComponent)
  private
    /// <summary><para>Clipboard custom format for copy/paste</para><para><b>Type: </b><c>Word</c></para></summary>
    CF_CopyPaste: Word;
    /// <summary><para>Number of characters that will halt the highlight from the background</para><para><b>Type: </b><c>Integer</c></para></summary>
    // FBackGroundLimit: Integer;
    /// <summary><para>Number of characters to break up long lines at</para><para><b>Type: </b><c>Integer</c></para></summary>
    FBreakUpLimit: Integer;
    /// <summary><para>Holds all records of copied/pasted text</para>
    /// <para><b>Type: </b><c>Array of <see cref="U_CPTCommon|TCprsClipboard" /></c></para></summary>
    FCPRSClipBoard: CprsClipboardArry;
    /// <summary><para>Controls the critical section for the thread</para><para><b>Type: </b><c>TCriticalSection</c></para></summary>
    FCriticalSection: TCriticalSection;
    /// <summary><para>Controls if the user can see paste details</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FDisplayPaste: Boolean;

    fSuperUser: Boolean;
    FSaveCutOff: Double;
    FCompareCutOff: Integer;

    /// <summary><para>List of applications to exlude from the past tracking</para><para><b>Type: </b><c>TStringList</c></para></summary>
    fExcludeApps: TStringList;
    /// <summary><para>Color used to highlight the matched text</para><para><b>Type: </b><c>TColor</c></para></summary>
    FHighlightColor: TColor;
    /// <summary><para>External load buffer event</para><para><b>Type: </b><c><see cref="U_CPTCommon|TLoadEvent" /></c></para></summary>
    FLoadBuffer: TLoadBuffEvent;
    /// <summary><para>Flag that indicates if the buffer has been loaded</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FLoadedBuffer: Boolean;

    fBufferTimer: TTimer;
    FBufferPolled: Boolean;
    /// <summary><para>Flag that indicates if the buffer will be used to save and load prior session data</para><para><b>Type: </b><c>Boolean</c></para></summary>
    fBufferEnabled: Boolean;
    /// <summary><para>Flag that indicates if the buffer will store hash value representation of the copy text</para><para><b>Type: </b><c>Boolean</c></para></summary>
    fHashBuffer: Boolean;
    /// <summary><para>List that can be used to hold excluded information (ie note IENs)</para><para><b>Type: </b><c>TStringList</c></para></summary>
    fExcludedList: TStringList;

    fStartPollBuff: TPollBuff;
    fStopPollBuff: TPollBuff;
    fBufferTryLimit: Integer;
    fLCSToggle: Boolean;
    fLCSCharLimit: Integer;
    FLCSTextColor: TColor;
    FLCSTextStyle: TFontStyles;
    FLCSUseColor: Boolean;
    fPasteLimit: Integer;
    fpSHA: TIdHashSHA1;
    /// <summary><para>External load properties event</para><para><b>Type: </b><c><see cref="U_CPTCommon|TLoadProperties" /></c></para></summary>
    FOnLoadProperties: TLoadProperties;
    /// <summary><para>Flag indicates if properties have been loaded</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FLoadedProperties: Boolean;
    fEnabled: Boolean;

    FLogObject: TLogComponent;
    /// <summary><para>Flag to display highlight when match found</para><para><b>Type: </b><c>Boolean</c></para></summary>
    FMatchHighlight: Boolean;
    /// <summary><para>Style to use for the matched text font</para><para><b>Type: </b><c>TFontStyles</c></para></summary>
    FMatchStyle: TFontStyles;
    /// <summary><para>The monitoring application name</para><para><b>Type: </b><c>string</c></para></summary>
    FMonitoringApplication: string;
    /// <summary><para>The monitoring application's package</para><para><b>Type: </b><c>string</c></para></summary>
    FMonitoringPackage: string;
    /// <summary><para>Number of words used to trigger copy/paste functionality</para><para><b>Type: </b><c>Double</c></para></summary>
    FNumberOfWords: Double;
    /// <summary><para>Percent used to match pasted text</para><para><b>Type:</b> <c>Double</c></para></summary>
    FPercentToVerify: Double;
    /// <summary><para>External save buffer event</para><para><b>Type: </b><c><see cref="U_CPTCommon|TSaveEvent" /></c></para></summary>
    FSaveBuffer: TSaveEvent;
    /// <summary><para>Stop Watch for metric information</para><para><b>Type: </b><c><see cref="U_CPTUtils|TStopWatch" /></c></para></summary>
    fStopWatch: TStopWatch;

    /// <summary><para>The current users DUZ</para><para><b>Type: </b><c>Int64</c></para></summary>
    FUserDuz: Int64;
    /// <summary><para>checks if should be exlcuded</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="AppName">AppName<para><b>Type: </b><c>String</c></para></param>
    /// <returns><para><b>Type: </b><c>Boolean</c></para> - </returns>
    function FromExcludedApp(AppName: String): Boolean;

    procedure SetEnabled(aValue: Boolean);
    function GetEnabled: Boolean;
    procedure SetLoadedProperties(aValue: Boolean);
    function GetLoadedProperties: Boolean;

    function GetExcludedList(): TStringList;
    function GetOnLoadProperties: TLoadProperties;
    procedure SetOnLoadProperties(const Value: TLoadProperties);
    function GetMatchStyle: TFontStyles;
    procedure SetMatchStyle(const Value: TFontStyles);
    function GetMatchHighlight: Boolean;
    procedure SetMatchHighlight(const Value: Boolean);
    function GetLoadedBuffer: Boolean;
    procedure SetLoadedBuffer(const Value: Boolean);
    function GetHighlightColor: TColor;
    procedure SetHighlightColor(const Value: TColor);
    function GetDisplayPaste: Boolean;
    procedure SetDisplayPaste(const Value: Boolean);
    function GetBufferEnabled: Boolean;
    procedure SetBufferEnabled(const Value: Boolean);
    function GetBufferPolled: Boolean;
    procedure SetBufferPolled(const Value: Boolean);
    function GetBufferTimer: TTimer;
    procedure SetBufferTimer(const Value: TTimer);
    function GetStartPollBuff: TPollBuff;
    procedure SetStartPollBuff(const Value: TPollBuff);
    function GetBufferTryLimit: Integer;
    procedure SetBufferTryLimit(const Value: Integer);
    function GetStopPollBuff: TPollBuff;
    procedure SetStopPollBuff(const Value: TPollBuff);
    function GetLoadBuffer: TLoadBuffEvent;
    procedure SetLoadBuffer(const Value: TLoadBuffEvent);
    function GetCPRSClipBoard: CprsClipboardArry;
  public
    /// <summary><para>Holds list of currently running threads</para><para><b>Type: </b><c>Array of <see cref="U_CPTExtended|tCopyPasteThread" /></c></para></summary>
    FCopyPasteThread: TCopyPasteThreadArry;
    /// <summary><para>List of paste details (panels) to keep in size sync</para><para><b>Type: </b><c>Array of TPanel</c></para></summary>
    fSyncSizeList: TPanelArry;

    //Holds the edit monitors for CPRS
    fEditMonitorList: TObjectList<tComponent>;

    /// <summary>Number of characters that will halt the highlight from the background</summary>
    // Property BackGroundLimit: Integer read FBackGroundLimit
    // write FBackGroundLimit;
    /// <summary>Clear out all SaveForDocument parameters</summary>
    procedure ClearCopyPasteClipboard();
    /// <summary>Adds the text being copied to the <see cref="U_CPTCommon|TCprsClipboard" /> array and to the clipboard with details</summary>
    /// <param name="TextToCopy">Copied text<para><b>Type: </b><c>string</c></para></param>
    /// <param name="FromName">Copied text's package<para><b>Type: </b><c>string</c></para></param>
    /// <param name="ItemID">ID of document the text was copied from<para><b>Type: </b><c>Integer</c></para></param>
    procedure CopyToCopyPasteClipboard(TextToCopy, FromName: string;
      ItemID: Int64);
    Property CFCopyPaste: Word Read CF_CopyPaste;
    /// <summary>Constructor</summary>
    /// <param name="AOwner">Object that is calling this</param>
    constructor Create(AOwner: TComponent); override;
    /// <summary>CriticalSection</summary>
    property CriticalSection: TCriticalSection read FCriticalSection;
    /// <summary>Destructor</summary>
    destructor Destroy; override;
    /// <summary>Controls if the user can see paste details</summary>
    property DisplayPaste: Boolean read GetDisplayPaste write SetDisplayPaste;

    property SuperUser: Boolean read fSuperUser write fSuperUser;

    /// <summary>List of applications to exclude from tracking</summary>
    property ExcludeApps: TStringList read fExcludeApps write fExcludeApps;

    property ExcludedList: TStringList read GetExcludedList;

    /// <summary><para>Get the owner (if applicable) from the clipboard</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <returns><para><b>Type: </b><c>tClipInfo</c></para> - </returns>
    function GetClipSource(GetLocked: Boolean = false): tClipInfo;

    property CPRSClipBoard: CprsClipboardArry Read GetCPRSClipBoard;

    /// <summary> Used to calcuate percent </summary>
    /// <param name="String1"> Original string </param>
    /// <param name="String2"> Compare String </param>
    /// <param name="CutOff"> number of character changes to fall in the threshold </param>
    /// <returns> Percentage the same </returns>
    function LevenshteinDistance(String1, String2: String;
      CutOff: Integer): Double;
    procedure LoadTheBufferPolled(Sender: TObject);
    property LogObject: TLogComponent read FLogObject;
    procedure LogText(Action, MessageTxt: String); overload;
    procedure LogText(Action: String; MessageTxt: TPasteArray); overload;
    property NumberOfWords: Double Read FNumberOfWords write FNumberOfWords;
    /// <summary>Perform the lookup of the pasted text and mark as such</summary>
    /// <param name="TextToPaste">Text being pasted</param>
    /// <param name="PasteDetails">Details from the clipboard</param>
    /// <param name="ItemIEN">Destination's IEN </param>
    /// <param name="ClipInfo">Clipborad information </param>
    procedure PasteToCopyPasteClipboard(TextToPaste, PasteDetails: string;
      ItemIEN: Int64; ClipInfo: tClipInfo);
    /// <summary><para>Recalculates the percentage after the save</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="ReturnedList">Data that is returned from the save RPC<para><b>Type: </b><c>TStringList</c></para></param>
    /// <param name="SaveList">Data that will be transfered back to vista<para><b>Type: </b><c>TStringList</c></para></param>
    /// <param name="ExisitingPaste">List of paste that already existed on the document (used for monitoring edits of paste)<para><b>Type: </b><c>array of <see cref="U_CPTCommon|TPasteText" /></c></para></param>
    procedure RecalPercentage(ReturnedList: TStringList;
      var SaveList: TStringList; ExisitingPaste: TPasteArray);
    /// <summary>Saved the copied text for this note</summary>
    /// <param name="Sender">Object that is calling this<para><b>Type: </b><c>TComponent</c></para></param>
    /// <param name="SaveList">List to save<para><b>Type: </b><c>TStringList</c></para></param>
    procedure SaveCopyPasteClipboard(Sender: TComponent; SaveList: TStringList);
    Property StopWatch: TStopWatch read fStopWatch;
    Function StartStopWatch(): Boolean;
    Function StopStopWatch(): Boolean;
    procedure IncBufferTryLimit;
    /// <summary><para>Sync all the sizes for the marked panels</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="sender">sender<para><b>Type: </b><c>TObject</c></para></param>
    procedure SyncSizes(Sender: TObject);

    property BufferLoaded: Boolean read GetLoadedBuffer write SetLoadedBuffer;
    /// <summary>How many words appear in the text</summary>
    /// <param name="TextToCount">Occurences of</param>
    /// <returns>Total number of occurences</returns>
    function WordCount(TextToCount: string): Integer;
    Procedure EnableBuffer(Value: Boolean);
    Property PasteLimit: Integer read fPasteLimit;
    Property LoadedProperties: Boolean read GetLoadedProperties
      Write SetLoadedProperties;
    Property BufferTimer: TTimer read GetBufferTimer Write SetBufferTimer;
    Property BufferTryLimit: Integer read GetBufferTryLimit
      write SetBufferTryLimit;
    procedure AddEditMonitorToList(aEditMonitor: tComponent);
    procedure RemoveFromMonitorList(aEditMonitor: tComponent);
    function TrackedByCP(aEdit: TCustomEdit): boolean;
  published
    /// <summary><para>where to break the text at</para><para><b>Type: </b>intger</para></summary>
    property BreakUpLimit: Integer read FBreakUpLimit write FBreakUpLimit;
    /// <summary>Color used to highlight the matched text</summary>
    property HighlightColor: TColor read GetHighlightColor
      write SetHighlightColor;
    /// <summary>Call to load the buffer </summary>
    property LoadBuffer: TLoadBuffEvent read GetLoadBuffer write SetLoadBuffer;
    /// <summary>Load the copy buffer from VistA</summary>
    procedure LoadTheBuffer();

    Procedure StopTheBuffer();

    /// <summary>External load for the properties</summary>
    property LoadProperties: TLoadProperties read GetOnLoadProperties
      write SetOnLoadProperties;

    /// <summary>External Load Properties</summary>
    procedure LoadTheProperties();
    /// <summary>Flag to display highlight when match found</summary>
    property MatchHighlight: Boolean read GetMatchHighlight
      write SetMatchHighlight;
    /// <summary>Style to use for the matched text font</summary>
    property MatchStyle: TFontStyles read GetMatchStyle write SetMatchStyle;
    /// <summary>The application that we are monitoring</summary>
    property MonitoringApplication: string read FMonitoringApplication
      write FMonitoringApplication;
    /// <summary>The package that this application relates to</summary>
    property MonitoringPackage: string read FMonitoringPackage
      write FMonitoringPackage;
    /// <summary>How many words do we start to consider this copy/paste</summary>
    property NumberOfWordsToBegin: Double read FNumberOfWords
      write FNumberOfWords;
    /// <summary>Percent to we consider this copy/paste functionality</summary>
    property PercentToVerify: Double read FPercentToVerify
      write FPercentToVerify;
    /// <summary>Should the buffer call be polled?</summary>
    Property PolledBuffer: Boolean read GetBufferPolled write SetBufferPolled;
    /// <summary>Is the buffer enabled</summary>
    Property BufferEnabled: Boolean read GetBufferEnabled
      write SetBufferEnabled;
    /// <summary>Do we use a hashed buffer</summary>
    property HashBuffer: Boolean read fHashBuffer write fHashBuffer;
    /// <summary>Call to save the buffer </summary>
    property SaveBuffer: TSaveEvent read FSaveBuffer write FSaveBuffer;
    /// <summary>Save copy buffer to VistA</summary>
    procedure SaveTheBuffer();

    property SaveCutOff: Double read FSaveCutOff write FSaveCutOff;
    property CompareCutOff: Integer read FCompareCutOff write FCompareCutOff;

    Property StartPollBuff: TPollBuff read GetStartPollBuff
      write SetStartPollBuff;
    Property StopPollBuff: TPollBuff read GetStopPollBuff write SetStopPollBuff;

    property LCSToggle: Boolean read fLCSToggle write fLCSToggle;
    property LCSCharLimit: Integer read fLCSCharLimit write fLCSCharLimit;
    property LCSUseColor: Boolean read FLCSUseColor write FLCSUseColor;
    property LCSTextColor: TColor read FLCSTextColor write FLCSTextColor;
    property LCSTextStyle: TFontStyles read FLCSTextStyle write FLCSTextStyle;

    /// <summary>The current users DUZ</summary>
    property UserDuz: Int64 read FUserDuz write FUserDuz;
    Property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

const
  INVALID_APP_NAME = '** N/A **';

procedure Register;

implementation

uses
  U_CPTEditMonitor, U_CPTPasteDetails, UResponsiveGUI;

procedure Register;
begin
  RegisterComponents('Copy/Paste', [TCopyApplicationMonitor]);
end;

{$REGION 'CopyApplicationMonitor'}

procedure TCopyApplicationMonitor.AddEditMonitorToList
  (aEditMonitor: TComponent);
begin
  if not(csDesigning in ComponentState) then
  begin
    if aEditMonitor is TCopyEditMonitor then
    begin
      if fEditMonitorList.IndexOf(aEditMonitor) = -1 then
        fEditMonitorList.Add(aEditMonitor);
    end;
  end;
end;

procedure TCopyApplicationMonitor.RemoveFromMonitorList(aEditMonitor: tComponent);
begin
  if not(csDesigning in ComponentState) then
    fEditMonitorList.Remove(aEditMonitor);
end;

function TCopyApplicationMonitor.TrackedByCP(aEdit: TCustomEdit): Boolean;
var
  aComponent: TComponent;
begin
  result := false;
  if not(csDesigning in ComponentState) then
  begin
    for aComponent in fEditMonitorList do
    begin
      if Assigned(aComponent) and (aComponent is TCopyEditMonitor) then
      begin
        if TCopyEditMonitor(aComponent).IsTracked(aEdit) then
        begin
          result := true;
          break;
        end;
      end;
    end;
  end;
end;



procedure TCopyApplicationMonitor.ClearCopyPasteClipboard;
var
  I: Integer;
begin
  FCriticalSection.Enter;
  try
    if not Enabled then
      Exit;
    StartStopWatch;
    try
      for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
      begin
        FCPRSClipBoard[I].SaveForDocument := false;
        FCPRSClipBoard[I].DateTimeOfPaste := '';
        FCPRSClipBoard[I].PasteToIEN := -1;
        FCPRSClipBoard[I].SaveItemID := -1;
      end;
    finally
      if StopStopWatch then
        LogText('METRIC', 'Clear: ' + fStopWatch.Elapsed);
    end;
    LogText('SAVE', 'Clearing all pasted data that was marked for save');

  finally
    FCriticalSection.Leave;
  end;
end;

Procedure TCopyApplicationMonitor.PasteToCopyPasteClipboard(TextToPaste,
  PasteDetails: string; ItemIEN: Int64; ClipInfo: tClipInfo);
var
  TextFound, AddItem: Boolean;
  I, PosToUSe, CutOff: Integer;
  PertoCheck, LastPertToCheck: Double;
  CompareText: TStringList;
  Len1, Len2: Integer;
  aHashString: String;
  aMatchFnd: Boolean;
begin
  if (csDesigning in ComponentState) then
    exit;
  FCriticalSection.Enter;
  try
    if not Enabled then
      Exit;
    // load the properties
    if not LoadedProperties then
      LoadTheProperties;
    // load the buffer
    if not BufferLoaded then
      LoadTheBuffer;

    aHashString := fpSHA.HashStringAsHex(TextToPaste);
    TextFound := false;
    CompareText := TStringList.Create;
    try
      CompareText.Text := TextToPaste; // Apples to Apples
      aMatchFnd := false;
      // Direct macthes
      StartStopWatch;
      try
        for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
        begin
          if trim(FCPRSClipBoard[I].HashValue) <> '' then
            aMatchFnd := FCPRSClipBoard[I].HashValue = aHashString
          else if not Assigned(FCPRSClipBoard[I].CopiedText) then
            aMatchFnd := false
          else if Assigned(FCPRSClipBoard[I].CopiedText) then
            aMatchFnd := AnsiSameText(trim(FCPRSClipBoard[I].CopiedText.Text),
              trim(CompareText.Text));

          If aMatchFnd then
          begin
            if (FCPRSClipBoard[I].CopiedFromIEN <> ItemIEN) then
            begin
              FCPRSClipBoard[I].SaveForDocument :=
                (FCPRSClipBoard[I].CopiedFromIEN <> ItemIEN);
              FCPRSClipBoard[I].DateTimeOfPaste :=
                FloatToStr(DateTimeToFMDateTime(Now));
              FCPRSClipBoard[I].CopiedFromPackage := FCPRSClipBoard[I]
                .CopiedFromPackage; // ????????
              FCPRSClipBoard[I].PercentMatch := 100.00;
              FCPRSClipBoard[I].PasteToIEN := ItemIEN;
              FCPRSClipBoard[I].PasteDBID := -1;

              if not Assigned(FCPRSClipBoard[I].CopiedText) then
              begin
                FCPRSClipBoard[I].CopiedText := TStringList.Create;
                FCPRSClipBoard[I].CopiedText.Text := trim(CompareText.Text);
              end;

              // Log info
              LogText('PASTE', 'Direct Match Found');
              LogText('PASTE', 'Pasted Text IEN(' + IntToStr(ItemIEN) + ')');
              LogText('TEXT', 'Pasted Text:' + #13#10 + CompareText.Text);
              LogText('PASTE', 'Matched to Text IEN(' +
                IntToStr(FCPRSClipBoard[I].CopiedFromIEN) + '):');
              if Assigned(FCPRSClipBoard[I].CopiedText) then
                LogText('TEXT', 'Matched to Text: ' + #13#10 +
                  trim(FCPRSClipBoard[I].CopiedText.Text));

            end;
            TextFound := true;
            Break;
          end;
        end;
      finally
        If StopStopWatch then
          LogText('METRIC', 'Direct Match: ' + fStopWatch.Elapsed);
      end;

      // % check or exceed limit
      if not TextFound then
      begin
        // check for text limit
        if Length(CompareText.Text) >= PasteLimit then
        begin
          // never exclude if originated from a tracking app
          if Length(PasteDetails) > 0 then
            AddItem := true
          else
          begin
            // Check if excluded
            AddItem := (not FromExcludedApp(ClipInfo.AppName));
            if not AddItem then
              LogText('PASTE', 'Excluded Application');
          end;

          if AddItem then
          begin
            // Look for the details first
            SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);

            with FCPRSClipBoard[High(FCPRSClipBoard)] do
            begin
              // From tracking app
              if Length(PasteDetails) > 0 then
              begin
                CopiedFromIEN := StrToIntDef(Piece(PasteDetails, '^', 1), -1);
                CopiedFromPackage := Piece(PasteDetails, '^', 2);
                ApplicationPackage := Piece(PasteDetails, '^', 3);
                ApplicationName := Piece(PasteDetails, '^', 4);
                PercentMatch := 100.0;
                HashValue := aHashString;

                LogText('PASTE', 'Paste from cross session - Over Limit ' +
                  PasteDetails);
                LogText('PASTE', 'Added to internal clipboard IEN(-1)');
              end
              else
              begin
                // Exceeds the limit set
                CopiedFromIEN := -1;
                CopiedFromPackage := 'Paste exceeds maximum compare limit.';
                if trim(ClipInfo.AppName) <> '' then
                  CopiedFromPackage := CopiedFromPackage + ' From: ' +
                    ClipInfo.AppName + ' - ' + ClipInfo.AppTitle;
                ApplicationPackage := MonitoringPackage;
                ApplicationName := MonitoringApplication;
                PercentMatch := 100.0;
                HashValue := aHashString;

                LogText('PASTE',
                  'Pasted from outside the tracking - Over Limit (' +
                  IntToStr(Length(CompareText.Text)) + ')');
                LogText('PASTE]', 'Added to internal clipboard IEN(-1)');
              end;
              PasteToIEN := ItemIEN;
              PasteDBID := -1;
              DateTimeOfCopy := FloatToStr(DateTimeToFMDateTime(Now));
              SaveForDocument := true;
              DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
              SaveToTheBuffer := true;
              CopiedText := TStringList.Create;

              CopiedText.Text := CompareText.Text;
              TextFound := true;
            end;
          end;
        end
        else
        begin
          StartStopWatch;
          try
            // Percentage match
            LastPertToCheck := 0;
            PosToUSe := -1;

            for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
            begin
              if not Assigned(FCPRSClipBoard[I].CopiedText) then
                continue;

              try
                Len1 := Length(trim(FCPRSClipBoard[I].CopiedText.Text));
                Len2 := Length(CompareText.Text);
                CutOff := ceil(min(Len1, Len2) * (FPercentToVerify * 0.01));
                PertoCheck := LevenshteinDistance
                  (trim(FCPRSClipBoard[I].CopiedText.Text),
                  CompareText.Text, CutOff);
              except
                PertoCheck := 0;
              end;
              if PertoCheck > LastPertToCheck then
              begin
                if PertoCheck > FPercentToVerify then
                begin
                  PosToUSe := I;
                  LastPertToCheck := PertoCheck;
                end;
              end;

            end;
            if PosToUSe <> -1 then
            begin
              If (FCPRSClipBoard[PosToUSe].CopiedFromIEN <> ItemIEN) then
              begin

                LogText('PASTE', 'Partial Match: %' +
                  FloatToStr(round(LastPertToCheck)));
                LogText('PASTE', 'Pasted Text IEN(' + IntToStr(ItemIEN) + ')');
                LogText('TEXT', 'Pasted Text:' + #13#10 + CompareText.Text);
                LogText('PASTE', 'Matched to Text IEN(' +
                  IntToStr(FCPRSClipBoard[PosToUSe].CopiedFromIEN) + ')');
                If Assigned(FCPRSClipBoard[PosToUSe].CopiedText) then
                  LogText('TEXT', 'Matched to Text: ' + #13#10 +
                    trim(FCPRSClipBoard[PosToUSe].CopiedText.Text));
                LogText('PASTE', 'Added to internal clipboard IEN(-1)');

                // add new
                SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
                with FCPRSClipBoard[High(FCPRSClipBoard)] do
                begin
                  CopiedFromIEN := -1;
                  CopiedFromPackage := 'Outside of current ' +
                    MonitoringApplication + ' tracking';
                  ApplicationPackage := MonitoringPackage;
                  ApplicationName := MonitoringApplication;
                  PercentMatch := round(LastPertToCheck);

                  PercentData :=
                    IntToStr(FCPRSClipBoard[PosToUSe].CopiedFromIEN) + ';' +
                    FCPRSClipBoard[PosToUSe].CopiedFromPackage;
                  PasteToIEN := ItemIEN;
                  PasteDBID := -1;
                  DateTimeOfCopy := FloatToStr(DateTimeToFMDateTime(Now));
                  SaveForDocument := true;
                  DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
                  SaveToTheBuffer := true;
                  CopiedText := TStringList.Create;
                  CopiedText.Text := CompareText.Text;
                  If Assigned(FCPRSClipBoard[PosToUSe].CopiedText) then
                  begin
                    OriginalText := TStringList.Create;
                    OriginalText.Text := FCPRSClipBoard[PosToUSe]
                      .CopiedText.Text;
                  end;
                  HashValue := aHashString;
                end;

              end;
              TextFound := true;
            end;
          finally
            If StopStopWatch then
              LogText('METRIC', 'Percentage Match: ' + fStopWatch.Elapsed);
          end;

        end;

        // add outside paste in here
        if (not TextFound) and (WordCount(CompareText.Text) >= FNumberOfWords)
        then
        begin
          StartStopWatch;
          try
            if Length(PasteDetails) > 0 then
              AddItem := true
            else
            begin
              // Check if excluded
              AddItem := (not FromExcludedApp(ClipInfo.AppName));
              if not AddItem then
                LogText('PASTE', 'Excluded Application');
            end;

            if AddItem then
            begin
              // Look for the details first
              SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
              with FCPRSClipBoard[High(FCPRSClipBoard)] do
              begin
                if Length(PasteDetails) > 0 then
                begin
                  CopiedFromIEN := StrToIntDef(Piece(PasteDetails, '^', 1), -1);
                  CopiedFromPackage := Piece(PasteDetails, '^', 2);
                  ApplicationPackage := Piece(PasteDetails, '^', 3);
                  ApplicationName := Piece(PasteDetails, '^', 4);
                  PercentMatch := 100.0;
                  HashValue := aHashString;

                  LogText('PASTE', 'Paste from cross session ' + PasteDetails);
                  LogText('PASTE', 'Added to internal clipboard IEN(-1)');

                end
                else
                begin
                  CopiedFromIEN := -1;
                  CopiedFromPackage := 'Outside of current ' +
                    MonitoringApplication + ' tracking.';
                  if trim(ClipInfo.AppName) <> '' then
                    CopiedFromPackage := CopiedFromPackage + 'From: ' +
                      ClipInfo.AppName + ' - ' + ClipInfo.AppTitle;
                  ApplicationPackage := MonitoringPackage;
                  ApplicationName := MonitoringApplication;
                  PercentMatch := 100.0;
                  HashValue := aHashString;

                  LogText('PASTE', 'Pasted from outside the tracking');
                  LogText('PASTE]', 'Added to internal clipboard IEN(-1)');

                end;
                PasteToIEN := ItemIEN;
                PasteDBID := -1;
                DateTimeOfCopy := FloatToStr(DateTimeToFMDateTime(Now));
                SaveForDocument := true;
                DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
                SaveToTheBuffer := true;
                CopiedText := TStringList.Create;
                CopiedText.Text := CompareText.Text;
              end;
            end;
          finally
            If StopStopWatch then
              LogText('METRIC', 'Outside Paste: ' + fStopWatch.Elapsed);
          end;
        end;
      end;
    finally
      CompareText.Free;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.SaveCopyPasteClipboard(Sender: TComponent;
  SaveList: TStringList);
var
  I, x, z, SaveCnt, FndTotalCnt, FndLineNum: Integer;
  IEN2Use: Int64;
  Package2Use, tmp: String;
  FndList: TStringList;
  FndListHash: THashedStringList;
  FndPercent: Double;
  FndTimeTook: Int64;
begin
  if not Enabled then
    Exit;

  FCriticalSection.Enter;
  try
    SaveList.Text := '';
    if (Sender is TCopyEditMonitor) then
    begin
      StartStopWatch;
      try
        FndList := TStringList.Create;
        FndListHash := THashedStringList.Create;
        try
          with (Sender as TCopyEditMonitor) do
          begin
            SaveCnt := 0;
            for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
            begin
              if FCPRSClipBoard[I].SaveForDocument = true then
              begin
                Inc(SaveCnt);
                FCPRSClipBoard[I].SaveItemID := SaveCnt;
                if FCPRSClipBoard[I].PercentMatch <> 100 then
                begin
                  IEN2Use := StrToIntDef(Piece(FCPRSClipBoard[I].PercentData,
                    ';', 1), -1);
                  Package2Use := Piece(FCPRSClipBoard[I].PercentData, ';', 2);
                end
                else
                begin
                  IEN2Use := FCPRSClipBoard[I].CopiedFromIEN;
                  Package2Use := FCPRSClipBoard[I].CopiedFromPackage;
                end;

                SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) + '^'
                  + FCPRSClipBoard[I].DateTimeOfPaste + '^' + IntToStr(ItemIEN)
                  + ';' + RelatedPackage + '^' + IntToStr(IEN2Use) + ';' +
                  Package2Use + '^' + FloatToStr(FCPRSClipBoard[I].PercentMatch)
                  + '^' + FCPRSClipBoard[I].ApplicationName + '^-1^');

                // Line Count (w/out OUR line breaks for size - code below)
                If Assigned(FCPRSClipBoard[I].CopiedText) then
                  BreakUpLongLines(SaveList, IntToStr(SaveCnt),
                    FCPRSClipBoard[I].CopiedText, FBreakUpLimit);

                // Send in  the original text if needed
                If Assigned(FCPRSClipBoard[I].OriginalText) then
                begin
                  BreakUpLongLines(SaveList, IntToStr(SaveCnt) + ',COPY',
                    FCPRSClipBoard[I].OriginalText, FBreakUpLimit);
                end;

                if TCopyEditMonitor(Sender).Owner is TCopyPasteDetails then
                begin
                  TCopyPasteDetails(TCopyEditMonitor(Sender).Owner)
                    .CPCOMPARE(FCPRSClipBoard[I], FndList, FndPercent,
                    FndTimeTook);
                  { DONE -oChris Bell : if 100 BUT MORE THAN 1 REC IN THE LIST THEN FORCE THE SAVE }
                  if ((FndPercent <> 100) and (FndPercent <> -3)) or
                    ((FndPercent = 100) and (StrToIntDef(FndList.Values['(0)'],
                    -1) > 1)) then
                  begin
                    FndListHash.Assign(FndList);
                    // Get the total number of finds
                    FndTotalCnt := StrToIntDef(FndListHash.Values['(0)'], -1);
                    SaveList.Add(IntToStr(SaveCnt) + ',Paste,-1=' +
                      IntToStr(FndTotalCnt) + '^' + IntToStr(FndTimeTook));
                    tmp := SaveList.Values[IntToStr(SaveCnt) + ',0'];
                    SetPiece(tmp, '^', 5, formatfloat('##.##', FndPercent));
                    // If 100% then we need to force the find text
                    if FndPercent = 100 then
                      SetPiece(tmp, '^', 8, '1');

                    SaveList.Values[IntToStr(SaveCnt) + ',0'] := tmp;
                    // Loop through each return and format for the save
                    for x := 1 to FndTotalCnt do
                    begin
                      FndLineNum :=
                        StrToIntDef
                        (FndListHash.Values['(' + IntToStr(x) + ',0)'], -1);
                      // Reuse
                      FndList.Clear;
                      for z := 1 to FndLineNum do
                        FndList.Add(FndListHash.Values['(' + IntToStr(x) + ',' +
                          IntToStr(z) + ')']);

                      BreakUpLongLines(SaveList, IntToStr(SaveCnt) + ',Paste,' +
                        IntToStr(x), FndList, FBreakUpLimit);
                    end;
                  end
                  else if FndPercent = 100 then
                  begin
                    tmp := SaveList.Values[IntToStr(SaveCnt) + ',0'];
                    SetPiece(tmp, '^', 5, '100');
                    SaveList.Values[IntToStr(SaveCnt) + ',0'] := tmp;
                  end
                  else if FndPercent = -3 then
                  begin
                    // Took to long so we need to indicate as such
                    tmp := SaveList.Values[IntToStr(SaveCnt) + ',0'];
                    SetPiece(tmp, '^', 8, '2');
                    SaveList.Values[IntToStr(SaveCnt) + ',0'] := tmp;
                  end;

                end;

              end;
            end;

            SaveList.Add('TotalToSave=' + IntToStr(SaveCnt));
            LogText('SAVE', 'Saved ' + IntToStr(SaveCnt) + ' Items');

          end;
        finally
          FndListHash.Free;
          FndList.Free;
        end;
      finally
        If StopStopWatch then
          LogText('METRIC', 'Build Save: ' + fStopWatch.Elapsed);
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.CopyToCopyPasteClipboard(TextToCopy,
  FromName: string; ItemID: Int64);
const
  Max_Retry = 3;
  Hlp_Msg = 'System Error: %s' + #13#10 +
    'There was a problem accessing the clipboard please try again.' + #13#10 +
    #13#10 + 'The following application has a lock on the clipboard:' + #13#10 +
    'App Title: %s' + #13#10 + 'App Name: %s' + #13#10 + #13#10 +
    'If this problem persists please close %s and then try again. If you are still experiencing issues please contact your local CPRS help desk.';
var
  I, RetryCnt: Integer;
  Found, TryCpy: Boolean;
  ClpLckInfo: tClipInfo;
  TmpStr, aHashString: string;

  procedure AddClipFormat(const Details: String);
  var
    DataPtr: Pointer;
    Data: THandle;
    aSize: Integer;
  begin
    {$WARN SYMBOL_PLATFORM OFF}
    Win32Check(OpenClipBoard(0));
    try
    aSize := ByteLength(Details);
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, aSize + 1);
    try
      DataPtr := GlobalLock(Data);
      try
        Move((PAnsiChar(AnsiString(Details)))^, DataPtr^, Length(Details) + 1);
        Win32Check(SetClipboardData(CF_CopyPaste, Data) <> 0);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
    finally
      Win32Check(CloseClipBoard);
    end;
    {$WARN SYMBOL_PLATFORM ON}
  end;


begin
  if (csDesigning in ComponentState) then
    exit;
  if not Enabled then
    Exit;
  Found := false;
  if not LoadedProperties then
    LoadTheProperties;
  if not BufferLoaded then
    LoadTheBuffer;
  FCriticalSection.Enter;
  try
    LogText('COPY', 'Copying data from IEN(' + IntToStr(ItemID) + ')');
    StartStopWatch;
    try
      if WordCount(TextToCopy) >= FNumberOfWords then
      begin
        aHashString := fpSHA.HashStringAsHex(StringReplace(TextToCopy, #13,
          #13#10, [rfReplaceAll]));
        // check if this already exist
        for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
        begin
          if FCPRSClipBoard[I].CopiedFromPackage = UpperCase(FromName) then
          begin
            if FCPRSClipBoard[I].CopiedFromIEN = ItemID then
            begin
              if trim(FCPRSClipBoard[I].HashValue) <> '' then
                Found := FCPRSClipBoard[I].HashValue = aHashString
              else if Assigned(FCPRSClipBoard[I].CopiedText) then
                Found := AnsiSameText(trim(FCPRSClipBoard[I].CopiedText.Text),
                  trim(TextToCopy));

              if Found then
              begin
                LogText('COPY', 'Copied data already being monitored');
                Break;
              end;
            end;
          end;
        end;

        // Copied text doesn't exist so add it in
        if (not Found) and (WordCount(TextToCopy) >= FNumberOfWords) then
        begin

          LogText('COPY', 'Adding copied data to session tracking');
          SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN := ItemID;
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
            UpperCase(FromName);
          FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
            MonitoringPackage;
          FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
            MonitoringApplication;
          FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
            FloatToStr(DateTimeToFMDateTime(Now));
          FCPRSClipBoard[High(FCPRSClipBoard)].PasteDBID := -1;
          FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := false;
          FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := true;
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText.Text := TextToCopy;
          FCPRSClipBoard[High(FCPRSClipBoard)].HashValue := aHashString;
        end;
      end;

      TryCpy := true;
      RetryCnt := 1;

      while TryCpy do
      begin
        while (RetryCnt <= Max_Retry) and TryCpy do
        begin
          try
            AddClipFormat(IntToStr(ItemID) + '^' + UpperCase(FromName) + '^' +
              MonitoringPackage + '^' + MonitoringApplication);

            TryCpy := false;
          Except
            Inc(RetryCnt);
            Sleep(100);
            If RetryCnt > Max_Retry then
              ClpLckInfo := GetClipSource(true)
          End;
        end;

        // If our retry count is greater than the max we were unable to grab the paste
        if RetryCnt > Max_Retry then
        begin
          TmpStr := Format(Hlp_Msg, [SysErrorMessage(GetLastError),
            ClpLckInfo.AppTitle, ClpLckInfo.AppName, ClpLckInfo.AppName]);
          if TaskMessageDlg('Clipboard Locked', TmpStr, mtError,
            [mbRetry, mbCancel], -1) = mrRetry then
          begin
            // reset the loop variables
            RetryCnt := 1;
            TryCpy := true;
          end
          else
            Exit;
        end;

      end;

    finally
      If StopStopWatch then
        LogText('METRIC', 'Add To Clipboard: ' + fStopWatch.Elapsed);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

constructor TCopyApplicationMonitor.Create(AOwner: TComponent);
Var
  I: Integer;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    FCriticalSection := TCriticalSection.Create;
  BufferLoaded := false;
  LoadedProperties := false;
  HighlightColor := clYellow;
  MatchStyle := [];
  MatchHighlight := true;
  DisplayPaste := true;
  Enabled := true;
  fLCSToggle := true;
  fLCSCharLimit := 5000;
  FCompareCutOff := 15;
  FSaveCutOff := 2;
  FLogObject := nil;
  fPasteLimit := 20000;

  if not(csDesigning in ComponentState) then
  begin
    CF_CopyPaste := RegisterClipboardFormat('CF_CopyPaste');

    for I := 1 to ParamCount do
    begin
      if UpperCase(ParamStr(I)) = 'CPLOG' then
      begin
        FLogObject := TLogComponent.Create(Self);
        FLogObject.LogToFile := LOG_SUM;
        Break;
      end
      else if UpperCase(ParamStr(I)) = 'CPLOGDEBUG' then
      begin
        FLogObject := TLogComponent.Create(Self);
        FLogObject.LogToFile := LOG_DETAIL;
        Break;
      end;
    end;
    if Assigned(FLogObject) then
      fStopWatch := TStopWatch.Create(Self, true);
    fEditMonitorList := TObjectList<TComponent>.Create(false);
    fExcludeApps := TStringList.Create;
    fExcludeApps.CaseSensitive := false;
    fpSHA := TIdHashSHA1.Create;
      SetLength(fSyncSizeList, 0);
  LogText('START', StringOfChar('*', 20) + FormatDateTime('mm/dd/yyyy hh:mm:ss',
    Now) + StringOfChar('*', 20));
  LogText('INIT', 'Monitor object created');
  end;

end;

destructor TCopyApplicationMonitor.Destroy;
var
  I: Integer;
begin
  if not (csDesigning in ComponentState) then
  begin
  FCriticalSection.Enter;
  try
    // Clear copy arrays
    for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
    begin
      if Assigned(FCPRSClipBoard[I].CopiedText) then
        FCPRSClipBoard[I].CopiedText.Free;
      If Assigned(FCPRSClipBoard[I].OriginalText) then
        FCPRSClipBoard[I].OriginalText.Free;
    end;
    SetLength(FCPRSClipBoard, 0);
    SetLength(fSyncSizeList, 0);

    if Assigned(ExcludeApps) then
      ExcludeApps.Free;
    if Assigned(ExcludedList) then
      ExcludedList.Free;
    if Assigned(fpSHA) then
      fpSHA.Free;

    for I := Low(FCopyPasteThread) to High(FCopyPasteThread) do
      FCopyPasteThread[I].Terminate;
    SetLength(FCopyPasteThread, 0);
    fEditMonitorList.Free;
    if Assigned(fStopWatch) then
      fStopWatch.Free;
    LogText('INIT', 'Monitor object destroyed');
    LogText('STOP', StringOfChar('*', 20) +
      FormatDateTime('mm/dd/yyyy hh:mm:ss', Now) + StringOfChar('*', 20));
  finally
    FCriticalSection.Leave;
  end;
  if Assigned(FCriticalSection) then
    FCriticalSection.Free;
  end;

  inherited;
end;

procedure TCopyApplicationMonitor.LoadTheBufferPolled(Sender: TObject);
const
  Wait_Timeout = 60; // Loop time each loop 1 second
  Timer_Delay = 5000; // MS
var
  BufferList: THashedStringList;
  I, x: Integer;
  NumLines, BuffLoopStart, BuffLoopStop { , StrtSub, StpSub } : Integer;
  ProcessLoad, LoadDone, ErrOccurred: Boolean;
  tmpString: String;
begin
  FCriticalSection.Enter;
  try
    ErrOccurred := false;
    if not Enabled or BufferLoaded then
      Exit;

    // Do we need to start the polling
    if not Assigned(BufferTimer) then
    begin
      if not Assigned(StartPollBuff) then
      begin
        // need to be able to start the buffer
        BufferLoaded := true;
        Exit;
      end
      else
      begin
        LogText('BUFF', 'RPC START POLL');
        StartStopWatch;
        try
          StartPollBuff(Self, ErrOccurred);
        finally
          If StopStopWatch then
            LogText('METRIC', 'Start Buffer RPC: ' + fStopWatch.Elapsed);
        end;
        if ErrOccurred then
        begin
          BufferLoaded := true;
          Exit;
        end;
      end;

      BufferTimer := TTimer.Create(Self);
      BufferTimer.Interval := Timer_Delay;
      BufferTimer.OnTimer := LoadTheBufferPolled;
      EnableBuffer(true);
      BufferTryLimit := 1;

      Exit; // Dont run the check right away, let the timmer handle this
    end;

    // Timmer has been started so lets check
    if (Sender is TTimer) then
    begin
      if not Assigned(LoadBuffer) then
      begin
        // need to be able to check the buffer
        BufferLoaded := true;
        Exit;
      end
      else
      begin
        BufferList := THashedStringList.Create();
        try
          ProcessLoad := true;
          LoadDone := false;
          EnableBuffer(false);
          LogText('BUFF', 'RPC BUFFER CALL');

          StartStopWatch;
          try
            LoadBuffer(Self, BufferList, ProcessLoad);
          finally
            If StopStopWatch then
              LogText('METRIC', 'Buffer Load RPC: ' + fStopWatch.Elapsed);
          end;

          if ProcessLoad then
          begin
            StartStopWatch;
            try

              if BufferList.Count > 0 then
              begin
                if BufferList.Strings[0] <> '-1' then
                begin
                  // first line is always the ~DONE
                  LoadDone := BufferList.Values['~Done'] = '1';
                  // If more than 1 line (the done line) then try to start processing the copies
                  if BufferList.Count > 1 then
                  begin
                    BuffLoopStart :=
                      StrToIntDef(Piece(Piece(BufferList.Strings[1], ',', 1),
                      '(', 2), 0);
                    BuffLoopStop :=
                      StrToIntDef
                      (Piece(Piece(BufferList.Strings[BufferList.Count - 1],
                      ',', 1), '(', 2), -1);

                    if BuffLoopStop > 0 then
                      SetLength(FCPRSClipBoard, BuffLoopStop);

                    if BuffLoopStart <> 0 then
                      BufferTryLimit := 1;

                    for I := BuffLoopStart to BuffLoopStop do
                    begin

                      with FCPRSClipBoard[I - 1] do
                      begin
                        SaveForDocument := false;
                        SaveToTheBuffer := false;
                        tmpString := BufferList.Values
                          ['(' + IntToStr(I) + ',0)'];
                        DateTimeOfCopy := Piece(tmpString, '^', 1);
                        ApplicationName := Piece(tmpString, '^', 2);
                        // ApplicationPackage := Piece(tmpString, '^', 3);
                        CopiedFromIEN :=
                          StrToIntDef(Piece(Piece(tmpString, '^', 3),
                          ';', 1), -1);
                        CopiedFromPackage :=
                          Piece(Piece(tmpString, '^', 3), ';', 2);

                        if fHashBuffer then
                          HashValue := Piece(tmpString, '^', 4)
                        else
                        begin
                          NumLines := StrToIntDef(Piece(tmpString, '^', 5), -1);
                          if NumLines > 0 then
                          begin
                            CopiedText := TStringList.Create;
                            CopiedText.BeginUpdate;
                            for x := 1 to NumLines do
                              CopiedText.Add
                                (BufferList.Values['(' + IntToStr(I) + ',' +
                                IntToStr(x) + ')']);
                            CopiedText.EndUpdate;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            finally
              If StopStopWatch then
                LogText('METRIC', 'Buffer build: ' + fStopWatch.Elapsed);
            end;

          end;

        finally
          BufferList.Free;
        end;

        IncBufferTryLimit;

        if BufferTryLimit = 3 then
          StopTheBuffer;

        // Stop the timer
        if LoadDone then
        begin
          BufferLoaded := true;
          EnableBuffer(false);
          LogText('BUFF', 'Buffer loaded with ' +
            IntToStr(Length(FCPRSClipBoard)) + ' Items');
        end
        else
          EnableBuffer(true);

      end;
    end
    else
    begin
      // Not from the Timer so we need to wait until the call is done
      I := 0;
      while BufferTimer.Enabled or (I >= Wait_Timeout) do
      begin
        // check to see if the buffer has finished yet
        TResponsiveGUI.Sleep(100);
        Inc(I);
      end;
    end;

  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.StopTheBuffer;
var
  ErrOccurred: Boolean;
begin
  FCriticalSection.Enter;
  try
    ErrOccurred := false;
    if Assigned(StopPollBuff) then
    begin
      LogText('BUFF', 'RPC STOP POLL');
      StartStopWatch;
      try
        fStopPollBuff(Self, ErrOccurred);
      finally
        If StopStopWatch then
          LogText('METRIC', 'Stop Buffer RPC: ' + fStopWatch.Elapsed);
      end;
    end;

    BufferLoaded := true;
    EnableBuffer(false);
  finally
    FCriticalSection.Leave;
  end;

end;

procedure TCopyApplicationMonitor.LoadTheBuffer();
var
  BufferList: TStringList;
  I, x: Integer;
  NumLines, BuffParent: Integer;
  ProcessLoad: Boolean;
begin
  if not Enabled then
    Exit;

  if not BufferEnabled then
    Exit;

  if PolledBuffer then
  begin
    LoadTheBufferPolled(Self);
    Exit;
  end;

  // Non polled logic
  BufferList := TStringList.Create();
  try
    ProcessLoad := true;
    BuffParent := 0;
    if Assigned(LoadBuffer) then
    begin
      LogText('BUFF', 'RPC CALL');

      StartStopWatch;
      try
        LoadBuffer(Self, BufferList, ProcessLoad);
      finally
        If StopStopWatch then
          LogText('METRIC', 'Buffer Load RPC: ' + fStopWatch.Elapsed);
      end;
    end;

    if ProcessLoad then
    begin
      StartStopWatch;
      try
        LogText('BUFF', 'Loading the buffer.' + BufferList.Values['(0,0)'] +
          ' Items.');

        if BufferList.Count > 0 then
          BuffParent := StrToIntDef(BufferList.Values['(0,0)'], -1);

        FCriticalSection.Enter;
        try
          for I := 1 to BuffParent do
          begin // first line is the total number

            LogText('BUFF', 'Buffer item (' + IntToStr(I) + '): ' +
              BufferList.Values['(' + IntToStr(I) + ',0)']);

            SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);

            with FCPRSClipBoard[High(FCPRSClipBoard)] do
            begin
              SaveForDocument := false;
              SaveToTheBuffer := false;
              DateTimeOfCopy :=
                Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 1);
              ApplicationName :=
                Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 2);
              // ApplicationPackage := Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 3);
              CopiedFromIEN :=
                StrToIntDef
                (Piece(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^',
                3), ';', 1), -1);
              CopiedFromPackage :=
                Piece(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^',
                3), ';', 2);

              if fHashBuffer then
                HashValue :=
                  Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 4)
              else
              begin
                CopiedText := TStringList.Create;
                // If not hashed then load  the full buffer
                NumLines :=
                  StrToIntDef
                  (Piece(BufferList.Values['(' + IntToStr(I) + ',0)'],
                  '^', 5), -1);
                for x := 1 to NumLines do
                  CopiedText.Add(BufferList.Values['(' + IntToStr(I) + ',' +
                    IntToStr(x) + ')']);
              end;
            end;

          end;
        finally
          FCriticalSection.Leave;
        end;
        BufferLoaded := true;

      finally
        If StopStopWatch then
          LogText('METRIC', 'Buffer build: ' + fStopWatch.Elapsed);
      end;

    end;

  finally
    BufferList.Free;
  end;
end;

procedure TCopyApplicationMonitor.SaveTheBuffer();
var
  SaveList, ReturnList: TStringList;
  I, SaveCnt, aIdx: Integer;
  ErrOccurred: Boolean;
begin
  if (csDesigning in ComponentState) then
    exit;

  FCriticalSection.Enter;
  try
    ErrOccurred := false;
    if not Enabled then
      Exit;

    if not BufferEnabled then
      Exit;

    if PolledBuffer and not BufferLoaded then
    begin
      // Ensure that the buffer poll has stoped
      if Assigned(fStopPollBuff) then
      begin
        LogText('BUFF', 'RPC STOP POLL');
        StartStopWatch;
        try
          fStopPollBuff(Self, ErrOccurred);
        finally
          If StopStopWatch then
            LogText('METRIC', 'Stop Buffer RPC: ' + fStopWatch.Elapsed);
        end;
      end;
    end;

    SaveList := TStringList.Create;
    ReturnList := TStringList.Create;
    try
      SaveCnt := 0;

      LogText('BUFF', 'Preparing Buffer for Save');
      StartStopWatch;
      try
        for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
        begin
          if FCPRSClipBoard[I].SaveToTheBuffer then
          begin
            Inc(SaveCnt);
            aIdx := SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) +
              '^' + FCPRSClipBoard[I].DateTimeOfCopy + '^' +
              IntToStr(FCPRSClipBoard[I].CopiedFromIEN) + ';' + FCPRSClipBoard
              [I].CopiedFromPackage + '^' + FCPRSClipBoard[I]
              .ApplicationName + '^');
            if fHashBuffer then
            begin
              if trim(FCPRSClipBoard[I].HashValue) <> '' then
                SaveList.Strings[aIdx] := SaveList.Strings[aIdx] +
                  FCPRSClipBoard[I].HashValue
              else if Assigned(FCPRSClipBoard[I].CopiedText) then
                SaveList.Strings[aIdx] := SaveList.Strings[aIdx] +
                  fpSHA.HashStringAsHex(FCPRSClipBoard[I].CopiedText.Text);
            end
            else
            begin
              if Assigned(FCPRSClipBoard[I].CopiedText) then
              begin
                SaveList.Add(IntToStr(SaveCnt) + ',-1=' +
                  IntToStr(FCPRSClipBoard[I].CopiedText.Count));
                BreakUpLongLines(SaveList, IntToStr(SaveCnt),
                  FCPRSClipBoard[I].CopiedText, FBreakUpLimit);
              end;
            end;

          end;
        end;
        SaveList.Add('TotalBufferToSave=' + IntToStr(SaveCnt));
      finally
        If StopStopWatch then
          LogText('METRIC', 'Build Save: ' + fStopWatch.Elapsed);
      end;
      LogText('BUFF', IntToStr(SaveCnt) + ' Items ready to save');
      if Assigned(FSaveBuffer) then
      begin
        StartStopWatch;
        try
          FSaveBuffer(Self, SaveList, ReturnList);
        finally
          If StopStopWatch then
            LogText('METRIC', 'Buffer Save RPC: ' + fStopWatch.Elapsed);
        end;
      end;
    finally
      ReturnList.Free;
      SaveList.Free;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.LoadTheProperties();
begin
  if not Enabled then
    Exit;

  if not LoadedProperties and Assigned(LoadProperties) then
  begin

    StartStopWatch;
    try
      LoadProperties(Self);
    finally
      If StopStopWatch then
        LogText('METRIC', 'Load Properties: ' + fStopWatch.Elapsed);
    end;

    // Log the properties
    LogText('PROP', 'Loading properties' + #13#10 + 'Number of words:' +
      FloatToStr(FNumberOfWords) + #13#10 + 'Percent to verify:' +
      FloatToStr(PercentToVerify));

  end;
  LoadedProperties := true;

end;

Procedure TCopyApplicationMonitor.EnableBuffer(Value: Boolean);
begin
  FCriticalSection.Enter;
  try
    BufferTimer.Enabled := Value;
  finally
    FCriticalSection.Leave;
  end;
end;

function TCopyApplicationMonitor.WordCount(TextToCount: string): Integer;
var
  CharCnt: Integer;

  function IsEnd(CharToCheck: char): Boolean;
  begin
    Result := CharInSet(CharToCheck, [#0 .. #$1F, ' ', '.', ',', '?', ':', ';',
      '(', ')', '/', '\']);
  end;

begin
  FCriticalSection.Enter;
  try
    Result := 0;
    if Enabled then
    begin
      CharCnt := 1;
      while CharCnt <= Length(TextToCount) do
      begin
        while (CharCnt <= Length(TextToCount)) and
          (IsEnd(TextToCount[CharCnt])) do
          Inc(CharCnt);
        if CharCnt <= Length(TextToCount) then
        begin
          Inc(Result);
          while (CharCnt <= Length(TextToCount)) and
            (not IsEnd(TextToCount[CharCnt])) do
            Inc(CharCnt);
        end;
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TCopyApplicationMonitor.LevenshteinDistance(String1, String2: String;
  CutOff: Integer): Double;
Var
  currentRow, previousRow, tmpRow: Array of Integer;
  firstLength, secondLength, I, J, tmpTo, tmpFrom, Cost: Integer;
  TmpStr: String;
  tmpChar: char;

begin
  FCriticalSection.Enter;
  try
    Result := 0.0;
    if not Enabled then
      Exit;
    firstLength := Length(String1);
    secondLength := Length(String2);

    if (firstLength = 0) then
    begin
      Result := secondLength;
      Exit;
    end
    else if (secondLength = 0) then
    begin
      Result := firstLength;
      Exit;
    end;

    if (firstLength > secondLength) then
    begin
      // Need to swap the text around for the compare
      TmpStr := String1;
      String1 := String2;
      String2 := TmpStr;
      // set the new lengths
      firstLength := secondLength;
      secondLength := Length(String2);
    end;

    // IF no max then use the longest length
    If (CutOff < 0) then
      CutOff := secondLength;

    // If more characters changed then our % threshold would allow then no need to calc
    if (secondLength - firstLength > CutOff) then
    begin
      Result := -1;
      Exit;
    end;

    SetLength(currentRow, firstLength + 1);
    SetLength(previousRow, firstLength + 1);

    // Pad the array
    for I := 0 to firstLength do
      previousRow[I] := I;

    for I := 1 to secondLength do
    begin
      tmpChar := String2[I];
      currentRow[0] := I - 1;
      tmpFrom := Max(I - CutOff - 1, 1);
      tmpTo := min(I + CutOff + 1, firstLength);
      for J := tmpFrom to tmpTo do
      begin
        if String1[J] = tmpChar then
          Cost := 0
        else
          Cost := 1;
        currentRow[J] := min(min(currentRow[J - 1] + 1, previousRow[J] + 1),
          previousRow[J - 1] + Cost);
      end;
      // shift the array around
      tmpRow := Copy(previousRow, 0, Length(previousRow));
      previousRow := Copy(currentRow, 0, Length(currentRow));
      currentRow := Copy(tmpRow, 0, Length(tmpRow));
      // clean up
      SetLength(tmpRow, 0);
    end;

    Result := (1 - (previousRow[firstLength] / Max(firstLength,
      secondLength))) * 100;

  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.RecalPercentage(ReturnedList: TStringList;
  var SaveList: TStringList; ExisitingPaste: TPasteArray);
var
  I, z: Integer;
  StringA, StringB: WideString;
  ArrayIdentifer, RPCIdentifer, Package, FromEdit: string;
  NumOfEntries, NumOfLines: Integer;
begin
  FCriticalSection.Enter;
  try
    if not Enabled then
      Exit;
    LogText('SAVE', 'Recalculate Percentage');
    StartStopWatch;
    try
      NumOfEntries := StrToIntDef(ReturnedList.Values['(0,0)'], 0);

      SaveList.Add('0=' + IntToStr(NumOfEntries));

      for I := 1 to NumOfEntries do
      begin

        FromEdit :=
          Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 5);

        if FromEdit = '1' then
        begin
          ArrayIdentifer :=
            Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 2);

          // Build String a from the internal clipboard
          for z := Low(ExisitingPaste) to High(ExisitingPaste) do
          begin
            if ExisitingPaste[z].PasteDBID = StrToIntDef(ArrayIdentifer, -1)
            then
            begin
              if Assigned(ExisitingPaste[z].OriginalText) then
                StringA := ExisitingPaste[z].OriginalText.Text
              else
                StringA := ExisitingPaste[z].PastedText.Text;
              Break;
            end;
          end;
        end
        else
        begin
          ArrayIdentifer :=
            Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 1);

          // Build String a from the internal clipboard
          for z := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
          begin
            if not Assigned(FCPRSClipBoard[z].CopiedText) then
              continue;
            if FCPRSClipBoard[z].SaveItemID = StrToIntDef(ArrayIdentifer, -1)
            then
            begin
              StringA := FCPRSClipBoard[z].CopiedText.Text;
              Break;
            end;
          end;
        end;

        // build string B from what was saved
        RPCIdentifer :=
          Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 2);
        Package := Piece(ReturnedList.Values['(' + IntToStr(I) +
          ',0)'], '^', 3);
        NumOfLines :=
          StrToIntDef(Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'],
          '^', 4), 0);

        StringB := '';
        for z := 1 to NumOfLines do
        begin
          StringB := StringB + ReturnedList.Values
            ['(' + IntToStr(I) + ',' + IntToStr(z) + ')'] + #13#10;
        end;

        // Strip the cariage returns out
        StringA := StringReplace(StringReplace(StringA, #13, '', [rfReplaceAll]
          ), #10, '', [rfReplaceAll]);
        StringB := StringReplace(StringReplace(StringB, #13, '', [rfReplaceAll]
          ), #10, '', [rfReplaceAll]);

        SaveList.Add(IntToStr(I) + '=' + RPCIdentifer + '^' + Package + '^' +
          IntToStr(round(LevenshteinDistance(StringA, StringB, -1))));

      end;
    finally
      If StopStopWatch then
        LogText('METRIC', 'Recal Build: ' + fStopWatch.Elapsed);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.LogText(Action: string;
  MessageTxt: TPasteArray);
begin
  if not Enabled then
    Exit;
  if Assigned(FLogObject) then
    if FLogObject.LogToFile = LOG_DETAIL then
      FLogObject.LogText(Action, FLogObject.Dump(MessageTxt));
end;

procedure TCopyApplicationMonitor.LogText(Action, MessageTxt: String);
begin
  if (csDesigning in ComponentState) then
    exit
  else begin
    if not Enabled then
    Exit;
  FCriticalSection.Enter;
  try
    if Assigned(FLogObject) then
      FLogObject.LogText(Action, MessageTxt);
  finally
    FCriticalSection.Leave;
  end;
  end;

end;

function TCopyApplicationMonitor.GetBufferEnabled: Boolean;
begin
  if (csDesigning in ComponentState) then
    Result := fBufferEnabled
  else
  begin
    FCriticalSection.Enter;
    try
      Result := fBufferEnabled;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetBufferPolled: Boolean;
begin
  if (csDesigning in ComponentState) then
    Result := FBufferPolled
  else
  begin
    FCriticalSection.Enter;
    try
      Result := FBufferPolled;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetBufferTimer: TTimer;
begin
  FCriticalSection.Enter;
  try
    Result := fBufferTimer;
  finally
    FCriticalSection.Leave;
  end;
end;

function TCopyApplicationMonitor.GetBufferTryLimit: Integer;
begin
  FCriticalSection.Enter;
  try
    Result := fBufferTryLimit;
  finally
    FCriticalSection.Leave;
  end;
end;

function TCopyApplicationMonitor.GetClipSource(GetLocked: Boolean = false)
  : tClipInfo;

  function GetAppByPID(PID: Cardinal): String;
  var
    snapshot: THandle;
    ProcEntry: TProcessEntry32;
  begin
    snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snapshot <> INVALID_HANDLE_VALUE) then
    begin
      ProcEntry.dwSize := SizeOf(ProcessEntry32);
      if (Process32First(snapshot, ProcEntry)) then
      begin
        // check the first entry
        if ProcEntry.th32ProcessID = PID then
          Result := ProcEntry.szExeFile
        else
        begin
          while Process32Next(snapshot, ProcEntry) do
          begin
            if ProcEntry.th32ProcessID = PID then
            begin
              Result := ProcEntry.szExeFile;
              Break;
            end;
          end;
        end;
      end;
    end;
    CloseHandle(snapshot);
  end;

  function GetHandleByPID(PID: Cardinal): HWND;
  type
    TEInfo = record
      PID: DWORD;
      HWND: THandle;
    end;
  var
    EInfo: TEInfo;

    function CallBack(Wnd: DWORD; var EI: TEInfo): Bool; stdcall;
    var
      PID: DWORD;
    begin
      GetWindowThreadProcessID(Wnd, @PID);
      Result := (PID <> EI.PID) or (not IsWindowVisible(Wnd)) or
        (not IsWindowEnabled(Wnd));

      if not Result then
        EI.HWND := Wnd;
    end;

  begin
    EInfo.PID := PID;
    EInfo.HWND := 0;
    EnumWindows(@CallBack, Integer(@EInfo));
    Result := EInfo.HWND;
  end;

begin
  if not Enabled then
  begin
    Result.AppName := INVALID_APP_NAME;
    Exit;
  end;
  LogText('PASTE', 'Clip Source');
  with Result do
  begin
    ObjectHwnd := 0;
    AppHwnd := 0;
    AppPid := 0;
    // Get the owners handle (TEdit, etc...)
    if GetLocked then
      ObjectHwnd := GetOpenClipboardWindow
    else
      ObjectHwnd := GetClipboardOwner;
    if ObjectHwnd <> 0 then
    begin
      // Get its running applications Process ID
      GetWindowThreadProcessID(ObjectHwnd, AppPid);

      if AppPid <> 0 then
      begin
        // Get the applciation name from the Process ID
        AppName := GetAppByPID(AppPid);

        // Get the main applications hwnd
        AppHwnd := GetHandleByPID(AppPid);

        SetLength(AppClass, 256);
        SetLength(AppClass, GetClassName(AppHwnd, PChar(AppClass),
          Length(AppClass)-1));
        SetLength(AppTitle, 256);
        SetLength(AppTitle, GetWindowText(AppHwnd, PChar(AppTitle),
          Length(AppTitle)-1));

      end
      else
        AppName := 'No Process Found';
    end
    else
      AppName := 'No Source Found';

  end;
end;

function TCopyApplicationMonitor.GetCPRSClipBoard: CprsClipboardArry;
begin
  FCriticalSection.Enter;
  try
    Result := FCPRSClipBoard;
  finally
    FCriticalSection.Leave;
  end;
end;

function TCopyApplicationMonitor.GetDisplayPaste: Boolean;
begin
  if (csDesigning in ComponentState) then
  Result := FDisplayPaste
  else begin
  FCriticalSection.Enter;
  try
    Result := FDisplayPaste;
  finally
    FCriticalSection.Leave;
  end;
  end;
end;

function TCopyApplicationMonitor.FromExcludedApp(AppName: String): Boolean;
var
  I: Integer;
begin
  if (csDesigning in ComponentState) then
    Exit(false);

  FCriticalSection.Enter;
  try
    result := false;
    if not Enabled then
      Exit;
    for I := 0 to ExcludeApps.Count - 1 do
    begin
      if UpperCase(Piece(ExcludeApps[I], '^', 1)) = UpperCase(AppName) then
      begin
        result := true;
        break;
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.SyncSizes(Sender: TObject);
var
  I, UseHeight: Integer;
begin
  if not Enabled then
    Exit;
  UseHeight := TCopyPasteDetails(Sender).Height;
  if Assigned(fSyncSizeList) then
  begin
    for I := Low(fSyncSizeList) to High(fSyncSizeList) do
    begin
      if Assigned(fSyncSizeList[I]) then
      begin
        if not Assigned(TCopyPasteDetails(fSyncSizeList[I]).ParentForm) then
          TCopyPasteDetails(fSyncSizeList[I]).ParentForm :=
            GetParentForm(TCopyPasteDetails(fSyncSizeList[I]), false);

        if (fSyncSizeList[I] <> Sender) and
          (TCopyPasteDetails(fSyncSizeList[I]).ParentForm = TCopyPasteDetails
          (Sender).ParentForm) then
          TCopyPasteDetails(fSyncSizeList[I]).Height := UseHeight;
      end;
    end;
  end;
end;

Function TCopyApplicationMonitor.StartStopWatch(): Boolean;
begin
  FCriticalSection.Enter;
  try
    Result := Assigned(fStopWatch);
    if Result then
      fStopWatch.Start;
  finally
    FCriticalSection.Leave;
  end;
end;

Function TCopyApplicationMonitor.StopStopWatch(): Boolean;
begin
  FCriticalSection.Enter;
  try
    Result := Assigned(fStopWatch);
    if Result then
      fStopWatch.Stop;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.IncBufferTryLimit;
var
  x: Integer;
begin
  FCriticalSection.Enter;
  try
    x := BufferTryLimit;
    Inc(x);
    BufferTryLimit := x;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.SetBufferEnabled(const Value: Boolean);
begin
  if (csDesigning in ComponentState) then
    fBufferEnabled := Value
  else
  begin
    FCriticalSection.Enter;
    try
      fBufferEnabled := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetBufferPolled(const Value: Boolean);
begin
  if (csDesigning in ComponentState) then
    FBufferPolled := Value
  else
  begin
    FCriticalSection.Enter;
    try
      FBufferPolled := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetBufferTimer(const Value: TTimer);
begin
  FCriticalSection.Enter;
  try
    fBufferTimer := Value;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.SetBufferTryLimit(const Value: Integer);
begin
  FCriticalSection.Enter;
  try
    fBufferTryLimit := Value;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TCopyApplicationMonitor.SetDisplayPaste(const Value: Boolean);
begin
  if (csDesigning in ComponentState) then
  FDisplayPaste := Value
  else begin
  FCriticalSection.Enter;
  try
    FDisplayPaste := Value;
  finally
    FCriticalSection.Leave;
  end;
  end;
end;

procedure TCopyApplicationMonitor.SetEnabled(aValue: Boolean);
begin
  if (csDesigning in ComponentState) then
    fEnabled := aValue
  else
  begin
    FCriticalSection.Enter;
    try
      fEnabled := aValue;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetHighlightColor(const Value: TColor);
begin
  if (csDesigning in ComponentState) then
    FHighlightColor := Value
  else
  begin
    FCriticalSection.Enter;
    try
      FHighlightColor := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetEnabled: Boolean;
begin
  if (csDesigning in ComponentState) then
    Result := fEnabled
  else
  begin
    FCriticalSection.Enter;
    try
      Result := fEnabled;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetLoadBuffer(const Value: TLoadBuffEvent);
begin
  if (csDesigning in ComponentState) then
    FLoadBuffer := Value
  else
  begin
    FCriticalSection.Enter;
    try
      FLoadBuffer := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetLoadedBuffer(const Value: Boolean);
begin
  if (csDesigning in ComponentState) then
  FLoadedBuffer := Value
  else begin
  FCriticalSection.Enter;
  try
    FLoadedBuffer := Value;
  finally
    FCriticalSection.Leave;
  end;
  end;
end;

procedure TCopyApplicationMonitor.SetLoadedProperties(aValue: Boolean);
begin
  if (csDesigning in ComponentState) then
  FLoadedProperties := aValue
  else begin
  FCriticalSection.Enter;
  try
    FLoadedProperties := aValue;
  finally
    FCriticalSection.Leave;
  end;
  end;
end;

procedure TCopyApplicationMonitor.SetMatchHighlight(const Value: Boolean);
begin
  if (csDesigning in ComponentState) then
    FMatchHighlight := Value
  else
  begin
    FCriticalSection.Enter;
    try
      FMatchHighlight := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetMatchStyle(const Value: TFontStyles);
begin
  if (csDesigning in ComponentState) then
    FMatchStyle := Value
  else
  begin
    FCriticalSection.Enter;
    try
      FMatchStyle := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetOnLoadProperties
  (const Value: TLoadProperties);
begin
  if (csDesigning in ComponentState) then
    FOnLoadProperties := Value
  else
  begin
    FCriticalSection.Enter;
    try
      FOnLoadProperties := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetStartPollBuff(const Value: TPollBuff);
begin
  if (csDesigning in ComponentState) then
    fStartPollBuff := Value
  else
  begin
    FCriticalSection.Enter;
    try
      fStartPollBuff := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SetStopPollBuff(const Value: TPollBuff);
begin
  if (csDesigning in ComponentState) then
    fStopPollBuff := Value
  else
  begin
    FCriticalSection.Enter;
    try
      fStopPollBuff := Value;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetLoadBuffer: TLoadBuffEvent;
begin
  if (csDesigning in ComponentState) then
    Result := FLoadBuffer
  else
  begin
    FCriticalSection.Enter;
    try
      Result := FLoadBuffer;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetLoadedBuffer: Boolean;
begin
  if (csDesigning in ComponentState) then
  Result := FLoadedBuffer
  else begin
  FCriticalSection.Enter;
  try
    Result := FLoadedBuffer;
  finally
    FCriticalSection.Leave;
  end;
  end;
end;

function TCopyApplicationMonitor.GetLoadedProperties: Boolean;
begin
   if (csDesigning in ComponentState) then
   Result := FLoadedProperties
   else begin
  FCriticalSection.Enter;
  try
    Result := FLoadedProperties;
  finally
    FCriticalSection.Leave;
  end;
   end;
end;

function TCopyApplicationMonitor.GetMatchHighlight: Boolean;
begin
  if (csDesigning in ComponentState) then
    Result := FMatchHighlight
  else
  begin
    FCriticalSection.Enter;
    try
      Result := FMatchHighlight;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetMatchStyle: TFontStyles;
begin
  if (csDesigning in ComponentState) then
    Result := FMatchStyle
  else
  begin
    FCriticalSection.Enter;
    try
      Result := FMatchStyle;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetOnLoadProperties: TLoadProperties;
begin
  if (csDesigning in ComponentState) then
    Result := FOnLoadProperties
  else
  begin
    FCriticalSection.Enter;
    try
      Result := FOnLoadProperties;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetStartPollBuff: TPollBuff;
begin
  if (csDesigning in ComponentState) then
    Result := fStartPollBuff
  else
  begin
    FCriticalSection.Enter;
    try
      Result := fStartPollBuff;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetStopPollBuff: TPollBuff;
begin
  if (csDesigning in ComponentState) then
    Result := fStopPollBuff
  else
  begin
    FCriticalSection.Enter;
    try
      Result := fStopPollBuff;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

function TCopyApplicationMonitor.GetExcludedList(): TStringList;
begin
  CriticalSection.Enter;
  try
    if not Assigned(fExcludedList) then
      fExcludedList := TStringList.Create;

    Result := fExcludedList;
  finally
    CriticalSection.Leave;
  end;
end;

function TCopyApplicationMonitor.GetHighlightColor: TColor;
begin
  if (csDesigning in ComponentState) then
    Result := FHighlightColor
  else
  begin
    FCriticalSection.Enter;
    try
      Result := FHighlightColor;
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

{$ENDREGION}

end.
