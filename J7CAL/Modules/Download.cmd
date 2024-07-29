:Download.Minecraft.List
curl -O -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
::curl -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json
for /f %%i in ('jq -j ".versions | map(.type) | unique[]"') do set type=
set TypeFilter=release,snapshot,old_beta,old_alpha
for /f %%i in ('jq -j ".versions[] | select(.type==\"release\")" "version_manifest_v2.json"') do set "Download.List.Release=%%i"
for /f %%v in ('jq -j ".versions[].id" "version_manifest_v2.json"') do echo %%v
goto :EOF


