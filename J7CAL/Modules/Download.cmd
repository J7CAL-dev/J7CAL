:Download.Minecraft.Start
call:Download.Minecraft.List
pause
::for /f %%i in ('jq -c -r ".versions[] | select(.type==\"%Download.Minecraft.List.Type%\") | .id" "version_manifest_v2.json"') do echo %%i
::set /p "Download.Minecraft.List.id=你要安装什么版本？"
::for /f %%i in ('jq -c -r ".versions[] | select(.id==\"%Download.Minecraft.List.id%\")" "version_manifest_v2.json"') do set "Download.Minecraft.List.Info.JSON=%%i"
::for /f %%v in ('jq -j ".versions[].id" "version_manifest_v2.json"') do echo %%v
::set /p "Download.Minecraft.List.Type=你要安装什么类型的版本？"


:Download.Minecraft.List
curl -O -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
for /f "delims=" %%i in ('jq -c ".versions | map(.type) | unique" "version_manifest_v2.json"') do set "Download.Minecraft.List.Type=%%i"
for /f %%i in ('echo !Download.Minecraft.List.Type! ^| jq -r .[]') do for /f %%a in ('jq -c "[.versions[] | select(.type==\"%%i\") | .id]" "version_manifest_v2.json"') do set "Download.Minecraft.List.%%i.id.JSON=%%a"
goto :EOF


