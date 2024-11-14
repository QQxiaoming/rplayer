import QtQuick
import QtQuick.Controls

Item {
    property alias inputText: textInput.text

    signal accepted()
    signal rejected()

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"

        TextInput {
            id: textInput
            y: 100
            height: 1000
            text: "http://"
            color: "white"
            font.pixelSize: 60
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 10
        }

        Button {
            id: button1
            width: 300
            height: 80
            contentItem: Text {
                text: "确认"
                color: "black"
                font.pixelSize: 60
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 100
            anchors.topMargin: 1300
            onClicked: {
                rectangle.parent.accepted()
            }
        }

        Button {
            id: button2
            width: button1.width
            height: button1.height
            contentItem: Text {
                text: "取消"
                color: "black"
                font.pixelSize: 60
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            anchors.right: parent.right
            anchors.top: button1.top
            anchors.rightMargin: 100
            anchors.topMargin: 0
            onClicked: {
                rectangle.parent.rejected()
            }
        }
    }
}
