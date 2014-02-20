unit XuDsigU;

interface

uses
    Windows, SysUtils;


function SerialNum(pbdata: pbytearray; len: DWORD): string;
function CertDateTime(CertTime: FileTime): TdateTime;
function CertDateTimeStr(CertTime: FileTime): string;

implementation

//This helper function is to build a HEX string from
//a pointer the the Serial number in a CERT_INFO
function SerialNum(pbdata: pbytearray; len: DWORD): string;
var
    i: integer;
begin
    Result := '';    //Init return string
    for i := len - 1 downto 0 do
    begin
        Result := Result + IntToHex(byte(pbdata[i]), 2);

    end;
end;  //SerialNum

function CertDateTime(CertTime: FileTime): TdateTime;
var
    sysDateTime: TSystemTime;
    dDateTime: TdateTime;
    //To convert to printable string use
    // DateTimeToStr  or DateTimeToString
begin
    FileTimeToSystemTime(CertTime, sysDateTime);
    dDateTime := systemTimeToDateTime(sysDateTime);
    Result := dDateTime;
end;

//Returns a string from a Cert DateTime
function CertDateTimeStr(CertTime: FileTime): string;
var
    sysDateTime: TSystemTime;
    dDateTime: TdateTime;
begin
    FileTimeToSystemTime(CertTime, sysDateTime);
    dDateTime := systemTimeToDateTime(sysDateTime);
    Result := DateTimeToStr(dDateTime);
end;


end.
