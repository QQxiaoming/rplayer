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

    bool isDarkTheme = true;
    QFontIcon::addFont(":/qt/qml/rplayer/res/fontawesome-webfont-v6.6.0-brands-400.ttf");
    QFontIcon::addFont(":/qt/qml/rplayer/res/fontawesome-webfont-v6.6.0-solid-900.ttf");
    QFontIcon::instance()->setColor(isDarkTheme?Qt::white:Qt::black);

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
    engine.loadFromModule("rplayer", "Main");

    return app.exec();
}
