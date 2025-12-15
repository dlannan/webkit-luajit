REM Build a test executable file. 
REM Build with the srlua tool and place in this folder.

call ..\thirdparty\srlua\Release\glue.exe ..\thirdparty\srlua\Release\srlua.exe ..\project\main.lua test.exe 
