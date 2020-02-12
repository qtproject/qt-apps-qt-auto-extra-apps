TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml \
         Samegame.qml

app.files = $$FILES
app.path = /apps/com.pelagicore.samegame

content.files += content
content.path = /apps/com.pelagicore.samegame

INSTALLS += app content

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
