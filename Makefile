# dotfiles — Setup Manager
# Uso: make help
#
# Arquitectura: chezmoi (dotfiles) + Homebrew/apt (apps) + scripts (sistema)
# Plataformas: macOS · Linux · WSL

.PHONY: help install bootstrap link apps defaults update diff status check \
        dump-brew ai-status ai-diff ai-verify

OS     := $(shell uname -s)
DOTDIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

GREEN  := \033[0;32m
YELLOW := \033[0;33m
RED    := \033[0;31m
NC     := \033[0m

help: ## Muestra este mensaje
	@echo ""
	@echo "  dotfiles — Setup Manager"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-18s$(NC) %s\n", $$1, $$2}'
	@echo ""

install: bootstrap link apps defaults ## Setup completo de la máquina
	@echo "$(GREEN)✓ Setup completo$(NC)"

bootstrap: ## Instala chezmoi y dependencias base
	@echo "→ Bootstrap..."
ifeq ($(OS),Darwin)
	@bash $(DOTDIR)/install/macos.sh bootstrap
else
	@bash $(DOTDIR)/install/linux.sh bootstrap
endif

link: ## Aplica dotfiles via chezmoi
	@echo "→ Aplicando dotfiles..."
	@chezmoi apply --source $(DOTDIR)/home --init

apps: ## Instala apps para el OS actual
	@echo "→ Instalando apps..."
ifeq ($(OS),Darwin)
	@brew bundle install --file=$(DOTDIR)/packages/Brewfile
else
	@xargs sudo apt-get install -y < $(DOTDIR)/packages/apt.txt
endif

defaults: ## Aplica configuraciones del sistema (solo macOS)
ifeq ($(OS),Darwin)
	@echo "→ Aplicando macOS defaults..."
	@bash $(DOTDIR)/system/macos/defaults.sh
endif

update: ## Actualiza packages y re-aplica dotfiles
	@chezmoi update --source $(DOTDIR)/home
ifeq ($(OS),Darwin)
	@brew upgrade
	@brew bundle --file=$(DOTDIR)/packages/Brewfile
endif

diff: ## Muestra cambios pendientes en dotfiles (sin aplicar)
	@chezmoi diff --source $(DOTDIR)/home

status: ## Estado de chezmoi (archivos modificados)
	@chezmoi status --source $(DOTDIR)/home

check: ## Verifica el estado del entorno (sin instalar nada)
	@bash $(DOTDIR)/scripts/verify.sh

vscode: ## Aplica settings y extensiones de VS Code
	@echo "→ Instalando extensiones..."
	@xargs -I {} code --install-extension {} < $(DOTDIR)/home/dot_config/vscode/extensions.txt
	@echo "→ Aplicando settings..."
	@cp $(DOTDIR)/home/dot_config/vscode/settings.json \
		"$(HOME)/Library/Application Support/Code/User/settings.json"
	@echo "$(GREEN)✓ VS Code configurado$(NC)"

vscode-dump: ## Captura settings y extensiones actuales de VS Code → dotfiles
	@echo "→ Sincronizando settings..."
	@cp "$(HOME)/Library/Application Support/Code/User/settings.json" \
		$(DOTDIR)/home/dot_config/vscode/settings.json
	@echo "→ Sincronizando extensiones..."
	@code --list-extensions | sort > $(DOTDIR)/home/dot_config/vscode/extensions.txt
	@echo "$(GREEN)✓ VS Code sincronizado$(NC)"
	@git -C $(DOTDIR) diff --stat home/dot_config/vscode/

dump-brew: ## Captura el estado actual de Homebrew → Brewfile
	@brew bundle dump --describe --force --file=$(DOTDIR)/packages/Brewfile
	@echo "$(GREEN)✓ Brewfile actualizado$(NC)"

ai-status: ## Estado completo del entorno en formato legible por IA
	@bash $(DOTDIR)/scripts/verify.sh

ai-diff: ## Diferencias entre entorno actual y declarado
	@bash $(DOTDIR)/scripts/diff-env.sh
