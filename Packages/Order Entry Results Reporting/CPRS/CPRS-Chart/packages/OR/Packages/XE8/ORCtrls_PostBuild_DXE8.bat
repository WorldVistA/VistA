if exist "%~1Resource" goto COPYFILES
mkdir "%~1Resource"
:COPYFILES
copy %~dp0..\..\dcu\*.dcu "%~1Resource"
copy %~dp0..\..\Source\OR2006Compatibility.dfm "%~1Resource"
copy %~dp0..\..\Source\ORDtTm.dfm "%~1Resource"
copy %~dp0..\..\Source\ORDtTmRng.dfm "%~1Resource"
copy %~dp0..\..\Source\ORCtrls.res "%~1Resource"
copy %~dp0..\..\Source\ORDtTm.res "%~1Resource"
rmdir %~dp0..\..\dcu /s /q
