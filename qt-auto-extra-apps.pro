TEMPLATE = subdirs
SUBDIRS = com.pelagicore.camera \
          com.pelagicore.spotify \
          com.pelagicore.netflix \
          com.luxoft.webbrowser \
          com.luxoft.videoplayer

# Top-level package target
QMAKE_EXTRA_TARGETS += package
package.CONFIG = recursive
