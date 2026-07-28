$ErrorActionPreference = "Stop"
$currentPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$Env:PROJ_DIR = "./plugin"
$env:PROJ_BRANCH = "feat/build3"

$env:OSGEO4W_ROOT = "C:/OSGeo4W"
$env:Qt6_DIR = "C:/OSGeo4W/apps/Qt6"

$env:qgis_dir = "./QGIS"
$env:qgis_version = "4.2.0-1"
$env:qgis_branch = "release-4_2"
$env:qgis_release = "rel"

$Env:BUILD_DIR = "./build"

Write-Host "====== Cloning plugin $env:PROJ_BRANCH..."
if (-not (Test-Path -Path $Env:PROJ_DIR)) {
  git clone https://github.com/benoitdm-oslandia/plugin-builder.git $Env:PROJ_DIR
}
git -C $Env:PROJ_DIR checkout $env:PROJ_BRANCH
git -C $Env:PROJ_DIR reset --hard $env:PROJ_BRANCH

Write-Host "====== Cloning QGIS $env:qgis_branch ..."
if (-not (Test-Path -Path $env:qgis_dir)) {
  git clone https://github.com/qgis/qgis.git $env:qgis_dir
}
git -C $env:qgis_dir checkout $env:qgis_branch
git -C $env:qgis_dir reset --hard $env:qgis_branch

if ((Get-Command "choco.exe" -ErrorAction SilentlyContinue) -eq $null) {
  Write-Host "====== Installing choco ..."
  Invoke-WebRequest -Uri https://community.chocolatey.org/install.ps1 -OutFile $currentPath/install_choco.ps1
  & (Join-Path $currentPath install_choco.ps1)
}
Write-Host "====== Installing Bison with choco ..."
choco install -y winflexbison3 ninja

New-Item -ItemType Directory -Force -Path "$env:OSGEO4W_ROOT" | Out-Null

# $exe = 'osgeo4w-setup.exe'
# $url = 'https://download.osgeo.org/osgeo4w/v2/' + $exe
# $qtVersion = '6'
# $qtPackages = "python3,python3-pyqt6-sip,qt6-devel,qt6-libs,qt6-tools,opencl-devel,zstd-devel,qgis-${env:qgis_release}-dev-deps,proj-devel,gdal-devel,sqlite3-devel"

# if (-not (Test-Path -Path $currentPath/$exe)) {
# Write-Host "====== Retrieving osgeo4w..."
# Invoke-WebRequest -Uri $url -OutFile $currentPath/$exe
# }

# Write-Host "====== Install osgeo4w..."
# Start-Process (Join-Path $currentPath $exe) -ArgumentList @(
# '--advanced',
# '--autoaccept',
# '--quiet-mode',
# '--only-site',
# '-R', $env:OSGEO4W_ROOT,
# '-s', 'https://download.osgeo.org/osgeo4w/v2/',
# '-P', $qtPackages
# ) -Wait -NoNewWindow

Write-Host "====== Run build..."
& (Join-Path $currentPath build_inside.ps1)
