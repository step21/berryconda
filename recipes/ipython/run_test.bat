REM recursion because generally failing, the rest for 3.8
set NOSE_EXCLUDE="recursion|home_dir_3|home_dir_5|store_restore"
iptest -- -vx -I "storemagic"
