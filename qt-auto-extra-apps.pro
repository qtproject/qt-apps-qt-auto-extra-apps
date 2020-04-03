TEMPLATE = subdirs
SUBDIRS = com.pelagicore.camera \
          com.pelagicore.youtube \
          com.luxoft.webbrowser \
          com.luxoft.videoplayer \
          com.luxoft.greenomics \
          com.pelagicore.samegame \
          com.pelagicore.webradio \
          com.pelagicore.parking

# Top-level package target
QMAKE_EXTRA_TARGETS += package
package.CONFIG = recursive
