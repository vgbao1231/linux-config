import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// Khung app hay dùng trên bar (giống taskbar Windows)
// - App ghim lấy từ Config.options.dock.pinnedApps, kèm các app đang mở
// - Click trái: mở app (chưa mở) / chuyển tới cửa sổ của app (đã mở)
// - Click giữa: mở thêm cửa sổ mới
// - Click phải: ghim / bỏ ghim
BarGroup {
    id: root
    property real iconSize: 20

    Repeater {
        model: ScriptModel {
            objectProp: "appId"
            values: TaskbarApps.apps
        }

        delegate: Item {
            id: appItem
            required property var modelData
            readonly property bool isSeparator: modelData.appId === "SEPARATOR"
            readonly property bool isRunning: modelData.toplevels.length > 0
            readonly property bool isActive: modelData.toplevels.some(t => t.activated)
            property int lastFocused: -1
            // Delegate được tái sử dụng khi đổi thứ tự app ghim (modelData đổi tại chỗ),
            // nên desktopEntry phải là binding theo modelData.appId, không gán một lần
            property int entriesRevision: 0
            readonly property var desktopEntry: {
                entriesRevision;
                return DesktopEntries.heuristicLookup(modelData.appId);
            }
            onModelDataChanged: lastFocused = -1

            Layout.fillHeight: true
            implicitWidth: isSeparator ? 1 : appButton.implicitWidth
            implicitHeight: appButton.implicitHeight

            Connections {
                target: DesktopEntries
                function onApplicationsChanged() {
                    appItem.entriesRevision++;
                }
            }

            // Vạch ngăn giữa app ghim và app đang mở
            Rectangle {
                visible: appItem.isSeparator
                anchors.centerIn: parent
                implicitWidth: 1
                implicitHeight: root.iconSize - 4
                color: Appearance.colors.colOutlineVariant
            }

            RippleButton {
                id: appButton
                visible: !appItem.isSeparator
                anchors.centerIn: parent
                implicitWidth: root.iconSize + 10
                implicitHeight: root.iconSize + 8
                buttonRadius: Appearance.rounding.small
                toggled: appItem.isActive
                colBackgroundToggled: Appearance.colors.colSecondaryContainer
                colBackgroundToggledHover: Appearance.colors.colSecondaryContainerHover
                colRippleToggled: Appearance.colors.colSecondaryContainerActive

                onClicked: {
                    const toplevels = appItem.modelData.toplevels;
                    if (toplevels.length === 0) {
                        appItem.desktopEntry?.execute();
                        return;
                    }
                    appItem.lastFocused = (appItem.lastFocused + 1) % toplevels.length;
                    toplevels[appItem.lastFocused].activate();
                }
                middleClickAction: () => appItem.desktopEntry?.execute()
                altAction: () => TaskbarApps.togglePin(appItem.modelData.appId)

                contentItem: Item {
                    IconImage {
                        anchors.centerIn: parent
                        implicitSize: root.iconSize
                        source: Quickshell.iconPath(AppSearch.guessIcon(appItem.modelData.appId), "image-missing")
                    }
                    // Chấm báo app đang mở
                    Rectangle {
                        visible: appItem.isRunning
                        anchors {
                            bottom: parent.bottom
                            horizontalCenter: parent.horizontalCenter
                        }
                        implicitWidth: appItem.isActive ? 10 : 4
                        implicitHeight: 3
                        radius: Appearance.rounding.full
                        color: appItem.isActive ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1Inactive
                    }
                }
            }
        }
    }
}
