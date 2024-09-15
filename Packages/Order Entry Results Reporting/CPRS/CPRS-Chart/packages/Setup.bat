::*********************************************************
:: Batch file used to run post clone actions
::
:: This file will install the client hooks
::
::*********************************************************



setlocal enabledelayedexpansion

@ECHO OFF
cls
xcopy /s .githooks .git\hooks
