:: This file uses cURL to navigate to (hard coded test servers), get a response, and email the response value via scripts 'Send-ServerBuildsEmail.ps1' 
:: and 'Send-EmailWithSendGrid.ps1'.
::
:: Example using guff data for demonstration purposes only!  
::
:: Consider contents of locally saved cookie file, get the component 'Cookie Id' for use in the cURL request. 
:: An '.SESSION' value is assigned at run time. 
::
:: Note that if executing in Windows Powershell, Google may need to be set to allow 'Less trustworthy apps'

@echo off

:: ----------------------------------------------------------------------------------------------------------------------------
:: Set variables

:: Directory of cookie files
set filepath=C:/Some/filePath

:: Windows Auth user credentials for servers
@echo off
set user=TestUser
set pass=secretSquirrels

:: Names of cookie files stored in 'ServerBuilds\cookie_files'
set cookie_test_server_1=cookie_test_server_1.txt
set cookie_test_server_2=cookie_test_server_2.txt

:: Full file path of cookie files
set "cookie_filepath_test_server_1=%filepath%%cookie_test_server_1%"
set "cookie_filepath_test_server_2=%filepath%%cookie_test_server_2%"

:: Clear previous output file
echo. > serverBuilds.txt
@echo off

:: ----------------------------------------------------------------------------------------------------------------------------
:: Get 'Cookie Id' from last line of cookie file by calling the 'getCookieFromTxtFile' function...

:: Test-server-1
call :getCookieFromTxtFile %cookie_filepath_test_server_1% 
set "cookie_id_test_server_1=%cookie_id%"
:: echo COOKIE TEST_SERVER_1 ID: %cookie_id_test_server_1%

:: Test-server-2
call :getCookieFromTxtFile %cookie_filepath_test_server_2% 
set "cookie_id_test_server_2=%cookie_id%"
:: echo COOKIE TEST_SERVER_2 ID: %cookie_id_test_server_2%

:: ----------------------------------------------------------------------------------------------------------------------------

:: Test-Server-1
echo Test-Server-1: >> serverBuilds.txt
curl -s -L -k --location-trusted >> serverBuilds.txt "https://testserver1.com/prefix/api/System/Any/EndPoint" ^
  -H "Connection: keep-alive" ^
  -H "Accept: */*" ^
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36" ^
  -H "X-Requested-With: XMLHttpRequest" ^
  -H "Sec-Fetch-Site: same-origin" ^
  -H "Sec-Fetch-Mode: cors" ^
  -H "Sec-Fetch-Dest: empty" ^
  -H "Accept-Language: en-GB,en-US;q=0.9,en;q=0.8" ^
  -H "Cookie: .COOKIE=%cookie_id_test_server_1%;" 
echo. >> serverBuilds.txt
echo. >> serverBuilds.txt 

:: The following server requires Windows Authentication (Windows user)

:: Test-Server-2
echo Test-Server-2: >> serverBuilds.txt
curl -s -L -k --location-trusted -ntlm %user%:%pass% >> serverBuilds.txt "https://testserver2.com/prefix/api/System/Any/EndPoint" ^
  -H "Connection: keep-alive" ^
  -H "Accept: */*" ^
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36" ^
  -H "X-Requested-With: XMLHttpRequest" ^
  -H "Sec-Fetch-Site: same-origin" ^
  -H "Sec-Fetch-Mode: cors" ^
  -H "Sec-Fetch-Dest: empty" ^
  -H "Accept-Language: en-GB,en-US;q=0.9,en;q=0.8" ^
  -H "Cookie: .COOKIE=%cookie_id_test_server_2%;" 
echo. >> serverBuilds.txt
echo. >> serverBuilds.txt


:: ----------------------------------------------------------------------------------------------------------------------------
:: Email text file by calling PowerShell script
:: Powershell.exe -executionpolicy remotesigned -File Send-EmailViaPowerShell.ps1

:: Email serverBuilds data using 'SendGrip' app
Powershell.exe -executionpolicy remotesigned -File Send-ServerBuildsEmail.ps1

:: ----------------------------------------------------------------------------------------------------------------------------
:: Close command line
::exit

:: ----------------------------------------------------------------------------------------------------------------------------
:: Function: Get the '.COOKIE' value from a cookie file.  Receives one parameter 'cookie_filepath_x', and returns string (the '.COOKIE' value)
:getCookieFromTxtFile
for /F "delims=" %%a in (%1) do (
   set "lastLine=%%a"
)
endlocal&set "cookie_id=%lastline:*.COOKIE	=%"
goto :eof
