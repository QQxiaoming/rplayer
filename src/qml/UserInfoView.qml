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
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: width
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
            }
        }
    }

    function setInfo(info) {
        userImage.source = info["image"];
        userName.text = info["name"];
        userInfo.text = info["info"];
    }
}
