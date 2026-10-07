#!/bin/bash
# Wallpaper riêng cho 2 màn
# Cách dùng: dual_wallpaper.sh <file màn dọc> <file màn ngang>
#            dual_wallpaper.sh --doc <file>    chỉ đổi màn dọc (tự thêm)
#            dual_wallpaper.sh --ngang <file>  chỉ đổi màn ngang (tự thêm)
# Không truyền tham số: dùng lại 2 file đã lưu (chạy lúc khởi động)

STATE="$HOME/.config/hypr/custom/dual_wallpaper.conf"
MODE_FILE="$HOME/.config/hypr/custom/dual_wallpaper.mode"   # (tự thêm)
II_CONFIG="$HOME/.config/illogical-impulse/config.json"      # (tự thêm)
ONLY=""      # doc / ngang: chỉ đổi 1 màn (tự thêm)
WAS_DUAL=0   # 1 = trước đó đã ở chế độ 2 hình (tự thêm)

if [ $# -eq 2 ] && { [ "$1" = "--doc" ] || [ "$1" = "--ngang" ]; }; then
    # Đổi riêng 1 màn, màn còn lại giữ nguyên (tự thêm)
    ONLY="${1#--}"
    TARGET=$(realpath "$2")
    if [ -f "$STATE" ] && [ "$(cat "$MODE_FILE" 2>/dev/null)" = "1" ]; then
        source "$STATE"
        WAS_DUAL=1
    else
        # Đang ở chế độ chọn hình kiểu gốc: màn còn lại dùng hình hiện tại
        CUR=$(jq -r '.background.wallpaperPath // empty' "$II_CONFIG" 2>/dev/null)
        DOC="$CUR"
        NGANG="$CUR"
    fi
    if [ "$ONLY" = "doc" ]; then DOC="$TARGET"; else NGANG="$TARGET"; fi
    for f in "$DOC" "$NGANG"; do
        if [ ! -f "$f" ]; then
            echo "Không tìm thấy file: $f"
            exit 1
        fi
    done
    printf 'DOC=%q\nNGANG=%q\n' "$DOC" "$NGANG" > "$STATE"
    echo 1 > "$MODE_FILE"
elif [ $# -eq 2 ]; then
    DOC=$(realpath "$1")
    NGANG=$(realpath "$2")
    for f in "$DOC" "$NGANG"; do
        if [ ! -f "$f" ]; then
            echo "Không tìm thấy file: $f"
            exit 1
        fi
    done
    # Lưu lại cho lần khởi động sau
    printf 'DOC=%q\nNGANG=%q\n' "$DOC" "$NGANG" > "$STATE"
    echo 1 > "$HOME/.config/hypr/custom/dual_wallpaper.mode"
elif [ $# -eq 0 ]; then
    if [ ! -f "$STATE" ]; then
        echo "Chưa có wallpaper nào được lưu"
        exit 1
    fi
    source "$STATE"
    # Đợi script wallpaper mặc định chạy xong lúc khởi động
    sleep 2
else
    echo "Cách dùng: $(basename "$0") <file màn dọc> <file màn ngang>"
    echo "       $(basename "$0") --doc <file> | --ngang <file>"   # (tự thêm)
    exit 1
fi

OPTS="image-display-duration=inf no-audio loop hwdec=auto scale=bilinear interpolation=no video-sync=display-resample panscan=1.0 video-align-x=0 video-align-y=0 load-scripts=no"

# Tìm tên cổng theo serial
MON_DOC=$(hyprctl monitors -j | jq -r '.[] | select(.description | contains("MCLMQS142609")) | .name')
MON_NGANG=$(hyprctl monitors -j | jq -r '.[] | select(.description | contains("MCLMQS142654")) | .name')

if [ -n "$ONLY" ] && [ "$WAS_DUAL" = "1" ]; then
    # Đã ở chế độ 2 hình: chỉ chạy lại mpvpaper của màn được đổi (tự thêm)
    if [ "$ONLY" = "doc" ]; then
        MON_T="$MON_DOC"; FILE_T="$DOC"; MON_O="$MON_NGANG"; FILE_O="$NGANG"
    else
        MON_T="$MON_NGANG"; FILE_T="$NGANG"; MON_O="$MON_DOC"; FILE_O="$DOC"
    fi
    pkill -f -9 "^mpvpaper -o .* $MON_T "
    setsid -f mpvpaper -o "$OPTS" "$MON_T" "$FILE_T" >/dev/null 2>&1
    # Màn còn lại chưa có mpvpaper thì chạy luôn
    if ! pgrep -f "^mpvpaper -o .* $MON_O " >/dev/null; then
        sleep 0.1
        setsid -f mpvpaper -o "$OPTS" "$MON_O" "$FILE_O" >/dev/null 2>&1
    fi
else
pkill -f -9 mpvpaper

# setsid -f: chạy tách khỏi terminal, đóng terminal không bị tắt wallpaper
setsid -f mpvpaper -o "$OPTS" "$MON_DOC" "$DOC" >/dev/null 2>&1
sleep 0.1
setsid -f mpvpaper -o "$OPTS" "$MON_NGANG" "$NGANG" >/dev/null 2>&1
fi   # (tự thêm)

echo "Màn dọc:  $DOC"
echo "Màn ngang: $NGANG"
