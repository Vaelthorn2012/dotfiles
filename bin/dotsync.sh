#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="$HOME/dotfiles"
msg="${1:-Update configs $(date '+%Y-%m-%d %H:%M')}"

mkdir -p "$dotfiles_dir/.config" "$dotfiles_dir/bin"
cp -r "$HOME/.config/rofi" "$HOME/.config/dunst" "$HOME/.config/oxwm" "$dotfiles_dir/.config/"
cp "$HOME/.local/bin/lock.sh" "$HOME/.local/bin/powermenu.sh" "$dotfiles_dir/bin/"
chmod +x "$dotfiles_dir/bin/lock.sh" "$dotfiles_dir/bin/powermenu.sh"

git -C "$dotfiles_dir" add .config bin

if git -C "$dotfiles_dir" diff --cached --quiet; then
  echo "No config changes to commit."
  exit 0
fi

git -C "$dotfiles_dir" commit -m "$msg"
git -C "$dotfiles_dir" push
