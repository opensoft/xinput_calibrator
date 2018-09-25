import QtQuick 2.10
import QtQuick.Controls 1.4
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
                message.text = "Mis-click detected, restarting..."
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

        onSetDisplaySize: {
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

            readonly property string defaultText: "Press the point, use a stylus to increase precision.\n(To abort, press any key)"

            color: "white"
            font.pointSize: 16
            horizontalAlignment: Qt.AlignHCenter
            text: defaultText
            anchors.centerIn: parent
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

        Keys.onPressed: Qt.quit()
    }

    Component.onCompleted: showFullScreen()
}
