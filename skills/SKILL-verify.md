# SKILL: verify — Verificar el estado del entorno

## Qué hace
Comprueba que todas las herramientas estén instaladas y funcionando.
No instala nada, solo reporta el estado.

## Comandos

### Verificación rápida
```
make check
```

### Ver diferencias entre estado actual y declarado
```
make ai-diff
```

### Estado de dotfiles (archivos modificados localmente)
```
make status
```

### Estado completo en formato legible por IA
```
make ai-status
```

## Qué verifica make check
- chezmoi status (dotfiles aplicados y sin conflictos)
- Homebrew instalado
- Shell tools: zsh, chezmoi, starship, zoxide, atuin, lsd, fzf
- Dev environments: node, fnm, python, pyenv, go, java, ruby, rust

## Salida esperada en entorno sano
```
=== DOTFILES ===
  (sin cambios pendientes)

=== BREW ===
  ✓ Homebrew instalado — N fórmulas

=== SHELL TOOLS ===
  ✓ zsh: ...
  ✓ chezmoi: ...
  ...

=== RESUMEN ===
  ✓ Todo OK
```

## Regenerar inventario completo
```
bash ~/dotfiles/scripts/inventory.sh
```
