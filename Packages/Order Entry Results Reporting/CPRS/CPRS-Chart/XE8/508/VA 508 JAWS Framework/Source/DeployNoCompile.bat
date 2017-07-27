if exist "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\ConfigNames.ini" del "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\ConfigNames.ini"
if exist "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JCF" del "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JCF"
if exist "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JSB" del "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JSB"
if exist "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JSD" del "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JSD"
if exist "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JSS" del "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JSS"
if exist "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JDF" del "%appdata%\Freedom Scientific\JAWS\7.10\Settings\enu\VA508JAWS.JDF"

if exist "%appdata%\Freedom Scientific\JAWS\8.0\Settings\enu\ConfigNames.ini" del "%appdata%\Freedom Scientific\JAWS\8.0\Settings\enu\ConfigNames.ini"
if exist "%appdata%\Freedom Scientific\JAWS\8.0\Settings\enu\VA508JAWS.JCF" del "%appdata%\Freedom Scientific\JAWS\8.0\Settings\enu\VA508JAWS.JCF"
if exist "%appdata%\Freedom Scientific\JAWS\8.0\Settings\enu\VA508JAWS.JDF" del "%appdata%\Freedom Scientific\JAWS\8.0\Settings\enu\VA508JAWS.JDF"

if "%ProgramFiles(x86)%"=="" (
echo 32-bit
set "ProgRoot=%ProgramFiles%"
) else (
set "ProgRoot=%ProgramFiles(x86)%"
echo 64-bit
)
echo %ProgRoot%

if not exist "%ProgRoot%\Vista" mkdir "C:\%ProgRoot%\Vista"
if not exist "%ProgRoot%\Vista\Common Files" mkdir "%ProgRoot%\Vista\Common Files"

cd ..\..\..\..\CPRS-Chart\JAWS Support Files
copy /y *.* "%ProgRoot%\Vista\Common Files\"
pause

