TEMPLATE = subdirs
SUBDIRS += plugin \
           app

app.depends = plugin
