REM Don't build html docs for this since for some weird reason that fails
"%R%" CMD INSTALL --build --no-html --data-compress=none .
IF %ERRORLEVEL% NEQ 0 exit 1

mkdir "%PREFIX%\share\jupyter\kernels\ir"
IF %ERRORLEVEL% NEQ 0 exit 1

xcopy /s inst\kernelspec\* "%PREFIX%\share\jupyter\kernels\ir\"
IF %ERRORLEVEL% NEQ 0 exit 1
