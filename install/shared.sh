#!/usr/bin/env bash

detect_os() {
  local os
  os=$(uname -s)
  case "$os" in
    Darwin) echo "macos" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

log_ok()   { echo "  ✓ $*"; }
log_info() { echo "  → $*"; }
log_warn() { echo "  ⚠ $*"; }
log_err()  { echo "  ✗ $*" >&2; }

apply_default() {
  local domain="$1" key="$2" type="$3" value="$4"
  local current
  current=$(defaults read "$domain" "$key" 2>/dev/null || echo "__NOT_SET__")
  if [ "$current" = "$value" ]; then
    log_ok "$domain → $key ya es '$value'"
  else
    log_info "$domain → $key: '$current' → '$value'"
    defaults write "$domain" "$key" "$type" "$value"
  fi
}

export -f detect_os log_ok log_info log_warn log_err apply_default
