/****************************************************************************
**
** Copyright (C) 2020 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 UI.
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

import QtQuick 2.12
import application.windows 1.0
import shared.utils 1.0

import shared.com.pelagicore.settings 1.0

import "."

ApplicationCCWindow {
    id: root

    MultiPointTouchArea {
        anchors.fill: parent
        anchors.margins: 30
        touchPoints: [ TouchPoint { id: touchPoint1 } ]

        property int count: 0
        onReleased: {
            count += 1;
            root.setWindowProperty("activationCount", count);
        }
    }

    VideoPlayerView {
        id: videoplayer
        x: root.exposedRect.x
        y: root.exposedRect.y
        width: root.exposedRect.width
        height: root.exposedRect.height

        state: root.neptuneState
        bottomWidgetHide: root.exposedRect.height === root.targetHeight
    }

    InstrumentCluster {
        id: clusterSettings
    }

    readonly property Loader applicationICWindowLoader: Loader {
        asynchronous: true
        active: clusterSettings.available
                || Qt.platform.os !== "linux" // FIXME and then remove; remote settings doesn't really work outside of Linux

        sourceComponent: Component {
            ApplicationICWindow {
                ICVideoPlayerView {
                    id: icVideoPlayer
                    anchors.fill: parent
                    sourceUrl: videoplayer.sourceUrl

                    Connections {
                        target: videoplayer
                        onPlayRequested: icVideoPlayer.player.play()
                        onPauseRequested: icVideoPlayer.player.pause()
                        onStopRequested: icVideoPlayer.player.stop()
                        onSeekRequested: icVideoPlayer.player.seek(offset)
                    }
                }
            }
        }
    }
}
