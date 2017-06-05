import QtQuick 2.7
import QtQuick.Controls 2.2
import Qt.labs.platform 1.0
import "../common"
import "qrc:/src/qml/common/"
import "../js/utils.js" as Utils

Page {
    signal createSubAdmin
    onVisibleChanged: {
        if(visible) {
            focus = true
        }
    }

    function finishCreateSubAdmin() {
        _userManagePage.refresh()
        _usernameRect.height = _userManagePage.height
    }

    Rectangle {
        anchors.fill: parent
        color: "#eeeeee"

        Item {
            id: _userContainer
            width: parent.width
            height: childrenRect.height
            anchors.top: parent.top
            anchors.topMargin: 20
            Text {
                id: _usernameText
                height: 30
                anchors {
                    left: parent.left
                    leftMargin: 40
                    top: parent.top
                }
                verticalAlignment: Text.AlignVCenter
                text: "当前用户：" +Global.appSettings.username
                font.pixelSize: 12
            }

            Item {
                id: _autoLoginSwitch
                height: 30
                width: childrenRect.width
                anchors {
                    left: _usernameText.right
                    leftMargin: 20
                    top: parent.top
                }
                property bool checked: Global.appSettings.autoLogin
                Text {
                    id: _autoLoginSwitchText
                    text: "自动登录"
                    color: _autoLoginSwitch.checked ? "black" : "#888888"
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    radius: 10
                    height: 20
                    width: 40
                    anchors.left: _autoLoginSwitchText.right
                    anchors.leftMargin: 10
                    color: _autoLoginSwitch.checked ? "#17a81a" : "#ffffff"
                    border.color: _autoLoginSwitch.checked ? "#17a81a" : "#cccccc"
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        x: _autoLoginSwitch.checked ? parent.width - width : 0
                        anchors.verticalCenter: parent.verticalCenter
                        width: 20
                        height: 20
                        radius: 10
                        color: _autoLoginSwitch.down ? "#cccccc" : "#ffffff"
                        border.color: _autoLoginSwitch.checked ? (_autoLoginSwitch.down ? "#17a81a" : "#21be2b") : "#999999"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            _autoLoginSwitch.checked = !_autoLoginSwitch.checked
                            Global.appSettings.autoLogin = _autoLoginSwitch.checked
                        }
                    }
                }

            }
            //it will be visible when permission equal to zero
            Button {
                id: _createSubAccount
                text: "创建附属账号"
                visible: Global.appSettings.permission == 0
                height: 30
                anchors {
                    left: _autoLoginSwitch.right
                    leftMargin: 20
                    top: parent.top
                }
                onClicked: {
                    createSubAdmin()
                }
            }

            //show all admin when permission equal to zero
            Item {
                id: _expandUserList
                width: 30
                height: 30
                visible: Global.appSettings.permission == 0
                property bool showUserList: false
                anchors {
                    right: parent.right
                    rightMargin: 40
                    top: parent.top
                }
                Image {
                    id: _expandUserImage
                    width: 20;height: 20
                    anchors.centerIn: parent
                    source: "qrc:/resource/images/expand.png"
                    sourceSize: Qt.size(width,height)
                }

                function updateUserList() {
                    _expandUserList.showUserList = ! _expandUserList.showUserList
                    if(_expandUserList.showUserList) {
                        _usernameRect.height = Qt.binding(function(){
                            return _userManagePage.height
                        })
                        _expandUserListAnimation.start()
                    }else {
                        _usernameRect.height = 0
                        _takebackUserListAnimation.start()
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        _expandUserList.updateUserList()
                    }
                }
                ToolTip.visible: showUserList
                ToolTip.text: showUserList ? "收回" : "展开"

                NumberAnimation {
                    id: _expandUserListAnimation
                    target: _expandUserImage
                    property: "rotation"
                    duration: 300
                    from: 0
                    to: 180
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    id: _takebackUserListAnimation
                    target:_expandUserImage
                    property: "rotation"
                    duration: 300
                    from: 180
                    to: 0
                    easing.type: Easing.InOutQuad
                }
            }

            Item {
                id: _usernameRect
                width: parent.width
                height: 0
                anchors.top: _usernameText.bottom
                anchors.topMargin: height == 0 ? 0 : 10
                Behavior on height {
                    NumberAnimation { duration:  300 }
                }

                UserManagePage {
                    id: _userManagePage
                    anchors.top: parent.top
//                    anchors.fill: parent
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    height: listModel.count * 30 + 30
                    visible: _usernameRect.height !== 0
                    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                    onItemDeleted: {
                        _usernameRect.height = listModel.count * 30 + 30
                    }
                }
            }
        }
        Rectangle {
            id: _seperateLine1
            width: parent.width - 80
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.top: _userContainer.bottom
            anchors.topMargin: 15
            height: 1
            color: "#ccc"
        }

        Row {
            id: _screenColorPicker
            anchors {
                left: parent.left
                leftMargin: 40
                top: _seperateLine1.bottom
                topMargin: 15
            }
            spacing: 10
            height: 30

            Button {
                text: "屏幕拾色"
                height: 30

                onClicked: {
                    _colorDialog.open()
                }
            }
        }

        Row {
            id: _colorPickerShortcut
            anchors {
                left: _screenColorPicker.right
                leftMargin: 20
                top: _seperateLine1.bottom
                topMargin: 15
            }
            spacing: 10
            height: 30
            Text {
                text: "快捷键"
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
            }

            KeyRecord {
                height: 30
                focus: true
                Keys.onPressed: {
                    if(isRecording) {
                        var shortcut = Utils.shortcut(event)
                        if(app.registerGlobalShortcut("colorPicker",shortcut)){
                            text = shortcut
                            Global.appSettings.shortcut_colorPicker = shortcut
                        }
                        event.accepted = true
                    }
                }
            }

            Component.onCompleted: {
                app.registerGlobalShortcut("colorPicker",Global.appSettings.shortcut_colorPicker)
            }
        }


    }

    Connections {
        target: app
        onColorPicker: {
            _colorDialog.open()
        }
    }

    ColorDialog {
        id: _colorDialog
        options: ColorDialog.ShowAlphaChannel
    }
}
