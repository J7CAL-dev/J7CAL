:Helper.test
set "Helper.GetFileSha1.file=C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
call:Helper.GetFileSha1
echo %Helper.GetFileSha1.return%
set "Helper.GetFileSize.file=C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
call:Helper.GetFileSize
echo %Helper.GetFileSize.return%

goto :EOF

:Helper.GetFileSha1
for /f "eol=C skip=1" %%i in ('certutil -hashfile %Helper.GetFileSha1.file% SHA1') do (
    set "Helper.GetFileSha1.return=%%i"
)

goto :EOF

:Helper.GetFileSize
for %%i in (%Helper.GetFileSize.file%) do set "Helper.GetFileSize.return=%%~zi"

goto :EOF


