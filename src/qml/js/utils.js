.pragma library

//根据KeyEvent获得快捷键，返回值为快捷键字符串
function shortcut(event) {
    if((event.modifiers == Qt.ShiftModifier
        || event.modifiers == Qt.ControlModifier
        || event.modifiers == Qt.AltModifier
        || event.modifiers == (Qt.ControlModifier | Qt.ShiftModifier)
        || event.modifiers == (Qt.ControlModifier | Qt.AltModifier)
        || event.modifiers == (Qt.ShiftModifier | Qt.AltModifier))
            && event.key != Qt.Key_unknown){
        var keySequence = "";
        if(event.modifiers == Qt.ControlModifier){
            keySequence = "Ctrl+"
        }else if(event.modifiers == Qt.ShiftModifier){
            keySequence = "Shift+"
        }else if(event.modifiers == Qt.AltModifier){
            keySequence = "Alt+"
        }else if(event.modifiers == (Qt.ControlModifier | Qt.ShiftModifier)){
            keySequence = "Ctrl+Shift+"
        }else if(event.modifiers == (Qt.ControlModifier | Qt.AltModifier)){
            keySequence = "Ctrl+Alt+"
        }else if(event.modifiers == (Qt.ShiftModifier | Qt.AltModifier)){
            keySequence = "Shift+Alt+"
        }else{
//            console.log("Unknowed Modifier");
            return ""
        }
        if(event.key >= Qt.Key_0 && event.key <= Qt.Key_9){  //数字0-9
            keySequence += String(event.key - Qt.Key_0)
        }else if(event.key >= Qt.Key_A && event.key <= Qt.Key_Z){ //A-Z
            keySequence += String.fromCharCode(event.key - Qt.Key_A + "A".charCodeAt())
        }else if(event.key >= Qt.Key_F1 && event.key <= Qt.Key_F12){//F1-F12
            keySequence += "F" + String(event.key - Qt.Key_F1 + 1)
        }else if(event.key == Qt.Key_Escape){
            keySequence += "Esc"
        }else {
//            console.log("Unsupport Key");
            return ""
        }
        return keySequence
    }
    return ""
}
