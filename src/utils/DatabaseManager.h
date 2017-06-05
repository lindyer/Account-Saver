#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QVariant>
#include <QSqlDatabase>

class DatabaseManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool firstStart READ firstStart)
public:
    explicit DatabaseManager(QObject *parent = 0);

    Q_INVOKABLE bool dbInsert(const QString &sql);
    Q_INVOKABLE bool dbDelete(const QString &sql);
    Q_INVOKABLE bool dbUpdate(const QString &sql);
    Q_INVOKABLE QVariant dbSelect(const QString &sql);
    Q_INVOKABLE QVariant dbFieldNames(const QString &table);
    bool firstStart() const;
signals:

public slots:
private:
    QSqlDatabase _dbConnect;
    bool _firstStart = false;       //是否第一次启动软件
};

#endif // DATABASEMANAGER_H
