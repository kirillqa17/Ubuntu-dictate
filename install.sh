#!/bin/bash
set -e

echo "=== dictate-ru: установка ==="

# 1. System dependencies
echo "[1/4] Системные пакеты..."
if ! command -v parec &>/dev/null; then
    sudo apt-get update -qq
    sudo apt-get install -y -qq pulseaudio-utils
fi

if ! command -v wl-copy &>/dev/null; then
    sudo apt-get install -y -qq wl-clipboard 2>/dev/null || echo "  wl-clipboard не установлен (clipboard не будет работать на X11 — ок)"
fi

# 2. Python vosk
echo "[2/4] Python vosk..."
if ! python3 -c "import vosk" 2>/dev/null; then
    pip install --user --break-system-packages vosk 2>/dev/null \
        || pip install --user vosk 2>/dev/null \
        || pip install vosk
fi

# 3. Download model
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODEL_DIR="$SCRIPT_DIR/model"

echo "[3/4] Русская модель Vosk..."
if [ ! -d "$MODEL_DIR" ] || [ ! -d "$MODEL_DIR/graph" ]; then
    MODEL_NAME="vosk-model-small-ru-0.22"
    MODEL_URL="https://alphacephei.com/vosk/models/${MODEL_NAME}.zip"
    TMP_ZIP="/tmp/${MODEL_NAME}.zip"

    echo "  Скачиваю $MODEL_NAME (~50MB)..."
    wget -q --show-progress "$MODEL_URL" -O "$TMP_ZIP"
    unzip -qo "$TMP_ZIP" -d "$SCRIPT_DIR"
    rm -f "$TMP_ZIP"
    ln -sfn "$SCRIPT_DIR/$MODEL_NAME" "$MODEL_DIR"
    echo "  Модель готова."
else
    echo "  Модель уже есть."
fi

# 4. Symlink to PATH
echo "[4/4] Добавляю в PATH..."
chmod +x "$SCRIPT_DIR/dictate"
mkdir -p "$HOME/.local/bin"
ln -sfn "$SCRIPT_DIR/dictate" "$HOME/.local/bin/dictate"

echo ""
echo "=== Готово! ==="
echo "Запуск:  dictate"
echo "Говори по-русски, жми Ctrl+C — текст скопируется в буфер."
