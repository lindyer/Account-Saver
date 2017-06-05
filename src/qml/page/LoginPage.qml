import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "../common"

Rectangle {
    id: _root
    color: '#eeeeee'
    signal accepted()
    property string type: "login"

    //登录
    BaseLoginPage {
        id: _loginPage
        type: _root.type
        onRequest: {
            var sql
            console.info(type)
            if(type == "login"){
                sql = "select * from users where username = '" + username +"' and password = '" +password +"'"
                var dataSet = dbm.dbSelect(sql);
                if(dataSet.length > 0) {
                    accepted() //登录成功
                    Global.appSettings.username = username
                    Global.appSettings.permission = dataSet[0].permission
                    prompt.show("欢迎回来")
                }else{
                    prompt.show("账号或者密码错误")
                }
            } else if (type == "register0") {       //管理员登录
                sql = "insert into users(username,password,permission) values ('" + username +"','" +password +"',0)"
                if(dbm.dbInsert(sql)) {
                    prompt.show("创建成功，下次启动软件则用此凭证登录",5000)
                    accepted()
                    Global.appSettings.username = username
                    Global.appSettings.permission = 0
                }else{
                    prompt.show("未知错误")
                }
            } else {
                if(username == "" || password == ""){
                    accepted()
                    return
                }
                sql = "insert into users (username,password,permission) values ('" + username +"','" +password +"',1)"
                if(dbm.dbInsert(sql)) {
                    prompt.show("创建成功，下次启动软件可用此凭证登录",5000)
                    accepted()
                } else {
                    prompt.show("未知错误")
                }
            }
        }
    }


}
