#include "DatabaseManager.h"
#include "Application.h"

//Qt Header
#include <QQmlApplicationEngine>
#include <QtQml/QQmlContext>

int main(int argc, char *argv[])
{
    Application app(argc, argv);
    app.setOrganizationName("Jenpen");
    app.setOrganizationDomain("lindyer.github.io");
    app.setApplicationName("AccountSaver");
    QQmlApplicationEngine engine;
    engine.addImportPath(":/src/qml");
    engine.rootContext()->setContextProperty("app",&app);
    engine.rootContext()->setContextProperty("dbm",new DatabaseManager());
    engine.load(QUrl(QLatin1String("qrc:/src/qml/main.qml")));
    return app.exec();
}
