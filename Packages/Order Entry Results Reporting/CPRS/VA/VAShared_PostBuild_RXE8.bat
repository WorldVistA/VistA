if exist "%~1Resource" goto COPYFILES
mkdir "%~1Resource"
:COPYFILES
copy dcu\*.dcu "%~1Resource"
rmdir dcu /s /q
