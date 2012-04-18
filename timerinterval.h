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

#ifndef CPPTIMERINTERVAL_H
#define CPPTIMERINTERVAL_H
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeComponent>
#include <QDateTime>
#include <QTextDocumentWriter>
#include <QTextDocument>
#include <QTextCursor>


// This class is intended to calculate the difference in seconds between
// the previous timer run and the current timer run.

class CppTimerInterval : public QObject
{
     Q_OBJECT
     Q_PROPERTY(int intID READ intID WRITE setintID)
     Q_PROPERTY(QDateTime iStart READ iStart WRITE setIStart)
     Q_PROPERTY(QDateTime iEnd READ iEnd WRITE setIEnd)
     Q_PROPERTY(QDateTime prevEnd READ prevEnd WRITE setPrevEnd)
     Q_PROPERTY(QString strDuration READ strDuration)
     Q_PROPERTY(QString strInterval READ strInterval)
     Q_PROPERTY(QString dataLog READ dataLog)
     Q_PROPERTY(QString fileName READ fileName WRITE setFileName)

 public:
     // default constructor
     CppTimerInterval(QObject *parent = 0);

     // interval ID, how many times timer has run
     int intID() const;
     void setintID(const int &intID);

     // start of current timer run
     QDateTime iStart() const;
     void setIStart(const QDateTime &iStart);

     // end of current timer run
     QDateTime iEnd() const;
     void setIEnd(const QDateTime &iEnd);

     // end of previous timer run
     QDateTime prevEnd() const;
     void setPrevEnd(const QDateTime &prevEnd);

     // difference in seconds between start and end of current timer run
     QString strDuration() const;
     Q_INVOKABLE void calcDuration();

     // difference in seconds between start of current timer run and end of previous run
     QString strInterval() const;
     Q_INVOKABLE void calcInterval();

     // data log of all events
     QString dataLog() const;
     Q_INVOKABLE void updateDataLog();

     // file name for data log
     QString fileName() const;
     void setFileName(const QString &filename);

     // data log saved to file
     Q_INVOKABLE bool saveFile();

/*
public slots:
     void slotDuration() {
         findDuration();
     }
     void slotInterval() {
         findInterval();
     }
*/

     /*
 signals:
     void intIDChanged();
     void iStartChanged();
     void iEndChanged();
     void prevEndChanged();
     void calcDurationChanged();
     void calcIntervalChanged();
     void fileNameChanged();
     void saveFileChanged();
     void dataLogChanged();
     //void intervalHistoryChanged();
     */

 private:
     int p_intID;           // event ID
     QDateTime p_iStart;    // event start datetime
     QDateTime p_iEnd;      // event end datetime
     QDateTime p_prevEnd;   // end of previous event
     int p_calcDuration;    // calculated duration in seconds
     QString p_strDuration; // string of duration in minutes and seconds
     int p_calcInterval;    // calculated interval in seconds
     QString p_strInterval; // string of interval in minutes and seconds
     //QTextDocument * const p_document;
     QString p_csvheader;   // CSV header for data log file
     QString p_dataLog;     // data log of all timer events
     QString p_filename;    // filename to save to
     QTextDocument * const p_document;  // document for data log
     QTextCursor p_cursor;  // cursor for document

};

#endif // CPPTIMERINTERVAL_H
