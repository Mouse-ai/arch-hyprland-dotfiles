pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root

    required property date now
    required property var widgetColors

    readonly property color digitOutline: widgetColors.clockOutline ?? widgetColors.outline ?? "transparent"

    Item {
        id: design

        width: 240
        height: 150

        scale: Math.min(
            root.width / width,
            root.height / height
        )

        transformOrigin: Item.TopLeft

        Text {
            x: 3
            y: 0

            text: Qt.formatDateTime(root.now, "MMMM").toUpperCase()
            color: root.widgetColors.muted
            style: root.widgetColors.outline ? Text.Outline : Text.Normal
            styleColor: root.widgetColors.outline ?? "transparent"

            font.family: "Cormorant Garamond"
            font.pixelSize: 16 + (root.widgetColors.smallTextBoost ?? 0)
            font.weight: root.widgetColors.smallTextWeight ?? Font.Normal
            font.letterSpacing: 4
        }

        Row {
            x: 0
            y: 8
            spacing: 8

            Text {
                text: Qt.formatDateTime(root.now, "HH")
                color: root.widgetColors.time
                style: root.digitOutline.a > 0 ? Text.Outline : Text.Normal
                styleColor: root.digitOutline

                font.family: "Cormorant Garamond"
                font.pixelSize: 96
                font.features: { "lnum": 1, "tnum": 1 }
                font.weight: Font.Medium
            }

            Text {
                text: Qt.formatDateTime(root.now, "mm")
                color: root.widgetColors.accent
                style: root.digitOutline.a > 0 ? Text.Outline : Text.Normal
                styleColor: root.digitOutline

                font.family: "Cormorant Garamond"
                font.pixelSize: 96
                font.features: { "lnum": 1, "tnum": 1 }
                font.weight: Font.Medium
            }
        }

        Rectangle {
            x: 3
            y: 118
            width: 228
            height: 1
            color: root.widgetColors.line
        }

        Text {
            x: 3
            y: 127

            text: Qt.formatDateTime(root.now, "dd")
                + " / "
                + Qt.formatDateTime(root.now, "dddd").toUpperCase()

            color: root.widgetColors.date
            style: root.widgetColors.outline ? Text.Outline : Text.Normal
            styleColor: root.widgetColors.outline ?? "transparent"

            font.family: "Cormorant Garamond"
            font.pixelSize: 17 + (root.widgetColors.smallTextBoost ?? 0)
            font.weight: root.widgetColors.smallTextWeight ?? Font.Normal
            font.letterSpacing: 2
        }
    }
}
