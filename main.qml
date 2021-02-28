/*
Copyright (C) 2021 by Sebastian Kauertz.

This file is part of QCounter, a QML-based counter.

QCounter is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

QCounter is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
If not, see <https://www.gnu.org/licenses/>.

Icons by Fontawesome Free: https://fontawesome.com/license/free
*/

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Shapes 1.11

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 200
    height: 180
    x: Backend.windowPosX
    y: Backend.windowPosY
    title: "Counter"

    // Variables for old settings (for Cancel functionality):
    property int oldOptionNegative:   optionNegative.checkState
    property int oldOptionUpperLimit: optionUpperLimit.checkState
    property int oldOptionLowerLimit: optionLowerLimit.checkState
    property int oldOptionWrap:       optionWrap.checkState


    property string darkGrey:              "#333333"
    property string midGrey:               "#5c5c5c"
    property string lightGrey:             "#dbdbdb"
    property string lightBlue:             "#8ca5c2"

    property string fg: lightGrey
    property string bg: darkGrey

    property int count: 0
    property int lowerLimit: 0
    property int oldlowerLimit: 0
    property int upperLimit: 999999
    property int oldupperLimit: 999999

    property int intro: 1   // Display the intro text

    color: bg


    function increaseCounter() {
        count += 1;
        if (optionWrap.checkState === 0) {
            // No wrapping
            count = Math.min(count, upperLimit);
            count = Math.max(count, lowerLimit);
        }
        else {
            // Wrapping
            if (count > upperLimit) count = lowerLimit;
        }
        if (intro === 1) {intro = 0; anim.running = true;}
    }

    function decreaseCounter() {
        count -= 1;
        if (optionWrap.checkState === 0) {
            // No wrapping
            count = Math.max(count, lowerLimit);
            count = Math.min(count, upperLimit);
        }
        else {
            // Wrapping
            if (count < lowerLimit) count = upperLimit;
        }
        if (intro === 1) {intro = 0; anim.running = true;}
    }


    Component.onCompleted: {
        if (Backend.settingNegative === 2)   optionNegative.checkState = 2;
        else                                 optionNegative.checkState = 0;
        if (Backend.settingUpperLimit === 2) optionUpperLimit.checkState = 2;
        else                                 optionUpperLimit.checkState = 0;
        if (Backend.settingLowerLimit === 2) optionLowerLimit.checkState = 2;
        else                                 optionLowerLimit.checkState = 0;
        if (Backend.settingWrap === 2)       optionWrap.checkState = 2;
        else                                 optionWrap.checkState = 0;

        if (Backend.settingNegative === 2)   lowerLimit = -999999;
        else                                 lowerLimit = 0;
        if (Backend.settingUpperLimit === 2) upperLimit = Backend.UpperLimit;
        else                                 upperLimit = 999999;
        if (Backend.settingLowerLimit === 2) lowerLimit = Backend.LowerLimit;
        else                                 Backend.settingNegative ? lowerLimit = -999999 : lowerLimit = 0;

        oldupperLimit = upperLimit;
        oldlowerLimit = lowerLimit;
    }

    onClosing: {
        Backend.savePosition(mainWindow.x, mainWindow.y, mainWindow.width, mainWindow.height);
    }


    Shortcut {
        sequences: ["+", "PgUp"]
        onActivated: increaseCounter()
        enabled: true
    }

    Shortcut {
        sequences: ["-", "PgDown"]
        onActivated: decreaseCounter()
        enabled: true
    }


    StackView {
        id: stack
        x: 0
        y: 0
        width: parent.width
        height: parent.height
        initialItem: mainView

    }


    Item {
        id: mainView
        visible: stack.depth === 1
        height: stack.height
        width: stack.width

        StackView.onActivating: {
            //console.log("Main view activating");
        }

        Rectangle {
            //id: introText
            x: 0
            y: 10
            width: mainWindow.width
            height: 24
            color: bg

            Text {
                id: introText
                width: parent.width
                height: parent.height
                color: lightGrey
                text: "Press \"+\" or \"-\" to increase/decrease counter"
                font.bold: true
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12

                PropertyAnimation {
                    id: anim
                    target: introText
                    property: "color"
                    to: bg
//                    property: "y"
//                    to: -50
                    easing.type: Easing.InOutQuad
                    duration: 800
                }
           }


        }

        Shape {
            id: hex1
            x: mainWindow.width/2 - width/2
            y: mainWindow.height/2 - height/2
            width: 100
            height: 86
            antialiasing: true

            ShapePath {
                fillColor: mainWindow.midGrey
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
                id: maPlus
                anchors.fill: parent
                onClicked: increaseCounter()
            }


            ShapePath {
                fillColor: maPlus.pressed ? midGrey : "transparent"
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

            Text {
                id: textPlus
                width: 46
                height: 30
                color: mainWindow.fg
                text: "+"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 24
            }
        }

        Shape {
            x: mainWindow.width/2 - 76
            y: mainWindow.height/2
            width: 50
            height: 50
            antialiasing: true

            MouseArea {
                id: maMinus
                anchors.fill: parent
                onClicked: decreaseCounter()
            }

            ShapePath {
                fillColor: maMinus.pressed ? midGrey : "transparent"
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

            Text {
                id: textMinus
                width: 46
                height: 55
                color: mainWindow.fg
                text: "-"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 28
            }
        }


        Rectangle {
            id: rectText
            x: mainWindow.width/2 - width/2
            y: mainWindow.height/2 - height/2
            width: 70
            height: 40

            color: "transparent"

            Text {
                id: text
                width: parent.width
                height: parent.height
                color: mainWindow.fg
                text: count
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Math.abs(count)<100 ? 36 : (Math.abs(count) < 1000 ? 30 : (Math.abs(count) < 10000 ? 24 : 20))
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

            onClicked: {
                if (stack.depth === 1) {
                    if (!stack.busy) {
                        stack.push(optionsView);
                    }
                }
                else if (stack.depth === 2) {
                    if (!stack.busy) {
                        stack.pop();
                    }
                }
            }
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

    } // Item



/////////////////////////////////////////////////////////////////////
    Item {
        id: optionsView
        visible: stack.depth === 2
        height: stack.height
        width: stack.width

        StackView.onActivating: {
            //console.log("Options activating");
            optionNegative.checkState       = Backend.settingNegative;
            optionUpperLimit.checkState     = Backend.settingUpperLimit;
            optionLowerLimit.checkState     = Backend.settingLowerLimit;
            optionWrap.checkState           = Backend.settingWrap;
            lowerLimit                      = Backend.LowerLimit;
            upperLimit                      = Backend.UpperLimit;
            oldOptionNegative               = optionNegative.checkState;
            oldOptionUpperLimit             = optionUpperLimit.checkState;
            oldOptionLowerLimit             = optionLowerLimit.checkState;
            oldOptionWrap                   = optionWrap.checkState;
        }


        Rectangle {
            id: form
            property int leftEdge: 10
            property int topEdge: 10

            height: parent.height - 30
            width: parent.width
            color: bg
            border.color: bg


            // Allow negative values:
            CheckBox {
                id: optionNegative
                x: form.leftEdge
                y: form.topEdge
                width: 40
                height: 20
                checked: false
                text: "Allow negative values"

                indicator: Rectangle {
                  implicitWidth: 14
                  implicitHeight: 14
                  x: optionNegative.leftPadding
                  y: parent.height / 2 - height / 2
                  radius: 3
                  border.color: parent.focus ? "orange" : fg

                  Rectangle {
                      width: 8
                      height: 8
                      x: 3
                      y: 3
                      radius: 2
                      color: optionNegative.down ? "grey" : "black"
                      visible: optionNegative.checked
                  }
                }

                contentItem: Text {
                     text: optionNegative.text
                     font.family: "Roboto"
                     font.bold: true
                     color: fg
                     verticalAlignment: Text.AlignVCenter
                     leftPadding: optionNegative.indicator.width + optionNegative.spacing
                 }

                onToggled: {

                }
            }


            // Set upper limit:
            CheckBox {
                id: optionUpperLimit
                x: form.leftEdge
                y: optionNegative.y + optionNegative.height + 10
                width: 130
                height: 20
                checked: false
                text: "Set upper limit"

                indicator: Rectangle {
                  implicitWidth: 14
                  implicitHeight: 14
                  x: optionUpperLimit.leftPadding
                  y: parent.height / 2 - height / 2
                  radius: 3
                  border.color: parent.focus ? "orange" : fg

                  Rectangle {
                      width: 8
                      height: 8
                      x: 3
                      y: 3
                      radius: 2
                      color: optionUpperLimit.down ? "grey" : "black"
                      visible: optionUpperLimit.checked
                  }
                }

                contentItem: Text {
                     text: optionUpperLimit.text
                     font.family: "Roboto"
                     font.bold: true
                     color: fg
                     verticalAlignment: Text.AlignVCenter
                     leftPadding: optionUpperLimit.indicator.width + optionUpperLimit.spacing
                 }

                onToggled: {
                    // Save limit when unchecked
                    checked ? (upperLimitText.text = oldupperLimit) : (oldupperLimit = upperLimit)
                }
            }
            Rectangle {
                x: optionUpperLimit.width + 10
                y: optionUpperLimit.y
                width: 55
                height: 20
                color: midGrey
                border.color: fg
                border.width: 2
                visible: optionUpperLimit.checkState

                TextInput {
                    id: upperLimitText
                    width: parent.width
                    height: parent.height
                    //focus: false
                    clip: true
                    activeFocusOnTab: true
                    selectByMouse: true
                    maximumLength: 7
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    text: upperLimit
                    font.bold: true
                    color: fg

                    echoMode: TextInput.Normal

                    onAccepted: {

                    }
                }
            }


            // Set lower limit:
            CheckBox {
                id: optionLowerLimit
                x: form.leftEdge
                y: optionUpperLimit.y + optionUpperLimit.height + 10
                width: 130
                height: 20
                checked: false
                text: "Set lower limit"

                indicator: Rectangle {
                  implicitWidth: 14
                  implicitHeight: 14
                  x: optionLowerLimit.leftPadding
                  y: parent.height / 2 - height / 2
                  radius: 3
                  border.color: parent.focus ? "orange" : fg

                  Rectangle {
                      width: 8
                      height: 8
                      x: 3
                      y: 3
                      radius: 2
                      color: optionLowerLimit.down ? "grey" : "black"
                      visible: optionLowerLimit.checked
                  }
                }

                contentItem: Text {
                     text: optionLowerLimit.text
                     font.family: "Roboto"
                     font.bold: true
                     color: fg
                     verticalAlignment: Text.AlignVCenter
                     leftPadding: optionLowerLimit.indicator.width + optionLowerLimit.spacing
                 }

                onToggled: {
                    // Save limit when unchecked
                    checked ? (lowerLimitText.text = oldlowerLimit) : (oldlowerLimit = lowerLimit)
                }
            }
            Rectangle {
                x: optionLowerLimit.width + 10
                y: optionLowerLimit.y
                width: 55
                height: 20
                color: midGrey
                border.color: fg
                border.width: 2
                visible: optionLowerLimit.checkState

                TextInput {
                    id: lowerLimitText
                    width: parent.width
                    height: parent.height
                    //focus: false
                    clip: true
                    activeFocusOnTab: true
                    selectByMouse: true
                    maximumLength: 7
                    horizontalAlignment: TextInput.AlignHCenter
                    verticalAlignment: TextInput.AlignVCenter
                    text: lowerLimit
                    font.bold: true
                    color: fg

                    echoMode: TextInput.Normal

                    onAccepted: {

                    }
                }
            }


            // Wrap at limits:
            CheckBox {
                id: optionWrap
                x: form.leftEdge
                y: optionLowerLimit.y + optionLowerLimit.height + 10
                width: 40
                height: 20
                checked: false
                text: "Wrap at limits"

                indicator: Rectangle {
                  implicitWidth: 14
                  implicitHeight: 14
                  x: optionWrap.leftPadding
                  y: parent.height / 2 - height / 2
                  radius: 3
                  border.color: parent.focus ? "orange" : fg

                  Rectangle {
                      width: 8
                      height: 8
                      x: 3
                      y: 3
                      radius: 2
                      color: optionWrap.down ? "grey" : "black"
                      visible: optionWrap.checked
                  }
                }

                contentItem: Text {
                     text: optionWrap.text
                     font.family: "Roboto"
                     font.bold: true
                     color: fg
                     verticalAlignment: Text.AlignVCenter
                     leftPadding: optionWrap.indicator.width + optionWrap.spacing
                 }

                onToggled: {

                }
            }

        }


        // Button bar
        Rectangle {
            height: 30
            width: parent.width
            color: bg
            border.color: "transparent"
            anchors.top: form.bottom


            Button {
                height: 20
                width: 60
                x: 30
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    height: 20
                    width: 60
                    radius: 15
                    anchors.verticalCenter: parent.verticalCenter
                    border.color: parent.down ? bg : (parent.focus ? "orange" : fg)
                    border.width: 2
                    color: parent.down ? fg : bg
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: parent.down ? bg : fg
                    font.bold: true
                    font.pixelSize: 12
                    text: "Cancel"
                }

                onClicked: {
                    // Set back to old values:
                    optionNegative.checkState       = oldOptionNegative;
                    optionUpperLimit.checkState     = oldOptionUpperLimit;
                    optionLowerLimit.checkState     = oldOptionLowerLimit;
                    optionWrap.checkState           = oldOptionWrap;
                    upperLimitText.text         = upperLimit
                    lowerLimitText.text         = lowerLimit
                    // Save values to backend:
                    Backend.settingNegative     = optionNegative.checkState;       // 0: Unchecked, 1: Partially Checked, 2: Checked
                    Backend.settingUpperLimit   = optionUpperLimit.checkState;     // 0: Unchecked, 1: Partially Checked, 2: Checked
                    Backend.UpperLimit          = upperLimit;
                    Backend.settingLowerLimit   = optionLowerLimit.checkState;     // 0: Unchecked, 1: Partially Checked, 2: Checked
                    Backend.LowerLimit          = lowerLimit;
                    Backend.settingWrap         = optionWrap.checkState;           // 0: Unchecked, 1: Partially Checked, 2: Checked

                    if (stack.depth === 1) {
                        if (!stack.busy) {
                            stack.push(optionsView);
                        }
                    }
                    else if (stack.depth === 2) {
                        if (!stack.busy) {
                            stack.pop();
                        }
                    }
                }

            }

            Button {
                height: 20
                width: 60
                x: 110
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    height: 20
                    width: 60
                    radius: 15
                    anchors.verticalCenter: parent.verticalCenter
                    border.color: parent.down ? bg : (parent.focus ? "orange" : fg)
                    border.width: 2
                    color: parent.down ? fg : bg
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: parent.down ? bg : fg
                    font.bold: true
                    font.pixelSize: 12
                    text: "OK"
                }

                onClicked: {
                   // Apply new values:
                   if (optionUpperLimit.checkState === 2) {
                        // If option is checked, take the value if there is one
                        if (upperLimitText.length > 0) {
                            upperLimit = upperLimitText.text;
                        }
                        else {
                            optionUpperLimit.checkState = 0;
                            upperLimit = 999999;
                        }
                    }
                    else {
                        upperLimit = 999999;
                    }

                    if (optionLowerLimit.checkState === 2) {
                        // If option is checked, take the value if there is one
                        if (lowerLimitText.length > 0) {
                            lowerLimit = lowerLimitText.text;
                        }
                        // otherwise use the default value
                        else {
                            optionLowerLimit.checkState = 0;
                            if (optionNegative.checkState === 2) lowerLimit = -999999;
                            else                                 lowerLimit = 0;
                        }
                    }
                    else {
                        // If no lower limit: Set default value depending on whether negative values allowed or not:
                        if (optionNegative.checkState === 2) lowerLimit = -999999;
                        else                                 lowerLimit = 0;
                    }

                    // Save new values in backend:
                    Backend.settingNegative     = optionNegative.checkState;       // 0: Unchecked, 1: Partially Checked, 2: Checked
                    Backend.settingUpperLimit   = optionUpperLimit.checkState;     // 0: Unchecked, 1: Partially Checked, 2: Checked
                    Backend.UpperLimit          = upperLimit;
                    Backend.settingLowerLimit   = optionLowerLimit.checkState;     // 0: Unchecked, 1: Partially Checked, 2: Checked
                    Backend.LowerLimit          = lowerLimit;
                    Backend.settingWrap         = optionWrap.checkState;           // 0: Unchecked, 1: Partially Checked, 2: Checked

                    if (stack.depth === 1) {
                        if (!stack.busy) {
                            stack.push(optionsView);
                        }
                    }
                    else if (stack.depth === 2) {
                        if (!stack.busy) {
                            stack.pop();
                        }
                    }
                }

            }  // Button

        }

    } // Item

}
