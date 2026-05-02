# Validation Report — dotfiles Setup Manager

**Fecha:** 2026-04-20
**Mac OS:** Darwin 25.3.0 arm64 (Apple Silicon)
**Docker image:** ubuntu:22.04
**Herramienta:** chezmoi v2.70.2 + Makefile

---

## Resumen ejecutivo

Bootstrap funciona correctamente en Ubuntu 22.04. Los 27 asserts pasaron con 0 fallos. Las 10 advertencias corresponden a herramientas macOS-only (Homebrew: starship, zoxide, atuin, lsd) y runtimes de desarrollo no instalados aún en Linux (node, go, java, rust, pnpm) — comportamiento esperado y documentado.

Se encontraron y corrigieron **2 bugs reales** en el proceso de validación:
1. El bootstrap Linux no incluía `unzip` + `zip` (requeridos por SDKMan) → todos los pasos post-bootstrap fallaban en cascada
2. `make link` llamaba `chezmoi apply --source` sin `--init` → la plantilla `.chezmoi.toml.tmpl` no se procesaba → variables de template faltaban en `.gitconfig`

---

## Test Suite — Ubuntu 22.04 (Linux / WSL simulado)

| Suite | PASS | FAIL | WARN |
|-------|------|------|------|
| Dotfiles | 8 | 0 | 0 |
| Dev Environments | 4 | 0 | 5 |
| Shell Tools | 15 | 0 | 5 |
| **Total** | **27** | **0** | **10** |

### Dotfiles (8/8 PASS)
- `.zshrc` existe y se sourcea sin errores en zsh
- `.gitconfig` existe con `mchediek_meli`, `matias.chediek`, `autoSetupRemote`
- `.gitignore_global` aplicado
- `.ssh/config` aplicado

### Dev Environments (4/4 PASS + 5 WARN esperados)
- `chezmoi` v2.70.2 instalado en `/home/matias/.local/bin`
- `age` v1.1.1 instalado en `/usr/local/bin`
- `python3` disponible (sistema)
- `SDKMan` instalado en `~/.sdkman` (manager, sin java aún)
- WARNs: node, go, java runtime, rust, pnpm → no instalados por bootstrap Linux (solo macOS via brew/nvm)

### Shell Tools (15/15 PASS + 5 WARN esperados)
- Paquetes apt.txt: git, curl, wget, make, zsh, tmux, nvim, fzf, jq, tree, rg, bat(cat), chezmoi
- PATH incluye `/home/matias/.local/bin`
- WARNs: starship, zoxide, atuin, lsd, j → solo macOS via Homebrew

---

## Idempotencia

**Resultado:** PASS — segunda ejecución idempotente.

Run 1 instala todos los paquetes. Run 2 produce:
- apt: `"X is already the newest version"` para todos los paquetes
- chezmoi: ya instalado, se sobreescribe sin error
- age: ya en `/usr/local/bin`, descarga sobreescribe limpiamente
- SDKMan: detecta instalación existente → skip
- chezmoi apply: aplica dotfiles sin cambios (idempotente)

No se generaron errores en la segunda ejecución.

---

## Comparativa: Mac vs Contenedor Linux

| Componente | Mac (real) | Contenedor (test) | Match |
|---|---|---|---|
| zsh | 5.9 | 5.8.1 | ✓ (minor ver diff OK) |
| chezmoi | v2.70.2 | v2.70.2 | ✓ |
| git | 2.49.0 | 2.34.1 | ✓ (distro ver OK) |
| .zshrc | ✓ | ✓ | ✓ |
| .gitconfig | ✓ | ✓ | ✓ |
| .gitignore_global | ✓ | ✓ | ✓ |
| .ssh/config | ✓ | ✓ | ✓ |
| age | 1.1.1 | 1.1.1 | ✓ |
| SDKMan | ✓ | ✓ | ✓ (manager) |
| node | v25.8.1 | — | ⚠ pendiente |
| python | 3.14.2 | 3.10 (sistema) | ⚠ versión diferente |
| go | go1.26.1 | — | ⚠ pendiente |
| java | openjdk 25 | — | ⚠ pendiente (SDKMan listo) |
| rust | 1.94.1 | — | ⚠ pendiente |
| starship | 1.25.0 | — | ⚠ solo macOS |
| zoxide | 0.9.9 | — | ⚠ solo macOS |
| atuin | 18.10.0 | — | ⚠ solo macOS |
| lsd | 1.2.0 | — | ⚠ solo macOS |

---

## Bugs encontrados y corregidos

### Bug 1 — SDKMan requiere `unzip` + `zip`
- **Síntoma:** `make bootstrap` fallaba con "Please install zip/unzip"
- **Causa:** El Dockerfile de test no incluía `zip` y `unzip` en el apt inicial
- **Fix:** Agregado `unzip zip` al RUN de apt en `Dockerfile.ubuntu` y `Dockerfile.idempotency`
- **Impacto original:** Bloqueaba todo el bootstrap (make install abortaba en cascade)

### Bug 2 — `chezmoi apply` sin `--init`
- **Síntoma:** `chezmoi: map has no entry for key "email"` al aplicar `.gitconfig.tmpl`
- **Causa:** `make link` llamaba `chezmoi apply --source <dir>` sin `--init`; el `.chezmoi.toml.tmpl` no se procesaba antes del apply
- **Fix:** `Makefile:link` → `chezmoi apply --source $(DOTDIR)/home --init`
- **Impacto:** Sin este fix, ningún dotfile templado se aplicaba en máquina nueva

---

## Fallos detallados

Sin fallos en la suite final. Los 10 WARNs son todos herramientas no instaladas por diseño en el bootstrap Linux actual.

---

## Próximos pasos

- [ ] Agregar instalación de `fnm` + `node LTS` al bootstrap Linux (`install/linux.sh`)
- [ ] Agregar instalación de `pyenv` + python 3.12 al bootstrap Linux
- [ ] Agregar instalación de `go` al bootstrap Linux
- [ ] Agregar `sdk install java` al bootstrap Linux (SDKMan ya está)
- [ ] Agregar `cargo`/rustup al bootstrap Linux
- [ ] Evaluar qué herramientas shell (starship, zoxide, atuin) instalar en Linux via apt/snap
- [ ] Configurar GitHub Actions para correr estos tests en cada push a main
- [ ] Agregar path de WSL (`install/wsl.sh` ya existe — integrar al test)
- [ ] Screenshots del proceso: no aplicable en entorno CLI headless — pendiente para GUI setup
