if exist "%~1Resource" goto COPYFILES
mkdir "%~1Resource"
:COPYFILES
copy %~dp0..\..\dcu\*.dcu "%~1Resource"
rmdir %~dp0..\..\dcu /s /q