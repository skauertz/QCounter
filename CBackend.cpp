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

#include "CBackend.h"

CBackend::CBackend(QObject *parent) : QObject(parent)
{

    Screen = QApplication::primaryScreen();
    ScreenSize = Screen->geometry();
    // Default position for the window:
    m_windowPosX = ScreenSize.width() - 200 - 50;
    m_windowPosY = ScreenSize.height()/2 - 180/2;
    m_windowWidth  = 200;
    m_windowHeight = 180;
    connect(qApp, &QApplication::screenRemoved, this, &CBackend::updatePosition);
    connect(qApp, &QApplication::primaryScreenChanged, this, &CBackend::updatePosition);


    // Default values for settings:
    m_settingNegative     = 0;
    m_settingUpperLimit   = 0;
    m_settingLowerLimit   = 0;
    m_settingWrap         = 0;
    m_UpperLimit          = 999999;
    m_LowerLimit          = 0;

    // Load ini file:
    readIniFile();

    emit windowPosChanged();
    emit settingChanged();

}


CBackend::~CBackend()
{

}


void CBackend::setup(QApplication *app)
{
// Actions to be done after QML has been loaded

    // Connect quit signal to writeIniFile:
    QObject::connect(app, &QApplication::aboutToQuit, this, &CBackend::writeIniFile);

}


void CBackend::updatePosition()
{
//  Update the main window position when a change of primary screen is detected
    //qInfo("updatePosition");

    // We only need to emit the signal so the QML updates the position to the last read one
    // m_windowPosX and m_windowPosY have not changed since reading the ini file
    emit windowPosChanged();
}



void CBackend::savePosition(int x, int y, int width, int height)
{
//  Memorize position and size of main window upon closing
    m_windowPosXSave   = x;
    m_windowPosYSave   = y;
    m_windowWidthSave  = width;
    m_windowHeightSave = height;
    //qInfo("Window position saved.");

}


bool CBackend::readIniFile()
{
// Read data from ini file
    QFile inifile("QCounter.ini");
    QString line;
    QString param;


    if (!inifile.open(QIODevice::ReadOnly)) {
        qWarning("Could not read ini file - QCounter.ini!");
        return false;
    }
    QTextStream in(&inifile);

    while (!in.atEnd()) {
        line = in.readLine();
        param = line.section("=",0,0);
        if      (param=="WindowPosX")   m_windowPosX   = line.section("=",1,1).toInt();
        else if (param=="WindowPosY")   m_windowPosY   = line.section("=",1,1).toInt();
        else if (param=="WindowWidth")  m_windowWidth  = line.section("=",1,1).toInt();
        else if (param=="WindowHeight") m_windowHeight = line.section("=",1,1).toInt();
        else if (param=="NegativeValues")    m_settingNegative     =  line.section("=",1,1).toInt();
        else if (param=="UpperLimit")        m_settingUpperLimit   =  line.section("=",1,1).toInt();
        else if (param=="UpperLimitValue")   m_UpperLimit          =  line.section("=",1,1).toInt();
        else if (param=="LowerLimit")        m_settingLowerLimit   =  line.section("=",1,1).toInt();
        else if (param=="LowerLimitValue")   m_LowerLimit          =  line.section("=",1,1).toInt();
        else if (param=="Wrap")              m_settingWrap         =  line.section("=",1,1).toInt();
    }
    inifile.close();

    // Make sure the window coordinates fit on the current screen:
    if (m_windowPosX > ScreenSize.width()-m_windowWidth) {
        m_windowPosX = ScreenSize.width()-m_windowWidth;
    }
    if (m_windowPosY > ScreenSize.height()-m_windowHeight-50) {
        m_windowPosY = ScreenSize.height()-m_windowHeight-50;
    }

    // Make sure checkbox settings are in the right format for QML:
    if (m_settingNegative >= 1)    m_settingNegative = 2;      // 0: Unchecked, 1: Partially Checked, 2: Checked
    if (m_settingUpperLimit >= 1)  m_settingUpperLimit = 2;    // 0: Unchecked, 1: Partially Checked, 2: Checked
    if (m_settingLowerLimit >= 1)  m_settingLowerLimit = 2;    // 0: Unchecked, 1: Partially Checked, 2: Checked
    if (m_settingWrap >= 1)        m_settingWrap = 2;          // 0: Unchecked, 1: Partially Checked, 2: Checked


//    qInfo("m_windowPosX = %d",m_windowPosX);
//    qInfo("m_windowPosY = %d",m_windowPosY);
//    qInfo("m_windowWidth = %d",m_windowWidth);
//    qInfo("m_windowHeight = %d",m_windowHeight);
//    qInfo("m_settingNegative = %d",m_settingNegative);
//    qInfo("m_settingUpperLimit = %d",m_settingUpperLimit);
//    qInfo("m_settingLowerLimit = %d",m_settingLowerLimit);
//    qInfo("m_settingWrap = %d",m_settingWrap);

    emit windowPosChanged();
    emit settingChanged();

    return true;
}


void CBackend::writeIniFile()
{
//  Write all necessary data to ini file in ASCII format
    QFile savefileini("QCounter.ini");

    qInfo("writeIniFile(): Writing ini file: QCounter.ini");

    if (!savefileini.open(QIODevice::WriteOnly)) {
        qWarning("Could not open ini file!");
       return;
    }
    QTextStream out(&savefileini);

    out << "[Geometry]" << endl;
    // Configuration settings
    out << "WindowPosX=" << (qint16) m_windowPosXSave << endl;     //qInfo("Saving - m_windowPosXSave = %d    m_windowPosYSave = %d",m_windowPosXSave,m_windowPosYSave);
    out << "WindowPosY=" << (qint16) m_windowPosYSave << endl;     //qInfo("Saving - m_windowPosYSave = %d",m_windowPosYSave);
    out << "WindowWidth=" << (quint16) m_windowWidthSave << endl;    //qInfo("m_windowWidthSave = %d",m_windowWidthSave);
    out << "WindowHeight=" << (quint16) m_windowHeightSave << endl;   //qInfo("m_windowHeightSave = %d",m_windowHeightSave);
    out << "[Settings]" << endl;
    out << "NegativeValues=" << (qint16) m_settingNegative << endl;
    out << "UpperLimit=" << (qint16) m_settingUpperLimit << endl;
    out << "UpperLimitValue=" << (qint32) m_UpperLimit << endl;
    out << "LowerLimit=" << (qint16) m_settingLowerLimit << endl;
    out << "LowerLimitValue=" << (qint32) m_LowerLimit << endl;   //qInfo("m_LowerLimit = %d",m_LowerLimit);
    out << "Wrap=" << (qint16) m_settingWrap << endl;

    savefileini.close();
}


