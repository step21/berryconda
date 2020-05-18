copy %RECIPE_DIR%\\CMakeLists.txt %SRC_DIR%\\CMakeLists.txt
mkdir build
cd build

REM https://github.com/conda/conda-build/issues/2850
set "CXXFLAGS=%CXXFLAGS:-GL=%"
set "CFLAGS=%CFLAGS:-GL=%"

cmake -G "NMake Makefiles" ^
	  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
	  -DCMAKE_BUILD_TYPE=Release ^
	  ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 13
