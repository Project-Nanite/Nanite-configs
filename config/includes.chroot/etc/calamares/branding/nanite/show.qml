import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Rectangle {
    id: root
    width: 800
    height: 600
    color: "transparent"

    // Background image
    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "/usr/share/backgrounds/wallpaper.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        cache: false
    }

    // Overlay for better text readability
    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "black"
        opacity: 0.3
    }

    // Main content
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        // Logo
        Image {
            id: logo
            source: "/usr/share/icons/Nanite-Icons/apps/128/distributor-logo.png"
            width: 128
            height: 128
            Layout.alignment: Qt.AlignHCenter
        }

        // Welcome text
        Text {
            id: welcomeText
            text: "Welcome to Nanite Linux"
            font.pixelSize: 32
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        // Subtitle
        Text {
            id: subtitleText
            text: "Installing your new system..."
            font.pixelSize: 18
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
    }

    // Progress indicator
    Rectangle {
        id: progressBar
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 40
        }
        height: 4
        color: "#4d7cf4"
        radius: 2

        // Animated progress
        Rectangle {
            id: progressFill
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width * 0.3
            color: "#ffffff"
            radius: 2

            SequentialAnimation on width {
                loops: Animation.Infinite
                NumberAnimation {
                    to: progressBar.width
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    to: progressBar.width * 0.3
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
