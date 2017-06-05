pragma Singleton
import QtQuick 2.7
import Qt.labs.settings 1.0

Item {
    property string programName: "AccoutSaver"
    property string version: "v0.1"
    property var authors: ["lindyer"]
    property alias appSettings: _appSettings
    //save window info
    Settings {
        id: _appSettings
        property string shortcut_colorPicker: "Ctrl+Shift+Z"
        property bool autoLogin: false
        property string username: "nobody"
        property int permission
    }
}
