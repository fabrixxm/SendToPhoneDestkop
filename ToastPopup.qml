import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Rectangle  {
    id: errorMessage
    property alias text: errorMessageLabel.text
    color: "#6d0000"
    opacity: 0
    anchors.horizontalCenterOffset: 0
    anchors.bottom: parent.bottom
    anchors.bottomMargin: -35
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width * 0.8
    height: 35


    Label {
        id: errorMessageLabel
        anchors.fill: parent
        text: "error"
        padding: 10
        color: '#FFFFFF'
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.state = ""
    }

    states: [
        State {
            name: "ERROR"

            PropertyChanges {
                target: errorMessage
                anchors.bottomMargin: 0
                opacity: 1
                color: "#6d0000"
            }
        }
    ]

    transitions: [
        Transition {
            to: "*"
            PropertyAnimation { target: errorMessage; properties: "anchors.bottomMargin, opacity"; duration: 100}
        }
    ]

    function showError(msg) {
        state = "ERROR"
        text = msg
    }
}
