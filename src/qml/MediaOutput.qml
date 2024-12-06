import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtMultimedia

Item {
    implicitWidth : 1080
    implicitHeight : 1920

    property alias videoView: videoOutput
    property alias imageView: imageOutput

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
        visible: true
        z: 1

        Timer {
            id : timer
            interval: 3*1000
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
            timer.stop();
        }
    }
}
