import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

Dialog {
    id: settingsDialog
    title: "Settings"
    standardButtons: Dialog.Cancel|Dialog.Ok


    GridLayout {
        columns: 2
        anchors.left: parent.left
        anchors.right: parent.right

        Label { text: "Url"; Layout.fillWidth: true; horizontalAlignment: Qt.AlignRight }
        TextField {
            id: textIp
            placeholderText: "IP of your phone"
            text: window.settings.ip
            Layout.fillWidth: true
        }

        Label { text: "Port"; Layout.fillWidth: true; horizontalAlignment: Qt.AlignRight }
        TextField {
            id: textPort
            placeholderText: "Port to connect to"
            text: window.settings.port === "" ? "9090" : window.settings.port
            Layout.fillWidth: true
        }

        Label { text: "Code"; Layout.fillWidth: true; horizontalAlignment: Qt.AlignRight }
        TextField {
            id: textCode
            placeholderText: "App secret code"
            text: window.settings.code
            Layout.fillWidth: true
        }

    }


    onAccepted: {

        window.settings.set( textIp.text, textPort.text, textCode.text);

        window.startup()
    }
    onRejected: console.log("Cancel clicked")
}
