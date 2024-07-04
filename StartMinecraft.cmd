:: Powered by allMagic
:: GitHub: https://github.com/allMagicNB

::@echo off
chcp 65001
set %1
setlocal ENABLEDELAYEDEXPANSION

:Start



:Authorization.Request
for /f "delims=" %%i in ('curl -s -X POST -d "client_id=%client_id%&scope=XboxLive.signin%%20offline_access" https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode') do set "Authorization.Request.JSON=%%i"
::for /f "delims=" %%i in ('curl -s -X POST -d "client_id=%client_id%&scope=XboxLive.signin" https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode') do set Authorization.Request.JSON=%%i

set Filter=user_code,device_code,message
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Request.JSON! ^| jq -j ".%%i"') do set "%%i=%%a"

echo %user_code% | clip
echo %message%
pause
goto Authorization.Response


:Authorization.Response
for /f "delims=" %%i in ('curl -s -X POST -d "grant_type=urn:ietf:params:oauth:grant-type:device_code&client_id=%client_id%&device_code=%device_code%" https://login.microsoftonline.com/consumers/oauth2/v2.0/token') do set "Authorization.Response.JSON=%%i"

set Filter=error,error_description
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Response.JSON! ^| jq -j ".%%i"') do set "%%i=%%a"
if %error%==authorization_pending goto Authorization.Response
if NOT %error%==null echo %error_description% & goto Authorization.Request

set Filter=access_token,refresh_token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Response.JSON! ^| jq -j ".%%i"') do set "%%i=%%a"

goto Authorization.XBL


:Authorization.Refresh
for /f "delims=" %%i in ('curl -s -X POST -d "client_id=%client_id%&scope=XboxLive.signin%%20offline_access&refresh_token=%refresh_token%&grant_type=refresh_token" https://login.live.com/oauth20_token.srf') do set "Authorization.Refresh.JSON=%%i"

set Filter=access_token,refresh_token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Refresh.JSON! ^| jq -j ".%%i"') do set "%%i=%%a"

goto Authorization.XBL


:Authorization.XBL
for /f "delims=" %%i in ('curl -s -X POST --json "{\"Properties\": {\"AuthMethod\": \"RPS\", \"SiteName\": \"user.auth.xboxlive.com\", \"RpsTicket\": \"d^=%access_token%\"}, \"RelyingParty\": \"http://auth.xboxlive.com\", \"TokenType\": \"JWT\"}" https://user.auth.xboxlive.com/user/authenticate') do set "Authorization.XBL.JSON=%%i"

set Filter=Token,DisplayClaims.xui[0].uhs
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.XBL.JSON! ^| jq -j ".%%i"') do set "%%i=%%a"

goto Authorization.XSTS


:Authorization.XSTS
for /f "delims=" %%i in ('curl -s -X POST --json "{\"Properties\": {\"SandboxId\": \"RETAIL\", \"UserTokens\": [\"%Token%\"]}, \"RelyingParty\": \"rp://api.minecraftservices.com/\", \"TokenType\": \"JWT\"}" https://xsts.auth.xboxlive.com/xsts/authorize') do set "Authorization.XSTS.JSON=%%i"

set Filter=Token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.XSTS.JSON! ^| jq -j ".%%i"') do set "%%i=%%a"

pause > nul


:Authorization.Minecraft
for /f "delims=" %%i in ('curl -s -X POST --json "{\"identityToken\": \"XBL3.0 x^=%DisplayClaims.xui[0].uhs%^;%Token%\"}" https://api.minecraftservices.com/authentication/login_with_xbox ^| jq -c .') do set "Authorization.Minecraft.JSON=%%i"

set Filter=access_token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Minecraft.JSON! ^| jq -j ".%%i"') do set "%%i=%%a"

pause > nul


:Authorization.Ownship
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %access_token%" https://api.minecraftservices.com/entitlements/mcstore ^| jq -c .') do set "Authorization.Ownship.JSON=%%i"

pause > nul


:Authorization.Profile
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %access_token%" https://api.minecraftservices.com/minecraft/profile ^| jq -c .') do set "Authorization.Profile.JSON=%%i"

pause > nul
