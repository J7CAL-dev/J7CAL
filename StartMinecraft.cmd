:: Powered by allMagic
:: GitHub: https://github.com/allMagicNB

::@echo off
chcp 65001
set %1


:Authorization.Request
curl -s -X POST -d "client_id=%client_id%&scope=XboxLive.signin%%20offline_access" https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode > json
::curl -s -X POST -d "client_id=%client_id%&scope=XboxLive.signin" https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode > json
for /f "delims=" %%i in (json) do set json=%%i
echo %json%
del json

set Filter=message,device_code
for %%i in (%Filter%) do echo %json% | jq ".%%i" -r > %%i & for /f "delims=" %%a in (%%i) do set %%i=%%a & del %%i
::for %%i in (%Filter%) do for /f %%a in ('echo "%json%" ^| jq -j ".%%i"') do set "%%i=%%a"&&set
pause
set
echo !device_code! | clip
echo %message%
pause
goto Authorization.Response


:Authorization.Response
curl -s -X POST -d "grant_type=urn:ietf:params:oauth:grant-type:device_code&client_id=%client_id%&device_code=%device_code%" https://login.microsoftonline.com/consumers/oauth2/v2.0/token > json
for /f "delims=" %%i in (json) do set json=%%i
del json

set Filter=error,error_description
for %%i in (%Filter%) do echo %json% | jq ".%%i" -r > %%i & for /f "delims=" %%a in (%%i) do set %%i=%%a & del %%i
if %error%==authorization_pending goto Authorization.Response
if NOT %error%==null echo %error_description% & goto Authorization.Request

set Filter=access_token,refresh_token
for %%i in (%Filter%) do echo %json% | jq ".%%i" -r > %%i & for /f "delims=" %%a in (%%i) do set %%i=%%a & del %%i

goto Authorization.XBL


:Authorization.XBL
curl -s -X POST --json "{\"Properties\": {\"AuthMethod\": \"RPS\", \"SiteName\": \"user.auth.xboxlive.com\", \"RpsTicket\": \"d=%access_token%\"}, \"RelyingParty\": \"http://auth.xboxlive.com\", \"TokenType\": \"JWT\"}" https://user.auth.xboxlive.com/user/authenticate > json
for /f "delims=" %%i in (json) do set json=%%i
del json

set Filter=Token
for %%i in (%Filter%) do echo %json% | jq ".%%i" -r > %%i & for /f "delims=" %%a in (%%i) do set %%i=%%a & del %%i
echo %json% | jq ".DisplayClaims.xui[0].uhs" -r > uhs & for /f "delims=" %%i in (uhs) do set uhs=%%i & del uhs
for /f %%i in ('echo %uhs:~0,-1%') do set uhs=%%i

goto Authorization.XSTS


:Authorization.XSTS
curl -s -X POST --json "{\"Properties\": {\"SandboxId\": \"RETAIL\", \"UserTokens\": [\"%Token%\"]}, \"RelyingParty\": \"rp://api.minecraftservices.com/\", \"TokenType\": \"JWT\"}" https://xsts.auth.xboxlive.com/xsts/authorize > json
for /f "delims=" %%i in (json) do set json=%%i
del json

set Filter=Token
for %%i in (%Filter%) do echo %json% | jq ".%%i" -r > %%i & for /f "delims=" %%a in (%%i) do set %%i=%%a & del %%i

pause > nul


:Authorization.Minecraft
curl -s -X POST --json "{\"identityToken\": \"XBL3.0 x=%uhs%;%Token%\"}" https://api.minecraftservices.com/authentication/login_with_xbox > json
for /f "delims=" %%i in (json) do set json=%%i
del json

set Filter=access_token
for %%i in (%Filter%) do echo %json% | jq ".%%i" -r > %%i & for /f "delims=" %%a in (%%i) do set %%i=%%a & del %%i

pause > nul


:Authorization.GetOwnship
curl -s -X GET -H "Authorization: Bearer %access_token%" https://api.minecraftservices.com/entitlements/mcstore > json
for /f "delims=" %%i in (json) do set json=%%i
del json

pause > nul


:Authorization.GetProfile
curl -s -X GET -H "Authorization: Bearer %access_token%" https://api.minecraftservices.com/minecraft/profile > json
for /f "delims=" %%i in (json) do set json=%%i
del json

pause > nul
