pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    required property var widgetColors

    readonly property MprisPlayer player: Mpris.players.values.find(item => item.isPlaying && item.trackTitle.trim().length > 0) ?? null
    readonly property string track: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""

    visible: player !== null
    implicitHeight: details.implicitHeight

    Text {
        id: note

        x: 3
        y: Math.max(0, title.baselineOffset - baselineOffset)
        text: "♪"
        color: root.widgetColors.muted
        style: root.widgetColors.outline ? Text.Outline : Text.Normal
        styleColor: root.widgetColors.outline ?? "transparent"
        font.pixelSize: 19
    }

    Column {
        id: details

        x: 31
        width: Math.max(0, root.width - x)
        spacing: 2

        Text {
            width: parent.width
            textFormat: Text.PlainText
            id: title
            text: root.track
            color: root.widgetColors.time
            style: root.widgetColors.outline ? Text.Outline : Text.Normal
            styleColor: root.widgetColors.outline ?? "transparent"
            elide: Text.ElideRight
            font.family: "Cormorant Garamond"
            font.pixelSize: 25
            font.weight: Font.DemiBold
        }

        Text {
            width: parent.width
            textFormat: Text.PlainText
            text: root.artist
            visible: text.length > 0
            color: root.widgetColors.muted
            style: root.widgetColors.outline ? Text.Outline : Text.Normal
            styleColor: root.widgetColors.outline ?? "transparent"
            elide: Text.ElideRight
            font.family: "Cormorant Garamond"
            font.pixelSize: 19 + (root.widgetColors.smallTextBoost ?? 0)
            font.weight: root.widgetColors.smallTextWeight ?? Font.Normal
        }
    }
}
