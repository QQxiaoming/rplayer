import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    property bool foreceUnderLine: false
    property alias text: labelText.text

    Label {
        anchors.fill: parent
        ToolButton {
            id: button
            anchors.fill: parent
            background: Rectangle {
                color: "transparent"
            }
        }
        Text {
            id : labelText
            anchors.fill: parent
            color: ( button.pressed || button.hovered || foreceUnderLine ) ? "white" : "gray"
            font.pixelSize: 60
            style: Text.Outline
            styleColor: "black"
        }
        Rectangle {
            width: parent.width
            height: 8
            color: ( button.pressed || button.hovered || foreceUnderLine ) ? "white" : "gray"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -10
            visible: button.pressed || button.hovered || foreceUnderLine
        }
    }
}
