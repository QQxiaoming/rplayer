import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    property int slideThreshold: 100
    property int chickThreshold: 40
    property int currentIndex: 0
    property string jsonUrl: ""
    property var parsedData: []

    signal showInfoDialog(var info)

    function readJsonUrl(url) {
        var jsonData = jsonReader.readJsonUrl(url);
        if (jsonData && jsonData.list) {
            parsedData = Object.values(jsonData.list);
            if(parsedData.length) {
                parsedData.pop();
                parsedData.sort(() => Math.random() - 0.5);
                jsonUrl = url;
                currentIndex = 0;
                refreshVideo(true);
            }
        }
    }

    function updateJsonUrl(index) {
        if(jsonUrl) {
            jsonReader.updateJsonUrl(jsonUrl, parsedData[index]);
        }
    }

    function updateVideoInfo(str) {
        if(parsedData.length) {
            videoInfo.text = str;
            parsedData[currentIndex].info = str;
            updateJsonUrl(currentIndex);
        }
    }

    function refreshVideo(direction) {
        var video = parsedData[currentIndex];
        if(typeof video.type === "undefined") {
            videoPlayer.switchVideo("video",video.path,direction);
        } else {
            videoPlayer.switchVideo(video.type,video.path,direction);
        }
        videoTitle.text = video.title;
        videoInfo.text = video.info;
        if(typeof video.icon !== "undefined") {
            videoIcon.source = video.icon;
        } else {
            videoIcon.source = fontIcon ? fontIcon.getIcon("0xf110","Default",videoIcon.radius*2) : ""
        }
        if(typeof video.icon2 !== "undefined") {
            videoIcon2.source = video.icon2;
            videoIcon2.visible = true;
        } else {
            videoIcon2.visible = false;
        }
        if(typeof video.like === "undefined") {
            likeNum.text = Math.floor(Math.random() * (10000 - 1000 + 1)) + 1000;
        } else {
            likeNum.text = video.like;
        }
        if(typeof video.bookMark === "undefined") {
            bookMarkNum.text = Math.floor(Math.random() * (10000 - 1000 + 1)) + 1000;
        } else {
            bookMarkNum.text = video.bookMark;
        }
        if(typeof video.star === "undefined") {
            starNum.text = Math.floor(Math.random() * (10000 - 1000 + 1)) + 1000;
        } else {
            starNum.text = video.star;
        }
        likeIcon.holdHovered = false;
        bookMarkIcon.holdHovered = false;
        starIcon.holdHovered = false;
        likeIcon.refresh()
        bookMarkIcon.refresh()
        starIcon.refresh()
    }

    function hideUI(enable){
        var video = parsedData[currentIndex];
        if(typeof video.icon2 !== "undefined") {
            videoIcon2.visible = enable;
        } else {
            videoIcon2.visible = false;
        }
        videoIcon.visible = enable;
        likeIcon.visible = enable;
        bookMarkIcon.visible = enable;
        starIcon.visible = enable;
        infoIcon.visible = enable;
        videoTitleLabel.visible = enable;
        videoInfoLabel.visible = enable;
    }

    Rectangle {
        id: videoView
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.topMargin: 0
        color: "black"

        VideoPlayer {
            id: videoPlayer
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 0
            z: 1
            onFullScreened: function(fullScreen) {
                hideUI(!fullScreen);
            }
        }

        Icon {
            id: videoIcon
            y: 1104
            radius: 50
            anchors.left: videoInfoLabel.left
            anchors.bottom: videoInfoLabel.top
            anchors.leftMargin: 0
            anchors.bottomMargin: 20
            z: 1
            enablePressAnimation: false
            hoveredScale: 1.5

            RotationAnimator on rotation {
                from: 0
                to: 360
                duration: 5000
                running: true
                loops: Animation.Infinite
            }
        }

        Icon {
            id: videoIcon2
            radius: videoIcon.radius
            anchors.left: videoIcon.right
            anchors.bottom: videoIcon.bottom
            anchors.leftMargin: 40
            anchors.bottomMargin: 0
            z: 1
            enablePressAnimation: videoIcon.enablePressAnimation
            hoveredScale: videoIcon.hoveredScale
            visible: false

            RotationAnimator on rotation {
                from: 0
                to: 360
                duration: 5000
                running: true
                loops: Animation.Infinite
            }
        }

        Label {
            id : videoTitleLabel
            Text {
                id: videoTitle
                text: "\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_"
                color: "white"
                textFormat: Text.MarkdownText
                font.pixelSize: 60
                style: Text.Outline
                styleColor: "black"
            }
            anchors.left: videoIcon2.visible ? videoIcon2.right : videoIcon.right
            anchors.right: videoInfoLabel.right
            anchors.top: videoIcon2.visible ? videoIcon2.top : videoIcon.top
            anchors.leftMargin: 20
            anchors.rightMargin: 0
            anchors.topMargin: 0
            height: videoIcon.radius*2
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.capitalization: Font.Capitalize
            z: 1
        }

        Label {
            id : videoInfoLabel
            Text {
                id: videoInfo
                text: "\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\n\n\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\n\n\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\n\n\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\n\n"
                color: "white"
                textFormat: Text.MarkdownText
                font.pixelSize: 40
                font.capitalization: Font.Capitalize
                style: Text.Outline
                styleColor: "black"
            }
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            anchors.topMargin: -320
            anchors.bottomMargin: 50
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            z: 1
        }

        Icon {
            id: infoIcon
            radius: 50
            anchors.right: videoInfoLabel.right
            anchors.rightMargin: 20
            anchors.bottom: videoInfoLabel.bottom
            anchors.bottomMargin: 50
            z: 1
            codePoint: "0xf007"
            enableHover: true
            hoveredColor: "#1abc9c"
            borderWidth : 0
            Rectangle {
                height: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 4
                color: "transparent"
                Label {
                    anchors.fill: parent
                    text: "详情"
                    color: "white"
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    style: Text.Outline
                    styleColor: "black"
                    font.capitalization: Font.Capitalize
                }
            }
            onClicked: {
                if(parsedData.length) {
                    videoView.parent.showInfoDialog(parsedData[currentIndex].info);
                }
            }
        }

        Icon {
            id: likeIcon
            radius: 50
            anchors.right: infoIcon.right
            anchors.rightMargin: 0
            anchors.bottom: infoIcon.top
            anchors.bottomMargin: 50
            z: 1
            codePoint: "0xf004"
            enableHover: true
            hoveredColor: "#e74c3c"
            borderWidth : 0
            Rectangle {
                height: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 4
                color: "transparent"
                Label {
                    id: likeNum
                    anchors.fill: parent
                    text: "0"
                    color: "white"
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    style: Text.Outline
                    styleColor: "black"
                    font.capitalization: Font.Capitalize
                }
            }
            onClicked: {
                if(parsedData.length) {
                    var curr = parseInt(likeNum.text);
                    if(holdHovered) {
                        likeNum.text = curr-1;
                    } else {
                        likeNum.text = curr+1;
                    }
                    parsedData[currentIndex].like = parseInt(likeNum.text);
                    updateJsonUrl(currentIndex);
                    holdHovered = !holdHovered;
                }
            }
        }

        Icon {
            id: bookMarkIcon
            radius: 50
            anchors.right: infoIcon.right
            anchors.rightMargin: 0
            anchors.bottom: likeIcon.top
            anchors.bottomMargin: 50
            z: 1
            codePoint: "0xf006"
            enableHover: true
            hoveredColor: "#3498db"
            borderWidth : 0
            Rectangle {
                height: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 4
                color: "transparent"
                Label {
                    id: bookMarkNum
                    anchors.fill: parent
                    text: "0"
                    color: "white"
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    style: Text.Outline
                    styleColor: "black"
                    font.capitalization: Font.Capitalize
                }
            }
            onClicked: {
                if(parsedData.length) {
                    var curr = parseInt(bookMarkNum.text);
                    if(holdHovered) {
                        bookMarkNum.text = curr-1;
                    } else {
                        bookMarkNum.text = curr+1;
                    }
                    parsedData[currentIndex].bookMark = parseInt(bookMarkNum.text);
                    updateJsonUrl(currentIndex);
                    holdHovered = !holdHovered;
                }
            }
        }

        Icon {
            id: starIcon
            radius: 50
            anchors.right: infoIcon.right
            anchors.rightMargin: 0
            anchors.bottom: bookMarkIcon.top
            anchors.bottomMargin: 50
            z: 1
            codePoint: "0xf087"
            enableHover: true
            hoveredColor: "#f1c40f"
            borderWidth : 0
            Rectangle {
                height: 40
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 4
                color: "transparent"
                Label {
                    id: starNum
                    anchors.fill: parent
                    text: "0"
                    color: "white"
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    style: Text.Outline
                    styleColor: "black"
                    font.capitalization: Font.Capitalize
                }
            }
            onClicked: {
                if(parsedData.length) {
                    var curr = parseInt(starNum.text);
                    if(holdHovered) {
                        starNum.text = curr-1;
                    } else {
                        starNum.text = curr+1;
                    }
                    parsedData[currentIndex].star = parseInt(starNum.text);
                    updateJsonUrl(currentIndex);
                    holdHovered = !holdHovered;
                }
            }
        }

        MultiPointTouchArea {
            id: multiPointTouchArea
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 0
            onReleased: function(touchPoints) {
                if (touchPoints.length === 1) {
                    var touchPoint = touchPoints[0];
                    if(parsedData.length) {
                        if ((touchPoint.x - touchPoint.startX < chickThreshold)&&
                            (touchPoint.x - touchPoint.startX > -chickThreshold)&&
                            (touchPoint.y - touchPoint.startY < chickThreshold)&&
                            (touchPoint.y - touchPoint.startY > -chickThreshold) ){
                            videoPlayer.pause();
                            return;
                        }
                        if(videoPlayer.fullScreen) {
                            if (touchPoint.x - touchPoint.startX > slideThreshold) {
                                videoPlayer.exitFullScreen();
                                return;
                            }
                        } else {
                            if(videoPlayer.paused) {
                                return;
                            }
                            if (touchPoint.startY - touchPoint.y > slideThreshold) {
                                // Slide up to play next video
                                currentIndex = (currentIndex + 1) % parsedData.length;
                                refreshVideo(true);
                                return;
                            } else if (touchPoint.y - touchPoint.startY > slideThreshold) {
                                // Slide down to play previous video
                                currentIndex = (currentIndex - 1 + parsedData.length) % parsedData.length;
                                refreshVideo(false);
                                return;
                            }
                        }
                    }
                }
            }
        }
    }
}
