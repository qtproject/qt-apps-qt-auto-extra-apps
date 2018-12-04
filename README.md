# QtAuto Extra Apps

This repository hosts additional apps provided for installation in the Qt Automotive Suite.

All apps are intended to be packaged by the appman-packager which is part of the QtApplicationManager module.

See the "Writing Applications" documentation of the QtApplicationManager for how to develop an application
and how the packaging integration works.

# Building and Packaging of Apps

All apps can be build by using the following commands:

$ qmake
$ make

In addition the apps can be packaged as well using the "package" build target

$ make package
