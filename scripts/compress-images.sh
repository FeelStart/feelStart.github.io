#!/usr/bin/env bash
# 批量压缩 static/images/ 下的图片（使用 macOS 内置 sips）
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
IMAGES_DIR="$REPO_ROOT/hugo/static/images"

if [[ ! -d "$IMAGES_DIR" ]]; then
  echo "目录不存在：$IMAGES_DIR" >&2
  exit 1
fi

# 默认最大宽度 1200px，质量 80
MAX_WIDTH="${1:-1200}"
QUALITY="${2:-80}"

echo "=== 压缩图片 ==="
echo "目录：$IMAGES_DIR"
echo "最大宽度：${MAX_WIDTH}px  质量：${QUALITY}"
echo ""

COUNT=0
SAVED=0

while IFS= read -r -d '' FILE; do
  EXT="${FILE##*.}"
  EXT_LOWER="$(echo "$EXT" | tr '[:upper:]' '[:lower:]')"

  # 只处理 jpg/jpeg/png
  [[ "$EXT_LOWER" == "jpg" || "$EXT_LOWER" == "jpeg" || "$EXT_LOWER" == "png" ]] || continue

  BEFORE="$(stat -f%z "$FILE")"

  if [[ "$EXT_LOWER" == "png" ]]; then
    sips --resampleWidth "$MAX_WIDTH" "$FILE" --out "$FILE" &>/dev/null 2>&1 || true
  else
    sips --resampleWidth "$MAX_WIDTH" -s formatOptions "$QUALITY" "$FILE" --out "$FILE" &>/dev/null 2>&1 || true
  fi

  AFTER="$(stat -f%z "$FILE")"
  DIFF=$(( BEFORE - AFTER ))

  if (( DIFF > 0 )); then
    echo "  压缩：$(basename "$FILE")  $(( BEFORE / 1024 ))KB → $(( AFTER / 1024 ))KB"
    SAVED=$(( SAVED + DIFF ))
  else
    echo "  跳过：$(basename "$FILE")（已是最优）"
  fi

  COUNT=$(( COUNT + 1 ))
done < <(find "$IMAGES_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0)

echo ""
if (( COUNT == 0 )); then
  echo "没有找到图片文件。"
else
  echo "处理 ${COUNT} 张，共节省 $(( SAVED / 1024 )) KB。"
fi
