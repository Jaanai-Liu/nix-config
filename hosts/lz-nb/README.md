# lz-nb — Jaanai 的笔记本

AMD Ryzen 7 7840HS / Radeon 780M / 14" 2K 16:10

## 从台式机刷 NixOS 到笔记本

以下流程从 `lz-pc` 通过 nixos-anywhere 远程安装 NixOS 到 `lz-nb`，会清空笔记本上原有的 Windows 系统。

### 0. 准备工作

- [ ] 备份笔记本上的重要数据
- [ ] 一个空闲 U 盘（≥4G），用于制作 NixOS 启动盘
- [ ] 笔记本和台式机在同一局域网（或通过 Easytier 互联）

### 1. 制作 NixOS 启动 U 盘

```bash
# 下载 NixOS 安装 ISO
wget https://mirror.nju.edu.cn/nixos/latest-iso/nixos-25.11.20250504.80e6e92-x86_64-linux.iso

# 写入 U 盘（假设 U 盘为 /dev/sdX，用 lsblk 确认）
sudo dd if=nixos-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

> 如果 GitHub 网络不好，可以用 ghproxy 加速下载 kexec 镜像，见下方步骤 3。

### 2. 启动笔记本进入安装环境

1. 插入 U 盘，笔记本开机按 `F2`/`F12`/`Del`（视机型）进入 BIOS
2. 关闭 Secure Boot
3. 设置 U 盘为第一启动项，保存重启
4. 进入 NixOS 安装环境后，设置密码开启 SSH：

```bash
# 在笔记本上执行
sudo -i
passwd root    # 设置一个临时密码，用于 SSH 登录
ip a           # 查看笔记本 IP 地址，记下来
```

### 3. 从台式机执行远程安装

NixOS ISO 自带 SSH，但可能需要手动 `systemctl start sshd`

```bash
# 如果因网络问题无法从 GitHub 拉取 kexec 镜像，可先用 ghproxy 下载
curl -L https://mirror.ghproxy.com/https://github.com/nix-community/nixos-images/releases/download/nixos-25.05/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz \
  -o nixos-kexec.tar.gz
```

两种方式执行 nixos-anywhere：

**方式 A — 标准 kexec（网络好的情况下）**

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#lz-nb \
  root@<NB_IP>
```

**方式 B — 手动 kexec（国内网络，夺舍法）**

```bash
# 1. 先手动上传 kexec 到笔记本
scp nixos-kexec.tar.gz root@<NB_IP>:/root/

# 2. SSH 到笔记本，手动 kexec
ssh root@<NB_IP>
tar -xzf nixos-kexec.tar.gz -C /root/
/root/kexec/run

# 3. 等待笔记本重启进入 kexec 环境后，从台式机执行安装
nix run github:nix-community/nixos-anywhere -- \
  --phases kexec \
  --flake .#lz-nb \
  root@<NB_IP>
```

> `--phases kexec` 跳过 kexec 阶段，因为已经手动完成。

### 4. 安装完成后

笔记本会自动重启进入新系统。

#### 4.1 生成准确的硬件配置

```bash
# 在笔记本上执行
sudo nixos-generate-config --show-hardware-config
```

将输出的内容替换 `hosts/lz-nb/hardware-configuration.nix` 中对应的硬件部分。

#### 4.2 重新部署

```bash
# 在台式机上
cd ~/nix-config
git add -A && git commit -m "Update lz-nb hardware config"
colmena apply --on lz-nb boot

# 笔记本重启使更新生效
ssh root@<NB_IP> reboot
```

### 5. 后续维护

日常更新和台式机一样：

```bash
colmena apply --on lz-nb boot
```

如果在笔记本本地，也可以直接：

```bash
sudo nixos-rebuild switch --flake .#lz-nb
```

### 注意事项

- **Secure Boot**：当前配置使用 systemd-boot，安装前需在 BIOS 关闭 Secure Boot
- **磁盘设备名**：`disk-config.nix` 默认使用 `/dev/nvme0n1`，如果笔记本磁盘设备名不同，安装前修改
- **首次部署**：`preservation.nix` 依赖 `/persistent`，首次部署后部分持久化目录需要手动创建或重启后自动生成
