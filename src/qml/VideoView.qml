import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    property int slideThreshold: 100
    property int chickThreshold: 40
    property int currentIndex: 0
    property string mediaJsonUrl: ""
    property string userJsonUrl: ""
    property string filtered_title: ""
    property string currMediaJsonDirUrl: ""
    property string currUserName: ""
    property var mediaData: []
    property var userData: []

    signal showInfoDialog(var title, var info)
    signal showUserInfoDialog(var info)
    signal showCommentDialog(var info)
    signal fullScreened(var enable)

    function showNotification(mainTitle, subTitle, themeColor) {
        notification.mainTitle = mainTitle;
        notification.subTitle = subTitle;
        notification.themeColor = themeColor;
        notification.opacity = 1.0;
        notificationTimer.restart();
    }

    function readMediaJsonUrl(url) {
        var jsonData = rPlayerDataReader.readJsonUrl(url);
        if (jsonData && jsonData.list) {
            mediaData = Object.values(jsonData.list);
            if(mediaData.length) {
                mediaData.pop();
                mediaData.sort(() => Math.random() - 0.5);
                mediaJsonUrl = url;
                currentIndex = 0;
                refreshVideo(true);
                var path = new URL(url).pathname;
                currMediaJsonDirUrl = path.substring(0, path.lastIndexOf("/"));
                showNotification("媒体数据加载成功", "已加载 " + mediaData.length + " 个媒体文件", "#34d399");
            } else {
                showNotification("媒体数据为空", "未找到可播放的媒体内容", "#f59e0b");
            }
        } else {
            showNotification("媒体数据加载失败", "无法解析媒体JSON文件", "#ef4444");
        }
    }

    function readUserJsonUrl(url) {
        var jsonData = rPlayerDataReader.readJsonUrl(url,currMediaJsonDirUrl);
        if (jsonData && jsonData.list) {
            userData = Object.values(jsonData.list);
            if(userData.length) {
                userData.pop();
                userJsonUrl = url;
                currUserName = userData[0].name;
                showNotification("用户数据加载成功", "已登录用户：" + (userData[0].name || "未知用户"), "#3b82f6");
                if(mediaData.length) {
                    var video = mediaData[currentIndex];
                    if(typeof userData[0].like !== "undefined") {
                        if(typeof video.path === "string") {
                            if(userData[0].like.indexOf(video.path) !== -1) {
                                likeIcon.holdHovered = true;
                            }
                        } else {
                            if(userData[0].like.indexOf(video.path[0]) !== -1) {
                                likeIcon.holdHovered = true;
                            }
                        }
                    }
                    if(typeof userData[0].bookMark !== "undefined") {
                        if(typeof video.path === "string") {
                            if(userData[0].bookMark.indexOf(video.path) !== -1) {
                                bookMarkIcon.holdHovered = true;
                            }
                        } else {
                            if(userData[0].bookMark.indexOf(video.path[0]) !== -1) {
                                bookMarkIcon.holdHovered = true;
                            }
                        }
                    }
                    if(typeof userData[0].star !== "undefined") {
                        if(typeof video.path === "string") {
                            if(userData[0].star.indexOf(video.path) !== -1) {
                                starIcon.holdHovered = true;
                            }
                        } else {
                            if(userData[0].star.indexOf(video.path[0]) !== -1) {
                                starIcon.holdHovered = true;
                            }
                        }
                    }
                    likeIcon.refresh()
                    bookMarkIcon.refresh()
                    starIcon.refresh()
                }
            } else {
                showNotification("用户数据为空", "用户配置文件无效", "#f59e0b");
            }
        } else {
            showNotification("用户数据加载失败", "无法解析用户JSON文件", "#ef4444");
        }
    }

    function updateMediaJsonUrl(index) {
        if(mediaJsonUrl) {
            rPlayerDataReader.updateMediaJsonUrl(mediaJsonUrl, mediaData[index]);
        }
    }

    function updateUserJsonUrl() {
        if(userJsonUrl) {
            var saveData = JSON.parse(JSON.stringify(userData))
            if(saveData.length) {
                for(var i = 0; i < saveData[0]["like"].length; i++) {
                    if(typeof saveData[0]["like"][i] === "string") {
                        saveData[0]["like"][i] = saveData[0]["like"][i].replace(currMediaJsonDirUrl, "{JSON_PATH}");
                    }
                }
                for(var i = 0; i < saveData[0]["bookMark"].length; i++) {
                    if(typeof saveData[0]["bookMark"][i] === "string") {
                        saveData[0]["bookMark"][i] = saveData[0]["bookMark"][i].replace(currMediaJsonDirUrl, "{JSON_PATH}");
                    }
                }
                for(var i = 0; i < saveData[0]["star"].length; i++) {
                    if(typeof saveData[0]["star"][i] === "string") {
                        saveData[0]["star"][i] = saveData[0]["star"][i].replace(currMediaJsonDirUrl, "{JSON_PATH}");
                    }
                }
                for(var i = 0; i < saveData[0]["image"].length; i++) {
                    if(typeof saveData[0]["image"][i] === "string") {
                        saveData[0]["image"][i] = saveData[0]["image"][i].replace(currMediaJsonDirUrl, "{JSON_PATH}");
                    }
                }
            }
            rPlayerDataReader.updateUserJsonUrl(userJsonUrl, saveData[0]);
        }
    }

    function updateUserList(item,enable) {
        if(enable) {
            if(userData.length) {
                if(typeof userData[0][item] === "undefined") {
                    userData[0][item] = [];
                }
                if(typeof mediaData[currentIndex].path === "string") {
                    if(userData[0][item].indexOf(mediaData[currentIndex].path) === -1) {
                        userData[0][item].push(mediaData[currentIndex].path);
                    }
                } else {
                    if(userData[0][item].indexOf(mediaData[currentIndex].path[0]) === -1) {
                        userData[0][item].push(mediaData[currentIndex].path[0]);
                    }
                }
                updateUserJsonUrl();
            }
        } else {
            if(userData.length) {
                if(typeof userData[0][item] !== "undefined") {
                    if(typeof mediaData[currentIndex].path === "string") {
                        var index = userData[0][item].indexOf(mediaData[currentIndex].path);
                        if(index !== -1) {
                            userData[0][item].splice(index, 1);
                        }
                    } else {
                        var index = userData[0][item].indexOf(mediaData[currentIndex].path[0]);
                        if(index !== -1) {
                            userData[0][item].splice(index, 1);
                        }
                    }
                    updateUserJsonUrl();
                }
            }
        }
    }

    function updateVideoInfo(title,info) {
        if(mediaData.length) {
            videoTitle.text = title;
            videoInfo.text = info;
            mediaData[currentIndex].info = info;
            mediaData[currentIndex].title = title;
            updateMediaJsonUrl(currentIndex);
            showNotification("信息已更新", "视频信息保存成功", "#10b981");
        }
    }

    function updateVideoComment(list) {
        if(mediaData.length) {
            mediaData[currentIndex].comment = list;
            updateMediaJsonUrl(currentIndex);
            showNotification("评论已更新", "共 " + list.length + " 条评论", "#8b5cf6");
        }
    }

    function refreshVideo(direction) {
        var video = mediaData[currentIndex];
        if(typeof video.type === "undefined") {
            videoPlayer.switchVideo("video",{"path": video.path, "audio": null},direction);
        } else {
            videoPlayer.switchVideo(video.type,{"path": video.path, "audio": video.audio},direction);
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
        if(userData.length) {
            if(typeof userData[0].like !== "undefined") {
                if(typeof video.path === "string") {
                    if(userData[0].like.indexOf(video.path) !== -1) {
                        likeIcon.holdHovered = true;
                    }
                } else {
                    if(userData[0].like.indexOf(video.path[0]) !== -1) {
                        likeIcon.holdHovered = true;
                    }
                }
            }
            if(typeof userData[0].bookMark !== "undefined") {
                if(typeof video.path === "string") {
                    if(userData[0].bookMark.indexOf(video.path) !== -1) {
                        bookMarkIcon.holdHovered = true;
                    }
                } else {
                    if(userData[0].bookMark.indexOf(video.path[0]) !== -1) {
                        bookMarkIcon.holdHovered = true;
                    }
                }
            }
            if(typeof userData[0].star !== "undefined") {
                if(typeof video.path === "string") {
                    if(userData[0].star.indexOf(video.path) !== -1) {
                        starIcon.holdHovered = true;
                    }
                } else {
                    if(userData[0].star.indexOf(video.path[0]) !== -1) {
                        starIcon.holdHovered = true;
                    }
                }
            }
        }
        likeIcon.refresh()
        bookMarkIcon.refresh()
        starIcon.refresh()
    }

    function hideUI(enable){
        var video = mediaData[currentIndex];
        if(typeof video.icon2 !== "undefined") {
            videoIcon2.visible = enable;
        } else {
            videoIcon2.visible = false;
        }
        videoIcon.visible = enable;
        likeIcon.visible = enable;
        bookMarkIcon.visible = enable;
        starIcon.visible = enable;
        contentIcon.visible = enable;
        infoIcon.visible = enable;
        videoTitleLabel.visible = enable;
        videoInfoLabel.visible = enable;
    }

    function updateFilteredTitle(title) {
        if (title !== filtered_title) {
            var notificationMainTitle = title !== "" ? "已进入筛选模式" : "已退出筛选模式";
            var notificationSubTitle = title !== "" ? ("只看作者: " + title) : ("取消只看作者: " + filtered_title);
            var notificationThemeColor = title !== "" ? "#ff69b4" : "#34d399";
            filtered_title = title;
            showNotification(notificationMainTitle, notificationSubTitle, notificationThemeColor);
        }
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
                videoView.parent.fullScreened(fullScreen);
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

            Rectangle {
                anchors.centerIn: parent
                width: parent.radius * 2 + 12
                height: parent.radius * 2 + 12
                radius: (parent.radius * 2 + 12) / 2
                color: "transparent"
                border.color: filtered_title !== "" ? "#ff69b4" : "transparent"
                border.width: filtered_title !== "" ? 8 : 0
                z: -1
                visible: true
            }

            onClicked: {
                if(mediaData.length) {
                    if(typeof videoIcon.source === "undefined") {
                        showNotification("无法查看详情", "头像信息不可用", "#ef4444");
                        return;
                    }
                    var imgPath = String(videoIcon.source);
                    var jsonPath = imgPath.substring(0, imgPath.lastIndexOf("/")) + "/data.json";
                    var jsonData = rPlayerDataReader.readJsonUrl(jsonPath);
                    if (jsonData && jsonData.list) {
                        var data = Object.values(jsonData.list);
                        if(data.length) {
                            videoView.parent.showUserInfoDialog(data[0]);
                        } else {
                            showNotification("用户信息为空", "未找到用户详细信息", "#f59e0b");
                        }
                    } else {
                        showNotification("无法加载用户信息", "用户信息文件读取失败", "#ef4444");
                    }
                }
            }
            onLongPressed: {
                if(mediaData.length) {
                    if(filtered_title !== "") {
                        updateFilteredTitle("");
                    } else {
                        updateFilteredTitle(mediaData[currentIndex].title);
                    }
                }
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

            Rectangle {
                anchors.centerIn: parent
                width: parent.radius * 2 + 12
                height: parent.radius * 2 + 12
                radius: (parent.radius * 2 + 12) / 2
                color: "transparent"
                border.color: filtered_title !== "" ? "#ff69b4" : "transparent"
                border.width: filtered_title !== "" ? 8 : 0
                z: -1
                visible: true
            }

            onClicked: {
                if(mediaData.length) {
                    if(typeof videoIcon2.source === "undefined") {
                        showNotification("无法查看详情", "头像信息不可用", "#ef4444");
                        return;
                    }
                    var imgPath = String(videoIcon2.source);
                    var jsonPath = imgPath.substring(0, imgPath.lastIndexOf("/")) + "/data.json";
                    var jsonData = rPlayerDataReader.readJsonUrl(jsonPath);
                    if (jsonData && jsonData.list) {
                        var data = Object.values(jsonData.list);
                        if(data.length) {
                            videoView.parent.showUserInfoDialog(data);
                        } else {
                            showNotification("用户信息为空", "未找到用户详细信息", "#f59e0b");
                        }
                    } else {
                        showNotification("无法加载用户信息", "用户信息文件读取失败", "#ef4444");
                    }
                }
            }
            onLongPressed: {
                if(mediaData.length) {
                    if(filtered_title !== "") {
                        updateFilteredTitle("");
                    } else {
                        updateFilteredTitle(mediaData[currentIndex].title);
                    }
                }
            }
        }

        Label {
            id : videoTitleLabel
            Text {
                id: videoTitle
                text: "\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_\\_"
                color: filtered_title !== "" ? "#ff69b4" : "white"
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
                if(mediaData.length) {
                    videoView.parent.showInfoDialog(mediaData[currentIndex].title,mediaData[currentIndex].info);
                }
            }
        }

        Icon {
            id: contentIcon
            radius: 50
            anchors.right: infoIcon.right
            anchors.rightMargin: 0
            anchors.bottom: infoIcon.top
            anchors.bottomMargin: 50
            z: 1
            codePoint: "0xf27b"
            enableHover: true
            hoveredColor: "#e066ea"
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
                    text: "评论"
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
                if(mediaData.length) {
                    videoView.parent.showCommentDialog(mediaData[currentIndex].comment);
                }
            }
        }

        Icon {
            id: likeIcon
            radius: 50
            anchors.right: infoIcon.right
            anchors.rightMargin: 0
            anchors.bottom: contentIcon.top
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
                if(mediaData.length) {
                    var curr = parseInt(likeNum.text);
                    if(holdHovered) {
                        likeNum.text = curr-1;
                        showNotification("取消点赞", "点赞数：" + likeNum.text, "#6b7280");
                    } else {
                        likeNum.text = curr+1;
                        showNotification("点赞成功", "点赞数：" + likeNum.text, "#e74c3c");
                    }
                    mediaData[currentIndex].like = parseInt(likeNum.text);
                    updateMediaJsonUrl(currentIndex);
                    holdHovered = !holdHovered;
                    updateUserList("like",holdHovered);
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
                if(mediaData.length) {
                    var curr = parseInt(bookMarkNum.text);
                    if(holdHovered) {
                        bookMarkNum.text = curr-1;
                        showNotification("取消收藏", "收藏数：" + bookMarkNum.text, "#6b7280");
                    } else {
                        bookMarkNum.text = curr+1;
                        showNotification("收藏成功", "收藏数：" + bookMarkNum.text, "#3498db");
                    }
                    mediaData[currentIndex].bookMark = parseInt(bookMarkNum.text);
                    updateMediaJsonUrl(currentIndex);
                    holdHovered = !holdHovered;
                    updateUserList("bookMark",holdHovered);
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
                if(mediaData.length) {
                    var curr = parseInt(starNum.text);
                    if(holdHovered) {
                        starNum.text = curr-1;
                        showNotification("取消星标", "星标数：" + starNum.text, "#6b7280");
                    } else {
                        starNum.text = curr+1;
                        showNotification("星标成功", "星标数：" + starNum.text, "#f1c40f");
                    }
                    mediaData[currentIndex].star = parseInt(starNum.text);
                    updateMediaJsonUrl(currentIndex);
                    holdHovered = !holdHovered;
                    updateUserList("star",holdHovered);
                }
            }
        }

        MultiPointTouchArea {
            id: multiPointTouchArea
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 0
            
            property bool isLongPress: false
            
            Timer {
                id: longPressTimer
                interval: 800  // 800ms for long press detection
                running: false
                onTriggered: {
                    multiPointTouchArea.isLongPress = true;
                    if(mediaData.length) {
                        videoPlayer.togglePlaybackSpeed();
                        showNotification("已切换播放速度", "当前播放速度: X" + videoPlayer.playbackRate, "#ffffffff");
                    }
                }
            }
            
            onPressed: function(touchPoints) {
                if (touchPoints.length === 1) {
                    isLongPress = false;
                    longPressTimer.start();
                }
            }
            
            onReleased: function(touchPoints) {
                longPressTimer.stop();
                if (touchPoints.length === 1 && !isLongPress) {
                    var touchPoint = touchPoints[0];
                    if(mediaData.length) {
                        if ((touchPoint.x - touchPoint.startX < chickThreshold)&&
                            (touchPoint.x - touchPoint.startX > -chickThreshold)&&
                            (touchPoint.y - touchPoint.startY < chickThreshold)&&
                            (touchPoint.y - touchPoint.startY > -chickThreshold) ){
                            videoPlayer.pause();
                            return;
                        }
                        if(videoPlayer.fullScreen) {
                            if (touchPoint.startX - touchPoint.x > slideThreshold) {
                                videoPlayer.exitFullScreen();
                                showNotification("退出全屏", "已退出全屏模式", "#10b981");
                                return;
                            }
                        } else {
                            if(videoPlayer.paused) {
                                return;
                            }
                            if (touchPoint.startY - touchPoint.y > slideThreshold) {
                                // Slide up to play next video
                                currentIndex = (currentIndex + 1) % mediaData.length;
                                var video = mediaData[currentIndex];
                                if(filtered_title !== "") {
                                    while(video.title !== filtered_title) {
                                        currentIndex = (currentIndex + 1) % mediaData.length;
                                        video = mediaData[currentIndex];
                                    }
                                }
                                refreshVideo(true);
                                return;
                            } else if (touchPoint.y - touchPoint.startY > slideThreshold) {
                                // Slide down to play previous video
                                currentIndex = (currentIndex - 1 + mediaData.length) % mediaData.length;
                                var video = mediaData[currentIndex];
                                if(filtered_title !== "") {
                                    while(video.title !== filtered_title) {
                                        currentIndex = (currentIndex - 1 + mediaData.length) % mediaData.length;
                                        video = mediaData[currentIndex];
                                    }
                                }
                                refreshVideo(false);
                                return;
                            } else if (touchPoint.startX - touchPoint.x > slideThreshold) {
                                videoPlayer.switchImage(true);
                                return;
                            } else if (touchPoint.x - touchPoint.startX > slideThreshold) {
                                videoPlayer.switchImage(false);
                                return;
                            }
                        }
                    }
                }
            }
        }

        // notification
        Rectangle {
            property string mainTitle: "mainTitle"
            property string subTitle: "subTitle"
            property string themeColor: "#ff69b4"

            id: notification
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.8, 600)
            height: 120
            radius: 20
            color: "#80000000"
            border.color: themeColor
            border.width: 3
            opacity: 0.0
            z: 10
            
            Rectangle {
                anchors.fill: parent
                anchors.margins: 3
                radius: parent.radius - 3
                color: "transparent"
                border.color: notification.themeColor
                border.width: 1
                opacity: 0.5
            }
            
            Column {
                anchors.centerIn: parent
                spacing: 10
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: notification.mainTitle
                    color: notification.themeColor
                    font.pixelSize: 36
                    font.bold: true
                    style: Text.Outline
                    styleColor: "black"
                }
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: notification.subTitle
                    color: "white"
                    font.pixelSize: 24
                    style: Text.Outline
                    styleColor: "black"
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
            }
            
            // Fade in animation
            Behavior on opacity {
                PropertyAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
            
            // Auto hide timer
            Timer {
                id: notificationTimer
                interval: 3000
                running: false
                onTriggered: {
                    fadeOutAnimation.start()
                }
            }
            
            // Fade out animation for auto-hide
            PropertyAnimation {
                id: fadeOutAnimation
                target: notification
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
    }
}
