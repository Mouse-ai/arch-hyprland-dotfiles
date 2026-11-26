pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root

    required property date today
    required property var widgetColors

    readonly property int firstColumn: (new Date(today.getFullYear(), today.getMonth(), 1).getDay() + 6) % 7
    readonly property int monthLength: new Date(today.getFullYear(), today.getMonth() + 1, 0).getDate()
    readonly property var weekdays: ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"]

    implicitHeight: grid.implicitHeight

    Grid {
        id: grid

        width: parent.width
        columns: 7
        rowSpacing: 3

        Repeater {
            model: 49

            Text {
                required property int index
                readonly property bool header: index < 7
                readonly property int day: index - 6 - root.firstColumn
                readonly property bool highlighted: !header && day === root.today.getDate()

                width: grid.width / grid.columns
                height: 22
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: header ? root.weekdays[index] : day >= 1 && day <= root.monthLength ? String(day) : ""
                color: highlighted ? root.widgetColors.time : header ? root.widgetColors.muted : root.widgetColors.date
                style: root.widgetColors.outline ? Text.Outline : Text.Normal
                styleColor: root.widgetColors.outline ?? "transparent"

                font.family: "Cormorant Garamond"
                font.pixelSize: (header ? 13 : 19) + (root.widgetColors.smallTextBoost ?? 0)
                font.weight: highlighted ? Font.Bold : (root.widgetColors.smallTextWeight ?? Font.Medium)
                font.underline: highlighted
                font.features: { "lnum": 1, "tnum": 1 }
            }
        }
    }
}
