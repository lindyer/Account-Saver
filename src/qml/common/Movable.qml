import QtQuick 2.0

/*
*   赋予包含此组件的父控件能移动窗体
**/

MouseArea {
    anchors.fill: parent
    property point pressPos: Qt.point(0,0)
    property var dest: appWindow
    onPressed: {
        pressPos = app.globalCursorPos()
    }
    onPositionChanged: {
        var pos = app.globalCursorPos()
        var deltaX = pos.x - pressPos.x
        var deltaY = pos.y - pressPos.y
        dest.x += deltaX
        dest.y += deltaY
        pressPos = pos
    }
}
