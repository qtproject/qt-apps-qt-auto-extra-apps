TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml \
         UrlField.qml \
         WBView.qml

app.files = $$FILES
app.path = /apps/com.luxoft.webbrowser
INSTALLS += app

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
