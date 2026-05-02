#!/usr/bin/env bash
# Genera un snapshot del entorno actual en ~/dotfiles-inventory/
set -euo pipefail

OUT="$HOME/dotfiles-inventory"
mkdir -p "$OUT/dotly-files"

echo "→ Homebrew..."
brew list --formula > "$OUT/brew-formulae.txt"
brew list --cask    > "$OUT/brew-casks.txt"
brew bundle dump --describe --force --file="$OUT/Brewfile.current"

echo "→ Shell config..."
[ -f ~/.zshrc ]    && cp ~/.zshrc    "$OUT/dotly-files/zshrc.txt"
[ -f ~/.zshenv ]   && cp ~/.zshenv   "$OUT/dotly-files/zshenv.txt"
[ -f ~/.zprofile ] && cp ~/.zprofile "$OUT/dotly-files/zprofile.txt"

echo "→ macOS defaults..."
defaults export com.apple.dock      "$OUT/defaults-dock.plist"
defaults export com.apple.finder    "$OUT/defaults-finder.plist"
defaults export NSGlobalDomain      "$OUT/defaults-global.plist"
defaults export com.apple.screencapture "$OUT/defaults-screenshot.plist"

echo "→ Apps..."
ls /Applications > "$OUT/all-apps.txt"
mas list         > "$OUT/mas-apps.txt" 2>/dev/null || true

echo "→ Dev environments..."
{
  echo "node: $(node --version 2>/dev/null || echo N/A)"
  echo "python: $(python3 --version 2>/dev/null || echo N/A)"
  echo "go: $(go version 2>/dev/null || echo N/A)"
  echo "java: $(java --version 2>/dev/null | head -1 || echo N/A)"
  echo "ruby: $(ruby --version 2>/dev/null || echo N/A)"
  echo "rust: $(rustc --version 2>/dev/null || echo N/A)"
} > "$OUT/dev-environments.txt"

echo "✓ Inventario en $OUT"
