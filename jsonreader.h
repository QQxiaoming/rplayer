#ifndef JSONREADER_H
#define JSONREADER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QEventLoop>
#include <QDebug>

class JsonReader : public QObject {
    Q_OBJECT
public:
    explicit JsonReader(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QVariantMap readJsonUrl(const QString &filePath) {
        QUrl url(filePath);
        if(url.isLocalFile()) {
            // from LocalFile
            QFile file(url.toLocalFile());
            if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
                qWarning() << "Failed to open file:" << filePath;
                return QVariantMap();
            }

            QByteArray jsonData = file.readAll();
            file.close();

            QJsonDocument document = QJsonDocument::fromJson(jsonData);
            if (document.isNull() || !document.isObject()) {
                qWarning() << "Failed to parse JSON file:" << filePath;
                return QVariantMap();
            }

            return document.object().toVariantMap();
        } else {
            // from remote file
            QUrl url(filePath);
            QNetworkAccessManager *manager = new QNetworkAccessManager(this);
            QNetworkRequest request(url);
            QNetworkReply *reply = manager->get(request);
            QEventLoop loop;
            connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
            loop.exec();

            QByteArray jsonData = reply->readAll();
            reply->deleteLater();

            QJsonDocument document = QJsonDocument::fromJson(jsonData);
            if (document.isNull() || !document.isObject()) {
                qWarning() << "Failed to parse JSON file:" << filePath;
                return QVariantMap();
            }

            return document.object().toVariantMap();
        }
    }
};

#endif // JSONREADER_H
