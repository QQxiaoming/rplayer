import QtQuick
import QtQuick.Controls

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    signal accepted(var commentList)

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
                delegate: Rectangle {
                    property alias itemIcon: iconId.sourceStr
                    property alias itemName: nameId.text
                    property alias itemContent: contentId.text
                    Icon {
                        id: iconId
                        property string sourceStr: icon
                        anchors.top: parent.top
                        anchors.topMargin: 200*index
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        radius: 40
                        enablePressAnimation: false
                        holdHovered: true
                        source: icon
                    }
                    TextEdit {
                        id: nameId
                        anchors.top: iconId.top
                        anchors.topMargin: 0
                        anchors.left: iconId.left
                        anchors.leftMargin: iconId.width + 10
                        width: rectangle.parent.width - iconId.width - 10
                        color: "white"
                        text: name
                        wrapMode: TextEdit.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                        mouseSelectionMode: TextInput.SelectWords
                        font.pixelSize: 70
                        readOnly: false
                    }
                    TextEdit {
                        id: contentId
                        anchors.top: iconId.bottom
                        anchors.topMargin: 20
                        anchors.left: iconId.left
                        anchors.leftMargin: 0
                        width: rectangle.parent.width
                        color: "white"
                        text: content
                        font.pixelSize: 40
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                        wrapMode: TextEdit.WordWrap
                        mouseSelectionMode: TextInput.SelectWords
                        readOnly: false
                    }
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
                    var list = [];
                    for(var i = 0; i < inputModel.count; i++) {
                        if(inputList.itemAtIndex(i).itemName === "") {
                            continue;
                        }
                        var comment = {};
                        comment["name"] = inputList.itemAtIndex(i).itemName;
                        comment["icon"] = inputList.itemAtIndex(i).itemIcon;
                        comment["content"] = inputList.itemAtIndex(i).itemContent;
                        list.push(comment);
                    }
                    rectangle.parent.accepted(list);
                }
            }
        }
    }

    function addComment(name, icon, content) {
        inputModel.append({"name": name, "icon": icon, "content": content});
    }

    function cleanComments() {
        inputModel.clear();
    }

    function setComment(list) {
        cleanComments();
        if(typeof list === "object") {
            for(var i = 0; i < list.length; i++) {
                inputModel.append(list[i]);
            }
        }
        addComment("", "", "");
    }
}
