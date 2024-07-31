:Json.test
call:Json.GetValueFromFile return C:\Things\J7CAL\J7CAL\Modules\.minecraft\versions\1.21\1.21.json .downloads.client.url
echo %return%
call:Json.GetValueFromText return "{"foo": 0}" .foo
echo %return%

goto :EOF

:Json.GetValueFromFile <returnString> <jsonFile> <jsonFilter>
for /f "delims=" %%i in ('jq -j "%~3" "%~2"') do set "%~1=%%i"

goto :EOF

:Json.GetValueFromText <returnString> <json> <jsonFilter>
for /f "delims=" %%i in ('echo %~2 ^| jq %3') do set "%~1=%%i"


