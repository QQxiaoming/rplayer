cmake_minimum_required(VERSION 3.16)

project(rplayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Multimedia)

qt_standard_project_setup(REQUIRES 6.5)

include_directories(src lib/QFontIcon)

qt_add_executable(rplayer
    src/main.cpp
)

qt_add_qml_module(rplayer
    URI rplayerui
    VERSION 1.0
    QML_FILES
        src/qml/Main.qml
        src/qml/Icon.qml
        src/qml/TitleLabel.qml
        src/qml/VideoView.qml
        src/qml/VideoPlayer.qml
        src/qml/InputView.qml
        src/qml/AboutView.qml
        src/qml/DebugView.qml
    SOURCES 
        src/jsonreader.h 
        src/fonticon.h 
        lib/QFontIcon/qfonticon.cpp 
        lib/QFontIcon/qfonticon.h
    RESOURCES 
        res/fontawesome-webfont-v6.6.0-brands-400.ttf 
        res/fontawesome-webfont-v6.6.0-solid-900.ttf
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(rplayer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.rplayer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(rplayer
    PRIVATE Qt6::Quick Qt6::Multimedia
)

if(IOS)
    qt_add_ios_ffmpeg_libraries(rplayer)
endif()

include(GNUInstallDirs)
install(TARGETS rplayer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
