
REM --- Need to add the bin path to run the exe dependent dlls.
REM --- Must run from root, all assets are sources from root of folder.
pushd ..\
set PATH=%cd%\bin\windows\x64\;%PATH%
build\test.exe
popd