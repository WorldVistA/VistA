if exist "%~1Resource" goto COPYFILES
mkdir "%~1Resource"
:COPYFILES
copy dcu\*.dcu "%~1Resource"
copy Source\OR2006Compatibility.dfm "%~1Resource"
copy Source\ORDtTm.dfm "%~1Resource"
copy Source\ORDtTmRng.dfm "%~1Resource"
copy Source\ORCtrls.res "%~1Resource"
copy Source\ORDtTm.res "%~1Resource"
rmdir dcu /s /q
