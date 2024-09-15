unit uModuleParser;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.SyncObjs,
  System.SysUtils,
  Winapi.PsAPI,
  Winapi.Windows;

type
  TModuleParser = class(TObject)
  private type

    // used to represent each DLL, or each DLL exported function
    TEntry = class(TObject)
    private
      FName: String;
      FStartAddress: DWORD;
      FEndAddress: DWORD;
      function GetName: String; virtual;
    public
      property Name: String read GetName;
      property StartAddress: DWORD read FStartAddress;
      property EndAddress: DWORD read FEndAddress;
    end;

    TEntries = class(TObjectList<TEntry>)
    private
      FSorted: boolean;
      procedure SortEntries;
    public
      function Find(AAddress: DWORD): TEntry;
    end;

    // DLL Loaded into memory
    TModuleEntry = class(TEntry)
    private
      FEntries: TEntries;
      FHandle: HMODULE;
      FNameLoaded: boolean;
      function GetEntries: TEntries;
      function GetName: String; override;
    public
      constructor Create(AHandle: HMODULE; AStartAddress, AEndAddress: DWORD);
      destructor Destroy; override;
      property Entries: TEntries read GetEntries;
    end;

    // DLL information read from disk
    TFileEntry = class(TEntry)
    private
      FEntries: TEntries;
    public
      constructor Create(AFileName: string; ASize: DWORD);
      destructor Destroy; override;
      property Entries: TEntries read FEntries;
    end;

  private
    FModules: TEntries;
    class var FFiles: TStringList;
    class var FLock: TCriticalSection;
    procedure BuildModules;
    class constructor Create;
    class destructor Destroy;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RetrieveModuleInfo(AAddress: Pointer;
      var ModuleName, FunctionName: string; var Offset: DWORD);
  end;

implementation

uses
  Vcl.Forms;

{ TModuleParser.TEntry }

function TModuleParser.TEntry.GetName: String;
begin
  Result := FName;
end;

{ TModuleParser.TEntries }

function TModuleParser.TEntries.Find(AAddress: DWORD): TEntry;
var
  L, H, Mid: Integer;
  Entry: TEntry;
begin
  Result := nil;
  if Count <= 0 then
    exit;
  SortEntries;
  if (AAddress < Items[0].StartAddress) or
    (AAddress > Items[Count - 1].EndAddress) then
    exit;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    Mid := L + (H - L) shr 1;
    Entry := Items[Mid];
    if AAddress < Entry.StartAddress then
      H := Mid - 1
    else if AAddress > Entry.EndAddress then
      L := Mid + 1
    else
      exit(Entry);
  end;
  Entry := Items[L];
  if (AAddress < Entry.StartAddress) or (AAddress > Entry.EndAddress) then
    exit;
  Result := Entry;
end;

procedure TModuleParser.TEntries.SortEntries;
begin
  if not FSorted then
  begin
    Sort(TComparer<TEntry>.Construct(
      function(const L, R: TEntry): Integer
      begin
        // L.StartAddress - R.StartAddress causes integer overflow error
        if L.StartAddress < R.StartAddress then
          Result := -1
        else if L.StartAddress > R.StartAddress then
          Result := 1
        else
          Result := 0;
      end));
    FSorted := True;
  end;
end;

{ TModuleParser.TModuleEntry }

constructor TModuleParser.TModuleEntry.Create(AHandle: HMODULE;
AStartAddress, AEndAddress: DWORD);
begin
  inherited Create;
  FHandle := AHandle;
  FStartAddress := AStartAddress;
  FEndAddress := AEndAddress;
end;

destructor TModuleParser.TModuleEntry.Destroy;
begin
  FEntries.Free;
  inherited;
end;

function TModuleParser.TModuleEntry.GetEntries: TEntries;
var
  i, Index: Integer;
  FileEntry: TFileEntry;
  Entry: TEntry;

begin
  if not Assigned(FEntries) then
  begin
    FEntries := TEntries.Create;
    if GetName <> Application.ExeName then
    begin
      FLock.Acquire;
      try
        if not Assigned(FFiles) then
          FFiles := TStringList.Create(True);
        Index := FFiles.IndexOf(Name);
        if Index < 0 then
        begin
          if (FName = '') or (not FileExists(FName)) then
            exit(nil);
          FileEntry := TFileEntry.Create(Name, FEndAddress - FStartAddress);
          FFiles.AddObject(Name, FileEntry);
        end
        else
          FileEntry := FFiles.Objects[Index] as TFileEntry;
        for i := 0 to FileEntry.Entries.Count - 1 do
        begin
          Entry := TEntry.Create;
          Entry.FName := FileEntry.Entries[i].FName;
          Entry.FStartAddress := FStartAddress + FileEntry.Entries[i]
            .StartAddress;
          Entry.FEndAddress := FStartAddress + FileEntry.Entries[i].EndAddress;
          FEntries.Add(Entry);
        end;
      finally
        FLock.Release;
      end;
    end;
  end;
  Result := FEntries;
end;

function TModuleParser.TModuleEntry.GetName: String;
begin
  if not FNameLoaded then
  begin
    SetLength(FName, MAX_PATH);
    SetLength(FName, GetModuleFileName(FHandle, PChar(FName), Length(FName)));
    FNameLoaded := True;
  end;
  Result := inherited GetName;
end;

{ TModuleParser.TFileEntry }

constructor TModuleParser.TFileEntry.Create(AFileName: string; ASize: DWORD);
var
  i: Integer;
  Mem: TMemoryStream;
  Done: boolean;
  AImageDosHeader: TImageDosHeader;
  AImageNtHeaderSignature: DWORD;
  AImageFileHeader: TImageFileHeader;
  AImageOptionalHeader32: TImageOptionalHeader32;
  AImageOptionalHeader64: TImageOptionalHeader64;
  AExportAddr: TImageDataDirectory;
  AExportDir: TImageExportDirectory;
  ACanCatchSection: boolean;
  AOffset: Cardinal;
  AExportName: AnsiString;
  ALen: Cardinal;
  AOrdinal: Word;
  AFuncAddress: Cardinal;
  AExportEntry: TEntry;
  AForwarded: boolean;
  AForwardName: AnsiString;
  AImportVirtualAddress: Cardinal;

  function RVAToFileOffset(ARVA: Cardinal): Cardinal;
  var
    i: Integer;
    AImageSectionHeader: TImageSectionHeader;
    ASectionsOffset: Int64;
  begin
    Result := 0;
    if (ARVA = 0) or (NOT ACanCatchSection) then
      exit();
    ASectionsOffset := (AImageDosHeader._lfanew + SizeOf(DWORD) +
      SizeOf(TImageFileHeader) + AImageFileHeader.SizeOfOptionalHeader);
    for i := 0 to (AImageFileHeader.NumberOfSections - 1) do
    begin
      Mem.Seek(ASectionsOffset + (i * SizeOf(TImageSectionHeader)),
        soBeginning);
      Mem.ReadBuffer(AImageSectionHeader, SizeOf(TImageSectionHeader));
      if (ARVA >= AImageSectionHeader.VirtualAddress) and
        (ARVA < AImageSectionHeader.VirtualAddress +
        AImageSectionHeader.SizeOfRawData) then
        Result := (ARVA - AImageSectionHeader.VirtualAddress +
          AImageSectionHeader.PointerToRawData);
    end;
  end;

  function GetStringLength(AStartAtPos: Cardinal): Cardinal;
  var
    ADummy: Byte;
  begin
    Result := 0;
    Mem.Seek(AStartAtPos, soBeginning);
    while True do
    begin
      Mem.ReadBuffer(ADummy, SizeOf(Byte));
      if (ADummy = 0) then
        break;
      Inc(Result);
    end;
  end;

begin
  if not FileExists(AFileName) then
    raise EArgumentException.Create(AFileName + ' not found');
  inherited Create;
  Done := False;
  FEntries := TEntries.Create;
  try
    ACanCatchSection := False;
    Mem := TMemoryStream.Create;
    try
      try
        Mem.LoadFromFile(AFileName);
        Mem.ReadBuffer(AImageDosHeader, SizeOf(TImageDosHeader));
        if (AImageDosHeader.e_magic <> IMAGE_DOS_SIGNATURE) then
          exit;
        Mem.Seek(AImageDosHeader._lfanew, soBeginning);
        Mem.ReadBuffer(AImageNtHeaderSignature, SizeOf(DWORD));
        if (AImageNtHeaderSignature <> IMAGE_NT_SIGNATURE) then
          exit;
        Mem.ReadBuffer(AImageFileHeader, SizeOf(TImageFileHeader));
        ACanCatchSection := True;
        AExportAddr.VirtualAddress := 0;
        AExportAddr.Size := 0;
        if (AImageFileHeader.Machine = IMAGE_FILE_MACHINE_AMD64) then
        begin
          Mem.ReadBuffer(AImageOptionalHeader64,
            AImageFileHeader.SizeOfOptionalHeader);
          AExportAddr := AImageOptionalHeader64.DataDirectory
            [IMAGE_DIRECTORY_ENTRY_EXPORT];
          AImportVirtualAddress := AImageOptionalHeader64.DataDirectory
            [IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
        end
        else
        begin
          Mem.ReadBuffer(AImageOptionalHeader32,
            AImageFileHeader.SizeOfOptionalHeader);
          AExportAddr := AImageOptionalHeader32.DataDirectory
            [IMAGE_DIRECTORY_ENTRY_EXPORT];
          AImportVirtualAddress := AImageOptionalHeader32.DataDirectory
            [IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
        end;
        AOffset := RVAToFileOffset(AExportAddr.VirtualAddress);
        if AOffset = 0 then
          exit;
        Mem.Seek(AOffset, soBeginning);
        Mem.ReadBuffer(AExportDir, SizeOf(TImageExportDirectory));
        if (AExportDir.NumberOfFunctions <= 0) then
          exit;
        for i := 0 to AExportDir.NumberOfNames - 1 do
        begin
          AOffset := RVAToFileOffset(AExportDir.AddressOfNameOrdinals) +
            Cardinal(i * SizeOf(Word));
          Mem.Seek(AOffset, soBeginning);
          Mem.ReadBuffer(AOrdinal, SizeOf(Word));
          AOffset := RVAToFileOffset(AExportDir.AddressOfFunctions) +
            (AOrdinal * SizeOf(Cardinal));
          Mem.Seek(AOffset, soBeginning);
          Mem.ReadBuffer(AFuncAddress, SizeOf(Cardinal));
          AOffset := RVAToFileOffset(AExportDir.AddressOfNames) +
            Cardinal(i * SizeOf(Cardinal));
          Mem.Seek(AOffset, soBeginning);
          Mem.ReadBuffer(AOffset, SizeOf(Cardinal));
          ALen := GetStringLength(RVAToFileOffset(AOffset));
          SetLength(AExportName, ALen);
          Mem.Seek(RVAToFileOffset(AOffset), soBeginning);
          Mem.ReadBuffer(AExportName[1], ALen);
          AForwarded :=
            (AFuncAddress > RVAToFileOffset(AExportAddr.VirtualAddress)) and
            (AFuncAddress <= AImportVirtualAddress);
          if AForwarded then
          begin
            ALen := GetStringLength(RVAToFileOffset(AFuncAddress));
            Mem.Seek(RVAToFileOffset(AFuncAddress), soBeginning);
            SetLength(AForwardName, ALen);
            Mem.ReadBuffer(AForwardName[1], ALen);
          end
          else
            AForwardName := '';
          AExportEntry := TEntry.Create;
          AExportEntry.FName := String(AExportName);
          if AForwarded then
            AExportEntry.FName := AExportEntry.FName + '/' +
              String(AForwardName);
          AExportEntry.FStartAddress := AFuncAddress;
          FEntries.Add(AExportEntry);
        end;
        Done := True;
      except
        on e: EReadError do
          exit;
      end;
    finally
      Mem.Free;
    end;
  finally
    if Done and (FEntries.Count > 0) then
    begin
      FEntries.SortEntries;
      if FEntries.Count > 1 then
      begin
        for i := 0 to FEntries.Count - 2 do
          FEntries[i].FEndAddress := FEntries[i + 1].FStartAddress - 1;
      end;
      FEntries[FEntries.Count - 1].FEndAddress := ASize - 1
    end
    else
      FEntries.Clear;
  end;
end;

destructor TModuleParser.TFileEntry.Destroy;
begin
  FEntries.Free;
  inherited;
end;

{ TModuleParser }

procedure TModuleParser.BuildModules;
var
  ProcessHandle: THandle;
  i, max: Integer;
  ModuleHandles: array [0 .. 4095] of HMODULE;
  Info: _MODULEINFO;
  PInfo: LPMODULEINFO;
  Output: DWORD;
  Entry: TModuleEntry;
  SAddress, EAddress: DWORD;
begin
  if Assigned(FModules) then
    exit;
  FModules := TEntries.Create;
  ProcessHandle := GetCurrentProcess;
  if EnumProcessModules(ProcessHandle, @ModuleHandles, SizeOf(ModuleHandles),
    Output) then
  begin
    max := (Output div SizeOf(HMODULE)) - 1;
    PInfo := @Info;
    for i := 0 to max do
      if GetModuleInformation(ProcessHandle, ModuleHandles[i], PInfo,
        SizeOf(_MODULEINFO)) then
      begin
        SAddress := DWORD(Info.lpBaseOfDll);
        EAddress := SAddress + Info.SizeOfImage - 1;
        Entry := TModuleEntry.Create(ModuleHandles[i], SAddress, EAddress);
        FModules.Add(Entry);
      end;
  end;
end;

constructor TModuleParser.Create;
begin
  inherited Create;
  BuildModules;
end;

class constructor TModuleParser.Create;
begin
  FLock := TCriticalSection.Create;
end;

destructor TModuleParser.Destroy;
begin
  FreeAndNil(FModules);
  inherited;
end;

class destructor TModuleParser.Destroy;
begin
  FreeAndNil(FFiles);
  FreeAndNil(FLock);
end;

procedure TModuleParser.RetrieveModuleInfo(AAddress: Pointer;
var ModuleName, FunctionName: string; var Offset: DWORD);
var
  Address: DWORD;
  Module: TModuleEntry;
  Entry: TEntry;
begin
  ModuleName := '';
  FunctionName := '';
  Offset := 0;
  Address := DWORD(AAddress);
  Module := FModules.Find(Address) as TModuleEntry;
  if not Assigned(Module) then
    exit;
  ModuleName := Module.Name;
  // Module.GetEntries will return nil if file not found
  if not Assigned(Module.Entries) then
    exit;
  Entry := Module.Entries.Find(Address);
  if not Assigned(Entry) then
    exit;
  FunctionName := Entry.Name;
  Offset := Address - Entry.StartAddress;
end;

end.
