hl.config({
    decoration = {
        active_opacity = 0.95,    -- cửa sổ đang focus: đục hoàn toàn
        inactive_opacity = 0.85,   -- cửa sổ không focus: 90%
        blur = {
            enabled = true,
            size = 4,      -- độ rộng vùng mờ, lớn hơn thì mờ hơn
            passes = 2     -- số lần làm mờ, nhiều hơn thì mịn hơn nhưng tốn GPU hơn
        }
    }
})


-- -- Hiệu ứng workspace: fade thay cho trượt ngang (tự thêm)
-- hl.animation({
--     leaf = "workspaces",
--     enabled = true,
--     speed = 7,
--     bezier = "menu_decel",
--     style = "slidevert"
-- })

-- -- Hiệu ứng workspace: fade thay cho trượt ngang (tự thêm)
-- hl.animation({
--     leaf = "workspaces",
--     enabled = true,
--     speed = 7,
--     bezier = "menu_decel",
--     style = "slide"
-- })

-- Hiệu ứng workspace: fade thay cho trượt ngang (tự thêm)
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 7,
    bezier = "menu_decel",
    style = "fade"
})

-- Khoảng cách cửa sổ (tự thêm)
hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 2
    }
})