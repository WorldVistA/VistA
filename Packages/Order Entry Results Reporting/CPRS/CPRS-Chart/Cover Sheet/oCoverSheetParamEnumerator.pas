unit oCoverSheetParamEnumerator;

{
  ================================================================================
  *
  *       Application:  CPRS - Coversheet
  *       Developer:    dan.petit@domain.ext
  *       Site:         Salt Lake City ISC
  *       Date:         2015-12-04
  *
  *       Description:  Simple enumerator for TCoverSheetParamList object.
  *
  *       Notes:
  *
  ================================================================================
}
interface

uses
  System.Classes,
  SysUtils,
  iCoverSheetIntf;

type
  TCoverSheetParamEnumerator = class(TInterfacedObject, ICoverSheetParamEnumerator)
  private
    fList: IInterfaceList;
    fIndex: integer;
  public
    constructor Create(aList: IInterfaceList);
    destructor Destroy; override;

    function GetCurrent: ICoverSheetParam;
    function MoveNext: boolean;
  end;

implementation

{ TCoverSheetParamEnumerator }

constructor TCoverSheetParamEnumerator.Create(aList: IInterfaceList);
begin
  inherited Create;
  aList.QueryInterface(IInterfaceList, fList);
  fIndex := -1;
end;

destructor TCoverSheetParamEnumerator.Destroy;
begin
  fList := nil;
  inherited;
end;

function TCoverSheetParamEnumerator.GetCurrent: ICoverSheetParam;
begin
  try
    Supports(fList[fIndex], ICoverSheetParam, Result);
  except
    Result := nil;
  end;
end;

function TCoverSheetParamEnumerator.MoveNext: boolean;
begin
  try
    if fIndex >= (fList.Count - 1) then
      Result := False
    else
      begin
        Result := fIndex < (fList.Count - 1);
        if Result then
          Inc(fIndex);
      end;
  except
    Result := False;
  end;
end;

end.
