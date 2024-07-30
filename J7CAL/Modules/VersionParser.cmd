:VersionParser.test
call:VersionParser.GetClientJarInfo C:\Things\J7CAL\J7CAL\Modules\.minecraft 1.21

goto :EOF

:VersionParser.GetClientJarInfo <versionPath> <version>
@echo off
set "versionPath=%1"
set "version=%2"
set "VersionParser.GetClientJarInfo.clientJsonPath=%versionPath%\versions\%version%\%version%.json"
::for /f "delims=" %%i in ('jq -j ".downloads.client.sha1" "%VersionParser.GetClientJarInfo.clientJsonPath%"') do set "VersionParser.GetClientJarInfo.clientSha1=%%i"
::for /f "delims=" %%i in ('jq -j ".downloads.client.size" "%VersionParser.GetClientJarInfo.clientJsonPath%"') do set "VersionParser.GetClientJarInfo.clientSize=%%i"
::for /f "delims=" %%i in ('jq -j ".downloads.client.url" "%VersionParser.GetClientJarInfo.clientJsonPath%"') do set "VersionParser.GetClientJarInfo.clientUrl=%%i"
call:Json.GetValueFromFile VersionParser.GetClientJarInfo.clientSha1 VersionParser.GetClientJarInfo.clientJsonPath ".downloads.client.sha1"
call:Json.GetValueFromFile VersionParser.GetClientJarInfo.clientSize VersionParser.GetClientJarInfo.clientJsonPath ".downloads.client.size"
call:Json.GetValueFromFile VersionParser.GetClientJarInfo.clientUrl VersionParser.GetClientJarInfo.clientJsonPath ".downloads.client.url"
echo %VersionParser.GetClientJarInfo.clientSha1%

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


