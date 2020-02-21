/****************************************************************************
**
** Copyright (C) 2019-2020 Luxoft Sweden AB
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtAuto Extra Apps.
**
** $QT_BEGIN_LICENSE:BSD-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: BSD-3-Clause
**
****************************************************************************/

import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0

import shared.utils 1.0
import shared.controls 1.0
import shared.Style 1.0
import shared.Sizes 1.0
import application.windows 1.0

import camera 0.1

ApplicationCCWindow {
    id: root
    readonly property var angles: [qsTr("Front"), qsTr("Rear"), qsTr("Left"), qsTr("Right")]
    property bool play: !videofeed.lastError
    property real buttonWidth: Sizes.dp(100)

    function prevCamera() {
        videofeed.angle = (videofeed.angle+3) % 4;
        camlabel.text = root.angles[videofeed.angle];
    }

    function nextCamera() {
        videofeed.angle = (videofeed.angle+1) % 4;
        camlabel.text = root.angles[videofeed.angle];
    }

    Timer {
        id: timer
        interval: 5000; running: root.play; repeat: true
        onTriggered: root.nextCamera()
    }


    Item {
        x: root.exposedRect.x
        y: root.exposedRect.y
        width: root.exposedRect.width
        height: root.exposedRect.height
        CameraStream {
            id: videofeed
            anchors.horizontalCenter: parent.horizontalCenter
            width: Sizes.dp(1280)
            height: Sizes.dp(1080)

            Row {
                id: controls
                anchors.top: parent.top
                width: 3*root.buttonWidth
                height: Sizes.dp(100)
                anchors.horizontalCenter: parent.horizontalCenter
                ToolButton {
                    width: root.buttonWidth
                    height: parent.height
                    enabled: !videofeed.lastError
                    icon.name: "ic_skipprevious"
                    icon.color: "white"
                    onClicked: root.prevCamera()
                }
                ToolButton {
                    width: root.buttonWidth
                    height: parent.height
                    enabled: !videofeed.lastError
                    icon.name: root.play ? "ic-pause" : "ic_play"
                    icon.color: "white"
                    onClicked: {
                        root.play = !root.play;
                        timer.running = root.play;
                    }
                    background: Image {
                        id: playButtonBackground
                        anchors.centerIn: parent
                        width: Sizes.dp(sourceSize.width)
                        height: Sizes.dp(sourceSize.height)
                        source: Style.image("ic_button-bg")
                        fillMode: Image.PreserveAspectFit
                        layer.enabled: true
                        layer.effect: ColorOverlay {
                            source: playButtonBackground
                            color: Style.accentColor
                        }
                    }
                }
                ToolButton {
                    width: root.buttonWidth
                    height: parent.height
                    enabled: !videofeed.lastError
                    icon.name: "ic_skipnext"
                    icon.color: "white"
                    onClicked: root.nextCamera()
                }
            }

            Label {
                anchors.centerIn: parent
                text: qsTr("No Camera")
                color: "white"
                visible: videofeed.lastError
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Sizes.dp(10)

                id: camlabel
                text: root.angles[videofeed.angle]
                color: "white"
            }
        }
    }
}
