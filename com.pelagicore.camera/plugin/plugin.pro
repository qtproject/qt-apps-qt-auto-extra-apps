TEMPLATE = lib
TARGET = camera
QT += qml quick
CONFIG += plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = camera
load(qmlplugin)

# Input
SOURCES += \
    camera_plugin.cpp \
    camerastream.cpp

HEADERS += \
    camera_plugin.h \
    camerastream.h

OTHER_FILES = qmldir
