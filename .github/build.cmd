@echo off
setlocal enabledelayedexpansion

set "PATH=%PATH%;C:\ProgramData\chocolatey\bin;C:\Program Files\CMake\bin;c:\ProgramData\mingw64\mingw64\bin"
echo PATH: %PATH%


@REM search Qt6 cmake file

set "SEARCH_DIR=c:\Qt"
set "FILE_NAME=Qt6Config.cmake"
set "QT6_PATH="

echo Searching for %FILE_NAME% in %SEARCH_DIR%...
for /f "delims=" %%i in ('dir /s /b "%SEARCH_DIR%\%FILE_NAME%" 2^>nul') do (
    set "QT6_PATH=%%~dpi"
    goto :found
)

:found
if defined QT6_PATH (
    echo Qt6 found at: %QT6_PATH%
) else (
    echo File not found.
)

@REM use " to transform path separator from / to \ in copy cmd
copy FindQGIS.cmake "%OSGEO4W_ROOT%/apps/%OSGEO4W_QGIS_SUBDIR%/"

@REM OSGEO4W_ROOT, QT6_PATH and QGIS_PATH must not use \ path separator
set "QT6_PATH=%QT6_PATH:\=/%"

cmake -S . -B build -GNinja ^
-DCMAKE_BUILD_TYPE=Release ^
-DCMAKE_CXX_FLAGS=-Wno-macro-redefined ^
-DCMAKE_CXX_COMPILER=g++.exe ^
-DCMAKE_C_COMPILER=gcc.exe ^
-DQT6_PATH="%QT6_PATH%" ^
-DQGIS_PATH="%OSGEO4W_ROOT%/apps/%OSGEO4W_QGIS_SUBDIR%"
