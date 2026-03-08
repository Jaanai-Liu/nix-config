# ❄️ Jaanai-Liu's NixOS Config

[![简体中文](https://img.shields.io/badge/语言-简体中文-fed.svg?style=flat-square)](README_zh.md)

---

<p align="center">
<img src="[https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png](https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png)" width="400" />
</p>


> [!NOTE]
> This repository contains my personal, modularized NixOS configurations built with **Niri**, **Home-manager**, and **Agenix**. It is heavily inspired by [Ryan's NixOS & Flakes Book](https://github.com/ryan4yin/nixos-and-flakes-book) and his [personal dotfiles](https://github.com/ryan4yin/nix-config).

## 💻 Hardware Overview

| Host | Type | Specifications | Status |
| --- | --- | --- | --- |
| **`lz-pc`** | Desktop | Intel i5-12400F | AMD Radeon GPU |
| **`lz-laptop`** | Laptop | AMD Ryzen 7 7840HS | *Work in Progress* |

## 🧩 Software Stack

I use the **Catppuccin Macchiato** color palette across most applications for a consistent, aesthetic experience.

| Category | Component |
| --- | --- |
| **Window Manager** | [Niri](https://github.com/YaLTeR/niri) (Scrollable Tiling Wayland Compositor) |
| **Status Bar/Shell** | [Noctalia-shell](https://github.com/noctalia-dev/noctalia-shell) |
| **Terminal** | [Kitty](https://github.com/kovidgoyal/kitty) |
| **Editor** | [Neovim](https://github.com/neovim/neovim) + [VS Code](https://code.visualstudio.com/) + [Vim](https://www.vim.org/) |
| **Shell** | [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) Prompt |
| **Input Method** | [Fcitx5](https://github.com/fcitx/fcitx5) with [Rime](https://rime.im/) |
| **File Manager** | [Yazi](https://github.com/sxyazi/yazi) & [nnn](https://github.com/jarun/nnn) |
| **Power/Idle** | [Hypridle](https://github.com/hyprwm/hypridle) + [Swaylock-effects](https://github.com/mortie/swaylock-effects) |
| **Productivity** | [Obsidian](https://obsidian.md/) & [WPS Office](https://www.wps.cn/) |
| **Secrets** | [Agenix](https://github.com/ryantm/agenix) |

---

## 🚀 Deployment

### ⚠️ Critical Warnings

* **Do not deploy this flake directly.** It contains hardware-specific configurations (CPU microcode, GPU drivers) and encrypted secrets managed by Agenix that require my private keys.
* **Pre-deployment requirement**: You **must** modify the `output.kdl` configuration within the Niri host directory to match your specific monitor setup before switching.

### Command

To deploy or update the configuration for the desktop host:

```bash
sudo nixos-rebuild switch --flake .#lz-pc

```

## 📁 Repository Structure

* `hosts/`: Machine-specific configurations and hardware definitions.
* `modules/`: Reusable NixOS and Home-manager modules.
* `secrets/`: Encrypted system secrets (Wi-Fi passwords, API keys, etc.).
* `wallpapers/`: My curated [wallpaper collection](https://github.com/Jaanai-Liu/nixos-config/tree/main/wallpapers).

---

**Maintained by Jaanai-Liu** *Looking forward to the next chapter in Shanghai.*

---
