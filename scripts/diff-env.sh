#!/usr/bin/env bash
set -uo pipefail

DOTDIR="$(dirname "$(realpath "$0")")/.."

echo ""
echo "=== DOTFILES (chezmoi diff) ==="
if command -v chezmoi &>/dev/null; then
  chezmoi diff --source "$DOTDIR/home" 2>/dev/null || echo "  (sin diferencias)"
else
  echo "  ✗ chezmoi no instalado"
fi

echo ""
echo "=== BREW (vs Brewfile declarado) ==="
if command -v brew &>/dev/null; then
  echo "  Fórmulas instaladas no en Brewfile:"
  brew bundle check --file="$DOTDIR/packages/Brewfile" 2>&1 | grep "^  x " || echo "  (todo OK)"
else
  echo "  ✗ Homebrew no instalado"
fi
