# ask - 智能命令行助手

AI 驱动的命令行助手，基于当前 shell 历史智能分析问题并执行命令。

## 安装

### Linux/macOS

```bash
curl -fsSL https://raw.githubusercontent.com/lijiehan72/ask/master/ask -o /usr/local/bin/ask
chmod +x /usr/local/bin/ask
```

### Windows PowerShell

**方法 1：直接使用（推荐）**

```powershell
# 下载脚本（保存为 ask 无扩展名）
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/ask" -OutFile "$env:USERPROFILE\ask"

# 运行
& $env:USERPROFILE\ask -y "查看当前目录"
```

**方法 2：添加到 PATH（永久生效）**

```powershell
# 1. 确保 Python 已安装并添加到 PATH
# 2. 下载脚本到 PATH 目录
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lijiehan72/ask/master/ask" -OutFile "$env:USERPROFILE\AppData\Local\Programs\Python\Python*\ask.exe"

# 3. 或者使用 .py 扩展名并运行
python $env:USERPROFILE\ask.py -y "查看当前目录"
```

## 首次配置

配置文件位置：`$env:USERPROFILE\.ask_setting.json`

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
