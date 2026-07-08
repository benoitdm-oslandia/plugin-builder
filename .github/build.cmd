set PATH=%PATH%;C:\ProgramData\chocolatey\bin;"C:\Program Files\CMake\bin"
echo %PATH%

dir c:\ProgramData\
dir c:\ProgramData\mingw64
dir c:\ProgramData\mingw64\mingw64
dir c:\ProgramData\mingw64\mingw64\bin

cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-Wno-macro-redefined -DCMAKE_CXX_COMPILER=c:\ProgramData\mingw64\mingw64\bin\g++ -DCMAKE_C_COMPILER=c:\ProgramData\mingw64\mingw64\bin\gcc
