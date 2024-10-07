:Download.Minecraft.Start
call:Download.Forge.List 1.21.1
pause
::for /f %%i in ('jq -c -r ".versions[] | select(.type==\"%Download.Minecraft.Manifest.Type%\") | .id" "version_manifest_v2.json"') do echo %%i
::set /p "Download.Minecraft.Manifest.id=你要安装什么版本？"
::for /f %%i in ('jq -c -r ".versions[] | select(.id==\"%Download.Minecraft.Manifest.id%\")" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.Info.JSON=%%i"
::for /f %%v in ('jq -j ".versions[].id" "version_manifest_v2.json"') do echo %%v
::set /p "Download.Minecraft.Manifest.Type=你要安装什么类型的版本？"
goto:EOF


:Download.Minecraft.Manifest
curl -O -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
for /f "delims=" %%i in ('jq -c ".versions | map(.type) | unique" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.Type=%%i"
for /f %%i in ('echo !Download.Minecraft.Manifest.Type! ^| jq -r .[]') do for /f %%a in ('jq -c "[.versions[] | select(.type==\"%%i\") | .id]" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.%%i.id.JSON=%%a"
goto :EOF


:Download.Minecraft.Manifest.id.JSON
for /f "delims=" %%i in ('jq -c ".versions[] | select(.id==\"%~1\")" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.%~1.JSON=%%i"
goto:EOF


:Download.Minecraft.Manifest.latest
for /f "delims=" %%i in ('jq -r ".latest.release" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.latest.release=%%i"
for /f "delims=" %%i in ('jq -r ".latest.snapshot" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.latest.snapshot=%%i"
goto:EOF


:Download.OptiFine.List

goto:EOF


:Download.Forge.List
aria2c "https://files.minecraftforge.net/net/minecraftforge/forge/index_%~1.html"
findstr /r /c:"^[0-9]*\.[0-9]*\.[0-9]*" "index_%~1.html"
goto :EOF


:Download.Forge
aria2c "https://maven.minecraftforge.net/net/minecraftforge/forge/%~1/forge-%~1-installer.jar" %~2
goto :EOF


:Download.NeoForge.List

goto :EOF


:Download.Fabric.List

goto :EOF


:Download.Quilt.List

goto :EOF


:Download.LiteLoader.List

goto :EOF


:Download.Tools.curl
certutil
goto :EOF




