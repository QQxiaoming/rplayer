#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QtEnvironmentVariables>

#include "rplayerdatareader.h"
#include "fonticon.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WINDOSW) || defined(Q_OS_LINUX) || defined(Q_OS_MACOS)
    qputenv("QT_SCALE_FACTOR","0.25");
#else
    qputenv("QT_SCALE_FACTOR","0.4");
#endif
    QGuiApplication app(argc, argv);

    QFontIcon::addFont(QString(":/qt/qml/")+MAIN_UI_NAME+"/res/fontawesome-webfont-v6.6.0-brands-400.ttf");
    QFontIcon::addFont(QString(":/qt/qml/")+MAIN_UI_NAME+"/res/fontawesome-webfont-v6.6.0-solid-900.ttf");
    QFontIcon::instance()->setColor(Qt::white);

    QQmlApplicationEngine engine;

    RPlayerDataReader rPlayerDataReader;
    engine.rootContext()->setContextProperty("rPlayerDataReader", &rPlayerDataReader);
    FontIcon fontIcon;
    engine.rootContext()->setContextProperty("fontIcon", &fontIcon);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule(MAIN_UI_NAME, "Main");

#if defined(Q_OS_WINDOSW) || defined(Q_OS_LINUX) || defined(Q_OS_MACOS)
    QList<QObject*> objList = engine.rootObjects();
    QObject *rootObject = objList.first();
    if (QQuickWindow *window = qobject_cast<QQuickWindow *>(rootObject)) {
        window->setMinimumSize(QSize(1080, 1920));
        window->resize(QSize(1080, 1920));
    }
#endif

    return app.exec();
}
