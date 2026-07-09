cmake_minimum_required(VERSION 3.16)
project(plugin_primitiveediting LANGUAGES CXX)

set (QT6_PATH "" CACHE STRING "Qt6 path")
set (QGIS_PATH "" CACHE STRING "QGIS path")

if(NOT QT6_PATH STREQUAL "")
  list(APPEND CMAKE_MODULE_PATH "${QT6_PATH}")
endif()

if(NOT QGIS_PATH STREQUAL "")
  list(APPEND CMAKE_MODULE_PATH "${QGIS_PATH}")
endif()

MESSAGE(STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")

# Modern CMake for Qt
# CMAKE_AUTOUIC: automatically runs uic on .ui files
# CMAKE_AUTORCC: automatically runs rcc on .qrc files
# CMAKE_AUTOMOC: automatically runs moc on files containing Q_OBJECT
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

# Find Qt6 Dependencies
find_package(Qt6 COMPONENTS Core Gui Widgets 3DCore 3DRender 3DInput 3DLogic 3DExtras REQUIRED)

# Find QGIS Dependencies
# The most idiomatic way is find_package(QGIS), which looks for QGISConfig.cmake.
find_package(QGIS REQUIRED)

# Source files
set(SRCS
  src/primitive_editing_plugin.cpp
  src/qgs3dcreateprimitivedialog.cpp
  src/qgs3dcreateprimitiveboxdialog.cpp
  src/qgs3dcreateprimitiveconedialog.cpp
  src/qgs3dcreateprimitivecylinderdialog.cpp
  src/qgs3dcreateprimitivespheredialog.cpp
  src/qgs3dcreateprimitivetorusdialog.cpp
  src/qgs3dmaptoolcreateprimitive.cpp
  src/qgs3dprimitiveeditingtoolbar.cpp
)

# UI files
set(UIS
  src/createprimitivedialog.ui
)

# Resource files
set(RCCS
  resources/images.qrc
)

# Create the plugin library as a MODULE
# With AUTOUIC and AUTORCC enabled, we list .ui and .qrc files directly in the source list.
add_library(plugin_primitiveediting MODULE
  ${SRCS}
  ${UIS}
  ${RCCS}
)

# Set include directories
target_include_directories(plugin_primitiveediting PRIVATE
  ${CMAKE_SOURCE_DIR}/src/plugins
)

# Link libraries
# We use the targets provided by find_package for Qt.
# For QGIS, we link against the core library names as per the original CMakeLists.txt.
target_link_libraries(plugin_primitiveediting PRIVATE
  Qt6::Core
  Qt6::Gui
  Qt6::Widgets
  Qt6::3DCore
  Qt6::3DRender
  Qt6::3DExtras
  qgis_core
  qgis_gui
  qgis_3d
  qgis_app
)

# Installation configuration
# QGIS_PLUGIN_DIR can be passed via -DQGIS_PLUGIN_DIR=/path/to/plugins
set(QGIS_PLUGIN_DIR "${QGIS_PLUGIN_DIR}" CACHE PATH "Installation directory for the QGIS plugin")

install(TARGETS plugin_primitiveediting
  LIBRARY DESTINATION ${QGIS_PLUGIN_DIR}
)
