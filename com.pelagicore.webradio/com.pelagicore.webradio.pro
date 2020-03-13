TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml \
         panels \
         stores \
         assets \
         popups \
         views \

app.files = $$FILES
app.path = /apps/com.pelagicore.webradio
INSTALLS += app

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
