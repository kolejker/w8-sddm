import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1920
    height: 1080

    readonly property color textColor: "white"
    readonly property int avatarSize: 200
    property bool showPasswordScreen: userModel.count === 1
    property bool showUserList: userModel.count > 1
    property int selectedUserIndex: userModel.count === 1 ? 0 : -1
    property bool isPowerDropdownVisible: false
    property bool isAccessibilityDropdownVisible: false
    property bool isDeviceLocked: false


    Rectangle {
        id: loginContainer
        width: parent.width
        height: parent.height
        color: "#180053"

        Item {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -100
            width: parent.width
            height: Math.max(userGrid.height, loginForm.height)

            Grid {
                id: userGrid
                anchors.centerIn: parent
                columns: 4
                spacing: 40
                visible: !showPasswordScreen && showUserList

                Repeater {
                    model: userModel.count

                    Rectangle {
                        width: avatarSize
                        height: avatarSize + 40
                        color: "transparent"

                        Column {
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                width: avatarSize
                                height: avatarSize
                                color: "#444444"

                                Image {
                                    anchors.fill: parent
                                    source: userModel.data(userModel.index(index, 0), Qt.UserRole + 4)
                                    fillMode: Image.PreserveAspectFit
                                }
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: userModel.data(userModel.index(index, 0), Qt.UserRole + 1)
                                color: textColor
                                font.pointSize: 12
                                font.family: "Segoe UI"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                selectedUserIndex = index
                                showPasswordScreen = true
                            }
                        }
                    }
                }
            }

            Row {
                id: loginForm
                anchors.centerIn: parent
                spacing: 20
                visible: showPasswordScreen
                opacity: 0

                Item {
                    width: 264
                    height: 200

                    Rectangle {
                        id: backButton
                        width: 42
                        height: 42
                        color: "transparent"
                        border.color: "white"
                        border.width: 2
                        radius: 100
                        opacity: 0
                        x: 50
                        visible: userModel.count > 1

                        Text {
                            text: "🡸"
                            anchors.centerIn: parent
                            width: 25
                            height: 50
                            font.family: "Segoe UI Symbol 8"
                            font.pointSize: 24
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                showPasswordScreen = false
                                passwordField.text = ""
                            }
                        }

                        NumberAnimation on x {
                        to: 0
                        duration: 300
                        running: showPasswordScreen && userModel.count > 1
                    }
                    NumberAnimation on opacity {
                    to: 1
                    duration: 300
                    running: showPasswordScreen && userModel.count > 1
                }
            }

            Rectangle {
                id: avatarContainer
                width: 200
                height: 200
                color: "#444444"
                anchors {
                    right: parent.right
                    top: parent.top
                }

                Image {
                    anchors.fill: parent
                    source: userModel.data(userModel.index(selectedUserIndex, 0), Qt.UserRole + 4)
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Column {
            anchors.top: parent.top
            width: 400
            spacing: 5

            Text {
                text: userModel.data(userModel.index(selectedUserIndex, 0), Qt.UserRole + 1)
                color: textColor
                font.family: "Segoe UI Light"
                font.pointSize: 22
            }

            Text {
                text: isDeviceLocked ? "Locked" : ""
                color: textColor
                font.pointSize: 12
                font.family: "Segoe UI"
                opacity: 0.5
            }

            Item {
                width: 1
                height: 20
            }

            Rectangle {
                width: 305
                height: 32
                color: "white"

                TextField {
                    id: passwordField
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    font.family: "Segoe UI"
                    placeholderText: "Password"
                    echoMode: TextInput.Password
                    color: "black"
                    font.pointSize: 12

                    background: Rectangle {
                        color: "transparent"
                    }

                    Keys.onReturnPressed: {
                        sddm.login(userModel.data(userModel.index(selectedUserIndex, 0), Qt.UserRole + 1),
                        passwordField.text,
                        sessionModel.lastIndex)
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    width: parent.height
                    height: parent.height
                    color: enterButtonMouseArea.pressed ? "#6839d7" : enterButtonMouseArea.containsMouse ? "#532ac6" : "#4617b5"
                    border.color: "white"
                    border.width: 2

                    Behavior on color {
                    ColorAnimation { duration: 10 }
                }

                Text {
                    anchors.centerIn: parent
                    text: "🡺"
                    font.family: "Segoe UI Symbol 8"
                    font.pointSize: 16
                    color: "white"
                }

                MouseArea {
                    id: enterButtonMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        sddm.login(userModel.data(userModel.index(selectedUserIndex, 0), Qt.UserRole + 1),
                        passwordField.text,
                        sessionModel.lastIndex)
                    }
                }
            }
        }
    }
}
}
}

Rectangle {
    id: accessibilityButton
    width: 40
    height: 40
    color: accessibilityMouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : "transparent"
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.margins: 60

    transformOrigin: Item.Center

    scale: accessibilityMouseArea.pressed ? 0.9 : 1.0

    Behavior on scale {
    NumberAnimation {
        duration: 50
        easing.type: Easing.InOutQuad
    }
}

Image {
    id: accessibilityImage
    anchors.centerIn: parent
    width: 32
    height: 32
    source: "accessibility.png"
    opacity: 1
}

MouseArea {
    id: accessibilityMouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
        isAccessibilityDropdownVisible = !isAccessibilityDropdownVisible;
        isPowerDropdownVisible = false;
    }
}
}

MouseArea {
    id: accessibilityOutsideMouseArea
    anchors.fill: parent
    visible: isAccessibilityDropdownVisible
    z: -1
    onClicked: {
        isAccessibilityDropdownVisible = false;
    }
}

Rectangle {
    id: accessibilityDropdown
    width: 200
    height: 170
    color: "white"
    border.width: 2
    border.color: "black"
    anchors {
        left: parent.left
        leftMargin: 60
    }
    y: parent.height - height - 60
    opacity: 0

    Behavior on y {
    NumberAnimation {
        duration: 150
        easing.type: Easing.InOutQuad
    }
}
Behavior on opacity {
NumberAnimation {
    duration: 150
    easing.type: Easing.InOutQuad
}
}

visible: isAccessibilityDropdownVisible

states: [
    State {
        name: "visible"
        when: isAccessibilityDropdownVisible
        PropertyChanges {
            target: accessibilityDropdown
            opacity: 1
            y: parent.height - height - 110
        }
    },
    State {
        name: "hidden"
        when: !isAccessibilityDropdownVisible
        PropertyChanges {
            target: accessibilityDropdown
            opacity: 0
            y: parent.height - height - 90
        }
    }
]

Column {
    anchors.centerIn: parent
    Repeater {
        model: [
        { label: "On-Screen Keyboard", action: "osk" },
        { label: "Magnifier", action: "magnifier" },
        { label: "Session: (session name)", action: "SessionSwitch" }
        ]
        Rectangle {
            width: accessibilityDropdown.width - 4
            height: 50
            color: mouseArea.containsMouse ? "lightgray" : "white"

            Text {
                text: modelData.label
                font.family: "Segoe UI"
                font.pointSize: 12
                color: "black"

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 15
                anchors.topMargin: 15
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    console.log("Selected: " + modelData.label);
                    isAccessibilityDropdownVisible = false;

                }
            }
        }
    }
}
}
Rectangle {
    id: powerButton
    width: 40
    height: 40
    color: powerMouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : "transparent"
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 60

    transformOrigin: Item.Center
    scale: powerMouseArea.pressed ? 0.9 : 1.0

    Behavior on scale {
    NumberAnimation {
        duration: 50
        easing.type: Easing.InOutQuad
    }
}

Image {
    id: powerImage
    anchors.centerIn: parent
    width: 32
    height: 32
    source: "off.png"
    opacity: 1
}

MouseArea {
    id: powerMouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
        isPowerDropdownVisible = !isPowerDropdownVisible;
        isAccessibilityDropdownVisible = false;
    }
}

}

MouseArea {
    id: outsideMouseArea
    anchors.fill: parent
    visible: isPowerDropdownVisible
    z: -1
    onClicked: {
        isPowerDropdownVisible = false;
    }
}

Rectangle {
    id: powerDropdown
    width: 120
    height: 170
    color: "white"
    border.width: 2
    border.color: "black"
    anchors {
        right: parent.right
        rightMargin: 60
    }
    y: parent.height - height - 60
    opacity: 0
    Behavior on y {
    NumberAnimation {
        duration: 150
        easing.type: Easing.InOutQuad
    }
}
Behavior on opacity {
NumberAnimation {
    duration: 150
    easing.type: Easing.InOutQuad
}
}
visible: isPowerDropdownVisible
states: [
    State {
        name: "visible"
        when: isPowerDropdownVisible
        PropertyChanges {
            target: powerDropdown
            opacity: 1
            y: parent.height - height - 110
        }
    },
    State {
        name: "hidden"
        when: !isPowerDropdownVisible
        PropertyChanges {
            target: powerDropdown
            opacity: 0
            y: parent.height - height - 90
        }
    }
]

Column {
    anchors.centerIn: parent
    Repeater {
        model: [
        { label: "Sleep", action: "suspend" },
        { label: "Restart", action: "reboot" },
        { label: "Shutdown", action: "poweroff" }
        ]
        Rectangle {
            width: powerDropdown.width - 4
            height: 50

            color: mouseArea.containsMouse ? "lightgray" : "white"

            Text {
                text: modelData.label
                font.family: "Segoe UI"
                font.pointSize: 12
                color: "black"

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 15
                anchors.topMargin: 15
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    sddm[modelData.action]()
                    isPowerDropdownVisible = false;
                }
            }
        }
    }
}
}


Rectangle {

    id: lockScreen
    width: parent.width
    height: parent.height
    y: 0
    property bool isDragging: false
        property real lastY: 0
            property real dragThreshold: height * 0.2

                Image {
                    anchors.fill: parent
                    source: "background.png"
                    fillMode: Image.PreserveAspectCrop
                }

                Column {
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        leftMargin: 74
                        bottomMargin: 105
                    }
                    spacing: -10

                    Text {
                        id: timeText
                        font.family: "Segoe UI"
                        text: Qt.formatDateTime(new Date(), "h:mm")
                        color: textColor
                        font.pointSize: 108
                        font.weight: Font.Light
                        bottomPadding: -5
                    }

                    Text {

                        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                        color: textColor
                        font.pointSize: 42
                        font.family: "Segoe UI"
                        font.weight: Font.Light
                        topPadding: -12
                        leftPadding: 10
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        lockScreen.isDragging = true
                        lockScreen.lastY = mouseY
                    }
                    onPositionChanged: {
                        if (lockScreen.isDragging)
                        {
                            var delta = mouseY - lockScreen.lastY
                            var newY = lockScreen.y + delta
                            newY = Math.min(0, Math.max(-lockScreen.height, newY))
                            lockScreen.y = newY
                            lockScreen.lastY = mouseY
                        }
                    }
                    onReleased: {
                        if (lockScreen.isDragging)
                        {
                            lockScreen.isDragging = false
                            if (-lockScreen.y > lockScreen.dragThreshold)
                            {
                                completeAnimation.start()
                            } else {
                            resetAnimation.start()
                        }
                    }
                }
            }

            PropertyAnimation {
                id: completeAnimation
                target: lockScreen
                property: "y"
                to: -lockScreen.height
                duration: 200
                easing.type: Easing.OutQuad
            }

            PropertyAnimation {
                id: resetAnimation
                target: lockScreen
                property: "y"
                to: 0
                duration: 200
                easing.type: Easing.OutQuad
            }

            states: [
                State {
                    name: "showLogin"
                    when: showPasswordScreen
                    PropertyChanges {
                        target: loginForm
                        opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    to: "showLogin"
                    SequentialAnimation {
                        PauseAnimation { duration: 300 }
                        NumberAnimation {
                            property: "opacity"
                            duration: 300
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            ]

            Component.onCompleted: {
                root.forceActiveFocus()
            }
        }
    }