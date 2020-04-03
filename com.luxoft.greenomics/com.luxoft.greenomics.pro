TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml

app.files = $$FILES
app.path = /apps/com.luxoft.greenomics

view.files += view
view.path = /apps/com.luxoft.greenomics

helper.files += helpers
helper.path = /apps/com.luxoft.greenomics

assets.files += assets/*
assets.path = /apps/com.luxoft.greenomics/assets

INSTALLS += app view helper assets

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
