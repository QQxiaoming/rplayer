import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    property bool enableFullScreen: false
    property alias fullScreen: videoOutputFull.visible
    property alias paused: pauseIcon.visible

    signal fullScreened(var info)

    MediaDevices {
        id: devices
    }

    AudioOutput {
        id: audioOutput
        device: devices.defaultAudioOutput
    }

    Button {
        id: buttonFullScreen
        width: 380
        height: 120
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 500
        visible: false
        z: 1
        contentItem: Text {
            text: "全屏"
            anchors.fill: parent
            color: "white"
            font.pixelSize: 60
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: buttonFullScreen.pressed ? "gray" : buttonFullScreen.hovered ? "gray" : "transparent"
        }
        onClicked: {
            var currentMediaOutput = stackView.currentItem;
            var currentPlayer = (currentMediaOutput === mediaOutput1) ? mediaPlayer1 : mediaPlayer2;
            currentPlayer.videoOutput = videoOutputFull;
            videoOutputFull.visible = true;
            buttonFullScreen.visible = false;
            stackView.visible = false;
            pauseIcon.orientation =  videoOutputFull.orientation;
            fullScreened(true);
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mediaOutput1

        property bool direction: true

        MediaOutput {
            id: mediaOutput1
        }

        MediaOutput {
            id: mediaOutput2
        }

        MediaPlayer {
            id: mediaPlayer1
            autoPlay: true
            loops: MediaPlayer.Infinite
            videoOutput: mediaOutput1.videoView
            audioOutput: audioOutput
            onMetaDataChanged: updateMetadata()
        }

        MediaPlayer {
            id: mediaPlayer2
            autoPlay: true
            loops: MediaPlayer.Infinite
            videoOutput: mediaOutput2.videoView
            audioOutput: null
            onMetaDataChanged: updateMetadata()
        }

        replaceEnter: Transition {
            YAnimator {
                from: (stackView.direction ? -1 : 1) * -stackView.height
                to: 0
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
        replaceExit: Transition {
            YAnimator {
                from: 0
                to: (stackView.direction ? -1 : 1) * stackView.height
                duration: 400
                easing.type: Easing.OutCubic
            }
        }
    }

    VideoOutput {
        id: videoOutputFull
        anchors.fill: parent
        visible: false
        z: 1
        orientation: -90
    }

    Icon {
        id: pauseIcon
        codePoint: "0xf04b"
        anchors.centerIn: parent
        radius: parent.width/4
        borderWidth: 10
        hoveredBackColor: "transparent"
        visible: false
        z: 2
        onClicked :{
            pause();
        }
    }

    function switchVideo(type, source, direction) {
        var currentMediaOutput = stackView.currentItem;
        var nextMediaOutput = (currentMediaOutput === mediaOutput1) ? mediaOutput2 : mediaOutput1;
        var nextPlayer = (currentMediaOutput === mediaOutput1) ? mediaPlayer2 : mediaPlayer1;
        var currentPlayer = (currentMediaOutput === mediaOutput1) ? mediaPlayer1 : mediaPlayer2;
        if(type === "video") {
            nextMediaOutput.videoView.visible = true;
            nextMediaOutput.imageView.visible = false;
            nextPlayer.source = source;
            nextPlayer.play();
            currentPlayer.audioOutput = null;
            nextPlayer.audioOutput = audioOutput;
            stackView.direction = direction;
            stackView.replace(currentMediaOutput, nextMediaOutput);
            updateMetadata();
        } else if(type === "image") {
            nextMediaOutput.imageView.visible = true;
            nextMediaOutput.videoView.visible = false;
            currentMediaOutput.imageView.stop();
            nextMediaOutput.imageView.play(source);
            currentPlayer.audioOutput = null;
            nextPlayer.audioOutput = null;
            stackView.direction = direction;
            stackView.replace(currentMediaOutput, nextMediaOutput);
            buttonFullScreen.visible = false;
        }
    }

    function pause() {
        var currentMediaOutput = stackView.currentItem;
        var currentPlayer = (currentMediaOutput === mediaOutput1) ? mediaPlayer1 : mediaPlayer2;
        if(currentPlayer.playing) {
            currentPlayer.pause();
            pauseIcon.visible = true
        } else {
            currentPlayer.play();
            pauseIcon.visible = false
        }
    }

    function exitFullScreen() {
        var currentMediaOutput = stackView.currentItem;
        var currentPlayer = (currentMediaOutput === mediaOutput1) ? mediaPlayer1 : mediaPlayer2;
        currentPlayer.videoOutput = currentMediaOutput;
        videoOutputFull.visible = false;
        buttonFullScreen.visible = true;
        stackView.visible = true;
        pauseIcon.orientation = 0;
        fullScreened(false);
    }

    function updateMetadata() {
        var currentMediaOutput = stackView.currentItem;
        var currentPlayer = (currentMediaOutput === mediaOutput1) ? mediaPlayer1 : mediaPlayer2;
        if (currentPlayer.metaData) {
            var metaData = currentPlayer.metaData;
            for (var key of metaData.keys()) {
                if (metaData.metaDataKeyToString(key) === "Resolution") {
                    var videoWidth = metaData.stringValue(key).split("x")[0];
                    var videoHeight = metaData.stringValue(key).split("x")[1];
                    buttonFullScreen.visible = (videoWidth/videoHeight > 1.5);
                    break;
                }
            }
         }
    }
}
