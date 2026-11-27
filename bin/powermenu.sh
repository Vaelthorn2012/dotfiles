#!/usr/bin/env bash
set -euo pipefail

lock_cmd="$HOME/.local/bin/lock.sh"

options=$(printf '%s\n' \
  "  Lock" \
  "󰍃  Lock & Screen Off" \
  "󰜉  Restart" \
  "⏻  Shutdown")

chosen=$(printf '%s\n' "$options" | rofi -dmenu -i -p "Power")

case "$chosen" in
  "  Lock")
    "$lock_cmd"
    ;;
  "󰍃  Lock & Screen Off")
    "$lock_cmd" &
    sleep 0.3
    xset dpms force off
    ;;
  "󰜉  Restart")
    systemctl reboot
    ;;
  "⏻  Shutdown")
    systemctl poweroff
    ;;
  *)
    exit 0
    ;;
esac
