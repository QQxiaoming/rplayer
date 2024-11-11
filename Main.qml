import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtMultimedia 6.5

ApplicationWindow {
    visible: true
    width: 540
    height: 720
    title: qsTr("Video Player")

    property int slideThreshold: 100
    property int currentIndex: 0
    property var videoSources: []

    Video {
        id: videoPlayer
        anchors.fill: parent
        autoPlay: true
        loops: MediaPlayer.Infinite

        onPlaying: {
            if(videoSources.length) {
                videoName.text = videoSources[currentIndex]
            }
        }
    }

    Text {
        id: videoName
        color: "white"
        font.pixelSize: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        z: 1
    }

    MultiPointTouchArea {
        anchors.fill: parent
        onReleased: function(touchPoints) {
            if (touchPoints.length === 1) {
                var touchPoint = touchPoints[0];
                if(videoSources.length) {
                    if (touchPoint.startY - touchPoint.y > slideThreshold) {
                        // Slide up to play next video
                        currentIndex = (currentIndex + 1) % videoSources.length;
                        videoPlayer.source = videoSources[currentIndex];
                        videoPlayer.play();
                        console.log("next video");
                    } else if (touchPoint.y - touchPoint.startY > slideThreshold) {
                        // Slide down to play previous video
                        currentIndex = (currentIndex - 1 + videoSources.length) % videoSources.length;
                        videoPlayer.source = videoSources[currentIndex];
                        videoPlayer.play();
                        console.log("previous video");
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Select Video File")
        fileMode: FileDialog.OpenFiles
        nameFilters: ["Video files (*.mp4 *.avi *.mkv)"]
        onAccepted: {
            for (var i = 0; i < fileDialog.selectedFiles.length; i++) {
                videoSources.push(fileDialog.selectedFiles[i]);
            }
            currentIndex = videoSources.length - 1
            videoPlayer.source = videoSources[currentIndex];
            console.log("Current video source: " + videoSources[currentIndex]);
            videoPlayer.play();
        }
    }

    Button {
        text: qsTr("Open Video")
        anchors.top: parent.top
        anchors.left: parent.left
        onClicked: fileDialog.open()
    }
}
