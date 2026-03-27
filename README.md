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

## 错误处理场景

ask 会读取 `.bash_history` 中的历史命令，可以帮助你分析和解决错误。

### 场景 1：命令拼写错误

```bash
$ ecoh "hello world"
ecoh: command not found

$ ask 这个报错怎么解决
# 返回: echo "hello world"
```

### 场景 2：权限不足

```bash
$ apt install nginx
E: Could not open lock file /var/lib/dpkg/lock-frontend - open (13: Permission denied)

$ ask 权限不足怎么解决
# 返回: sudo apt install nginx
```

### 场景 3：文件不存在

```bash
$ cat /etc/nginx/nginx.conf
cat: /etc/nginx/nginx.conf: No such file or directory

$ ask 这个文件不存在怎么办
# 返回: sudo apt install nginx 或 ls /etc/nginx/
```

### 场景 4：端口被占用

```bash
$ python3 app.py
OSError: [Errno 98] Address already in use

$ ask 端口被占用怎么解决
# 返回: lsof -ti:8000 | xargs kill -9 或找到占用进程
```

### 场景 5：git 冲突

```bash
$ git push
! [rejected] main -> main (fetch first)
error: failed to push some refs to 'origin'

$ ask git push 被拒绝怎么解决
# 返回: git pull --rebase origin main 然后再 git push
```

### 场景 6：npm/yarn 安装失败

```bash
$ npm install
npm ERR! code EACCES
npm ERR! syscall open
npm ERR! path /usr/lib/node_modules

$ ask npm 安装权限报错
# 返回: sudo chown -R $(whoami) ~/.npm 或使用 nvm
```

### 场景 7：Docker 常见错误

```bash
$ docker run hello-world
docker: permission denied while trying to connect to the Docker daemon socket.

$ ask docker 权限拒绝怎么解决
# 返回: sudo usermod -aG docker $USER 然后重新登录
```

### 场景 8：修复上一条失败的命令

直接在问题中提到"上一个"或"刚才的命令"：

```bash
# 先执行一条会失败的命令
$ unknonwcommand
bash: unknonwcommand: command not found

# 让 ask 帮忙修复
$ ask 修复上一个命令
# 返回: unknowncommand（纠正拼写）
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
