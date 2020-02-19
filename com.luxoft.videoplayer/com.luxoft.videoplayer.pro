TEMPLATE = aux

FILES += info.yaml \
         icon.png \
         Main.qml \
         VideoPlayerView.qml \
         VideoPlayerPanel.qml \
         ControlsOverlay.qml \
         OpenFilesPanel.qml \
         ICVideoPlayerView.qml \
         utils.js

app.files = $$FILES
app.path = /apps/com.luxoft.videoplayer
INSTALLS += app

AM_MANIFEST = info.yaml
AM_PACKAGE_DIR = $$app.path

load(am-app)
