
@echo off

ECHO.

SETLOCAL
TITLE SRCBM Test Meaghan HCPS

set INQUISITPATH="C:\Program Files\Millisecond Software\Inquisit 5\Inquisit.exe"

:: Evaluate the Box configuration and set the path accordingly.
SET D1="C:\Users\%USERNAME%\Box\SRCBM\Data_collection\Meagan_HCPS"
SET D2="C:\Users\%USERNAME%\Box Sync\SRCBM\Data_collection\Meagan_HCPS"
SET D3="C:\Users\%USERNAME%\Box Sync\Meagan_HCPS"
SET D4="C:\Users\%USERNAME%\Box\Meagan_HCPS"
IF exist %D1%\ (set BOXPATH=%D1%) ELSE IF exist %D2%\ (set BOXPATH=%D2%) ELSE IF exist %D3%\ (set BOXPATH=%D3%)ELSE IF exist %D4%\ (set BOXPATH=%D4%) 

::echo Path = %BOXPATH%

set SCRIPT_1_PATH="%BOXPATH:"=%\ID_info\EngShortForm\ID_info_EngShortForm_Meaghan_final2.exp"
set SCRIPT_2_PATH="%BOXPATH:"=%\ERHYM\ERHYM_ShortFormsAB_Meaghan_Final2.iqx"
set SCRIPT_3_PATH="%BOXPATH:"=%\ELNFR\ELNFR_ShortFormsA_Meaghan_Final2.exp" 
set SCRIPT_4_PATH="%BOXPATH:"=%\ELNMC\ELNMC_ShortForms_Meaghan_Final2.exp"   
set SCRIPT_5_PATH="%BOXPATH:"=%\EVOCB\EVOCB_ShortFormsAB_Meaghan_Final2.exp"  
set SCRIPT_6_PATH="%BOXPATH:"=%\ELSFR\ELSFR_ShortFormAB_Meaghan_Final2.exp"  
set SCRIPT_7_PATH="%BOXPATH:"=%\ELSMC\ELSMC_ShortFormsAB_Meaghan_Final2.exp"
set SCRIPT_8_PATH="%BOXPATH:"=%\EBLFR\EBLFR_ShortFormsAB_Meaghan_Final2.exp"    
set SCRIPT_9_PATH="%BOXPATH:"=%\EBLMC\EBLMC_ShortFormsAB_Meaghan_Final2.iqx"
set SCRIPT_10_PATH="%BOXPATH:"=%\End_time\End_time_Meaghan_final2.exp"

set /a CODE=%RANDOM%

@echo ^<values^> > c:\TEMP\code.txt
@echo /code = %CODE% >> c:\TEMP\code.txt
@echo ^</values^> >> c:\TEMP\code.txt

:: Prompt user for Child ID, Group ID, and beginning test ID Number
echo.
set /p SID=Enter Child ID (4 - digit code): 
echo.

echo.
set /p GID=Enter Timepoint of test(Ranges from 1 - 9): 
echo.




::==================================================================::
::                                                                  ::
::                      Select test to begin with                   ::
::                                                                  ::
::==================================================================::

echo Test numbers:  
echo              1 - ERHYM
echo              2 - ELNFR
echo              3 - ELNMC
echo              4 - EVOCB
echo              5 - ELSFR
echo              6 - ELSMC
echo              7 - EBLFR
echo              8 - EBLMC

echo.

:: Request starting test number (set default to 1 first)
CHOICE /C 12345678 /N /M "Select starting test: "
SET /A TID=%ERRORLEVEL%

:: Begin Test
start "" /wait %INQUISITPATH% %SCRIPT_1_PATH% -s %SID% -g %GID%

IF %TID% LEQ 1 (
echo ERHYM
start "" /wait %INQUISITPATH% %SCRIPT_2_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 2 (
echo ELNFR 
start "" /wait %INQUISITPATH% %SCRIPT_3_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 3 (
echo ELNMC
start "" /wait %INQUISITPATH% %SCRIPT_4_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 4 (
echo EVOCB
start "" /wait %INQUISITPATH% %SCRIPT_5_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 5 (
echo ELSFR
start "" /wait %INQUISITPATH% %SCRIPT_6_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 6 (
echo ELSMC
start "" /wait %INQUISITPATH% %SCRIPT_7_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 7 (
echo EBLFR
start "" /wait %INQUISITPATH% %SCRIPT_8_PATH% -s %SID% -g %GID%
)

IF %TID% LEQ 8 (
echo EBLMC
start "" /wait %INQUISITPATH% %SCRIPT_9_PATH% -s %SID% -g %GID%
)

start "" /wait %INQUISITPATH% %SCRIPT_10_PATH% -s %SID% -g %GID%

echo test completed








