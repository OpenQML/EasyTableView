import QtQuick 2.12

Item {
    id: root

    readonly property int columns: arrHeaderTitles.length

    property alias currentIndex: listView.currentIndex
    property alias currentItem: listView.currentItem

    property alias model: listModel
    property alias worker: workerScript

    property real borderWidth: 1
    property real rowHeight: 30
    property real rowSpacing: 1
    property real columnSpacing: 1

    property color backgroundColor: "#D3D3D3"
    property color backgroundColorBody: "white"
    property color backgroundColorHeader: "gray"

    property color borderColor: "#D3D3D3"

    property color maskColorClickedItem: "#300000FF"

    property color textColorBody: "black"
    property color textColorHeader: "white"

    property var arrHeaderTitles: ["Title1", "Title2"]
    property var arrWidthRatio: [0.5, 0.5]

    signal listItemClicked()

    Component.onCompleted: {
        privateMember.borderWidth = borderWidth % 2 > 0 ? (borderWidth+1) : borderWidth
    }

    Item {
        id: privateMember

        property int fontSize: rowHeight * 0.4
        property real borderWidth: 0

        WorkerScript {
            id: workerScript

            source: "WorkerEasyTableView.js"

            onMessage: {
                if(messageObject.isWorking) {}
                else {}
            }
        }

        ListModel {
            id: listModel
        }
    }

    Rectangle {
        id: rectTableViewBorder

        width: parent.width + privateMember.borderWidth
        height: parent.height + privateMember.borderWidth

        color: borderColor

        Rectangle {
            id: rectTableView

            width: root.width
            height: root.height

            anchors.centerIn: parent

            color: backgroundColor

            clip: true

            Item {
                id: itemHeader

                width: parent.width
                height: rowHeight

                z: listView.z + 1

                Row {
                    anchors.fill: parent

                    spacing: columnSpacing

                    Repeater {
                        model: root.columns

                        Rectangle {
                            width: itemHeader.width * arrWidthRatio[index] - (columnSpacing/2)
                            height: parent.height

                            color: backgroundColorHeader

                            clip: true

                            Text {
                                anchors.fill: parent

                                text: root.arrHeaderTitles[index]
                                color: textColorHeader

                                font {
                                    bold: true
                                    pixelSize: privateMember.fontSize
                                }

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }

            ListView {
                id: listView

                width: parent.width
                height: parent.height - itemHeader.height

                anchors.bottom: parent.bottom

                currentIndex: -1
                spacing: rowSpacing

                model: listModel

                delegate: Rectangle {
                    id: delegate

                    width: listView.width
                    height: rowHeight

                    color: backgroundColor

                    property bool isClicked: listView.currentIndex === index

                    property var arrTexts: []

                    property var mapData: map_data

                    onMapDataChanged: {
                        for(var i=0;i<root.columns;i++) {
                            arrTexts.push(mapData[arrHeaderTitles[i]])
                        }
                    }

                    onIsClickedChanged: {
                        if(isClicked) {
                            rectMaskClickedItem.z += 1

                            root.listItemClicked()
                        }
                        else {
                            rectMaskClickedItem.z -= 1
                        }
                    }

                    Rectangle {
                        id: rectMaskClickedItem

                        anchors.fill: parent

                        color: delegate.isClicked ? maskColorClickedItem : "transparent"
                    }

                    Row {
                        anchors.fill: parent

                        spacing: columnSpacing

                        Repeater {
                            model: root.columns

                            Rectangle {
                                width: delegate.width * arrWidthRatio[index] - (columnSpacing/2)
                                height: parent.height

                                color: backgroundColorBody

                                clip: true

                                Text {
                                    anchors.fill: parent

                                    text: delegate.arrTexts[index]

                                    color: textColorBody
                                    font.pixelSize: privateMember.fontSize

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            listView.currentIndex = index
                        }
                    }
                }
            }
        }
    }
}
