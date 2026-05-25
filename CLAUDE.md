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
scripts/       # 自动化脚本（未来）
hugo/
  content/
    posts/     # 所有文章
    search.md  # 搜索页
    archives.md # 归档页
  static/
    images/    # 图片资源
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
cd hugo
hugo new content posts/文章名.md
```

## 本地预览

```bash
cd hugo
hugo server
```

访问 http://localhost:1313

## 部署

推送到 `master` 分支后 GitHub Actions 自动构建并部署到 GitHub Pages。
