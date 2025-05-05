import QtQuick
import QtQuick.Controls

Item {
    implicitHeight : 1920
    implicitWidth : 1080

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"

        ScrollView {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 100
            anchors.bottomMargin: 120

            Image {
                id: userImage
                property var sourceList : [""]
                property int index : 0
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: width
                fillMode: Image.PreserveAspectFit
                source: userImage.sourceList[userImage.index]
                
                MultiPointTouchArea {
                    anchors.fill: parent
                    enabled: true
                    onReleased: function(touchPoints) {
                        if (userImage.sourceList.length <= 1) {
                            return;
                        }
                        if (touchPoints.length === 1) {
                            var touchPoint = touchPoints[0];
                            if(touchPoint.startX - touchPoint.x > 100) {
                                userImage.index = userImage.index + 1;
                                if(userImage.index >= userImage.sourceList.length) {
                                    userImage.index = 0;
                                }
                                userImage.source = userImage.sourceList[userImage.index];
                            } else if(touchPoint.startX - touchPoint.x < -100) {
                                userImage.index = userImage.index - 1;
                                if(userImage.index < 0) {
                                    userImage.index = userImage.sourceList.length - 1;
                                }
                                userImage.source = userImage.sourceList[userImage.index];
                            }
                        }
                    }
                }
            }

            Text {
                id: userName
                anchors.top: userImage.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "white"
                font.pixelSize: 70
            }

            Text {
                id: userInfo
                anchors.top: userName.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "white"
                font.pixelSize: 50
                wrapMode: Text.WrapAnywhere
            }
            
            Canvas {
                id: userAttr
                anchors.top: userInfo.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 50
                height: 1200

                property var list: [
                    {name: "Strength", value: 0.8},
                    {name: "Agility", value: 0.6},
                    {name: "Intelligence", value: 0.7},
                    {name: "Charisma", value: 0.5},
                    {name: "Endurance", value: 0.9},
                    {name: "Luck", value: 0.4}
                ] // 六维属性数据

                onPaint: {
                    var ctx = userAttr.getContext("2d");
                    ctx.clearRect(0, 0, userAttr.width, userAttr.height);

                    var centerX = userAttr.width / 2;
                    var centerY = userAttr.height / 2;
                    var radius = Math.min(userAttr.width, userAttr.height) / 3;
                    var numDimensions = userAttr.list.length;

                    // 绘制六边形网格
                    ctx.strokeStyle = "white";
                    ctx.lineWidth = 1;
                    for (var i = 1; i <= 5; i++) {
                        ctx.beginPath();
                        for (var j = 0; j < numDimensions; j++) {
                            var angle = (Math.PI * 2 / numDimensions) * j;
                            var x = centerX + Math.cos(angle) * (radius * i / 5);
                            var y = centerY + Math.sin(angle) * (radius * i / 5);
                            if (j === 0) {
                                ctx.moveTo(x, y);
                            } else {
                                ctx.lineTo(x, y);
                            }
                        }
                        ctx.closePath();
                        ctx.stroke();
                    }

                    for (var n = 0; n < numDimensions; n++) {
                        var angle = (Math.PI * 2 / numDimensions) * n;
                        var x = centerX + Math.cos(angle) * radius;
                        var y = centerY + Math.sin(angle) * radius;
                        ctx.beginPath();
                        ctx.moveTo(centerX, centerY);
                        ctx.lineTo(x, y);
                        ctx.stroke();
                    }

                    // 绘制属性数据
                    ctx.fillStyle = "rgb(255, 0, 204)";
                    ctx.beginPath();
                    for (var k = 0; k < numDimensions; k++) {
                        var dataAngle = (Math.PI * 2 / numDimensions) * k;
                        var dataX = centerX + Math.cos(dataAngle) * (radius * userAttr.list[k].value);
                        var dataY = centerY + Math.sin(dataAngle) * (radius * userAttr.list[k].value);
                        if (k === 0) {
                            ctx.moveTo(dataX, dataY);
                        } else {
                            ctx.lineTo(dataX, dataY);
                        }
                    }
                    ctx.closePath();
                    ctx.fill();

                    ctx.fillStyle = "white";
                    ctx.font = "50px Arial";
                    for (var m = 0; m < numDimensions; m++) {
                        var labelAngle = (Math.PI * 2 / numDimensions) * m;
                        var labelX = centerX + Math.cos(labelAngle) * (radius + 50); // 调整为 50px 的偏移
                        var labelY = centerY + Math.sin(labelAngle) * (radius + 50); // 调整为 50px 的偏移

                        // 根据文本宽度和高度调整位置，使文本居中
                        var textWidth = ctx.measureText(userAttr.list[m].name).width;
                        var textHeight = 50; // 假设字体大小为 50px
                        ctx.fillText(userAttr.list[m].name, labelX - textWidth / 2, labelY + textHeight / 4);
                    }
                }
            }
        }
    }

    function setInfo(info) {
        userImage.sourceList = info["image"];
        userName.text = info["name"];
        userInfo.text = info["info"];
        userAttr.list = info["attr"];
        if (userImage.sourceList.length > 0) {
            userImage.index = 0;
            userImage.source = userImage.sourceList[userImage.index];
        } else {
            userImage.index = 0;
            userImage.source = "";
        }
        userAttr.requestPaint(); // 触发绘制
    }
}
