import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.3

ApplicationWindow {
    id: root

    property var xs: [0.0, 0.0, 0.0, 0.0]
    property var ys: [0.0, 0.0, 0.0, 0.0]
    property int displayWidth: width
    property int displayHeight: height

    onVisibleChanged: worker.init()
    Connections {
        target: worker

        onStateChanged: {
            if (state === 0)
                message.text = qsTr("Mis-click detected, restarting...")
            else
                message.text = message.defaultText

            var i;
            for (i = 0; i < state; ++i) {
                crosses.itemAt(i).visible = true
                crosses.itemAt(i).active = false
            }
            crosses.itemAt(state).visible = true
            crosses.itemAt(state).active = true
            for (i = state + 1; i < 4; ++i) {
                crosses.itemAt(i).visible = false
                crosses.itemAt(i).active = false
            }
        }

        onInitialized: {
            displayWidth = newWidth > 0 ? newWidth : Screen.desktopAvailableWidth;
            displayHeight = newHeight > 0 ? newHeight : Screen.desktopAvailableHeight;

            var deltaX = displayWidth / numBlocks;
            var deltaY = displayHeight / numBlocks;
            xs[0] = deltaX;
            ys[0] = deltaY;
            xs[1] = displayWidth - deltaX - 1;
            ys[1] = deltaY;
            xs[2] = deltaX;
            ys[2] = displayHeight - deltaY - 1;
            xs[3] = displayWidth - deltaX - 1;
            ys[3] = displayHeight - deltaY - 1;
            crosses.model = 4
            crosses.itemAt(0).visible = true
            crosses.itemAt(0).active = true
        }
    }


    Item {
        id: centralItem

        focus: true

        anchors.fill: parent

        Image {
            id: backgroundImage
            anchors.fill: parent
            source: "qrc:/images/background-window.jpg"
            fillMode: Image.PreserveAspectCrop
        }

        Text {
            id: message

            readonly property string defaultText: qsTr("Press the point, use a stylus to increase precision.")

            color: "white"
            font.pointSize: 16
            horizontalAlignment: Qt.AlignHCenter
            text: defaultText
            anchors.centerIn: parent
        }

        Button {
            id: abortButton

            z: 10
            anchors {
                top: message.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            width: 200
            height: 50

            style: ButtonStyle {
                id: proofButtonStyle

                background: Rectangle {
                    id: backgroundRectangle

                    radius: 5
                    border.width: control.pressed ? 0 : 1
                    border.color: "white"
                    color: "#1262AD"
                }

                label: Text {
                    id: label

                    height: control.height

                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    color: "white"
                    text: control.text
                    font.pixelSize: 18
                }
            }

            text: qsTr("Abort calibration")
            onClicked: worker.abort()
        }

        Repeater {
            id: crosses
            Cross {
                visible: false
                active: false
                x: xs[index] - width / 2
                y: ys[index] - height / 2
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: worker.onClicked(mouseX, mouseY, displayWidth, displayHeight)
        }
    }

    Component.onCompleted: showFullScreen()
}
