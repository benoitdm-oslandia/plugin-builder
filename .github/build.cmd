@echo off
setlocal enabledelayedexpansion

set "PATH=%PATH%;C:\ProgramData\chocolatey\bin;C:\Program Files\CMake\bin;c:\ProgramData\mingw64\mingw64\bin"
echo PATH: %PATH%

@REM set "SEARCH_DIR=c:\Qt"
@REM set "FILE_NAME=Qt6Config.cmake"
@REM set "QT6_PATH="

@REM echo Searching for %FILE_NAME% in %SEARCH_DIR%...
@REM for /f "delims=" %%i in ('dir /s /b "%SEARCH_DIR%\%FILE_NAME%" 2^>nul') do (
@REM     set "QT6_PATH=%%~dpi"
@REM     set "QT6_PATH=%QT6_PATH:\=/%"
@REM     goto :found
@REM )

@REM :found
@REM if defined QT6_PATH (
@REM     echo Qt6 found at: %QT6_PATH%
@REM ) else (
@REM     echo File not found.
@REM )

copy FindQGIS.cmake %OSGEO4W_ROOT%/apps/%OSGEO4W_QGIS_SUBDIR%

cmake -S . -B build -GNinja ^
-DCMAKE_BUILD_TYPE=Release ^
-DCMAKE_CXX_FLAGS=-Wno-macro-redefined ^
-DCMAKE_CXX_COMPILER=g++.exe ^
-DCMAKE_C_COMPILER=gcc.exe ^
-DQT6_PATH="C:/Qt/6.4.2/mingw_64/lib/cmake/Qt6" ^
-DQGIS_PATH="%OSGEO4W_ROOT%/apps/%OSGEO4W_QGIS_SUBDIR%"
