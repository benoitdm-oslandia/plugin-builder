git clone -b $Env:QGIS_BRANCH git@github.com:qgis/QGIS.git

mkdir QGIS/src/plugins/primitive_editing
cp CMakeLists_inside.txt QGIS/src/plugins/primitive_editing/CMakeLists.txt
cp -a src resources tests QGIS/src/plugins/primitive_editing/

cmake -S $Env:PROJ_DIR/QGIS -B $env:BUILD_DIR `
    -DCMAKE_BUILD_TYPE=Release `
    -GNinja `
    -DAGGRESSIVE_SAFE_MODE=OFF `
    -DBUILD_WITH_QT6=ON `
    -DCMAKE_CXX_FLAGS=-Wno-macro-redefined `
    -DENABLE_MODELTEST=OFF `
    -DENABLE_PGTEST=OFF `
    -DENABLE_TESTS=OFF `
    -DENABLE_UNITY_BUILDS=OFF `
    -DSUPPRESS_QT_WARNINGS=ON `
    -DWITH_3D=ON `
    -DWITH_ANALYSIS=ON `
    -DWITH_APIDOC=OFF `
    -DWITH_ASTYLE=OFF `
    -DWITH_BINDINGS=OFF `
    -DWITH_CLAZY=OFF `
    -DWITH_DESKTOP=ON `
    -DWITH_GRASS7=OFF `
    -DWITH_GRASS8=OFF `
    -DWITH_GRASS_PLUGIN=OFF `
    -DWITH_GUI=ON `
    -DWITH_HANA=OFF `
    -DWITH_OAUTH2_PLUGIN=OFF `
    -DWITH_ORACLE=OFF `
    -DWITH_PDAL=OFF `
    -DWITH_QGIS_PROCESS=OFF `
    -DWITH_QSPATIALITE=OFF `
    -DWITH_QTSERIALPORT=OFF `
    -DWITH_QTWEBKIT=OFF `
    -DWITH_QUICK=OFF `
    -DWITH_QWTPOLAR=OFF `
    -DWITH_SERVER=OFF `
    -DWITH_SERVER_LANDINGPAGE_WEBAPP=OFF `
    -DWITH_SFCGAL=ON `
    -DQT6_PATH="$qt6PathUnix"

cmake --build $env:BUILD_DIR/QGIS --config Release
