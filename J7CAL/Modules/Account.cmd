:Account

goto:EOF


::Mojang API
:Account.Mojang_API.NameToID
for /f "delims=" %%i in ('curl -s -X GET "https://api.mojang.com/users/profiles/minecraft/%~1" ^| jq -c .') do set "Account.Mojang_API.NameToID.JSON=%%i"
set Filter=id,name,errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.NameToID.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.NameToID.%%i=%%a"
goto:EOF


::TODO：怎么用，怎么返回
:Account.Mojang_API.IDToName
for /f "delims=" %%i in ('curl -s -X POST --json "%~1" "https://api.minecraftservices.com/minecraft/profile/lookup/bulk/byname" ^| jq -c .') do set "Account.Mojang_API.IDToName.JSON=%%i"
goto:EOF


:Account.Mojang_API.IDToProfile
for /f "delims=" %%i in ('curl -s -X GET "https://sessionserver.mojang.com/session/minecraft/profile/%~1" ^| jq -c .') do set "Account.Mojang_API.IDToProfile.JSON=%%i"
set Filter=id,name,properties[0].name,properties[0].value,profileActions,errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.IDToProfile.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.IDToProfile.%%i=%%a"
goto:EOF


:Account.Mojang_API.GetProfile
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/minecraft/profile" ^| jq -c .') do set "Account.Mojang_API.GetProfile.JSON=%%i"
set Filter=id,name,skins,capes,profileActions
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.GetProfile.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.GetProfile.%%i=%%a"
goto:EOF


:Account.Mojang_API.GetPlayerAttribute
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/player/attributes" ^| jq -c .') do set "Account.Mojang_API.GetPlayerAttribute.JSON=%%i"
set Filter=privileges,profanityFilterPreferences,banStatus
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.GetPlayerAttribute.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.GetPlayerAttribute.%%i=%%a"
goto:EOF


:Account.Mojang_API.GetBlocklist
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/privacy/blocklist" ^| jq -c .') do set "Account.Mojang_API.GetBlocklist.JSON=%%i"
set Filter=blockedProfiles
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.GetBlocklist.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.GetBlocklist.%%i=%%a"
goto:EOF


:Account.Mojang_API.GetPlayerCertificate
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/player/certificates" ^| jq -c .') do set "Account.Mojang_API.GetPlayerCertificate.JSON=%%i"
set Filter=keyPair,publicKeySignature,publicKeySignatureV2,expiresAt,refreshedAfter
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.GetPlayerCertificate.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.GetPlayerCertificate.%%i=%%a"
goto:EOF


:Account.Mojang_API.GetNamechange
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/minecraft/profile/namechange" ^| jq -c .') do set "Account.Mojang_API.GetNamechange.JSON=%%i"
set Filter=keyPair,publicKeySignature,publicKeySignatureV2,expiresAt,refreshedAfter
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.GetNamechange.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.GetNamechange.%%i=%%a"
goto:EOF


::Not Useful?
:Account.Mojang_API.CheckProductVoucher
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/productvoucher/giftcode" ^| jq -c .') do set "Account.Mojang_API.CheckProductVoucher.JSON=%%i"
goto:EOF


:Account.Mojang_API.CheckNameAvailable
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/minecraft/profile/name/%~2/available" ^| jq -c .') do set "Account.Mojang_API.CheckNameAvailable.JSON=%%i"
set Filter=status
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.CheckNameAvailable.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.CheckNameAvailable.%%i=%%a"
goto:EOF


:Account.Mojang_API.ChangeName
for /f "delims=" %%i in ('curl -s -X PUT -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/minecraft/profile/name/%~2" ^| jq -c .') do set "Account.Mojang_API.ChangeName.JSON=%%i"
set Filter=errorType,error,details.status,errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.ChangeName.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.ChangeName.%%i=%%a"
goto:EOF


:Account.Mojang_API.ChangeSkin
for /f "delims=" %%i in ('curl -s -X POST -H "Authorization: Bearer %~1" --json "{\"variant\":\"%~2\",\"url\":\"%~3\"}" "https://api.minecraftservices.com/minecraft/profile/skins" ^| jq -c .') do set "Account.Mojang_API.ChangeSkin.JSON=%%i"
set Filter=errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.ChangeSkin.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.ChangeSkin.%%i=%%a"
goto:EOF


:Account.Mojang_API.UploadSkin
for /f "delims=" %%i in ('curl -s -X POST -H "Authorization: Bearer %~1" -F "variant=%~2" -F "file=@%~3;type=image/png" "https://api.minecraftservices.com/minecraft/profile/skins" ^| jq -c .') do set "Account.Mojang_API.UploadSkin.JSON=%%i"
set Filter=errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.UploadSkin.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.UploadSkin.%%i=%%a"
goto:EOF


:Account.Mojang_API.ResetSkin
for /f "delims=" %%i in ('curl -s -X DELETE -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/minecraft/profile/skins/active" ^| jq -c .') do set "Account.Mojang_API.ResetSkin.JSON=%%i"
set Filter=errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.ResetSkin.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.ResetSkin.%%i=%%a"
goto:EOF


:Account.Mojang_API.ResetCape
for /f "delims=" %%i in ('curl -s -X DELETE -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/minecraft/profile/capes/active" ^| jq -c .') do set "Account.Mojang_API.ResetCape.JSON=%%i"
set Filter=errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.ResetCape.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.ResetCape.%%i=%%a"
goto:EOF


:Account.Mojang_API.ChangeCape
for /f "delims=" %%i in ('curl -s -X PUT -H "Authorization: Bearer %~1" --json "{\"capeId\":\"%~2\"}" "https://api.minecraftservices.com/minecraft/profile/capes/active" ^| jq -c .') do set "Account.Mojang_API.ChangeCape.JSON=%%i"
set Filter=errorMessage
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.ChangeCape.JSON! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.ChangeCape.%%i=%%a"
goto:EOF


:Account.Mojang_API.GetMigration
for /f "delims=" %%i in ('curl -s -X GET -H "Authorization: Bearer %~1" "https://api.minecraftservices.com/rollout/v1/msamigration" ^| jq -c .') do set "Account.Mojang_API.ChangeCape.JSON=%%i"
set Filter=feature,rollout
for %%i in (%Filter%) do for /f "delims=" %%a in ('echo !Account.Mojang_API.GetMigration! ^| jq -c -r ".%%i"') do set "Account.Mojang_API.ChangeCape.%%i=%%a"
goto:EOF




