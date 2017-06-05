#include "DatabaseManager.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>
#include <QDir>
#include <QCoreApplication>
#include <QDateTime>
#include <QJsonObject>
#include <QJsonArray>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{
    QDir appDir = QCoreApplication::applicationDirPath();
    QString tmpPath = appDir.path().append("/data");
    QDir tmpDir(tmpPath);
    if(!tmpDir.exists()){
        appDir.mkdir("data");
    }
    QString dbPath = tmpPath.append("/accounts.db");
    QFile file(dbPath);
    if(!QSqlDatabase::drivers().contains("SQLITECIPHER")){
        qWarning()<<"Error: SQLITECIPHER driver is not exist";
        return;
    }
    _dbConnect = QSqlDatabase::addDatabase("SQLITECIPHER");
    _dbConnect.setDatabaseName(dbPath);
    _dbConnect.setPassword("lindyer");
    if(!QFile::exists(dbPath)){  //如果不存在数据库，则创建
        _firstStart = true;
        qDebug()<<"renew db file"<<"新建数据库及账号";
        file.open(QIODevice::WriteOnly);
        file.close();
        _dbConnect.setConnectOptions("QSQLITE_CREATE_KEY");
        if(!_dbConnect.open()){
            qWarning()<<"Warn: accounts.db open failed";
            return ;
        }
        QSqlQuery query(_dbConnect);
        QString sql = "CREATE TABLE accounts([id] INTEGER PRIMARY KEY,[website] TEXT,[account] TEXT,[password] TEXT,comment TEXT,[createdtime] TIMESTAMP NOT NULL DEFAULT (datetime('now','localtime')))";
        if(!query.exec(sql)) {
            qDebug() << "表accounts创建失败";
        }
        sql = "CREATE TABLE users([id] INTEGER PRIMARY KEY,[username] TEXT,[password] TEXT,[permission] INTEGER NOT NULL DEFAULT (1) )";
        if(!query.exec(sql)) {
            qDebug() << "表users创建失败";
        }
    }else {
        _dbConnect.open();
        //查找是否存在管理员
        QVariant dataSet = dbSelect("select * from users where permission = 0");
        if(dataSet.toJsonArray().isEmpty()){
            _firstStart = true;
        }
    }
}

bool DatabaseManager::dbInsert(const QString &sql)
{
    QSqlQuery query(_dbConnect);
    bool ok = query.exec(sql);
    return ok;
}

bool DatabaseManager::dbDelete(const QString &sql)
{
    QSqlQuery query(_dbConnect);
    return query.exec(sql);
}

bool DatabaseManager::dbUpdate(const QString &sql)
{
    QSqlQuery query(_dbConnect);
    return query.exec(sql);
}

QVariant DatabaseManager::dbSelect(const QString &sql)
{
    QSqlQuery query(_dbConnect);
    QJsonArray jsonArray;
    if(query.exec(sql)){
        while(query.next()){
            QSqlRecord record = query.record();
            QJsonObject jsonObject;
            for(int i = 0;i < record.count(); ++i){
                QString type = query.value(record.fieldName(i)).typeName();
                if(type == "qlonglong"){
                    jsonObject.insert(record.fieldName(i),query.value(record.fieldName(i)).toInt());
                }else if(type == "QString"){
                    jsonObject.insert(record.fieldName(i),query.value(record.fieldName(i)).toString());
                }
            }
            qDebug()<<jsonObject;
            jsonArray.append(jsonObject);
//            long long timestamp = query.value(5).toLongLong();
//            QDateTime dateTime;
//            dateTime.setMSecsSinceEpoch(timestamp);
//            qDebug()<<id<<website<<account<<password<<comment<<timestamp<<dateTime.toString("yyyy-MM-dd hh:mm:ss");
        }
    }
    return QVariant(jsonArray);
}

QVariant DatabaseManager::dbFieldNames(const QString &table)
{
    QSqlQuery query(_dbConnect);
    QString sql = "select * from "+ table + " limit 1";
    if(query.exec(sql)){
        QSqlRecord record = query.record();
        QJsonArray jsonArray;
        for(int i = 0;i < record.count(); ++i){
            jsonArray.append(record.fieldName(i));
        }
        return jsonArray;
    }else {
        return QVariant(QJsonArray());
    }
}

bool DatabaseManager::firstStart() const
{
    return _firstStart;
}
