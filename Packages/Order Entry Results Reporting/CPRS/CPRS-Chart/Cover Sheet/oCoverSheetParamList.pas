unit oCoverSheetParamList;
{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Simple collection of the parameters for each pane in the
  *                     coversheet.
  *
  *       Notes:        Includes GetEnumerator as ICoverSheetParam.
  *
  ================================================================================
}

interface

uses
  System.Classes,
  System.SysUtils,
  iCoverSheetIntf;

type
  TCoverSheetParamList = class(TInterfacedObject, ICoverSheetParamList)
  private
    fParams: IInterfaceList;

    function getCoverSheetParam(aID: string): ICoverSheetParam;
    function getCoverSheetParamByIndex(aIndex: integer): ICoverSheetParam;
    function getCoverSheetParamCount: integer;

    function Add(aCoverSheetParam: ICoverSheetParam): boolean;
    function Clear: boolean;
    function GetEnumerator: ICoverSheetParamEnumerator;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  oCoverSheetParam,
  oCoverSheetParamEnumerator;

{ TCoverSheetParamList }

constructor TCoverSheetParamList.Create;
begin
  TInterfaceList.Create.GetInterface(IInterfaceList, fParams);
end;

destructor TCoverSheetParamList.Destroy;
begin
  Clear;
  fParams := nil;
  inherited;
end;

function TCoverSheetParamList.Clear: boolean;
begin
  try
    while fParams.Count > 0 do
      begin
        fParams[0] := nil;
        fParams.Delete(0);
      end;
    Result := True;
  except
    Result := False;
  end;
end;

function TCoverSheetParamList.getCoverSheetParamCount: integer;
begin
  Result := fParams.Count;
end;

function TCoverSheetParamList.getCoverSheetParam(aID: string): ICoverSheetParam;
begin
  Result := nil;
end;

function TCoverSheetParamList.getCoverSheetParamByIndex(aIndex: integer): ICoverSheetParam;
begin
  try
    Supports(fParams[aIndex], ICoverSheetParam, Result);
  except
    Result := nil;
  end;
end;

function TCoverSheetParamList.Add(aCoverSheetParam: ICoverSheetParam): boolean;
begin
  try
    fParams.Add(aCoverSheetParam);
    Result := True;
  except
    Result := False;
  end;
end;

function TCoverSheetParamList.GetEnumerator: ICoverSheetParamEnumerator;
begin
  TCoverSheetParamEnumerator.Create(fParams).GetInterface(ICoverSheetParamEnumerator, Result);
end;

end.
