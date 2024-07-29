@echo off
chcp 65001 > nul
set %1
setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS


:Start
title J7CAL
goto Download.Minecraft.List
goto :EOF


