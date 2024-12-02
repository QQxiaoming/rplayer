#ifndef JSONREADER_H
#define JSONREADER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QFileInfo>
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
            QFileInfo fileInfo(file);
            if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
                qWarning() << "Failed to open file:" << filePath;
                return QVariantMap();
            }

            QByteArray jsonData = file.readAll();
            file.close();
            jsonData.replace("{JSON_PATH}", fileInfo.absolutePath().toUtf8());

            QJsonDocument document = QJsonDocument::fromJson(jsonData);
            if (document.isNull() || !document.isObject()) {
                qWarning() << "Failed to parse Local JSON file:" << filePath;
                return QVariantMap();
            }

            return document.object().toVariantMap();
        } else if(url.isValid()) {
            // from remote file
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
                qWarning() << "Failed to parse remote JSON file:" << filePath;
                return QVariantMap();
            }

            return document.object().toVariantMap();
        } else {
            QByteArray jsonData = filePath.toUtf8();

            QJsonDocument document = QJsonDocument::fromJson(jsonData);
            if (document.isNull() || !document.isObject()) {
                qWarning() << "Failed to parse JSON file:" << filePath;
                return QVariantMap();
            }
            return document.object().toVariantMap();
        }
    }

    Q_INVOKABLE void updateJsonUrl(const QString &filePath, QVariantMap data) {
        QJsonDocument updateDocument = QJsonDocument::fromVariant(data);
        QJsonObject updateObject = updateDocument.object();

        QUrl url(filePath);
        if(url.isLocalFile()) {
            QFile file(url.toLocalFile());
            QFileInfo fileInfo(file);
            if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
                qWarning() << "Failed to open file:" << filePath;
                return;
            }

            QByteArray jsonData = file.readAll();
            file.close();

            QJsonDocument document = QJsonDocument::fromJson(jsonData);
            if (document.isNull() || !document.isObject()) {
                qWarning() << "Failed to parse Local JSON file:" << filePath;
                return;
            }
            QJsonObject obj = document.object();
            QJsonArray list = obj["list"].toArray();
            for(int i = 0; i < list.size(); i++) {
                QJsonObject item = list[i].toObject();
                QString target = item["path"].toString();
                if(target.replace("{JSON_PATH}", fileInfo.absolutePath().toUtf8()) == updateObject["path"].toString()) {
                    if(updateObject["info"].toString() == "") {
                        list.removeAt(i);
                    } else {
                        updateObject["path"] = target;
                        list[i] = updateObject;
                    }
                    break;
                }
                if(target == updateObject["path"].toString()) {
                    if(updateObject["info"].toString() == "") {
                        list.removeAt(i);
                    } else {
                        list[i] = updateObject;
                    }
                    break;
                }
            }
            obj["list"] = list;
            QJsonDocument updateDocument(obj);
            if(!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
                qWarning() << "Failed to open file:" << filePath;
                return;
            }
            file.write(updateDocument.toJson());
            file.close();
        } 
    }
};

#endif // JSONREADER_H
