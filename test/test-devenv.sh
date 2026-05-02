#!/usr/bin/env bash
# Tests: entornos de desarrollo
# Versiones de referencia: Mac usa node v25.8.1, python 3.14.2, go 1.26.1, java 25 (SDKMAN), rust 1.94.1
# En Linux, el bootstrap instala chezmoi + age + SDKMan (manager); los runtimes NO se instalan aún
source "$(dirname "$0")/assertions.sh"

echo ""
echo "=== TEST: Dev Environments ==="

# chezmoi y age son instalados por bootstrap.sh en Linux
assert_command_exists "chezmoi"
assert_command_exists "age"

# SDKMan manager (instalado, pero java requiere sdkman install java)
if [ -d "$HOME/.sdkman" ]; then
  echo "  ✓ PASS | SDKMan directorio existe: $HOME/.sdkman"
  PASS=$((PASS + 1))
else
  echo "  ✗ FAIL | SDKMan NO instalado"
  FAIL=$((FAIL + 1))
fi

# Runtimes no instalados por bootstrap Linux — se documentan como WARN
# Mac: node v25.8.1 (via homebrew/nvm) — Linux: pendiente de configurar fnm/nvm
warn "node: no instalado por bootstrap Linux (Mac: v25.8.1 via homebrew+nvm)"

# python3 del sistema (pre-instalado en el Dockerfile para validación)
# Mac usa Python 3.14.2 via brew + pyenv 3.12.11; Linux tiene python3 del sistema
assert_command_exists "python3"

# Mac: go 1.26.1 — Linux: pendiente
warn "go: no instalado por bootstrap Linux (Mac: go1.26.1)"

# Mac: java 25 via SDKMan — SDKMan instalado pero java no inicializado
warn "java: SDKMan instalado, pero 'sdk install java' no ejecutado (Mac: openjdk 25)"

# Mac: rust 1.94.1 — Linux: pendiente
warn "rust: no instalado por bootstrap Linux (Mac: rustc 1.94.1)"

# Mac: pnpm 10.16.1 — Linux: pendiente
warn "pnpm: no instalado por bootstrap Linux (Mac: 10.16.1)"

print_summary
