#!/usr/bin/env bash
set -euo pipefail

mode="${1:-region}"
out_dir="${HOME}/Pictures/Screenshots"
mkdir -p "$out_dir"
ts="$(date +%Y-%m-%d_%H-%M-%S)"
raw_file="$(mktemp --tmpdir "shot_${ts}_XXXX.png")"
final_file="${out_dir}/shot_${ts}.png"

cleanup() {
  rm -f "$raw_file"
}
trap cleanup EXIT

case "$mode" in
  full)
    maim -u "$raw_file"
    ;;
    region)
    maim -u -s \
      -b 2 \
      -c "0.980,0.980,0.980,0.12" \
      --highlight \
      "$raw_file"
    ;;
  window)
    active_win="$(xdotool getactivewindow 2>/dev/null || true)"
    if [[ -n "$active_win" ]]; then
      maim -u -i "$active_win" "$raw_file"
    else
      maim -u "$raw_file"
    fi
    ;;
  *)
    dunstify -a "screenshot" -u critical "Screenshot" "Unknown mode: $mode (use full, region, or window)"
    exit 1
    ;;
esac

if [[ ! -s "$raw_file" ]]; then
  exit 0
fi

xclip -selection clipboard -t image/png -i "$raw_file"

if command -v satty >/dev/null 2>&1; then
  satty \
    --filename "$raw_file" \
    --output-filename "$final_file" \
    --early-exit \
    --copy-command "xclip -selection clipboard -t image/png -i" \
    --actions-on-enter "save-to-file,exit"
  if [[ -f "$final_file" ]]; then
    dunstify -a "screenshot" -u normal -i "$final_file" "Screenshot Saved" "$final_file"
  fi
else
  cp "$raw_file" "$final_file"
  dunstify -a "screenshot" -u normal -i "$final_file" "Screenshot Copied" "Saved to $final_file"
fi
