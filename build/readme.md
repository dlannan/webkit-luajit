# Build an app from scripts
The aim of the scripts in here are to provide a way to 
build an app from the luajit system.

The basis of this is using the srlua system which packages lua files with a modified lua
executable that can call the packaged obj code.

Extensions need to be made to package multiple lua scripts (all dependent ones) with the 
executable and thus have a complete exe solution minus the data folders.
