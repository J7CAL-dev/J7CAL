:Helper.test
set "Helper.GetFileSha1.file=C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
call:Helper.GetFileSha1
echo %Helper.GetFileSha1.result%
set "Helper.GetFileSize.file=C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
call:Helper.GetFileSize
echo %Helper.GetFileSize.result%
set Helper.CheckFile.size=514560
set Helper.CheckFile.sha1=bbb690cb11f50da2351765b3ec516543046e85a2
set "Helper.CheckFile.file=C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
call:Helper.CheckFile
echo %Helper.CheckFile.result%
set "Helper.GetPathFromFullPath.file=C:\Users\Hill233\Downloads\图吧工具箱202407\图吧工具箱2024.exe"
call:Helper.GetPathFromFullPath
echo %Helper.GetPathFromFullPath.result%
goto:EOF

:Helper.GetFileSha1
::获取文件的SHA1值
for /f "eol=C skip=1" %%i in ('certutil -hashfile %Helper.GetFileSha1.file% SHA1') do set "Helper.GetFileSha1.result=%%i"

goto :EOF

:Helper.GetFileSize
::获取文件的大小
for %%i in (%Helper.GetFileSize.file%) do set "Helper.GetFileSize.result=%%~zi"

goto :EOF

:Helper.CheckFile
::从文件是否存在和大小和SHA1值同时检查一个文件是否正常 成功返回true 失败返回false
set Helper.CheckFile.result=false
if not exist %Helper.CheckFile.file% goto :EOF
set Helper.GetFileSize.file=%Helper.CheckFile.file%
set Helper.GetFileSha1.file=%Helper.CheckFile.file%
call:Helper.GetFileSize
call:Helper.GetFileSha1
if %Helper.CheckFile.size%==%Helper.GetFileSize.result% (if %Helper.CheckFile.sha1%==%Helper.GetFileSha1.result% set Helper.CheckFile.result=true)

goto :EOF

:Helper.CheckPath
::检查文件路径/目录路径的后面是否有反斜杠，如果有就删除
if "%Helper.CheckPath.path:~-1%"=="\" set "Helper.CheckPath.result=%Helper.CheckPath.path:~,-1%"

goto :EOF

:Helper.GetPathFromFullPath
::从文件的绝对路径返回文件所处的目录路径
for %%i in (%Helper.GetPathFromFullPath.file%) do set "Helper.GetPathFromFullPath.result=%%~dpi"
set Helper.CheckPath.path=%Helper.GetPathFromFullPath.result%
call:Helper.CheckPath
set Helper.GetPathFromFullPath.result=%Helper.CheckPath.result%

goto :EOF


