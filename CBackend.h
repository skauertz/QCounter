/*
Copyright (C) 2021 by Sebastian Kauertz.

This file is part of QCounter, a QML-based counter.

QCounter is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

QCounter is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef CBACKEND_H
#define CBACKEND_H

#include <QObject>
#include <QShortcut>
#include <QtWidgets/QApplication>
#include <QScreen>
#include <QFile>
#include <QTextStream>


class CBackend : public QObject
{
    Q_OBJECT  // IMPORTANT - without it e.g. signals won't work

public:
    explicit CBackend(QObject *parent = nullptr);
    ~CBackend();


    Q_PROPERTY(qint16  settingNegative     MEMBER m_settingNegative      NOTIFY settingChanged)
    Q_PROPERTY(qint16  settingUpperLimit   MEMBER m_settingUpperLimit    NOTIFY settingChanged)
    Q_PROPERTY(qint16  settingLowerLimit   MEMBER m_settingLowerLimit    NOTIFY settingChanged)
    Q_PROPERTY(qint16  settingWrap         MEMBER m_settingWrap          NOTIFY settingChanged)
    Q_PROPERTY(qint32  UpperLimit          MEMBER m_UpperLimit           NOTIFY settingChanged)
    Q_PROPERTY(qint32  LowerLimit          MEMBER m_LowerLimit           NOTIFY settingChanged)
    Q_PROPERTY(qint16  windowPosX          MEMBER m_windowPosX           NOTIFY windowPosChanged)
    Q_PROPERTY(qint16  windowPosY          MEMBER m_windowPosY           NOTIFY windowPosChanged)
    Q_PROPERTY(quint16 windowWidth         MEMBER m_windowWidth          NOTIFY windowPosChanged)
    Q_PROPERTY(quint16 windowHeight        MEMBER m_windowHeight         NOTIFY windowPosChanged)

    Q_INVOKABLE void savePosition(int x, int y, int width, int height);

    void setup(QApplication *app = nullptr);
    bool readIniFile();
    void writeIniFile();
    void updatePosition();


signals:
    void windowPosChanged();
    void settingChanged();


private:
    // Settings
    qint16  m_settingNegative;
    qint16  m_settingUpperLimit;
    qint16  m_settingLowerLimit;
    qint16  m_settingWrap;
    qint32  m_UpperLimit;
    qint32  m_LowerLimit;
    qint16  m_windowPosX, m_windowPosY;
    quint16 m_windowWidth, m_windowHeight;
    qint16  m_windowPosXSave, m_windowPosYSave;
    quint16 m_windowWidthSave, m_windowHeightSave;
    QScreen *Screen;
    QRect   ScreenSize;


};

#endif // CBACKEND_H
