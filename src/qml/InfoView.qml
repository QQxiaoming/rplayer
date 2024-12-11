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

            ListView {
                id : inputList
                width: rectangle.parent.width
                model: ListModel {
                    id : inputModel
                }
                delegate: TextEdit {
                    width: rectangle.parent.width
                    color: "white"
                    font.pixelSize: 40
                    text: str
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    wrapMode: TextEdit.WordWrap
                    mouseSelectionMode: TextInput.SelectWords
                    readOnly: false
                }
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
                if(inputModel.count) {
                    rectangle.parent.accepted(inputList.itemAtIndex(0).text,inputList.itemAtIndex(1).text);
                }
            }
        }
    }

    function setInfo(title,info) {
        inputModel.clear();
        inputModel.append({"str": title});
        inputModel.append({"str": info});
    }
}
