# 博客规范

## 技术栈

- Hugo 静态站点生成器（v0.161.1）
- PaperMod 主题（git submodule）
- GitHub Pages + GitHub Actions 部署
- 仓库：`git@github.com-feelstart:FeelStart/FeelStart.github.io.git`

## 目录结构

```
.github/
  workflows/
    hugo.yml   # CI/CD
docs/          # 文档、规范（未来）
scripts/
  new-post.sh  # 交互式新建文章
  new-log.sh   # 新建日志条目
  publish.sh   # 一键发布
  compress-images.sh  # 批量压缩图片
hugo/
  content/
    posts/
      apple/   # Swift / iOS / OC / Bug
      tech/    # 工具、媒体、数据库等
      reading/ # 读书笔记
      life/    # 生活、规划、随笔
    logs/      # 日常日志（无需标题，时间戳命名）
    search.md  # 搜索页
    archives.md # 归档页
  static/
    images/
      apple/   # apple 相关图片
      tech/    # 技术相关图片
      reading/ # 读书相关图片
  themes/
    PaperMod/  # 主题 submodule
  hugo.toml    # 站点配置
CLAUDE.md      # AI 工具配置
.gitignore
```

## Front Matter 规范

每篇文章必须包含以下字段：

```yaml
---
title: "文章标题"
date: 2024-01-01
categories: ["技术"]
tags: ["Swift"]
---
```

### Categories（必填，只选一个）

| 分类 | 用途 |
|------|------|
| `技术` | iOS/Swift 开发、编程技术、工具使用 |
| `读书` | 读书笔记、书评 |
| `生活` | 个人生活、规划、随笔 |
| `工具` | 开发工具、效率工具（不在导航菜单，但可用） |

### Tags（可选，最多 2 个）

仅技术类文章使用 tags，其他分类留空 `[]`。

| 标签 | 用途 |
|------|------|
| `Swift` | Swift 语言相关 |
| `iOS` | iOS 平台、UIKit、SwiftUI |
| `Objective-C` | OC 语言相关 |
| `Bug` | Bug 排查与修复记录 |

### 规则

- `categories` 只选一个，用数组格式 `["技术"]`
- `tags` 最多 2 个，非技术文章用 `[]`
- 不使用 `draft: true`（草稿不放入此仓库）
- `date` 格式：`YYYY-MM-DD`

## 新建文章

```bash
./scripts/new-post.sh
```

或手动：

```bash
cd hugo
hugo new content posts/apple/文章名.md   # Swift/iOS/OC/Bug
hugo new content posts/tech/文章名.md    # 工具、媒体等
hugo new content posts/reading/文章名.md # 读书笔记
hugo new content posts/life/文章名.md    # 生活随笔
```

## 新建日志

```bash
./scripts/new-log.sh
```

文件名自动用时间戳（如 `2026-05-25-1430.md`），title 自动填当前日期时间，无需手动填写。日志存放在 `hugo/content/logs/`，分类为 `日志`。

## 本地预览

```bash
cd hugo
hugo server
```

访问 http://localhost:1313

## 部署

推送到 `master` 分支后 GitHub Actions 自动构建并部署到 GitHub Pages。
