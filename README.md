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
# 1. 下载 Python 脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/ask" -OutFile "$env:USERPROFILE\ask.py"

# 2. 确保已安装 Python，然后在 PowerShell 中运行
python $env:USERPROFILE\ask.py -y "查看当前目录"

# 或者添加到 PATH 后直接运行 ask
```

## 首次配置

首次运行会创建配置文件。

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

# 修复错误（把错误信息包含在问题中）
ask docker: permission denied 怎么解决
```

## 多步骤命令

AI 会返回多行命令，自动依次执行：

```bash
ask -y 安装nginx并启动
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
- 如果需要修复错误，**需要把错误信息包含在问题中**，例如：
  - `ask curl: (35) connection reset 怎么解决`
  - `ask apt: permission denied 如何处理`

## License

MIT
