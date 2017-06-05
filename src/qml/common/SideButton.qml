import QtQuick 2.7
import QtQuick.Controls 2.2

TabButton {
    id: _root
    width: parent.width
    height: 35
    property color indicatorColor: "#ff2f2f"
    property color bgColor: "#22666666"
    contentItem: Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: _root.text
        font.pixelSize: 12
    }
    indicator: Rectangle {
        anchors.left: parent.left
        width: 2
        height: parent.height
        color: _root.checked ? indicatorColor : "transparent"
    }
    background: Rectangle {
        color: _root.checked ? "#22666666" : "transparent"
    }
}
