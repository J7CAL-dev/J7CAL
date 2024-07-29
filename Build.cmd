mkdir Output
copy /b "J7CAL\Modules\*.cmd" "Output\Modules.cmd"
copy /b "J7CAL\Main.cmd"+"Output\Modules.cmd" "Output\J7CAL.cmd"
