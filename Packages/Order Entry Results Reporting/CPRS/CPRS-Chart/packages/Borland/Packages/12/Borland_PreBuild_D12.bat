if not exist %~dp0..\..\dcu goto MAKEDIR
rmdir %~dp0..\..\dcu /s /q
:MAKEDIR
mkdir %~dp0..\..\dcu

