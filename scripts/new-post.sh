#!/usr/bin/env bash
# 新建博客文章
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HUGO_DIR="$REPO_ROOT/hugo"

echo "=== 新建文章 ==="
echo ""

# 1. 文章标题
read -r -p "文章标题: " TITLE
if [[ -z "$TITLE" ]]; then
  echo "标题不能为空" >&2
  exit 1
fi

# 2. 文件名（slug）
read -r -p "文件名（英文/拼音，不含 .md，留空则用标题）: " SLUG
if [[ -z "$SLUG" ]]; then
  SLUG="$(echo "$TITLE" | tr ' ' '_' | tr -cd '[:alnum:]_-')"
fi
if [[ -z "$SLUG" ]]; then
  SLUG="post-$(date +%Y%m%d%H%M%S)"
fi

# 3. 子目录
echo ""
echo "子目录："
echo "  1) apple   — Swift / iOS / OC / Bug"
echo "  2) tech    — 工具、媒体、数据库等"
echo "  3) reading — 读书笔记"
echo "  4) life    — 生活、规划、随笔"
read -r -p "选择子目录 [1-4，默认 1]: " DIR_CHOICE
case "$DIR_CHOICE" in
  2) SUBDIR="tech" ;;
  3) SUBDIR="reading" ;;
  4) SUBDIR="life" ;;
  *) SUBDIR="apple" ;;
esac

# 4. 分类（根据子目录自动推断，可覆盖）
case "$SUBDIR" in
  apple|tech) DEFAULT_CAT="技术" ;;
  reading)    DEFAULT_CAT="读书" ;;
  life)       DEFAULT_CAT="生活" ;;
esac
echo ""
echo "分类（默认 ${DEFAULT_CAT}）："
echo "  1) 技术  2) 读书  3) 生活  4) 工具"
read -r -p "选择分类 [1-4，留空用默认]: " CAT_CHOICE
case "$CAT_CHOICE" in
  1) CATEGORY="技术" ;;
  2) CATEGORY="读书" ;;
  3) CATEGORY="生活" ;;
  4) CATEGORY="工具" ;;
  *) CATEGORY="$DEFAULT_CAT" ;;
esac

# 5. 标签（仅技术类）
TAGS="[]"
if [[ "$CATEGORY" == "技术" ]]; then
  echo ""
  echo "标签（最多 2 个，空格分隔，可留空）："
  echo "  可选：Swift  iOS  Objective-C  Bug"
  read -r -p "标签: " TAGS_INPUT
  if [[ -n "$TAGS_INPUT" ]]; then
    TAG_ARRAY=""
    for tag in $TAGS_INPUT; do
      TAG_ARRAY="${TAG_ARRAY}\"${tag}\", "
    done
    TAG_ARRAY="${TAG_ARRAY%, }"
    TAGS="[${TAG_ARRAY}]"
  fi
fi

# 6. 创建文件
FILE_PATH="posts/${SUBDIR}/${SLUG}.md"
FULL_PATH="$HUGO_DIR/content/$FILE_PATH"
TODAY="$(date +%Y-%m-%d)"

mkdir -p "$(dirname "$FULL_PATH")"

cat > "$FULL_PATH" <<EOF
---
title: "${TITLE}"
date: ${TODAY}
categories: ["${CATEGORY}"]
tags: ${TAGS}
---

EOF

echo ""
echo "已创建：hugo/content/${FILE_PATH}"
echo ""

# 7. 打开编辑器
if [[ -n "$EDITOR" ]]; then
  "$EDITOR" "$FULL_PATH"
elif command -v code &>/dev/null; then
  code "$FULL_PATH"
elif command -v open &>/dev/null; then
  open "$FULL_PATH"
fi
