# HP DeskJet 2130 — NixOS 打印与扫描教程

> 适用：HP DeskJet 2130 系列 | 连接方式：USB 有线 | 系统：NixOS (flake)

---

## 中文版

### 1. NixOS 配置

在 `modules/desktop/peripherals.nix` 中加入以下内容（已配置则跳过）：

```nix
# ============================= Printer =============================
# Enable CUPS to print documents.
services.printing.enable = true;
# HP DeskJet 2130 (USB wired) — print + scan
services.printing.drivers = [ pkgs.hplip ];
hardware.sane = {
  enable = true;
  extraBackends = [ pkgs.hplip ];
};
```

应用配置：

```bash
sudo nixos-rebuild switch --flake .#lz-pc
```

### 2. 添加打印机（CUPS Web 界面）

1. 将打印机插上 USB 线并开机
2. 浏览器打开 **http://localhost:631**
3. 点击顶部 **Administration** → **Add Printer**
4. 如提示登录，输入系统用户名和密码（例如 `zheng`）
5. 在列表中找到 **HP DeskJet 2130 series (USB)**，选中 → **Continue**
6. Model/驱动选择（任选其一）：
   - **HP DeskJet 2130 Series, hpcups**（推荐）
   - 如果列表里没出现，说明 hplip 未正确安装，重新执行 `nixos-rebuild switch`
7. 点击 **Add Printer** → 设置默认选项（纸张大小建议选 A4）→ **Set Default Options**

### 3. 测试打印

```bash
# 查看打印机列表
lpstat -p -d

# 设置默认打印机（可选）
lpadmin -d HP_DeskJet_2130_series

# 发送测试页
lp -d HP_DeskJet_2130_series /etc/nixos/hardware-configuration.nix
```

### 4. 在 WPS 中打印

WPS 使用系统 CUPS 框架，因此 **不需要额外配置**。

1. 打开 WPS
2. `Ctrl+P` 调出打印对话框
3. 打印机下拉列表会自动出现已添加的 HP DeskJet 2130
4. 选择即可打印

### 5. 扫描

配置中已启用 SANE + hpaio 后端，推荐使用 `simple-scan` 扫描：

```bash
# 安装 simple-scan（如未安装）
nix shell nixpkgs#simple-scan --command simple-scan
# 或加入 home-manager / systemPackages
```

打开 `simple-scan`（应用菜单里叫"文档扫描器"），它会自动识别 HP 扫描仪。

常用扫描软件：
| 软件 | 包名 | 说明 |
|------|------|------|
| simple-scan | `pkgs.simple-scan` | GNOME 出品，上手最简单，推荐 |
| xsane | `pkgs.xsane` | 老牌扫描软件，功能全面 |
| scanimage | `pkgs.sane-backends` | 命令行扫描 |

### 6. 故障排查

```bash
# 查看 CUPS 是否正常
systemctl status cups

# 查看已连接打印机
lpstat -t

# 查看打印机支持的驱动
lpinfo -m | grep -i hp

# 查看 USB 设备是否被识别
lsusb | grep -i hp

# 扫描设备列表
scanimage -L

# 开启 CUPS 调试日志
cupsctl --debug-logging
journalctl -u cups --follow

# 关闭调试日志
cupsctl --no-debug-logging
```

---

## English Version

### 1. NixOS Configuration

Add the following to `modules/desktop/peripherals.nix` (skip if already present):

```nix
# ============================= Printer =============================
# Enable CUPS to print documents.
services.printing.enable = true;
# HP DeskJet 2130 (USB wired) — print + scan
services.printing.drivers = [ pkgs.hplip ];
hardware.sane = {
  enable = true;
  extraBackends = [ pkgs.hplip ];
};
```

Apply:

```bash
sudo nixos-rebuild switch --flake .#lz-pc
```

### 2. Add Printer (CUPS Web Interface)

1. Connect the printer via USB and power it on
2. Open **http://localhost:631** in a browser
3. Click **Administration** → **Add Printer**
4. If prompted, log in with your system username and password (e.g. `zheng`)
5. Select **HP DeskJet 2130 series (USB)** from the list → **Continue**
6. Choose a driver (pick one):
   - **HP DeskJet 2130 Series, hpcups** (recommended)
   - If the HP drivers are missing from the list, hplip was not installed properly — re-run `nixos-rebuild switch`
7. Click **Add Printer** → set defaults (A4 paper recommended) → **Set Default Options**

### 3. Test Printing

```bash
# List printers
lpstat -p -d

# Set as default printer (optional)
lpadmin -d HP_DeskJet_2130_series

# Send a test page
lp -d HP_DeskJet_2130_series /etc/nixos/hardware-configuration.nix
```

### 4. Printing from WPS

WPS uses the system CUPS framework — **no extra setup needed**.

1. Open WPS
2. Press `Ctrl+P` to open the print dialog
3. The HP DeskJet 2130 will appear in the printer dropdown
4. Select it and print

### 5. Scanning

SANE + hpaio backend is already enabled. The easiest option is `simple-scan`:

```bash
# Install & launch simple-scan
nix shell nixpkgs#simple-scan --command simple-scan
# Or add it to home-manager / systemPackages
```

Launch `simple-scan` ("Document Scanner" in the app menu) — it will auto-detect the HP scanner.

Available scanning software:
| App | Package | Notes |
|-----|---------|-------|
| simple-scan | `pkgs.simple-scan` | GNOME project, easiest to use, recommended |
| xsane | `pkgs.xsane` | Classic, feature-rich |
| scanimage | `pkgs.sane-backends` | CLI tool for scripting |

### 6. Troubleshooting

```bash
# Check CUPS status
systemctl status cups

# List all printers and their status
lpstat -t

# List available HP drivers
lpinfo -m | grep -i hp

# Check if USB device is detected
lsusb | grep -i hp

# List detected scanners
scanimage -L

# Enable CUPS debug logging
cupsctl --debug-logging
journalctl -u cups --follow

# Disable debug logging
cupsctl --no-debug-logging
```
