#!/usr/bin/env bash
set -euo pipefail

dotfiles_dir="$HOME/dotfiles"
msg="${1:-Update configs $(date '+%Y-%m-%d %H:%M')}"

mkdir -p "$dotfiles_dir/.config" "$dotfiles_dir/bin"
cp -r "$HOME/.config/rofi" "$HOME/.config/dunst" "$HOME/.config/oxwm" "$dotfiles_dir/.config/"
if [ -d "$HOME/.config/alacritty" ]; then
  cp -r "$HOME/.config/alacritty" "$dotfiles_dir/.config/"
fi
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$dotfiles_dir/.zshrc"
fi
cp "$HOME/.local/bin/lock.sh" "$HOME/.local/bin/powermenu.sh" "$dotfiles_dir/bin/"
chmod +x "$dotfiles_dir/bin/lock.sh" "$dotfiles_dir/bin/powermenu.sh"

git -C "$dotfiles_dir" add .config bin
if [ -f "$dotfiles_dir/.zshrc" ]; then
  git -C "$dotfiles_dir" add .zshrc
fi

if git -C "$dotfiles_dir" diff --cached --quiet; then
  echo "No config changes to commit."
  exit 0
fi

git -C "$dotfiles_dir" commit -m "$msg"
git -C "$dotfiles_dir" push
