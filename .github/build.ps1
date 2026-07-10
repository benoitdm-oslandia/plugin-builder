# # Set environment PATH
# $extraPaths = "C:\ProgramData\chocolatey\bin", "C:\Program Files\CMake\bin"
# foreach ($path in $extraPaths) {
#     if ($env:PATH -notlike "*$path*") {
#         $env:PATH += ";$path"
#     }
# }
# Write-Host "PATH: $env:PATH"

# # Search for Qt6 cmake file
# $searchDir = "C:/OSGeo4W/apps/Qt6"
# $fileName = "Qt6Config.cmake"
# Write-Host "Searching for $fileName in $searchDir..."

# $file = Get-ChildItem -Path $searchDir -Filter $fileName -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

# if ($file) {
#     $qt6Path = $file.DirectoryName
#     Write-Host "Qt6 found at: $qt6Path"
# } else {
#     Write-Error "File not found."
#     exit 1
# }

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
