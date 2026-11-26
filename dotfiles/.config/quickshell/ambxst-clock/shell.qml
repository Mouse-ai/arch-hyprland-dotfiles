pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.utils

ShellRoot {
    id: desktopShell

    property string wallpaperName
    readonly property var styles: ({
        "violet-desktop.png": {
            time: "#38342F", accent: "#8D776B", muted: "#81766A",
            line: "#A69B89", date: "#5C5349", weather: "#51483E"
        },
        "evergarden-serenity.webp": {
            time: "#FFF8E5", accent: "#F6E4A7", muted: "#E6ECCD",
            line: "#475B3C", date: "#F5F2DC", weather: "#FFF2C1",
            outline: "#1E2D23"
        },
        "mai-lilac-morning.webp": {
            time: "#291733", accent: "#42284B", muted: "#37243F",
            line: "#684968", date: "#35203F", weather: "#291733",
            outline: "#E6CFE8"
        },
        "makima-midnight.webp": {
            time: "#F1E5EE", accent: "#F3A7B8", muted: "#D2ACBC",
            line: "#987080", date: "#E4C5D2", weather: "#FFE3E9"
        },
        "sparkle-moonstage.webp": {
            time: "#FFF0F8", accent: "#F6ABD7", muted: "#DDB5D0",
            line: "#A36F9D", date: "#F2D1E8", weather: "#FCE0F1"
        },
        "sparxie-planarcadia.webp": {
            time: "#F3E9FF", accent: "#E7B2FD", muted: "#C9B4E2",
            line: "#9A78BB", date: "#E2CEF6", weather: "#F5D6F8"
        }
    })
    readonly property var widgetColors: styles[wallpaperName] ?? styles["violet-desktop.png"]

    FileView {
        path: Paths.state + "/wallpaper/path.txt"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: desktopShell.wallpaperName = text().trim().split("/").pop()
        onLoadFailed: desktopShell.wallpaperName = ""
    }

    SystemClock {
        id: desktopTime
        precision: SystemClock.Minutes
    }

    Component.onCompleted: Weather.reload()

    IpcHandler {
        target: "desktopWeather"

        function style(): string {
            return JSON.stringify({
                wallpaper: desktopShell.wallpaperName,
                colors: desktopShell.widgetColors
            })
        }

        function status(): string {
            return JSON.stringify({
                location: Weather.loc,
                temperature: Weather.cc?.tempC ?? null,
                description: Weather.cc ? Weather.description : null
            })
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: desktop

            required property ShellScreen modelData
            screen: modelData

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "ambxst-clock"
            WlrLayershell.layer: WlrLayer.Bottom
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            mask: Region {}

            Item {
                id: widgetStack

                width: 248
                height: 522
                scale: Math.max(0.05, Math.min(1, (desktop.width - 16) / width, (desktop.height - 16) / height))
                x: Math.max(8, desktop.width - width * scale - 118)
                y: Math.max(8, Math.min(372, desktop.height - height * scale - 8))
                transformOrigin: Item.TopLeft

                ClockWidget {
                    now: desktopTime.date
                    widgetColors: desktopShell.widgetColors
                    width: parent.width
                    height: 158
                }

                WeatherWidget {
                    widgetColors: desktopShell.widgetColors
                    y: 192
                    width: parent.width
                    height: 54
                }

                CalendarWidget {
                    today: desktopTime.date
                    widgetColors: desktopShell.widgetColors
                    x: 3
                    y: 274
                    width: 235
                    height: implicitHeight
                }

                NowPlayingWidget {
                    widgetColors: desktopShell.widgetColors
                    y: 462
                    width: parent.width
                    height: implicitHeight
                }
            }
        }
    }
}
