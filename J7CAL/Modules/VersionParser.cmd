:VersionParser.test
set "VersionParser.GetClientJarInfo.versionPath=C:\Users\Hill233\AppData\Roaming\.minecraft"
set "VersionParser.GetClientJarInfo.version=1.21"
call:VersionParser.GetClientJarInfo C:\Users\Hill233\AppData\Roaming\.minecraft 1.21

goto :EOF

:VersionParser.GetClientJarInfo
set "VersionParser.GetClientJarInfo.jsonPath=%VersionParser.GetClientJarInfo.versionPath%\versions\%VersionParser.GetClientJarInfo.version%\%VersionParser.GetClientJarInfo.version%.json"
set Filter=sha1,size,url
for %%i in (%Filter%) do for /f "delims=" %%a in ('jq -j ".downloads.client.%%i" "%VersionParser.GetClientJarInfo.jsonPath%"') do set "VersionParser.GetClientJarInfo.%%i=%%a"
echo %VersionParser.GetClientJarInfo.sha1%

goto :EOF

:VersionParser.GetClientLibrariesInfo

goto :EOF

:VersionParser.NameToPath
for /f "tokens=1,2,3 delims=:" %%a in ("%VersionParser.NameToPath.name%") do (
    set "splited1=%%a"
    set "splited2=%%b"
    set "splited3=%%c"
)
set "splited4=%splited1%"
set "splited4=%splited4:.=\%"
set "VersionParser.NameToPath.result=%~3\libraries\%splited4%\%splited2%\%splited3%\%splited2%-%splited3%.jar"

goto :EOF


