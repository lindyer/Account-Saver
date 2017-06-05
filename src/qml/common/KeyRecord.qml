import QtQuick 2.7
import QtQuick.Controls 2.1
//import "qrc:/src/qml/js/utils.js" as Utils
import "."
Rectangle {
    id: _root
    height: 30
    width: 150
    border.color: "#e0e0e0"
    border.width: 1
    property bool isRecording: false
    property alias text: _text.text
    color: "#eeeeee"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            focus = false
            isRecording = false
        }
    }

    Rectangle {
        id: _status
        width: 16
        height: 16
        color: _mouseArea.containsMouse ? Qt.lighter("red",1.3) : isRecording ? "red" : "gray"
        radius: height/2
        anchors {
            right: parent.right
            rightMargin: 4
            verticalCenter: parent.verticalCenter
        }
        MouseArea {
            id: _mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                isRecording = !isRecording
                if(isRecording){
                    _text.focus = true
                }else{
                    _text.focus = false
                }
            }
        }
        ToolTip.visible: isRecording
        ToolTip.text: "请按快键键"
    }

    Text {
        id: _text
        font.pixelSize: 12
        verticalAlignment: TextField.AlignVCenter
        text: Global.appSettings.shortcut_colorPicker
        anchors {
            left: parent.left
            leftMargin: 4
            right: _status.left
            rightMargin: 4
            verticalCenter: parent.verticalCenter
        }
    }

}
