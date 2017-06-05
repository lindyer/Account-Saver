import QtQuick 2.0

// 图标按钮，悬停切换图标

Item {
    id: _root
    width: 28; height: 28
    property url hoveredUrl
    property url unhoveredUrl
    property size imageSize: Qt.size(24,24)
    signal clicked
    Image {
        id: _image
        anchors.centerIn: parent
        width: imageSize.width
        height: imageSize.height
        source: _mouseArea.containsMouse ? hoveredUrl : unhoveredUrl
        sourceSize: Qt.size(width,height)
    }
    MouseArea {
        id: _mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: _root.clicked()
    }
}
