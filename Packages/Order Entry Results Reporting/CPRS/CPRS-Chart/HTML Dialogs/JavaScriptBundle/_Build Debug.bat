rmdir dist /S /Q
call npm run buildD
pause
IF NOT EXIST .\dist\bundle.zip exit  
echo.
echo.
echo.
cd ..\..\
if EXIST CPRSChart.dres del CPRSChart.dres
call rsvars
call msbuild CPRSChart.dproj
pause