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
import QtQuick.Controls 2.2

import shared.controls 1.0
import shared.Sizes 1.0
import shared.Style 1.0
import shared.utils 1.0
import shared.animations 1.0

import "../stores"
import "../popups"


Item {
    id: root

    property RadioStore store
    property Item rootItem
    signal chosenGenre(var genre)

    Image {
        width: root.width - Sizes.dp(80)
        height: Sizes.dp(16)
        anchors.horizontalCenter: root.horizontalCenter
        anchors.bottom: genrelist.top
        source: Style.image("list-divider")
        opacity: genrelist.contentY > 0 ? 1.0 : 0.0
        Behavior on opacity { DefaultNumberAnimation { duration: 100 } }
    }

    ToolsColumn {
        id: toolsColumn
        width: Sizes.dp(264)
        anchors.left: parent.left
        anchors.top: parent.top
        model: root.store.toolsColumnModel

        onClicked: {
            if (currentText === "sources") {
                //FIXME in multiprocess store.musicSourcesModel.length returns 1
                //even though is more. When spotify and/or web radio are uninstalled
                //and installed again, then it updates fine.
                var pos = currentItem.mapToItem(root.rootItem
                                                , currentItem.width/2, currentItem.height/2);

                let posX = pos.x / root.Sizes.scale;
                let posY = pos.y / root.Sizes.scale;

                // caclulate popup height based on musicSources list items
                // + 200 for header & margins
                musicSourcesPopup.height = Qt.binding(() => {
                    return musicSourcesPopup.model
                        ? root.Sizes.dp(200 + (musicSourcesPopup.model.count * 96))
                        : root.Sizes.dp(296);
                });
                musicSourcesPopup.width = Qt.binding(() => root.Sizes.dp(910))

                //set model each time to ensure data accuracy
                musicSourcesPopup.model = root.store.musicSourcesModel
                musicSourcesPopup.originItemX = Qt.binding(() => root.Sizes.dp(posX));
                musicSourcesPopup.originItemY = Qt.binding(() => root.Sizes.dp(posY));
                musicSourcesPopup.popupY = Qt.binding(() => {
                    return root.Sizes.dp(Config.centerConsoleHeight / 4);
                });
                musicSourcesPopup.visible = true;
            } else if (currentText === "ABOUT...") {
                pos = currentItem.mapToItem(root.rootItem
                                                , currentItem.width/2, currentItem.height/2);

                let posX = pos.x / root.Sizes.scale;
                let posY = pos.y / root.Sizes.scale;

                aboutPopup.width = Qt.binding(() => root.Sizes.dp(910))
                aboutPopup.height = Qt.binding(() => root.Sizes.dp(450))
                aboutPopup.originItemX = Qt.binding(() => root.Sizes.dp(posX));
                aboutPopup.originItemY = Qt.binding(() => root.Sizes.dp(posY));
                aboutPopup.popupY = Qt.binding(() => {
                    return root.Sizes.dp(Config.centerConsoleHeight / 4);
                });
                aboutPopup.visible = true;
            }

            toolsColumn.currentIndex = 0;
        }
    }

    MusicSourcesPopup {
        id: musicSourcesPopup
        onSwitchSourceClicked: {
            store.switchSource(source)
        }
    }

    AboutPopup {
        id: aboutPopup
    }

    GridView {
        id: genrelist

        width: root.width - Sizes.dp(247.5)
        height: root.height
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: toolsColumn.width / 3

        model: root.store.musicGenres
        clip: true
        cellWidth: Sizes.dp(202.5) ; cellHeight: cellWidth

        ScrollIndicator.vertical: ScrollIndicator {
            parent: genrelist.parent
            anchors.top: genrelist.top
            anchors.right: genrelist.right
            anchors.rightMargin: - Sizes.dp(9)
            anchors.bottom: genrelist.bottom
        }

        delegate: Item {
            width: Sizes.dp(193,5)
            height: Sizes.dp(180)

            Rectangle {
                anchors.fill: parent
                opacity: 0.2
                color: "black"
                border.width: mouseArea.containsPress ? 2 : 1
                border.color: "#888"
                radius: 4
                gradient: Gradient {
                    GradientStop { position: 0 ; color: mouseArea.containsPress ? "#ccc" : "#eee" }
                    GradientStop { position: 1 ; color: mouseArea.containsPress ? "#aaa" : "#ccc" }
                }
            }

            Label {
                anchors.centerIn: parent
                width: Sizes.dp(157,5)
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Sizes.fontSizeS
                text: model.name
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    root.chosenGenre(model.name)
                }
            }
        }
    }
}
