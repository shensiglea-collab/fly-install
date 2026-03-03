# Fly Install - ClawHub 备用安装方案

> 当 `clawhub install` 遭遇速率限制时的逃生通道 🚀

## 问题场景

- `npx clawhub install <skill>` 返回 `Rate limit exceeded`
- `clawhub` CLI 无法访问或安装失败
- 急需安装某个技能但官方渠道受阻

## 解决方案

通过 clawhub.ai 网站直接下载技能 zip 包，手动安装到本地 skills 目录。

## 使用方法

### 全自动脚本（推荐）

```bash
# 使用 fly-install 脚本一键安装
~/.openclaw/workspace/skills/fly-install/fly-install.sh <skill-name>

# 示例
~/.openclaw/workspace/skills/fly-install/fly-install.sh nano-pdf
~/.openclaw/workspace/skills/fly-install/fly-install.sh skill-vetter
```

### 手动流程

1. **搜索技能**: 访问 https://clawhub.ai/skills 搜索你要安装的技能
2. **进入详情页**: 点击技能卡片，检查安全扫描状态
3. **获取下载链接**: 找到 "Download zip" 按钮，复制链接
4. **下载并安装**:
   ```bash
   cd ~/.openclaw/workspace/skills
   wget -O <skill-name>.zip "<下载链接>"
   unzip -q <skill-name>.zip -d <skill-name>
   rm <skill-name>.zip
   ```
5. **验证安装**: `ls <skill-name>/SKILL.md`

## 安装此技能

```bash
cd ~/.openclaw/workspace/skills
git clone https://github.com/shensiglea-collab/fly-install.git
```

## 安全提示

- ⚠️ **只从 clawhub.ai 官方站点下载**
- ⚠️ **安装前检查 VirusTotal 扫描结果**
- ⚠️ **审查 SKILL.md 内容后再使用**

## 相关技能

- `find-skills` - 搜索发现新技能
- `security-check` - 扫描技能安全性

---

*🦞 大龙虾的逃生通道，CLI 受阻时的救命稻草。*

## GitHub 仓库

https://github.com/shensiglea-collab/fly-install
