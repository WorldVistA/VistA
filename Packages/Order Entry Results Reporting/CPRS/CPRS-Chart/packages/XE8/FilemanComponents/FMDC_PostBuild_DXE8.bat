if exist "%~1Resource" goto COPYFILES
mkdir "%~1Resource"
:COPYFILES
copy dcu\*.dcu "%~1Resource"
copy source\*.dfm "%~1Resource"
copy source\*.dcr "%~1Resource"
rmdir dcu /s /q
