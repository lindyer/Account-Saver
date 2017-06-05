/*
*
*  作者：Jenpen
*  创建时间： 2017-5-31
*  组件说明：提示条，默认两秒关闭，鼠标进入后停止关闭，离开两秒后关闭
*
*/


import QtQuick 2.7
import QtQuick.Controls 2.1


Item {
    id: _root
    property bool memoryHorizontalPosition: false   //记忆水平位置
    property int  residenceTime: 2000               //停留时间
    property real radius: 4
    property int fontSize: 16
    property int transitionInterval: 300            //动画过渡时间
    visible: false
    width: appWindow.width
    height: appWindow.height
    z: 99
    focus: false

    function show(text,interval) {
        _text.text = text
        visible = true
        residenceTime = interval || 2000
        _container.state = "anchor_verticalCenter"
    }

    Item {
        anchors.fill: parent
        id: _container

        Timer {
            id: _anchortopTimer
            repeat: false
            interval: residenceTime
            onTriggered: {
                _container.state = "anchor_top"
                _closeTimer.start()
            }
            running: _container.state == "anchor_verticalCenter"
        }
        Timer {
            id: _closeTimer
            repeat: false
            interval: transitionInterval
            onTriggered: {
                if(!memoryHorizontalPosition) {
                    _content.anchors.horizontalCenter = _container.horizontalCenter
                }
                _content.anchors.bottom = _container.bottom
                _root.visible = false
            }
        }
        Rectangle {
            id: _content
            implicitWidth: _text.paintedWidth + 40
            implicitHeight: _text.paintedHeight + 20
            anchors.horizontalCenter: _container.horizontalCenter
            color: "#00BCD4"
            radius: _root.radius

            Text {
                id: _text
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                width: 300
                wrapMode: Text.WordWrap
                text: "This is a tip"
                font.pixelSize: fontSize
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                drag.target: _content
                drag.axis: Drag.XAndYAxis
                drag.minimumX: 0
                drag.maximumX: _root.width - _content.width
                drag.minimumY: 0
                drag.maximumY: _root.height - _content.height
                onEntered: _anchortopTimer.stop()
                hoverEnabled: true
                onPressed: {
                    _content.anchors.bottom = undefined
                    _content.anchors.verticalCenter = undefined
                    _content.anchors.horizontalCenter = undefined
                    _content.anchors.top = undefined
                    _content.anchors.left = undefined
                    _content.anchors.right = undefined
                }
                onExited: {
                    _anchortopTimer.start(2000)
                }
            }
        }
        state: _root.visible ? "anchor_verticalCenter" : "anchor_bottom"
        states: [
            State {
                name: "anchor_bottom"
                AnchorChanges {
                    target: _content
                    anchors.bottom: _container.bottom
                }
            },
            State {
                name: "anchor_verticalCenter"
                AnchorChanges {
                    target: _content
                    anchors.verticalCenter: _container.verticalCenter
                }
            },
            State {
                name: "anchor_top"
                AnchorChanges {
                    target: _content
                    anchors.bottom: _container.top
                }
            }
        ]
        transitions: Transition {
            AnchorAnimation {
                duration: transitionInterval
                easing.type: Easing.InOutQuad
            }
        }
    }
}
