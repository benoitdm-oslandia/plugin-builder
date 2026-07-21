Write-Host "====== Make osgeo4w links..."
# Due to some cmake errors, the relative path is lost and resources are searched starting
# at '/'. These links helps cmake to find the needed resources
New-Item -Path C:\bin -ItemType SymbolicLink -Value $Env:OSGEO4W_ROOT\bin
New-Item -Path C:\lib -ItemType SymbolicLink -Value $Env:OSGEO4W_ROOT\lib
New-Item -Path C:\include -ItemType SymbolicLink -Value $Env:OSGEO4W_ROOT\include

Write-Host "====== Copy plugin sources to QGIS project..."
New-Item -ItemType Directory -Force -Path QGIS/src/plugins/primitive_editing
Copy-Item -Path "CMakeLists_inside.txt" -Destination "QGIS/src/plugins/primitive_editing/CMakeLists.txt" -Force
Copy-Item -Path "src" -Destination "QGIS/src/plugins/primitive_editing/" -Recurse -Force
Copy-Item -Path "resources" -Destination "QGIS/src/plugins/primitive_editing/" -Recurse -Force
Copy-Item -Path "tests" -Destination "QGIS/src/plugins/primitive_editing/" -Recurse -Force

Write-Host "====== Prepare build..."

# remove already installed python
Remove-Item -Recurse C:/hostedtoolcache/windows/Python/

# Update path to add Osgeo4W python support
$Env:path="$Env:path;$Env:OSGEO4W_ROOT\apps\Python312;$Env:OSGEO4W_ROOT\apps\Python312\Scripts;$Env:OSGEO4W_ROOT\bin;"

# Search for SetupAPI lib
$searchDir = "C:/Program Files (x86)/Windows Kits"
$fileName = "SetupAPI.lib"
Write-Host "Searching for $fileName in $searchDir..."

$file = Get-ChildItem -Path $searchDir -Filter $fileName -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like "*x64*" } | Select-Object -First 1

if ($file) {
    Write-Host "File '$fileName' found at: $file"
    $setupapidir = Split-Path $file -Parent
} else {
    Write-Error "File '$fileName' not found."
    exit 1
}

# Disabled options:
# - do no use -GNinja as cmake will use mingw64
# - remove -DCMAKE_CXX_FLAGS=-Wno-macro-redefined seems to generate errors

Write-Host "====== Running cmake -S..."
cmake -S $Env:PROJ_DIR/QGIS -B $Env:BUILD_DIR `
  -DCMAKE_BUILD_TYPE=Release `
  -DAGGRESSIVE_SAFE_MODE=OFF `
  -DENABLE_MODELTEST=OFF `
  -DENABLE_TESTS=OFF `
  -DENABLE_UNITY_BUILDS=OFF `
  -DWITH_3D=ON `
  -DWITH_ANALYSIS=ON `
  -DWITH_APIDOC=OFF `
  -DWITH_BINDINGS=ON `
  -DWITH_CLAZY=OFF `
  -DWITH_DESKTOP=ON `
  -DWITH_GRASS7=OFF `
  -DWITH_GRASS8=OFF `
  -DWITH_GUI=ON `
  -DWITH_HANA=OFF `
  -DWITH_OAUTH2_PLUGIN=OFF `
  -DWITH_ORACLE=OFF `
  -DWITH_PDAL=OFF `
  -DWITH_QGIS_PROCESS=OFF `
  -DWITH_QSPATIALITE=OFF `
  -DWITH_QTSERIALPORT=OFF `
  -DWITH_QUICK=OFF `
  -DWITH_SERVER=OFF `
  -DWITH_SERVER_LANDINGPAGE_WEBAPP=OFF `
  -DWITH_SFCGAL=ON `
  -DUSE_OPENCL=OFF `
  -DCMAKE_MODULE_PATH="$Env:OSGEO4W_ROOT/cmake" `
  -DCMAKE_PREFIX_PATH="$Env:OSGEO4W_ROOT/apps/qt6;$Env:OSGEO4W_ROOT;$setupapidir" `
  -DCMAKE_LIBRARY_PATH="$Env:OSGEO4W_ROOT/lib" `
  -DCMAKE_INCLUDE_PATH="$Env:OSGEO4W_ROOT/include" `
  -DQt6_DIR="$Env:OSGEO4W_ROOT/apps/qt6/lib/cmake/Qt6" `
  -DCUSTOM_PLUGINS=primitive_editing


Write-Host "====== Running cmake --target help..."
cmake --build $Env:BUILD_DIR --target help

Write-Host "====== Running cmake --build..."
cmake --build $Env:BUILD_DIR --config Release plugin_primitiveediting
