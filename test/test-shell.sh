#!/usr/bin/env bash
# Tests: herramientas y configuración del shell
# Instaladas via apt.txt: git curl wget make build-essential zsh tmux neovim ripgrep fzf jq tree bat
# No instaladas en Linux bootstrap: starship, zoxide, atuin, lsd (solo macOS via brew)
source "$(dirname "$0")/assertions.sh"

echo ""
echo "=== TEST: Shell Tools ==="

# Herramientas base (apt.txt)
assert_command_exists "git"
assert_command_exists "curl"
assert_command_exists "wget"
assert_command_exists "make"
assert_command_exists "zsh"
assert_command_exists "tmux"
assert_command_exists "nvim" "nvim"
assert_command_exists "fzf"
assert_command_exists "jq"
assert_command_exists "tree"
assert_command_exists "rg" "rg"
# En Ubuntu 22.04, el paquete 'bat' instala el binario como 'batcat'
if command -v bat &>/dev/null; then
  assert_command_exists "bat"
else
  assert_command_exists "bat (batcat)" "batcat"
fi
assert_command_exists "chezmoi"

# Variables de entorno básicas
assert_env_var "HOME"
assert_env_var "PATH" "/usr/local/bin\|/home/linuxbrew\|/usr/bin\|/home/matias/.local/bin"

# Herramientas macOS-only (Homebrew) — no disponibles en contenedor Linux
warn "starship: no instalado en Linux (solo macOS via brew)"
warn "zoxide: no instalado en Linux (solo macOS via brew)"
warn "atuin: no instalado en Linux (solo macOS via brew)"
warn "lsd: no instalado en Linux (solo macOS via brew — alias ls/ll/la no funcionales)"

# j/autojump/zoxide — no instalados
warn "j (zoxide/autojump): no instalado en Linux"

print_summary
