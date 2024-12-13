import QtQuick
import QtQuick.Controls

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    property bool readOnly: true
    property int wrapMode: TextEdit.WordWrap

    signal accepted(var str)

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
                spacing: 10
                delegate: TextEdit {
                    width: rectangle.parent.width
                    color: "white"
                    font.pixelSize: 40
                    text: str
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    wrapMode: rectangle.parent.wrapMode
                    mouseSelectionMode: TextInput.SelectWords
                    readOnly: rectangle.parent.readOnly
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
            visible: !rectangle.parent.readOnly
            z: 1
            enableHover: true
            hoveredColor: "#1abc9c"
            codePoint: "0xf044"
            onClicked: {
                if(inputModel.count) {
                    rectangle.parent.accepted(inputList.itemAtIndex(0).text);
                }
            }
        }
    }

    function addlog(str) {
        inputModel.append({"str": str});
    }

    function cleanlog() {
        inputModel.clear();
    }
}
