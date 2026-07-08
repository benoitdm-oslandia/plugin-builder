set PATH=%PATH%;C:\ProgramData\chocolatey\bin;"C:\Program Files\CMake\bin";c:\ProgramData\mingw64\mingw64\bin
echo %PATH%

cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-Wno-macro-redefined -DCMAKE_CXX_COMPILER=g++.exe -DCMAKE_C_COMPILER=gcc.exe
