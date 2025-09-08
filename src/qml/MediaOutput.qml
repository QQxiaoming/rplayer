import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtMultimedia

Item {
    implicitWidth : 1080
    implicitHeight : 1920

    property alias videoView: videoOutput
    property alias imageView: imageOutput
    property real playbackRate: 1.0

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
        visible: false
        z: 1
    }

    Image {
        property var sourceList : []
        property int index : 0
        property bool start : false

        id: imageOutput
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: false
        z: 1

        Rectangle {
            id: mask
            width: parent.width-20
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            color: "transparent"

            Row {
                Repeater {
                    model: imageOutput.sourceList.length?imageOutput.sourceList.length:1
                    Rectangle {
                        width: mask.width / imageOutput.sourceList.length
                        height: mask.height
                        color: "white"
                        border.color: "black"
                        radius: 10
                        z: 2
                        opacity: index == (imageOutput.index-1) ? 1.0 : 0.3
                        MultiPointTouchArea {
                            anchors.fill: parent
                            enabled: imageOutput.visible
                            onReleased: function(touchPoints) {
                                if (touchPoints.length === 1) {
                                    imageOutput.index = index;
                                    imageOutput.source = imageOutput.sourceList[imageOutput.index];
                                    imageOutput.index = imageOutput.index + 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        Timer {
            id : timer
            interval: 3*1000/imageOutput.parent.playbackRate
            repeat: true
            onTriggered: {
                if(start && imageOutput.sourceList.length) {
                    var list = imageOutput.sourceList;
                    if(imageOutput.index >= list.length) {
                        imageOutput.index = 0;
                    }
                    imageOutput.source = list[imageOutput.index];
                    imageOutput.index = imageOutput.index + 1;
                }
            }
        }

        function next(direction) {
            if(start && imageOutput.sourceList.length) {
                var list = imageOutput.sourceList;
                if(direction) {
                    if(imageOutput.index >= list.length) {
                        imageOutput.index = 0;
                    }
                    imageOutput.source = list[imageOutput.index];
                    imageOutput.index = imageOutput.index + 1;
                } else {
                    if(imageOutput.index - 2 < 0) {
                        imageOutput.index = list.length-1;
                    } else {
                        imageOutput.index = imageOutput.index - 2;
                    }
                    imageOutput.source = list[imageOutput.index];
                    imageOutput.index = imageOutput.index + 1;
                }
            }
        }

        function play() {
            if (arguments.length === 0) {
                timer.start();
            } else if (arguments.length === 1) {
                var source = arguments[0];
                imageOutput.sourceList = source;
                imageOutput.source = source[0];
                imageOutput.index = 1;
                imageOutput.start = true;
                timer.start();
            } else {
                console.error("Invalid arguments for play function");
            }
        }

        function pause() {
            timer.stop();
        }

        function stop() {
            imageOutput.index = 0
            imageOutput.start = false
            imageOutput.source = ""
            imageOutput.sourceList = []
            timer.stop();
        }
    }
}
