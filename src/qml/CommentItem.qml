import QtQuick
import QtQuick.Controls

Item {
    implicitWidth : 1080
    height: contentId.height + 120

    property string inputIcon: ""
    property string inputName: ""
    property string inputContent: ""
    property alias itemIcon: iconId.sourceStr
    property alias itemName: nameId.text
    property alias itemContent: contentId.text
    
    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "transparent"
        
        Icon {
            id: iconId
            property string sourceStr: inputIcon
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 0
            radius: 40
            enablePressAnimation: false
            holdHovered: true
            source: inputIcon
        }

        TextInput {
            id: nameId
            anchors.top: iconId.top
            anchors.topMargin: 0
            anchors.left: iconId.left
            anchors.leftMargin: iconId.width + 20
            width: rectangle.parent.width - iconId.width - 10
            maximumLength: 160
            color: "white"
            text: inputName
            wrapMode: TextInput.NoWrap
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            mouseSelectionMode: TextInput.SelectWords
            font.pixelSize: 70
            readOnly: false
        }

        TextEdit {
            id: contentId
            anchors.top: iconId.bottom
            anchors.topMargin: 20
            anchors.left: iconId.left
            anchors.leftMargin: 0
            width: rectangle.parent.width
            color: "white"
            text: inputContent
            font.pixelSize: 40
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: TextEdit.WordWrap
            mouseSelectionMode: TextInput.SelectWords
            readOnly: false
        }
    }
}
