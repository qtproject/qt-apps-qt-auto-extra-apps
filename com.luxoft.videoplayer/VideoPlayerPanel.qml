/****************************************************************************
**
** Copyright (C) 2020 Luxoft Sweden AB
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import QtQuick.Controls 2.12
import QtMultimedia 5.12

import "utils.js" as Utils

Rectangle {
    implicitWidth: 800
    implicitHeight: 600
    color: "black"

    Video {
        id: videoplayer
        anchors.fill: parent
        audioRole: MediaPlayer.VideoRole
        autoPlay: true

        onStatusChanged: {
            console.debug("Video player status changed:", Utils.statusToString(status))
        }
        onErrorChanged: {
            console.warn("Video player error: %1\n%2".arg(error).arg(errorString))
        }
        onPlaybackStateChanged: {
            console.debug("Video playback state changed:", Utils.playbackStateToString(playbackState))
        }
        onVolumeChanged: {
            console.debug("Video player volume changed:", volume)
        }
        Component.onCompleted: {
            console.debug("Video player availability:", Utils.availabilityToString(availability))
            console.debug("Supported audio roles:", supportedAudioRoles())
        }

        focus: true
        Keys.onLeftPressed: seek(position - 5000)
        Keys.onRightPressed: seek(position + 5000)
        Keys.onUpPressed: videoplayer.volume += .1
        Keys.onDownPressed: videoplayer.volume -= .1
        Keys.enabled: videoplayer.seekable

        MouseArea {
            anchors.fill: parent
            onClicked: controls.shouldShow = !controls.shouldShow
        }

        ToolButton {
            anchors.centerIn: parent
            visible: !videoplayer.hasVideo && !controls.shouldShow
            text: qsTr("Open video...")
            onClicked: {
                controls.shouldShow = !controls.shouldShow;
                controls.openFilesPanel();
            }
        }

        ControlsOverlay {
            id: controls
            width: parent.width
            height: parent.height
            x: parent.x
            y: shouldShow ? 0 : parent.height
            player: videoplayer
            Behavior on y { NumberAnimation {}}
            onFileOpenRequested: videoplayer.source = fileURL
        }
    }
}
