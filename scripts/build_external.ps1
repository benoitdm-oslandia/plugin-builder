# Use " to transform path separator from / to \ in copy cmd
$targetDir = Join-Path $env:OSGEO4W_ROOT "apps\$env:OSGEO4W_QGIS_SUBDIR"
Copy-Item -Path "FindQGIS.cmake" -Destination $targetDir

# OSGEO4W_ROOT, QT6_PATH and QGIS_PATH must not use \ path separator
$qt6PathUnix = $env:QT6_DIR.Replace('\', '/')
$qgisPathUnix = ($env:OSGEO4W_ROOT + "/apps/" + $env:OSGEO4W_QGIS_SUBDIR).Replace('\', '/')

cmake -S $Env:PROJ_DIR -B $env:BUILD_DIR `
    -DCMAKE_BUILD_TYPE=Release `
    -DQT6_PATH="$qt6PathUnix" `
    -DQGIS_PATH="$qgisPathUnix"

cmake --build $env:BUILD_DIR --config Release
