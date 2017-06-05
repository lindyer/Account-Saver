import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4 as QControls14
import "qrc:/src/qml/common/"
import "./common"
import "."
import QtGraphicalEffects 1.0
import QtQuick.Window 2.2
//import Common 1.0
//import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0


ApplicationWindow {
    id: appWindow
    visible: true
    width: 800
    height: 600
    minimumWidth: 800
    minimumHeight: 600
    flags: Qt.FramelessWindowHint | Qt.Window
    property color bgColor: rgba(250,250,250)
    property color headerColor: rgba(198,47,47)
    property bool isMaximized: false
    property real borderWidth: 10
    property point pressPos: Qt.point(0,0)
    function rgba(r,g,b,a){
        return Qt.rgba(r/255,g/255,b/255, (a || 255)/255)
    }
    color: "transparent"

    Component.onCompleted: {
        console.info(Global.version,headerColor)
        _startAnimation.start()
    }

    NumberAnimation {
        id: _startAnimation
        target: _root
        property: "scale"
        duration: 300
        from: 0
        to: 1.0
        easing.type: Easing.InOutQuad
    }
    NumberAnimation {
        id: _closeAnimation
        target: _root
        property: "scale"
        duration: 300
        from: 1.0
        to: 0
        easing.type: Easing.InOutQuad
        onStopped: close()
    }

    function mousePress() {
        pressPos = app.globalCursorPos()
    }

    //directX为-1时向左边，为1时向右边，为0时不变，directY -1向上边，1向下
    //判断增量正负，并结合directX和directY来改变窗口大小及位置，
    //以左上角为例：directX = -1 ，directY = -1
    //当deltaX为正时，即x变大，说明正在缩小窗口，反之则扩大窗口
    //当deltaY为正时，即Y变大，说明正在缩小窗口，反之则扩大窗口
    function mousePositionChange(directX,directY) {
        var tmpWidth,tmpHeight
        var pos = app.globalCursorPos()
        var deltaX = pos.x - pressPos.x
        var deltaY = pos.y - pressPos.y
        if(directX === 1) {
            tmpWidth = width + deltaX
            if(tmpWidth <= minimumWidth) {
                width = minimumWidth
            } else {
                width += deltaX
            }
        } else if(directX === -1) {  //需要改变x
            tmpWidth = width - deltaX
            if(deltaX > 0){
                if(tmpWidth <= minimumWidth){
                    width = minimumWidth
                }else {
                    x += deltaX
                    width = tmpWidth
                }
            }else{
                x += deltaX
                width = tmpWidth
            }
        }
        if(directY === 1) {   //y不变，height变
            tmpHeight = height + deltaY
            if(tmpHeight <= minimumHeight) {
                height = minimumHeight
            } else {
                height = tmpHeight
            }
        } else if(directY === -1) { //y和height都变
            tmpHeight = height - deltaY
            if(deltaY > 0){
                if(tmpHeight <= minimumHeight){
                    height = minimumHeight
                }else {
                    y += deltaY
                    height = tmpHeight
                }
            }else{
                y += deltaY
                height = tmpHeight
            }
        }
        pressPos = pos
    }

    property alias prompt: _prompt
//    property alias screenImage: _screenShot
    Item {
        id: _root
        anchors.fill: parent
        Prompt {
            id: _prompt
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: "transparent"
        }

        RectangularGlow {
            id: effect
            anchors.fill: _contentContainer
            glowRadius: borderWidth
            spread: 0.2
            color: "#22666666"
            cornerRadius: glowRadius + _contentContainer.radius
        }

        //5
        Rectangle {
            id: _contentContainer
            color: "white"
            anchors.centerIn: parent
            width: parent.width - borderWidth * 2
            height: parent.height - borderWidth * 2
            radius: 2
            clip: true
            Rectangle {
                id: _header
                width: parent.width
                height: 40
                color: headerColor
                Movable {
                    onDoubleClicked: {
                        if(isMaximized) {
                            appWindow.showNormal()
                            borderWidth = 10
                        } else {
                            appWindow.showMaximized()
                            borderWidth = 0
                        }
                        isMaximized = !isMaximized
                    }
                }

                Item {
                    width: _programName.paintedWidth
                    height: parent.height
                    Text {
                        id: _programName
                        text: "Account Saver"
                        font {
                            bold: true
                            pixelSize: 16
                        }
                        color: "white"
                        anchors {
                            left: parent.left
                            leftMargin: 15
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            _drawer.open()
                        }
                    }
                }

                Row {
                    anchors {
                        right: parent.right
                        rightMargin: 8
                        verticalCenter: parent.verticalCenter
                    }
                    IconButton {
                        hoveredUrl: "qrc:/resource/images/min_hovered.png"
                        unhoveredUrl: "qrc:/resource/images/min_unhovered.png"
                        onClicked: appWindow.showMinimized()
                    }
                    IconButton {
                        hoveredUrl: "qrc:/resource/images/max_hovered.png"
                        unhoveredUrl: "qrc:/resource/images/max_unhovered.png"
                        onClicked: {
                            if(isMaximized) {
                                appWindow.showNormal()
                                borderWidth = 10
                            } else {
                                appWindow.showMaximized()
                                borderWidth = 0
                            }
                            isMaximized = !isMaximized
                        }
                    }
                    IconButton {
                        hoveredUrl: "qrc:/resource/images/close_hovered.png"
                        unhoveredUrl: "qrc:/resource/images/close_unhovered.png"
                        onClicked: {
                            _closeAnimation.start()
                        }
                    }
                }
            }

            StackView {
                id: _stackView
                width: parent.width
                height: parent.height - _header.height
                background: Rectangle {
                    color: bgColor
                }
                anchors.top: _header.bottom
                Component.onCompleted: {
                    var mainPage,loginPage
                    console.info(Global.appSettings.username,Global.appSettings.autoLogin)
                    if(!Global.appSettings.autoLogin || Global.appSettings.username === "nobody") {
                        var type
                        if(dbm.firstStart) {
                            type = "register0"
                        }else{
                            type = "login"
                        }
                        loginPage = _stackView.push("qrc:/src/qml/page/LoginPage.qml",{"type":type})
                        loginPage.accepted.connect(function(){
                            mainPage = _stackView.replace(loginPage,"qrc:/src/qml/page/MainPage.qml")
                            mainPage.createSubAdmin.connect(function(){
                                loginPage = _stackView.push("qrc:/src/qml/page/LoginPage.qml",{"type":"register1"})
                                loginPage.accepted.connect(function(){
                                    _stackView.pop()
                                    mainPage.finishCreateSubAdmin()
                                })
                            })
                        })
                    }else {
                        mainPage = _stackView.push("qrc:/src/qml/page/MainPage.qml")
                        mainPage.createSubAdmin.connect(function(){
                            loginPage = _stackView.push("qrc:/src/qml/page/LoginPage.qml",{"type":"register1"})
                            loginPage.accepted.connect(function(){
                                _stackView.pop()
                                mainPage.finishCreateSubAdmin()
                            })
                        })
                    }
                }
            }

            Drawer {
                id: _drawer
                width: 160
                height: parent.height - _header.height - borderWidth * 2
                bottomMargin: borderWidth
                topMargin: _header.height + borderWidth
                leftMargin: borderWidth
                clip: true
                leftPadding: borderWidth
                dim: false
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                background: Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: borderWidth
                    height: parent.height
                    color: "#66666666"
                }
                transformOrigin: Popup.Left
                enter: Transition {
                    NumberAnimation { property: "width"; from: 0;to: 160 ;duration: 300}
                }
                exit: Transition {
                    NumberAnimation { property: "width"; from: 160 ;to: 0 ;duration: 300}
                }

                Item {
                    anchors.centerIn: parent
                    width: parent.width
                    height: childrenRect.height
                    clip: true
                    Text {
                        text: "© 2017 Jenpen \n当前版本： V0.1\n"
                        font.family: "Helvetica [Cronyx]"
                        font.weight: Font.Medium
                        font.pixelSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        //                        color: "white"
                    }
                }
            }

        }
    /* 使用 import Qt.labs.platform 1.0   ColorDialog代替

        Rectangle {
            id: _screenShot
            anchors.centerIn: parent
            width: parent.width - borderWidth * 2
            height: parent.height - borderWidth * 2
            visible: false
            property alias source:_screenshotImage.source

            Image {  //效果不理想
                id: _screenshotImage
                anchors.fill: parent
                cache: false
                autoTransform: true
                sourceSize: Qt.size(width,height)
                smooth: true
            }

            MouseArea {
                id: _screenshotMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onPositionChanged: {
                    var color = app.startColorPicker(mouseX,mouseY) //获取颜色了
                    _colorText.text = color.toString().toUpperCase()
                }
                onDoubleClicked: { //
                    _colorDialog.open()
                }
            }

            ColorDialog {
                id: _colorDialog
                currentColor: _colorText.text
            }

            Rectangle {
                height: childrenRect.height
                width: childrenRect.width
                color: "#aa000000"
                x: _screenshotMouseArea.mouseX + 10
                y: _screenshotMouseArea.mouseY - 5
                Text {
                    id: _colorText
                    font.pixelSize: 14
                    height: paintedHeight+2
                    width: paintedWidth+4
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "white"
                }
            }
            Keys.onEscapePressed: {
                showNormal()
                _screenShot.visible = false
            }


        }

  */
        //1
        Item {
            id: _leftTopCorner
            width: borderWidth
            height: borderWidth
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeFDiagCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(-1,-1)
            }
        }
        //2
        Item {
            id: _top
            width: parent.width - borderWidth * 2
            anchors.left: _leftTopCorner.right
            height: borderWidth
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeVerCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(0,-1)
            }
        }
        //3
        Item {
            id: _rightTopCorner
            width: borderWidth
            height: borderWidth
            anchors.right: parent.right
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeBDiagCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(1,-1)
            }
        }
        //4
        Item {
            id: _left
            width: borderWidth
            height: parent.height - borderWidth * 2
            anchors.top: _leftTopCorner.bottom
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(-1,0)
            }
        }

        //6
        Item {
            id: _rightContainer
            width: borderWidth
            height: parent.height - borderWidth * 2
            anchors.right: parent.right
            anchors.top: _rightTopCorner.bottom
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeHorCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(1,0)
            }
        }
        //7
        Item {
            id: _leftBottomCorner
            width: borderWidth
            height: borderWidth
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeBDiagCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(-1,1)
            }
        }
        //8
        Item {
            id: _bottom
            width: parent.width - borderWidth * 2
            height: borderWidth
            anchors.bottom: parent.bottom
            anchors.left: _leftBottomCorner.left
            anchors.leftMargin: borderWidth
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeVerCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(0,1)
            }
        }
        //9
        Item {
            id: _rightBottomCorner
            width: borderWidth
            height: borderWidth
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.SizeFDiagCursor
                onPressed: mousePress()
                onPositionChanged: mousePositionChange(1,1)
            }
        }
    }

    function showAllRecord() {
        print("------------- All Records -------------")
        var array = dbm.dbSelect("select * from accounts")
        for(var i = 0;i < array.length; ++i){
            print(">>",array[i].website,array[i].account,array[i].password,array[i].comment)
        }
    }

    //    overlay.modal: Rectangle {
    //        color: "#2f28282a"
    //    }

    //    overlay.modeless: Rectangle {
    //        color: "#2f28282a"
    //    }

}
