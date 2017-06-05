import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as QControls14
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Page {
    id: _root
    signal refreshTable()
    signal turntoAccountManagePage()
    background: Rectangle {
        color: "#eeeeee"
    }
    Item {
        id: _addAccountItem
        width: 300
        height: childrenRect.height
        anchors.centerIn: parent
        Column {
            width: parent.width
            height: childrenRect.height
            spacing: 8
            Rectangle {
                height: 40
                width: parent.width
                color: "#E91E63"

                RowLayout {
                    anchors.fill: parent
                    Text {
                        text: "网站"
                        Layout.preferredWidth: 60
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        color: "white"
                    }
                    TextField {
                        id: _website
                        placeholderText: "网站域名"
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height
                        selectByMouse: true
                        background: Rectangle {
                            height: parent.height
                            border.color: _website.activeFocus ? "#E91E63" : "#eeeeee"
                            border.width: _website.activeFocus ? 2 : 1
                            color: "#fafafa"
                        }
                        rightPadding: _website.hovered ? 40 : 4
                        Rectangle {
                            id: _linkRect
                            width: 24
                            height: 24
                            visible: (_website.hovered || _linkImageMouseArea.containsMouse) && _website.text !== ""
                            color: "#fafafa"
                            anchors {
                                right: parent.right
                                rightMargin: 6
                                verticalCenter: parent.verticalCenter
                            }
                            Image {
                                anchors.fill: parent
                                sourceSize: Qt.size(24,24)
                                source: "qrc:/resource/images/link.png"
                                MouseArea {
                                    id: _linkImageMouseArea
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        app.openUrl(_website.text)
                                    }
                                }
                                ToolTip.visible:(_linkImageMouseArea.containsMouse || _website.hovered) && _website.text !== ""
                                ToolTip.text: "打开网站"
                            }

                        }
                    }

                }
            }
            Rectangle {
                height: 40
                width: parent.width
                color: "#F44336"
                RowLayout {
                    anchors.fill: parent
                    Text {
                        text: "账号"
                        Layout.preferredWidth: 60
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        color: "white"
                    }
                    TextField {
                        id: _account
                        placeholderText: "登录名/账号"
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height
                        selectByMouse: true
                        background: Rectangle {
                            height: parent.height
                            border.color: _account.activeFocus ? "#F44336" : "#eeeeee"
                            border.width: _account.activeFocus ? 2 : 1
                            color: "#fafafa"
                        }
                        rightPadding: _account.hovered ? 40 : 4
                        Rectangle {
                            id: _accountClipRect
                            width: 24
                            height: 24
                            visible: (_account.hovered || _accountClipImageMouseArea.containsMouse) && _account.text !== ""
                            color: "#fafafa"
                            anchors {
                                right: parent.right
                                rightMargin: 6
                                verticalCenter: parent.verticalCenter
                            }
                            Image {
                                anchors.fill: parent
                                sourceSize: Qt.size(24,24)
                                source: "qrc:/resource/images/copy.png"
                                MouseArea {
                                    id: _accountClipImageMouseArea
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        app.setClipBoardContent(_account.text)
                                    }
                                }
                                ToolTip.visible: (_accountClipImageMouseArea.containsMouse || _account.hovered) && _account.text !== ""
                                ToolTip.text: "复制"
                            }
                        }
                    }
                }
            }
            Rectangle {
                height: 40
                width: parent.width
                color: "#4CAF50"
                RowLayout {
                    height: parent.height
                    width: parent.width
                    Text {
                        text: "密码"
                        Layout.preferredWidth: 60
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        color: "white"
                    }
                    TextField {
                        id: _password
                        placeholderText: "登录密码"
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height
                        echoMode: TextInput.Password
                        background: Rectangle {
                            height: parent.height
                            border.color: _password.activeFocus ? "#4CAF50" : "#eeeeee"
                            border.width: _password.activeFocus ? 2 : 1
                            color: "#fafafa"
                        }
                        selectByMouse: true
                        Rectangle {
                            id: _passwordRect
                            width: 24
                            height: 24
                            visible: (_password.hovered || _passwordHideImageMouseArea.containsMouse)
                            color: "#fafafa"
                            anchors {
                                right: parent.right
                                rightMargin: 6
                                verticalCenter: parent.verticalCenter
                            }
                            Image {
                                id: _passwordImage
                                anchors.fill: parent
                                sourceSize: Qt.size(24,24)
                                property bool show: false
                                source: show ? "qrc:/resource/images/hide_password.png" : "qrc:/resource/images/show.png"
                                MouseArea {
                                    id: _passwordHideImageMouseArea
                                    hoverEnabled: true
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if(_passwordImage.show) {
                                            _passwordImage.show = false
                                            _password.echoMode = TextInput.Password
                                        } else {
                                            _passwordImage.show = true
                                            _password.echoMode = TextInput.Normal
                                        }
                                    }
                                }
                                ToolTip.visible: _passwordHideImageMouseArea.containsMouse || _password.hovered
                                ToolTip.text: show ? "隐藏" : "显示"
                            }
                        }
                    }
                }
            }

            Rectangle {
                height: 40
                width: parent.width
                color: "#3F51B5"
                RowLayout {
                    height: parent.height
                    width: parent.width
                    Text {
                        text: "备注"
                        Layout.preferredWidth: 60
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        color: "white"
                    }
                    TextField {
                        id: _comment
                        placeholderText: "账号备注说明"
                        font.pixelSize: 16
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height
                        background: Rectangle {
                            height: parent.height
                            border.color: _comment.activeFocus ? "#3F51B5" : "#eeeeee"
                            border.width: _comment.activeFocus ? 2 : 1
                            color: "#fafafa"
                        }
                    }
                }
            }

            Button {
                id: _saveButton
                width: parent.width
                height: 40
                text: "保存"
                background: Rectangle {
                    anchors.fill: parent
                    color: _saveButton.pressed ? "#FFC107" : (_saveButton.hovered ? "#FF9800" : "#FF5722")
                }
                contentItem: Text {
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 16
                    text: _saveButton.text
                }
                onClicked: {
                    if(_website.text == ""){
                        prompt.show("网址不能为空")
                    }else if(_account.text == ""){
                        prompt.show("账号不能为空")
                    }else if(_password.text == ""){
                        prompt.show("密码不能为空")
                    }else{
                        var sql = "insert into accounts(website,account,password,comment)values('"+_website.text+"','"+_account.text+"','"+_password.text+"','"+_comment.text+"')"
                        if(dbm.dbInsert(sql)){
                            prompt.show("添加成功")
                            turntoAccountManagePage()
                        }else{
                            prompt.show("添加失败")
                        }
                        refreshTable()
                    }
                }
            }
        }
    }


//    Item {
//        width: 32
//        height: 32
//        z:2
//        anchors {
//            top: parent.top
//            topMargin: 8
//            left: parent.left
//            leftMargin: 8
//        }
//        Image {
//            anchors.fill: parent
//            source: _returnMouseArea.containsMouse ? "qrc:/resource/images/return_hovered.png" :"qrc:/resource/images/return_unhovered.png"
//            sourceSize: Qt.size(32,32)
//        }
//        MouseArea {
//            id: _returnMouseArea
//            anchors.fill: parent
//            hoverEnabled: true
//            onClicked: {
//                turntoAccountManagePage()
//            }
//        }
//        ToolTip.visible: _returnMouseArea.containsMouse
//        ToolTip.text: "返回"
//    }

}
