pushd %~dp0\..
rem mkdir x86
mkdir x64
rem mkdir arm
rem cd x86
rem "C:\Program Files\CMake\bin\cmake.exe" ..\..
rem msbuild LiteCore.sln /p:Configuration=RelWithDebInfo

rem cd ..
cd x64
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 15 2017 Win64" ..\..
msbuild LiteCore.sln /p:Configuration=RelWithDebInfo /p:Platform="x64" /t:LiteCore

rem cd ..
rem cd arm
rem "C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 14 2015 ARM" ..\..
rem msbuild LiteCore.sln /p:Configuration=RelWithDebInfo /t:LiteCore
popd