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

#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <QVariant>
#include <QSurfaceFormat>
#include "CBackend.h"

int main(int argc, char *argv[])
{
    CBackend* Backend;

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

//    QGuiApplication app(argc, argv);
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Ensure smooth Shapes:
    QSurfaceFormat format;
    format.setSamples(8);
    QSurfaceFormat::setDefaultFormat(format);

    // Instantiate the backend:
    Backend = new CBackend();

    // Register the backend with the root context to access its properties:
    engine.rootContext()->setContextProperty("Backend", Backend);


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    // After the QML is loaded, finish initialization of backend:
    Backend->setup(&app);

    return app.exec();
}
