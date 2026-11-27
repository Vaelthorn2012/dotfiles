#!/usr/bin/env bash
set -euo pipefail

pgrep -x "i3lock" >/dev/null 2>&1 && exit 0

src="$HOME/Pictures/lock.jpg"
img="$HOME/.cache/lock_blurred.png"
LOCK_FONT="Iosevka Nerd Font"
mkdir -p "$(dirname "$img")"

if [[ ! -f "$img" || "$src" -nt "$img" ]]; then
  magick "$src" \
    -resize 1280x1024^ -gravity center -extent 1280x1024 \
    -blur 0x16 \
    -fill "#09090b" -colorize 35% \
    "$img"
fi

exec i3lock -n \
  -i "$img" \
  --radius 90 \
  --ring-width 6 \
  --ind-pos="w/2:h/2+155" \
  --inside-color=18181be6 \
  --insidever-color=18181be6 \
  --insidewrong-color=27272ae6 \
  --ring-color=27272aff \
  --ringver-color=fafafaee \
  --ringwrong-color=ef4444ff \
  --keyhl-color=fafafaff \
  --bshl-color=ef4444ff \
  --line-color=09090b00 \
  --clock \
  --time-str="%I:%M %p" \
  --time-pos="w/2:h/2-95" \
  --time-color=fafafaff \
  --time-font="$LOCK_FONT" \
  --time-size=56 \
  --date-str="%A, %b %d" \
  --date-pos="w/2:h/2-25" \
  --date-color=e4e4e7ff \
  --date-font="$LOCK_FONT" \
  --date-size=20 \
  --greeter-text="ENTER PASSWORD" \
  --greeter-pos="w/2:h/2+35" \
  --greeter-color=a1a1aaff \
  --greeter-font="$LOCK_FONT" \
  --greeter-size=15 \
  --verif-text="CHECKING..." \
  --wrong-text="WRONG PASSWORD" \
  --noinput-text="" \
  --pass-media-keys \
  --pass-volume-keys
