import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
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

    function switchVideo(source, direction) {
        var currentVideoOutput = stackView.currentItem;
        var nextVideoOutput = (currentVideoOutput === videoOutput1) ? videoOutput2 : videoOutput1;
        var nextPlayer = (currentVideoOutput === videoOutput1) ? mediaPlayer2 : mediaPlayer1;
        var currentPlayer = (currentVideoOutput === videoOutput1) ? mediaPlayer1 : mediaPlayer2;
        nextPlayer.source = source;
        nextPlayer.play();
        currentPlayer.audioOutput = null;
        nextPlayer.audioOutput = audioOutput;
        stackView.direction = direction;
        stackView.replace(currentVideoOutput, nextVideoOutput);
    }
}
