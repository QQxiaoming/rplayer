#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QtEnvironmentVariables>

#include "jsonreader.h"
#include "fonticon.h"

int main(int argc, char *argv[])
{
    qputenv("QT_SCALE_FACTOR","0.25");
    QGuiApplication app(argc, argv);

    QFontIcon::addFont(":/qt/qml/rplayerui/res/fontawesome-webfont-v6.6.0-brands-400.ttf");
    QFontIcon::addFont(":/qt/qml/rplayerui/res/fontawesome-webfont-v6.6.0-solid-900.ttf");
    QFontIcon::instance()->setColor(Qt::white);

    QQmlApplicationEngine engine;

    JsonReader jsonReader;
    engine.rootContext()->setContextProperty("jsonReader", &jsonReader);
    FontIcon fontIcon;
    engine.rootContext()->setContextProperty("fontIcon", &fontIcon);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("rplayerui", "Main");

#if defined(Q_OS_WINDOSW) || defined(Q_OS_LINUX) || defined(Q_OS_MACOS)
    QList<QObject*> objList = engine.rootObjects();
    QObject *rootObject = objList.first();
    if (QQuickWindow *window = qobject_cast<QQuickWindow *>(rootObject)) {
        window->setMinimumSize(QSize(1080, 1920));
    }
#endif

    return app.exec();
}
