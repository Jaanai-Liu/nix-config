---
author: Jaanai Liu
pubDatetime: 2025-04-19T10:00:00Z
modDatetime: 2025-04-19T10:00:00Z
title: 低内存 VPS 上 NixOS Anywhere 安装指南
slug: nixos-anywhere-install-guide
featured: true
draft: false
tags:
  - nixos
  - vps
  - tutorial
description: 针对低内存及网络受限 VPS 的 NixOS Anywhere 安装指南，含标准 kexec 流程与国内网络环境手动夺舍方案。
---

本指南提供了一套针对低内存 VPS 及连接 GitHub 网络较差机器的 NixOS 完美工作流。

## 方法一：标准 kexec 流程

```bash
ssh-keygen -R <YOUR_VPS_IP>
```

```bash
nix run github:nix-community/nixos-anywhere -- --phases kexec --flake .#<YOUR_FLAKE_HOST> root@<YOUR_VPS_IP> --no-substitute-on-destination
```

## 方法二：手动 kexec 流程 (夺舍)

适用于国内服务器等网络受限环境。

```bash
curl -L https://mirror.ghproxy.com/https://github.com/nix-community/nixos-images/releases/download/nixos-25.05/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz -o nixos-kexec.tar.gz
```

> 关键技巧：使用 `ghproxy.com` 镜像加速 GitHub 下载，解决国内网络问题。
