import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    property int radius: 50
    property string codePoint: "0xf110"
    property bool enableHover: false
    property bool holdHovered: false
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

        ToolButton {
            id: button
            anchors.fill: parent
            background: Rectangle {
                color: button.hovered ? "gray" : "transparent"
                radius: iconRect.radius
            }
            onHoveredChanged: {
                iconRect.parent.refresh()
            }
            onClicked: {
                iconRect.parent.clicked()
            }
        }

        Image {
            id: sourceItem
            source: fontIcon ? fontIcon.getIcon(codePoint, button.hovered ? hoveredColor : "Default") : ""
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
