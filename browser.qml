import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "browser.js" as Browser
ColumnLayout {
    id: browserPage

    Component.onCompleted: {
        window.toolAddButton.visible = false;
        window.toolSaveButton.visible = false;
        window.toolDeleteButton.visible = false;
        window.toolSep1.visible = false;
        window.toolUpdateButton.visible = false;
    }

    RowLayout {
        Layout.fillWidth: true
        TextField {
            id: urlText
            Layout.fillWidth: true
        }
        ToolButton {
            text: ">"
            onClicked: Browser.open(urlText.text)
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: 'navy'
    }
}
