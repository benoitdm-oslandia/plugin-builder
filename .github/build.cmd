@echo off
setlocal enabledelayedexpansion

set "PATH=%PATH%;C:\ProgramData\chocolatey\bin;C:\Program Files\CMake\bin;c:\ProgramData\mingw64\mingw64\bin"
echo PATH: %PATH%

set "SEARCH_DIR=c:\Qt"
set "FILE_NAME=Qt6Config.cmake"
set "FOUND_FILE="

echo Searching for %FILE_NAME% in %SEARCH_DIR%...
for /f "delims=" %%i in ('dir /s /b "%SEARCH_DIR%\%FILE_NAME%" 2^>nul') do (
    set "FOUND_FILE=%%~dpi"
    goto :found
)

:found
if defined FOUND_FILE (
    echo Found at: !FOUND_FILE!
    set "CMAKE_MODULE_PATH=!CMAKE_MODULE_PATH!;!FOUND_FILE!"
) else (
    echo File not found.
)

set "CMAKE_MODULE_PATH=!CMAKE_MODULE_PATH!;c:\osgeo4w\apps\qgis-ltr-dev"
echo CMAKE_MODULE_PATH: %CMAKE_MODULE_PATH%

cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-Wno-macro-redefined -DCMAKE_CXX_COMPILER=g++.exe -DCMAKE_C_COMPILER=gcc.exe
