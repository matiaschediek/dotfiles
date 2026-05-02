#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/shared.sh"

log_info "Aplicando ajustes WSL..."

WINDOWS_HOME=$(cmd.exe /c "echo %USERPROFILE%" 2>/dev/null | tr -d '\r' || true)
if [ -n "$WINDOWS_HOME" ]; then
  WSLCONFIG="$WINDOWS_HOME/.wslconfig"
  log_info "Configurando $WSLCONFIG..."
  cat > "$WSLCONFIG" << 'EOF'
[wsl2]
memory=8GB
processors=4
EOF
  log_ok ".wslconfig configurado"
fi

log_ok "Ajustes WSL aplicados"
