TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Camera.qml

app.files = $$FILES
app.path = /apps/com.pelagicore.camera
INSTALLS += app

OTHER_FILES += $$FILES
