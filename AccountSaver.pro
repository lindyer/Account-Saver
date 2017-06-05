
#
# 项目名称：账号密码保存器
# 创建时间：2017/5/30
# 作者： Jenpen
#


QT += qml quick sql widgets

CONFIG += c++11

SOURCES += src/main.cpp \
    src/utils/DatabaseManager.cpp \
    src/core/Application.cpp

RESOURCES += qml.qrc

DESTDIR = ./

include(src/thirdparty/qxtglobalshortcut5/qxt.pri)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/src/qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

win32 {
    QT += winextras
    RC_ICONS = resource/images/app.ico
}
mac{
    ICON = resource/images/app.icns
}

HEADERS += \
    src/utils/DatabaseManager.h \
    src/core/Application.h

INCLUDEPATH += src/core \
            src/utils
            src/thirdparty/qxtglobalshortcut5
