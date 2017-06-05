import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as QControls14
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Page {
    background: Rectangle {
        color: "#eeeeee"
    }

    signal turnToAccountManagePage()
    function refresh() {
        _listModel.clear()
        var array = dbm.dbSelect("select * from accounts")
        for(var i = 0;i < array.length; ++i){
            print(">>",array[i].id,array[i].website,array[i].account,array[i].password,array[i].comment)
            _listModel.append({
                                  "id": array[i].id,
                                  "website":array[i].website,
                                  "account":array[i].account,
                                  "password":array[i].password,
                                  "comment":array[i].comment
                              })
        }
    }

    QControls14.TableView {
        id: _tableView
        style: TableViewStyle {
            frame: Item {}
        }
        selectionMode: QControls14.SelectionMode.ExtendedSelection
        anchors.fill: parent
        alternatingRowColors: true
        backgroundVisible: false
        model: ListModel {id: _listModel}
        Rectangle {
            anchors.fill: parent
            visible:  _listModel.count == 0
            color: "#eeeeee"
            Text {
                text: "暂未保存账号"
                anchors.centerIn: parent
                font.pixelSize: 14
            }
        }

        highlightOnFocus: true
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        headerDelegate: Rectangle {
            height: 30
            width: _tableView.width/5
            color: "#aadddddd"
            Text {
                anchors.centerIn: parent
                text: styleData.value
                font.pixelSize: 12
            }
            Rectangle {
                width: 1
                height: parent.height - 8
                visible: styleData.column !== _tableView.columnCount
                color: headerColor
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
            }
        }

        focus: true
        Keys.onPressed: {
            if(event.key === Qt.Key_F5){
                refresh()
            }
        }

        Item {
            width: 32
            height: 32
            z:2
            anchors {
                bottom: parent.bottom
                bottomMargin: 4
                horizontalCenter: parent.horizontalCenter
            }
            Image {
                anchors.fill: parent
                source: _newMouseArea.containsMouse ? "qrc:/resource/images/new_hovered.png" :"qrc:/resource/images/new_unhovered.png"
                sourceSize: Qt.size(32,32)
            }
            MouseArea {
                id: _newMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    turnToAccountManagePage()
                }
            }
            ToolTip.visible: _newMouseArea.containsMouse
            ToolTip.text: "新增账号"
        }

        rowDelegate: Rectangle {
            height: 30
            width: _tableView.width
            color: styleData.hasActiveFocus || styleData.selected  ? "#cccccc" : "transparent"
//                color: styleData.hasActiveFocus
//                       ? "#B0BEC5" : (styleData.alternate ? "#cccccc" : "transparent")
        }
        property real columnWidth: _tableView.width/5

        QControls14.TableViewColumn {
            id: _websiteColumn
            title: "网址"
            role: "website"
            movable: false
            resizable: false
            width: _tableView.columnWidth
            delegate: TextField {
                id: _website_delegate
                height: 30
                placeholderText: "网站域名"
                text: styleData.value
                font.pixelSize: 16
                selectByMouse: true
                horizontalAlignment: TextField.AlignHCenter
                verticalAlignment: TextField.AlignVCenter
                onEditingFinished: {
                    _listModel.get(styleData.row).website = text
                }
                background: Rectangle {
                    height: parent.height
                    color: activeFocus ? "white" :"transparent"
                    border.color: _website_delegate.activeFocus ? "#f6f6f6" : "#eeeeee"
                    border.width: _website_delegate.activeFocus ? 1 : 0
                }
                rightPadding: _website_delegate.hovered ? 18 : 2
                Item {
                    width: 16
                    height: 16
                    visible: (_website_delegate.hovered || _linkImageMouseArea_delegate.containsMouse) && _website_delegate.text !== ""
                    anchors {
                        right: parent.right
                        rightMargin: 2
                        verticalCenter: parent.verticalCenter
                    }
                    Image {
                        anchors.fill: parent
                        sourceSize: Qt.size(16,16)
                        source: "qrc:/resource/images/link.png"
                        MouseArea {
                            id: _linkImageMouseArea_delegate
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                app.openUrl(_website_delegate.text)
                            }
                        }
                    }

                }

            }
        }
        QControls14.TableViewColumn {
            id: _accountColumn
            title: "账号"
            role: "account"
            movable: false
            resizable: false
            width: _tableView.columnWidth
            delegate: TextField {
                id: _account_delegate
                placeholderText: "登录名/账号"
                font.pixelSize: 16
                text: styleData.value
                selectByMouse: true
                horizontalAlignment: TextField.AlignHCenter
                verticalAlignment: TextField.AlignVCenter
                background: Rectangle {
                    height: parent.height
                    color: activeFocus ? "white" :"transparent"
                    border.color: _account_delegate.activeFocus ? "#f6f6f6" : "#eeeeee"
                    border.width: _account_delegate.activeFocus ? 1 : 0
                }
                onEditingFinished: {
                    _listModel.get(styleData.row).account = text
                }
                rightPadding: _account_delegate.hovered ? 18 : 2
                Item {
                    id: _accountClipRect_delegate
                    width: 16
                    height: 16
                    visible: (_account_delegate.hovered || _accountClipImageMouseArea_delegate.containsMouse) && _account_delegate.text !== ""
                    anchors {
                        right: parent.right
                        rightMargin: 2
                        verticalCenter: parent.verticalCenter
                    }
                    Image {
                        anchors.fill: parent
                        sourceSize: Qt.size(16,16)
                        source: "qrc:/resource/images/copy.png"
                        MouseArea {
                            id: _accountClipImageMouseArea_delegate
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                app.setClipBoardContent(_account_delegate.text)
                            }
                        }
                    }
                }
            }
        }
        QControls14.TableViewColumn {
            id: _passwordColumn
            title: "密码"
            role: "password"
            movable: false
            resizable: false
            width:_tableView.columnWidth
            delegate: TextField {
                id: _password_delegate
                placeholderText: "登录密码"
                font.pixelSize: 16
                text: styleData.value
                horizontalAlignment: TextField.AlignHCenter
                verticalAlignment: TextField.AlignVCenter
                background: Rectangle {
                    height: parent.height
                    color: activeFocus ? "white" :"transparent"
                    border.color: _password_delegate.activeFocus ? "#f6f6f6" : "#eeeeee"
                    border.width: _password_delegate.activeFocus ? 1 : 0
                }
                selectByMouse: true
                onEditingFinished: {
                    _listModel.get(styleData.row).password = text
                }
                Item {
                    id: _passwordRect_delegate
                    width: 16
                    height: 16
                    visible: (_password_delegate.hovered || _passwordHideImageMouseArea_delegate.containsMouse)
                    anchors {
                        right: parent.right
                        rightMargin: 6
                        verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: _passwordImage_delegate
                        anchors.fill: parent
                        sourceSize: Qt.size(16,16)
                        property bool show: true
                        source: show ? "qrc:/resource/images/hide_password.png" : "qrc:/resource/images/show.png"
                        MouseArea {
                            id: _passwordHideImageMouseArea_delegate
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if(_passwordImage_delegate.show) {
                                    _passwordImage_delegate.show = false
                                    _password_delegate.echoMode = TextInput.Password
                                } else {
                                    _passwordImage_delegate.show = true
                                    _password_delegate.echoMode = TextInput.Normal
                                }
                            }
                        }
                    }
                }
            }
        }
        QControls14.TableViewColumn {
            id: _commentColumn
            title: "备注"
            role: "comment"
            movable: false
            resizable: false
            width: _tableView.columnWidth
            delegate: TextField {
                id: _commentTextField
                placeholderText: "账号备注说明"
                text: styleData.value
                font.pixelSize: 16
                horizontalAlignment: TextField.AlignHCenter
                verticalAlignment: TextField.AlignVCenter
//                    onEditingFinished: {
//                        _listModel.get(styleData.row).comment = _commentTextField.text
//                    }
                onTextChanged: {
                    var item = _listModel.get(styleData.row)
                    if(item !== undefined && item.comment !== undefined){
                        _listModel.get(styleData.row).comment = _commentTextField.text
                    }
                }
                background: Rectangle {
                    height: parent.height
                    color: activeFocus ? "white" :"transparent"
                    border.color: _commentTextField.activeFocus ? "#f6f6f6" : "#eeeeee"
                    border.width: _commentTextField.activeFocus ? 1 : 0
                }
            }
        }
        QControls14.TableViewColumn {
            id: _operateColumn
            title: "操作"
            movable: false
            resizable: false
            width: _tableView.columnWidth
            delegate: Item {
                anchors.fill: parent
//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: {
//                            _tableView.currentRow = styleData.row
//                        }
//                    }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    Image {
                        width: 20
                        height: 20
                        source: "qrc:/resource/images/commit.png"
                        sourceSize: Qt.size(width,height)
                        MouseArea {
                            id: _commitMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var id = _listModel.get(styleData.row).id
                                var website = _listModel.get(styleData.row).website
                                var account = _listModel.get(styleData.row).account
                                var password = _listModel.get(styleData.row).password
                                var comment = _listModel.get(styleData.row).comment
                                var sql = "update accounts set website = '"+website+"',account = '"+account+"',password = '"+password+"',comment = '"+comment+"' where id = "+id
                                console.info(sql)
                                if(dbm.dbUpdate(sql)){
                                    prompt.show("更新成功")
                                }
                            }
                        }
                        ToolTip.visible: _commitMouseArea.containsMouse
                        ToolTip.text: "更新"
                    }
                    Image {
                        width: 20
                        height: 20
                        source: "qrc:/resource/images/delete.png"
                        sourceSize: Qt.size(width,height)
                        MouseArea {
                            id: _deleteMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                var sql  = "delete from accounts where id = "+ _listModel.get(styleData.row).id
                                if(dbm.dbDelete(sql)){
                                    _listModel.remove(styleData.row)
                                    prompt.show("删除成功")
                                }
                            }
                        }
                        ToolTip.visible: _deleteMouseArea.containsMouse
                        ToolTip.text: "删除"
                    }
                }
            }
        }
        Component.onCompleted: {
            //                    console.info(dbm.dbFieldNames("accounts"))
            refresh()
        }
    }


}
