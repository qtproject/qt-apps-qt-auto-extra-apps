/****************************************************************************
**
** Copyright (C) 2020 Luxoft Sweden AB
** Copyright (C) 2017-2018 Pelagicore AG
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

import QtQuick 2.8
import QtMultimedia 5.9
import QtQuick.XmlListModel 2.14
import QtApplicationManager.Application 2.0
import QtApplicationManager 2.0

import shared.utils 1.0
import shared.Sizes 1.0

Store {
    id: root

    property bool nextStation: true
    Component.onCompleted: {
        getAllGenres();
    }

    property ListModel musicGenres: ListModel {}
    property ListModel currentStations: ListModel {}

    property Audio player: Audio {
        id: player
        source: url
    }

    property alias volume: player.volume
    property bool playing: player.playbackState === Audio.PlayingState

    property var station
    property int currentIndex
    property string url
    property string currentOperationStatus

    property ListModel toolsColumnModel: ListModel {
        id: toolsColumnModel

        ListElement { icon: "ic-installed"; text: "genres"; greyedOut: false }
        ListElement { icon: "ic-toolbar-sources-tuner"; text: "sources"; greyedOut: false }
        ListElement { icon: ""; text: "ABOUT..."; greyedOut: false }
    }

    property ListModel musicSourcesModel: ListModel {
        id: musicSourcesModel
        ListElement {
            text: "AM/FM Radio"
            appId: "com.pelagicore.tuner"
        }
        ListElement {
            text: "Music"
            appId: "com.pelagicore.music"
        }
    }

    QtObject {
        id: d
        readonly property string devID: "5ClwKdIfc6j5Nitn"
        readonly property string base_tuneIN: "/sbin/tunein-station.pls"
        readonly property var xmlGenresParser: XmlListModel {
            query: "/genrelist/genre"
            XmlRole { name: "name"; query: "@name/string()" }
            XmlRole { name: "count"; query: "@count/number()" }
            onStatusChanged: {
                if (status === XmlListModel.Ready) {
                    musicGenres.clear();
                    root.currentOperationStatus = "";
                    var tmpAr = []
                    for (var i = 0; i < count; ++i) {
                        var obj = get(i);
                        if (obj.count > 0) {
                            tmpAr.push({'name': obj.name});
                        }
                    }

                    // append array is not documented
                    // see qt5/qtdeclarative/src/qml/types/qqmllistmodel.cpp
                    musicGenres.append(tmpAr);
                } else if (status === XmlListModel.Error) {
                    root.currentOperationStatus =
                        qsTr("Failed to load genres list, try to restart the app later");
                }
            }
        }

        readonly property var xmlStationsParser: XmlListModel {
            query: "/stationlist/station"
            XmlRole { name: "name"; query: "@name/string()" }
            XmlRole { name: "mt"; query: "@mt/string()" }
            XmlRole { name: "id"; query: "@id/string()" }
            XmlRole { name: "br"; query: "@br/string()" }
            XmlRole { name: "logo"; query: "@logo/string()" }
            onStatusChanged: {
                if (status === XmlListModel.Ready) {
                    currentStations.clear();
                    root.currentOperationStatus = "";
                    var tmpAr = []
                    for (var i = 0; i < count; ++i) {
                        var obj = get(i);
                        tmpAr.push(
                                {'name': obj.name
                                , "id": obj.id
                                , "logo": obj.logo
                                , "br": obj.br
                                });
                    }

                    currentStations.append(tmpAr);
                    playFirst();
                } else if (status === XmlListModel.Error) {
                    root.currentOperationStatus =
                        qsTr("Failed to get stations for the given genre");
                }
            }
        }
    }

    function playFirst() {
        if (currentStations.count > 0) {
            currentIndex = 0;
            var station = currentStations.get(currentIndex);
            getSourceForStation(station.id);
            root.station = station;
        }
    }

    function next() {
        if (currentStations.count > 0) {
            currentIndex = (currentIndex + 1) % currentStations.count;
            var station = currentStations.get(currentIndex);
            getSourceForStation(station.id);
            root.station = station;
        }
    }

    function previous() {
        if (currentStations.count > 0) {
            currentIndex = currentIndex == 0 ? currentStations.count - 1 : currentIndex - 1;
            var station = currentStations.get(currentIndex);
            getSourceForStation(station.id);
            root.station = station;
        }
    }

    function play() {
        player.autoPlay = true
        player.play()
    }

    function pause() {
        player.autoPlay = false
        player.pause()
    }

    function switchSource(source) {
        root.pause()
        if (source === "com.pelagicore.music" || source === "com.pelagicore.tuner") {
            var request = IntentClient.sendIntentRequest("activate-app", source, {})
            request.onReplyReceived.connect(function() {
                if (request.succeeded) {
                    var result = request.result
                    console.log(Logging.apps, "Intent result: " + result.done)
                } else {
                    console.log(Logging.apps, "Intent request failed: " + request.errorMessage)
                }
            })
        }
    }

    // A SHOUTcast Radio Directory API is used with the devId
    function getAllGenres() {
        root.currentOperationStatus = qsTr("Trying to load genres");
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "http://api.shoutcast.com/legacy/genrelist?k=" + d.devID)
        xhr.responseType = "document";
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                d.xmlGenresParser.xml = xhr.responseText;
            }
        }
        xhr.send()
    }

    //http://api.shoutcast.com/legacy/genresearch?k=5ClwKdIfc6j5Nitn&genre=50s
    //http://api.shoutcast.com/legacy/genresearch?k=[Your Dev ID]&genre=<genre>
    function getStationsForGenre(genre) {
        root.currentOperationStatus = qsTr("Trying to load stations for ") + genre;
        var xhr = new XMLHttpRequest;
        xhr.open("GET"
            , "http://api.shoutcast.com/legacy/genresearch?k="
                + d.devID + "&genre=" + genre.replace("&","%26")
        );
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                d.xmlStationsParser.xml = xhr.responseText;
            }
        }
        xhr.send();
    }

    //http://yp.shoutcast.com/sbin/tunein-station.pls?id=1513982
    function getSourceForStation(id) {
        root.currentOperationStatus = qsTr("Trying to get url for the given station");
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=" + id);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.url = xhr.responseText.match("File1=(.*)")[1];
                root.currentOperationStatus = "";
            }
        }
        xhr.send();
    }
}
