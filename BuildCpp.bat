:: ---------------
:: BuildCpp.bat
::
:: Builds the .cpp files generated in the out/ folder.
:: ---------------

:: Ensure everything is reset after .bat is complete
setlocal

:: Set cwd to where this .bat file is
cd /d %~dp0

:: Create these folders if they do not exist
if not exist "obj/" (mkdir obj)
if not exist "bin/" (mkdir bin)

:: Compile C++
cl.exe out/src/*.cpp /D cxx /I . /I out/include /I civetweb/include /std:c++17 /EHsc /Fo:obj/ /MDd /Fe:bin/Program.exe
link /SUBSYSTEM:CONSOLE obj/*.obj civetweb/VisualStudio/ex_embedded_c/x64/Debug/civetweb.obj 
