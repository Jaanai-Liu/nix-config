# Bluetooth CLI 教程

## 基础用法

```bash
# 进入交互模式
bluetoothctl

# 在 shell 里执行单条命令
bluetoothctl <command>
```

## 首次配对流程

```bash
# 1. 确保蓝牙开启
bluetoothctl power on

# 2. 开始扫描（保持运行，然后让键盘进入配对模式）
bluetoothctl scan on
# ── K380: 长按 F1/F2/F3（3秒），LED 快闪即进入配对模式 ──
# 看到设备出现后，记下 MAC 地址，Ctrl+C 停止

# 3. 配对
bluetoothctl pair <MAC>

# 4. 连接
bluetoothctl connect <MAC>

# 5. 设为信任（以后自动回连）
bluetoothctl trust <MAC>
```

## 常用管理命令

```bash
bluetoothctl show                  # 查看适配器状态
bluetoothctl devices               # 列出所有已配对设备
bluetoothctl info <MAC>            # 查看设备详情
bluetoothctl disconnect <MAC>      # 断开连接
bluetoothctl connect <MAC>         # 重新连接
bluetoothctl remove <MAC>          # 取消配对
bluetoothctl block <MAC>           # 阻止连接
bluetoothctl unblock <MAC>         # 取消阻止
```

## 交互模式（推荐）

```bash
bluetoothctl         # 进入交互 shell

[bluetooth]# devices           # 列出设备
[bluetooth]# scan on           # 开始扫描
[bluetooth]# scan off          # 停止扫描
[bluetooth]# connect <MAC>     # 连接
[bluetooth]# disconnect <MAC>  # 断开
[bluetooth]# info <MAC>        # 设备信息
[bluetooth]# remove <MAC>      # 删除设备
[bluetooth]# paired-devices    # 已配对设备
[bluetooth]# exit              # 退出
```

## K380 特殊说明

- **切换设备**：K380 有 3 个通道（F1/F2/F3），每个通道可绑定不同设备，短按切换
- **进入配对模式**：长按 F1/F2/F3 3 秒直到 LED 快闪
- **唤醒**：按任意键即可唤醒，键盘自动重连

## 排错

```bash
sudo systemctl restart bluetooth    # 重启蓝牙服务
journalctl -u bluetooth -f          # 查看蓝牙日志
bluetoothctl power off && bluetoothctl power on  # 重置适配器
```
