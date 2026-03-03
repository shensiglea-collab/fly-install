---
name: fly-install
description: 当 ClawHub CLI 速率限制或安装失败时，通过 clawhub.ai 网站直接下载 zip 包手动安装技能。提供完整的流程指导和自动化脚本。
---

# Fly Install - ClawHub 备用安装方案

> 当 `clawhub install` 遭遇速率限制时的逃生通道 🚀

## 问题场景

- `npx clawhub install <skill>` 返回 `Rate limit exceeded`
- `clawhub` CLI 无法访问或安装失败
- 急需安装某个技能但官方渠道受阻

## 解决方案

通过 clawhub.ai 网站直接下载技能 zip 包，手动安装到本地 skills 目录。

## 使用方法

### 方式一：全自动脚本（推荐）

```bash
# 使用 fly-install 脚本一键安装
~/.openclaw/workspace/skills/fly-install/fly-install.sh <skill-name>

# 示例
~/.openclaw/workspace/skills/fly-install/fly-install.sh nano-pdf
~/.openclaw/workspace/skills/fly-install/fly-install.sh skill-vetter
```

### 方式二：手动流程

如果不想使用脚本，可以按以下步骤手动操作：

#### 步骤 1: 搜索技能
访问 https://clawhub.ai/skills 搜索你要安装的技能名称

#### 步骤 2: 进入详情页
点击技能卡片进入详情页，确认：
- ✅ 安全扫描状态（VirusTotal + OpenClaw）
- ✅ 作者信息
- ✅ 下载次数和评分

#### 步骤 3: 获取下载链接
在详情页找到 "Download zip" 按钮，复制链接地址

#### 步骤 4: 下载并安装
```bash
cd ~/.openclaw/workspace/skills

# 下载 zip 包（替换为实际的下载链接）
wget -O <skill-name>.zip "<下载链接>"

# 解压到独立文件夹
unzip -q <skill-name>.zip -d <skill-name>

# 删除 zip 包
rm <skill-name>.zip

# 验证安装
ls <skill-name>/SKILL.md
cat <skill-name>/SKILL.md
```

#### 步骤 5: 测试技能
检查技能是否正常加载：
```bash
ls ~/.openclaw/workspace/skills/<skill-name>/
```

## 批量安装

如果需要安装多个技能，可以创建一个列表文件：

```bash
# skills-to-install.txt
nano-pdf
skill-vetter
clawshield
atxp
```

然后运行：
```bash
while read skill; do
  ~/.openclaw/workspace/skills/fly-install/fly-install.sh "$skill"
done < skills-to-install.txt
```

## 注意事项

### 安全提醒 ⚠️
- **只从 clawhub.ai 官方站点下载**
- **安装前检查 VirusTotal 扫描结果**
- **审查 SKILL.md 内容后再使用**
- **不要安装来源不明的技能**

### 与官方 CLI 的区别
| 特性 | clawhub CLI | fly-install |
|------|-------------|-------------|
| 速度 | 可能速率限制 | 直接下载，无限制 |
| 安全验证 | 自动 | 需人工检查 |
| 依赖安装 | 自动 | 需手动安装 |
| 更新检查 | 自动 | 需手动 |

## 故障排除

### 下载失败
```bash
# 如果 wget 失败，尝试 curl
curl -L -o <skill-name>.zip "<下载链接>"
```

### 解压失败
```bash
# 安装 unzip
apt-get install unzip  # Ubuntu/Debian
yum install unzip      # CentOS/RHEL
brew install unzip     # macOS
```

### 技能未识别
确保文件夹名称与技能名称一致，且包含有效的 `SKILL.md` 文件。

## 更新技能

fly-install 安装的 skills 不会自动更新。要更新：

```bash
# 1. 备份旧版本
mv <skill-name> <skill-name>-backup

# 2. 重新下载最新版本
~/.openclaw/workspace/skills/fly-install/fly-install.sh <skill-name>

# 3. 测试新版本正常后删除备份
rm -rf <skill-name>-backup
```

## 相关技能

- `find-skills` - 搜索发现新技能
- `healthcheck` - 检查系统健康状态
- `security-check` - 扫描技能安全性

---

*🦞 大龙虾的逃生通道，CLI 受阻时的救命稻草。*
