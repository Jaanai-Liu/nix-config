---
author: Jaanai Liu
pubDatetime: 2025-04-19T16:00:00Z
modDatetime: 2025-04-19T16:00:00Z
title: Assetto Corsa Linux Setup — NixOS 环境一键部署
slug: assetto-corsa-linux-setup
featured: false
draft: false
tags:
  - nixos
  - gaming
  - proton
description: 在 NixOS 环境下一键部署神力科莎 (Assetto Corsa)，含 Proton 兼容层、Content Manager 和 CSP 配置。
---

在 NixOS 环境下一键部署神力科莎 (Assetto Corsa)，包含 Proton 兼容层、Content Manager 和 Custom Shaders Patch。

## 技术栈

- **Proton**: Valve 的 Wine 兼容层，用于在 Linux 上运行 Windows 游戏
- **Content Manager**: Assetto Corsa 的第三方启动器和管理工具
- **CSP (Custom Shaders Patch)**: 图形增强模组

## 安装

使用 Nix 声明式环境，确保游戏及其依赖项可复现部署。

[查看项目](https://github.com/Jaanai-Liu/nix-config)
