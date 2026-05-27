---
title: "IGListKit 简介"
date: 2026-05-26
categories: ["技术"]
tags: ["iOS"]
---

[IGListKit](https://github.com/Instagram/IGListKit) 是 Instagram 开源的数据驱动型 UICollectionView 框架，旨在解决复杂列表场景下的性能与可维护性问题。

## 核心价值

- **数据驱动**：通过 diff 算法自动计算数据变化，精准更新 Cell，避免 `reloadData` 带来的全量刷新。
- **良好架构**：每个数据类型对应一个独立的 `ListSectionController`，职责清晰，易于复用和测试。

### 数据驱动

数据驱动的核心思想是：只需操作数据，UI 会自动同步更新。

以删除某一行为例，传统方式需要手动调用 `deleteItems(at:)` 或 `reloadData()`，还要确保数据源与 UI 状态一致，稍有不慎就会触发 crash。IGListKit 封装了这一过程——只需更新数据源并调用 `performUpdates`，框架会通过 diff 算法找出变化，自动执行精准的插入、删除、移动动画，无需手动管理 IndexPath。

### 良好架构

复杂页面往往包含多种异构数据，比如 Banner、商品列表、推荐位混排在同一个 CollectionView 中。传统做法把所有逻辑堆在一个 ViewController 里，随着需求增长很快变得难以维护。

IGListKit 引入 `ListSectionController` 的概念，将每种数据类型的展示逻辑封装成独立的 Controller。每个 SectionController 只关心自己的数据和 Cell，互不干扰，可以单独开发、测试和复用。

## 源码分析

**ListAdapter** 是 IGListKit 的核心枢纽，负责连接原生 `UICollectionView` 与 IGListKit 的数据驱动体系。它持有数据源、管理所有 `SectionController` 的生命周期，并在数据更新时协调 diff 计算与 UI 刷新。