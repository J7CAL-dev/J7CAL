:Authorization.Start
call:Authorization.Request
call:Authorization.Response
call:Authorization.XBL
call:Authorization.XSTS
call:Authorization.Minecraft
echo %Authorization.Minecraft.access_token%
goto :EOF

:Authorization.Request
for /f "delims=" %%i in ('curl -s -X POST -d "client_id=%client_id%&scope=XboxLive.signin offline_access" https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode') do set "Authorization.Request.JSON=%%i"

set Filter=user_code,device_code,verification_uri,expires_in,message,interval
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Request.JSON! ^| jq -c -r ".%%i"') do set "Authorization.Request.%%i=%%a"

echo | set /p="%Authorization.Request.user_code%" | clip
echo %Authorization.Request.message%

goto :EOF


:Authorization.Response
for /f "delims=" %%i in ('curl -s -X POST -d "grant_type=urn:ietf:params:oauth:grant-type:device_code&client_id=%client_id%&device_code=%Authorization.Request.device_code%" https://login.microsoftonline.com/consumers/oauth2/v2.0/token') do set "Authorization.Response.JSON=%%i"

set Filter=error,error_description
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Response.JSON! ^| jq -c -r ".%%i"') do set "Authorization.Response.%%i=%%a"
if %Authorization.Response.error%==authorization_pending timeout /t %Authorization.Request.interval% /nobreak > nul & goto Authorization.Response
if %Authorization.Response.error%==authorization_declined echo 用户拒绝了授权请求。 & set %ERRORLEVEL%=1 & goto :EOF
if %Authorization.Response.error%==expired_token echo 授权请求已经过期。 & set %ERRORLEVEL%=1 & goto :EOF
if NOT %Authorization.Response.error%==null echo %Authorization.Response.error% & echo %Authorization.Response.error_description% & set %ERRORLEVEL%=1 & goto :EOF

set Filter=access_token,refresh_token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Response.JSON! ^| jq -c -r ".%%i"') do set "Authorization.Response.%%i=%%a"

goto :EOF


:Authorization.Refresh
for /f "delims=" %%i in ('curl -s -X POST -d "client_id=%client_id%&scope=XboxLive.signin offline_access&refresh_token=%Authorization.Response.refresh_token%&grant_type=refresh_token" https://login.live.com/oauth20_token.srf') do set "Authorization.Refresh.JSON=%%i"

set Filter=access_token,refresh_token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Refresh.JSON! ^| jq -c -r ".%%i"') do set "Authorization.Response.%%i=%%a"

goto :EOF


:Authorization.XBL
for /f "delims=" %%i in ('curl -s -X POST --json "{\"Properties\":{\"AuthMethod\":\"RPS\",\"SiteName\":\"user.auth.xboxlive.com\",\"RpsTicket\":\"d^=%Authorization.Response.access_token%\"},\"RelyingParty\":\"http://auth.xboxlive.com\",\"TokenType\":\"JWT\"}" https://user.auth.xboxlive.com/user/authenticate') do set "Authorization.XBL.JSON=%%i"

set Filter=Token,DisplayClaims.xui[0].uhs
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.XBL.JSON! ^| jq -c -r ".%%i"') do set "Authorization.XBL.%%i=%%a"

goto :EOF


:Authorization.XSTS
for /f "delims=" %%i in ('curl -s -X POST --json "{\"Properties\":{\"SandboxId\":\"RETAIL\",\"UserTokens\":[\"%Authorization.XBL.Token%\"]},\"RelyingParty\":\"rp://api.minecraftservices.com/\",\"TokenType\":\"JWT\"}" https://xsts.auth.xboxlive.com/xsts/authorize') do set "Authorization.XSTS.JSON=%%i"

set Filter=Token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.XSTS.JSON! ^| jq -c -r ".%%i"') do set "Authorization.XSTS.%%i=%%a"

goto :EOF


:Authorization.Minecraft
for /f "delims=" %%i in ('curl -s -X POST --json "{\"identityToken\":\"XBL3.0 x^=%Authorization.XBL.DisplayClaims.xui[0].uhs%^;%Authorization.XSTS.Token%\"}" https://api.minecraftservices.com/authentication/login_with_xbox ^| jq -c .') do set "Authorization.Minecraft.JSON=%%i"

set Filter=access_token
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Authorization.Minecraft.JSON! ^| jq -c -r ".%%i"') do set "Authorization.Minecraft.%%i=%%a"

goto :EOF


:Authorization.Ownship
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %Authorization.Minecraft.access_token%" https://api.minecraftservices.com/entitlements/mcstore ^| jq -c .') do set "Authorization.Ownship.JSON=%%i"

goto :EOF


:Authorization.Profile
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %Authorization.Minecraft.access_token%" https://api.minecraftservices.com/minecraft/profile ^| jq -c .') do set "Authorization.Profile.JSON=%%i"

goto :EOF


