TEMPLATE = subdirs
SUBDIRS += plugin \
           app

app.depends = plugin

AM_MANIFEST = $$PWD/app/info.yaml
AM_PACKAGE_DIR = /apps/com.pelagicore.camera

load(am-app)
