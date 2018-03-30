import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3
import "note.js" as Note

RowLayout {
    id: notePage

    Component.onCompleted: {
        window.toolAddButton.visible = true;
        window.toolAddButton.clicked.connect(Note.newNote);

        window.toolSaveButton.visible = true;
        window.toolSaveButton.clicked.connect(Note.saveNote);

        window.toolDeleteButton.visible = true;
        window.toolDeleteButton.clicked.connect(Note.deleteNote);

        window.toolSep1.visible = true;
        window.toolUpdateButton.visible = true;
        window.toolUpdateButton.clicked.connect(Note.updateNoteList);

        Note.updateNoteList();
    }


    ListModel {
        id: noteListModel
    }

    Component {
        id: noteListDelegate
        Item {
            id: noteListItem
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30

            Rectangle {
                id: theColor
                width: 25
                height: 25
                anchors {
                    left: parent.left
                    leftMargin: 6
                    verticalCenter: parent.verticalCenter
                }
                color: model.color
                Label {
                    text: model.id
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    opacity: 0.8
                }
            }

            Label {
                id: theLabel
                text: title.split("\n")[0]
                elide: Text.ElideRight
                anchors {
                    left: theColor.right
                    right: parent.right
                    leftMargin: 6
                    verticalCenter: parent.verticalCenter
                }
                color: noteListItem.ListView.isCurrentItem ? window.palette.highlightedText : window.palette.text
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    noteListView.currentIndex = index
                }
            }
        }
    }

    ListView {
        id: noteListView
        Layout.fillHeight: true
        state: "OPENED"
        clip: true

        model: noteListModel

        delegate: noteListDelegate
        highlight: Rectangle { color: window.palette.highlight }
        focus: true

        onCurrentIndexChanged: {
            if (currentIndex < 0 || currentIndex > model.count ) return;
            Note.getNoteText( model.get(currentIndex).id )
        }

        function toggle() {
            state = state == "OPENED" ? "CLOSED" : "OPENED";
        }

        states: [
            State {
                name: "OPENED"

                PropertyChanges {
                    target: noteListView
                    Layout.preferredWidth: 200
                }
            },

            State {
                name: "CLOSED"

                PropertyChanges {
                    target: noteListView
                    Layout.preferredWidth: 40
                }
            }
        ]

    }

    Rectangle {
        id: rectangle
        Layout.fillHeight: true
        Layout.preferredWidth: 6
        color: window.palette.window
        Label {
            text: "⋮"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onClicked: noteListView.toggle()
        }
    }

    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true


        Rectangle {

            Layout.fillHeight: true
            Layout.fillWidth: true
            color: window.palette.base

            Flickable {
                id: flick
                clip: true
                anchors.fill: parent
                contentWidth: noteText.width; contentHeight: noteText.height
                TextArea {
                    id: noteText

                    property int noteId: -1
                    property string noteColor: ""

                    width: flick.width
                    wrapMode: TextEdit.Wrap
                    selectByKeyboard: true
                    selectByMouse: true


                }
                ScrollBar.vertical: ScrollBar { id: vbar; active: hbar.active}
                ScrollBar.horizontal: ScrollBar { id: hbar; active: vbar.active}
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: 16
            Layout.preferredWidth: 16
            Layout.bottomMargin: 6
            Layout.rightMargin: 6
            color: noteText.noteColor
            MouseArea {
                anchors.fill: parent
                onClicked: colorDialog.select(parent.color)
            }

        }

    }

    ColorDialog {
        id: colorDialog
        title: "Please choose a color"

        onAccepted: {
            noteText.noteColor = color
        }
        onRejected: {
        }

        function select(clr) {
            color = clr
            visible = true
        }
    }
}
