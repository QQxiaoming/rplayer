import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: videoPlayer1

        property bool direction: true

        Video {
            id: videoPlayer1
            autoPlay: true
            loops: MediaPlayer.Infinite
        }

        Video {
            id: videoPlayer2
            autoPlay: true
            loops: MediaPlayer.Infinite
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
        var currentVideo = stackView.currentItem;
        var nextVideo = (currentVideo === videoPlayer1) ? videoPlayer2 : videoPlayer1;
        nextVideo.source = source;
        nextVideo.play();
        stackView.direction = direction;
        stackView.replace(currentVideo, nextVideo);
    }
}
