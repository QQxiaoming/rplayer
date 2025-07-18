#ifndef RPLAYERDATAREADER_H
#define RPLAYERDATAREADER_H

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
#include <QStandardPaths>
#include <QDebug>

class RPlayerDataReader : public QObject {
    Q_OBJECT
public:
    explicit RPlayerDataReader(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QVariantMap readJsonUrl(const QString &filePath, const QString &jsonPath = "") {
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
            if(jsonPath == ""){
                jsonData.replace("{JSON_PATH}", fileInfo.absolutePath().toUtf8());
            } else {
                jsonData.replace("{JSON_PATH}", jsonPath.toUtf8());
            }

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

    Q_INVOKABLE void updateMediaJsonUrl(const QString &filePath, QVariantMap data) {
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
                if(item["path"].isString() && updateObject["path"].isString()) {
                    QString target = item["path"].toString();
                    if(target.replace("{JSON_PATH}", fileInfo.absolutePath().toUtf8()) == updateObject["path"].toString()) {
                        if(updateObject["info"].toString() == "") {
                            list.removeAt(i);
                        } else {
                            updateObject["path"] = QJsonValue(item["path"].toString());
                            if(item["icon"].isString() && updateObject["icon"].isString()) {
                                updateObject["icon"] = QJsonValue(item["icon"].toString());
                            }
                            list[i] = updateObject;
                        }
                        break;
                    }
                    if(target == updateObject["path"].toString()) {
                        if(updateObject["info"].toString() == "") {
                            list.removeAt(i);
                        } else {
                            if(item["icon"].isString() && updateObject["icon"].isString()) {
                                updateObject["icon"] = QJsonValue(item["icon"].toString());
                            }
                            list[i] = updateObject;
                        }
                        break;
                    }
                } else if(item["path"].isArray() && updateObject["path"].isArray()) {
                    QJsonArray target = item["path"].toArray();
                    QJsonArray update = updateObject["path"].toArray();
                    if(target.size() == update.size()) {
                        bool isSame1 = true;
                        for(int j = 0; j < target.size(); j++) {
                            if(target[j].toString().replace("{JSON_PATH}", fileInfo.absolutePath().toUtf8()) != update[j].toString()) {
                                isSame1 = false;
                                break;
                            }
                        }
                        if(isSame1) {
                            if(updateObject["info"].toString() == "") {
                                list.removeAt(i);
                            } else {
                                if(item["icon"].isString() && updateObject["icon"].isString()) {
                                    updateObject["icon"] = QJsonValue(item["icon"].toString());
                                }
                                updateObject["path"] = QJsonValue(target);
                                list[i] = updateObject;
                            }
                            break;
                        }
                        bool isSame2 = true;
                        for(int j = 0; j < target.size(); j++) {
                            if(target[j].toString() != update[j].toString()) {
                                isSame2 = false;
                                break;
                            }
                        }
                        if(isSame2) {
                            if(updateObject["info"].toString() == "") {
                                list.removeAt(i);
                            } else {
                                if(item["icon"].isString() && updateObject["icon"].isString()) {
                                    updateObject["icon"] = QJsonValue(item["icon"].toString());
                                }
                                list[i] = updateObject;
                            }
                            break;
                        }
                    }
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

    Q_INVOKABLE void updateUserJsonUrl(const QString &filePath, QVariantMap data) {
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
                if(item["name"].isString() && updateObject["name"].isString()) {
                    QString target = item["name"].toString();
                    if(target == updateObject["name"].toString()) {
                        list[i] = updateObject;
                        break;
                    }
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

    Q_INVOKABLE QString getDocumentsPath() {
        return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    }
};

#endif // RPLAYERDATAREADER_H
