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


import QtQuick 1.1
import com.nokia.symbian 1.1
import TimerInterval 1.0

// Main application page

Page {
    id: mainPage

    property int timercount : 0
    property int intsecs : 0
    property int intmins : 0
    property string strsecs : "00"
    property string strmins : "0"
    property string strdata : ""
    property string strsep : ","
    property string timercolor : "#bbbbbb"
    property date firstdate
    tools: mainToolbar


    // Custom TimerInterval object, uses CPPTimerInterval class
    // Holds all needed values, calculations and methods
    TimerInterval {
        id: tiObj
        intID: 0
    }


    // Default toolbar
    ToolBarLayout {
        id: mainToolbar
        ToolButton {
            id: toolbarbtnBack
            flat: true
            iconSource: "toolbar-back"
            anchors.left: parent.left
            onClicked:
            {
                mainMenu.close()
                window.pageStack.depth <= 1 ? quitDialog.open() : window.pageStack.pop()
                //window.pageStack.depth <= 1 ? Qt.quit() : window.pageStack.pop()
            }
        }
        ToolButton {
            id: toolbarbtnMenu
            flat: true
            iconSource: "toolbar-view-menu"
            anchors.right: parent.right
            onClicked: (mainMenu.status == DialogStatus.Closed)
                                        ? mainMenu.open()
                                        : mainMenu.close()
        }
    }


    // Main menu
    Menu {
        id: mainMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: "Save..."; onClicked: savequeryDialog.open() }
            MenuItem { text: "About"; onClicked: { aboutDialog.open() } }
        }
    }


    // Quit dialog
    QueryDialog {
        id: quitDialog
        titleText: "Quit"
        message: "Are you sure you want to quit?\n"
        acceptButtonText: "OK"
        rejectButtonText: "Cancel"
        onAccepted:
        {
            quitDialog.close()
            Qt.quit()
        }
        onRejected:
        {
            quitDialog.close()
        }
    }

    // Save data dialog
    QueryDialog {
        id: savequeryDialog
        titleText: "Save Data to File"
        message: "Timer data will be saved to C:/Data in CSV format with .txt extension.\n"
        acceptButtonText: "OK"
        rejectButtonText: "Cancel"
        onAccepted:
        {
            tiObj.fileName = qsTr("C:/Data/timer-" + Qt.formatDateTime(firstdate, "yyyy-MM-dd-hhmm") + ".txt")
            if (tiObj.saveFile() == true)
            {
                saveDialog.titleText = "File save successful"
                saveDialog.message = "Saved to " + tiObj.fileName + "\n"  //qsTr("Saved to " + tiObj.fileName)
            }
            else
            {
                saveDialog.titleText = "Unsuccessful file save"
                saveDialog.message = "Cannot save file\n"
            }
            saveDialog.open()
            //console.log ("Trying to save..." + tiObj.saveFile)
        }
        onRejected: savequeryDialog.close()

    }


    // Save result dialog, sucessful or failed
    QueryDialog {
        id: saveDialog
        titleText: ""
        message: ""
        acceptButtonText: "OK"
        onAccepted: {
            saveDialog.close()
            savequeryDialog.close()
        }
    }

    // About dialog, NEW
    QueryDialog {
        id: aboutDialog
        titleText: "Interval Timer QML"
        message: "This application measures the duration of an event and the interval between events.\n\nPress Start to begin timing, Stop to stop timing.\n\nThe first number is the duration of the event. The second number is the interval between the current event and the previous event.\n\nSaved file are in CSV format with .txt extension.\n"
        acceptButtonText: "OK"
        }


    // Timer display
    Text {
        id: txtTimerDisplay
        anchors.top: parent.top
        anchors.topMargin: 2
        //anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: undefined
        width: parent.width
        lineHeight: 1
        color: timercolor
        text: strmins + " : " + strsecs
        style: Text.Normal
        font.bold: false
        styleColor: "#000000"
        wrapMode: Text.NoWrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 34

        states: [
            State {
                name: "LANDSCAPE"
                PropertyChanges {
                    target: txtTimerDisplay
                    font.pointSize: 32
                    width: 320
                }
                AnchorChanges {
                    target: txtTimerDisplay
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.horizontalCenter: undefined
                }
            }
        ]
    }


    // Start/top button
    Button {
        property string buttontext : "Start"
        id: btnStart               
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: undefined
        anchors.topMargin: 0
        anchors.bottomMargin: 10
        width: 140
        height: 60

        text: buttontext

        states: [
            State {
                name: "LANDSCAPE"                
                PropertyChanges {
                    target: btnStart
                    anchors.topMargin: 100
                }
                AnchorChanges {
                    target: btnStart
                    anchors.top: txtTimerDisplay.bottom
                    anchors.bottom: undefined
                    anchors.horizontalCenter: txtTimerDisplay.horizontalCenter
                }
            }
        ]

        // On clicked, all the processing happens...
        // This should be cleaned up and moved out somewhere else!
        onClicked: {
            if (timerObj.running == true) {
                // stop timer, count duration and interval
                timerObj.stop()
                tiObj.iEnd = new Date()

                // reset timer
                timercount = 0
                timercolor = "#bbbbbb"
                intsecs = 0
                intmins = 0
                buttontext = "Start"

                // get required info
                tiObj.calcDuration()
                tiObj.calcInterval()
                tiObj.updateDataLog()                
                console.debug(tiObj.dataLog)

                // display information in list
                listModel.append({"times": tiObj.intID + ". " +
                                           Qt.formatDateTime(tiObj.iStart, "hh:mm:ss") + " to " +
                                           Qt.formatDateTime(tiObj.iEnd, "hh:mm:ss"),
                                     "durationinterval": "Duration: "  + tiObj.strDuration + "    " +
                                                         "Interval: " + tiObj.strInterval
                                 })
                //listView.currentIndex = listView.count
                listView.currentIndex = listView.currentIndex + 1

            }
            else {
                // start timer, reset previous
                timerObj.start()
                tiObj.iStart = new Date()
                tiObj.intID++
                strmins = "0"
                strsecs = "00"
                timercolor = "#9ffedd"
                buttontext = "Stop"

                // set end of previous run
                if (tiObj.intID > 1) {
                    tiObj.prevEnd = tiObj.iEnd;
                }
                else { // first run
                    tiObj.prevEnd = tiObj.iStart;
                    firstdate = tiObj.iStart
                    console.debug("First date set to " + tiObj.iStart)
                }

            }
        }
    }

    // Function for updating seconds display
    function updateSecs() {
        if (intsecs < 10) {
            strsecs = "0" + intsecs }
        else {
            strsecs = intsecs }
    }

    // Function for updating minutes display
    function updateMins() {
        if (timercount >= 60) {
            if (timercount % 60 == 0) {
                intmins++
                strmins = intmins
            }
        }
        intsecs = timercount % 60
        console.log(timercount + "  Min" + intmins + " Sec" + intsecs)
    }

    // Timer object, does all the counting
    Timer {
        id: timerObj
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            timercount++
            updateMins()
            updateSecs()
        }
    }


    // Listview and listmodels, showing all timer data
    ListView {
        id: listView
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top : txtTimerDisplay.bottom
        anchors.topMargin: 2
        anchors.bottom: btnStart.top // WATCH OUT THIS IS FUCKED! *********
        anchors.bottomMargin: 10
        anchors.left: undefined
        //x: 3
        //y: 200
        width: parent.width - 40
        height: (parent.height / 1.5)
        focus: true
        clip: true
        model: listModel
        delegate: listDelegate
        highlightFollowsCurrentItem: true

        states: [
            State {
                name: "LANDSCAPE"
                PropertyChanges {
                    target: listView
                    height: parent.height - 200
                    width: parent - 360
                }
                AnchorChanges {
                    target: listView
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: undefined
                    anchors.left: parent.horizontalCenter
                }
            }
        ]

    }

    Component {
        id: listDelegate

        ListItem {
            id: listItem

            Column {
                anchors.fill: listItem.paddingItem

                ListItemText {
                    mode: listItem.mode
                    role: "Title"
                    text: durationinterval // Title text from model, duration and interval
                    width: parent.width
                }

                ListItemText {
                    mode: listItem.mode
                    role: "SubTitle"
                    text: times // SubTitle text from model, start and end times
                    width: parent.width
                }
            }
        }
    }

    ListModel {
        id: listModel
        ListElement {
            times: "Starting time to ending time"
            durationinterval: "Duration and interval"
        }
    }


    // State machine to handle portrait/landscape orientation  
    state: {
        if (screen.currentOrientation == Screen.Landscape) {
            // landscape
            console.log("landscape")
            //mainPage.state = "switchL"
            txtTimerDisplay.state = "LANDSCAPE"
            listView.state = "LANDSCAPE"
            btnStart.state = "LANDSCAPE"
        } else {
            // portrait
            console.log("portrait default")
            txtTimerDisplay.state = ""
            listView.state = ""
            btnStart.state = ""
            //mainPage.state = "switchP"
        }
    }


}
