hl.on("hyprland.start", function ()
    -- Autologin xong thì khóa ngay bằng lock screen của mình (đợi quickshell sẵn sàng, tối đa ~5s)
    hl.exec_cmd("for i in $(seq 50); do pidof qs quickshell >/dev/null && break; sleep 0.1; done; sleep 0.5; loginctl lock-session")

    -- Focus màn ngang (workspace 2) trước
    hl.exec_cmd("hyprctl dispatch workspace 2")

    -- Con trỏ chuột (ghi đè Bibata của file mặc định)
    hl.exec_cmd("sleep 1 && hyprctl setcursor GawrGura-2026 48")

    -- Wallpaper video riêng cho 2 màn
    hl.exec_cmd("$HOME/.config/hypr/custom/scripts/dual_wallpaper.sh")

    -- Bộ gõ tiếng Việt
    hl.exec_cmd("fcitx5 -d")

    -- App khởi động
    -- Chrome, Teams -> workspace 2 (màn ngang); VSCode -> workspace 1 (màn dọc, xem rules.lua)
    hl.exec_cmd("google-chrome-stable", { workspace = "2 silent" })
    hl.exec_cmd("/opt/teams-for-linux/teams-for-linux --ozone-platform=x11", { workspace = "2 silent" })
    hl.exec_cmd("code", { workspace = "1 silent" })
end)
