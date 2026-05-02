#!/usr/bin/env bash
# Funciones de aserción para los tests

PASS=0
FAIL=0
WARN=0

assert_command_exists() {
  local name="$1" cmd="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    echo "  ✓ PASS | $name está instalado ($(command -v "$cmd"))"
    PASS=$((PASS + 1))
  else
    echo "  ✗ FAIL | $name NO encontrado"
    FAIL=$((FAIL + 1))
  fi
}

assert_version_contains() {
  local name="$1" cmd="$2" expected="$3"
  local actual
  actual=$(eval "$cmd" 2>&1 | head -1)
  if echo "$actual" | grep -q "$expected"; then
    echo "  ✓ PASS | $name versión OK: $actual"
    PASS=$((PASS + 1))
  else
    echo "  ✗ FAIL | $name versión incorrecta. Esperado: '$expected', Actual: '$actual'"
    FAIL=$((FAIL + 1))
  fi
}

assert_file_exists() {
  local path="$1"
  if [ -f "$path" ]; then
    echo "  ✓ PASS | Archivo existe: $path"
    PASS=$((PASS + 1))
  else
    echo "  ✗ FAIL | Archivo NO existe: $path"
    FAIL=$((FAIL + 1))
  fi
}

assert_file_contains() {
  local path="$1" pattern="$2"
  if [ -f "$path" ] && grep -q "$pattern" "$path"; then
    echo "  ✓ PASS | $path contiene '$pattern'"
    PASS=$((PASS + 1))
  else
    echo "  ✗ FAIL | $path NO contiene '$pattern'"
    FAIL=$((FAIL + 1))
  fi
}

assert_env_var() {
  local name="$1" pattern="${2:-}"
  if [ -n "${!name:-}" ]; then
    if [ -z "$pattern" ] || echo "${!name}" | grep -q "$pattern"; then
      echo "  ✓ PASS | \$$name = ${!name}"
      PASS=$((PASS + 1))
    else
      echo "  ✗ FAIL | \$$name existe pero no contiene '$pattern': ${!name}"
      FAIL=$((FAIL + 1))
    fi
  else
    echo "  ✗ FAIL | \$$name no está definida"
    FAIL=$((FAIL + 1))
  fi
}

warn() {
  echo "  ⚠ WARN | $*"
  WARN=$((WARN + 1))
}

print_summary() {
  echo ""
  echo "═══════════════════════════════"
  echo "  PASS: $PASS  FAIL: $FAIL  WARN: $WARN"
  echo "═══════════════════════════════"
  [ "$FAIL" -eq 0 ]
}

export -f assert_command_exists assert_version_contains \
           assert_file_exists assert_file_contains \
           assert_env_var warn print_summary
export PASS FAIL WARN
