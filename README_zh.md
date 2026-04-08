# ❄️ Jaanai-Liu 的 NixOS 配置

[![English](https://img.shields.io/badge/Language-English-blue.svg?style=flat-square)](README.md)

---

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</p>

> [!NOTE]
> 本仓库包含了我个人的模块化 NixOS 配置（基于 **Niri**、**home-manager** 和 **Agenix**）。整个架构由我独立构建并完成模块化，深度参考了 [Ryan's NixOS & Flakes Book](https://github.com/ryan4yin/nixos-and-flakes-book) 及其 [个人配置文件](https://github.com/ryan4yin/nix-config)。

## 💻 硬件概览

| 主机名 | 类型 | 处理器 | 显卡 | 状态 |
| :--- | :--- | :--- | :--- | :--- |
| **`lz-pc`** | 台式机 | Intel i5-12400F | AMD Radeon 9060XT | ✅ 已配置 |
| **`lz-laptop`** | 笔记本 | AMD Ryzen 7 7840HS (联想) | 核显 | 🚧 待配置 |

## 🧩 系统组件

系统全局主题统一采用 **Catppuccin Macchiato** 配色方案。

| 类别 | 软件方案 / 配置 |
| :--- | :--- |
| **窗口管理器** | [Niri](https://github.com/YaLTeR/niri) (基于 Wayland 的滚动平铺管理器) |
| **状态栏与 Shell** | [noctalia-shell](https://github.com/noctalia-dev/noctalia-shell) |
| **终端模拟器** | [Kitty](https://github.com/kovidgoyal/kitty) |
| **编辑器** | [Neovim](https://github.com/neovim/neovim) + [VSCode](https://code.visualstudio.com/) + [Vim](https://www.vim.org/) |
| **Shell 环境** | [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) |
| **输入法** | [Fcitx5](https://github.com/fcitx/fcitx5) + [Rime](https://rime.im/) (小狼毫) |
| **文件管理器** | [Yazi](https://github.com/sxyazi/yazi) + [nnn](https://github.com/jarun/nnn) |
| **休眠与锁屏** | [hypridle](https://github.com/hyprwm/hypridle) + [swaylock-effects](https://github.com/mortie/swaylock-effects) |
| **办公笔记** | [Obsidian](https://obsidian.md/) + [WPS Office](https://www.wps.cn/) |
| **密钥管理** | [Agenix](https://github.com/ryantm/agenix) |

🎨 **壁纸收藏**: [我的壁纸库](https://github.com/Jaanai-Liu/nix-config/tree/main/wallpapers)

---

## 🚀 如何部署？

### ⚠️ 重要提示

*   **请勿直接在你的机器上部署此配置。**
    本仓库包含特定硬件的微码（如 i5-12400F）和驱动配置（如 AMD 显卡），以及通过 Agenix 加密的私密信息，直接运行会导致失败。
*   **部署前置要求**：
    在应用配置前，请务必根据你的显示器实际情况，修改 `hosts` 目录下对应主机配置中的 `niri/output.kdl` 文件。

### 部署命令

根据主机名（如 `lz-pc`）应用配置：

```bash
sudo nixos-rebuild switch --flake .#lz-pc
```
