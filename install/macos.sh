#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/shared.sh"

COMMAND="${1:-install}"

case "$COMMAND" in
  bootstrap)
    log_info "Verificando Homebrew..."
    if ! command -v brew &>/dev/null; then
      log_info "Instalando Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    log_ok "Homebrew $(brew --version | head -1)"

    log_info "Instalando dependencias base..."
    brew install chezmoi age git make fnm
    log_ok "Dependencias base instaladas"

    log_info "Instalando SDKMan (Java)..."
    if [ ! -d "$HOME/.sdkman" ]; then
      curl -s "https://get.sdkman.io" | bash
      log_ok "SDKMan instalado"
    else
      log_ok "SDKMan ya instalado"
    fi
    ;;

  install)
    log_info "Instalando apps desde Brewfile..."
    brew bundle install --file="$(dirname "$0")/../packages/Brewfile"
    log_ok "Apps instaladas"
    ;;
esac
