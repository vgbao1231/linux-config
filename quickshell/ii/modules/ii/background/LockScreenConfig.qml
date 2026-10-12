pragma Singleton
import QtQuick
import Quickshell

// ============================================================
//  Cài đặt màn khóa (tự thêm) — chỉ cần sửa file này.
//  Lưu file là quickshell tự load lại, không cần restart.
// ============================================================
Singleton {
    // Cài đặt riêng từng màn.
    //   match     : một đoạn chữ có trong tên (description) của màn, thường là số serial
    //   wallpaper : ảnh màn khóa; để "" thì dùng hình nền hiện tại
    //   blur      : mức blur, 0 = không blur (càng lớn càng mờ, ~30 là vừa)
    property var monitors: [
        {
            name: "Màn dọc (trái)",
            match: "MCLMQS142609",
            wallpaper: "/home/vgbao/Pictures/Wallpapers/saba.png",
            blur: 20,
        },
        {
            name: "Màn ngang (phải)",
            match: "MCLMQS142654",
            wallpaper: "/home/vgbao/Pictures/Wallpapers/gura-sleep.jpg",
            blur: 20,
        },
    ]

    // Màn không có trong danh sách trên:
    //   wallpaper "" = dùng hình nền hiện tại
    //   blur null    = dùng mức blur trong Settings (lock.blur.radius)
    property var fallback: ({
        wallpaper: "",
        blur: null,
    })

    // Độ tối phủ lên ảnh khi có blur (0 = không tối, 1 = đen hẳn)
    property real dim: 0.3

    // Thời gian hiệu ứng mờ dần khi khóa/mở khóa (ms)
    property int fadeDuration: 600

    // File công tắc chế độ 2 hình nền (nội dung "1" = đang dùng lệnh wall), tính từ $HOME
    property string dualWallpaperFlag: ".config/hypr/custom/dual_wallpaper.mode"

    // ------------------------------------------------------------
    // Phần dưới là code tra cứu, không cần sửa.
    // ------------------------------------------------------------
    function forMonitor(description) {
        const desc = description ?? "";
        for (const m of monitors) {
            if (m.match && desc.includes(m.match))
                return m;
        }
        return fallback;
    }
}
