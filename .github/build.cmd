set PATH=%PATH%;C:\ProgramData\chocolatey\bin
echo %PATH%
cmake -S . -B build -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-Wno-macro-redefined