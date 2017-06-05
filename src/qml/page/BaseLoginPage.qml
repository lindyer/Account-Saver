import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "../common"

Item {
    anchors.fill: parent
    property string type: "login"  //  login/register0/register1  ,后面的序号为等级，0为管理员
    signal request(string username,string password)
    onTypeChanged: {
        if(type === "login") {
            _button.text = "登录"
            _tipText.text = "Tips: 请验证账号密码"
        } else if(type === "register0"){     //注册管理员账号
            _button.text = "创建管理员账号"
            _tipText.text = "Tips: 这次你第一次使用本软件，请先注册一个属于你自己的账号（管理员）"
        } else {        //注册子账号
            _button.text = "创建附属账号"
            _tipText.text = "Tips: 正在创建附属账号"
        }
    }

    Item {
        width: 32
        height: 32
        z:2
        visible: type == "register1"
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 10
        }
        Image {
            anchors.fill: parent
            source: _returnMouseArea.containsMouse ? "qrc:/resource/images/return_hovered.png" :"qrc:/resource/images/return_unhovered.png"
            sourceSize: Qt.size(32,32)
        }
        MouseArea {
            id: _returnMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                request("","")
            }
        }
        ToolTip.visible: _returnMouseArea.containsMouse
        ToolTip.text: "返回"
    }

    Text {
        id: _welcome
        font.pixelSize: 24
        color: "#888888"   //"#F44336"
        text: "Welcome To Use Account Saver"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100
        font.bold: true
    }

    Rectangle {
        id: _container
        width: 300
        height: childrenRect.height
        border.color: "#cccccc"
        border.width: 1
        color: "transparent"
        radius: 4
        anchors {
            top: _welcome.bottom
            topMargin: 80
            horizontalCenter: parent.horizontalCenter
        }
        Column {
            width: parent.width
            height: childrenRect.height

            TextField {
                id: _account
                width: parent.width
                height: 40
                placeholderText: "账号"
                background: Item {}
                font.pixelSize: 18
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#ccc"
            }

            TextField {
                id: _password
                width: parent.width
                height: 40
                placeholderText: "密码"
                Layout.preferredHeight: parent.height
                background: Item {}
                font.pixelSize: 18
            }
        }
    }

    CheckBox {
          id: _checkbox
          text: qsTr("自动登录")
          checked: Global.appSettings.autoLogin
          visible: type === "login"
          anchors.top: _container.bottom
          anchors.topMargin: 8
          anchors.left: _container.left
          leftPadding: 0
          font.pixelSize: 14
          indicator: Rectangle {
              implicitWidth: 18
              implicitHeight: 18
              y: parent.height / 2 - height / 2
              radius: 3
              border.color: _checkbox.down ? Qt.lighter("#bbb",1.3) : "#bbb"

              Rectangle {
                  width: 10
                  height: 10
                  x: 4
                  y: 4
                  radius: 2
                  color: _checkbox.down ? Qt.darker("#4CAF50",1.3) : "#4CAF50"
                  visible: _checkbox.checked
              }
          }

          onCheckedChanged: {
              Global.appSettings.autoLogin = checked
          }

          contentItem: Text {
              text: _checkbox.text
              font: _checkbox.font
              opacity: enabled ? 1.0 : 0.3
              color: _checkbox.down ? Qt.darker("#bbb",1.3) : "#bbb"
              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter
              leftPadding: _checkbox.indicator.width + _checkbox.spacing
          }
      }

    Button {
        id: _button
        width: _container.width
        height: 40
        text: "登录"
        font.pixelSize: 20
        background: Rectangle {
            color: _button.pressed ? Qt.darker("#bbbbbb",1.3) : "#bbbbbb"
        }

        anchors {
            top: _checkbox.bottom
            topMargin: 8
            left: _container.left
        }
        onClicked: {
            if(_account.text === ""){
                prompt.show("账号不能为空")
            }else if(_password.text === "") {
                prompt.show("密码不能为空")
            } else {
                request(_account.text,_password.text)
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 30
        color: "#aa333333"
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: _tipText
            text: "Tips: 这次你第一次使用本软件，请先注册一个属于你自己的账号"
            font.pixelSize: 14
            anchors.centerIn: parent
            color: "#ccc"
        }
    }

}
