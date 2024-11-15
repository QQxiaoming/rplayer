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
    property alias source: sourceItem.source
    property alias borderWidth: iconRect.border.width


    width: radius*2
    height: width

    signal clicked()

    function refresh() {
        if (enableHover) {
            if(holdHovered) {
                sourceItem.source = fontIcon ? fontIcon.getIcon(codePoint, hoveredColor ) : "";
            } else {
                sourceItem.source = fontIcon ? fontIcon.getIcon(codePoint, button.hovered ? hoveredColor : "Default") : "";
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
                color: button.hovered ? "gray" : "transparent"
                radius: iconRect.radius
            }
            onHoveredChanged: {
                iconRect.parent.refresh()
                if(button.hovered) {
                    iconRect.scale = hoveredScale
                } else {
                    iconRect.scale = 1.0
                }
            }
            onClicked: {
                iconRect.parent.clicked()
                iconRect.parent.refresh()
            }
            onPressed: {
                if(enablePressAnimation) {
                    iconRect.scale = 0.8
                }
            }
            onReleased: {
                iconRect.scale = 1.0
            }
        }

        Image {
            id: sourceItem
            source: fontIcon ? fontIcon.getIcon(codePoint) : ""
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
