import QtQuick
import QtQuick.Controls

Item {
    implicitHeight : 1920
    implicitWidth : 1080

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

            Image {
                id: userImage
                property var sourceList : [""]
                property int index : 0
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: width
                fillMode: Image.PreserveAspectFit
                source: userImage.sourceList[userImage.index]
                
                MultiPointTouchArea {
                    anchors.fill: parent
                    enabled: true
                    onReleased: function(touchPoints) {
                        if (userImage.sourceList.length <= 1) {
                            return;
                        }
                        if (touchPoints.length === 1) {
                            var touchPoint = touchPoints[0];
                            if(touchPoint.startX - touchPoint.x > 100) {
                                userImage.index = userImage.index + 1;
                                if(userImage.index >= userImage.sourceList.length) {
                                    userImage.index = 0;
                                }
                                userImage.source = userImage.sourceList[userImage.index];
                            } else if(touchPoint.startX - touchPoint.x < -100) {
                                userImage.index = userImage.index - 1;
                                if(userImage.index < 0) {
                                    userImage.index = userImage.sourceList.length - 1;
                                }
                                userImage.source = userImage.sourceList[userImage.index];
                            }
                        }
                    }
                }
            }

            Text {
                id: userName
                anchors.top: userImage.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "white"
                font.pixelSize: 70
            }

            Text {
                id: userInfo
                anchors.top: userName.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "white"
                font.pixelSize: 50
                wrapMode: Text.WrapAnywhere
            }

            ListView {
                id: userAttr
                anchors.top: userInfo.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 200
                model: ListModel {
                }
                delegate: Item {
                    width: userAttr.width
                    height: 50
                    Row {
                        spacing: 10
                        Text { text: model.name; color: "white"; font.pixelSize: 30 }
                        Text { text: model.value; color: "white"; font.pixelSize: 30 }
                    }
                }
            }
        }
    }

    function setInfo(info) {
        userImage.sourceList = info["image"];
        userName.text = info["name"];
        userInfo.text = info["info"];
        userAttr.model.clear();
        for (var i = 0; i < info["attr"].length; i++) {
            userAttr.model.append({ name: info["attr"][i]["name"], value: info["attr"][i]["value"] });
        }
        if (userImage.sourceList.length > 0) {
            userImage.index = 0;
            userImage.source = userImage.sourceList[userImage.index];
        } else {
            userImage.index = 0;
            userImage.source = "";
        }
    }
}
