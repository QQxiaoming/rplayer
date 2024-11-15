import QtQuick
import QtQuick.Controls

Item {
    property alias readOnly: input.readOnly
    property alias text: input.text
    property alias wrapMode: input.wrapMode

    signal accepted(var str)

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"

        Flickable {
            id: inputFlickable
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 100
            anchors.bottomMargin: 120
            contentWidth: input.width
            contentHeight: input.height

            TextEdit {
                id: input
                width:1080
                height:20000
                color: "white"
                font.pixelSize: 40
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                wrapMode: TextEdit.WordWrap
                mouseSelectionMode: TextInput.SelectWords
                readOnly: true
            }
        }

        Icon {
            id: button
            radius: 80
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.right: parent.right
            anchors.rightMargin: 50
            visible: !input.readOnly
            z: 1
            enableHover: true
            hoveredColor: "#1abc9c"
            codePoint: "0xf044"
            onClicked: {
                rectangle.parent.accepted(input.text);
            }
        }
    }
}
