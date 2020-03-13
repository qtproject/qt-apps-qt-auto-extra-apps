/****************************************************************************
**
** Copyright (C) 2020 Luxoft Sweden AB
** Copyright (C) 2014-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtAuto Extra Apps.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/

import QtQuick 2.8
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0

import shared.Sizes 1.0
import shared.controls 1.0
import shared.Style 1.0

Item {
    id: root

    width: Sizes.dp(607.5)
    height: Sizes.dp(480)

    property alias source: image.source
    property alias title: title.text
    property alias description: description.text
    property alias subTitle: subTitle.text
    property string status
    signal clicked()

    RowLayout {
        id: currentRadio
        anchors.left: parent.left
        spacing: Sizes.dp(30)
        Item {
            Layout.preferredWidth: Sizes.dp(270)
            Layout.preferredHeight: Sizes.dp(270)
            Rectangle {
                anchors.fill: parent
                color: "white"
                border.color: Qt.darker(color, 1.2)
            }
            Image {
                id: image
                anchors.fill: parent
                anchors.margins: Sizes.dp(2)
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                Image {
                    anchors.top: parent.bottom
                    width: Sizes.dp(270)
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: Style.image("album-art-shadow-widget")
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Label {
            id: titelPlaceholder
            Layout.preferredWidth: Sizes.dp(306)
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: Sizes.fontSizeM
            wrapMode: Text.WordWrap
            visible: title.text === ""
            text: qsTr("No Stream Selected")
        }

        Label {
            id: title
            Layout.preferredWidth: Sizes.dp(306)
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: Sizes.fontSizeM
            wrapMode: Text.WordWrap
        }
    }

    ColumnLayout {
        anchors.top: currentRadio.bottom
        anchors.topMargin: Sizes.dp(80)
        anchors.left: currentRadio.left
        spacing: Sizes.dp(5)

        Label {
            id: subTitle
            font.pixelSize: Sizes.fontSizeS
            font.weight: Font.Light
        }

        Label {
            id: description
            Layout.preferredWidth: root.width
            Layout.preferredHeight: Sizes.dp(70)
            font.pixelSize: Sizes.fontSizeS
            font.weight: Font.Light
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Label {
            visible: root.status !== ""
            text: root.status
            font.pixelSize: Sizes.fontSizeM
            font.weight: Font.Light
            Layout.preferredWidth: root.width
            Layout.alignment: Qt.AlignCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
