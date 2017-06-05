import QtQuick 2.7
import "qrc:/src/qml/common/"
import "../common"
import "."
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item {
    id: _root
    signal createSubAdmin
    function finishCreateSubAdmin(){
        _functionExtensionPage.finishCreateSubAdmin()
    }

    Rectangle {
        id: _funcContainer
        width: 80
        height: parent.height
        color: bgColor

        ButtonGroup {
            buttons: _funcGroup.children
        }
        Column {
            id: _funcGroup
            anchors.fill: parent
            SideButton {
                text: "账号管理"
                checked: true
                onClicked: {
                    _container.currentIndex = 0
                }
            }
            SideButton {
                text: "功能扩展"
                onClicked: {
                    _container.currentIndex = 2
                }
            }
        }

    }

    StackLayout {
        id: _container
        anchors {
            left: _funcContainer.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        currentIndex: 0
        onCurrentIndexChanged: {
            switch (currentIndex) {
            case 0:
                _accountManagePage.opacity = 1;
                _addAccountPage.opacity = 0;
                _functionExtensionPage.opacity = 0;
                break;
            case 1:
                _accountManagePage.opacity = 0;
                _addAccountPage.opacity = 1;
                _functionExtensionPage.opacity = 0;
                break;
            case 2:
                _accountManagePage.opacity = 0
                _addAccountPage.opacity = 0;
                _functionExtensionPage.opacity = 1;
                break;
            }
        }

        AccountManagePage {
            id: _accountManagePage
            anchors.fill: parent
            onTurnToAccountManagePage: {
                _container.currentIndex = 1
            }
            Behavior on opacity {
                NumberAnimation { duration: 800 }
            }
        }

        AddAccountPage {
            id: _addAccountPage
            anchors.fill: parent
            opacity: 0
            onRefreshTable: {
                _accountManagePage.refresh()
            }
            onTurntoAccountManagePage: {
                _container.currentIndex = 0
            }

            Behavior on opacity {
                NumberAnimation { duration: 800 }
            }
        }

        FunctionExtensionPage {
            id: _functionExtensionPage
            opacity: 0
            anchors.fill: parent
            Behavior on opacity {
                NumberAnimation { duration: 800 }
            }
            onCreateSubAdmin: {
                _root.createSubAdmin()
            }
        }
    }

}
