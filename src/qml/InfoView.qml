import QtQuick
import QtQuick.Controls

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    signal accepted(var title, var info)

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"

        ScrollView {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 100
            anchors.bottomMargin: 120

            Label {
                id: titleLabel
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                width: 120
                height : 80
                Text {
                    anchors.fill: parent
                    font.pixelSize: 70
                    style: Text.Outline
                    color: "white"
                    styleColor: "black"
                    text: "标题"
                }
            }

            TextInput {
                id: titleText
                anchors.top: titleLabel.top
                anchors.topMargin: 0
                anchors.left: titleLabel.right
                anchors.leftMargin: 40
                width: rectangle.parent.width - titleLabel.width - 40
                color: "white"
                font.pixelSize: 70
                maximumLength: 160
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                wrapMode: TextEdit.NoWrap
                mouseSelectionMode: TextInput.SelectWords
                readOnly: false
            }

            Label {
                id: infoLabel
                anchors.top: titleLabel.bottom
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 0
                width: 120
                height : 80
                Text {
                    anchors.fill: parent
                    font.pixelSize: 70
                    style: Text.Outline
                    color: "white"
                    styleColor: "black"
                    text: "简介"
                }
            }

            TextEdit {
                id: infoText
                anchors.top: infoLabel.top
                anchors.topMargin: 30
                anchors.left: infoLabel.right
                anchors.leftMargin: 40
                width: rectangle.parent.width - infoLabel.width - 40
                color: "white"
                font.pixelSize: 40
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                wrapMode: TextEdit.WordWrap
                mouseSelectionMode: TextInput.SelectWords
                readOnly: false
            }
        }

        Icon {
            id: button
            radius: 80
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.right: parent.right
            anchors.rightMargin: 50
            visible: true
            z: 1
            enableHover: true
            hoveredColor: "#1abc9c"
            codePoint: "0xf044"
            onClicked: {
                rectangle.parent.accepted(titleText.text,infoText.text);
            }
        }
    }

    function setInfo(title,info) {
        titleText.text = title;
        infoText.text = info;
    }
}
