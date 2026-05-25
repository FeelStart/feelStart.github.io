#!/usr/bin/env bash
# 发布博客：git add → commit → push
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== 发布博客 ==="
echo ""

# 检查是否有变更
if git diff --quiet && git diff --cached --quiet && [[ -z "$(git ls-files --others --exclude-standard)" ]]; then
  echo "没有需要提交的变更。"
  exit 0
fi

# 显示变更文件
echo "变更文件："
git status --short
echo ""

# commit 信息
read -r -p "提交信息（留空则自动生成）: " MSG
if [[ -z "$MSG" ]]; then
  # 自动生成：列出新增/修改的文章文件名
  NEW_POSTS="$(git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard)"
  POST_NAMES="$(echo "$NEW_POSTS" | grep 'hugo/content/posts/' | xargs -I{} basename {} .md | tr '\n' ', ' | sed 's/, $//')"
  if [[ -n "$POST_NAMES" ]]; then
    MSG="发布文章：${POST_NAMES}"
  else
    MSG="更新博客 $(date +%Y-%m-%d)"
  fi
fi

echo ""
echo "提交信息：$MSG"
echo ""

# 构建校验
echo "构建校验中..."
if ! (cd "$REPO_ROOT/hugo" && hugo --quiet 2>&1); then
  echo ""
  echo "构建失败，已取消发布。请修复后重试。" >&2
  exit 1
fi
echo "构建通过。"
echo ""

git add .
git commit -m "$MSG"
git push

echo ""
echo "已推送，GitHub Actions 将自动部署。"
