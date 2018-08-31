# QtAuto Extra Apps

This repository hosts additional apps provided for installation in the Qt Automotive Suite.

All apps are intended to be packaged by the appman-packager which is part of the QtApplicationManager module.

# Building and Packaging of Apps

All apps can be build by using the following commands:

$ qmake
$ make

In addition the apps can be packaged as well using the "package" build target

$ make package

# Adding new apps
## Simple Apps

For simple QML only apps, just add a new folder with your QML files and icon and the info.yaml for the package.
The new package needs to be added to the qmake build system. For simple apps this is done by creating a new pro file named the same way like your folder.
The pro file looks as following:

FILES += info.yaml \
         icon.png \
         Browser.qml

load(app)

Also make sure the new folder is added to the toplevel pro file qt-auto-extra-apps.pro

## Complex Apps

For more complex apps where you need to deploy a C++ based QML plugin in addition to your QML content you need to do the following:

1. Create a new folder as described for Simple Apps
2. Create a new "app" sub-folder and a new "plugin" subfolder
3. In the plugin subfolder you can use the qmlplugin feature file e.g.

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

4. In the app directory you can use the same template as used in the simple app case.
5. As the package name is retrieved from the folder name, you need to manually set the package name in your app project file
e.g. NAME = com.pelagicore.camera
6. Create a sub-dirs pro file in your global app folder
7. Add your app folder to the toplevel pro file qt-auto-extra-apps.pro
