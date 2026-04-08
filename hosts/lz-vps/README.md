# NixOS Remote Takeover & VLESS-REALITY Proxy Setup Guide (Low-RAM VPS)

This guide outlines the process of replacing an existing Linux distribution (e.g., Ubuntu) with NixOS on a 1GB RAM VPS, and configuring it as a highly secure VLESS-REALITY proxy server using Sing-box.

## I. Pre-Installation: Check Disk & NixOS Settings

Before initiating the takeover, verify the target server's storage device name and boot mode.

1. **Check Default Partition Layout**
   SSH into your existing Ubuntu server:

   ```bash
   ssh root@your_server_ip
   lsblk       # Check the primary disk name (usually /dev/vda or /dev/sda)
   fdisk -l /dev/vda # Check if it's BIOS or UEFI
   ```

2. **Update NixOS Configuration Locally**
   In your `disk-config.nix`, ensure the device name matches:
   ```nix
   device = "/dev/vda";
   ```
   In your `default.nix`, ensure GRUB targets the correct disk:
   ```nix
   boot.loader.grub.device = "/dev/vda";
   ```

## II. The Takeover (Deploying NixOS)

1. **Add Temporary Swap Space (Crucial for 1GB RAM)**
   On the Ubuntu server, run:

   ```bash
   fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && ufw disable; exit
   ```

2. **Execute Deployment from Local PC**
   Clear the old SSH fingerprint and run `nixos-anywhere` with low-RAM optimizations:

   ```bash
   ssh-keygen -R your_server_ip
   export SSHPASS='your_current_ubuntu_password'

   nix run github:nix-community/nixos-anywhere -- \
     --build-on local \
     --env-password \
     --flake .#your-flake-hostname \
     --no-disko-deps \
     --ssh-option ConnectTimeout=100 \
     --ssh-option ServerAliveInterval=5 \
     root@your_server_ip
   ```

## III. Post-Install: Setting Up VLESS-REALITY Proxy

Once NixOS is installed and rebooted, your server is ready. Now we configure the proxy.

1. **Generate Security Keys Locally**
   Run these commands on your local PC terminal and save the output:

   ```bash
   # 1. Generate UUID
   nix run nixpkgs#sing-box -- generate uuid
   # 2. Generate REALITY Keypair (Public & Private keys)
   nix run nixpkgs#sing-box -- generate reality-keypair
   # 3. Generate Short ID
   nix run nixpkgs#sing-box -- generate rand --hex 8
   ```

2. **Update your `default.nix`**
   Add the following Sing-box configuration to your NixOS config file, replacing the placeholders with the keys you just generated:

   ```nix
     # Open firewall port
     networking.firewall.allowedTCPPorts = [ 443 ];
     networking.firewall.allowedUDPPorts = [ 443 ];

     # Sing-box Service
     services.sing-box = {
       enable = true;
       settings = {
         inbounds = [{
           type = "vless";
           tag = "vless-in";
           listen = "::";
           listen_port = 443;
           users = [{
             uuid = "YOUR_UUID_HERE";
             flow = "xtls-rprx-vision";
           }];
           tls = {
             enabled = true;
             server_name = "www.microsoft.com";
             reality = {
               enabled = true;
               handshake = {
                 server = "www.microsoft.com";
                 server_port = 443;
               };
               private_key = "YOUR_PRIVATE_KEY_HERE";
               short_id = [ "YOUR_SHORT_ID_HERE" ];
             };
           };
         }];
         outbounds = [{ type = "direct"; tag = "direct"; }];
       };
     };
   ```

3. **Deploy the Proxy Configuration**
   Push the changes to your server:
   ```bash
   git add .
   nixos-rebuild switch --flake .#your-flake-hostname --target-host root@your_server_ip --build-host localhost
   ```

## IV. Connecting Your Devices

Your proxy server is now running! Create your connection link by replacing the bracketed info below:

```text
vless://[YOUR_UUID]@[YOUR_SERVER_IP]:443?encryption=none&flow=xtls-rprx-vision&security=reality&sni=www.microsoft.com&fp=chrome&pbk=[YOUR_PUBLIC_KEY]&sid=[YOUR_SHORT_ID]&type=tcp&headerType=none#My-NixOS-Proxy
```

```
# 1. 代理节点定义 (对应你的 Sing-box 服务器端配置)
proxies:
  - name: "NixOS-VLESS-Reality"
    type: vless
    server: "你的服务器IP"      # 填入你的 VPS IP
    port: 443
    uuid: "你的UUID"            # 填入生成的 UUID
    network: tcp
    tls: true
    udp: true
    flow: xtls-rprx-vision
    servername: "www.microsoft.com" # 必须与服务器端 handshake.server 保持一致
    client-fingerprint: chrome      # 伪装客户端指纹
    reality-opts:
      public-key: "你的PublicKey"   # 注意：这里必须填 公钥 (Public Key)！
      short-id: "你的Short_ID"      # 填入生成的 8位/16位 Short ID

# 2. 策略组定义 (控制面板里的切换按钮)
proxy-groups:
  - name: "🚀 节点选择"
    type: select
    proxies:
      - "NixOS-VLESS-Reality"
      - DIRECT

  - name: "🎯 漏网之鱼"
    type: select
    proxies:
      - "🚀 节点选择"
      - DIRECT

# 3. 极简分流规则 (默认所有流量走代理，国内流量建议后续添加 GeoIP 规则)
rules:
  - MATCH,🚀 节点选择
```

- **Android**: Download **v2rayNG** (arm64 version). Copy the complete `vless://` link above, open the app, tap the `+` icon, and select **"Import profile from clipboard"**. Tap the V icon to connect.
- **PC**: Open **Clash Verge Rev** or **NekoBox**, copy the link, and paste/import from clipboard to start routing your traffic.

---

# NixOS 远程夺舍与 VLESS-REALITY 代理配置全指南 (低内存 VPS)

本指南涵盖了在 1GB 内存的 VPS 上，使用 `nixos-anywhere` 将原系统（如 Ubuntu）替换为 NixOS 的全过程，并手把手教你将其配置为高隐蔽性的 VLESS-REALITY 科学上网节点。

## I. 部署前准备：检查磁盘与配置

在开始夺舍前，必须核实目标服务器的硬盘名称。

1. **检查默认分区布局**
   SSH 登录到现有的 Ubuntu 服务器：

   ```bash
   ssh root@你的服务器IP
   lsblk       # 查看主硬盘名称（通常是 /dev/vda 或 /dev/sda）
   fdisk -l /dev/vda # 查看是 BIOS 还是 UEFI 启动
   ```

2. **在本地更新 NixOS 配置**
   在你的 `disk-config.nix` 中，确保设备名匹配：
   ```nix
   device = "/dev/vda";
   ```
   在 `default.nix` 中，确保 GRUB 指向正确的硬盘：
   ```nix
   boot.loader.grub.device = "/dev/vda";
   ```

## II. 开始夺舍（部署 NixOS）

1. **临时挂载 Swap（1GB 内存保命必做）**
   在 Ubuntu 服务器内执行，防止内核切换时内存溢出：

   ```bash
   fallocate -l 2G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && ufw disable; exit
   ```

2. **从本地发起终极部署**
   清理旧指纹，并使用低内存优化参数运行 `nixos-anywhere`：

   ```bash
   ssh-keygen -R 你的服务器IP
   export SSHPASS='你当前的Ubuntu密码'

   nix run github:nix-community/nixos-anywhere -- \
     --build-on local \
     --env-password \
     --flake .#你的flake主机名 \
     --no-disko-deps \
     --ssh-option ConnectTimeout=100 \
     --ssh-option ServerAliveInterval=5 \
     root@你的服务器IP
   ```

   _注：`--no-disko-deps` 极其关键，它能避免向 VPS 内存中塞入庞大的分区依赖包，解决卡死问题。_

## III. 夺舍后：配置 VLESS-REALITY 代理服务

安装完成并重启后，你的 VPS 已成为纯正的 NixOS。接下来配置代理。

1. **在本地生成专属安全密钥**
   在你本地电脑的终端执行以下命令，并将输出结果记录下来：

   ```bash
   # 1. 生成 UUID
   nix run nixpkgs#sing-box -- generate uuid
   # 2. 生成 REALITY 公私钥 (会输出 PrivateKey 和 PublicKey)
   nix run nixpkgs#sing-box -- generate reality-keypair
   # 3. 生成 16位 Short ID
   nix run nixpkgs#sing-box -- generate rand --hex 8
   ```

2. **修改 `default.nix` 注入代理配置**
   将以下 Sing-box 服务代码添加到你的 `default.nix` 中，把刚才生成的密钥填入对应位置：

   ```nix
     # 放行 443 端口
     networking.firewall.allowedTCPPorts = [ 443 ];
     networking.firewall.allowedUDPPorts = [ 443 ];

     # 启用 Sing-box 服务
     services.sing-box = {
       enable = true;
       settings = {
         inbounds = [{
           type = "vless";
           tag = "vless-in";
           listen = "::";
           listen_port = 443;
           users = [{
             uuid = "填入你生成的_UUID";
             flow = "xtls-rprx-vision";
           }];
           tls = {
             enabled = true;
             server_name = "www.microsoft.com";
             reality = {
               enabled = true;
               handshake = {
                 server = "www.microsoft.com";
                 server_port = 443;
               };
               private_key = "填入你生成的_PrivateKey";
               short_id = [ "填入你生成的_Short_ID" ];
             };
           };
         }];
         outbounds = [{ type = "direct"; tag = "direct"; }];
       };
     };
   ```

3. **推送并激活配置**
   在本地终端执行重构命令，将配置无缝推送到洛杉矶的服务器并自动启动服务：
   ```bash
   git add .
   nixos-rebuild switch --flake .#你的flake主机名 --target-host root@你的服务器IP --build-host localhost
   ```

## IV. 客户端连接测试

服务器端已就绪！现在，我们需要把各项参数拼装成一个标准的 `vless://` 链接。
请复制下方链接，并替换方括号 `[]` 内的内容（替换时去掉方括号）：

```text
vless://[你的UUID]@[服务器IP]:443?encryption=none&flow=xtls-rprx-vision&security=reality&sni=www.microsoft.com&fp=chrome&pbk=[你的PublicKey]&sid=[你的Short_ID]&type=tcp&headerType=none#RackNerd-VPS
```

```
# 1. 代理节点定义 (对应你的 Sing-box 服务器端配置)
proxies:
  - name: "NixOS-VLESS-Reality"
    type: vless
    server: "你的服务器IP"      # 填入你的 VPS IP
    port: 443
    uuid: "你的UUID"            # 填入生成的 UUID
    network: tcp
    tls: true
    udp: true
    flow: xtls-rprx-vision
    servername: "www.microsoft.com" # 必须与服务器端 handshake.server 保持一致
    client-fingerprint: chrome      # 伪装客户端指纹
    reality-opts:
      public-key: "你的PublicKey"   # 注意：这里必须填 公钥 (Public Key)！
      short-id: "你的Short_ID"      # 填入生成的 8位/16位 Short ID

# 2. 策略组定义 (控制面板里的切换按钮)
proxy-groups:
  - name: "🚀 节点选择"
    type: select
    proxies:
      - "NixOS-VLESS-Reality"
      - DIRECT

  - name: "🎯 漏网之鱼"
    type: select
    proxies:
      - "🚀 节点选择"
      - DIRECT

# 3. 极简分流规则 (默认所有流量走代理，国内流量建议后续添加 GeoIP 规则)
rules:
  - MATCH,🚀 节点选择
```

- **手机端 (安卓)**：推荐使用 **v2rayNG**（下载 arm64 版本）。在手机上完整复制上方拼接好的链接，打开软件，点击右上角 `+` 号，选择**“从剪贴板导入”**，然后点击右下角的 V 字圆形按钮即可起飞。
- **电脑端**：使用 **Clash Verge Rev** 或 **NekoBox**，直接选择“新建”并“从剪贴板导入”（Import from Clipboard）即可连接。
