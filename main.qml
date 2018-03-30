import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "app.js" as App

ApplicationWindow {

    /* app state */
    property bool connected: false
    property var settings: App.loadSettings()

    property string platform: ""
    property string api_version: ""
    property var api_list: []

    Component.onCompleted: startup()

    /* /app state */

    function startup() { App.startup() }

    /* app funcs */
    function fetch(api, data, method,postdata) {
        return App._fetch(api, data, method, postdata).catch(function(e){
            errorMessage.showError(e);
        });
    }

    /* /app funcs */

    /* */
    onConnectedChanged: {
        if (connected) pageLoader.source = "note.qml"
        else pageLoader.source = "disconnected.qml"
    }

    property alias toolAddButton: toolAddButton
    property alias toolSaveButton: toolSaveButton
    property alias toolDeleteButton: toolDeleteButton
    property alias toolSep1: toolSep1
    property alias toolUpdateButton: toolUpdateButton
    /* / */

    FontLoader { id: forkAwesome ; source: "qrc:/icons/forkawesome-webfont.ttf" }



    id: window
    visible: true
    minimumWidth: 600
    minimumHeight: 400

    title: "Send To Phone Desktop"

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            Image {
                source: window.connected ? "qrc:/icons/icon-16.png" : "qrc:/icons/icon-16-off.png"
                fillMode: Image.PreserveAspectFit
                Layout.minimumHeight: 30
            }

            Label {
                text: ""
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                id: toolAddButton
                font.family: forkAwesome.name
                text: "\uf067"
                visible: false
            }
            ToolButton {
                id: toolSaveButton
                text: "\uf0c7"
                font.family: forkAwesome.name
                enabled: false
                visible: false
            }
            ToolButton {
                id: toolDeleteButton
                text: "\uf1f8"
                font.family: forkAwesome.name
                visible: false
                enabled: false
            }
            ToolSeparator { id: toolSep1; visible: false}
            ToolButton {
                id: toolUpdateButton
                text: "\uf021"
                font.family: forkAwesome.name
                visible: false
                enabled: true
            }
        }
    }

    footer: ToolBar {
        id: bottomToolBar
        Layout.fillWidth: true
        RowLayout {
            anchors.right: parent.right
            anchors.left: parent.left
            ToolButton {
                flat: true
                text: "\uf013"
                font.family: forkAwesome.name
                /*icon {
                    name: "preferences-system"
                    //source: "qrc:/icons/gear-16.png"
                }*/
                onClicked: settingsDialog.open()
            }
            Item { Layout.fillWidth: true } // spacer

        }
        ToastPopup { id: errorMessage }
    }



    RowLayout {
        anchors.fill: parent
//        spacing: 6

        ColumnLayout {
            Layout.fillHeight: true
            Layout.minimumWidth: 100


            MainMenu {
                id: mainMenu
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width
                onActivated : pageLoader.source = page
            }

        }
        Loader {
            id: pageLoader
            source: "disconnected.qml"

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    SettingsDialog { id: settingsDialog }

}
