

-- Bật lại blur cho cửa sổ (ghi đè rule tắt blur của bộ dots) (tự thêm)
hl.window_rule({ match = { class = ".*" }, no_blur = false })
-- Giữ tắt blur cho menu chuột phải của app X11, tránh lỗi hiển thị
hl.window_rule({ match = { class = "^()$", title = "^()$" }, no_blur = true })

-- VSCode luôn mở ở workspace 1 (màn dọc, trái)
hl.window_rule({ match = { class = "^(com\\.microsoft\\.VSCode|code|code-oss|Code)$" }, workspace = "1 silent" })
