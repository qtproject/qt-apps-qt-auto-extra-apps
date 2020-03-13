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

import QtQuick 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.2
import shared.controls 1.0
import shared.Sizes 1.0

import shared.Style 1.0

Item {
    id: root

    property string stationName: ""
    property string stationImage: ""
    property string bitRate: ""
    property string streamingUrl: ""
    property alias currentOperationStatus: stationInfo.status
    property bool playing

    signal nextStation()
    signal prevStation()
    signal playStation()
    signal pauseStation()

    StationCover {
        id: stationInfo

        anchors.left: parent.left
        anchors.leftMargin: Sizes.dp(80)
        source: root.stationImage === "" ? "../assets/onair.jpg" : root.stationImage
        title: root.stationName
        subTitle: qsTr("Bitrate: ") + root.bitRate
        description: qsTr("Streaming: ") + root.streamingUrl
    }

    Image {
        anchors.bottomMargin: -Sizes.dp(80)
        anchors.bottom: controlsRow.top
        anchors.left: stationInfo.right
        height: Sizes.dp(278 / 3)
        width: Sizes.dp(1000 / 3)
        fillMode: Image.PreserveAspectCrop
        source: Style.theme === Style.Dark ? "../assets/logo-dark.png" : "../assets/logo.png"
    }

    RowLayout {
        id: controlsRow
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(52)
        anchors.left: stationInfo.right
        ToolButton {
            Layout.preferredWidth: Sizes.dp(80)
            Layout.preferredHeight: Sizes.dp(240)
            icon.name: "ic_skipprevious"
            onClicked: {
                root.prevStation()
            }
        }

        ToolButton {
            Layout.preferredWidth: Sizes.dp(160)
            Layout.preferredHeight: Sizes.dp(240)
            icon.name: root.playing ? "ic-pause" : "ic_play"
            onClicked: root.playing ? root.pauseStation() : root.playStation()
        }

        ToolButton {
            Layout.preferredWidth: Sizes.dp(80)
            Layout.preferredHeight: Sizes.dp(240)
            icon.name: "ic_skipnext"
            onClicked: {
                root.nextStation()
            }
        }
    }
}
