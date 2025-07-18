import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    property int radius: 50
    property string codePoint: "0xf110"
    property bool enableHover: false
    property bool holdHovered: false
    property real hoveredScale: 1.2
    property bool enablePressAnimation: true
    property string hoveredColor: "#202020"
    property string hoveredBackColor: "gray"
    property alias source: sourceItem.source
    property alias borderWidth: iconRect.border.width
    property alias orientation: iconRect.rotation

    width: radius*2
    height: width

    signal clicked()
    signal longPressed()

    function refresh() {
        if (enableHover) {
            if(holdHovered) {
                sourceItem.source = fontIcon ? fontIcon.getIcon(codePoint, hoveredColor, radius*2) : "";
            } else {
                sourceItem.source = fontIcon ? fontIcon.getIcon(codePoint, button.hovered ? hoveredColor : "Default", radius*2) : "";
            }
        }
    }

    Rectangle {
        id : iconRect
        width: parent.width
        height: parent.height
        radius: parent.radius
        border.color: "white"
        border.width: 2
        clip: true
        color: "transparent"
        
        property real scale: 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }
        transform: Scale {
            origin.x: iconRect.width / 2
            origin.y: iconRect.height / 2
            xScale: iconRect.scale
            yScale: iconRect.scale
        }

        ToolButton {
            id: button
            anchors.fill: parent
            background: Rectangle {
                color: button.hovered ? hoveredBackColor : "transparent"
                radius: iconRect.radius
            }
            property bool longPressTriggered: false
            Timer {
                id: longPressTimer
                interval: 500 // 长按判定时间，毫秒
                running: false
                repeat: false
                onTriggered: {
                    button.longPressTriggered = true;
                    iconRect.parent.longPressed();
                }
            }
            onHoveredChanged: {
                iconRect.parent.refresh();
                if(button.hovered) {
                    iconRect.scale = hoveredScale;
                } else {
                    iconRect.scale = 1.0;
                }
            }
            onPressed: {
                if(enablePressAnimation) {
                    iconRect.scale = 0.8;
                }
                button.longPressTriggered = false;
                longPressTimer.start();
            }
            onReleased: {
                iconRect.scale = 1.0;
                longPressTimer.stop();
                if (!button.longPressTriggered) {
                    iconRect.parent.clicked();
                    iconRect.parent.refresh();
                }
            }
        }

        Image {
            id: sourceItem
            source: fontIcon ? fontIcon.getIcon(codePoint, "Default", radius*2) : ""
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            visible: false
        }

        MultiEffect {
            source: sourceItem
            anchors.fill: sourceItem
            maskEnabled: true
            maskSource: mask
        }

        Item {
            id: mask
            width: sourceItem.width
            height: sourceItem.height
            layer.enabled: true
            visible: false

            Rectangle {
                width: sourceItem.width
                height: sourceItem.height
                radius: width/2
                color: "black"
            }
        }
    }
}
