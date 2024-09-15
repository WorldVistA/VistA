unit ORCtrls.UORJSONParameters;

interface

uses
  ORNetIntf,
  VAShared.UJSONParameters;

type
  TIORNetMults = array of IORNetMult;

type
  TORJSONParameters = class(TJSONParameters)
  protected
    class function StrToIORNetMult(AString: string; PageSize: integer; const HDRDelimiter: string = DefaultPieceDelimiter): TIORNetMults;
  public
    function ToIORNetMults(LineSize, PageSize: integer): TIORNetMults;
  end;

implementation
uses
  System.Classes,
  System.SysUtils;

class function TORJSONParameters.StrToIORNetMult(AString: string; PageSize: integer; const HDRDelimiter: string = DefaultPieceDelimiter): TIORNetMults;
// This function generates an array of IORNetMult interfaces. They can be sent
// to VistA with calls to
//   CallVistA('VistAEndPoint', [AIEN, AIORNetMult, 0], AReturn);
// for each AIORNetMult interface in the array. See rTIU.SetText for how CPRS
// does this for notes. Remember that in Delphi, interfaces ARE reference
// counted.
//
// AString: The string to be converted
// PageSize: The number of lines per page
// HDRDelimiter: The delimiter used in the HDR Subscript element at the
//   bottom of each page.
// Result: An array of IORNetMult interfaces.
var
  I, Pages, Page, PageStart, PageEnd: integer;
  StringList: TStringList;
begin
  if PageSize <= 0 then raise EJSONParametersError.Create('PageSize must be > 0');
  StringList := TStringList.Create;
  try
    StringList.Text := AString;
    Pages := (StringList.Count div PageSize);
    if (StringList.Count mod PageSize) > 0 then Inc(Pages);
    SetLength(Result, Pages);
    for Page := 0 to Pages - 1 do
    begin
      if not NewORNetMult(Result[Page]) then
        raise EJSONParametersError.Create('Call to NewORNetMult failed');
      PageStart := Page * PageSize;
      PageEnd := (Page + 1) * PageSize - 1;
      if PageEnd >= StringList.Count then PageEnd := StringList.Count - 1;
      for I := PageStart to PageEnd do
      begin
        Result[Page].AddSubscript(['TEXT', I + 1, 0], StringList[I]);
      end;
      Result[Page].AddSubscript('HDR', Format('%d%s%d', [Page + 1, HDRDelimiter, Pages]));
    end;
  finally
    FreeAndNil(StringList);
  end;
end;

function TORJSONParameters.ToIORNetMults(LineSize, PageSize: integer): TIORNetMults;
// This function generates an array of IORNetMult interfaces. They can be sent
// to VistA with calls to
//   CallVistA('VistAEndPoint', [AIEN, AIORNetMult, 0], AReturn);
// for each AIORNetMult interface in the array. See rTIU.SetText for how CPRS
// does this for notes.
//
// LineSize: The number of characters per line (of JSON, not including the
//   overhead that IORNetMult imposes!)
// PageSize: The number of lines per page (Of JSON, again, not including the
//   overhead that IORNetMult imposes!)
// Result: An array of IORNetMult interfaces.
begin
  Result := StrToIORNetMult(ToString(LineSize), PageSize, PieceStringFormat.PieceDelimiter);
end;

end.
