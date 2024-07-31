:VersionParser.test
call:VersionParser.GetClientJarInfo C:\Users\Hill233\AppData\Roaming\.minecraft 1.21

goto :EOF

:VersionParser.GetClientJarInfo <versionPath> <version>
set "VersionParser.GetClientJarInfo.jsonPath=%~1\versions\%~2\%~2.json"
::for /f "delims=" %%i in ('jq -j ".downloads.client.sha1" "%VersionParser.GetClientJarInfo.jsonPath%"') do set "VersionParser.GetClientJarInfo.sha1=%%i"
::for /f "delims=" %%i in ('jq -j ".downloads.client.size" "%VersionParser.GetClientJarInfo.jsonPath%"') do set "VersionParser.GetClientJarInfo.size=%%i"
::for /f "delims=" %%i in ('jq -j ".downloads.client.url" "%VersionParser.GetClientJarInfo.jsonPath%"') do set "VersionParser.GetClientJarInfo.url=%%i"
::call:Json.GetValueFromFile VersionParser.GetClientJarInfo.sha1 VersionParser.GetClientJarInfo.jsonPath ".downloads.client.sha1"
::call:Json.GetValueFromFile VersionParser.GetClientJarInfo.size VersionParser.GetClientJarInfo.jsonPath ".downloads.client.size"
::call:Json.GetValueFromFile VersionParser.GetClientJarInfo.url VersionParser.GetClientJarInfo.jsonPath ".downloads.client.url"
set Filter=sha1,size,url
for /f "delims=" %%i in (%Filter%) do (call:Json.GetValueFromText VersionParser.GetClientJarInfo.%%i VersionParser.GetClientJarInfo.jsonPath)

echo %VersionParser.GetClientJarInfo.sha1%

goto :EOF

:VersionParser.GetClientLibrariesInfo

goto :EOF

:VersionParser.NameToPath <returnPath> <name> <mcFloder>
for /f "tokens=1,2,3 delims=:" %%a in ("%~2") do (
    set "splited1=%%a"
    set "splited2=%%b"
    set "splited3=%%c"
)
set "splited4=%splited1%"
set "splited4=%splited4:.=\%"
set "resultPath=%~3\libraries\%splited4%\%splited2%\%splited3%\%splited2%-%splited3%.jar"
set "%~1=%resultPath%"

goto :EOF


