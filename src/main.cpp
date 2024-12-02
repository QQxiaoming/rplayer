#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QtEnvironmentVariables>
#if QT_CONFIG(permissions)
#include <QPermissions>
#endif

#include "jsonreader.h"
#include "fonticon.h"

void checkCameraPermission(void) {
#if QT_CONFIG(permissions)
    QCameraPermission cameraPermission;
    switch (qApp->checkPermission(cameraPermission)) {
        case Qt::PermissionStatus::Undetermined:
            qApp->requestPermission(cameraPermission, qApp, &checkCameraPermission);
            return;
        case Qt::PermissionStatus::Denied:
            qDebug() << "Camera permission is not granted!";
            return;
        case Qt::PermissionStatus::Granted:
            qDebug() << "Camera permission is granted!";
            break;
    }
#endif
}

bool checkAuthorizationStatus(bool block) {
    bool ret = false;
#if QT_CONFIG(permissions)
    QCameraPermission cameraPermission;
    Qt::PermissionStatus auth_status = Qt::PermissionStatus::Undetermined;
    while(true) {
        QThread::msleep(1);
        auth_status = qApp->checkPermission(cameraPermission);
        if(auth_status == Qt::PermissionStatus::Denied) {
            if(!block) {
                return ret;
            }
        } else if(auth_status == Qt::PermissionStatus::Granted) {
            ret = true;
            break;
        } else if(auth_status == Qt::PermissionStatus::Undetermined)
            continue;
        break;
    }
#else
    ret = true;
#endif
    return ret;
}

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
    engine.loadFromModule(MAIN_UI_NAME, "Main");

#if defined(Q_OS_WINDOSW) || defined(Q_OS_LINUX) || defined(Q_OS_MACOS)
    QList<QObject*> objList = engine.rootObjects();
    QObject *rootObject = objList.first();
    if (QQuickWindow *window = qobject_cast<QQuickWindow *>(rootObject)) {
        window->setMinimumSize(QSize(1080, 1920));
        window->resize(QSize(1080, 1920));
    }
#endif

    checkCameraPermission();
    checkAuthorizationStatus(true);

    return app.exec();
}
