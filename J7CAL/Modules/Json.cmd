:Json.test
set "Json.GetValueFromFile.jsonFile=C:\Users\Hill233\AppData\Roaming\.minecraft\versions\1.21\1.21.json"
set Json.GetValueFromFile.jsonFilter=.downloads.client.url
call :Json.GetValueFromFile
echo %Json.GetValueFromFile.result%
set "Json.GetValueFromText.json={"foo": 0}"
set Json.GetValueFromFile.jsonFilter=.foo
call :Json.GetValueFromText
echo %Json.GetValueFromFile.result%

goto :EOF

:Json.GetValueFromFile
for /f "delims=" %%i in ('jq -j "%Json.GetValueFromFile.jsonFilter%" "%Json.GetValueFromFile.jsonFile%"') do set "Json.GetValueFromFile.result=%%i"

goto :EOF

:Json.GetValueFromText
for /f "delims=" %%i in ('echo !Json.GetValueFromFile.json! ^| jq %Json.GetValueFromFile.jsonFilter%') do set "Json.GetValueFromFile.return=%%i"

goto :EOF


