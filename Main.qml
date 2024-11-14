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
                text: "\u2630"
                color: "white"
                font: parent.font
                style: Text.Outline
                styleColor: "black"
            }
            background: Rectangle {
                color: toolButton.hovered ? "gray" : "transparent"
            }
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop();
                    drawer.open();
                } else {
                    drawer.open();
                }
            }
        }

        Label {
            id : label1
            width: 120
            anchors.left: parent.left
            anchors.top: toolButton.top
            anchors.leftMargin: 360
            anchors.topMargin: 10
            Text {
                text: "关注"
                color: "white"
                font.pixelSize: 60
                style: Text.Outline
                styleColor: "black"
            }
        }

        Label {
            id: label2
            width: 120
            anchors.left: label1.right
            anchors.top: toolButton.top
            anchors.leftMargin: 40
            anchors.topMargin: 10
            Text {
                text: "直播"
                color: "white"
                font.pixelSize: 60
                style: Text.Outline
                styleColor: "black"
            }
        }

        Label {
            id: label3
            width: 120
            anchors.left: label2.right
            anchors.top: toolButton.top
            anchors.leftMargin: 40
            anchors.topMargin: 10
            Text {
                text: "推荐"
                color: "white"
                font.pixelSize: 60
                style: Text.Outline
                styleColor: "black"
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
    }

    Component.onCompleted: {
        console.log("start app...");
    }

    FileDialog {
        id: fileDialog
        title: qsTr("选择JSON文件")
        fileMode: FileDialog.OpenFile
        nameFilters: ["JSON文件 (*.json)"]
        onAccepted: {
            videoView.readJsonUrl(fileDialog.selectedFile);
            var datetime = new Date();
            debugView.text = debugView.text + datetime.toLocaleString() + " - " + fileDialog.selectedFile + "\n";
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
                    fileDialog.open();
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
