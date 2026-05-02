#!/usr/bin/env bash
# bootstrap.sh — One-liner para máquina nueva
# Uso: curl -fsSL https://raw.githubusercontent.com/mchediek/dotfiles/main/bootstrap.sh | bash
# o:  bash ~/dotfiles/bootstrap.sh

set -euo pipefail

DOTFILES_REPO="https://github.com/mchediek/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"

echo ""
echo "╔══════════════════════════════════╗"
echo "║   dotfiles — Setup Manager       ║"
echo "╚══════════════════════════════════╝"
echo ""

OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
  if ! command -v brew &>/dev/null; then
    echo "→ Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew install git make chezmoi age fnm
elif [ "$OS" = "Linux" ]; then
  sudo apt-get update -q
  sudo apt-get install -y git make curl
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "→ Clonando dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"
make install

echo ""
echo "✓ Setup completo. Reiniciá el shell: exec zsh"
