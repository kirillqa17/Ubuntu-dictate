# dictate-ru

Offline голосовая диктовка на русском языке для Linux. Работает без интернета, распознаёт речь локально через [Vosk](https://alphacephei.com/vosk/).

Идеально для ввода текста голосом в терминал, Claude Code и другие CLI-инструменты.

## Установка

```bash
git clone https://github.com/YOUR_USERNAME/dictate-ru.git
cd dictate-ru
./install.sh
```

Скрипт автоматически:
- Установит системные пакеты (`pulseaudio-utils`, `wl-clipboard`)
- Установит Python-библиотеку `vosk`
- Скачает русскую модель (~50MB)
- Добавит команду `dictate` в `~/.local/bin/`

## Использование

```bash
dictate
```

1. Говори по-русски в микрофон
2. Видишь текст в реальном времени
3. Жми **Ctrl+C** — готовый текст выводится в stdout и копируется в буфер обмена
4. Вставляй куда нужно через **Ctrl+V** / **Ctrl+Shift+V**

### Опции

```bash
dictate --no-copy    # Не копировать в буфер обмена
dictate --model /path/to/model  # Использовать другую Vosk модель
```

## Требования

- Linux (Ubuntu/Debian)
- Python 3.8+
- PulseAudio или PipeWire (с pulseaudio-utils)
- Wayland (для wl-copy) — на X11 работает без копирования в буфер

## Как это работает

```
Микрофон → parec (PulseAudio) → Vosk (offline STT) → текст в stdout + clipboard
```

Всё распознавание происходит локально — никакие данные не отправляются в интернет.

## Лицензия

MIT
