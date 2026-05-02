# SKILL: install — Setup completo de la máquina

## Qué hace
Ejecuta el setup completo: instala chezmoi, aplica dotfiles, instala apps con
Homebrew y configura macOS defaults.

## Cuándo usarlo
- Máquina nueva desde cero
- Después de reinstalar macOS
- Cuando se quiere sincronizar todo el entorno

## Prerequisito
Repo dotfiles clonado en ~/dotfiles/

## Comando
```
make install
```

## Es idempotente: SÍ
Puede correrse múltiples veces. Instala lo que falta, no reinstala lo existente.
chezmoi muestra diff ante conflictos.

## Verifica con
```
make check
```

## Tiempo estimado
15-30 min en máquina nueva (descarga de apps).
2-3 min en máquina ya configurada.
