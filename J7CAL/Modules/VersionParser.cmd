:VersionParser.test
set "VersionParser.GetClientJarInfo.minecraftPath=C:\Users\Hill233\AppData\Roaming\.minecraft"
set "VersionParser.GetClientJarInfo.version=1.21"
call:VersionParser.GetClientJarInfo
set VersionParser.NameToPath.minecraftPath=C:\Users\Hill233\AppData\Roaming\.minecraft
set VersionParser.NameToPath.name=ca.weblite:java-objc-bridge:1.1
call:VersionParser.NameToPath
echo %VersionParser.NameToPath.result%
set VersionParser.GetClientLibrariesInfo.minecraftPath=C:\Users\Hill233\AppData\Roaming\.minecraft
set VersionParser.GetClientLibrariesInfo.version=1.8.9
call:VersionParser.GetClientLibrariesInfo
for /l %%i in (0,1,%VersionParser.GetClientLibrariesInfo.librariesNumbers%) do (
    echo !VersionParser.GetClientLibrariesInfo.%%i.sha1!
    echo !VersionParser.GetClientLibrariesInfo.%%i.size!
    echo !VersionParser.GetClientLibrariesInfo.%%i.url!
    echo !VersionParser.GetClientLibrariesInfo.%%i.name!
    echo !VersionParser.GetClientLibrariesInfo.%%i.isNatives!
)

goto :EOF


:VersionParser.GetClientJarInfo
::获取指定版本的客户端的信息
set "VersionParser.GetClientJarInfo.jsonPath=%VersionParser.GetClientJarInfo.minecraftPath%\versions\%VersionParser.GetClientJarInfo.version%\%VersionParser.GetClientJarInfo.version%.json"
set Filter=sha1,size,url
for %%i in (%Filter%) do for /f "delims=" %%a in ('jq -j .downloads.client.%%i "%VersionParser.GetClientJarInfo.jsonPath%"') do set "VersionParser.GetClientJarInfo.%%i=%%a"

goto :EOF




:VersionParser.GetClientLibrariesInfo
::获取指定版本的类库信息
set "VersionParser.GetClientLibrariesInfo.jsonPath=%VersionParser.GetClientLibrariesInfo.minecraftPath%\versions\%VersionParser.GetClientLibrariesInfo.version%\%VersionParser.GetClientLibrariesInfo.version%.json"
set Filter=sha1,size,url
call:Helper.GetProcessorBitness
for /f "delims=" %%i in ('jq -r ".libraries|map(select(.natives? and .natives.windows))|length" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do set "VersionParser.GetClientLibrariesInfo.librariesNativesNumbers=%%i"
for /f "delims=" %%i in ('jq -r ".libraries|map(select(.natives?|not))|length" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do set "VersionParser.GetClientLibrariesInfo.librariesNumbers=%%i"
for %%i in (%Filter%) do (
    set count=0
    for /f "delims=" %%a in ('jq -r ".libraries[]|select(.natives? and .natives.windows)|.natives.windows" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do (
        set nativesSelect=%%a
        set nativesSelect=\"!nativesSelect:${arch}=%Helper.GetProcessorBitness.result%!\"
        for /f "delims=" %%b in ('jq -r ".libraries|map(select(.natives? and .natives.windows))|.[!count!].downloads.classifiers.!nativesSelect!.%%i" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do set VersionParser.GetClientLibrariesInfo.!count!.%%i=%%b
        set VersionParser.GetClientLibrariesInfo.!count!.isNatives=true
        set /a count+=1
    )
)
set count=0
for /f "delims=" %%a in ('jq -r ".libraries[]|select(.natives? and .natives.windows)|.name" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do set VersionParser.GetClientLibrariesInfo.!count!.name=%%a & set /a count+=1
for %%i in (%Filter%) do (
    for /f "delims=" %%a in ('jq -r ".libraries[]|select(.natives?|not)|.name" "%VersionParser.GetClientLibrariesInfo.jsonPath%"')do (
        set VersionParser.GetClientLibrariesInfo.!count!.name=%%a
        for /f "delims=" %%b in ('jq -r ".libraries|map(select(.natives?|not))|.[!count!].downloads.artifact.%%i" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do (
            set VersionParser.GetClientLibrariesInfo.!count!.%%i=%%b
            set VersionParser.GetClientLibrariesInfo.!count!.isNatives=false
        )
        set /a count+=1
    )
)

goto :EOF


:VersionParser.NameToPath
::将Library的Name转换成可供访问的绝对路径
for /f "tokens=1,2,3 delims=:" %%a in ("%VersionParser.NameToPath.name%") do (
    set "splited1=%%a"
    set "splited2=%%b"
    set "splited3=%%c"
)

if defined VersionParser.NameToPath.natives (
    set "VersionParser.NameToPath.result=%VersionParser.NameToPath.minecraftPath%\libraries\%splited1:.=\%\%splited2%\%splited3%\%splited2%-%splited3%-%VersionParser.NameToPath.natives%.jar"
) else (
    set "VersionParser.NameToPath.result=%VersionParser.NameToPath.minecraftPath%\libraries\%splited1:.=\%\%splited2%\%splited3%\%splited2%-%splited3%.jar"
)

goto :EOF


