import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    property bool enableFullScreen: false
    property alias fullScreen: videoOutputFull.visible

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
            console.log("FullScreen");
            var currentVideoOutput = stackView.currentItem;
            var currentPlayer = (currentVideoOutput === videoOutput1) ? mediaPlayer1 : mediaPlayer2;
            currentPlayer.videoOutput = videoOutputFull;
            videoOutputFull.visible = true;
            buttonFullScreen.visible = false;
            stackView.visible = false;
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: videoOutput1

        property bool direction: true

        MediaDevices {
            id: devices
        }

        AudioOutput {
            id: audioOutput
            device: devices.defaultAudioOutput
        }

        VideoOutput {
            id: videoOutput1
        }

        VideoOutput {
            id: videoOutput2
        }

        MediaPlayer {
            id: mediaPlayer1
            autoPlay: true
            loops: MediaPlayer.Infinite
            videoOutput: videoOutput1
            audioOutput: audioOutput
        }

        MediaPlayer {
            id: mediaPlayer2
            autoPlay: true
            loops: MediaPlayer.Infinite
            videoOutput: videoOutput2
            audioOutput: null
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

    function switchVideo(source, direction, enableFullScreen) {
        var currentVideoOutput = stackView.currentItem;
        var nextVideoOutput = (currentVideoOutput === videoOutput1) ? videoOutput2 : videoOutput1;
        var nextPlayer = (currentVideoOutput === videoOutput1) ? mediaPlayer2 : mediaPlayer1;
        var currentPlayer = (currentVideoOutput === videoOutput1) ? mediaPlayer1 : mediaPlayer2;
        nextPlayer.source = source;
        nextPlayer.play();
        buttonFullScreen.visible = enableFullScreen;
        currentPlayer.audioOutput = null;
        nextPlayer.audioOutput = audioOutput;
        stackView.direction = direction;
        stackView.replace(currentVideoOutput, nextVideoOutput);
    }

    function exitFullScreen() {
        var currentVideoOutput = stackView.currentItem;
        var currentPlayer = (currentVideoOutput === videoOutput1) ? mediaPlayer1 : mediaPlayer2;
        currentPlayer.videoOutput = currentVideoOutput;
        videoOutputFull.visible = false;
        buttonFullScreen.visible = true;
        stackView.visible = true;
    }
}
