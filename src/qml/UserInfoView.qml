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
        }
    }

    function setInfo(info) {
        userImage.sourceList = info["image"];
        userName.text = info["name"];
        userInfo.text = info["info"];
    }
}
