import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as QControls14
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

QControls14.TableView {
    id: _tableView
    property alias listModel: _listModel
    property real columnWidth: _tableView.width/4
    style: TableViewStyle {
        frame: Item {}
    }
    selectionMode: QControls14.SelectionMode.ExtendedSelection
    alternatingRowColors: true
    backgroundVisible: false
    model: ListModel {id: _listModel}
    highlightOnFocus: true
    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    headerDelegate: Rectangle {
        height: 30
        width: _tableView.width/4
        color: "#dddddd"
        Text {
            anchors.centerIn: parent
            text: styleData.value
            font.pixelSize: 12
        }
        Rectangle {
            width: 1
            height: parent.height - 8
            visible: styleData.column !== _tableView.columnCount
            color: "#ccc"
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
        }
    }
    clip: true
    focus: true
    Keys.onPressed: {
        if(event.key === Qt.Key_F5){
            refresh()
        }
    }
    signal itemDeleted
    rowDelegate: Rectangle {
        height: 30
        width: _tableView.width
        color: styleData.hasActiveFocus || styleData.selected  ? "#cccccc" : "transparent"
        //                color: styleData.hasActiveFocus
        //                       ? "#B0BEC5" : (styleData.alternate ? "#cccccc" : "transparent")
    }
    function refresh() {
        _listModel.clear()
        var array = dbm.dbSelect("select * from users")
        for(var i = 0;i < array.length; ++i){
            print(">>",array[i].id,array[i].username,array[i].password,array[i].permission)
            _listModel.append({
                                  "id": array[i].id,
                                  "username":array[i].username,
                                  "password":array[i].password,
                                  "permission":array[i].permission
                              })
        }
    }
    QControls14.TableViewColumn {
        id: _usernameColumn
        title: "用户名"
        role: "username"
        movable: false
        resizable: false
        width: _tableView.columnWidth
        delegate: TextField {
            id: _website_delegate
            height: 30
            placeholderText: "用户名"
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
        }
    }
    QControls14.TableViewColumn {
        id: _commentColumn
        title: "等级"
        role: "permission"
        movable: false
        resizable: false
        width: _tableView.columnWidth
        delegate: TextField {
            id: _commentTextField
            placeholderText: "等级"
            text: styleData.value === 0 ? "管理员" : "附属者"
            font.pixelSize: 16
            horizontalAlignment: TextField.AlignHCenter
            enabled: false
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
                            var username = _listModel.get(styleData.row).username
                            var password = _listModel.get(styleData.row).password
                            var permission = _listModel.get(styleData.row).permission
                            var sql = "update users set username = '"+username+"',password = '"+password+"',permission = '"+permission+"' where id = "+id
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
                            var sql  = "delete from users where id = "+ _listModel.get(styleData.row).id
                            if(dbm.dbDelete(sql)){
                                _listModel.remove(styleData.row)
                                prompt.show("删除成功")
                                itemDeleted()
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


