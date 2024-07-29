:Download.Minecraft.List
curl -O -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
::curl -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json
echo 目前版本类型有：
for /f "delims=" %%i in ('jq -r ".versions | map(.type) | unique[]" "version_manifest_v2.json"') do echo %%i
set /p "Download.Minecraft.List.Type=你要安装什么类型的版本？"
for /f %%i in ('jq -c -r ".versions[] | select(.type==\"%Download.Minecraft.List.Type%\") | .id" "version_manifest_v2.json"') do echo %%i
set /p "Download.Minecraft.List.id=你要安装什么版本？"
for /f %%i in ('jq -c -r ".versions[] | select(.id==\"%Download.Minecraft.List.id%\")" "version_manifest_v2.json"') do set "Download.Minecraft.List.Info.JSON=%%i"
::for /f %%v in ('jq -j ".versions[].id" "version_manifest_v2.json"') do echo %%v
goto :EOF


