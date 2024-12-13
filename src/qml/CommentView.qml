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
                spacing: 10
                delegate: CommentItem {
                    width: rectangle.parent.width
                    inputIcon: icon
                    inputName: name
                    inputContent: content
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
