/****************************************************************************
**
** Copyright (C) 2019 Luxoft Sweden AB
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

.pragma library

.import QtMultimedia 5.12 as QtMultimedia

function baseName(str)
{
    var base = String(str).substring(String(str).lastIndexOf('/') + 1);
    return base;
}

function availabilityToString(availability) {
    switch (availability) {
    case QtMultimedia.MediaPlayer.Available:
        return "Available";
    case QtMultimedia.MediaPlayer.Busy:
        return "Busy";
    case QtMultimedia.MediaPlayer.Unavailable:
        return "Unavailable";
    case QtMultimedia.MediaPlayer.ResourceMissing:
        return "Missing resource";
    default:
        return "Unknown status: %1".arg(availability);
    }
}

function statusToString(status) {
    switch (status) {
    case QtMultimedia.MediaPlayer.NoMedia: return "No media";
    case QtMultimedia.MediaPlayer.Loading: return "Loading";
    case QtMultimedia.MediaPlayer.Loaded: return "Loaded";
    case QtMultimedia.MediaPlayer.Buffering: return "Buffering";
    case QtMultimedia.MediaPlayer.Stalled: return "Stalled";
    case QtMultimedia.MediaPlayer.Buffered: return "Buffered";
    case QtMultimedia.MediaPlayer.EndOfMedia: return "End of media";
    case QtMultimedia.MediaPlayer.InvalidMedia: return "Invalid media";
    case QtMultimedia.MediaPlayer.UnknownStatus:
    default:
        return "Unknown status %1".arg(status);
    }
}

function playbackStateToString(playbackState) {
    switch (playbackState) {
    case QtMultimedia.MediaPlayer.PlayingState: return qsTr("Playing");
    case QtMultimedia.MediaPlayer.PausedState: return qsTr("Paused");
    case QtMultimedia.MediaPlayer.StoppedState: return qsTr("Stopped");
    default: return qsTr("Unknown playback state %1").arg(playbackState);
    }
}

function msToTime(duration) {
    var seconds = Math.floor((duration / 1000) % 60);
    var minutes = Math.floor((duration / (1000 * 60)) % 60);
    var hours = Math.floor((duration / (1000 * 60 * 60)) % 24);

    hours = (hours < 10) ? "0" + hours : hours;
    minutes = (minutes < 10) ? "0" + minutes : minutes;
    seconds = (seconds < 10) ? "0" + seconds : seconds;

    return hours + ":" + minutes + ":" + seconds;
}
