# SKILL: dotfiles — Gestión de dotfiles con chezmoi

## Qué hace
Aplica los dotfiles del repo a la máquina usando chezmoi.
Los templates `.tmpl` se renderizan con variables de `.chezmoi.toml`.

## Comandos clave

### Ver cambios pendientes (sin aplicar)
```
make diff
```

### Aplicar cambios
```
make link
# o interactivo:
chezmoi apply --source ~/dotfiles/home --interactive
```

### Ver estado actual
```
make status
```

### Editar un dotfile
```
chezmoi edit --source ~/dotfiles/home ~/.zshrc
```

### Verificar que un template renderiza correctamente
```
chezmoi cat --source ~/dotfiles/home ~/.zshrc
```

## Archivos gestionados
- `~/.zshrc` ← `home/dot_zshrc.tmpl`
- `~/.zshenv` ← `home/dot_zshenv.tmpl`
- `~/.gitconfig` ← `home/dot_gitconfig.tmpl`
- `~/.gitignore` ← `home/dot_gitignore_global`
- `~/.ssh/config` ← `home/private_dot_ssh/config.tmpl`

## Secretos
Las claves SSH privadas NO van al repo. Solo `~/.ssh/config`.
Los tokens de Claude Code NO van al repo. Configuración manual post-bootstrap.
