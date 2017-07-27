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
  Winapi.Windows, Vcl.Forms, Winapi.TlHelp32;

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
    fStartPollBuff: TPollBuff;
    fStopPollBuff: TPollBuff;
    fBufferTryLimit: Integer;
    fLCSToggle: Boolean;
    fLCSCharLimit: Integer;
    FLCSTextColor: TColor;
    FLCSTextStyle: TFontStyles;
    FLCSUseColor: Boolean;
    fPasteLimit: Integer;

    /// <summary><para>External load properties event</para><para><b>Type: </b><c><see cref="U_CPTCommon|TLoadProperties" /></c></para></summary>
    FLoadProperties: TLoadProperties;
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
  public
    /// <summary><para>Holds list of currently running threads</para><para><b>Type: </b><c>Array of <see cref="U_CPTExtended|tCopyPasteThread" /></c></para></summary>
    FCopyPasteThread: TCopyPasteThreadArry;
    /// <summary><para>List of paste details (panels) to keep in size sync</para><para><b>Type: </b><c>Array of TPanel</c></para></summary>
    fSyncSizeList: TPanelArry;

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
    property DisplayPaste: Boolean read FDisplayPaste write FDisplayPaste;

    property SuperUser: Boolean read fSuperUser write fSuperUser;

    /// <summary>List of applications to exclude from tracking</summary>
    property ExcludeApps: TStringList read fExcludeApps write fExcludeApps;
    /// <summary><para>Get the owner (if applicable) from the clipboard</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <returns><para><b>Type: </b><c>tClipInfo</c></para> - </returns>
    function GetClipSource(GetLocked: Boolean = false): tClipInfo;

    property CPRSClipBoard: CprsClipboardArry Read FCPRSClipBoard;
    /// <summary>Used to calcuate percent</summary>
    /// <param name="String1">Original string</param>
    /// <param name="String2">Compare String</param>
    /// <param name="CutOff2">number of character changes to fall in the threshold</param>
    /// <returns>Percentage the same</returns>
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
    /// <summary><para>Sync all the sizes for the marked panels</para><para><b>Type: </b><c>Integer</c></para></summary>
    /// <param name="sender">sender<para><b>Type: </b><c>TObject</c></para></param>
    procedure SyncSizes(Sender: TObject);

    property BufferLoaded: Boolean read FLoadedBuffer;
    /// <summary>How many words appear in the text</summary>
    /// <param name="TextToCount">Occurences of</param>
    /// <returns>Total number of occurences</returns>
    function WordCount(TextToCount: string): Integer;

    Property PasteLimit: Integer read fPasteLimit;
  published
    /// <summary><para>where to break the text at</para><para><b>Type: </b>intger</para></summary>
    property BreakUpLimit: Integer read FBreakUpLimit write FBreakUpLimit;
    /// <summary>Color used to highlight the matched text</summary>
    property HighlightColor: TColor read FHighlightColor write FHighlightColor;
    /// <summary>Call to load the buffer </summary>
    property LoadBuffer: TLoadBuffEvent read FLoadBuffer write FLoadBuffer;
    /// <summary>Load the copy buffer from VistA</summary>
    procedure LoadTheBuffer();

    Procedure StopTheBuffer();

    /// <summary>External load for the properties</summary>
    property LoadProperties: TLoadProperties read FLoadProperties
      write FLoadProperties;
    /// <summary>External Load Properties</summary>
    procedure LoadTheProperties();
    /// <summary>Flag to display highlight when match found</summary>
    property MatchHighlight: Boolean read FMatchHighlight write FMatchHighlight;
    /// <summary>Style to use for the matched text font</summary>
    property MatchStyle: TFontStyles read FMatchStyle write FMatchStyle;
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
    Property PolledBuffer: Boolean read FBufferPolled write FBufferPolled;
    /// <summary>Call to save the buffer </summary>
    property SaveBuffer: TSaveEvent read FSaveBuffer write FSaveBuffer;
    /// <summary>Save copy buffer to VistA</summary>
    procedure SaveTheBuffer();

    property SaveCutOff: Double read FSaveCutOff write FSaveCutOff;
    property CompareCutOff: Integer read FCompareCutOff write FCompareCutOff;

    Property StartPollBuff: TPollBuff read fStartPollBuff write fStartPollBuff;
    Property StopPollBuff: TPollBuff read fStopPollBuff write fStopPollBuff;

    property LCSToggle: Boolean read fLCSToggle write fLCSToggle;
    property LCSCharLimit: Integer read fLCSCharLimit write fLCSCharLimit;
    property LCSUseColor: Boolean read FLCSUseColor write FLCSUseColor;
    property LCSTextColor: TColor read FLCSTextColor write FLCSTextColor;
    property LCSTextStyle: TFontStyles read FLCSTextStyle write FLCSTextStyle;

    /// <summary>The current users DUZ</summary>
    property UserDuz: Int64 read FUserDuz write FUserDuz;
    Property Enabled: Boolean read fEnabled write SetEnabled;
  end;

procedure Register;

implementation

uses
  U_CPTEditMonitor, U_CPTPasteDetails;

procedure Register;
begin
  RegisterComponents('Copy/Paste', [TCopyApplicationMonitor]);
end;

{$REGION 'CopyApplicationMonitor'}

procedure TCopyApplicationMonitor.ClearCopyPasteClipboard;
var
  I: Integer;
begin
  if not fEnabled then
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

end;

Procedure TCopyApplicationMonitor.PasteToCopyPasteClipboard(TextToPaste,
  PasteDetails: string; ItemIEN: Int64; ClipInfo: tClipInfo);
var
  TextFound, AddItem: Boolean;
  I, PosToUSe, CutOff: Integer;
  PertoCheck, LastPertToCheck: Double;
  CompareText: TStringList;
  Len1, Len2: Integer;
begin

  if not fEnabled then
    Exit;
  // load the properties
  if not FLoadedProperties then
    LoadTheProperties;
  // load the buffer
  if not FLoadedBuffer then
    LoadTheBuffer;

  TextFound := false;
  CompareText := TStringList.Create;
  try
    CompareText.Text := TextToPaste; // Apples to Apples

    // Direct macthes
    StartStopWatch;
    try
      for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
      begin
        If AnsiSameText(Trim(FCPRSClipBoard[I].CopiedText.Text),
          Trim(CompareText.Text)) then
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


            // Log info
            LogText('PASTE', 'Direct Match Found');
            LogText('PASTE', 'Pasted Text IEN(' + IntToStr(ItemIEN) + ')');
            LogText('TEXT', 'Pasted Text:' + #13#10 + CompareText.Text);
            LogText('PASTE', 'Matched to Text IEN(' +
              IntToStr(FCPRSClipBoard[I].CopiedFromIEN) + '):');
            LogText('TEXT', 'Matched to Text: ' + #13#10 +
              Trim(FCPRSClipBoard[I].CopiedText.Text));

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

              LogText('PASTE', 'Paste from cross session - Over Limit ' +
                PasteDetails);
              LogText('PASTE', 'Added to internal clipboard IEN(-1)');
            end
            else
            begin
              // Exceeds the limit set
              CopiedFromIEN := -1;
              CopiedFromPackage := 'Paste exceeds maximum compare limit.';
              if Trim(ClipInfo.AppName) <> '' then
                CopiedFromPackage := CopiedFromPackage + ' From: ' +
                  ClipInfo.AppName + ' - ' + ClipInfo.AppTitle;
              ApplicationPackage := MonitoringPackage;
              ApplicationName := MonitoringApplication;
              PercentMatch := 100.0;

              LogText('PASTE', 'Pasted from outside the tracking - Over Limit ('
                + IntToStr(Length(CompareText.Text)) + ')');
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
            try
              Len1 := Length(Trim(FCPRSClipBoard[I].CopiedText.Text));
              Len2 := Length(CompareText.Text);
              CutOff := ceil(min(Len1, Len2) * (FPercentToVerify * 0.01));
              PertoCheck := LevenshteinDistance
                (Trim(FCPRSClipBoard[I].CopiedText.Text),
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
              LogText('TEXT', 'Matched to Text: ' + #13#10 +
                Trim(FCPRSClipBoard[PosToUSe].CopiedText.Text));
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

                PercentData := IntToStr(FCPRSClipBoard[PosToUSe].CopiedFromIEN)
                  + ';' + FCPRSClipBoard[PosToUSe].CopiedFromPackage;
                PasteToIEN := ItemIEN;
                PasteDBID := -1;
                DateTimeOfCopy := FloatToStr(DateTimeToFMDateTime(Now));
                SaveForDocument := true;
                DateTimeOfPaste := FloatToStr(DateTimeToFMDateTime(Now));
                SaveToTheBuffer := true;
                CopiedText := TStringList.Create;
                CopiedText.Text := CompareText.Text;
                OriginalText := TStringList.Create;
                OriginalText.Text := FCPRSClipBoard[PosToUSe].CopiedText.Text;
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

                LogText('PASTE', 'Paste from cross session ' + PasteDetails);
                LogText('PASTE', 'Added to internal clipboard IEN(-1)');

              end
              else
              begin
                CopiedFromIEN := -1;
                CopiedFromPackage := 'Outside of current ' +
                  MonitoringApplication + ' tracking.';
                if Trim(ClipInfo.AppName) <> '' then
                  CopiedFromPackage := CopiedFromPackage + 'From: ' +
                    ClipInfo.AppName + ' - ' + ClipInfo.AppTitle;
                ApplicationPackage := MonitoringPackage;
                ApplicationName := MonitoringApplication;
                PercentMatch := 100.0;

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
  if not fEnabled then
    Exit;
  // load the properties
  // if not FLoadedProperties then
  // LoadTheProperties;
  // load the buffer
  // if not FLoadedBuffer then
  // LoadTheBuffer;
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

              SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) + '^' +
                FCPRSClipBoard[I].DateTimeOfPaste + '^' + IntToStr(ItemIEN) +
                ';' + RelatedPackage + '^' + IntToStr(IEN2Use) + ';' +
                Package2Use + '^' + FloatToStr(FCPRSClipBoard[I].PercentMatch) +
                '^' + FCPRSClipBoard[I].ApplicationName + '^-1^');

              // Line Count (w/out OUR line breaks for size - code below)

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
                      StrToIntDef(FndListHash.Values['(' + IntToStr(x) +
                      ',0)'], -1);
                    // Reuse
                    FndList.Clear;
                    for z := 1 to FndLineNum do
                      FndList.Add(FndListHash.Values['(' + IntToStr(x) + ',' +
                        IntToStr(z) + ')']);

                    BreakUpLongLines(SaveList, IntToStr(SaveCnt) + ',Paste,' +
                      IntToStr(x), FndList, FBreakUpLimit);
                  end;
                  { end else if FndPercent = -1 then
                    begin
                    If not Assigned(FCPRSClipBoard[I].OriginalText) then
                    begin
                    //Move the paste text into the "copy" section and then make the find text the new paste text
                    SaveList.SaveToFile('test.txt');
                    FndPercent := 100;
                    tmp := SaveList.Values[IntToStr(SaveCnt) +',0'];
                    SetPiece(tmp, '^', 5, '100');
                    SaveList.Values[IntToStr(SaveCnt) +',0'] := tmp;
                    //Move the original paste into the "copy"
                    FndLineNum := StrToIntDef(SaveList.Values[IntToStr(SaveCnt) +',-1'], -1);

                    Idx:=SaveList.IndexOfName(IntToStr(SaveCnt) +',-1');
                    If Idx >= 0 then
                    SaveList.Delete(Idx);

                    SaveList.Add(IntToStr(SaveCnt) + ',Copy,0=' + IntToStr(FndLineNum));
                    for X := 1 to FndLineNum do
                    begin
                    SaveList.Add(IntToStr(SaveCnt) + ',Copy,'+IntToStr(x)+'=' + SaveList.Values[IntToStr(SaveCnt) +',' + IntToStr(x)] );
                    //Now delete the "old" Line
                    Idx:=SaveList.IndexOfName(IntToStr(SaveCnt) +',' + IntToStr(x));
                    If Idx >= 0 then
                    SaveList.Delete(Idx);
                    end;
                    SaveList.SaveToFile('test.txt');
                    //Move the find text into the paste
                    FndListHash.Assign(FndList);
                    //Get the total number of finds
                    FndTotalCnt := StrToIntDef(FndListHash.Values['(0)'], -1);

                    FndList.Clear;
                    for x := 1 to FndTotalCnt do
                    begin
                    if X > 1 then
                    FndList.Add('');
                    FndLineNum := StrToIntDef(FndListHash.Values['(' + IntToStr(X) + ',0)'], -1);
                    for Z := 1 to FndLineNum do
                    FndList.Add(FndListHash.Values['(' + IntToStr(X) + ',' + IntToStr(Z) + ')']);
                    end;

                    BreakUpLongLines(SaveList, IntToStr(SaveCnt), FndList, FBreakUpLimit);

                    end; }

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
  TmpStr: string;

  procedure AddToClipBrd(CPDetails, CPText: string);
  var
    gMem: HGLOBAL;
    lp: Pointer;
  begin
{$WARN SYMBOL_PLATFORM OFF}
    Win32Check(OpenClipBoard(0));
    try
      Win32Check(EmptyClipBoard);
      // Add the details to the clipboard
      gMem := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, Length(CPDetails) + 1);
      try
        Win32Check(gMem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, Pointer(PAnsiChar(AnsiString(CPDetails))),
          Length(CPDetails) + 1);
        Win32Check(gMem <> 0);
        SetClipboardData(CF_CopyPaste, gMem);
        Win32Check(gMem <> 0);
      finally
        GlobalUnlock(gMem);
      end;

      // now add the text to the clipboard
      CPText := StringReplace(CPText, #13, #13#10, [rfReplaceAll]);
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE,
        (Length(CPText) + 1) * 2);
      try
        Win32Check(gMem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, Pointer(PAnsiChar(AnsiString(CPText))),
          (Length(CPText) + 1) * 2);
        Win32Check(gMem <> 0);
        SetClipboardData(CF_TEXT, gMem);
        Win32Check(gMem <> 0);
      finally
        GlobalUnlock(gMem);
      end;
    finally
      Win32Check(CloseClipBoard);
    end;
{$WARN SYMBOL_PLATFORM ON}
  end;

begin
  if not fEnabled then
    Exit;
  Found := false;
  if not FLoadedProperties then
    LoadTheProperties;
  if not FLoadedBuffer then
    LoadTheBuffer;

  LogText('COPY', 'Copying data from IEN(' + IntToStr(ItemID) + ')');
  StartStopWatch;
  try
    if WordCount(TextToCopy) >= FNumberOfWords then
    begin
      // check if this already exist
      for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
      begin
        if FCPRSClipBoard[I].CopiedFromPackage = UpperCase(FromName) then
        begin
          if FCPRSClipBoard[I].CopiedFromIEN = ItemID then
          begin
            if AnsiSameText(Trim(FCPRSClipBoard[I].CopiedText.Text),
              Trim(TextToCopy)) then
            begin
              Found := true;

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
      end;
    end;

    TryCpy := true;
    RetryCnt := 1;

    while TryCpy do
    begin
      while (RetryCnt <= Max_Retry) and TryCpy do
      begin
        try
          AddToClipBrd(IntToStr(ItemID) + '^' + UpperCase(FromName) + '^' +
            MonitoringPackage + '^' + MonitoringApplication, TextToCopy);
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
end;

constructor TCopyApplicationMonitor.Create(AOwner: TComponent);
Var
  I: Integer;
begin
  inherited;
  FLoadedBuffer := false;
  FLoadedProperties := false;
  FHighlightColor := clYellow;
  FMatchStyle := [];
  FMatchHighlight := true;
  FDisplayPaste := true;
  fEnabled := true;
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
        FLogObject.LogToFile := LOG_DETAIL;
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

    FCriticalSection := TCriticalSection.Create;
    fExcludeApps := TStringList.Create;
    fExcludeApps.CaseSensitive := false;
  end;
  SetLength(fSyncSizeList, 0);
  LogText('START', StringOfChar('*', 20) + FormatDateTime('mm/dd/yyyy hh:mm:ss',
    Now) + StringOfChar('*', 20));
  LogText('INIT', 'Monitor object created');

end;

destructor TCopyApplicationMonitor.Destroy;
var
  I: Integer;
begin
  // Clear copy arrays
  for I := Low(FCPRSClipBoard) to High(FCPRSClipBoard) do
  begin
    FCPRSClipBoard[I].CopiedText.Free;
    If Assigned(FCPRSClipBoard[I].OriginalText) then
      FCPRSClipBoard[I].OriginalText.Free;
  end;
  SetLength(FCPRSClipBoard, 0);
  SetLength(fSyncSizeList, 0);

  if Assigned(FCriticalSection) then
    FCriticalSection.Free;
  if Assigned(fExcludeApps) then
    fExcludeApps.Free;

  for I := Low(FCopyPasteThread) to High(FCopyPasteThread) do
    FCopyPasteThread[I].Terminate;
  SetLength(FCopyPasteThread, 0);

  if Assigned(fStopWatch) then
    fStopWatch.Free;
  LogText('INIT', 'Monitor object destroyed');
  LogText('STOP', StringOfChar('*', 20) + FormatDateTime('mm/dd/yyyy hh:mm:ss',
    Now) + StringOfChar('*', 20));
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
  ErrOccurred := false;
  if not fEnabled or FLoadedBuffer then
    Exit;

  // Do we need to start the polling
  if not Assigned(fBufferTimer) then
  begin
    if not Assigned(fStartPollBuff) then
    begin
      // need to be able to start the buffer
      FLoadedBuffer := true;
      Exit;
    end
    else
    begin
      LogText('BUFF', 'RPC START POLL');
      StartStopWatch;
      try
        fStartPollBuff(Self, ErrOccurred);
      finally
        If StopStopWatch then
          LogText('METRIC', 'Start Buffer RPC: ' + fStopWatch.Elapsed);
      end;
      if ErrOccurred then
      begin
        FLoadedBuffer := true;
        Exit;
      end;
    end;

    fBufferTimer := TTimer.Create(Self);
    fBufferTimer.Interval := Timer_Delay;
    fBufferTimer.OnTimer := LoadTheBufferPolled;
    fBufferTimer.Enabled := true;
    fBufferTryLimit := 1;
    Exit; // Dont run the check right away, let the timmer handle this
  end;

  // Timmer has been started so lets check
  if (Sender is TTimer) then
  begin
    if not Assigned(FLoadBuffer) then
    begin
      // need to be able to check the buffer
      FLoadedBuffer := true;
      Exit;
    end
    else
    begin
      BufferList := THashedStringList.Create();
      try
        ProcessLoad := true;
        LoadDone := false;
        // BuffLoopStart := 0;
        // BuffLoopStop := -1;
        fBufferTimer.Enabled := false;
        LogText('BUFF', 'RPC BUFFER CALL');

        StartStopWatch;
        try
          FLoadBuffer(Self, BufferList, ProcessLoad);
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
                    (Piece(Piece(BufferList.Strings[BufferList.Count - 1], ',',
                    1), '(', 2), -1);

                  if BuffLoopStop > 0 then
                    SetLength(FCPRSClipBoard, BuffLoopStop);

                  if BuffLoopStart <> 0 then
                    fBufferTryLimit := 1;

                  for I := BuffLoopStart to BuffLoopStop do
                  begin

                    with FCPRSClipBoard[I - 1] do
                    begin
                      SaveForDocument := false;
                      SaveToTheBuffer := false;
                      tmpString := BufferList.Values['(' + IntToStr(I) + ',0)'];
                      DateTimeOfCopy := Piece(tmpString, '^', 1);
                      ApplicationPackage := Piece(tmpString, '^', 3);
                      CopiedFromIEN :=
                        StrToIntDef(Piece(Piece(tmpString, '^', 4),
                        ';', 1), -1);
                      CopiedFromPackage :=
                        Piece(Piece(tmpString, '^', 4), ';', 2);
                      ApplicationName := Piece(tmpString, '^', 6);
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
          finally
            If StopStopWatch then
              LogText('METRIC', 'Buffer build: ' + fStopWatch.Elapsed);
          end;

        end;

      finally
        BufferList.Free;
      end;

      Inc(fBufferTryLimit);

      if fBufferTryLimit = 3 then
        StopTheBuffer;

      // Stop the timer
      if LoadDone then
      begin
        FLoadedBuffer := true;
        fBufferTimer.Enabled := false;
        LogText('BUFF', 'Buffer loaded with ' + IntToStr(Length(FCPRSClipBoard))
          + ' Items');
      end
      else
        fBufferTimer.Enabled := true;

    end;
  end
  else
  begin
    // Not from the Timer so we need to wait until the call is done
    I := 0;
    while fBufferTimer.Enabled or (I >= Wait_Timeout) do
    begin
      // check to see if the buffer has finished yet
      Sleep(1000);
      Application.ProcessMessages;
      Inc(I);
    end;
  end;

end;

procedure TCopyApplicationMonitor.StopTheBuffer;
var
  ErrOccurred: Boolean;
begin
  ErrOccurred := false;
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

  FLoadedBuffer := true;
  fBufferTimer.Enabled := false;

end;

procedure TCopyApplicationMonitor.LoadTheBuffer();
var
  BufferList: TStringList;
  I, x: Integer;
  NumLines, BuffParent: Integer;
  ProcessLoad: Boolean;
begin
  if not fEnabled then
    Exit;

  if FBufferPolled then
  begin
    LoadTheBufferPolled(Self);
    Exit;
  end;

  // Non polled logic
  BufferList := TStringList.Create();
  try
    ProcessLoad := true;
    BuffParent := 0;
    if Assigned(FLoadBuffer) then
    begin
      LogText('BUFF', 'RPC CALL');

      StartStopWatch;
      try
        FLoadBuffer(Self, BufferList, ProcessLoad);
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

        for I := 1 to BuffParent do
        begin // first line is the total number

          LogText('BUFF', 'Buffer item (' + IntToStr(I) + '): ' +
            BufferList.Values['(' + IntToStr(I) + ',0)']);

          SetLength(FCPRSClipBoard, Length(FCPRSClipBoard) + 1);
          FCPRSClipBoard[High(FCPRSClipBoard)].SaveForDocument := false;
          FCPRSClipBoard[High(FCPRSClipBoard)].SaveToTheBuffer := false;
          FCPRSClipBoard[High(FCPRSClipBoard)].DateTimeOfCopy :=
            Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 1);
          FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationPackage :=
            Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 3);
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromIEN :=
            StrToIntDef
            (Piece(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 4),
            ';', 1), -1);
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedFromPackage :=
            Piece(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^',
            4), ';', 2);
          FCPRSClipBoard[High(FCPRSClipBoard)].ApplicationName :=
            Piece(BufferList.Values['(' + IntToStr(I) + ',0)'], '^', 6);
          FCPRSClipBoard[High(FCPRSClipBoard)].CopiedText := TStringList.Create;
          NumLines :=
            StrToIntDef(Piece(BufferList.Values['(' + IntToStr(I) + ',0)'],
            '^', 5), -1);
          for x := 1 to NumLines do
            FCPRSClipBoard[High(FCPRSClipBoard)
              ].CopiedText.Add(BufferList.Values['(' + IntToStr(I) + ',' +
              IntToStr(x) + ')']);

        end;
        FLoadedBuffer := true;

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
  I, SaveCnt: Integer;
  ErrOccurred: Boolean;
begin
  ErrOccurred := false;
  if not fEnabled then
    Exit;

  if FBufferPolled and not FLoadedBuffer then
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
          SaveList.Add(IntToStr(SaveCnt) + ',0=' + IntToStr(UserDuz) + '^' +
            FCPRSClipBoard[I].DateTimeOfCopy + '^' +
            IntToStr(FCPRSClipBoard[I].CopiedFromIEN) + ';' + FCPRSClipBoard[I]
            .CopiedFromPackage + '^' + FCPRSClipBoard[I].ApplicationName + '^');

          SaveList.Add(IntToStr(SaveCnt) + ',-1=' +
            IntToStr(FCPRSClipBoard[I].CopiedText.Count));
          BreakUpLongLines(SaveList, IntToStr(SaveCnt),
            FCPRSClipBoard[I].CopiedText, FBreakUpLimit);

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
end;

procedure TCopyApplicationMonitor.LoadTheProperties();
begin
  if not fEnabled then
    Exit;
  if not FLoadedProperties and Assigned(FLoadProperties) then
  begin

    StartStopWatch;
    try
      FLoadProperties(Self);
    finally
      If StopStopWatch then
        LogText('METRIC', 'Load Properties: ' + fStopWatch.Elapsed);
    end;

    // Log the properties
    LogText('PROP', 'Loading properties' + #13#10 + 'Number of words:' +
      FloatToStr(FNumberOfWords) + #13#10 + 'Percent to verify:' +
      FloatToStr(PercentToVerify));

  end;
  FLoadedProperties := true;

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
  // if not fEnabled then
  // Exit;
  Result := 0;
  if fEnabled then
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
end;

function TCopyApplicationMonitor.LevenshteinDistance(String1, String2: String;
  CutOff: Integer): Double;
Var
  currentRow, previousRow, tmpRow: Array of Integer;
  firstLength, secondLength, I, J, tmpTo, tmpFrom, Cost: Integer;
  TmpStr: String;
  tmpChar: char;

begin
  Result := 0.0;
  if not fEnabled then
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

end;

procedure TCopyApplicationMonitor.RecalPercentage(ReturnedList: TStringList;
  var SaveList: TStringList; ExisitingPaste: TPasteArray);
var
  I, z: Integer;
  StringA, StringB: WideString;
  ArrayIdentifer, RPCIdentifer, Package, FromEdit: string;
  NumOfEntries, NumOfLines: Integer;
begin
  if not fEnabled then
    Exit;
  LogText('SAVE', 'Recalculate Percentage');
  StartStopWatch;
  try
    NumOfEntries := StrToIntDef(ReturnedList.Values['(0,0)'], 0);

    SaveList.Add('0=' + IntToStr(NumOfEntries));

    for I := 1 to NumOfEntries do
    begin

      FromEdit := Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 5);

      if FromEdit = '1' then
      begin
        ArrayIdentifer :=
          Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 2);

        // Build String a from the internal clipboard
        for z := Low(ExisitingPaste) to High(ExisitingPaste) do
        begin
          if ExisitingPaste[z].PasteDBID = StrToIntDef(ArrayIdentifer, -1) then
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
          if FCPRSClipBoard[z].SaveItemID = StrToIntDef(ArrayIdentifer, -1) then
          begin
            StringA := FCPRSClipBoard[z].CopiedText.Text;
            Break;
          end;
        end;
      end;

      // build string B from what was saved
      RPCIdentifer :=
        Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 2);
      Package := Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 3);
      NumOfLines := StrToIntDef
        (Piece(ReturnedList.Values['(' + IntToStr(I) + ',0)'], '^', 4), 0);

      StringB := '';
      for z := 1 to NumOfLines do
      begin
        StringB := StringB + ReturnedList.Values
          ['(' + IntToStr(I) + ',' + IntToStr(z) + ')'] + #13#10;
      end;

      // Strip the cariage returns out
      StringA := StringReplace(StringReplace(StringA, #13, '', [rfReplaceAll]),
        #10, '', [rfReplaceAll]);
      StringB := StringReplace(StringReplace(StringB, #13, '', [rfReplaceAll]),
        #10, '', [rfReplaceAll]);

      SaveList.Add(IntToStr(I) + '=' + RPCIdentifer + '^' + Package + '^' +
        IntToStr(round(LevenshteinDistance(StringA, StringB, -1))));

    end;
  finally
    If StopStopWatch then
      LogText('METRIC', 'Recal Build: ' + fStopWatch.Elapsed);
  end;
end;

procedure TCopyApplicationMonitor.LogText(Action: string;
  MessageTxt: TPasteArray);
begin
  if not fEnabled then
    Exit;
  if Assigned(FLogObject) then
    if FLogObject.LogToFile = LOG_DETAIL then
      FLogObject.LogText(Action, FLogObject.Dump(MessageTxt));
end;

procedure TCopyApplicationMonitor.LogText(Action, MessageTxt: String);
begin
  if not fEnabled then
    Exit;
  if Assigned(FLogObject) then
    FLogObject.LogText(Action, MessageTxt);
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
  if not fEnabled then
    Exit;
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

        SetLength(AppClass, 255);
        SetLength(AppClass, GetClassName(AppHwnd, PChar(AppClass),
          Length(AppClass)));
        SetLength(AppTitle, 255);
        SetLength(AppTitle, GetWindowText(AppHwnd, PChar(AppTitle),
          Length(AppTitle)));

      end
      else
        AppName := 'No Process Found';
    end
    else
      AppName := 'No Source Found';

  end;
end;

function TCopyApplicationMonitor.FromExcludedApp(AppName: String): Boolean;
var
  I: Integer;
begin
  Result := false;
  if not fEnabled then
    Exit;
  for I := 0 to ExcludeApps.Count - 1 do
  begin
    if UpperCase(Piece(ExcludeApps[I], '^', 1)) = UpperCase(AppName) then
    begin
      Result := true;
      Break;
    end;
  end;
end;

procedure TCopyApplicationMonitor.SyncSizes(Sender: TObject);
var
  I, UseHeight: Integer;
begin
  if not fEnabled then
    Exit;
  UseHeight := TCopyPasteDetails(Sender).Height;
  if Assigned(fSyncSizeList) then
  begin
    for I := Low(fSyncSizeList) to High(fSyncSizeList) do
    begin
      if Assigned(fSyncSizeList[I]) then
      begin
        if not Assigned(TCopyPasteDetails(fSyncSizeList[I]).ParentForm)  then
          TCopyPasteDetails(fSyncSizeList[I]).ParentForm := GetParentForm(TCopyPasteDetails(fSyncSizeList[I]), false);

        if (fSyncSizeList[I] <> Sender) and (TCopyPasteDetails(fSyncSizeList[I]).ParentForm = TCopyPasteDetails(Sender).ParentForm) then
          TCopyPasteDetails(fSyncSizeList[I]).Height := UseHeight;
      end;
    end;
  end;
end;

Function TCopyApplicationMonitor.StartStopWatch(): Boolean;
begin

  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Start;
end;

Function TCopyApplicationMonitor.StopStopWatch(): Boolean;
begin
  Result := Assigned(fStopWatch);
  if Result then
    fStopWatch.Stop;
end;

procedure TCopyApplicationMonitor.SetEnabled(aValue: Boolean);
begin
  fEnabled := aValue;
end;

{$ENDREGION}

end.
