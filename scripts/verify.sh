#!/usr/bin/env bash
set -uo pipefail

DOTDIR="$(dirname "$(realpath "$0")")/.."
ERRORS=0

check_cmd() {
  local name="$1" cmd="$2"
  if eval "$cmd" &>/dev/null; then
    local version
    version=$(eval "$cmd" 2>/dev/null | head -1)
    echo "  ✓ $name: $version"
  else
    echo "  ✗ $name: NO ENCONTRADO"
    ERRORS=$((ERRORS + 1))
  fi
}

echo ""
echo "=== DOTFILES ==="
if command -v chezmoi &>/dev/null; then
  chezmoi status --source "$DOTDIR/home" 2>/dev/null | while read -r line; do
    echo "  $line"
  done || echo "  (sin cambios pendientes)"
else
  echo "  ✗ chezmoi: NO ENCONTRADO"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=== BREW ==="
if command -v brew &>/dev/null; then
  TOTAL=$(brew list --formula 2>/dev/null | wc -l | tr -d ' ')
  echo "  ✓ Homebrew instalado — $TOTAL fórmulas"
else
  echo "  ✗ Homebrew no encontrado"
  ERRORS=$((ERRORS + 1))
fi

echo ""
echo "=== SHELL TOOLS ==="
check_cmd "zsh"      "zsh --version"
check_cmd "chezmoi"  "chezmoi --version"
check_cmd "starship" "starship --version"
check_cmd "zoxide"   "zoxide --version"
check_cmd "atuin"    "atuin --version"
check_cmd "lsd"      "lsd --version"
check_cmd "fzf"      "fzf --version"

echo ""
echo "=== DEV ENVIRONMENTS ==="
check_cmd "node"   "node --version"
check_cmd "fnm"    "fnm --version"
check_cmd "python" "python3 --version"
check_cmd "pyenv"  "pyenv --version"
check_cmd "go"     "go version"
check_cmd "java"   "java --version"
check_cmd "ruby"   "ruby --version"
check_cmd "rust"   "rustc --version"

echo ""
echo "=== RESUMEN ==="
if [ "$ERRORS" -eq 0 ]; then
  echo "  ✓ Todo OK"
else
  echo "  ✗ $ERRORS problema(s) encontrado(s)"
fi
echo ""

exit $ERRORS
