# linux-config

Config cá nhân cho Arch Linux + Hyprland, dùng bộ rice **[illogical-impulse (end-4/dots-hyprland)](https://github.com/end-4/dots-hyprland)**.
Repo này chính là thư mục `~/.config`, nhưng chỉ theo dõi những thư mục được liệt kê trong `.gitignore` (dạng whitelist).

## Repo chứa những gì

| Thư mục / file | Nội dung |
|---|---|
| `hypr/` | Config Hyprland. **Chỉnh sửa riêng nằm trong `hypr/custom/`** (xem bên dưới) |
| `hypr/monitors.lua`, `hypr/workspaces.lua` | 2 màn ASUS PA278CV: màn dọc bên trái (workspace 1), màn ngang bên phải (workspace 2) |
| `quickshell/`, `illogical-impulse/`, `matugen/` | Thanh bar, widget, settings và bộ sinh màu của rice |
| `kitty/`, `foot/`, `fish/`, `zshrc.d/`, `starship.toml` | Terminal và shell |
| `fuzzel/`, `wlogout/`, `cava/`, `mpv/` | Launcher, menu tắt máy, visualizer nhạc, trình phát video |
| `fcitx5/` | Bộ gõ tiếng Việt |
| `Kvantum/`, `gtk-3.0/`, `gtk-4.0/`, `kde-material-you-colors/`, `fontconfig/` | Theme, font |
| `*-flags.conf` | Cờ khởi động của Chrome, Thorium, VS Code |
| `mimeapps.list` | App mặc định để mở từng loại file |
| `pkglist.txt` | Các gói cài từ kho chính thức (pacman) |
| `pkglist-aur.txt` | Các gói AUR (Chrome, Slack, Teams, Outlook, VS Code, Upscayl, mpvpaper…) |

### Những gì đã tự chỉnh (`hypr/custom/`)

- `execs.lua`: tự khoá màn hình sau autologin, cursor **GawrGura-2026**, wallpaper video cho 2 màn, `fcitx5`, tự mở Chrome và Teams ở workspace 2, VS Code ở workspace 1
- `rules.lua`: bật lại blur cho cửa sổ, VS Code luôn mở ở workspace 1
- `general.lua`, `env.lua`, `keybinds.lua`: các giá trị ghi đè cấu hình mặc định
- `scripts/dual_wallpaper.sh`, `dual_wallpaper.conf`: wallpaper ảnh cho màn dọc, video (mpvpaper) cho màn ngang

### ⚠️ Những thứ KHÔNG có trong repo (phải tự chép sang máy mới)

- **Cursor GawrGura**: `~/.local/share/icons/GawrGura-*`
- **Wallpaper**: `~/Pictures/Wallpapers/` (`saba.png`, `saba-dance.mp4`). Đường dẫn được khai báo trong `hypr/custom/dual_wallpaper.conf`
- Dữ liệu và đăng nhập của các app (Chrome, Slack, Teams, VS Code…): đăng nhập lại, hoặc dùng tính năng sync của từng app
- SSH key (`~/.ssh`): tạo key mới trên mỗi máy

---

## Cài lên máy mới

### 1. Cài Arch và rice end-4

```bash
git clone https://github.com/end-4/dots-hyprland.git ~/project/dots-hyprland
cd ~/project/dots-hyprland
./setup install
```

Bước này cài Hyprland, quickshell và toàn bộ gói phụ thuộc, đồng thời tạo config mặc định trong `~/.config`.

### 2. Cài các gói còn lại

```bash
curl -O https://raw.githubusercontent.com/vgbao1231/linux-config/main/pkglist.txt
curl -O https://raw.githubusercontent.com/vgbao1231/linux-config/main/pkglist-aur.txt
sudo pacman -S --needed - < pkglist.txt
yay -S --needed - < pkglist-aur.txt
```

Nếu repo đang để private thì `curl` sẽ không tải được. Khi đó làm bước 3 trước rồi chạy các lệnh cài trong `~/.config`.
Nếu pacman báo gói nào không tồn tại (bị đổi tên hoặc gỡ khỏi kho), xoá dòng đó trong file rồi chạy lại.

### 3. Đè config của mình lên

`~/.config` đã có sẵn file nên không `git clone` thẳng vào được. Thay vào đó chạy:

```bash
cd ~/.config
git init -b main
git remote add origin https://github.com/vgbao1231/linux-config.git
git fetch origin
git checkout -f -B main origin/main   # ghi đè file mặc định bằng bản trong repo
```

Chỉ những file có trong repo bị ghi đè. Các file khác trong `~/.config` không bị ảnh hưởng.

### 4. Chép cursor và wallpaper, chỉnh màn hình

- Chép `GawrGura-*` vào `~/.local/share/icons/` và wallpaper vào `~/Pictures/Wallpapers/`.
- **Màn hình khác thì phải sửa `hypr/monitors.lua`.** Lấy tên màn bằng `hyprctl monitors all` rồi sửa `output = "desc:..."`, `mode`, `position`.
- Đường dẫn trong `hypr/custom/dual_wallpaper.conf` dùng `/home/vgbao/...`. Nếu tên user khác thì sửa lại.

### 5. Nạp lại và thiết lập push

```bash
hyprctl reload        # hoặc đăng xuất rồi đăng nhập lại

# tạo SSH key và thêm vào https://github.com/settings/ssh/new
ssh-keygen -t ed25519 -C "vgbao1231@github" -f ~/.ssh/id_ed25519 -N ""
cat ~/.ssh/id_ed25519.pub
git -C ~/.config remote set-url origin git@github.com:vgbao1231/linux-config.git
git -C ~/.config branch -u origin/main
```

---

## Dùng hằng ngày

Mở `~/.config` bằng VS Code, vào tab **Source Control** (Ctrl+Shift+G) để xem thay đổi, commit, push. Hoặc dùng terminal:

```bash
cd ~/.config
git status
git add -A && git commit -m "mô tả thay đổi" && git push
```

### Quy tắc khi chỉnh config

- **Sửa trong `hypr/custom/`**, không sửa thẳng `hypr/hyprland/*.lua`. Bản update của rice ghi đè `hypr/hyprland/` nhưng giữ nguyên `custom/`.
- Muốn theo dõi thêm một config mới (ví dụ `nvim`): thêm dòng `!/nvim/` vào `.gitignore` rồi commit.
- Các file `*.bak` bị bỏ qua, không lên git.

### Khi update rice end-4

```bash
cd ~/.config && git add -A && git commit -m "before update" && git push   # 1. lưu lại trước
cd ~/project/dots-hyprland && git stash && git pull && ./setup install      # 2. update
cd ~/.config && git diff --stat                                             # 3. xem file nào bị đổi
git checkout -- <file>                                                      # 4. lấy lại file bị ghi đè sai
hyprctl reload
```

Trong VS Code, bấm **Discard Changes (↶)** trên từng file cũng có tác dụng như bước 4.

### Cập nhật danh sách gói

Hai file danh sách gói không tự cập nhật. Sau khi cài hoặc gỡ phần mềm:

```bash
cd ~/.config
pacman -Qqen > pkglist.txt
pacman -Qqem | grep -v '^illogical-impulse-' > pkglist-aur.txt
git add pkglist*.txt && git commit -m "Update package lists" && git push
```

Các gói `illogical-impulse-*` được loại ra vì chúng là gói nội bộ do `./setup install` tự build, không có trên AUR.

---

## Xử lý sự cố

| Triệu chứng | Cách xử lý |
|---|---|
| Hyprland báo đỏ `config has errors` / `cannot open hyprland.lua` sau khi git checkout hoặc update | Thường chỉ là lỗi tạm do Hyprland nạp lại đúng lúc file đang được ghi. Chạy `hyprctl reload`, rồi `hyprctl configerrors` để xem lỗi thật nếu còn |
| VS Code hiện hàng nghìn thay đổi kỳ lạ | Ctrl+Shift+P → `Developer: Reload Window`. Kiểm tra bằng `git status` trong terminal |
| Cấu hình màn hình bị lệch | Sửa `hypr/monitors.lua` theo `hyprctl monitors all` |
| Push bị từ chối / hỏi mật khẩu | Kiểm tra `ssh -T git@github.com` và remote phải là `git@github.com:...` |
