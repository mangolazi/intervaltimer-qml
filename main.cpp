/* Copyright © mangolazi 2012.

This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/


#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtDeclarative>
#include "timerinterval.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    // Expose CppTimerInterval type to QML
    qmlRegisterType<CppTimerInterval>("TimerInterval", 1,0, "TimerInterval");

    QmlApplicationViewer viewer;
    viewer.setMainQmlFile(QLatin1String("qml/IntervalTimer/main.qml"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    // Lock in portrait for now, will fix later!
    viewer.setWindowTitle("Interval Timer QML");
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    viewer.showExpanded();

    return app->exec();
}
