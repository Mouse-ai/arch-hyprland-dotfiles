pragma ComponentBehavior: Bound
import QtQuick
import qs.services

Item {
    id: root

    required property var widgetColors

    readonly property bool ready: Number.isFinite(Weather.cc?.tempC)

    Item {
        width: 240
        height: 50
        scale: Math.min(root.width / width, root.height / height)
        transformOrigin: Item.TopLeft

        Text {
            id: temperature

            x: 3
            text: root.ready ? Weather.formatTemp(Weather.cc.tempC, true) : "—"
            color: root.widgetColors.weather
            style: root.widgetColors.outline ? Text.Outline : Text.Normal
            styleColor: root.widgetColors.outline ?? "transparent"
            font.family: "Cormorant Garamond"
            font.pixelSize: 38
            font.weight: Font.Medium
        }

        Text {
            anchors.left: temperature.right
            anchors.leftMargin: 18
            anchors.right: parent.right
            anchors.baseline: temperature.baseline
            text: root.ready ? Weather.description : "Нет данных о погоде"
            color: root.widgetColors.muted
            style: root.widgetColors.outline ? Text.Outline : Text.Normal
            styleColor: root.widgetColors.outline ?? "transparent"
            font.family: "Cormorant Garamond"
            font.pixelSize: 21 + (root.widgetColors.smallTextBoost ?? 0)
            font.weight: root.widgetColors.smallTextWeight ?? Font.Normal
            elide: Text.ElideRight
        }
    }
}
