import QtQuick 2.10

Item {
    id: cross

    property bool active: false
    readonly property color color: active ? "red" : "white"

    width: 50
    height: width
    Rectangle {
        color: cross.color
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: 2
    }

    Rectangle {
        color: cross.color
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: 2
    }

    Rectangle {
        color: "transparent"
        border.color: cross.color
        border.width: 2
        anchors.centerIn: parent
        radius: width / 2
        width: parent.width * 0.25
        height: width
    }

}
