import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Rectangle {
    id: root
    width: 800
    height: 600
    
    // Use the bee wallpaper as background
    Image {
        id: background
        anchors.fill: parent
        source: "/usr/share/backgrounds/wallpaper.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }
    
    // Semi-transparent overlay for better text readability
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.3
    }
    
    // Welcome text
    Text {
        anchors.centerIn: parent
        text: "Welcome to Nanite Linux"
        font.pixelSize: 32
        color: "white"
        font.bold: true
    }
    
    // Subtitle
    Text {
        anchors.top: parent.verticalCenter
        anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Installing your new system..."
        font.pixelSize: 18
        color: "white"
        opacity: 0.8
    }
}
