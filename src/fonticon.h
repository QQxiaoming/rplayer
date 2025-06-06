#ifndef FONTICON_H
#define FONTICON_H

#include <QObject>
#include <QIcon>
#include <QDebug>

#include "qfonticon.h"

class FontIcon : public QObject {
    Q_OBJECT
public:
    explicit FontIcon(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QString getIcon(const QString &codePoint, const QString &color = "Default", int size = 100) {
        if(size <= 0) {
            return QString();
        }
        bool isOk = false;
        uint16_t code = codePoint.toUShort(&isOk, 16);
        if (isOk) {
            QColor c = QFontIcon::instance()->baseColor;
            if(color != "Default") {
                c = QColor(color);
            }
            QIcon icon = QFontIcon::icon(QChar(code),c);
            QPixmap pixmap = icon.pixmap(size, size);
            QImage image = pixmap.toImage();
            QByteArray byteArray;
            QBuffer buffer(&byteArray);
            buffer.open(QIODevice::WriteOnly);
            image.save(&buffer, "PNG");
            if(byteArray.isEmpty()) {
                return QString();
            }
            return QString("data:image/png;base64,") + byteArray.toBase64();
        }
        return QString();
    }
};

#endif // RPLAYERDATAREADER_H
