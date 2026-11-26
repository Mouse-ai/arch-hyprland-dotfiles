pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    id: intro

    property real veilOpacity: 1
    property bool revealing: false

    function reveal(): void {
        if (revealing)
            return
        revealing = true
        desktopReady.stop()
        fade.start()
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: veil
            required property ShellScreen modelData
            screen: modelData
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "violet-login-transition"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            mask: Region {}

            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }

            Image {
                anchors.fill: parent
                asynchronous: true
                source: "file://" + Quickshell.env("HOME") + "/Pictures/Wallpapers/violet-desktop.png"
                fillMode: Image.PreserveAspectCrop
                opacity: intro.veilOpacity
            }
        }
    }

    Process {
        id: check
        command: ["/bin/bash", "-c", "set -o pipefail; hyprctl -j layers | jq -e 'length > 0 and all(.[]; [.levels[][]?.namespace] | index(\"caelestia-background\") != null and index(\"caelestia-drawers\") != null and index(\"ambxst-clock\") != null)' >/dev/null"]
        onExited: (exitCode) => {
            if (exitCode === 0)
                intro.reveal()
        }
    }

    Timer {
        id: desktopReady
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            if (!check.running)
                check.running = true
        }
    }

    Timer {
        interval: 1600
        running: true
        onTriggered: intro.reveal()
    }

    SequentialAnimation {
        id: fade
        NumberAnimation {
            target: intro
            property: "veilOpacity"
            to: 0
            duration: 280
            easing.type: Easing.InOutCubic
        }
        ScriptAction { script: Qt.quit() }
    }
}
