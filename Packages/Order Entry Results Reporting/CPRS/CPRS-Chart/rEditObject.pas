unit rEditObject;


interface
uses Contnrs, SysUtils, Classes, ORNet, ORFn, ORClasses, ORNetINTF;

procedure getLayoutLists(aList: iORNetMult; defaultList: TStrings; var layoutList: TStrings; var dataList: TStrings;
                        var dataTypes: TStrings; var dataDefaultList: TStrings; var dataAboveLineList: TStrings);
function validateResults(list, inputList, resultList: TStrings): boolean;
implementation

procedure getLayoutLists(aList: iORNetMult; defaultList: TStrings; var layoutList: TStrings; var dataList: TStrings;
                        var dataTypes: TStrings; var dataDefaultList: TStrings; var dataAboveLineList: TStrings);
var
aReturn: TStrings;
i: integer;
temp: string;
begin
  aReturn := TStringList.Create;
  try
    callVistA('ORFEDT GETLAYOT', [aList, defaultList], aReturn);
    if aReturn.Count = 0 then
      begin
        ShowMessage('Editor settings not found');
        exit;
      end;
    if piece(aReturn[0], U, 1)='-1' then
      begin
        ShowMessage(piece(aReturn[0], U, 2));
        exit;
      end;
    for i := 0 to aReturn.Count - 1 do
      begin
        temp := aReturn.Strings[i];
        if (Piece(temp, u, 1) <> 'DATA') and (Piece(temp, u, 1) <> 'DATA DEFAULT') and
          (Piece(temp, u, 1) <> 'DATA WORD PROCESSING') and (Piece(temp, u, 1) <> 'LINE') then layoutList.Add(temp)
        else if Piece(temp, u, 1) = 'DATA' then
          begin
            if dataTypes.IndexOf(Piece(temp, u, 2)) = -1 then
              dataTypes.Add(Piece(temp, u, 2));
            dataList.Add(Pieces(temp, u, 2, 20));
          end
        else if Piece(temp, u, 1) = 'DATA DEFAULT' then
            dataDefaultList.Add(Pieces(temp, u, 2, 10))
        else if Piece(temp, u, 1) = 'DATA WORD PROCESSING' then
            begin
              dataTypes.Add(Piece(temp, u, 2));
              dataDefaultList.Add(Pieces(temp, u, 2,3));
            end
        else if Piece(temp, u, 1) = 'LINE' then
             dataAboveLineList.Add(Pieces(temp, u, 2,10));
      end;
  finally
     FreeAndNil(aReturn);
  end;
end;

function validateResults(list, inputList, resultList: TStrings): boolean;
var
temp: string;
aReturn: TStrings;
aList: iORNetMult;
i: integer;
begin
  aReturn := TStringList.Create;
  result := false;
  neworNetMult(aList);
  try
    for i := 0 to inputList.count - 1 do
      begin
        temp := InputList.strings[i];
        aList.AddSubscript(Piece(temp, u, 1), Piece(temp, u, 2));
      end;
    callVistA('ORFEDT BLDRESLT', [list, aList], aReturn);
    if aReturn.Count < 1 then
      begin
        resultList.Add('No data returned from ORFEDT BLDRESLT');
        exit;
      end
    else if Piece(aReturn.Strings[0], u, 1)  = '-1' then
      begin
        resultList.Add(Piece(aReturn.Strings[0], u, 2));
        exit;
      end
    else
      begin
        result := true;
        FastAssign(aReturn, resultList);
      end;
  finally
    FreeAndNil(aReturn);
  end;

end;



end.
