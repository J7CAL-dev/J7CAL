:Helper.test
@echo off
chcp 65001
call:Helper.GetFileSha1 return "C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
echo %return%
call:Helper.GetFileSize return "C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
echo %return%

goto :EOF

:Helper.GetFileSha1 <returnSha1> <filePath>
for /f "eol=C skip=1" %%i in ('certutil -hashfile %2% SHA1') do (
    set "%1=%%i"
)

goto :EOF

:Helper.GetFileSize <returnSize> <filePath>
for %%i in (%2) do set %1=%%~zi

goto :EOF


