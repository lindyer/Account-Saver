#ifndef APPLICATION_H
#define APPLICATION_H

#include <QApplication>
#include <qxtglobalshortcut.h>

class Application : public QApplication
{
    Q_OBJECT
public:
    explicit Application(int argc,char** argv);
    //globalCursorPos 全局光标位置
    Q_INVOKABLE QPoint globalCursorPos() const;
    //openUrl 启动桌面服务-浏览器Url
    Q_INVOKABLE void openUrl(const QString &url);
    //setClipBoardContent 设置剪切板的文本
    Q_INVOKABLE void setClipBoardContent(const QString &text);
    Q_INVOKABLE QVariant screenShot();          //屏幕截图保存,返回图片存放的路径
    Q_INVOKABLE QVariant startColorPicker(int mouseX, int mouseY);        //屏幕拾色
    Q_INVOKABLE bool registerGlobalShortcut(const QString &func,const QString& keySequence);
signals:
    void colorPicker();

public slots:
private:
    QImage *_screenshotImage;
    QHash<QString, QxtGlobalShortcut*> _shortcutHash;
};

#endif // APPLICATION_H
