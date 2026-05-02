#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/shared.sh"

COMMAND="${1:-install}"

case "$COMMAND" in
  bootstrap)
    log_info "Actualizando apt..."
    sudo apt-get update -q
    sudo apt-get install -y git make curl build-essential

    log_info "Instalando chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"

    log_info "Instalando age..."
    AGE_VERSION="1.1.1"
    curl -Lo /tmp/age.tar.gz \
      "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz"
    tar -xzf /tmp/age.tar.gz -C /tmp
    sudo mv /tmp/age/age /usr/local/bin/
    rm -rf /tmp/age.tar.gz /tmp/age
    log_ok "chezmoi y age instalados"

    log_info "Instalando SDKMan (Java)..."
    if [ ! -d "$HOME/.sdkman" ]; then
      curl -s "https://get.sdkman.io" | bash
      log_ok "SDKMan instalado"
    else
      log_ok "SDKMan ya instalado"
    fi
    ;;

  install)
    log_info "Instalando packages desde apt.txt..."
    xargs sudo apt-get install -y < "$(dirname "$0")/../packages/apt.txt"
    log_ok "Packages instalados"
    ;;
esac
