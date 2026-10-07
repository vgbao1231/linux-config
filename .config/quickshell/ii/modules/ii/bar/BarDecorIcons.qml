import qs.modules.common
import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import QtMultimedia

// Icon trang trí trên bar: hiện mọi ảnh trong thư mục `folder`, xếp theo tên file
// (đặt tên 01-xxx.png, 02-xxx.gif... để chọn thứ tự). Ảnh .gif và video ngắn (mp4, webm...) tự chạy lặp lại, không tiếng.
Item {
    id: root
    property string folder: `${Directories.config}/illogical-impulse/bar-icons/left`
    property real iconHeight: Appearance.sizes.baseBarHeight - 8
    property real spacing: 4

    visible: folderModel.count > 0
    implicitWidth: row.implicitWidth
    implicitHeight: Appearance.sizes.baseBarHeight

    FolderListModel {
        id: folderModel
        folder: root.folder.startsWith("file://") ? root.folder : `file://${root.folder}`
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.svg", "*.gif", "*.mp4", "*.webm", "*.mkv", "*.mov"]
        showDirs: false
        caseSensitive: false
        sortField: FolderListModel.Name
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.spacing

        Repeater {
            model: folderModel
            delegate: Loader {
                id: imgLoader
                required property url fileUrl
                required property string fileSuffix
                anchors.verticalCenter: parent.verticalCenter
                readonly property string suffix: fileSuffix.toLowerCase()
                sourceComponent: suffix === "gif" ? gifComp
                    : ["mp4", "webm", "mkv", "mov"].includes(suffix) ? videoComp
                    : imageComp

                Component {
                    id: imageComp
                    Image {
                        source: imgLoader.fileUrl
                        height: root.iconHeight
                        width: implicitHeight > 0 ? height * implicitWidth / implicitHeight : height
                        // Ảnh to (ảnh chụp, wallpaper...) được thu nhỏ khi tải cho nhẹ
                        sourceSize.height: root.iconHeight * 2
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                        asynchronous: true
                    }
                }
                Component {
                    id: videoComp
                    Item {
                        readonly property size videoSize: player.metaData.value(MediaMetaData.Resolution) ?? Qt.size(0, 0)
                        height: root.iconHeight
                        width: videoSize.height > 0 ? height * videoSize.width / videoSize.height : height
                        MediaPlayer {
                            id: player
                            source: imgLoader.fileUrl
                            loops: MediaPlayer.Infinite
                            videoOutput: videoOutput
                            Component.onCompleted: play()
                        }
                        VideoOutput {
                            id: videoOutput
                            anchors.fill: parent
                            fillMode: VideoOutput.PreserveAspectFit
                        }
                    }
                }
                Component {
                    id: gifComp
                    AnimatedImage {
                        source: imgLoader.fileUrl
                        height: root.iconHeight
                        width: sourceSize.height > 0 ? height * sourceSize.width / sourceSize.height : height
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                }
            }
        }
    }
}
