TEMPLATE = lib
TARGET = camera
QT += qml quick
CONFIG += plugin

TARGET = $$qtLibraryTarget($$TARGET)

# Input
SOURCES += \
    camera_plugin.cpp \
    camerastream.cpp

HEADERS += \
    camera_plugin.h \
    camerastream.h

installPath = /apps/com.pelagicore.camera/imports/camera
target.path = $$installPath
qmldir.files = qmldir
qmldir.path = $$installPath
INSTALLS += target qmldir

OTHER_FILES = qmldir
