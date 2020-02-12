/****************************************************************************
**
** Copyright (C) 2020 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: http://www.pelagicore.com/
**
** This file is part of Neptune 3 IVI UI.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Neptune IVI UI licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Pelagicore. For licensing terms
** and conditions see http://www.pelagicore.com.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU General Public License version 3 requirements will be
** met: http://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.8
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtWebEngine 1.7
import application.windows 1.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0

ApplicationCCWindow {
    id: root

    Control {
        id: mainContent
        x: root.exposedRect.x
        y: root.exposedRect.y
        width: root.exposedRect.width
        height: root.exposedRect.height
        property alias title: webView.title
        property string url: "https://www.youtube.com"

        onUrlChanged: {
            var pattern = /^((file|http|https|ftp):\/\/)/;

            if (!pattern.test(url)) {
                url = "http://" + url;
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                height: Sizes.dp(4)
                color: "#000000"

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width * webView.loadProgress / 100
                    height: Sizes.dp(4)
                    color: Style.accentColor

                    opacity: webView.loading
                    Behavior on opacity { NumberAnimation {} }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    anchors.fill: parent
                    color: Style.mainColor
                }

                WebEngineView {
                    id: webView

                    anchors.fill: parent
                    url: mainContent.url

                    onLoadingChanged: {
                        if (loadRequest.status === WebEngineView.LoadFailedStatus) {
                            console.log(Logging.sysui, "WebView.Loadfailed: "
                                        + loadRequest.errorString)
                            console.log(Logging.sysui, "when loading: " + loadRequest.url)
                        }
                    }
                }
            }
        }
    }
}
