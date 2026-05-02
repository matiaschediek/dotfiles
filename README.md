# dotfiles

Configuración personal de entorno de desarrollo gestionada con [chezmoi](https://chezmoi.io).
Cubre shell, git, SSH, herramientas de desarrollo y aplicaciones para macOS y Linux.

---

## Qué incluye

| Área | Detalle |
|------|---------|
| Shell | zsh + starship + atuin + zoxide + fzf + lsd |
| Git | gitconfig con firma SSH, delta como diff viewer |
| Terminal | Ghostty + tmux |
| Dev runtimes | Node (fnm), Python (pyenv), Go, Java (SDKMan), Ruby, Rust |
| Apps (macOS) | Homebrew Brewfile con formulae, casks y Mac App Store |
| Sistema | macOS defaults automatizados |
| SSH | Configuración multi-cuenta (personal + work overlay) |

---

## Dependencias clave

- **[chezmoi](https://chezmoi.io)** — gestiona y aplica los dotfiles con soporte para templates
- **[Homebrew](https://brew.sh)** — instala y sincroniza todas las apps (macOS) o apt (Linux)
- **[age](https://github.com/FiloSottile/age)** — cifrado de archivos sensibles gestionados por chezmoi
- **[make](https://www.gnu.org/software/make/)** — punto de entrada principal para todos los comandos

---

## Cómo usarlo (Humano)

### Máquina nueva — setup completo automático

```bash
curl -fsSL https://raw.githubusercontent.com/mchediek/dotfiles/main/bootstrap.sh | bash
```

Esto instala Homebrew (si falta), clona el repo en `~/dotfiles` y ejecuta `make install`.

### Si ya tenés el repo clonado

```bash
cd ~/dotfiles
make install
```

Tiempo estimado: 15-30 min en máquina nueva, 2-3 min si ya está configurada. Es idempotente.

### Comandos útiles del día a día

| Comando | Qué hace |
|---------|----------|
| `make help` | Muestra todos los comandos disponibles |
| `make check` | Verifica que todo el entorno esté OK (sin instalar nada) |
| `make diff` | Muestra qué dotfiles cambiaron sin aplicar |
| `make status` | Estado de chezmoi (archivos modificados localmente) |
| `make update` | Actualiza packages y re-aplica dotfiles |
| `make apps` | Instala/sincroniza apps desde Brewfile |
| `make dump-brew` | Captura el Homebrew actual → Brewfile |
| `make vscode` | Aplica settings y extensiones de VS Code |
| `make vscode-dump` | Sincroniza VS Code actual → dotfiles |

### Editar dotfiles

Los archivos fuente viven en `home/`. chezmoi los aplica con `make link`.
Los archivos `.tmpl` son templates de chezmoi — reciben variables desde `home/.chezmoi.toml.tmpl`.

```bash
# Ver qué cambiaría antes de aplicar
make diff

# Aplicar cambios
make link
```

---

## Cómo usarlo (IA)

### Estructura del repo

```
dotfiles/
├── bootstrap.sh          # One-liner para máquina nueva
├── Makefile              # Punto de entrada principal
├── home/                 # Fuente de dotfiles (chezmoi)
│   ├── .chezmoi.toml.tmpl   # Variables del usuario (nombre, email, OS)
│   ├── dot_zshrc.tmpl       # Shell config (→ ~/.zshrc)
│   ├── dot_zshenv.tmpl      # Variables de entorno (→ ~/.zshenv)
│   ├── dot_gitconfig.tmpl   # Git config (→ ~/.gitconfig)
│   ├── dot_gitignore_global # Gitignore global
│   ├── private_dot_ssh/     # SSH config (→ ~/.ssh/)
│   └── dot_config/          # configs de apps (starship, ghostty, vscode)
├── packages/
│   ├── Brewfile          # Apps macOS (brew + cask + mas + vscode + go + cargo)
│   └── apt.txt           # Packages Linux
├── install/
│   ├── macos.sh          # Bootstrap y setup macOS
│   ├── linux.sh          # Bootstrap y setup Linux
│   ├── shared.sh         # Funciones compartidas
│   └── wsl.sh            # Setup WSL
├── system/
│   └── macos/defaults.sh # macOS system defaults
├── scripts/
│   ├── verify.sh         # Verifica el entorno
│   ├── diff-env.sh       # Diferencias entre actual y declarado
│   └── inventory.sh      # Inventario completo del entorno
├── skills/               # Documentación para agentes IA
│   ├── SKILL-dotfiles.md
│   ├── SKILL-install.md
│   ├── SKILL-devenv.md
│   ├── SKILL-apps.md
│   └── SKILL-verify.md
└── test/                 # Tests de idempotencia (Docker)
```

### Convenciones de chezmoi

- `dot_` → `.` (ej: `dot_zshrc` → `~/.zshrc`)
- `private_` → permisos 600
- `.tmpl` → template de Go con variables de `.chezmoi.toml.tmpl`
- Variables disponibles: `.name`, `.email`, `.github_user`, `.os`, `.homebrew_prefix`

### Comandos de diagnóstico para IA

```bash
make ai-status   # Estado completo del entorno en texto legible
make ai-diff     # Diferencias entre entorno actual y declarado
make check       # Verificación rápida de herramientas
```

### Skills disponibles

Los archivos en `skills/` documentan capacidades operativas específicas:

- `SKILL-install.md` — cómo ejecutar el setup completo
- `SKILL-dotfiles.md` — cómo gestionar los dotfiles con chezmoi
- `SKILL-devenv.md` — runtimes de desarrollo y sus gestores
- `SKILL-apps.md` — gestión de apps con Homebrew
- `SKILL-verify.md` — cómo verificar el estado del entorno

---

## Perfil laboral (work overlay)

Este repo está diseñado para convivir con un repositorio separado de configuración laboral.
El patrón es un overlay: los dotfiles base cargan archivos de trabajo si existen, sin depender de ellos.

Los puntos de extensión son:

| Archivo base | Carga automáticamente |
|---|---|
| `~/.zshrc` | `~/.zshrc.work` (si existe) |
| `~/.gitconfig` | `~/.gitconfig.work` (si existe) |
| `~/.ssh/config` | `~/.ssh/work_config` (si existe) |

El repositorio laboral (ej: `~/dotfiles-work`) se encarga de poblar esos tres archivos
con variables de entorno, aliases, configuración de git corporativa y claves SSH de trabajo.
El setup típico sería:

```bash
# 1. Setup personal (este repo)
make install

# 2. Setup laboral (repo separado)
cd ~/dotfiles-work
make install
```

De esta forma el entorno personal y laboral están completamente separados y cada uno
se puede actualizar de forma independiente.
