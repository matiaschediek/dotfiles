# SKILL: devenv — Entornos de desarrollo

## Resumen del entorno actual

| Runtime | Gestor | Versión activa |
|---------|--------|----------------|
| Node.js | fnm    | v20.18.1 (default) |
| Python  | pyenv  | 3.12.11 |
| Go      | brew   | 1.26.1 |
| Java    | SDKMan | OpenJDK 25.0.2 Temurin |
| Ruby    | brew   | moderno |
| Rust    | rustup | 1.94.1 |

## Node.js — fnm
```bash
fnm list            # versiones instaladas
fnm use 20          # activar versión
fnm install 20      # instalar versión
```
Los `.nvmrc` en proyectos se respetan automáticamente con `--use-on-cd`.

## Python — pyenv
```bash
pyenv versions      # versiones instaladas
pyenv global 3.12.11  # cambiar versión global
pyenv install 3.12.11 # instalar versión
```

## Java — SDKMan
```bash
sdk list java       # versiones disponibles
sdk install java    # instalar latest
sdk use java 21     # cambiar versión
```

## Rust — rustup
```bash
rustup update       # actualizar toolchain
rustup show         # versión activa
```

## Go — brew
```bash
go version
brew upgrade go
```
GOPATH: ~/.go

## pnpm
```bash
pnpm --version
```
PNPM_HOME: ~/Library/pnpm (macOS)
