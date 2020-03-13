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

import shared.controls 1.0
import shared.Sizes 1.0
import shared.Style 1.0

import "../stores"
import "../panels"

Item {
    id: root

    property RadioStore store
    property var station: store.station
    property alias rootItem: selectionScreen.rootItem
    property bool playerVisible: false

    CurrentStationScreen {
        id: currentStation

        width: parent.width
        height: Sizes.dp(560)
        stationName: root.station && root.station.name ? root.station.name : ""
        stationImage: root.station && root.station.logo ? root.station.logo : ""
        bitRate: root.station && root.station.br? root.station.br : ""
        streamingUrl: root.store.url
        currentOperationStatus: root.store.currentOperationStatus
        playing: root.store.playing

        onNextStation: {
            root.store.next();
        }

        onPrevStation: {
            root.store.previous();
        }

        onPlayStation: root.store.play()
        onPauseStation: root.store.pause()
    }

    SelectionScreen {
        id: selectionScreen
        width: parent.width
        height: parent.height - currentStation.height
        anchors.top: currentStation.bottom
        store: root.store

        onChosenGenre: {
            store.getStationsForGenre(genre);
        }
    }
}
