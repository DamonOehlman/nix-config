# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a comprehensive NixOS and nix-darwin configuration repository using Nix Flakes to manage system and user configurations across multiple machines and platforms (Linux and macOS). The repository supports both NixOS systems and macOS systems via nix-darwin, with Home Manager handling user-specific configurations.

## Architecture

The configuration is structured with three main layers:

1. **System Layer** (`hosts/`): Machine-specific NixOS and nix-darwin configurations
2. **User Layer** (`home/`): User-specific Home Manager configurations  
3. **Shared Modules** (`hosts/modules/` and `home/modules/`): Reusable configuration modules

### Key Files and Structure

- `flake.nix`: Main flake definition with inputs, outputs, and helper functions
- `hosts/`: System configurations organized by hostname
  - `hosts/modules/`: Shared system modules (common.nix, desktop environments, etc.)
  - `hosts/darwin/`: macOS-specific system configurations
- `home/`: Home Manager configurations organized by user/hostname
  - `home/modules/`: Shared user modules (applications, shell configs, etc.)
- `files/`: Static configuration files, scripts, and assets
- `overlays/`: Custom Nix package overlays

### Configuration Functions

The flake defines helper functions for creating configurations:

- `mkNixosConfiguration`: Creates NixOS system configurations
- `mkDarwinConfiguration`: Creates nix-darwin system configurations  
- `mkHomeConfiguration`: Creates Home Manager user configurations

## Common Commands

### Building and Switching Configurations

**NixOS systems:**
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

**macOS systems:**
```bash
darwin-rebuild switch --flake .#<hostname>
```

**Home Manager configurations:**
```bash
home-manager switch --flake .#<username>@<hostname>
```

### Bootstrap Commands (macOS)

The Makefile provides bootstrap commands for setting up new macOS machines:

```bash
make bootstrap-mac        # Full bootstrap (install Nix + nix-darwin)
make install-nix         # Install Nix package manager
make install-nix-darwin  # Install nix-darwin
make darwin-rebuild      # Rebuild darwin configuration
```

### Flake Management

```bash
nix flake update          # Update all flake inputs
nix flake show           # Show flake outputs
nix flake check          # Check flake for errors
```

## Supported Platforms and Machines

**Current NixOS configurations:**
- `energy` (nabokikh user)
- `nabokikh-z13` (nabokikh user)  
- `djo-steamdeck` (damo user)
- `djo-x270` (damo user)

**Current nix-darwin configurations:**
- `defrag-mini` (damo user)
- `defrag-air` (damo user)
- `djo-affectable` (damo user)

## Module System

### System Modules (`hosts/modules/`)

- `common.nix`: Base system packages and configuration
- `common-linux.nix` / `common-darwin.nix`: Platform-specific common configs
- `common-heavy.nix`: Resource-intensive applications
- Desktop environments: `gnome.nix`, `hyprland.nix`
- Gaming: `steam.nix`, `lutris.nix`
- Hardware: `laptop.nix`, `corectrl.nix`
- Services: `ollama.nix`

### Home Manager Modules (`home/modules/`)

**Core modules:**
- `common.nix`: Default user applications and configurations
- `home.nix`: Basic Home Manager setup

**Development tools:**
- `git.nix`, `neovim.nix`, `vscode.nix`, `zeditor.nix`
- `lang-*.nix`: Language-specific tooling (node, rust, deno, go)
- `lazygit.nix`: Git TUI

**Terminal and shell:**
- `zsh.nix`, `tmux.nix`, `alacritty.nix`, `kitty.nix`
- `fzf.nix`, `bat.nix`, `btop.nix`

**Desktop environment:**
- `hyprland.nix`, `gnome.nix`, `waybar.nix`
- `gtk.nix`, `catppuccin.nix` (theming)

## Adding New Machines

1. Update `flake.nix` to add user config if needed
2. Add machine to appropriate `*Configurations` section in flake.nix
3. Create system configuration in `hosts/<hostname>/` or `hosts/darwin/<hostname>/`
4. Create Home Manager config in `home/<username>/<hostname>.nix`
5. Add files with `git add .` before building
6. Build and switch to new configuration

## Important Notes

- Always add new files to git before building configurations
- The repository uses both stable and unstable nixpkgs channels
- Catppuccin theme is available globally via the catppuccin flake input
- Custom scripts are managed in `files/scripts/` and enabled via `scripts.nix`
- Configuration files for applications are stored in `files/configs/`