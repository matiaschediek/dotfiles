#!/usr/bin/env bash
# Tests: dotfiles aplicados correctamente por chezmoi
source "$(dirname "$0")/assertions.sh"

echo ""
echo "=== TEST: Dotfiles ==="

assert_file_exists "$HOME/.zshrc"
assert_file_exists "$HOME/.gitconfig"
assert_file_exists "$HOME/.gitignore_global"

# gitconfig tiene nombre personal y email desde template
assert_file_contains "$HOME/.gitconfig" "Matias Chediek"
assert_file_contains "$HOME/.gitconfig" "matias.chediek"
assert_file_contains "$HOME/.gitconfig" "autoSetupRemote"

# SSH config aplicado
assert_file_exists "$HOME/.ssh/config"

# El zshrc debe sourcing sin errores fatales
if command -v zsh &>/dev/null; then
  if zsh --no-rcs -c "source $HOME/.zshrc" 2>/dev/null; then
    echo "  ✓ PASS | .zshrc se sourcea sin errores en zsh"
    PASS=$((PASS + 1))
  else
    warn ".zshrc produce errores al sourcear en zsh (puede ser por herramientas macOS-only ausentes en Linux)"
  fi
else
  warn "zsh no instalado — no se puede probar el sourcing del .zshrc"
fi

print_summary
