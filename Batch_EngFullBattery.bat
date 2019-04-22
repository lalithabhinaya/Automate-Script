
@ECHO OFF
ECHO.

SETLOCAL

TITLE STEM English Full Battery 

set INQUISITPATH="C:\Program Files\Millisecond Software\Inquisit 5\Inquisit.exe"

:: Evaluate the Box configuration and set the path accordingly.
SET D1="C:\Users\%USERNAME%\Box\STEM\Data_collection"
SET D2="C:\Users\%USERNAME%\Box Sync\STEM\Data_collection"
SET D3="C:\Users\%USERNAME%\Box Sync\Data_collection"
IF exist %D1%\ (set BOXPATH=%D1%) ELSE IF exist %D2%\ (set BOXPATH=%D2%) ELSE IF exist %D3%\ (set BOXPATH=%D3%)

::echo Path = %BOXPATH%

set SCRIPT_1_PATH="%BOXPATH:"=%\Scaling_Final\ID_info\EngFullBattery\ID_info_STEM_EngFullBattery_final.exp"
set SCRIPT_2_PATH="%BOXPATH:"=%\Scaling_Final\ELIST\ELIST_MC_Y1_V3_formB_final_Practice_SS.iqx"
set SCRIPT_3_PATH="%BOXPATH:"=%\Scaling_Final\EScience\STEM_ESCIE_Final_SS.iqx"
set SCRIPT_4_PATH="%BOXPATH:"=%\Scaling_Final\EMATHMC\STEM_EMATH_RECEP_FINAL_SS.iqx"
set SCRIPT_5_PATH="%BOXPATH:"=%\Scaling_Final\EMATHFR\STEM_EMATHFR_Final.iqx"
set SCRIPT_6_PATH="%BOXPATH:"=%\Scaling_Final\ELIST\ELIST_MC_Y1_V3_formB_final_Practice_MS.iqx"
set SCRIPT_7_PATH="%BOXPATH:"=%\Scaling_Final\EScience\STEM_ESCIE_Final_MS.iqx"
set SCRIPT_8_PATH="%BOXPATH:"=%\Scaling_Final\EMATHMC\STEM_EMATH_RECEP_FINAL_MS.iqx"
set SCRIPT_9_PATH="%BOXPATH:"=%\Scaling_Final\EEnd\ESTEM_End_time_Scaling_final.exp"

set /a CODE=%RANDOM%

@echo ^<values^> > c:\TEMP\code.txt
@echo /code = %CODE% >> c:\TEMP\code.txt
@echo /comp_id = %USERNAME% >> c:\TEMP\code.txt
@echo ^</values^> >> c:\TEMP\code.txt

:: Prompt user for Subject ID, Group ID, and DOB
echo.
set /p SID=Enter subject ID: 
echo.

::==================================================================::
::                                                                  ::
::           Enter date of birth and calculate age group            ::
::                                                                  ::
::==================================================================::

:EnterDate 
SET "sDate=/"
:: Check if the first date is valid
SET /p DOB=Enter Child's Date of Birth (mm/dd/yyyy): 
(ECHO.%DOB%) | FINDSTR /R /B /C:"[0-9]*\%sDate%[0-9]*\%sDate%[0-9]*" >NUL
IF ERRORLEVEL 1 (
	ECHO Error: %DOB% is not a valid date
	ECHO.
	GOTO EnterDate
)

:: Get today's date for assessment date
FOR %%A IN (%Date%) DO SET Date2=%%A

:: Parse the first date
CALL :ParseDate %DOB%

:: Convert the parsed Gregorian date to Julian
CALL :JDate %GYear% %GMonth% %GDay%

:: Save the resulting Julian date
SET JDate1=%JDate%

:: Parse the second date
CALL :ParseDate %Date2%

:: Convert the parsed Gregorian date to Julian
CALL :JDate %GYear% %GMonth% %GDay%

:: Calculate the Age 
SET /A GID=(%JDate% - %JDate1%)/365
set "valid_Age=true"
IF %GID% GEQ 7 set "valid_Age=false"
IF %GID% LSS 2 set "valid_Age=false"
IF %GID% EQU 6 set GID=5
IF %GID% EQU 2 set GID=3

IF "%valid_Age%"=="false" (
	ECHO.
	ECHO Error: The DOB entered is outside the allowed range
	GOTO EnterDate
	ECHO.
) 

:: Display the result
::ECHO DOB          : %DOB%
ECHO                        Today's date     : %Date2%
ECHO                        Age Group        : %GID%



::==================================================================::
::                                                                  ::
::                      Select test to begin with                   ::
::                                                                  ::
::==================================================================::
echo.
echo Test numbers:  
echo 1 - Science Single Select
echo 2 - Math Single Select
echo 3 - Math Free Response
echo 4 - Science Multiple Select
echo 5 - Math Multiple Select
echo.

:: Request starting test number (set default to 1 first)
CHOICE /C 12345 /N /M "Select starting test: "
SET /A TID=%ERRORLEVEL%

:: Begin Test
start "" /wait %INQUISITPATH% %SCRIPT_1_PATH% -s %SID% -g %GID%

IF %TID% LEQ 2 (
echo SS practice
start "" /wait %INQUISITPATH% %SCRIPT_2_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 1 (
echo SS Science 
start "" /wait %INQUISITPATH% %SCRIPT_3_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 2 (
echo SS Math
start "" /wait %INQUISITPATH% %SCRIPT_4_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 3 (
echo Math FR
start "" /wait %INQUISITPATH% %SCRIPT_5_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 5 (
echo MS Practice
start "" /wait %INQUISITPATH% %SCRIPT_6_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 4 (
echo Science MS
start "" /wait %INQUISITPATH% %SCRIPT_7_PATH% -s %SID% -g %GID%
)
IF %TID% LEQ 5 (
echo Math MS
start "" /wait %INQUISITPATH% %SCRIPT_8_PATH% -s %SID% -g %GID%
)

start "" /wait %INQUISITPATH% %SCRIPT_9_PATH% -s %SID% -g %GID%



::===================================::
::                                   ::
::   -   S u b r o u t i n e s   -   ::
::                                   ::
::===================================::

:JDate
:: Convert date to Julian
:: Arguments : YYYY MM DD
:: Returns   : Julian date
::
:: First strip leading zeroes; a logical error in this
:: routine was corrected with help from Alexander Shapiro
SET MM=%2
SET DD=%3
IF 1%MM% LSS 110 SET MM=%MM:~1%
IF 1%DD% LSS 110 SET DD=%DD:~1%
::
:: Algorithm based on Fliegel-Van Flandern
:: algorithm from the Astronomical Almanac,
:: provided by Doctor Fenton on the Math Forum
:: (http://mathforum.org/library/drmath/view/51907.html),
:: and converted to batch code by Ron Bakowski.
SET /A Month1 = ( %MM% - 14 ) / 12
SET /A Year1  = %1 + 4800
SET /A JDate  = 1461 * ( %Year1% + %Month1% ) / 4 + 367 * ( %MM% - 2 -12 * %Month1% ) / 12 - ( 3 * ( ( %Year1% + %Month1% + 100 ) / 100 ) ) / 4 + %DD% - 32075
FOR %%A IN (Month1 Year1) DO SET %%A=
GOTO:EOF 


:ParseDate
:: Parse (Gregorian) date depending on registry's date format settings
:: Argument : Gregorian date in local date format,
:: Requires : sDate (local date separator), iDate (local date format number)
:: Returns  : GYear (4-digit year), GMonth (2-digit month), GDay (2-digit day)
::
FOR /F "TOKENS=1-3 DELIMS=/" %%A IN ('ECHO.%1') DO (
	SET GYear=%%C
	SET GMonth=%%A
	SET GDay=%%B
)
GOTO:EOF





