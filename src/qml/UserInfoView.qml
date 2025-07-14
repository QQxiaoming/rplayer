import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    implicitHeight: 1920
    implicitWidth: 1080
    
    property bool userInfoVisible: false
    property bool userAttrVisible: false

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"

        Flickable {
            id: flickable
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: column.implicitHeight
            clip: true // 确保内容不会超出边界

            Column {
                id: column
                width: flickable.width
                spacing: 20 // 控制子组件之间的间距

                Image {
                    id: userImage
                    property var sourceList: [""]
                    property int index: 0
                    width: parent.width
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
                                if (touchPoint.startX - touchPoint.x > 100) {
                                    userImage.index = userImage.index + 1;
                                    if (userImage.index >= userImage.sourceList.length) {
                                        userImage.index = 0;
                                    }
                                    userImage.source = userImage.sourceList[userImage.index];
                                } else if (touchPoint.startX - touchPoint.x < -100) {
                                    userImage.index = userImage.index - 1;
                                    if (userImage.index < 0) {
                                        userImage.index = userImage.sourceList.length - 1;
                                    }
                                    userImage.source = userImage.sourceList[userImage.index];
                                }
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: userName.implicitHeight
                    
                    Text {
                        id: userName
                        width: parent.width
                        color: "white"
                        font.pixelSize: 70
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Item {
                    width: parent.width
                    height: userInfo.implicitHeight
                    
                    Text {
                        id: userInfo
                        width: parent.width
                        color: "white"
                        font.pixelSize: 50
                        wrapMode: Text.WrapAnywhere
                        horizontalAlignment: Text.AlignLeft
                        visible: userInfoVisible
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: userInfoVisible = !userInfoVisible
                        }
                    }
                    
                    Item {
                        anchors.fill: parent
                        visible: !userInfoVisible
                        
                        ParticleEffect {
                            anchors.fill: parent
                            particleCount: height
                            speedMultiplier: 2.0
                            MouseArea {
                                anchors.fill: parent
                                onClicked: userInfoVisible = true
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: parent.width
                    
                    Canvas {
                        id: userAttr
                        width: parent.width
                        height: parent.width
                        visible: userAttrVisible

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

                            // 检查数据是否有效
                            if (!userAttr.list || userAttr.list.length === 0) {
                                return;
                            }

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
                        
                        MouseArea {
                            anchors.fill: parent
                            onClicked: userAttrVisible = !userAttrVisible
                        }
                    }
                    
                    Item {
                        anchors.fill: parent
                        visible: !userAttrVisible
                        
                        ParticleEffect {
                            anchors.fill: parent
                            particleCount: height
                            speedMultiplier: 2.0
                            MouseArea {
                                anchors.fill: parent
                                onClicked: userAttrVisible = true
                            }
                        }
                    }
                }
            }
        }
    }

    function setInfo(info) {
        userImage.sourceList = info["image"];
        userName.text = info["name"];
        userInfo.text = info["info"];
        
        // 安全地设置属性数据
        if (info["attr"] && userAttr) {
            userAttr.list = info["attr"];
        }
        
        if (userImage.sourceList.length > 0) {
            userImage.index = 0;
            userImage.source = userImage.sourceList[userImage.index];
        } else {
            userImage.index = 0;
            userImage.source = "";
        }
        
        // 安全地触发重绘
        if (userAttr) {
            userAttr.requestPaint();
        }
        
        // 重置所有遮罩状态
        userInfoVisible = false;
        userAttrVisible = false;
    }
}
