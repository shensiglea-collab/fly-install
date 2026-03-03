# Fly Install

当 ClawHub CLI 遭遇速率限制时，通过 zip 下载手动安装技能的备用方案。

## 快速开始

```bash
# 使用脚本安装技能
~/.openclaw/workspace/skills/fly-install/fly-install.sh nano-pdf

# 或手动流程
# 1. 访问 https://clawhub.ai/skills 搜索技能
# 2. 复制 Download zip 链接
# 3. wget + unzip 安装
```

## 安装

```bash
# 克隆到 OpenClaw skills 目录
cd ~/.openclaw/workspace/skills
git clone https://github.com/YOUR_USERNAME/fly-install.git
```

## 使用方法

### 全自动安装
```bash
~/.openclaw/workspace/skills/fly-install/fly-install.sh <skill-name>
```

### 手动安装流程
1. 访问 https://clawhub.ai/skills
2. 搜索并进入技能详情页
3. 点击 "Download zip" 获取链接
4. 下载并解压到 skills 目录

## 安全提示

- ⚠️ 只从 clawhub.ai 官方下载
- ⚠️ 检查 VirusTotal 安全扫描结果
- ⚠️ 审查 SKILL.md 后再使用

## 故障排除

### 下载失败
使用 curl 替代 wget：
```bash
curl -L -o skill.zip "https://..."
```

### 解压失败
```bash
# Ubuntu/Debian
sudo apt-get install unzip

# macOS
brew install unzip
```

## License

MIT
