# NixOS-Anywhere Installation Guide for Low-RAM VPS (ZRAM Method)

This guide provides a bulletproof workflow for installing NixOS on low-memory Virtual Private Servers (VPS), such as those with only 1GB of RAM. Standard `nixos-anywhere` installations often fail on such machines due to Out-Of-Memory (OOM) errors or garbage collection (GC) loops when transferring the system closure.

This workflow solves the issue by splitting the installation into phases, utilizing local computation, and creating a temporary ZRAM swap space in the Live environment.

## Step 1: Preparation & SSH Key Management

Before beginning, ensure your local machine has SSH access to the target VPS. If you are reusing an IP address from a previous server, your local SSH client will likely reject the connection due to a host key mismatch.

**Clear the old SSH record:**

```bash
ssh-keygen -R <YOUR_VPS_IP>
```

_Explanation:_ This command removes the old cryptographic fingerprint associated with the IP address from your `~/.ssh/known_hosts` file, preventing the `REMOTE HOST IDENTIFICATION HAS CHANGED` error. Ensure your local public key is authorized on the target VPS's `root` user.

## Step 2: Inject NixOS Memory System (kexec phase)

The first step is to replace the existing operating system (e.g., Ubuntu/Debian) with a minimal NixOS Live environment running entirely in the server's RAM.

**Execute on your local machine:**

```bash
nix run github:nix-community/nixos-anywhere -- --phases kexec --flake .#<YOUR_FLAKE_HOST> root@<YOUR_VPS_IP> --no-substitute-on-destination
```

_Explanation:_ * `--phases kexec`: Instructs the tool to *only\* load the in-memory OS and stop. It will not format disks yet.

- `--no-substitute-on-destination`: **CRITICAL for low RAM.** Forces your local machine to evaluate and build the dependencies, pushing only raw binaries to the VPS. Without this, the VPS will try to resolve dependencies and instantly run out of memory.
- _Note:_ The connection will drop automatically when the kexec is triggered. Wait 1-2 minutes for the VPS to reboot into the NixOS memory environment.

## Step 3: Enable ZRAM Extreme Expansion

Now that the VPS is running the NixOS Live environment, we must expand its capacity to receive the full system closure without crashing.

**Connect to the VPS:**

```bash
ssh root@<YOUR_VPS_IP>
```

_(If you get a host key warning again, run `ssh-keygen -R <YOUR_VPS_IP>` locally, as the OS has changed)._

**Execute the following commands line by line on the VPS:**

```bash
# 1. Expand the temporary Nix store limit
mount -o remount,size=2G /nix/.rw-store

# 2. Load the ZRAM module and configure compression
modprobe zram
echo zstd > /sys/block/zram0/comp_algorithm
echo 1500M > /sys/block/zram0/disksize

# 3. Initialize and activate the ZRAM virtual Swap
mkswap /dev/zram0
swapon /dev/zram0

# 4. Disconnect to prepare for final installation
exit
```

_Explanation:_ The default `/nix/.rw-store` is only ~500MB, which cannot hold a full system closure. We force it to 2GB, and then create 1.5GB of highly compressed memory (ZRAM) to act as a safety buffer. This prevents the Nix garbage collector from entering an infinite loop when the temporary storage fills up.

## Step 4: Execute Disk Formatting and Installation

With the server's memory fortified, you can safely push the final system.

**Execute on your local machine:**

```bash
nix run github:nix-community/nixos-anywhere -- --phases disko,install --flake .#<YOUR_FLAKE_HOST> root@<YOUR_VPS_IP> --no-substitute-on-destination
```

_Explanation:_

- `--phases disko,install`: Resumes the process. It will first execute your `disko` configuration (partitioning and formatting the hard drive, e.g., to BTRFS), and then copy the system closure from your local machine to the newly formatted drive.
- Once the process outputs `### Done! ###`, the server will automatically reboot into your newly installed NixOS.

---

# 低内存 VPS 上 NixOS Anywhere 安装指南 (ZRAM 方案)

本指南提供了一套针对低内存 VPS（如 1GB 内存）安装 NixOS 的完美工作流。在低配机器上直接运行 `nixos-anywhere` 通常会因为内存耗尽 (OOM) 或触发垃圾回收 (GC) 死循环而导致传输失败。

本方案通过分步执行、利用本地算力代工，以及在内存系统中开启 ZRAM 虚拟内存，完美解决了爆内存导致安装卡死的问题。

## 第一步：准备工作与 SSH 密钥管理

在开始之前，请确保你的本地电脑可以通过 SSH 免密登录目标 VPS 的 root 账户。如果你重用了一个以前使用过的 IP 地址，你的 SSH 客户端会因为主机指纹不匹配而拒绝连接。

**清除旧的 SSH 记录：**

```bash
ssh-keygen -R <你的VPS_IP>
```

_原理解释：_ 此命令会从你本地的 `~/.ssh/known_hosts` 文件中删除与该 IP 绑定的旧密钥指纹，防止出现 `REMOTE HOST IDENTIFICATION HAS CHANGED` 报错。

## 第二步：注入 NixOS 内存系统 (kexec 阶段)

此步骤会将服务器原有的系统（如 Ubuntu）干掉，并在内存 (RAM) 中拉起一个微型的 NixOS Live 环境。

**在本地电脑上执行：**

```bash
nix run github:nix-community/nixos-anywhere -- --phases kexec --flake .#<你的主机名> root@<你的VPS_IP> --no-substitute-on-destination
```

_原理解释：_

- `--phases kexec`：指示工具仅执行内存系统的加载，然后停止，**不会**格式化硬盘。
- `--no-substitute-on-destination`：**低内存机器的救命参数！** 它强制本地电脑承担所有的依赖解析和编译工作，仅将纯二进制文件推送到 VPS。如果不加此参数，VPS 会尝试自己拉取依赖，瞬间导致内存溢出崩溃。
- _注意：_ 命令执行完毕后会自动断开连接，请等待 1-2 分钟，让服务器在内存中重启完成。

## 第三步：SSH 登录并开启 ZRAM 极限扩容

此时服务器已在 NixOS 内存环境中运行，我们需要扩大它的承载能力，以接收接下来庞大的系统文件。

**SSH 连接到服务器：**

```bash
ssh root@<你的VPS_IP>
```

_(如果再次遇到指纹报错，请在本地重新运行 `ssh-keygen -R <你的VPS_IP>`，因为系统已经改变)。_

**在服务器终端中逐行执行以下魔法指令：**

```bash
# 1. 扩容临时挂载点上限
mount -o remount,size=2G /nix/.rw-store

# 2. 挂载并配置 ZRAM 内存压缩模块
modprobe zram
echo zstd > /sys/block/zram0/comp_algorithm
echo 1500M > /sys/block/zram0/disksize

# 3. 初始化并激活 ZRAM 虚拟 Swap
mkswap /dev/zram0
swapon /dev/zram0

# 4. 退出服务器，准备最后的夺舍
exit
```

_原理解释：_ 默认的 `/nix/.rw-store` 只有约 500MB，根本装不下完整的系统闭包。我们强制将其上限调整为 2GB，并利用 ZRAM 技术将 1.5GB 的内存转化为高压缩率的虚拟 Swap。这不仅扩大了存储，还彻底避免了因空间不足导致的 Nix GC 死循环问题。

## 第四步：执行硬盘分区与系统安装

服务器已经武装完毕，现在可以安全地推送完整的系统了。

**回到本地电脑上执行：**

```bash
nix run github:nix-community/nixos-anywhere -- --phases disko,install --flake .#<你的主机名> root@<你的VPS_IP> --no-substitute-on-destination
```

_原理解释：_

- `--phases disko,install`：恢复安装流程。它会先根据你的 `disko` 配置无情地格式化硬盘（例如切分为 BTRFS），然后将本地准备好的纯净系统直接灌入新硬盘中。
- 当终端输出 `### Done! ###` 时，表明系统引导已成功写入，服务器将自动重启进入你全新安装的 NixOS。
