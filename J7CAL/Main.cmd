::@echo off
chcp 65001 > nul
set %1
setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS


:Start
title J7CAL
::call:Download.Minecraft.Start
set "VersionParser.GetClientJarInfo.versionPath=C:\Users\Hill233\AppData\Roaming\.minecraft"
set "VersionParser.GetClientJarInfo.version=1.21"
call :VersionParser.GetClientJarInfo
echo %VersionParser.GetClientJarInfo.sha1%,%VersionParser.GetClientJarInfo.size%,%VersionParser.GetClientJarInfo.url%
goto :EOF


