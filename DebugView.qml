import QtQuick
import QtQuick.Controls

Item {
    property alias text: debugLabel.text

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"

        Label {
            id : debugLabel
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 100
            anchors.bottomMargin: 0
            color: "white"
            font.pixelSize: 40
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WordWrap
        }
    }
}
