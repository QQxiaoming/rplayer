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
            var currentPlayer = currentMediaOutput.player;
            currentPlayer.videoOutput = videoOutputFull;
            videoOutputFull.visible = true;
            buttonFullScreen.visible = false;
            stackView.visible = false;
            pauseIcon.orientation =  videoOutputFull.angle;
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
            property alias player: mediaPlayer1
        }

        MediaOutput {
            id: mediaOutput2
            property alias player: mediaPlayer2
        }

        MediaPlayer {
            id: mediaPlayer1
            property alias output: mediaOutput1
            autoPlay: true
            loops: MediaPlayer.Infinite
            videoOutput: mediaOutput1.videoView
            audioOutput: audioOutput
            onMetaDataChanged: updateMetadata()
        }

        MediaPlayer {
            id: mediaPlayer2
            property alias output: mediaOutput2
            autoPlay: true
            loops: MediaPlayer.Infinite
            videoOutput: mediaOutput2.videoView
            audioOutput: null
            onMetaDataChanged: updateMetadata()
        }

        Slider {
            property var player: mediaPlayer1
            id: progressBar
            width: parent.width-20
            height: pressed ? 60 : 30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: pressed ? 15 : 30
            from: 0
            to: player.duration
            value: player.position
            visible: false
            onMoved: {
                player.position = value
            }
            background: Rectangle {
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                width: parent.availableWidth
                height: parent.height / 5
                color: "gray"
                Rectangle {
                    width: parent.width *  parent.parent.visualPosition
                    height: parent.height
                    color: "white"
                }
            }
            handle: Rectangle {
                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                width: parent.height / 2
                height: width
                radius: width / 2
                color: "white"
                border.color: parent.pressed ? "black" : "white"
            }
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
        property int angle: -90

        id: videoOutputFull
        anchors.fill: parent
        visible: false
        z: 1
        
        orientation: Qt.platform.os !== "ios" ? videoOutputFull.angle : 0
        scale: Qt.platform.os === "ios" ? videoOutputFull.height / videoOutputFull.width : 1
        rotation: Qt.platform.os === "ios" ? videoOutputFull.angle : 0

    }

    Slider {
        property var player: mediaPlayer1
        id: progressBarFull
        width: pressed ? 60 : 30
        height: parent.height-20
        anchors.right: parent.right
        anchors.rightMargin: pressed ? 15 : 30
        from: 0
        to: player.duration
        value: player.position
        visible: videoOutputFull.visible
        z: 1
        orientation: Qt.Vertical
        onMoved: {
            player.position = value
        }
        background: Rectangle {
            x: parent.leftPadding + parent.availableWidth / 2 - width / 2
            height: parent.availableHeight
            width: parent.width / 5
            color: "white"
            Rectangle {
                height: parent.height * parent.parent.visualPosition
                width: parent.width
                color: "gray"
            }
        }
        handle: Rectangle {
            y: parent.topPadding + parent.visualPosition * (parent.availableHeight - height)
            x: parent.leftPadding + parent.availableWidth / 2 - width / 2
            width: parent.width / 2
            height: width
            radius: width / 2
            color: "white"
            border.color: parent.pressed ? "black" : "white"
        }
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
        var nextPlayer = nextMediaOutput.player;
        var currentPlayer = currentMediaOutput.player;
        if(type === "video") {
            nextMediaOutput.videoView.visible = true;
            nextMediaOutput.imageView.visible = false;
            progressBar.enabled = true;
            progressBar.visible = true;
            progressBar.player = nextPlayer;
            progressBarFull.enabled = true;
            progressBarFull.player = nextPlayer;
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
            progressBar.visible = false;
            progressBar.enabled = false;
            progressBarFull.enabled = false;
            currentMediaOutput.imageView.stop();
            nextMediaOutput.imageView.play(source);
            currentPlayer.audioOutput = null;
            nextPlayer.audioOutput = null;
            stackView.direction = direction;
            stackView.replace(currentMediaOutput, nextMediaOutput);
            buttonFullScreen.visible = false;
        }
    }

    function switchImage(next) {
        var currentMediaOutput = stackView.currentItem;
        if(currentMediaOutput.imageView.visible) {
            currentMediaOutput.imageView.next(next);
        }
    }

    function pause() {
        var currentMediaOutput = stackView.currentItem;
        var currentPlayer = currentMediaOutput.player;
        if(currentPlayer.playing) {
            currentPlayer.pause();
            currentMediaOutput.imageView.pause();
            pauseIcon.visible = true
        } else {
            currentPlayer.play();
            currentMediaOutput.imageView.play();
            pauseIcon.visible = false
        }
    }

    function exitFullScreen() {
        var currentMediaOutput = stackView.currentItem;
        var currentPlayer = currentMediaOutput.player;
        currentPlayer.videoOutput = currentMediaOutput.videoView;
        videoOutputFull.visible = false;
        buttonFullScreen.visible = true;
        stackView.visible = true;
        pauseIcon.orientation = 0;
        fullScreened(false);
    }

    function updateMetadata() {
        var currentMediaOutput = stackView.currentItem;
        var currentPlayer = currentMediaOutput.player;
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
