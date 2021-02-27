import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Shapes 1.11
import QtQuick.Dialogs 1.2

Window {
    id: mainWindow
    visible: true
    width: 200
    height: 150
    title: qsTr("Counter")


    property string darkGrey:              "#333333"
    property string midGrey:               "#5c5c5c"
    property string lightGrey:             "#dbdbdb"
    property string lightBlue:             "#8ca5c2"

    property string foreground: lightGrey
    property string background: darkGrey

    property int count: 0
    property int lowerLimit: 0
    property int upperLimit: 200

    color: background


    function increaseCounter() {
        count += 1;
        count = Math.min(count, upperLimit);
    }
    function decreaseCounter() {
        count -= 1;
        count = Math.max(count, lowerLimit);
    }

    Shortcut {
        sequence: "+"
        onActivated: increaseCounter()
    }

    Shortcut {
        sequence: "-"
        onActivated: decreaseCounter()
    }


    Shape {
        id: hex1
        x: mainWindow.width/2 - width/2
        y: mainWindow.height/2 - height/2
        width: 100
        height: 86
        antialiasing: true

        ShapePath {
            fillColor: mainWindow.midGrey // "transparent"
            strokeColor: "orange"
            fillRule: ShapePath.WindingFill
            strokeWidth: 2
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 25
            startY: 0
            PathLine { relativeX: 50  ; relativeY: 0}
            PathLine { relativeX: 25  ; relativeY: 43.3}
            PathLine { relativeX: -25  ; relativeY: 43.3}
            PathLine { relativeX: -50  ; relativeY: 0}
            PathLine { relativeX: -25 ; relativeY: -43.3}
            PathLine { relativeX: 25  ; relativeY: -43.3}
        }
    }

    Shape {
        x: mainWindow.width/2 + 30
        y: mainWindow.height/2 - hex1.height/2
        width: 50
        height: 50
        antialiasing: true

        MouseArea {
            anchors.fill: parent
            onClicked: increaseCounter()
        }


        ShapePath {
            fillColor: "transparent"
            strokeColor: "orange"
            fillRule: ShapePath.WindingFill
            strokeWidth: 2
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 0
            startY: 0
            PathLine { relativeX: 46  ; relativeY: 0}
            PathLine { relativeX: -23  ; relativeY: 1.732*23.0}
            PathLine { relativeX: -23  ; relativeY: -1.732*23.0}

        }
    }

    Shape {
        x: mainWindow.width/2 - 76
        y: mainWindow.height/2
        width: 50
        height: 50
        antialiasing: true

        MouseArea {
            anchors.fill: parent
            onClicked: decreaseCounter()
        }

        ShapePath {
            fillColor: "transparent"
            strokeColor: "orange"
            fillRule: ShapePath.WindingFill
            strokeWidth: 2
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: 0
            startY: 44
            PathLine { relativeX:  46  ; relativeY: 0}
            PathLine { relativeX: -23  ; relativeY: -1.732*23.0}
            PathLine { relativeX: -23  ; relativeY:  1.732*23.0}
        }
    }


    Rectangle {
        id: rectText
        x: mainWindow.width/2 - width/2
        y: mainWindow.height/2 - height/2
        width: 70
        height: 40

        color: "transparent" //mainWindow.foreground

        Text {
            id: text
            width: parent.width
            height: parent.height
            color: mainWindow.foreground
            text: count
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: count<100 ? 36 : 30
        }
    }


    RoundButton {
        id: options
        x: mainWindow.width/2 - hex1.width/2 - width/2 - 2
        y: mainWindow.height/2 - hex1.height/2
        radius: 15
        height: 30
        width: 30
        flat: true
        icon.source: "/icons/cogs-solid.png"
        icon.color: options.down ? midGrey : lightGrey

        background: Rectangle {
            height: parent.height
            width: parent.width
            radius: parent.radius
//            border.color: lightGrey
            color: "transparent"
        }

        //onClicked: optionsMenu.popup();

    }


    RoundButton {
        id: undo
        x: mainWindow.width/2 + 53 - width/2
        y: mainWindow.height/2 + hex1.height/2 - height
        radius: 15
        height: 30
        width: 30
        flat: true
        icon.source: "/icons/undo-alt-solid.png"
        icon.color: undo.down ? midGrey : lightGrey

        background: Rectangle {
            height: parent.height
            width: parent.width
            radius: parent.radius
//            border.color: lightGrey
            color: "transparent"
        }

        onClicked: count = 0

    }




}
