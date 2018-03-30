import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

Rectangle {
    id: mainMenu
    signal activated(string page)
    property alias currentIndex: mainMenuView.currentIndex

    onCurrentIndexChanged: {
        if (window.connected)
            activated(mainMenuModel.get(currentIndex).page)
    }

    color: window.palette.mid

    ListModel {
        id: mainMenuModel
        ListElement { label: "Note"; page: "note.qml" }
        ListElement { label: "Browser"; page: "browser.qml"; }
        ListElement { label: "Clipboard"; page: "clipboard.qml"; }
    }

    Component {
        id: mainMenuDelegate
        Item {
            id: mainMenuItem
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30

            Label {
                id:theLabel
                text: label
                anchors {
                    left: parent.left
                    leftMargin: 6
                    verticalCenter: parent.verticalCenter
                }

                opacity: window.connected ? 1 : 0.5

                color: mainMenuItem.ListView.isCurrentItem ? window.palette.highlightedText : window.palette.text

            }

            MouseArea {
                visible: window.connected
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    mainMenu.currentIndex = index
                    // mainMenu.activated(page)
                }
            }
        }
    }

    ListView {
        id: mainMenuView
        anchors.fill: parent

        model: mainMenuModel

        delegate: mainMenuDelegate
        highlight: Rectangle { color: window.palette.highlight; visible: window.connected }
        focus: window.connected

    }
}
