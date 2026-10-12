-- Nhận diện theo serial, đổi cổng cắm không ảnh hưởng

-- Màn dọc (trái)
hl.monitor({
    output = "desc:ASUSTek COMPUTER INC PA278CV MCLMQS142609",
    mode = "2560x1440@59.95",
    position = "2001x1948",
    scale = 1,
    vrr = 0,
    transform = 1
})

-- Màn ngang (phải)
hl.monitor({
    output = "desc:ASUSTek COMPUTER INC PA278CV MCLMQS142654",
    mode = "2560x1440@59.95",
    position = "3441x2505",
    scale = 1,
    vrr = 0
})
