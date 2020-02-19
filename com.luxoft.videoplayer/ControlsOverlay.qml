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
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtMultimedia 5.12

import shared.Sizes 1.0

import "utils.js" as Utils

Rectangle {
    id: root
    color: Qt.rgba(0, 0, 0, .6)

    readonly property bool playingOrPaused: player.playbackState === MediaPlayer.PausedState
                                            || player.playbackState === MediaPlayer.PlayingState

    property bool shouldShow: false
    property Video player

    function openFilesPanel() {
        filesPanel.visible = true;
    }

    signal fileOpenRequested(url fileURL)
    signal playRequested()
    signal pauseRequested()
    signal stopRequested()
    signal muteRequested(bool muted)
    signal seekRequested(int offset)

    Timer {
        id: hideTimer
        interval: 2500
        running: root.shouldShow && !filesPanel.visible
        repeat: true
        onTriggered: {
            if (player.hasVideo) {
                root.shouldShow = false;
            }
        }
    }

    RowLayout {
        id: labelsLayout
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(24)

        ToolButton {
            text: qsTr("Open...")
            onClicked: filesPanel.visible = !filesPanel.visible
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            visible: player.hasVideo
            Layout.preferredWidth: root.width/3*2
            elide: Label.ElideMiddle
            text: Utils.baseName(player.source)
        }

        Label {
            visible: player.hasVideo
            text: "(%1)".arg(Utils.playbackStateToString(player.playbackState)) + (player.muted ? " " + qsTr("Muted") : "")
        }
    }

    OpenFilesPanel {
        id: filesPanel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: labelsLayout.bottom
        anchors.bottom: playbackControls.top
        anchors.margins: Sizes.dp(24)
        visible: false
        onFileOpenRequested: root.fileOpenRequested(fileURL)
    }

    RowLayout {
        id: playbackControls
        visible: player.hasVideo
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: visible ? implicitHeight : 0
        anchors.margins: Sizes.dp(24)
        spacing: Sizes.dp(24)

        Label {
            text: Utils.msToTime(posSlider.value)
        }

        Slider {
            id: posSlider
            Layout.fillWidth: true
            from: 0
            to: player.duration
            value: player.position
            enabled: player.seekable
            onMoved: {
                hideTimer.restart();
                player.seek(value);
                root.seekRequested(value);
            }
        }

        Label {
            text: Utils.msToTime(player.duration)
        }

        ToolButton {
            id: playPauseButton
            Layout.preferredWidth: Sizes.dp(64)
            Layout.preferredHeight: Sizes.dp(64)
            icon.name: player.playbackState == MediaPlayer.PlayingState ? "ic-pause" : "ic_play"
            enabled: player.hasVideo
            onClicked: {
                hideTimer.restart();
                if (player.playbackState == MediaPlayer.PlayingState) {
                    player.pause();
                    root.pauseRequested();
                } else {
                    player.play();
                    root.playRequested();
                }
            }
        }
        ToolButton {
            id: stopButton
            Layout.preferredWidth: Sizes.dp(64)
            Layout.preferredHeight: Sizes.dp(64)
            icon.name: "ic-close"  // FIXME probably not the best icon :/
            enabled: root.playingOrPaused
            onClicked: {
                hideTimer.restart();
                player.stop();
                root.stopRequested();
            }
        }
        ToolButton {
            id: muteButton
            Layout.preferredWidth: Sizes.dp(64)
            Layout.preferredHeight: Sizes.dp(64)
            icon.name: checked ? "ic-volume-0" : "ic-volume-2"
            enabled: root.playingOrPaused
            checkable: true
            checked: player.muted
            onToggled: {
                hideTimer.restart();
                player.muted = !player.muted;
                root.muteRequested(player.muted);
            }
        }
    }
}
