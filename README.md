# ask - 智能命令行助手

AI 驱动的命令行助手，基于当前 shell 历史智能分析问题并执行命令。

## 安装

### Linux/macOS

```bash
curl -fsSL https://raw.githubusercontent.com/lijiehan72/ask/master/ask -o /usr/local/bin/ask
chmod +x /usr/local/bin/ask
```

### Windows PowerShell

```powershell
# 方法1：一键安装（推荐）
# 下载安装脚本并执行
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/install.ps1" -OutFile "$env:TEMP\install-ask.ps1"
powershell -ExecutionPolicy Bypass -File "$env:TEMP\install-ask.ps1"

# 方法2：手动安装
# 1. 下载安装脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/install.ps1" -OutFile ".\install-ask.ps1"

# 2. 右键点击 install.ps1，选择"使用 PowerShell 运行"
# 或在 PowerShell 中执行: .\install-ask.ps1
```

安装完成后**重启 PowerShell**，然后直接使用：

```powershell
ask -y "查看当前目录"
```

## 首次配置

首次运行会自动创建配置文件，编辑它：

### Linux/macOS

```bash
nano ~/.ask_setting.json
```

### Windows

```powershell
notepad $env:USERPROFILE\.ask_setting.json
```

配置示例：

```json
{
  "base_url": "https://cloud.infini-ai.com/maas/v1",
  "api_key": "你的API密钥",
  "model": "kimi-k2.5"
}
```

## 使用

```bash
# 基本用法（会确认）
ask 安装docker

# 自动执行
ask -y 安装git

# 查看历史
ask --history

# 更新 ask
ask --update
```

## 配置说明

| 字段 | 说明 |
|------|------|
| base_url | API 端点 |
| api_key | API 密钥 |
| model | 使用的模型 |

## 限制说明

⚠️ **重要限制**：

- ask 读取的是 shell 历史文件，只保存**命令**，不保存命令输出
- 如果需要修复错误，**需要把错误信息包含在问题中**

## License

MIT
