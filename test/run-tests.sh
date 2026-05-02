#!/usr/bin/env bash
# Orquestador de todos los tests
set -uo pipefail

DOTFILES_DIR="$(dirname "$(realpath "$0")")/.."
TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_WARN=0
FAILURES=""

run_suite() {
  local name="$1" script="$2"
  echo ""
  echo "┌─────────────────────────────────────────"
  echo "│ Suite: $name"
  echo "└─────────────────────────────────────────"

  local output
  output=$(bash "$script" 2>&1)
  echo "$output"

  local pass fail warn
  pass=$(echo "$output" | grep -c "✓ PASS" || true)
  fail=$(echo "$output" | grep -c "✗ FAIL" || true)
  warn=$(echo "$output" | grep -c "⚠ WARN" || true)

  TOTAL_PASS=$((TOTAL_PASS + pass))
  TOTAL_FAIL=$((TOTAL_FAIL + fail))
  TOTAL_WARN=$((TOTAL_WARN + warn))

  if [ "$fail" -gt 0 ]; then
    FAILURES="${FAILURES}\n#### $name\n"
    while IFS= read -r line; do
      FAILURES="${FAILURES}- ${line}\n"
    done < <(echo "$output" | grep "✗ FAIL")
  fi
}

echo "╔══════════════════════════════════════════╗"
echo "║   dotfiles — Validation Test Suite       ║"
echo "╠══════════════════════════════════════════╣"
printf  "║   %-42s ║\n" "$(date '+%Y-%m-%d %H:%M:%S')"
echo "╚══════════════════════════════════════════╝"

run_suite "Dotfiles"          "$DOTFILES_DIR/test/test-dotfiles.sh"
run_suite "Dev Environments"  "$DOTFILES_DIR/test/test-devenv.sh"
run_suite "Shell Tools"       "$DOTFILES_DIR/test/test-shell.sh"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   RESUMEN FINAL                          ║"
printf  "║   PASS: %-4s FAIL: %-4s WARN: %-11s ║\n" "$TOTAL_PASS" "$TOTAL_FAIL" "$TOTAL_WARN"
echo "╚══════════════════════════════════════════╝"
echo ""

REPORT_FILE="$DOTFILES_DIR/test/VALIDATION-REPORT.md"
cat > "$REPORT_FILE" << MDREPORT
# Validation Report — dotfiles Setup Manager

**Fecha:** $(date '+%Y-%m-%d %H:%M:%S')
**Entorno:** $(uname -a)

---

## Resumen ejecutivo

$([ "$TOTAL_FAIL" -eq 0 ] && echo "Bootstrap funciona correctamente en Ubuntu 22.04. Todos los asserts pasaron." || echo "Bootstrap completado con $TOTAL_FAIL fallo(s). Ver sección 'Fallos detallados'.")

---

## Test Suite — Ubuntu (Linux / WSL simulado)

| Suite | PASS | FAIL | WARN |
|-------|------|------|------|
| Dotfiles | - | - | - |
| Dev Environments | - | - | - |
| Shell Tools | - | - | - |
| **Total** | **$TOTAL_PASS** | **$TOTAL_FAIL** | **$TOTAL_WARN** |

---

## Fallos detallados

$([ -z "$FAILURES" ] && echo "Sin fallos." || printf '%b' "$FAILURES")

---

## Próximos pasos

- [ ] Agregar instalación de fnm + node LTS al bootstrap Linux
- [ ] Agregar instalación de pyenv + python al bootstrap Linux
- [ ] Agregar instalación de go al bootstrap Linux
- [ ] Configurar GitHub Actions para correr estos tests en cada push a main
- [ ] Agregar path de WSL (Windows) si aplica
MDREPORT

echo "→ Reporte guardado en $REPORT_FILE"

[ "$TOTAL_FAIL" -eq 0 ]
