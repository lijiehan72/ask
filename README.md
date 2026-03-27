# ask - 智能命令行助手

一个可以对话并执行命令的 AI 助手，会记住当前 shell 的历史上下文。

## 功能特性

- 🤖 基于 AI 分析问题，返回可执行的 shell 命令
- 📜 自动读取 `.bash_history` 获取当前 shell 的历史记录
- ⚙️ 配置文件位于 `~/.ask_setting.json`，修改立即生效
- ✅ 执行前确认，回车直接执行
- 📝 记录每次执行的命令到历史

## 快速开始

### 1. 安装

```bash
# 下载 ask 脚本
curl -fsSL https://raw.githubusercontent.com/你的用户名/ask/main/ask -o /usr/local/bin/ask
chmod +x /usr/local/bin/ask
```

### 2. 首次配置

首次运行会自动创建配置文件：

```bash
ask test
# 会提示配置 ~/.ask_setting.json
```

编辑配置文件：

```bash
nano ~/.ask_setting.json
```

配置示例：

```json
{
  "base_url": "https://cloud.infini-ai.com/maas/v1",
  "api_key": "你的API密钥",
  "model": "kimi-k2.5"
}
```

### 3. 使用

```bash
# 基本用法
ask 如何安装docker?

# 自动执行（跳过确认）
ask -y apt update

# 查看执行历史
ask --history

# 查看帮助
ask --help
```

## 配置说明

| 字段 | 说明 | 示例 |
|------|------|------|
| base_url | API 端点 | `https://cloud.infini-ai.com/maas/v1` |
| api_key | 你的 API 密钥 | `sk-xxx` |
| model | 使用的模型 | `kimi-k2.5` |

### 支持的 API

- 无问芯穹 (Infini-ai)
- 百度千帆
- OpenAI 兼容 API
- Anthropic 兼容 API

### 认证方式

- Bearer Token（默认，用于 OpenAI 兼容格式）
- x-api-key（用于 Anthropic 兼容格式）

## 使用示例

```bash
# 安装软件
ask 安装docker
# 返回: curl -fsSL https://get.docker.com | sh

# 查看文件
ask 查看当前目录
# 返回: ls -la

# 解决问题
ask ecoh command not found 怎么解决
# 返回: echo（纠正拼写错误）

# 聊天（不执行命令）
ask 你好
# 返回: NO_COMMAND: 只是打招呼
```

## 选项

| 选项 | 说明 |
|------|------|
| `-y` | 跳过确认，直接执行 |
| `--history` | 查看执行历史 |
| `--help` | 查看帮助 |

## 工作原理

1. 读取当前 shell 的 `.bash_history` 获取最近 10 条命令
2. 将问题发送给 AI 分析
3. AI 返回可执行的 shell 命令
4. 用户确认后执行命令
5. 记录执行结果到历史

## 文件结构

```
~/.ask_setting.json  # 配置文件
~/.ask_history.json  # 执行历史（自动生成）
```

## License

MIT
