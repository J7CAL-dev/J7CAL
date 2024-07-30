@echo off
chcp 65001 > nul
set %1
setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS


:Start
title J7CAL
::call:Download.Minecraft.List
call:VersionParser.GetClientJarInfo C:\Users\Hill233\AppData\Roaming\.minecraft 1.21
goto :EOF


