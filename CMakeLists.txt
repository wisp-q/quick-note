cmake_minimum_required(VERSION 3.16)
project(QuickNotePlugin VERSION 2.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)

qt_add_qml_module(
    quicknote
    URI My.QuickNote
    VERSION 1.0
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/My/QuickNote
    SOURCES src/quicknote.h src/quicknote.cpp
)

target_link_libraries(quicknote PRIVATE Qt6::Core Qt6::Qml Qt6::Quick)
target_include_directories(quicknote PRIVATE src)

set_target_properties(quicknote PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/My/QuickNote"
    BUILD_RPATH "$ORIGIN"
    INSTALL_RPATH "$ORIGIN"
)

set_target_properties(quicknoteplugin PROPERTIES
    BUILD_RPATH "$ORIGIN"
    INSTALL_RPATH "$ORIGIN"
)
