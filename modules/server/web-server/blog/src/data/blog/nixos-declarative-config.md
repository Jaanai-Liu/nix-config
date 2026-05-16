---
author: Jaanai Liu
pubDatetime: 2025-04-19T12:00:00Z
modDatetime: 2025-04-19T12:00:00Z
title: 我的 NixOS 声明式系统配置
slug: nixos-declarative-config
featured: true
draft: false
tags:
  - nixos
  - dotfiles
  - nix
description: 基于 Niri 窗口管理器、Home-manager 及 Agenix 的个人模块化 NixOS 配置仓库介绍。
---

包含了我的个人模块化 NixOS 配置文件。基于 Niri 窗口管理器、Home-manager 以及 Agenix 进行构建。

## 核心软件栈

- **窗口管理器 (WM):** Niri (滚动平铺 Wayland 合成器)
- **密钥管理:** Agenix (保护 Wi-Fi 密码与 API keys)

> ⚠️ 请勿直接部署此 Flake。它包含需要我私钥才能解密的 Agenix 密钥。

[访问 GitHub 仓库源码](https://github.com/Jaanai-Liu/nix-config)
