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

#include "timerinterval.h"
#include <QTextDocumentWriter>
#include <QTextDocument>
#include <QTextCursor>
#include <QFile>

//#include <QStringBuilder>


// INITIALIZE OBJECT, DOCUMENT POINTERS
CppTimerInterval::CppTimerInterval(QObject *parent) :
    QObject(parent),
    p_document(new QTextDocument()),
    p_cursor(p_document)  //, p_intervalStart(0)
{
    p_dataLog = QString("");
}


// return functions

int CppTimerInterval::intID() const
{
    return p_intID;
}

QDateTime CppTimerInterval::iStart() const
{
    return p_iStart;
}

QDateTime CppTimerInterval::iEnd() const
{
    return p_iEnd;
}

QDateTime CppTimerInterval::prevEnd() const
{
    return p_prevEnd;
}

QString CppTimerInterval::strDuration() const
{
    return p_strDuration;
}

QString CppTimerInterval::strInterval() const
{
    return p_strInterval;
}

QString CppTimerInterval::dataLog() const
{
    return p_dataLog;
}


QString CppTimerInterval::fileName() const
{
    return p_filename;
}


// Calculate functions

void CppTimerInterval::calcDuration()
{
    p_calcDuration = p_iStart.secsTo(p_iEnd);
    p_strDuration = QString("");

    // convert seconds to minutes
    if (p_calcDuration >= 60)
    {
        p_strDuration = QString::number(p_calcDuration/60) + "m" + QString::number(p_calcDuration%60) + "s";
    }
    else
    {
        p_strDuration = QString::number(p_calcDuration) + "s";
    }

}

void CppTimerInterval::calcInterval()
{
    p_calcInterval = p_prevEnd.secsTo(p_iStart);
    p_strInterval = QString("");

    // convert seconds to minutes
    if (p_calcInterval >= 60)
    {
        p_strInterval = QString::number(p_calcInterval/60) + "m" + QString::number(p_calcInterval%60) + "s";
    }
    else
    {
        p_strInterval = QString::number(p_calcInterval) + "s";
    }
}


// setting functions

void CppTimerInterval::setintID(const int &intID)
{
    //if (p_intID!= intID) {
        p_intID = intID;
        //emit intIDChanged();
    //}
}

void CppTimerInterval::setIStart(const QDateTime &iStart)
{
    //if (p_iStart != iStart) {
        p_iStart = iStart; // QDateTime::currentDateTime(); //iStart;
        //emit iStartChanged();
    //}
}

void CppTimerInterval::setIEnd(const QDateTime &iEnd)
{
    //if (p_iEnd != iEnd) {
        p_iEnd = iEnd; //QDateTime::currentDateTime(); // iEnd;
        //emit iEndChanged();
    //}
}

void CppTimerInterval::setPrevEnd(const QDateTime &prevEnd)
{
    //if (p_prevEnd != prevEnd) {
        p_prevEnd = prevEnd;
        //emit prevEndChanged();
    //}
}


// Save data log to file

void CppTimerInterval::updateDataLog()
{
    QString dataFormat = \
            QString::number(p_intID) + "," + \
            p_strDuration + "," + \
            QString::number(p_calcDuration) + "," + \
            p_strInterval + "," + \
            QString::number(p_calcInterval) + "," + \
            p_iStart.toString(Qt::ISODate) + "," + \
            p_iEnd.toString(Qt::ISODate) + "\n";
    p_dataLog.append(dataFormat);
}

void CppTimerInterval::setFileName(const QString &filename)
{
    p_filename = filename;
}

bool CppTimerInterval::saveFile()
{
    p_csvheader = "Event,Duration,DurationSec,Interval,IntervalSec,Start,End\n";

    p_document->undo(); // remove previous info on CSV header
    p_document->undo(); // remove previous info on data log
    p_cursor.insertText(p_csvheader); // insert CSV header
    p_cursor.insertText(p_dataLog); // insert data log

    QTextDocumentWriter writer;
    writer.setFormat("plaintext");
    writer.setFileName(p_filename);

    bool success = writer.write(p_document);

    return success;
}
