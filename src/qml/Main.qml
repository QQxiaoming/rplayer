import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Window {
    id: root
    width: 1080
    height: 1920

    visible: true

    ToolBar {
        id: toolBar
        anchors.right: parent.right
        font.pixelSize: 60
        anchors.left: parent.left
        contentHeight: toolButton.implicitHeight
        z: 1

        ToolButton {
            id: toolButton
            contentItem: Text {
                id: toolButtonText
                text: stackView.depth > 1 ? "\u25C0" : "\u2630"
                color: "white"
                font: parent.font
                style: Text.Outline
                styleColor: "black"
            }
            background: Rectangle {
                color: toolButton.pressed ? "gray" : toolButton.hovered ? "gray" : "transparent"
            }
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop();
                } else {
                    drawer.open();
                }
            }
        }

        Rectangle {
            width: 440
            height: 70
            anchors.top: toolButton.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            TitleLabel {
                id : labelStar
                width: 120
                height: 70
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 0
                anchors.topMargin: 0
                text: "关注"
            }

            TitleLabel {
                id: labelLive
                width: 120
                height: 70
                anchors.left: labelStar.right
                anchors.top: parent.top
                anchors.leftMargin: 40
                anchors.topMargin: 0
                text: "直播"
            }

            TitleLabel {
                id: labelTrend
                width: 120
                height: 70
                anchors.left: labelLive.right
                anchors.top: parent.top
                anchors.leftMargin: 40
                anchors.topMargin: 0
                text: "推荐"
            }
        }

        background: Rectangle {
            color: "transparent"
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: videoView
    }

    VideoView {
        id: videoView
        onShowInfoDialog: function(info) {
            infoDialog.text = info;
            stackView.push(infoDialog);
        }
    }

    InputView {
        id: inputView
        visible: false
        onAccepted: {
            stackView.pop();
            videoView.readJsonUrl(inputView.inputText);
            var datetime = new Date();
            debugView.text = debugView.text + datetime.toLocaleString() + " - " + inputView.inputText + "\n";
        }
        onRejected: {
            stackView.pop();
        }
    }

    AboutView {
        id: aboutView
        visible: false
    }
    
    DebugView {
        id: debugView
        visible: false
        wrapMode: TextEdit.Wrap
    }

    DebugView {
        id: infoDialog
        readOnly: false
        visible: false
        onAccepted: function(str){
            videoView.writeInfo(str);
            stackView.pop();
        }
    }

    Component.onCompleted: {
        console.log("start app...");
    }

    FileDialog {
        id: jsonFileDialog
        title: qsTr("选择JSON文件")
        fileMode: FileDialog.OpenFile
        nameFilters: ["JSON文件 (*.json)"]
        onAccepted: {
            videoView.readJsonUrl(jsonFileDialog.selectedFile);
            var datetime = new Date();
            debugView.text = debugView.text + datetime.toLocaleString() + " - " + jsonFileDialog.selectedFile + "\n";
        }
    }

    FileDialog {
        id: videoFileDialog
        title: qsTr("选择视频文件")
        fileMode: FileDialog.OpenFile
        nameFilters: ["视频文件 (*.mp4 *.mkv *.avi)"]
        onAccepted: {
            var json = "{\"list\":[{\"path\":\"" + videoFileDialog.selectedFile + "\",\"title\":\"调试\",\"info\":\"调试\"}]}";
            videoView.readJsonUrl(json);
            var datetime = new Date();
            debugView.text = debugView.text + datetime.toLocaleString() + " - " + videoFileDialog.selectedFile + "\n";
        }
    }

    Drawer {
        id: drawer
        width: root.width * 0.5
        height: root.height
        background: Rectangle {
            color: "#363535"
        }

        property string color: "#f1f1f1"
        property int fontpixelSize: 60

        Column {
            anchors.fill: parent
            spacing: 10

            ItemDelegate {
                width: parent.width
                contentItem: Text {
                    text: qsTr("添加数据源（本地）")
                    color: drawer.color
                    font.pixelSize: drawer.fontpixelSize
                }
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    drawer.close();
                    jsonFileDialog.open();
                }
            }

            ItemDelegate {
                width: parent.width
                contentItem: Text {
                    text: qsTr("添加数据源（网络）")
                    color: drawer.color
                    font.pixelSize: drawer.fontpixelSize
                }
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    drawer.close();
                    stackView.push(inputView);
                }
            }

            ItemDelegate {
                width: parent.width
                contentItem: Text {
                    text: qsTr("添加视频（调试）")
                    color: drawer.color
                    font.pixelSize: drawer.fontpixelSize
                }
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    drawer.close();
                    videoFileDialog.open();
                }
            }

            ItemDelegate {
                width: parent.width
                contentItem: Text {
                    text: qsTr("关于")
                    color: drawer.color
                    font.pixelSize: drawer.fontpixelSize
                }
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    drawer.close();
                    stackView.push(aboutView);
                }
            }

            ItemDelegate {
                width: parent.width
                contentItem: Text {
                    text: qsTr("调试")
                    color: drawer.color
                    font.pixelSize: drawer.fontpixelSize
                }
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    drawer.close();
                    stackView.push(debugView);
                }
            }
        }
    }
}
