@echo ON
setlocal enabledelayedexpansion

make install PREFIX=%LIBRARY_PREFIX% LCOV_PERL_PATH=
cp %RECIPE_DIR%\lcov.bat %LIBRARY_BIN%
