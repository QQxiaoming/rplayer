import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    property alias text: labelText.text

    Label {
        anchors.fill: parent
        ToolButton {
            id: button
            anchors.fill: parent
            background: Rectangle {
                color: button.pressed ? "gray" : button.hovered ? "gray" : "transparent"
            }
        }
        Text {
            id : labelText
            anchors.fill: parent
            color: "white"
            font.pixelSize: 60
            style: Text.Outline
            styleColor: "black"
        }
    }
}
