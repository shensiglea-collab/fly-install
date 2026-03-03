#!/bin/bash
# fly-install.sh - ClawHub 备用安装脚本
# 当 clawhub CLI 速率限制时，通过 zip 下载安装技能

set -e

SKILL_NAME="$1"
SKILLS_DIR="${2:-$HOME/.openclaw/workspace/skills}"
CLAWHUB_API="https://wry-manatee-359.convex.site/api/v1/download"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# 显示用法
usage() {
  cat << EOF
Usage: $0 <skill-name> [skills-directory]

Arguments:
  skill-name          要安装的技能名称
  skills-directory    技能安装目录（默认: $HOME/.openclaw/workspace/skills）

Examples:
  $0 nano-pdf
  $0 skill-vetter /custom/skills/path

EOF
}

# 检查参数
if [ -z "$SKILL_NAME" ] || [ "$SKILL_NAME" == "--help" ] || [ "$SKILL_NAME" == "-h" ]; then
  log_error "请提供技能名称"
  usage
  exit 1
fi

# 检查目录是否存在
if [ ! -d "$SKILLS_DIR" ]; then
  log_error "技能目录不存在: $SKILLS_DIR"
  log_info "创建目录..."
  mkdir -p "$SKILLS_DIR"
fi

cd "$SKILLS_DIR"

# 检查是否已安装
if [ -d "$SKILL_NAME" ]; then
  log_warn "技能 '$SKILL_NAME' 已存在"
  read -p "是否覆盖安装? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "取消安装"
    exit 0
  fi
  log_info "备份旧版本..."
  mv "$SKILL_NAME" "${SKILL_NAME}-backup-$(date +%s)"
fi

log_info "开始安装技能: $SKILL_NAME"

# 下载 zip 包
DOWNLOAD_URL="${CLAWHUB_API}?slug=${SKILL_NAME}"
ZIP_FILE="${SKILL_NAME}.zip"

log_info "下载 zip 包..."
if command -v wget &> /dev/null; then
  if ! wget -O "$ZIP_FILE" "$DOWNLOAD_URL" 2>&1 | tail -3; then
    log_error "wget 下载失败，尝试 curl..."
    rm -f "$ZIP_FILE"
    if ! curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL" 2>&1 | tail -3; then
      log_error "下载失败，请检查技能名称是否正确"
      exit 1
    fi
  fi
elif command -v curl &> /dev/null; then
  if ! curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL" 2>&1 | tail -3; then
    log_error "下载失败，请检查技能名称是否正确"
    exit 1
  fi
else
  log_error "需要 wget 或 curl 来下载文件"
  exit 1
fi

# 检查文件大小
FILE_SIZE=$(stat -f%z "$ZIP_FILE" 2>/dev/null || stat -c%s "$ZIP_FILE" 2>/dev/null)
if [ "$FILE_SIZE" -lt 100 ]; then
  log_error "下载的文件太小，可能不存在该技能"
  rm -f "$ZIP_FILE"
  exit 1
fi

log_info "下载完成: $FILE_SIZE 字节"

# 解压
log_info "解压到 $SKILL_NAME/"
if ! unzip -q "$ZIP_FILE" -d "$SKILL_NAME"; then
  log_error "解压失败"
  rm -f "$ZIP_FILE"
  exit 1
fi

# 删除 zip 包
rm -f "$ZIP_FILE"

# 验证安装
if [ ! -f "$SKILL_NAME/SKILL.md" ]; then
  log_error "安装失败: 未找到 SKILL.md"
  rm -rf "$SKILL_NAME"
  exit 1
fi

# 显示技能信息
log_info "安装成功!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 技能名称: $SKILL_NAME"
echo "📁 安装位置: $SKILLS_DIR/$SKILL_NAME"
echo "📄 文件列表:"
ls -la "$SKILL_NAME/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 显示 SKILL.md 头部信息
echo ""
echo "📝 技能描述:"
head -20 "$SKILL_NAME/SKILL.md" | grep -E "^name:|^description:" || head -5 "$SKILL_NAME/SKILL.md"

echo ""
log_info "技能 '$SKILL_NAME' 已准备就绪"
echo "提示: 如果技能需要 CLI 工具，请根据 SKILL.md 中的说明手动安装"
