mkdir "J7CAL\Debug"
copy /b "J7CAL\Modules\*.cmd" "J7CAL\Debug\Modules.cmd"
copy /b "J7CAL\Main.cmd"+"J7CAL\Debug\Modules.cmd" "J7CAL\Debug\J7CAL.cmd"
