# SKILL: apps — Gestión de aplicaciones con Homebrew

## Qué hace
Instala y sincroniza las aplicaciones declaradas en `packages/Brewfile`.

## Comandos clave

### Instalar todo lo del Brewfile
```
make apps
# o directamente:
brew bundle install --file=~/dotfiles/packages/Brewfile
```

### Capturar el estado actual → Brewfile
```
make dump-brew
```

### Verificar qué falta instalar
```
brew bundle check --file=~/dotfiles/packages/Brewfile
```

### Actualizar todo
```
make update
```

## Brewfile: ~/dotfiles/packages/Brewfile
Contiene: formulae brew, casks, mas (App Store), vscode extensions,
go tools y cargo tools.

## Apps no automatizables (requieren instalación manual/MDM)
- Falcon (CrowdStrike EDR) — MDM MeLi
- GlobalProtect (VPN Palo Alto)
- HorusScan — interno MeLi
- Jamf Connect — MDM auth
- Workspace ONE Assist/Hub — MDM VMware
- mhunt — herramienta interna MeLi

## atuin
Instalado via curl en `~/.atuin/bin/`. El Brewfile incluye `atuin` para
máquinas nuevas. En la máquina actual conviven ambas versiones.
