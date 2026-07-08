set PATH=%PATH%;C:\ProgramData\chocolatey\bin;"C:\Program Files\CMake\bin";c:\ProgramData\mingw64\mingw64\bin
echo %PATH%

for /f "delims=" %%i in ('dir /s /b "c:\Qt6Config.cmake"') do (
    set "FOUND_FILE=%%i"
    goto :found
)

:found
if defined FOUND_FILE (
    echo Found %FOUND_FILE%
    set FOUND_PATH=%~dp$FOUND_FILE
    set CMAKE_MODULE_PATH=%CMAKE_MODULE_PATH%:%FOUND_PATH%
) else (
    echo File not found.
)
echo %CMAKE_MODULE_PATH%


cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-Wno-macro-redefined -DCMAKE_CXX_COMPILER=g++.exe -DCMAKE_C_COMPILER=gcc.exe
