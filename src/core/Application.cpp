#include "Application.h"
#include <QDesktopServices>
#include <QUrl>
#include <QDebug>
#include <QClipboard>
#include <QCursor>
#include <QScreen>
#include <QImage>
#include <QPixmap>
#include <QDir>


Application::Application(int argc, char **argv) : QApplication(argc,argv),
    _screenshotImage(Q_NULLPTR)
{

}

QPoint Application::globalCursorPos() const
{
    return QCursor::pos();
}

void Application::openUrl(const QString &url)
{
    if(url.isEmpty()){
        return;
    }
    QDesktopServices::openUrl(QUrl(url));
}

void Application::setClipBoardContent(const QString &text)
{
    clipboard()->setText(text);
}

QVariant Application::screenShot()
{
    QScreen *screen = QGuiApplication::primaryScreen();
    QImage image = screen->grabWindow(0).toImage();
    QDir appDir = applicationDirPath();
    QString tmpPath = appDir.path().append("/temp");
    QDir tmpDir(tmpPath);
    if(!tmpDir.exists()){
        appDir.mkdir("temp");
    }
    if(image.save("./temp/screen.png")){
        return tmpDir.absoluteFilePath("screen.png");
    }
    return QUrl();
}

QVariant Application::startColorPicker(int mouseX,int mouseY)
{
    if(_screenshotImage == Q_NULLPTR){
        _screenshotImage = new QImage("./temp/screen.png");
    }
    if(!_screenshotImage->isNull()){
        return _screenshotImage->pixelColor(mouseX,mouseY);
    }
    return QVariant();
}

bool Application::registerGlobalShortcut(const QString &func,const QString &keySequence)
{
    QxtGlobalShortcut *shortcut;
    if(_shortcutHash.contains(func)){
        shortcut = _shortcutHash.value(func);
    } else {
        shortcut = new QxtGlobalShortcut(this);
        _shortcutHash.insert(func,shortcut);
    }
    shortcut->disconnect();
    bool result = shortcut->setShortcut(QKeySequence(keySequence));
    if(result) {
        if(func == "colorPicker"){
            connect(shortcut,&QxtGlobalShortcut::activated,[&]{
                emit colorPicker();
            });
        }
    }
    return result;
}
