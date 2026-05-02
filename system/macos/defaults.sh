#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../install/shared.sh"

DRY_RUN="${1:-}"
if [ "$DRY_RUN" = "--dry-run" ]; then
  log_info "MODO DRY RUN — no se aplicarán cambios"
  apply_default() { log_info "[dry-run] defaults write $1 $2 $3 $4"; }
fi

log_info "Aplicando macOS defaults..."

# Dock
apply_default "com.apple.dock" "autohide"               "-bool"   "true"
apply_default "com.apple.dock" "minimize-to-application" "-bool"   "false"
apply_default "com.apple.dock" "show-recents"            "-bool"   "false"
apply_default "com.apple.dock" "tilesize"                "-int"    "42"
apply_default "com.apple.dock" "orientation"             "-string" "left"

# Finder
apply_default "com.apple.finder" "ShowPathbar"                "-bool"   "true"
apply_default "com.apple.finder" "ShowStatusBar"              "-bool"   "true"
apply_default "com.apple.finder" "FXEnableExtensionChangeWarning" "-bool" "false"
apply_default "com.apple.finder" "_FXSortFoldersFirst"        "-bool"   "true"
apply_default "com.apple.finder" "FXDefaultSearchScope"       "-string" "SCcf"

# Screenshots
apply_default "com.apple.screencapture" "type" "-string" "png"

# Keyboard
apply_default "NSGlobalDomain" "KeyRepeat"             "-int" "1"
apply_default "NSGlobalDomain" "InitialKeyRepeat"      "-int" "20"
apply_default "NSGlobalDomain" "ApplePressAndHoldEnabled" "-bool" "true"

log_ok "Defaults aplicados"
log_info "Reiniciando Dock y Finder..."
killall Dock   2>/dev/null || true
killall Finder 2>/dev/null || true
log_ok "Listo"
